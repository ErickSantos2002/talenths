const mysql = require('mysql2/promise');
const crypto = require('crypto');
const fs = require('fs');
const path = require('path');

// --- Config ---
const MYSQL_CONFIG = {
  host: 'gateway02.us-east-1.prod.aws.tidbcloud.com',
  port: 4000,
  user: '2ViNFbqDmL8xuf6.root',
  password: '6S7b04aMwKXUViY0Vjm6',
  database: 'GVBsRzLnRs6ezzdcr36fSC',
  ssl: { rejectUnauthorized: true },
};

const TEST_MODE = false;
const TEST_COMPANY_NAME = 'Etc & Tal Live Marketing';
const TEST_USER_LIMIT = 2;
const USERS_PER_FILE = 100;

// --- Helpers ---
const uuid = () => crypto.randomUUID();

function esc(val) {
  if (val === null || val === undefined) return 'NULL';
  return "'" + String(val).replace(/'/g, "''") + "'";
}

const escJson = (obj) => esc(JSON.stringify(obj));
const ts = (date) => date ? esc(new Date(date).toISOString()) : 'now()';

function norm(value, min, max) {
  if (max === min) return 50;
  return Math.round(((value - min) / (max - min)) * 100);
}

function header(title, partNum, totalParts) {
  return [
    '-- ============================================',
    `-- Talent-IA Migration - Part ${partNum}/${totalParts}: ${title}`,
    '-- Generated: ' + new Date().toISOString(),
    `-- EXECUTE IN ORDER: Part ${partNum} of ${totalParts}`,
    '-- ============================================',
    '',
  ].join('\n');
}

function writeFile(name, content) {
  const p = path.join(__dirname, name);
  fs.writeFileSync(p, content, 'utf8');
  console.log(`  -> ${name} (${(Buffer.byteLength(content) / 1024).toFixed(0)} KB)`);
}

// --- Main ---
(async () => {
  const conn = await mysql.createConnection(MYSQL_CONFIG);

  // ----- Fetch legacy data -----
  const companyFilter = TEST_MODE ? ` WHERE name = ${esc(TEST_COMPANY_NAME)}` : '';
  const [companies] = await conn.query('SELECT * FROM companies' + companyFilter);
  const companyIds = companies.map((c) => c.id);

  let departments = [];
  if (companyIds.length > 0) {
    const [d] = await conn.query('SELECT * FROM departments WHERE companyId IN (?)', [companyIds]);
    departments = d;
  }

  let users = [];
  if (TEST_MODE) {
    const [u] = await conn.query(`
      SELECT DISTINCT u.* FROM users u
      INNER JOIN testResults tr ON tr.userId = u.id
      WHERE u.companyId IN (?) LIMIT ?
    `, [companyIds, TEST_USER_LIMIT]);
    users = u;
  } else {
    const [u] = await conn.query('SELECT * FROM users WHERE companyId IN (?)', [companyIds]);
    users = u;
  }

  const [allResults] = await conn.query(
    'SELECT discD, discI, discS, discC, discDAdapted, discIAdapted, discSAdapted, discCAdapted, oceanO, oceanC, oceanE, oceanA, oceanN FROM testResults'
  );
  const fields = ['discD','discI','discS','discC','discDAdapted','discIAdapted','discSAdapted','discCAdapted','oceanO','oceanC','oceanE','oceanA','oceanN'];
  const ranges = {};
  for (const f of fields) {
    const vals = allResults.map((r) => r[f]);
    ranges[f] = { min: Math.min(...vals), max: Math.max(...vals) };
  }

  const userIds = users.map((u) => u.id);
  let testResults = [];
  if (userIds.length > 0) {
    const [r] = await conn.query('SELECT * FROM testResults WHERE userId IN (?)', [userIds]);
    testResults = r;
  }

  console.log(`Companies: ${companies.length}, Departments: ${departments.length}, Users: ${users.length}, Results: ${testResults.length}`);

  // Generate UUIDs upfront
  const companyMap = {};
  for (const c of companies) companyMap[c.id] = uuid();

  const deptMap = {};
  for (const d of departments) deptMap[d.id] = uuid();

  const userMap = {};
  for (const u of users) userMap[u.id] = uuid();

  // Calculate number of user batches
  const userBatches = [];
  for (let i = 0; i < users.length; i += USERS_PER_FILE) {
    userBatches.push(users.slice(i, i + USERS_PER_FILE));
  }

  // Total parts: 1 cleanup + 1 companies/depts + N user batches + 1 test results
  const totalParts = 2 + userBatches.length + 1;
  let partNum = 0;

  console.log(`\nGenerating ${totalParts} SQL files...\n`);

  // ===== PART 1: CLEANUP =====
  partNum++;
  const cleanupLines = [];
  cleanupLines.push(header('Cleanup (DELETE existing data)', partNum, totalParts));
  cleanupLines.push('-- Remove existing migrated data before re-importing');
  cleanupLines.push('-- This makes the migration safe to re-run');
  cleanupLines.push('');

  const emails = users.map((u) => esc(u.email)).join(', ');
  cleanupLines.push(`DELETE FROM public.test_results WHERE user_id IN (SELECT id FROM auth.users WHERE email IN (${emails}));`);
  cleanupLines.push(`DELETE FROM public.user_roles WHERE user_id IN (SELECT id FROM auth.users WHERE email IN (${emails}));`);
  cleanupLines.push(`DELETE FROM public.profiles WHERE user_id IN (SELECT id FROM auth.users WHERE email IN (${emails}));`);
  cleanupLines.push(`DELETE FROM auth.identities WHERE user_id IN (SELECT id FROM auth.users WHERE email IN (${emails}));`);
  cleanupLines.push(`DELETE FROM auth.users WHERE email IN (${emails});`);
  cleanupLines.push('');

  for (const c of companies) {
    cleanupLines.push(`DELETE FROM public.departments WHERE company_id IN (SELECT id FROM public.companies WHERE name = ${esc(c.name)});`);
    cleanupLines.push(`DELETE FROM public.companies WHERE name = ${esc(c.name)};`);
  }

  writeFile(`migration-${String(partNum).padStart(2, '0')}-cleanup.sql`, cleanupLines.join('\n'));

  // ===== PART 2: COMPANIES + DEPARTMENTS =====
  partNum++;
  const compDeptLines = [];
  compDeptLines.push(header('Companies + Departments', partNum, totalParts));

  compDeptLines.push('-- ========== COMPANIES ==========');
  for (const c of companies) {
    compDeptLines.push(`INSERT INTO public.companies (id, name, cnpj, status, created_at)`);
    compDeptLines.push(`VALUES (${esc(companyMap[c.id])}, ${esc(c.name)}, ${esc(c.cnpj)}, ${esc(c.status)}, ${ts(c.createdAt)});`);
  }
  compDeptLines.push('');

  compDeptLines.push('-- ========== DEPARTMENTS ==========');
  if (departments.length === 0) compDeptLines.push('-- (none)');
  for (const d of departments) {
    compDeptLines.push(`INSERT INTO public.departments (id, company_id, name, created_at)`);
    compDeptLines.push(`VALUES (${esc(deptMap[d.id])}, ${esc(companyMap[d.companyId])}, ${esc(d.name)}, ${ts(d.createdAt)});`);
  }

  writeFile(`migration-${String(partNum).padStart(2, '0')}-companies-departments.sql`, compDeptLines.join('\n'));

  // ===== PARTS 3..N: USERS (batched) =====
  for (let batchIdx = 0; batchIdx < userBatches.length; batchIdx++) {
    partNum++;
    const batch = userBatches[batchIdx];
    const startIdx = batchIdx * USERS_PER_FILE + 1;
    const endIdx = startIdx + batch.length - 1;

    const userLines = [];
    userLines.push(header(`Users ${startIdx}-${endIdx} (batch ${batchIdx + 1}/${userBatches.length})`, partNum, totalParts));

    for (const u of batch) {
      const uid = userMap[u.id];
      const name = u.name || u.email;
      const compId = companyMap[u.companyId] || null;
      const deptId = deptMap[u.departmentId] || null;

      userLines.push(`-- ${name} (${u.email}) | Role: ${u.role}`);

      // auth.users
      userLines.push(`INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)`);
      userLines.push(`VALUES (${esc(uid)}, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', ${esc(u.email)}, '', ${ts(u.createdAt)}, ${ts(u.createdAt)}, ${ts(u.updatedAt)}, ${escJson({provider:'email',providers:['email']})}, ${escJson({name})}, false, '', '');`);

      // auth.identities
      userLines.push(`INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)`);
      userLines.push(`VALUES (${esc(uuid())}, ${esc(uid)}, ${escJson({sub:uid, email:u.email, email_verified:true})}, 'email', ${esc(uid)}, ${ts(u.createdAt)}, ${ts(u.updatedAt)}, ${ts(u.lastSignedIn)});`);

      // profile (trigger creates it, then we update)
      const profUpdates = [`name = ${esc(name)}`];
      if (u.cpf) profUpdates.push(`cpf = ${esc(u.cpf)}`);
      if (u.phone) profUpdates.push(`phone = ${esc(u.phone)}`);
      if (compId) profUpdates.push(`company_id = ${esc(compId)}`);
      if (deptId) profUpdates.push(`department_id = ${esc(deptId)}`);
      userLines.push(`UPDATE public.profiles SET ${profUpdates.join(', ')} WHERE user_id = ${esc(uid)};`);

      // role
      if (u.role !== 'user') {
        userLines.push(`UPDATE public.user_roles SET role = ${esc(u.role)}::public.app_role, company_id = ${compId ? esc(compId) : 'NULL'} WHERE user_id = ${esc(uid)};`);
      } else if (compId) {
        userLines.push(`UPDATE public.user_roles SET company_id = ${esc(compId)} WHERE user_id = ${esc(uid)};`);
      }
      userLines.push('');
    }

    const batchLabel = userBatches.length === 1 ? 'users' : `users-${batchIdx + 1}`;
    writeFile(`migration-${String(partNum).padStart(2, '0')}-${batchLabel}.sql`, userLines.join('\n'));
  }

  // ===== LAST PART: TEST RESULTS =====
  partNum++;
  const resultLines = [];
  resultLines.push(header('Test Results', partNum, totalParts));

  for (const tr of testResults) {
    const uid = userMap[tr.userId];
    if (!uid) continue;

    const dn = {
      D: norm(tr.discD, ranges.discD.min, ranges.discD.max),
      I: norm(tr.discI, ranges.discI.min, ranges.discI.max),
      S: norm(tr.discS, ranges.discS.min, ranges.discS.max),
      C: norm(tr.discC, ranges.discC.min, ranges.discC.max),
    };
    const da = {
      D: norm(tr.discDAdapted, ranges.discDAdapted.min, ranges.discDAdapted.max),
      I: norm(tr.discIAdapted, ranges.discIAdapted.min, ranges.discIAdapted.max),
      S: norm(tr.discSAdapted, ranges.discSAdapted.min, ranges.discSAdapted.max),
      C: norm(tr.discCAdapted, ranges.discCAdapted.min, ranges.discCAdapted.max),
    };
    const bf = {
      O: norm(tr.oceanO, ranges.oceanO.min, ranges.oceanO.max),
      C: norm(tr.oceanC, ranges.oceanC.min, ranges.oceanC.max),
      E: norm(tr.oceanE, ranges.oceanE.min, ranges.oceanE.max),
      A: norm(tr.oceanA, ranges.oceanA.min, ranges.oceanA.max),
      N: norm(tr.oceanN, ranges.oceanN.min, ranges.oceanN.max),
    };

    const mean = (dn.D + dn.I + dn.S + dn.C) / 4;
    const variance = Math.sqrt(((dn.D-mean)**2 + (dn.I-mean)**2 + (dn.S-mean)**2 + (dn.C-mean)**2) / 4);
    const iem = Math.min(100, Math.round(bf.N * 0.6 + (variance / 50) * 40));
    const userName = users.find((u) => u.id === tr.userId)?.name || tr.userId;

    resultLines.push(`-- ${userName} (${new Date(tr.createdAt).toISOString().slice(0,10)})`);
    resultLines.push(`INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)`);
    resultLines.push(`VALUES (${esc(uuid())}, ${esc(uid)}, ${escJson(dn)}, ${escJson(da)}, ${escJson(bf)}, ${iem}, ${esc(uuid())}, '{}', ${ts(tr.createdAt)});`);
    resultLines.push('');
  }

  resultLines.push(`-- Done! Results: ${testResults.length}`);
  writeFile(`migration-${String(partNum).padStart(2, '0')}-test-results.sql`, resultLines.join('\n'));

  // ===== SUMMARY =====
  console.log(`\nTotal: ${totalParts} files generated.`);
  console.log(`Execute in order: 01 -> ${String(totalParts).padStart(2, '0')}`);
  console.log(`\nData: ${companies.length} companies, ${departments.length} departments, ${users.length} users, ${testResults.length} test results`);

  await conn.end();
})().catch((e) => { console.error('Error:', e); process.exit(1); });
