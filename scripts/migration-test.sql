-- ============================================
-- Talent-IA Migration SQL (safe re-run: cleanup + insert)
-- Generated: 2026-02-13T20:12:25.504Z
-- Mode: TEST (2 users)
-- ============================================

-- ========== CLEANUP ==========
DELETE FROM public.test_results WHERE user_id IN (SELECT id FROM auth.users WHERE email IN ('mayaradias.tur@gmail.com', 'surama@etcetal.com.br'));
DELETE FROM public.user_roles WHERE user_id IN (SELECT id FROM auth.users WHERE email IN ('mayaradias.tur@gmail.com', 'surama@etcetal.com.br'));
DELETE FROM public.profiles WHERE user_id IN (SELECT id FROM auth.users WHERE email IN ('mayaradias.tur@gmail.com', 'surama@etcetal.com.br'));
DELETE FROM auth.identities WHERE user_id IN (SELECT id FROM auth.users WHERE email IN ('mayaradias.tur@gmail.com', 'surama@etcetal.com.br'));
DELETE FROM auth.users WHERE email IN ('mayaradias.tur@gmail.com', 'surama@etcetal.com.br');
DELETE FROM public.departments WHERE company_id IN (SELECT id FROM public.companies WHERE name = 'Etc & Tal Live Marketing');
DELETE FROM public.companies WHERE name = 'Etc & Tal Live Marketing';

-- ========== COMPANIES ==========
INSERT INTO public.companies (id, name, cnpj, status, created_at)
VALUES ('f3568eb2-fcd9-4436-b84c-0b04899986e9', 'Etc & Tal Live Marketing', NULL, 'active', '2026-01-05T16:52:51.000Z');

-- ========== DEPARTMENTS ==========
-- (none)

-- ========== USERS ==========
-- Mayara Dias (mayaradias.tur@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('0ae582e7-04db-4e19-b2e5-1b7907ef1b42', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'mayaradias.tur@gmail.com', '', '2026-01-14T01:20:09.000Z', '2026-01-14T01:20:09.000Z', '2026-01-14T15:05:37.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Mayara Dias"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('1d32fa84-2ed1-47f2-b7b8-a18ea54180e4', '0ae582e7-04db-4e19-b2e5-1b7907ef1b42', '{"sub":"0ae582e7-04db-4e19-b2e5-1b7907ef1b42","email":"mayaradias.tur@gmail.com","email_verified":true}', 'email', '0ae582e7-04db-4e19-b2e5-1b7907ef1b42', '2026-01-14T01:20:09.000Z', '2026-01-14T15:05:37.000Z', '2026-01-14T15:05:37.000Z');
UPDATE public.profiles SET name = 'Mayara Dias', cpf = '13680526652', phone = '31996952207', company_id = 'f3568eb2-fcd9-4436-b84c-0b04899986e9' WHERE user_id = '0ae582e7-04db-4e19-b2e5-1b7907ef1b42';
UPDATE public.user_roles SET company_id = 'f3568eb2-fcd9-4436-b84c-0b04899986e9' WHERE user_id = '0ae582e7-04db-4e19-b2e5-1b7907ef1b42';

-- Surama Carvalho Pereira (surama@etcetal.com.br) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('697741d5-c5cd-4564-95ff-c9769b6ed628', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'surama@etcetal.com.br', '', '2026-01-22T23:13:06.000Z', '2026-01-22T23:13:06.000Z', '2026-01-23T23:11:06.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Surama Carvalho Pereira"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('7f18b406-c3f3-47b8-813d-1e3e31031eaa', '697741d5-c5cd-4564-95ff-c9769b6ed628', '{"sub":"697741d5-c5cd-4564-95ff-c9769b6ed628","email":"surama@etcetal.com.br","email_verified":true}', 'email', '697741d5-c5cd-4564-95ff-c9769b6ed628', '2026-01-22T23:13:06.000Z', '2026-01-23T23:11:06.000Z', '2026-01-23T23:11:07.000Z');
UPDATE public.profiles SET name = 'Surama Carvalho Pereira', cpf = '75818477649', phone = '31991337120', company_id = 'f3568eb2-fcd9-4436-b84c-0b04899986e9' WHERE user_id = '697741d5-c5cd-4564-95ff-c9769b6ed628';
UPDATE public.user_roles SET company_id = 'f3568eb2-fcd9-4436-b84c-0b04899986e9' WHERE user_id = '697741d5-c5cd-4564-95ff-c9769b6ed628';

-- ========== TEST RESULTS ==========
-- Mayara Dias (2026-01-14)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('7b317b62-660d-43c0-9849-c97a57414405', '0ae582e7-04db-4e19-b2e5-1b7907ef1b42', '{"D":80,"I":70,"S":62,"C":63}', '{"D":83,"I":48,"S":20,"C":48}', '{"O":76,"C":77,"E":81,"A":73,"N":54}', 38, '70ecf03a-db7e-42f6-a642-ec6ce3fe9e9b', '{}', '2026-01-14T01:27:31.000Z');

-- Surama Carvalho Pereira (2026-01-23)
INSERT INTO public.test_results (id, user_id, disc_natural, disc_adapted, big_five, iem, share_token, ai_analysis, completed_at)
VALUES ('34337456-406d-4b6e-a36d-a0259f84f8b5', '697741d5-c5cd-4564-95ff-c9769b6ed628', '{"D":30,"I":40,"S":100,"C":100}', '{"D":14,"I":36,"S":77,"C":77}', '{"O":54,"C":95,"E":32,"A":85,"N":92}', 81, '926f54bf-8231-46c0-8652-86d88a5e94ea', '{}', '2026-01-23T23:03:51.000Z');

-- ============================================
-- Done! Companies: 1, Departments: 0, Users: 2, Results: 2
-- ============================================