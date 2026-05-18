-- ============================================
-- Talent-IA Migration - Part 5/8: Users 201-300 (batch 3/5)
-- Generated: 2026-02-13T20:29:31.266Z
-- EXECUTE IN ORDER: Part 5 of 8
-- ============================================

-- Taís Faria (taisfaria1@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('25f704e1-8c13-4510-b646-205eccb8c059', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'taisfaria1@gmail.com', '', '2026-01-24T23:33:29.000Z', '2026-01-24T23:33:29.000Z', '2026-01-24T23:33:31.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Taís Faria"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('18d71b17-42d7-4785-86da-bbeca50d556d', '25f704e1-8c13-4510-b646-205eccb8c059', '{"sub":"25f704e1-8c13-4510-b646-205eccb8c059","email":"taisfaria1@gmail.com","email_verified":true}', 'email', '25f704e1-8c13-4510-b646-205eccb8c059', '2026-01-24T23:33:29.000Z', '2026-01-24T23:33:31.000Z', '2026-01-24T23:33:32.000Z');
UPDATE public.profiles SET name = 'Taís Faria', cpf = '23093787807', phone = '11982365730', company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '25f704e1-8c13-4510-b646-205eccb8c059';
UPDATE public.user_roles SET company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '25f704e1-8c13-4510-b646-205eccb8c059';

-- Rodrigo Alves de Araujo (ronetju@yahoo.com.br) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('e35cc0ca-f90e-4496-971d-f07297e16314', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'ronetju@yahoo.com.br', '', '2026-01-24T23:33:37.000Z', '2026-01-24T23:33:37.000Z', '2026-01-25T19:58:36.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Rodrigo Alves de Araujo"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('ed0f3cf5-52f9-4fd0-80ec-2eaf1d763cc0', 'e35cc0ca-f90e-4496-971d-f07297e16314', '{"sub":"e35cc0ca-f90e-4496-971d-f07297e16314","email":"ronetju@yahoo.com.br","email_verified":true}', 'email', 'e35cc0ca-f90e-4496-971d-f07297e16314', '2026-01-24T23:33:37.000Z', '2026-01-25T19:58:36.000Z', '2026-01-25T19:58:36.000Z');
UPDATE public.profiles SET name = 'Rodrigo Alves de Araujo', cpf = '08131149773', phone = '27997300312', company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = 'e35cc0ca-f90e-4496-971d-f07297e16314';
UPDATE public.user_roles SET company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = 'e35cc0ca-f90e-4496-971d-f07297e16314';

-- lilian ribeiro coelho (lilianc21@yahoo.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('a3e52b80-d7e8-474c-866d-2a1a5b7bf53e', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'lilianc21@yahoo.com', '', '2026-01-24T23:33:41.000Z', '2026-01-24T23:33:41.000Z', '2026-01-24T23:49:38.000Z', '{"provider":"email","providers":["email"]}', '{"name":"lilian ribeiro coelho"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('2a64b592-f19f-4a30-89df-753ae664a704', 'a3e52b80-d7e8-474c-866d-2a1a5b7bf53e', '{"sub":"a3e52b80-d7e8-474c-866d-2a1a5b7bf53e","email":"lilianc21@yahoo.com","email_verified":true}', 'email', 'a3e52b80-d7e8-474c-866d-2a1a5b7bf53e', '2026-01-24T23:33:41.000Z', '2026-01-24T23:49:38.000Z', '2026-01-24T23:49:39.000Z');
UPDATE public.profiles SET name = 'lilian ribeiro coelho', cpf = '73834025704', phone = '21992297693', company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = 'a3e52b80-d7e8-474c-866d-2a1a5b7bf53e';
UPDATE public.user_roles SET company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = 'a3e52b80-d7e8-474c-866d-2a1a5b7bf53e';

-- GETULIO AIRES (getulioairescorretorimoveis@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('43f59463-a080-4f0a-a32d-0a5630cd01f8', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'getulioairescorretorimoveis@gmail.com', '', '2026-01-24T23:33:41.000Z', '2026-01-24T23:33:41.000Z', '2026-01-25T22:11:49.000Z', '{"provider":"email","providers":["email"]}', '{"name":"GETULIO AIRES"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('360752fa-454e-484c-b8e8-7e313c1156bb', '43f59463-a080-4f0a-a32d-0a5630cd01f8', '{"sub":"43f59463-a080-4f0a-a32d-0a5630cd01f8","email":"getulioairescorretorimoveis@gmail.com","email_verified":true}', 'email', '43f59463-a080-4f0a-a32d-0a5630cd01f8', '2026-01-24T23:33:41.000Z', '2026-01-25T22:11:49.000Z', '2026-01-25T22:11:50.000Z');
UPDATE public.profiles SET name = 'GETULIO AIRES', cpf = '26265575104', phone = '62996715383', company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '43f59463-a080-4f0a-a32d-0a5630cd01f8';
UPDATE public.user_roles SET company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '43f59463-a080-4f0a-a32d-0a5630cd01f8';

-- Kimberly Suellen Bueno (kimberly_suellen@hotmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('444ac52a-96cc-4272-b478-81af8a244a05', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'kimberly_suellen@hotmail.com', '', '2026-01-24T23:33:44.000Z', '2026-01-24T23:33:44.000Z', '2026-01-24T23:43:31.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Kimberly Suellen Bueno"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('70a04aa2-be3e-42d5-b375-5537a69a5ceb', '444ac52a-96cc-4272-b478-81af8a244a05', '{"sub":"444ac52a-96cc-4272-b478-81af8a244a05","email":"kimberly_suellen@hotmail.com","email_verified":true}', 'email', '444ac52a-96cc-4272-b478-81af8a244a05', '2026-01-24T23:33:44.000Z', '2026-01-24T23:43:31.000Z', '2026-01-24T23:43:31.000Z');
UPDATE public.profiles SET name = 'Kimberly Suellen Bueno', cpf = '08819414929', phone = '44998331341', company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '444ac52a-96cc-4272-b478-81af8a244a05';
UPDATE public.user_roles SET company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '444ac52a-96cc-4272-b478-81af8a244a05';

-- GISELLE APARECIDA DA SILVA LAGE (giselleas@hotmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('46cb7f3e-23f7-41dc-8524-2195340c3e10', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'giselleas@hotmail.com', '', '2026-01-24T23:33:49.000Z', '2026-01-24T23:33:49.000Z', '2026-01-25T22:50:13.000Z', '{"provider":"email","providers":["email"]}', '{"name":"GISELLE APARECIDA DA SILVA LAGE"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('c3a72f29-4895-47b7-b3ac-c92627f31233', '46cb7f3e-23f7-41dc-8524-2195340c3e10', '{"sub":"46cb7f3e-23f7-41dc-8524-2195340c3e10","email":"giselleas@hotmail.com","email_verified":true}', 'email', '46cb7f3e-23f7-41dc-8524-2195340c3e10', '2026-01-24T23:33:49.000Z', '2026-01-25T22:50:13.000Z', '2026-01-25T22:50:14.000Z');
UPDATE public.profiles SET name = 'GISELLE APARECIDA DA SILVA LAGE', cpf = '28719229852', phone = '11995595867', company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '46cb7f3e-23f7-41dc-8524-2195340c3e10';
UPDATE public.user_roles SET company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '46cb7f3e-23f7-41dc-8524-2195340c3e10';

-- Maurina da silveira  (maurina26mbk@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('81a3473b-652e-47c3-a6b2-ca7d8b155efc', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'maurina26mbk@gmail.com', '', '2026-01-24T23:33:50.000Z', '2026-01-24T23:33:50.000Z', '2026-01-24T23:42:55.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Maurina da silveira "}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('31eee63d-fa59-4d05-a0ca-3a27d86c68aa', '81a3473b-652e-47c3-a6b2-ca7d8b155efc', '{"sub":"81a3473b-652e-47c3-a6b2-ca7d8b155efc","email":"maurina26mbk@gmail.com","email_verified":true}', 'email', '81a3473b-652e-47c3-a6b2-ca7d8b155efc', '2026-01-24T23:33:50.000Z', '2026-01-24T23:42:55.000Z', '2026-01-24T23:42:56.000Z');
UPDATE public.profiles SET name = 'Maurina da silveira ', cpf = '02732713937', phone = '47984081443', company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '81a3473b-652e-47c3-a6b2-ca7d8b155efc';
UPDATE public.user_roles SET company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '81a3473b-652e-47c3-a6b2-ca7d8b155efc';

-- Maria Helena Rocha (helenafcr@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('5d75d25f-f26b-463e-9f99-e27b9d787223', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'helenafcr@gmail.com', '', '2026-01-24T23:33:54.000Z', '2026-01-24T23:33:54.000Z', '2026-01-24T23:40:35.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Maria Helena Rocha"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('387fecec-cd87-4fdb-9f1c-155d288d00d8', '5d75d25f-f26b-463e-9f99-e27b9d787223', '{"sub":"5d75d25f-f26b-463e-9f99-e27b9d787223","email":"helenafcr@gmail.com","email_verified":true}', 'email', '5d75d25f-f26b-463e-9f99-e27b9d787223', '2026-01-24T23:33:54.000Z', '2026-01-24T23:40:35.000Z', '2026-01-24T23:40:35.000Z');
UPDATE public.profiles SET name = 'Maria Helena Rocha', cpf = '06349297636', phone = '31999978050', company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '5d75d25f-f26b-463e-9f99-e27b9d787223';
UPDATE public.user_roles SET company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '5d75d25f-f26b-463e-9f99-e27b9d787223';

-- ALESSANDRA LIMA DOS SANTOS (alle-lima2011@hotmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('edb2c765-08c8-4979-9083-0d53981b49ca', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'alle-lima2011@hotmail.com', '', '2026-01-24T23:33:59.000Z', '2026-01-24T23:33:59.000Z', '2026-01-24T23:35:44.000Z', '{"provider":"email","providers":["email"]}', '{"name":"ALESSANDRA LIMA DOS SANTOS"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('e4b9a28e-70fa-49dc-a693-ef2739d5d00c', 'edb2c765-08c8-4979-9083-0d53981b49ca', '{"sub":"edb2c765-08c8-4979-9083-0d53981b49ca","email":"alle-lima2011@hotmail.com","email_verified":true}', 'email', 'edb2c765-08c8-4979-9083-0d53981b49ca', '2026-01-24T23:33:59.000Z', '2026-01-24T23:35:44.000Z', '2026-01-24T23:35:45.000Z');
UPDATE public.profiles SET name = 'ALESSANDRA LIMA DOS SANTOS', cpf = '02079824902', phone = '41988712614', company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = 'edb2c765-08c8-4979-9083-0d53981b49ca';
UPDATE public.user_roles SET company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = 'edb2c765-08c8-4979-9083-0d53981b49ca';

-- Larissa de Assis  (larissa21_assis@outlook.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('759c3a46-af52-4c15-941b-47b0d4e9a3ac', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'larissa21_assis@outlook.com', '', '2026-01-24T23:34:02.000Z', '2026-01-24T23:34:02.000Z', '2026-01-24T23:35:15.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Larissa de Assis "}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('efb6b685-10ad-42a3-b6f7-a96b7621bafd', '759c3a46-af52-4c15-941b-47b0d4e9a3ac', '{"sub":"759c3a46-af52-4c15-941b-47b0d4e9a3ac","email":"larissa21_assis@outlook.com","email_verified":true}', 'email', '759c3a46-af52-4c15-941b-47b0d4e9a3ac', '2026-01-24T23:34:02.000Z', '2026-01-24T23:35:15.000Z', '2026-01-24T23:35:16.000Z');
UPDATE public.profiles SET name = 'Larissa de Assis ', cpf = '12960652606', phone = '31982310103', company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '759c3a46-af52-4c15-941b-47b0d4e9a3ac';
UPDATE public.user_roles SET company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '759c3a46-af52-4c15-941b-47b0d4e9a3ac';

-- WANDERLEY ALMEIDA DOS REIS JUNIOR (junioalmeida1994@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('6df284be-b363-4b56-851c-409345b44b4b', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'junioalmeida1994@gmail.com', '', '2026-01-24T23:34:04.000Z', '2026-01-24T23:34:04.000Z', '2026-01-25T23:38:47.000Z', '{"provider":"email","providers":["email"]}', '{"name":"WANDERLEY ALMEIDA DOS REIS JUNIOR"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('c69168d9-e868-4789-b3e9-cba39caa29b3', '6df284be-b363-4b56-851c-409345b44b4b', '{"sub":"6df284be-b363-4b56-851c-409345b44b4b","email":"junioalmeida1994@gmail.com","email_verified":true}', 'email', '6df284be-b363-4b56-851c-409345b44b4b', '2026-01-24T23:34:04.000Z', '2026-01-25T23:38:47.000Z', '2026-01-25T23:38:48.000Z');
UPDATE public.profiles SET name = 'WANDERLEY ALMEIDA DOS REIS JUNIOR', cpf = '11976516676', phone = '32998191606', company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '6df284be-b363-4b56-851c-409345b44b4b';
UPDATE public.user_roles SET company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '6df284be-b363-4b56-851c-409345b44b4b';

-- Amanda zahdi pessuti Turossi  (turossizah@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('a0b14aa1-f84a-440f-a887-c0032bb8b065', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'turossizah@gmail.com', '', '2026-01-24T23:34:06.000Z', '2026-01-24T23:34:06.000Z', '2026-01-25T02:26:29.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Amanda zahdi pessuti Turossi "}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('3cf60684-c28e-415f-b719-227680001a0c', 'a0b14aa1-f84a-440f-a887-c0032bb8b065', '{"sub":"a0b14aa1-f84a-440f-a887-c0032bb8b065","email":"turossizah@gmail.com","email_verified":true}', 'email', 'a0b14aa1-f84a-440f-a887-c0032bb8b065', '2026-01-24T23:34:06.000Z', '2026-01-25T02:26:29.000Z', '2026-01-25T02:26:30.000Z');
UPDATE public.profiles SET name = 'Amanda zahdi pessuti Turossi ', cpf = '08920229902', phone = '41997473317', company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = 'a0b14aa1-f84a-440f-a887-c0032bb8b065';
UPDATE public.user_roles SET company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = 'a0b14aa1-f84a-440f-a887-c0032bb8b065';

-- PATRICIA SANTOS ANTAO DA SILVA (patriciaas.antao@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('3adf3c06-6307-470b-9bc9-d37355ef6d99', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'patriciaas.antao@gmail.com', '', '2026-01-24T23:34:19.000Z', '2026-01-24T23:34:19.000Z', '2026-01-24T23:35:08.000Z', '{"provider":"email","providers":["email"]}', '{"name":"PATRICIA SANTOS ANTAO DA SILVA"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('83626da5-7d54-4f60-a2a9-320e65a52859', '3adf3c06-6307-470b-9bc9-d37355ef6d99', '{"sub":"3adf3c06-6307-470b-9bc9-d37355ef6d99","email":"patriciaas.antao@gmail.com","email_verified":true}', 'email', '3adf3c06-6307-470b-9bc9-d37355ef6d99', '2026-01-24T23:34:19.000Z', '2026-01-24T23:35:08.000Z', '2026-01-24T23:35:08.000Z');
UPDATE public.profiles SET name = 'PATRICIA SANTOS ANTAO DA SILVA', cpf = '18299987814', phone = '11996679548', company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '3adf3c06-6307-470b-9bc9-d37355ef6d99';
UPDATE public.user_roles SET company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '3adf3c06-6307-470b-9bc9-d37355ef6d99';

-- ROSELI ROSENDO LIMA DE BENEDITO (rosellirozendo@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('ff0efd83-62a1-4e94-b871-4bf4f6e207c9', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'rosellirozendo@gmail.com', '', '2026-01-24T23:34:19.000Z', '2026-01-24T23:34:19.000Z', '2026-01-24T23:34:23.000Z', '{"provider":"email","providers":["email"]}', '{"name":"ROSELI ROSENDO LIMA DE BENEDITO"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('5c2172bc-1833-4c00-ac2b-b4086bc604aa', 'ff0efd83-62a1-4e94-b871-4bf4f6e207c9', '{"sub":"ff0efd83-62a1-4e94-b871-4bf4f6e207c9","email":"rosellirozendo@gmail.com","email_verified":true}', 'email', 'ff0efd83-62a1-4e94-b871-4bf4f6e207c9', '2026-01-24T23:34:19.000Z', '2026-01-24T23:34:23.000Z', '2026-01-24T23:34:23.000Z');
UPDATE public.profiles SET name = 'ROSELI ROSENDO LIMA DE BENEDITO', cpf = '18644567870', phone = '16991129375', company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = 'ff0efd83-62a1-4e94-b871-4bf4f6e207c9';
UPDATE public.user_roles SET company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = 'ff0efd83-62a1-4e94-b871-4bf4f6e207c9';

-- Juliane cristina gurgel vieira  (juliane.vieira@claro.com.br) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('31527661-9652-4d93-a36e-19f454e802b0', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'juliane.vieira@claro.com.br', '', '2026-01-24T23:34:24.000Z', '2026-01-24T23:34:24.000Z', '2026-01-24T23:35:57.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Juliane cristina gurgel vieira "}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('dc968c5f-73ae-4def-b7b4-48db7e7fce39', '31527661-9652-4d93-a36e-19f454e802b0', '{"sub":"31527661-9652-4d93-a36e-19f454e802b0","email":"juliane.vieira@claro.com.br","email_verified":true}', 'email', '31527661-9652-4d93-a36e-19f454e802b0', '2026-01-24T23:34:24.000Z', '2026-01-24T23:35:57.000Z', '2026-01-24T23:35:58.000Z');
UPDATE public.profiles SET name = 'Juliane cristina gurgel vieira ', cpf = '34452232892', phone = '15991284181', company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '31527661-9652-4d93-a36e-19f454e802b0';
UPDATE public.user_roles SET company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '31527661-9652-4d93-a36e-19f454e802b0';

-- Mariana Ribeiro (mariribeiro14071982@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('6c85fd56-6b1d-41ce-9b38-68f3b49a6f35', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'mariribeiro14071982@gmail.com', '', '2026-01-24T23:34:27.000Z', '2026-01-24T23:34:27.000Z', '2026-01-24T23:34:44.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Mariana Ribeiro"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('ea1e9d65-bd4d-45ed-b9fc-e10e9862e9f9', '6c85fd56-6b1d-41ce-9b38-68f3b49a6f35', '{"sub":"6c85fd56-6b1d-41ce-9b38-68f3b49a6f35","email":"mariribeiro14071982@gmail.com","email_verified":true}', 'email', '6c85fd56-6b1d-41ce-9b38-68f3b49a6f35', '2026-01-24T23:34:27.000Z', '2026-01-24T23:34:44.000Z', '2026-01-24T23:34:44.000Z');
UPDATE public.profiles SET name = 'Mariana Ribeiro', cpf = '29116253825', phone = '16991280437', company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '6c85fd56-6b1d-41ce-9b38-68f3b49a6f35';
UPDATE public.user_roles SET company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '6c85fd56-6b1d-41ce-9b38-68f3b49a6f35';

-- Denilson jose de lima (dennilsonjl@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('b9f4765d-e705-41b4-9099-2992be39b073', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'dennilsonjl@gmail.com', '', '2026-01-24T23:34:27.000Z', '2026-01-24T23:34:27.000Z', '2026-01-25T22:46:50.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Denilson jose de lima"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('2ebed911-1daf-4da6-8ca8-dcc98162bac2', 'b9f4765d-e705-41b4-9099-2992be39b073', '{"sub":"b9f4765d-e705-41b4-9099-2992be39b073","email":"dennilsonjl@gmail.com","email_verified":true}', 'email', 'b9f4765d-e705-41b4-9099-2992be39b073', '2026-01-24T23:34:27.000Z', '2026-01-25T22:46:50.000Z', '2026-01-25T22:46:51.000Z');
UPDATE public.profiles SET name = 'Denilson jose de lima', cpf = '48415480415', phone = '81999090744', company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = 'b9f4765d-e705-41b4-9099-2992be39b073';
UPDATE public.user_roles SET company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = 'b9f4765d-e705-41b4-9099-2992be39b073';

-- Liliane Barbosa da Silva (liliane.soberana@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('c5e8efe5-9f57-4aae-ba67-4d860bbb5053', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'liliane.soberana@gmail.com', '', '2026-01-24T23:34:36.000Z', '2026-01-24T23:34:36.000Z', '2026-02-01T19:49:02.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Liliane Barbosa da Silva"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('c5e32bc6-8559-4cac-a9b3-c04dec36745c', 'c5e8efe5-9f57-4aae-ba67-4d860bbb5053', '{"sub":"c5e8efe5-9f57-4aae-ba67-4d860bbb5053","email":"liliane.soberana@gmail.com","email_verified":true}', 'email', 'c5e8efe5-9f57-4aae-ba67-4d860bbb5053', '2026-01-24T23:34:36.000Z', '2026-02-01T19:49:02.000Z', '2026-02-01T19:49:01.000Z');
UPDATE public.profiles SET name = 'Liliane Barbosa da Silva', cpf = '25917562873', phone = '11957006407', company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = 'c5e8efe5-9f57-4aae-ba67-4d860bbb5053';
UPDATE public.user_roles SET company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = 'c5e8efe5-9f57-4aae-ba67-4d860bbb5053';

-- Isaac Gomes de Oliveira (isaacgomesrdf@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('478ca420-e19d-44d1-a784-b37afd054b74', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'isaacgomesrdf@gmail.com', '', '2026-01-24T23:34:58.000Z', '2026-01-24T23:34:58.000Z', '2026-01-24T23:50:18.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Isaac Gomes de Oliveira"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('f99ebf53-b968-494e-82a6-2933b715f7d8', '478ca420-e19d-44d1-a784-b37afd054b74', '{"sub":"478ca420-e19d-44d1-a784-b37afd054b74","email":"isaacgomesrdf@gmail.com","email_verified":true}', 'email', '478ca420-e19d-44d1-a784-b37afd054b74', '2026-01-24T23:34:58.000Z', '2026-01-24T23:50:18.000Z', '2026-01-24T23:50:18.000Z');
UPDATE public.profiles SET name = 'Isaac Gomes de Oliveira', cpf = '05132691692', phone = '32998137022', company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '478ca420-e19d-44d1-a784-b37afd054b74';
UPDATE public.user_roles SET company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '478ca420-e19d-44d1-a784-b37afd054b74';

-- Rodrigo Fernandes da Silva (RODRIGOFERNANDESCONTABILIDADE@GMAIL.COM) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('c2723208-9da8-4f47-b2c4-7cebb756a43e', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'RODRIGOFERNANDESCONTABILIDADE@GMAIL.COM', '', '2026-01-24T23:35:05.000Z', '2026-01-24T23:35:05.000Z', '2026-02-02T01:14:41.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Rodrigo Fernandes da Silva"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('41a0b212-3ac4-4b58-8b04-cb10628cd755', 'c2723208-9da8-4f47-b2c4-7cebb756a43e', '{"sub":"c2723208-9da8-4f47-b2c4-7cebb756a43e","email":"RODRIGOFERNANDESCONTABILIDADE@GMAIL.COM","email_verified":true}', 'email', 'c2723208-9da8-4f47-b2c4-7cebb756a43e', '2026-01-24T23:35:05.000Z', '2026-02-02T01:14:41.000Z', '2026-02-02T01:14:40.000Z');
UPDATE public.profiles SET name = 'Rodrigo Fernandes da Silva', cpf = '11837083789', phone = '62999998844', company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = 'c2723208-9da8-4f47-b2c4-7cebb756a43e';
UPDATE public.user_roles SET company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = 'c2723208-9da8-4f47-b2c4-7cebb756a43e';

-- Carlos Cerbbinno (carloscerbbinno@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('1c8361e9-3466-401c-ae60-3833ef481cb7', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'carloscerbbinno@gmail.com', '', '2026-01-24T23:35:28.000Z', '2026-01-24T23:35:28.000Z', '2026-02-03T01:19:45.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Carlos Cerbbinno"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('b8eb34f3-1e5e-42ca-9b7a-ac9310d4e8af', '1c8361e9-3466-401c-ae60-3833ef481cb7', '{"sub":"1c8361e9-3466-401c-ae60-3833ef481cb7","email":"carloscerbbinno@gmail.com","email_verified":true}', 'email', '1c8361e9-3466-401c-ae60-3833ef481cb7', '2026-01-24T23:35:28.000Z', '2026-02-03T01:19:45.000Z', '2026-02-03T01:19:45.000Z');
UPDATE public.profiles SET name = 'Carlos Cerbbinno', cpf = '06604957837', phone = '62993969388', company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '1c8361e9-3466-401c-ae60-3833ef481cb7';
UPDATE public.user_roles SET company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '1c8361e9-3466-401c-ae60-3833ef481cb7';

-- ESMIRNA DA COSTA VIANNA (esmirnacv@yahoo.com.br) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('cccb0811-c189-404d-907c-ac6c17e2b664', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'esmirnacv@yahoo.com.br', '', '2026-01-24T23:35:40.000Z', '2026-01-24T23:35:40.000Z', '2026-01-25T04:55:55.000Z', '{"provider":"email","providers":["email"]}', '{"name":"ESMIRNA DA COSTA VIANNA"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('5c74b026-eda2-43d0-aa97-672f37d01574', 'cccb0811-c189-404d-907c-ac6c17e2b664', '{"sub":"cccb0811-c189-404d-907c-ac6c17e2b664","email":"esmirnacv@yahoo.com.br","email_verified":true}', 'email', 'cccb0811-c189-404d-907c-ac6c17e2b664', '2026-01-24T23:35:40.000Z', '2026-01-25T04:55:55.000Z', '2026-01-25T04:55:56.000Z');
UPDATE public.profiles SET name = 'ESMIRNA DA COSTA VIANNA', cpf = '03019723701', phone = '21997214622', company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = 'cccb0811-c189-404d-907c-ac6c17e2b664';
UPDATE public.user_roles SET company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = 'cccb0811-c189-404d-907c-ac6c17e2b664';

-- PATRICIA MARTINS DA SILVA CRUZ (phaty17@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('10c92df0-200c-44db-bd50-adb0cde90daf', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'phaty17@gmail.com', '', '2026-01-24T23:35:43.000Z', '2026-01-24T23:35:43.000Z', '2026-02-02T13:19:56.000Z', '{"provider":"email","providers":["email"]}', '{"name":"PATRICIA MARTINS DA SILVA CRUZ"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('22513338-a00d-4fad-8568-5c725696f392', '10c92df0-200c-44db-bd50-adb0cde90daf', '{"sub":"10c92df0-200c-44db-bd50-adb0cde90daf","email":"phaty17@gmail.com","email_verified":true}', 'email', '10c92df0-200c-44db-bd50-adb0cde90daf', '2026-01-24T23:35:43.000Z', '2026-02-02T13:19:56.000Z', '2026-02-02T13:19:55.000Z');
UPDATE public.profiles SET name = 'PATRICIA MARTINS DA SILVA CRUZ', cpf = '25976858880', phone = '11999511946', company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '10c92df0-200c-44db-bd50-adb0cde90daf';
UPDATE public.user_roles SET company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '10c92df0-200c-44db-bd50-adb0cde90daf';

-- Marcelo Fernandes Franco (marceloffranco@glook.com.br) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('73c67e79-3f46-4e85-84bf-4989cc1f947c', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'marceloffranco@glook.com.br', '', '2026-01-24T23:36:16.000Z', '2026-01-24T23:36:16.000Z', '2026-01-25T00:10:14.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Marcelo Fernandes Franco"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('bc0f84dc-d795-4c6c-8936-f93062c54888', '73c67e79-3f46-4e85-84bf-4989cc1f947c', '{"sub":"73c67e79-3f46-4e85-84bf-4989cc1f947c","email":"marceloffranco@glook.com.br","email_verified":true}', 'email', '73c67e79-3f46-4e85-84bf-4989cc1f947c', '2026-01-24T23:36:16.000Z', '2026-01-25T00:10:14.000Z', '2026-01-25T00:10:14.000Z');
UPDATE public.profiles SET name = 'Marcelo Fernandes Franco', cpf = '16189357806', phone = '11986955090', company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '73c67e79-3f46-4e85-84bf-4989cc1f947c';
UPDATE public.user_roles SET company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '73c67e79-3f46-4e85-84bf-4989cc1f947c';

-- ELIO OLA RIBEIRO (ribeiroola@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('ca961462-e524-4618-bfa0-3104dd661c9e', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'ribeiroola@gmail.com', '', '2026-01-24T23:36:56.000Z', '2026-01-24T23:36:56.000Z', '2026-02-03T14:30:16.000Z', '{"provider":"email","providers":["email"]}', '{"name":"ELIO OLA RIBEIRO"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('554f4123-4ffb-4c34-b128-9e39227e87db', 'ca961462-e524-4618-bfa0-3104dd661c9e', '{"sub":"ca961462-e524-4618-bfa0-3104dd661c9e","email":"ribeiroola@gmail.com","email_verified":true}', 'email', 'ca961462-e524-4618-bfa0-3104dd661c9e', '2026-01-24T23:36:56.000Z', '2026-02-03T14:30:16.000Z', '2026-02-03T14:30:15.000Z');
UPDATE public.profiles SET name = 'ELIO OLA RIBEIRO', cpf = '07855841881', phone = '17997231288', company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = 'ca961462-e524-4618-bfa0-3104dd661c9e';
UPDATE public.user_roles SET company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = 'ca961462-e524-4618-bfa0-3104dd661c9e';

-- Larissa Almeida Silva (larissa.almeida@grupomultilaser.com.br) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('aed30cde-a6cf-460b-a66c-feb7ac78f146', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'larissa.almeida@grupomultilaser.com.br', '', '2026-01-24T23:36:59.000Z', '2026-01-24T23:36:59.000Z', '2026-01-24T23:51:08.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Larissa Almeida Silva"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('9680c839-39a7-45da-831f-138154030603', 'aed30cde-a6cf-460b-a66c-feb7ac78f146', '{"sub":"aed30cde-a6cf-460b-a66c-feb7ac78f146","email":"larissa.almeida@grupomultilaser.com.br","email_verified":true}', 'email', 'aed30cde-a6cf-460b-a66c-feb7ac78f146', '2026-01-24T23:36:59.000Z', '2026-01-24T23:51:08.000Z', '2026-01-24T23:51:09.000Z');
UPDATE public.profiles SET name = 'Larissa Almeida Silva', cpf = '12629031659', phone = '31988638110', company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = 'aed30cde-a6cf-460b-a66c-feb7ac78f146';
UPDATE public.user_roles SET company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = 'aed30cde-a6cf-460b-a66c-feb7ac78f146';

-- Marcela Malloy Dias  (marcela@artesacramoda.com.br) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('c521e8a4-75e5-4e5b-bf0f-42de5a604b8a', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'marcela@artesacramoda.com.br', '', '2026-01-24T23:37:22.000Z', '2026-01-24T23:37:22.000Z', '2026-01-25T00:06:00.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Marcela Malloy Dias "}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('baa31f06-13dd-492d-a998-f117572bff9e', 'c521e8a4-75e5-4e5b-bf0f-42de5a604b8a', '{"sub":"c521e8a4-75e5-4e5b-bf0f-42de5a604b8a","email":"marcela@artesacramoda.com.br","email_verified":true}', 'email', 'c521e8a4-75e5-4e5b-bf0f-42de5a604b8a', '2026-01-24T23:37:22.000Z', '2026-01-25T00:06:00.000Z', '2026-01-25T00:06:00.000Z');
UPDATE public.profiles SET name = 'Marcela Malloy Dias ', cpf = '04540960628', phone = '31986610031', company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = 'c521e8a4-75e5-4e5b-bf0f-42de5a604b8a';
UPDATE public.user_roles SET company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = 'c521e8a4-75e5-4e5b-bf0f-42de5a604b8a';

-- Camila de Mattos Reis  (milamreis@hotmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('a4aad624-f105-4c91-99eb-35238f4702ea', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'milamreis@hotmail.com', '', '2026-01-24T23:37:37.000Z', '2026-01-24T23:37:37.000Z', '2026-01-26T17:31:02.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Camila de Mattos Reis "}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('bae056d4-ec0b-4056-986c-e8174def9891', 'a4aad624-f105-4c91-99eb-35238f4702ea', '{"sub":"a4aad624-f105-4c91-99eb-35238f4702ea","email":"milamreis@hotmail.com","email_verified":true}', 'email', 'a4aad624-f105-4c91-99eb-35238f4702ea', '2026-01-24T23:37:37.000Z', '2026-01-26T17:31:02.000Z', '2026-01-26T17:31:03.000Z');
UPDATE public.profiles SET name = 'Camila de Mattos Reis ', cpf = '10737670606', phone = '31985738116', company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = 'a4aad624-f105-4c91-99eb-35238f4702ea';
UPDATE public.user_roles SET company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = 'a4aad624-f105-4c91-99eb-35238f4702ea';

-- Rafael Freitas (rafaelfarreb@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('de85a300-c1c7-4d81-9ada-e7f1e44e1ef8', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'rafaelfarreb@gmail.com', '', '2026-01-24T23:37:39.000Z', '2026-01-24T23:37:39.000Z', '2026-01-27T02:55:18.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Rafael Freitas"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('c21d7a13-9f5c-4b01-b69c-b4126a195e2f', 'de85a300-c1c7-4d81-9ada-e7f1e44e1ef8', '{"sub":"de85a300-c1c7-4d81-9ada-e7f1e44e1ef8","email":"rafaelfarreb@gmail.com","email_verified":true}', 'email', 'de85a300-c1c7-4d81-9ada-e7f1e44e1ef8', '2026-01-24T23:37:39.000Z', '2026-01-27T02:55:18.000Z', '2026-01-27T02:55:17.000Z');
UPDATE public.profiles SET name = 'Rafael Freitas', cpf = '14715003813', phone = '11981050388', company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = 'de85a300-c1c7-4d81-9ada-e7f1e44e1ef8';
UPDATE public.user_roles SET company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = 'de85a300-c1c7-4d81-9ada-e7f1e44e1ef8';

-- Marcos Del Nero  (marcosdelnero.apps@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('39a76182-711d-4faf-8953-44f546e67c9c', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'marcosdelnero.apps@gmail.com', '', '2026-01-24T23:38:49.000Z', '2026-01-24T23:38:49.000Z', '2026-01-25T20:10:53.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Marcos Del Nero "}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('799a8bc7-e56b-43f6-b2d7-6bd5c1ff7f3b', '39a76182-711d-4faf-8953-44f546e67c9c', '{"sub":"39a76182-711d-4faf-8953-44f546e67c9c","email":"marcosdelnero.apps@gmail.com","email_verified":true}', 'email', '39a76182-711d-4faf-8953-44f546e67c9c', '2026-01-24T23:38:49.000Z', '2026-01-25T20:10:53.000Z', '2026-01-25T20:10:54.000Z');
UPDATE public.profiles SET name = 'Marcos Del Nero ', cpf = '83655654804', phone = '11997879825', company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '39a76182-711d-4faf-8953-44f546e67c9c';
UPDATE public.user_roles SET company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '39a76182-711d-4faf-8953-44f546e67c9c';

-- Debora Oliveira Ramos (or-debora@outlook.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('29f2b496-c0f7-42b8-8578-97f40d319d89', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'or-debora@outlook.com', '', '2026-01-24T23:46:41.000Z', '2026-01-24T23:46:41.000Z', '2026-01-25T04:07:30.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Debora Oliveira Ramos"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('f736129e-5097-47c8-bde9-4e6f20134754', '29f2b496-c0f7-42b8-8578-97f40d319d89', '{"sub":"29f2b496-c0f7-42b8-8578-97f40d319d89","email":"or-debora@outlook.com","email_verified":true}', 'email', '29f2b496-c0f7-42b8-8578-97f40d319d89', '2026-01-24T23:46:41.000Z', '2026-01-25T04:07:30.000Z', '2026-01-25T04:07:30.000Z');
UPDATE public.profiles SET name = 'Debora Oliveira Ramos', cpf = '12486788697', phone = '31975031629', company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '29f2b496-c0f7-42b8-8578-97f40d319d89';
UPDATE public.user_roles SET company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '29f2b496-c0f7-42b8-8578-97f40d319d89';

-- Joao Ricardo Diniz Silva (joaoricardodinizsilva@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('64497958-49f0-47d4-b123-39b529b8c57d', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'joaoricardodinizsilva@gmail.com', '', '2026-01-25T00:05:01.000Z', '2026-01-25T00:05:01.000Z', '2026-01-25T18:45:04.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Joao Ricardo Diniz Silva"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('ef15aeac-ae6a-43b7-94f7-47d82cfb3145', '64497958-49f0-47d4-b123-39b529b8c57d', '{"sub":"64497958-49f0-47d4-b123-39b529b8c57d","email":"joaoricardodinizsilva@gmail.com","email_verified":true}', 'email', '64497958-49f0-47d4-b123-39b529b8c57d', '2026-01-25T00:05:01.000Z', '2026-01-25T18:45:04.000Z', '2026-01-25T18:45:04.000Z');
UPDATE public.profiles SET name = 'Joao Ricardo Diniz Silva', cpf = '10571687695', phone = '31991404322', company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '64497958-49f0-47d4-b123-39b529b8c57d';
UPDATE public.user_roles SET company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '64497958-49f0-47d4-b123-39b529b8c57d';

-- Leandro Machado (leandrotsmachado@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('223b1dc2-b294-4bef-93ff-9d1201c66e67', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'leandrotsmachado@gmail.com', '', '2026-01-25T00:21:37.000Z', '2026-01-25T00:21:37.000Z', '2026-01-25T00:35:46.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Leandro Machado"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('643f203b-1538-42f7-8b69-4251b88a2a26', '223b1dc2-b294-4bef-93ff-9d1201c66e67', '{"sub":"223b1dc2-b294-4bef-93ff-9d1201c66e67","email":"leandrotsmachado@gmail.com","email_verified":true}', 'email', '223b1dc2-b294-4bef-93ff-9d1201c66e67', '2026-01-25T00:21:37.000Z', '2026-01-25T00:35:46.000Z', '2026-01-25T00:35:46.000Z');
UPDATE public.profiles SET name = 'Leandro Machado', cpf = '08085178648', phone = '31986941462', company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '223b1dc2-b294-4bef-93ff-9d1201c66e67';
UPDATE public.user_roles SET company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '223b1dc2-b294-4bef-93ff-9d1201c66e67';

-- Luiza Caldeira Sena Deschamps (luiza.deschamps@hotmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('1f69779b-9f05-4704-ada9-8e6cd582afcd', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'luiza.deschamps@hotmail.com', '', '2026-01-25T00:36:42.000Z', '2026-01-25T00:36:42.000Z', '2026-01-25T00:58:37.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Luiza Caldeira Sena Deschamps"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('161c5de3-cb87-48f3-81ce-38482932dfe8', '1f69779b-9f05-4704-ada9-8e6cd582afcd', '{"sub":"1f69779b-9f05-4704-ada9-8e6cd582afcd","email":"luiza.deschamps@hotmail.com","email_verified":true}', 'email', '1f69779b-9f05-4704-ada9-8e6cd582afcd', '2026-01-25T00:36:42.000Z', '2026-01-25T00:58:37.000Z', '2026-01-25T00:58:37.000Z');
UPDATE public.profiles SET name = 'Luiza Caldeira Sena Deschamps', cpf = '04967325107', phone = '31992041860', company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '1f69779b-9f05-4704-ada9-8e6cd582afcd';
UPDATE public.user_roles SET company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '1f69779b-9f05-4704-ada9-8e6cd582afcd';

-- Brunna Soalheiro Campos  (brunnacampos01@hotmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('825fde01-ba47-49c1-a6b9-2212afa472a6', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'brunnacampos01@hotmail.com', '', '2026-01-25T01:08:16.000Z', '2026-01-25T01:08:16.000Z', '2026-01-25T02:31:23.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Brunna Soalheiro Campos "}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('5f97e942-fe83-4794-bef7-4c98a58fcc86', '825fde01-ba47-49c1-a6b9-2212afa472a6', '{"sub":"825fde01-ba47-49c1-a6b9-2212afa472a6","email":"brunnacampos01@hotmail.com","email_verified":true}', 'email', '825fde01-ba47-49c1-a6b9-2212afa472a6', '2026-01-25T01:08:16.000Z', '2026-01-25T02:31:23.000Z', '2026-01-25T02:31:23.000Z');
UPDATE public.profiles SET name = 'Brunna Soalheiro Campos ', cpf = '11494952602', phone = '31998445927', company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '825fde01-ba47-49c1-a6b9-2212afa472a6';
UPDATE public.user_roles SET company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '825fde01-ba47-49c1-a6b9-2212afa472a6';

-- luciano bueno francsco (buenocurador@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('b7b087a1-cd39-42f9-aa79-1347f36c9540', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'buenocurador@gmail.com', '', '2026-01-25T02:57:40.000Z', '2026-01-25T02:57:40.000Z', '2026-01-27T05:11:56.000Z', '{"provider":"email","providers":["email"]}', '{"name":"luciano bueno francsco"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('d3509e33-e41a-4120-a314-a4697b9efb97', 'b7b087a1-cd39-42f9-aa79-1347f36c9540', '{"sub":"b7b087a1-cd39-42f9-aa79-1347f36c9540","email":"buenocurador@gmail.com","email_verified":true}', 'email', 'b7b087a1-cd39-42f9-aa79-1347f36c9540', '2026-01-25T02:57:40.000Z', '2026-01-27T05:11:56.000Z', '2026-01-27T05:11:55.000Z');
UPDATE public.profiles SET name = 'luciano bueno francsco', cpf = '10975494880', phone = '12981471260', company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = 'b7b087a1-cd39-42f9-aa79-1347f36c9540';
UPDATE public.user_roles SET company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = 'b7b087a1-cd39-42f9-aa79-1347f36c9540';

-- João Vicente Ribeiro Ferreira (joaovicenterf@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('d8183a56-412f-4a2b-8faa-e6a9323ae688', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'joaovicenterf@gmail.com', '', '2026-01-25T14:54:29.000Z', '2026-01-25T14:54:29.000Z', '2026-01-25T23:03:15.000Z', '{"provider":"email","providers":["email"]}', '{"name":"João Vicente Ribeiro Ferreira"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('528090d2-aa6d-4ac7-9148-cbc1943e8fe8', 'd8183a56-412f-4a2b-8faa-e6a9323ae688', '{"sub":"d8183a56-412f-4a2b-8faa-e6a9323ae688","email":"joaovicenterf@gmail.com","email_verified":true}', 'email', 'd8183a56-412f-4a2b-8faa-e6a9323ae688', '2026-01-25T14:54:29.000Z', '2026-01-25T23:03:15.000Z', '2026-01-25T23:03:16.000Z');
UPDATE public.profiles SET name = 'João Vicente Ribeiro Ferreira', cpf = '16177646808', phone = '13996126409', company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = 'd8183a56-412f-4a2b-8faa-e6a9323ae688';
UPDATE public.user_roles SET company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = 'd8183a56-412f-4a2b-8faa-e6a9323ae688';

-- Izabela Dutra (izabela.sdutra@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('db8257f0-acaf-45e9-a942-9103360011b7', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'izabela.sdutra@gmail.com', '', '2026-01-25T15:17:39.000Z', '2026-01-25T15:17:39.000Z', '2026-01-25T15:24:14.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Izabela Dutra"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('7b14f9fe-696e-4917-ac22-239b022fb2ec', 'db8257f0-acaf-45e9-a942-9103360011b7', '{"sub":"db8257f0-acaf-45e9-a942-9103360011b7","email":"izabela.sdutra@gmail.com","email_verified":true}', 'email', 'db8257f0-acaf-45e9-a942-9103360011b7', '2026-01-25T15:17:39.000Z', '2026-01-25T15:24:14.000Z', '2026-01-25T15:24:14.000Z');
UPDATE public.profiles SET name = 'Izabela Dutra', cpf = '09789927681', phone = '31996264311', company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = 'db8257f0-acaf-45e9-a942-9103360011b7';
UPDATE public.user_roles SET company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = 'db8257f0-acaf-45e9-a942-9103360011b7';

-- Alessandra Oliveira (alessandra.cso@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('14107053-63c4-442d-827e-3433a947073c', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'alessandra.cso@gmail.com', '', '2026-01-25T15:18:54.000Z', '2026-01-25T15:18:54.000Z', '2026-01-27T00:48:07.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Alessandra Oliveira"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('db7c5a70-375a-4a70-8f65-b12437d18697', '14107053-63c4-442d-827e-3433a947073c', '{"sub":"14107053-63c4-442d-827e-3433a947073c","email":"alessandra.cso@gmail.com","email_verified":true}', 'email', '14107053-63c4-442d-827e-3433a947073c', '2026-01-25T15:18:54.000Z', '2026-01-27T00:48:07.000Z', '2026-01-27T00:48:06.000Z');
UPDATE public.profiles SET name = 'Alessandra Oliveira', cpf = '30902707817', phone = '11992048999', company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '14107053-63c4-442d-827e-3433a947073c';
UPDATE public.user_roles SET company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '14107053-63c4-442d-827e-3433a947073c';

-- Ana Paula Gibo Segeti (giboanapaula@hotmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('82859e7b-9014-411d-939f-05fd5c88ff6c', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'giboanapaula@hotmail.com', '', '2026-01-25T15:19:00.000Z', '2026-01-25T15:19:00.000Z', '2026-01-26T14:48:12.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Ana Paula Gibo Segeti"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('22bcfe4f-c47d-45c5-a58a-7a3258030eb7', '82859e7b-9014-411d-939f-05fd5c88ff6c', '{"sub":"82859e7b-9014-411d-939f-05fd5c88ff6c","email":"giboanapaula@hotmail.com","email_verified":true}', 'email', '82859e7b-9014-411d-939f-05fd5c88ff6c', '2026-01-25T15:19:00.000Z', '2026-01-26T14:48:12.000Z', '2026-01-26T14:48:12.000Z');
UPDATE public.profiles SET name = 'Ana Paula Gibo Segeti', cpf = '22729609873', phone = '11998049980', company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '82859e7b-9014-411d-939f-05fd5c88ff6c';
UPDATE public.user_roles SET company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '82859e7b-9014-411d-939f-05fd5c88ff6c';

-- GLADYS SYLVIA COSTA TOLEDANO CORREIA LIMA (gladyslimabio@yahoo.com.br) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('5dfe8d5f-7ddc-419d-9b0d-3d9c4b6c6f5d', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'gladyslimabio@yahoo.com.br', '', '2026-01-25T15:20:04.000Z', '2026-01-25T15:20:04.000Z', '2026-01-25T19:07:31.000Z', '{"provider":"email","providers":["email"]}', '{"name":"GLADYS SYLVIA COSTA TOLEDANO CORREIA LIMA"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('db6b933b-f58e-4c81-9d61-cd09e61fe378', '5dfe8d5f-7ddc-419d-9b0d-3d9c4b6c6f5d', '{"sub":"5dfe8d5f-7ddc-419d-9b0d-3d9c4b6c6f5d","email":"gladyslimabio@yahoo.com.br","email_verified":true}', 'email', '5dfe8d5f-7ddc-419d-9b0d-3d9c4b6c6f5d', '2026-01-25T15:20:04.000Z', '2026-01-25T19:07:31.000Z', '2026-01-25T19:07:32.000Z');
UPDATE public.profiles SET name = 'GLADYS SYLVIA COSTA TOLEDANO CORREIA LIMA', cpf = '77520262987', phone = '12997142708', company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '5dfe8d5f-7ddc-419d-9b0d-3d9c4b6c6f5d';
UPDATE public.user_roles SET company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '5dfe8d5f-7ddc-419d-9b0d-3d9c4b6c6f5d';

-- Julieta Nogueira (julietanferreira@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('d61cb6fb-1eb9-45b4-b0a7-b7c261923fa8', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'julietanferreira@gmail.com', '', '2026-01-25T15:20:49.000Z', '2026-01-25T15:20:49.000Z', '2026-01-25T15:21:02.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Julieta Nogueira"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('df397fcc-b1ca-4a17-bf8d-fa7af8510bff', 'd61cb6fb-1eb9-45b4-b0a7-b7c261923fa8', '{"sub":"d61cb6fb-1eb9-45b4-b0a7-b7c261923fa8","email":"julietanferreira@gmail.com","email_verified":true}', 'email', 'd61cb6fb-1eb9-45b4-b0a7-b7c261923fa8', '2026-01-25T15:20:49.000Z', '2026-01-25T15:21:02.000Z', '2026-01-25T15:21:03.000Z');
UPDATE public.profiles SET name = 'Julieta Nogueira', cpf = '07301183801', phone = '11968331442', company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = 'd61cb6fb-1eb9-45b4-b0a7-b7c261923fa8';
UPDATE public.user_roles SET company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = 'd61cb6fb-1eb9-45b4-b0a7-b7c261923fa8';

-- Marianna Rezende Costa (mariannarezende@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('cbf492a5-06a5-450a-a375-3ff37cdd3b08', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'mariannarezende@gmail.com', '', '2026-01-25T15:21:38.000Z', '2026-01-25T15:21:38.000Z', '2026-01-25T23:27:19.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Marianna Rezende Costa"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('0620a6b7-99ac-4275-a32e-4b68a593b334', 'cbf492a5-06a5-450a-a375-3ff37cdd3b08', '{"sub":"cbf492a5-06a5-450a-a375-3ff37cdd3b08","email":"mariannarezende@gmail.com","email_verified":true}', 'email', 'cbf492a5-06a5-450a-a375-3ff37cdd3b08', '2026-01-25T15:21:38.000Z', '2026-01-25T23:27:19.000Z', '2026-01-25T23:27:20.000Z');
UPDATE public.profiles SET name = 'Marianna Rezende Costa', cpf = '04973858641', phone = '64992233242', company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = 'cbf492a5-06a5-450a-a375-3ff37cdd3b08';
UPDATE public.user_roles SET company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = 'cbf492a5-06a5-450a-a375-3ff37cdd3b08';

-- Michelle Aline Pereira do Vale Sanros (mialine_vale@yahoo.com.br) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('e22725c9-0b59-452e-8ab8-b1d34b2ca2e6', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'mialine_vale@yahoo.com.br', '', '2026-01-25T15:21:55.000Z', '2026-01-25T15:21:55.000Z', '2026-01-25T20:10:06.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Michelle Aline Pereira do Vale Sanros"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('07e9d7ee-d6f9-4b3a-bb52-784f00ea348a', 'e22725c9-0b59-452e-8ab8-b1d34b2ca2e6', '{"sub":"e22725c9-0b59-452e-8ab8-b1d34b2ca2e6","email":"mialine_vale@yahoo.com.br","email_verified":true}', 'email', 'e22725c9-0b59-452e-8ab8-b1d34b2ca2e6', '2026-01-25T15:21:55.000Z', '2026-01-25T20:10:06.000Z', '2026-01-25T20:10:07.000Z');
UPDATE public.profiles SET name = 'Michelle Aline Pereira do Vale Sanros', cpf = '07948858610', phone = '31993070320', company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = 'e22725c9-0b59-452e-8ab8-b1d34b2ca2e6';
UPDATE public.user_roles SET company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = 'e22725c9-0b59-452e-8ab8-b1d34b2ca2e6';

-- EDMILSON ROSSI (edmilsonrossi@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('22dffd2f-2b06-4b87-b11f-0310a39b82ab', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'edmilsonrossi@gmail.com', '', '2026-01-25T15:22:19.000Z', '2026-01-25T15:22:19.000Z', '2026-01-25T17:44:49.000Z', '{"provider":"email","providers":["email"]}', '{"name":"EDMILSON ROSSI"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('9141fd3d-378f-4d3d-85d5-782350e6a2f3', '22dffd2f-2b06-4b87-b11f-0310a39b82ab', '{"sub":"22dffd2f-2b06-4b87-b11f-0310a39b82ab","email":"edmilsonrossi@gmail.com","email_verified":true}', 'email', '22dffd2f-2b06-4b87-b11f-0310a39b82ab', '2026-01-25T15:22:19.000Z', '2026-01-25T17:44:49.000Z', '2026-01-25T17:44:50.000Z');
UPDATE public.profiles SET name = 'EDMILSON ROSSI', cpf = '28750504860', phone = '19993095474', company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '22dffd2f-2b06-4b87-b11f-0310a39b82ab';
UPDATE public.user_roles SET company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '22dffd2f-2b06-4b87-b11f-0310a39b82ab';

-- Pedro Márcio Pinto de Oliveira (profpedromarcio@hotmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('c86d5e29-a275-4dfc-a0b5-d12a59936559', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'profpedromarcio@hotmail.com', '', '2026-01-25T15:22:28.000Z', '2026-01-25T15:22:28.000Z', '2026-01-25T16:14:08.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Pedro Márcio Pinto de Oliveira"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('e1426b9e-0f14-4129-a91d-3f41b567da20', 'c86d5e29-a275-4dfc-a0b5-d12a59936559', '{"sub":"c86d5e29-a275-4dfc-a0b5-d12a59936559","email":"profpedromarcio@hotmail.com","email_verified":true}', 'email', 'c86d5e29-a275-4dfc-a0b5-d12a59936559', '2026-01-25T15:22:28.000Z', '2026-01-25T16:14:08.000Z', '2026-01-25T16:14:09.000Z');
UPDATE public.profiles SET name = 'Pedro Márcio Pinto de Oliveira', cpf = '03216503526', phone = '75991104818', company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = 'c86d5e29-a275-4dfc-a0b5-d12a59936559';
UPDATE public.user_roles SET company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = 'c86d5e29-a275-4dfc-a0b5-d12a59936559';

-- HERON GUATIELLO (heronguatiello@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('1fb0e050-f95c-49b6-9eb2-9cfb4bf774b8', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'heronguatiello@gmail.com', '', '2026-01-25T15:28:29.000Z', '2026-01-25T15:28:29.000Z', '2026-02-05T01:33:36.000Z', '{"provider":"email","providers":["email"]}', '{"name":"HERON GUATIELLO"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('57976e8d-3320-4f06-90c3-a4cf9c2e1149', '1fb0e050-f95c-49b6-9eb2-9cfb4bf774b8', '{"sub":"1fb0e050-f95c-49b6-9eb2-9cfb4bf774b8","email":"heronguatiello@gmail.com","email_verified":true}', 'email', '1fb0e050-f95c-49b6-9eb2-9cfb4bf774b8', '2026-01-25T15:28:29.000Z', '2026-02-05T01:33:36.000Z', '2026-02-05T01:33:36.000Z');
UPDATE public.profiles SET name = 'HERON GUATIELLO', cpf = '72749911753', phone = '21971481180', company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '1fb0e050-f95c-49b6-9eb2-9cfb4bf774b8';
UPDATE public.user_roles SET company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '1fb0e050-f95c-49b6-9eb2-9cfb4bf774b8';

-- Alexsandra Matos Teste (alexsandra@dnia.ai) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('8dacfc06-ed81-4878-a0c3-b62aec408abc', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'alexsandra@dnia.ai', '', '2026-01-25T15:30:30.000Z', '2026-01-25T15:30:30.000Z', '2026-01-25T15:34:35.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Alexsandra Matos Teste"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('6f8d2832-6126-4fdd-b51a-1626e5caf842', '8dacfc06-ed81-4878-a0c3-b62aec408abc', '{"sub":"8dacfc06-ed81-4878-a0c3-b62aec408abc","email":"alexsandra@dnia.ai","email_verified":true}', 'email', '8dacfc06-ed81-4878-a0c3-b62aec408abc', '2026-01-25T15:30:30.000Z', '2026-01-25T15:34:35.000Z', '2026-01-25T15:34:35.000Z');
UPDATE public.profiles SET name = 'Alexsandra Matos Teste', cpf = '12657408605', phone = '31991111739', company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '8dacfc06-ed81-4878-a0c3-b62aec408abc';
UPDATE public.user_roles SET company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '8dacfc06-ed81-4878-a0c3-b62aec408abc';

-- Rodrigo (rodrigoferreira077@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('321ca154-e610-42d6-b05d-9dfa04d37532', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'rodrigoferreira077@gmail.com', '', '2026-01-25T15:31:04.000Z', '2026-01-25T15:31:04.000Z', '2026-01-25T19:11:29.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Rodrigo"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('7ba9a2a2-8658-46e3-a4c4-11df029bac49', '321ca154-e610-42d6-b05d-9dfa04d37532', '{"sub":"321ca154-e610-42d6-b05d-9dfa04d37532","email":"rodrigoferreira077@gmail.com","email_verified":true}', 'email', '321ca154-e610-42d6-b05d-9dfa04d37532', '2026-01-25T15:31:04.000Z', '2026-01-25T19:11:29.000Z', '2026-01-25T19:11:30.000Z');
UPDATE public.profiles SET name = 'Rodrigo', cpf = '01855584700', phone = '21988850178', company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '321ca154-e610-42d6-b05d-9dfa04d37532';
UPDATE public.user_roles SET company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '321ca154-e610-42d6-b05d-9dfa04d37532';

-- luiz nichele (lanich2014@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('dae0a35b-8176-49c6-8e07-d58783356114', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'lanich2014@gmail.com', '', '2026-01-25T15:32:07.000Z', '2026-01-25T15:32:07.000Z', '2026-01-26T14:47:39.000Z', '{"provider":"email","providers":["email"]}', '{"name":"luiz nichele"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('6c42f03e-24e6-459d-80be-bf457764d30e', 'dae0a35b-8176-49c6-8e07-d58783356114', '{"sub":"dae0a35b-8176-49c6-8e07-d58783356114","email":"lanich2014@gmail.com","email_verified":true}', 'email', 'dae0a35b-8176-49c6-8e07-d58783356114', '2026-01-25T15:32:07.000Z', '2026-01-26T14:47:39.000Z', '2026-01-26T14:47:39.000Z');
UPDATE public.profiles SET name = 'luiz nichele', cpf = '53597745920', phone = '41999962535', company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = 'dae0a35b-8176-49c6-8e07-d58783356114';
UPDATE public.user_roles SET company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = 'dae0a35b-8176-49c6-8e07-d58783356114';

-- Heitor Francisco Costa Xavier (heitorfrancisco2005@hotmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('e4d54950-21d1-42a2-9fa7-9565518ab09b', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'heitorfrancisco2005@hotmail.com', '', '2026-01-25T15:32:16.000Z', '2026-01-25T15:32:16.000Z', '2026-01-25T15:38:21.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Heitor Francisco Costa Xavier"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('1ae8be79-d4eb-4367-a174-b6bca1d65a2d', 'e4d54950-21d1-42a2-9fa7-9565518ab09b', '{"sub":"e4d54950-21d1-42a2-9fa7-9565518ab09b","email":"heitorfrancisco2005@hotmail.com","email_verified":true}', 'email', 'e4d54950-21d1-42a2-9fa7-9565518ab09b', '2026-01-25T15:32:16.000Z', '2026-01-25T15:38:21.000Z', '2026-01-25T15:38:21.000Z');
UPDATE public.profiles SET name = 'Heitor Francisco Costa Xavier', cpf = '03138920160', phone = '31991666057', company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = 'e4d54950-21d1-42a2-9fa7-9565518ab09b';
UPDATE public.user_roles SET company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = 'e4d54950-21d1-42a2-9fa7-9565518ab09b';

-- Ketlen Machado (ketlenmac@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('776711c2-1e78-4ca2-885d-6e4f3436d044', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'ketlenmac@gmail.com', '', '2026-01-25T15:34:34.000Z', '2026-01-25T15:34:34.000Z', '2026-01-26T16:36:58.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Ketlen Machado"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('acc16c09-1079-4d96-a706-1667d461d2b9', '776711c2-1e78-4ca2-885d-6e4f3436d044', '{"sub":"776711c2-1e78-4ca2-885d-6e4f3436d044","email":"ketlenmac@gmail.com","email_verified":true}', 'email', '776711c2-1e78-4ca2-885d-6e4f3436d044', '2026-01-25T15:34:34.000Z', '2026-01-26T16:36:58.000Z', '2026-01-26T16:36:58.000Z');
UPDATE public.profiles SET name = 'Ketlen Machado', cpf = '39998206839', phone = '47992506634', company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '776711c2-1e78-4ca2-885d-6e4f3436d044';
UPDATE public.user_roles SET company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '776711c2-1e78-4ca2-885d-6e4f3436d044';

-- Marcos Cesar Rodrigues de Oliveira (ttjpopo@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('594980cf-4173-411b-87df-e7dc21d95335', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'ttjpopo@gmail.com', '', '2026-01-25T15:38:35.000Z', '2026-01-25T15:38:35.000Z', '2026-01-25T15:39:10.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Marcos Cesar Rodrigues de Oliveira"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('9550c089-e454-428b-a0e1-f9c80b156d68', '594980cf-4173-411b-87df-e7dc21d95335', '{"sub":"594980cf-4173-411b-87df-e7dc21d95335","email":"ttjpopo@gmail.com","email_verified":true}', 'email', '594980cf-4173-411b-87df-e7dc21d95335', '2026-01-25T15:38:35.000Z', '2026-01-25T15:39:10.000Z', '2026-01-25T15:39:10.000Z');
UPDATE public.profiles SET name = 'Marcos Cesar Rodrigues de Oliveira', cpf = '03231596807', phone = '19988089880', company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '594980cf-4173-411b-87df-e7dc21d95335';
UPDATE public.user_roles SET company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '594980cf-4173-411b-87df-e7dc21d95335';

-- Alaide  (Alaideoliveiralongo@hotmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('a3399150-af65-45e8-97d8-539c111e38cd', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'Alaideoliveiralongo@hotmail.com', '', '2026-01-25T15:43:37.000Z', '2026-01-25T15:43:37.000Z', '2026-01-25T15:46:08.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Alaide "}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('f3884507-0878-4050-b703-62a7621cceea', 'a3399150-af65-45e8-97d8-539c111e38cd', '{"sub":"a3399150-af65-45e8-97d8-539c111e38cd","email":"Alaideoliveiralongo@hotmail.com","email_verified":true}', 'email', 'a3399150-af65-45e8-97d8-539c111e38cd', '2026-01-25T15:43:37.000Z', '2026-01-25T15:46:08.000Z', '2026-01-25T15:46:08.000Z');
UPDATE public.profiles SET name = 'Alaide ', cpf = '14583328885', phone = '14996468503', company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = 'a3399150-af65-45e8-97d8-539c111e38cd';
UPDATE public.user_roles SET company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = 'a3399150-af65-45e8-97d8-539c111e38cd';

-- Barbara Benvenu (barbarabenvenu@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('4b331cc3-64ff-499d-a1d8-919142210ff4', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'barbarabenvenu@gmail.com', '', '2026-01-25T15:49:05.000Z', '2026-01-25T15:49:05.000Z', '2026-01-25T16:20:34.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Barbara Benvenu"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('7f093b41-f91a-4eed-9039-07601fd305ac', '4b331cc3-64ff-499d-a1d8-919142210ff4', '{"sub":"4b331cc3-64ff-499d-a1d8-919142210ff4","email":"barbarabenvenu@gmail.com","email_verified":true}', 'email', '4b331cc3-64ff-499d-a1d8-919142210ff4', '2026-01-25T15:49:05.000Z', '2026-01-25T16:20:34.000Z', '2026-01-25T16:20:35.000Z');
UPDATE public.profiles SET name = 'Barbara Benvenu', cpf = '37315958851', phone = '19989847997', company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '4b331cc3-64ff-499d-a1d8-919142210ff4';
UPDATE public.user_roles SET company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '4b331cc3-64ff-499d-a1d8-919142210ff4';

-- Jane Rodrigues (janecpq76@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('911f51c2-d1b5-4752-b032-366e877e0176', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'janecpq76@gmail.com', '', '2026-01-25T16:17:56.000Z', '2026-01-25T16:17:56.000Z', '2026-02-01T03:29:36.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Jane Rodrigues"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('ae186f8f-8d34-4104-a812-e6c01692f673', '911f51c2-d1b5-4752-b032-366e877e0176', '{"sub":"911f51c2-d1b5-4752-b032-366e877e0176","email":"janecpq76@gmail.com","email_verified":true}', 'email', '911f51c2-d1b5-4752-b032-366e877e0176', '2026-01-25T16:17:56.000Z', '2026-02-01T03:29:36.000Z', '2026-02-01T03:29:36.000Z');
UPDATE public.profiles SET name = 'Jane Rodrigues', cpf = '17891669856', phone = '19981678639', company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '911f51c2-d1b5-4752-b032-366e877e0176';
UPDATE public.user_roles SET company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '911f51c2-d1b5-4752-b032-366e877e0176';

-- Layla Nathânia Teixeira (lalla.nathania@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('ff6b2fdb-079c-4db5-8ea4-305a13dfb19a', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'lalla.nathania@gmail.com', '', '2026-01-25T16:41:40.000Z', '2026-01-25T16:41:40.000Z', '2026-01-25T16:44:34.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Layla Nathânia Teixeira"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('abe919a8-971b-406b-8363-8ede049c35f9', 'ff6b2fdb-079c-4db5-8ea4-305a13dfb19a', '{"sub":"ff6b2fdb-079c-4db5-8ea4-305a13dfb19a","email":"lalla.nathania@gmail.com","email_verified":true}', 'email', 'ff6b2fdb-079c-4db5-8ea4-305a13dfb19a', '2026-01-25T16:41:40.000Z', '2026-01-25T16:44:34.000Z', '2026-01-25T16:44:35.000Z');
UPDATE public.profiles SET name = 'Layla Nathânia Teixeira', cpf = '08409832631', phone = '38999072632', company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = 'ff6b2fdb-079c-4db5-8ea4-305a13dfb19a';
UPDATE public.user_roles SET company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = 'ff6b2fdb-079c-4db5-8ea4-305a13dfb19a';

-- Ana Carla  (mendesana39@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('0dedeeb2-9153-40d0-a3b4-771457ed5a1a', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'mendesana39@gmail.com', '', '2026-01-25T16:42:28.000Z', '2026-01-25T16:42:28.000Z', '2026-01-25T16:47:36.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Ana Carla "}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('a3246e84-77d6-44e3-b909-54dba580b083', '0dedeeb2-9153-40d0-a3b4-771457ed5a1a', '{"sub":"0dedeeb2-9153-40d0-a3b4-771457ed5a1a","email":"mendesana39@gmail.com","email_verified":true}', 'email', '0dedeeb2-9153-40d0-a3b4-771457ed5a1a', '2026-01-25T16:42:28.000Z', '2026-01-25T16:47:36.000Z', '2026-01-25T16:47:36.000Z');
UPDATE public.profiles SET name = 'Ana Carla ', cpf = '09300550370', phone = '81986519653', company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '0dedeeb2-9153-40d0-a3b4-771457ed5a1a';
UPDATE public.user_roles SET company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '0dedeeb2-9153-40d0-a3b4-771457ed5a1a';

-- Julia Bertello (bertellojulia@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('290abab8-b476-4573-ac30-9d4c9925bfa1', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'bertellojulia@gmail.com', '', '2026-01-25T16:46:58.000Z', '2026-01-25T16:46:58.000Z', '2026-01-25T17:18:44.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Julia Bertello"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('bae35472-a4bd-42c7-b1fd-024eddef1ebf', '290abab8-b476-4573-ac30-9d4c9925bfa1', '{"sub":"290abab8-b476-4573-ac30-9d4c9925bfa1","email":"bertellojulia@gmail.com","email_verified":true}', 'email', '290abab8-b476-4573-ac30-9d4c9925bfa1', '2026-01-25T16:46:58.000Z', '2026-01-25T17:18:44.000Z', '2026-01-25T17:18:44.000Z');
UPDATE public.profiles SET name = 'Julia Bertello', cpf = '08609618935', phone = '43998657038', company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '290abab8-b476-4573-ac30-9d4c9925bfa1';
UPDATE public.user_roles SET company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '290abab8-b476-4573-ac30-9d4c9925bfa1';

-- Carolina Malloy Dias (carolina@artesacramoda.com.br) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('218c5a7c-7eb6-40a0-966a-f8c2fba08308', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'carolina@artesacramoda.com.br', '', '2026-01-25T17:50:18.000Z', '2026-01-25T17:50:18.000Z', '2026-01-25T19:50:17.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Carolina Malloy Dias"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('9eb3a2bd-adf1-4b6c-ac48-40528801cc60', '218c5a7c-7eb6-40a0-966a-f8c2fba08308', '{"sub":"218c5a7c-7eb6-40a0-966a-f8c2fba08308","email":"carolina@artesacramoda.com.br","email_verified":true}', 'email', '218c5a7c-7eb6-40a0-966a-f8c2fba08308', '2026-01-25T17:50:18.000Z', '2026-01-25T19:50:17.000Z', '2026-01-25T19:50:17.000Z');
UPDATE public.profiles SET name = 'Carolina Malloy Dias', cpf = '04517965600', phone = '31988029716', company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '218c5a7c-7eb6-40a0-966a-f8c2fba08308';
UPDATE public.user_roles SET company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '218c5a7c-7eb6-40a0-966a-f8c2fba08308';

-- Ivane Ferreira da Silva (reporterivane@yahoo.com.br) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('33f3ecb7-31f5-496b-b1ba-3e28662c0fe9', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'reporterivane@yahoo.com.br', '', '2026-01-25T17:59:22.000Z', '2026-01-25T17:59:22.000Z', '2026-01-25T22:52:36.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Ivane Ferreira da Silva"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('7a38722d-a4c7-4755-92cd-1b4549a77fa8', '33f3ecb7-31f5-496b-b1ba-3e28662c0fe9', '{"sub":"33f3ecb7-31f5-496b-b1ba-3e28662c0fe9","email":"reporterivane@yahoo.com.br","email_verified":true}', 'email', '33f3ecb7-31f5-496b-b1ba-3e28662c0fe9', '2026-01-25T17:59:22.000Z', '2026-01-25T22:52:36.000Z', '2026-01-25T22:52:37.000Z');
UPDATE public.profiles SET name = 'Ivane Ferreira da Silva', cpf = '05603464682', phone = '3798451516', company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '33f3ecb7-31f5-496b-b1ba-3e28662c0fe9';
UPDATE public.user_roles SET company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '33f3ecb7-31f5-496b-b1ba-3e28662c0fe9';

-- Rosr martins (rmartins.2306@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('4641c826-1ae4-43ea-8f46-4ada5e7058b3', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'rmartins.2306@gmail.com', '', '2026-01-25T18:42:21.000Z', '2026-01-25T18:42:21.000Z', '2026-02-01T00:26:40.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Rosr martins"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('8334c567-393b-47c1-9756-e79ade4ce1fa', '4641c826-1ae4-43ea-8f46-4ada5e7058b3', '{"sub":"4641c826-1ae4-43ea-8f46-4ada5e7058b3","email":"rmartins.2306@gmail.com","email_verified":true}', 'email', '4641c826-1ae4-43ea-8f46-4ada5e7058b3', '2026-01-25T18:42:21.000Z', '2026-02-01T00:26:40.000Z', '2026-02-01T00:26:41.000Z');
UPDATE public.profiles SET name = 'Rosr martins', cpf = '04417894809', phone = '11956008186', company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '4641c826-1ae4-43ea-8f46-4ada5e7058b3';
UPDATE public.user_roles SET company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '4641c826-1ae4-43ea-8f46-4ada5e7058b3';

-- MARCELA MARTINS DE OLIVEIRA (marcelalazza@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('0df79488-e46b-4971-a84b-6e0c58fb2545', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'marcelalazza@gmail.com', '', '2026-01-25T19:15:45.000Z', '2026-01-25T19:15:45.000Z', '2026-02-01T22:28:18.000Z', '{"provider":"email","providers":["email"]}', '{"name":"MARCELA MARTINS DE OLIVEIRA"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('49b34784-0649-40d2-841c-8be395c2843d', '0df79488-e46b-4971-a84b-6e0c58fb2545', '{"sub":"0df79488-e46b-4971-a84b-6e0c58fb2545","email":"marcelalazza@gmail.com","email_verified":true}', 'email', '0df79488-e46b-4971-a84b-6e0c58fb2545', '2026-01-25T19:15:45.000Z', '2026-02-01T22:28:18.000Z', '2026-02-01T22:28:19.000Z');
UPDATE public.profiles SET name = 'MARCELA MARTINS DE OLIVEIRA', cpf = '97561924615', phone = '32988216831', company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '0df79488-e46b-4971-a84b-6e0c58fb2545';
UPDATE public.user_roles SET company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '0df79488-e46b-4971-a84b-6e0c58fb2545';

-- carla Tutschke  (carlatutschkeanalistacorporal@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('866ffbb3-53c5-40d1-a3a5-7ea262f334cb', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'carlatutschkeanalistacorporal@gmail.com', '', '2026-01-25T19:51:53.000Z', '2026-01-25T19:51:53.000Z', '2026-01-25T19:52:27.000Z', '{"provider":"email","providers":["email"]}', '{"name":"carla Tutschke "}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('2805c28f-a3f0-4b88-a339-a320d961e579', '866ffbb3-53c5-40d1-a3a5-7ea262f334cb', '{"sub":"866ffbb3-53c5-40d1-a3a5-7ea262f334cb","email":"carlatutschkeanalistacorporal@gmail.com","email_verified":true}', 'email', '866ffbb3-53c5-40d1-a3a5-7ea262f334cb', '2026-01-25T19:51:53.000Z', '2026-01-25T19:52:27.000Z', '2026-01-25T19:52:27.000Z');
UPDATE public.profiles SET name = 'carla Tutschke ', cpf = '05119431992', phone = '41998667758', company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '866ffbb3-53c5-40d1-a3a5-7ea262f334cb';
UPDATE public.user_roles SET company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '866ffbb3-53c5-40d1-a3a5-7ea262f334cb';

-- CARLA MARIANA RODRIGUES DA SILVA (carla.mariana70@hotmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('0a6b2d3f-e7e5-4246-98e5-1ca65ab1f78f', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'carla.mariana70@hotmail.com', '', '2026-01-25T19:51:54.000Z', '2026-01-25T19:51:54.000Z', '2026-01-25T20:08:00.000Z', '{"provider":"email","providers":["email"]}', '{"name":"CARLA MARIANA RODRIGUES DA SILVA"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('af88423c-c33d-46b6-a495-7b681d3b4d1d', '0a6b2d3f-e7e5-4246-98e5-1ca65ab1f78f', '{"sub":"0a6b2d3f-e7e5-4246-98e5-1ca65ab1f78f","email":"carla.mariana70@hotmail.com","email_verified":true}', 'email', '0a6b2d3f-e7e5-4246-98e5-1ca65ab1f78f', '2026-01-25T19:51:54.000Z', '2026-01-25T20:08:00.000Z', '2026-01-25T20:08:01.000Z');
UPDATE public.profiles SET name = 'CARLA MARIANA RODRIGUES DA SILVA', cpf = '34379452204', phone = '92994697428', company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '0a6b2d3f-e7e5-4246-98e5-1ca65ab1f78f';
UPDATE public.user_roles SET company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '0a6b2d3f-e7e5-4246-98e5-1ca65ab1f78f';

-- Larissa de assis germano  (assislarissa2023@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('e17bf3fd-ea0b-4312-84c0-f166474d4bac', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'assislarissa2023@gmail.com', '', '2026-01-25T20:03:08.000Z', '2026-01-25T20:03:08.000Z', '2026-01-25T20:15:34.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Larissa de assis germano "}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('5dec842c-a44a-4bad-adbb-b5038056cdff', 'e17bf3fd-ea0b-4312-84c0-f166474d4bac', '{"sub":"e17bf3fd-ea0b-4312-84c0-f166474d4bac","email":"assislarissa2023@gmail.com","email_verified":true}', 'email', 'e17bf3fd-ea0b-4312-84c0-f166474d4bac', '2026-01-25T20:03:08.000Z', '2026-01-25T20:15:34.000Z', '2026-01-25T20:15:35.000Z');
UPDATE public.profiles SET name = 'Larissa de assis germano ', cpf = '12960652606', phone = '31982310103', company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = 'e17bf3fd-ea0b-4312-84c0-f166474d4bac';
UPDATE public.user_roles SET company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = 'e17bf3fd-ea0b-4312-84c0-f166474d4bac';

-- Paola Cristina Leal Colli (paollacolli@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('6266e127-9ee1-4e3f-9c27-47a247e6c920', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'paollacolli@gmail.com', '', '2026-01-25T20:03:32.000Z', '2026-01-25T20:03:32.000Z', '2026-01-25T20:49:47.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Paola Cristina Leal Colli"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('5e4b1d25-3944-43e1-805a-76edae07fb1b', '6266e127-9ee1-4e3f-9c27-47a247e6c920', '{"sub":"6266e127-9ee1-4e3f-9c27-47a247e6c920","email":"paollacolli@gmail.com","email_verified":true}', 'email', '6266e127-9ee1-4e3f-9c27-47a247e6c920', '2026-01-25T20:03:32.000Z', '2026-01-25T20:49:47.000Z', '2026-01-25T20:49:47.000Z');
UPDATE public.profiles SET name = 'Paola Cristina Leal Colli', cpf = '08048011930', phone = '41995483462', company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '6266e127-9ee1-4e3f-9c27-47a247e6c920';
UPDATE public.user_roles SET company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '6266e127-9ee1-4e3f-9c27-47a247e6c920';

-- Edson Gabriel dos Santos (santogabriel13@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('9c55ff51-53b1-444f-8bea-a356aa45f36a', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'santogabriel13@gmail.com', '', '2026-01-25T20:52:22.000Z', '2026-01-25T20:52:22.000Z', '2026-02-05T04:21:43.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Edson Gabriel dos Santos"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('63568098-7fb1-43bf-9179-076b037a071e', '9c55ff51-53b1-444f-8bea-a356aa45f36a', '{"sub":"9c55ff51-53b1-444f-8bea-a356aa45f36a","email":"santogabriel13@gmail.com","email_verified":true}', 'email', '9c55ff51-53b1-444f-8bea-a356aa45f36a', '2026-01-25T20:52:22.000Z', '2026-02-05T04:21:43.000Z', '2026-02-05T04:21:43.000Z');
UPDATE public.profiles SET name = 'Edson Gabriel dos Santos', cpf = '61536296953', phone = '12997717152', company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '9c55ff51-53b1-444f-8bea-a356aa45f36a';
UPDATE public.user_roles SET company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '9c55ff51-53b1-444f-8bea-a356aa45f36a';

-- Maria Sueli Ribeiro da Silva  (mssuribeiro@yahoo.com.br) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('ef1b86b1-5a13-4ef2-8e93-e0427e44b08d', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'mssuribeiro@yahoo.com.br', '', '2026-01-25T21:29:16.000Z', '2026-01-25T21:29:16.000Z', '2026-01-25T21:49:02.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Maria Sueli Ribeiro da Silva "}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('4d4a6e98-03ce-4671-be2a-351e161b68ef', 'ef1b86b1-5a13-4ef2-8e93-e0427e44b08d', '{"sub":"ef1b86b1-5a13-4ef2-8e93-e0427e44b08d","email":"mssuribeiro@yahoo.com.br","email_verified":true}', 'email', 'ef1b86b1-5a13-4ef2-8e93-e0427e44b08d', '2026-01-25T21:29:16.000Z', '2026-01-25T21:49:02.000Z', '2026-01-25T21:49:03.000Z');
UPDATE public.profiles SET name = 'Maria Sueli Ribeiro da Silva ', cpf = '13340618828', phone = '17991109538', company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = 'ef1b86b1-5a13-4ef2-8e93-e0427e44b08d';
UPDATE public.user_roles SET company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = 'ef1b86b1-5a13-4ef2-8e93-e0427e44b08d';

-- Viviane Noronha (vivi.noronha2009@hotmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('f68b4157-513a-41c5-b3a8-36834e9b7c3a', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'vivi.noronha2009@hotmail.com', '', '2026-01-25T21:51:02.000Z', '2026-01-25T21:51:02.000Z', '2026-01-25T22:15:51.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Viviane Noronha"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('b38278dc-209d-480f-af46-a4b1c0cf0665', 'f68b4157-513a-41c5-b3a8-36834e9b7c3a', '{"sub":"f68b4157-513a-41c5-b3a8-36834e9b7c3a","email":"vivi.noronha2009@hotmail.com","email_verified":true}', 'email', 'f68b4157-513a-41c5-b3a8-36834e9b7c3a', '2026-01-25T21:51:02.000Z', '2026-01-25T22:15:51.000Z', '2026-01-25T22:15:52.000Z');
UPDATE public.profiles SET name = 'Viviane Noronha', cpf = '09526239784', phone = '21998116822', company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = 'f68b4157-513a-41c5-b3a8-36834e9b7c3a';
UPDATE public.user_roles SET company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = 'f68b4157-513a-41c5-b3a8-36834e9b7c3a';

-- Caio França Ricciardi (caiofran746@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('c9938481-153d-4901-8520-2d9d153ed1d4', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'caiofran746@gmail.com', '', '2026-01-25T22:25:26.000Z', '2026-01-25T22:25:26.000Z', '2026-01-25T22:52:23.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Caio França Ricciardi"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('1db0b478-df82-4b4f-ae55-e28cf32a4cda', 'c9938481-153d-4901-8520-2d9d153ed1d4', '{"sub":"c9938481-153d-4901-8520-2d9d153ed1d4","email":"caiofran746@gmail.com","email_verified":true}', 'email', 'c9938481-153d-4901-8520-2d9d153ed1d4', '2026-01-25T22:25:26.000Z', '2026-01-25T22:52:23.000Z', '2026-01-25T22:52:23.000Z');
UPDATE public.profiles SET name = 'Caio França Ricciardi', cpf = '14903004732', phone = '21973993220', company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = 'c9938481-153d-4901-8520-2d9d153ed1d4';
UPDATE public.user_roles SET company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = 'c9938481-153d-4901-8520-2d9d153ed1d4';

-- Carlos Eduardo Montenegro da Silva (caredufisio@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('9c343b5f-819a-4ce7-a75e-181ddebd338c', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'caredufisio@gmail.com', '', '2026-01-25T22:26:24.000Z', '2026-01-25T22:26:24.000Z', '2026-01-25T22:36:31.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Carlos Eduardo Montenegro da Silva"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('f819e30b-cef9-4afc-b0fa-17c1df9b480a', '9c343b5f-819a-4ce7-a75e-181ddebd338c', '{"sub":"9c343b5f-819a-4ce7-a75e-181ddebd338c","email":"caredufisio@gmail.com","email_verified":true}', 'email', '9c343b5f-819a-4ce7-a75e-181ddebd338c', '2026-01-25T22:26:24.000Z', '2026-01-25T22:36:31.000Z', '2026-01-25T22:36:31.000Z');
UPDATE public.profiles SET name = 'Carlos Eduardo Montenegro da Silva', cpf = '04304839705', phone = '21988317432', company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '9c343b5f-819a-4ce7-a75e-181ddebd338c';
UPDATE public.user_roles SET company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '9c343b5f-819a-4ce7-a75e-181ddebd338c';

-- ADRIANA COELHO VIDAL (adrianavidal@flourish.com.br) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('5971540c-90a9-4e1f-b112-2333283c342a', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'adrianavidal@flourish.com.br', '', '2026-01-25T22:51:57.000Z', '2026-01-25T22:51:57.000Z', '2026-01-25T23:04:19.000Z', '{"provider":"email","providers":["email"]}', '{"name":"ADRIANA COELHO VIDAL"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('e2627306-8404-48bf-a4c3-ec6c248f0c46', '5971540c-90a9-4e1f-b112-2333283c342a', '{"sub":"5971540c-90a9-4e1f-b112-2333283c342a","email":"adrianavidal@flourish.com.br","email_verified":true}', 'email', '5971540c-90a9-4e1f-b112-2333283c342a', '2026-01-25T22:51:57.000Z', '2026-01-25T23:04:19.000Z', '2026-01-25T23:04:20.000Z');
UPDATE public.profiles SET name = 'ADRIANA COELHO VIDAL', cpf = '03517001619', phone = '31999792277', company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '5971540c-90a9-4e1f-b112-2333283c342a';
UPDATE public.user_roles SET company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '5971540c-90a9-4e1f-b112-2333283c342a';

-- ROBERTA SETRINI (setrini@uol.com.br) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('45f1c0c1-2c5e-42c4-8f3e-803897d46355', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'setrini@uol.com.br', '', '2026-01-25T22:52:34.000Z', '2026-01-25T22:52:34.000Z', '2026-01-25T23:03:03.000Z', '{"provider":"email","providers":["email"]}', '{"name":"ROBERTA SETRINI"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('ff96c71d-8082-4041-8aaf-87a631364457', '45f1c0c1-2c5e-42c4-8f3e-803897d46355', '{"sub":"45f1c0c1-2c5e-42c4-8f3e-803897d46355","email":"setrini@uol.com.br","email_verified":true}', 'email', '45f1c0c1-2c5e-42c4-8f3e-803897d46355', '2026-01-25T22:52:34.000Z', '2026-01-25T23:03:03.000Z', '2026-01-25T23:03:04.000Z');
UPDATE public.profiles SET name = 'ROBERTA SETRINI', cpf = '02808185723', phone = '5521995497707', company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '45f1c0c1-2c5e-42c4-8f3e-803897d46355';
UPDATE public.user_roles SET company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '45f1c0c1-2c5e-42c4-8f3e-803897d46355';

-- Maria Daniane Moraes Dantas Abicair (danianemd@yahoo.com.br) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('34a7848f-6769-45a9-bcd1-3a946c6fdf45', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'danianemd@yahoo.com.br', '', '2026-01-25T22:53:17.000Z', '2026-01-25T22:53:17.000Z', '2026-02-05T18:01:07.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Maria Daniane Moraes Dantas Abicair"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('6f82adc1-385c-412a-8c7e-93f85d591ebe', '34a7848f-6769-45a9-bcd1-3a946c6fdf45', '{"sub":"34a7848f-6769-45a9-bcd1-3a946c6fdf45","email":"danianemd@yahoo.com.br","email_verified":true}', 'email', '34a7848f-6769-45a9-bcd1-3a946c6fdf45', '2026-01-25T22:53:17.000Z', '2026-02-05T18:01:07.000Z', '2026-02-05T18:01:07.000Z');
UPDATE public.profiles SET name = 'Maria Daniane Moraes Dantas Abicair', cpf = '05822308619', phone = '19983217733', company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '34a7848f-6769-45a9-bcd1-3a946c6fdf45';
UPDATE public.user_roles SET company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '34a7848f-6769-45a9-bcd1-3a946c6fdf45';

-- Claudio Luciano Martire  (cmartire@hotmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('b8038757-a427-4c4d-ba92-2034d6e07028', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'cmartire@hotmail.com', '', '2026-01-25T22:53:48.000Z', '2026-01-25T22:53:48.000Z', '2026-01-26T00:09:38.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Claudio Luciano Martire "}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('a4cf8e7b-4391-4e40-8c4c-f0c0aea81052', 'b8038757-a427-4c4d-ba92-2034d6e07028', '{"sub":"b8038757-a427-4c4d-ba92-2034d6e07028","email":"cmartire@hotmail.com","email_verified":true}', 'email', 'b8038757-a427-4c4d-ba92-2034d6e07028', '2026-01-25T22:53:48.000Z', '2026-01-26T00:09:38.000Z', '2026-01-26T00:09:38.000Z');
UPDATE public.profiles SET name = 'Claudio Luciano Martire ', cpf = '03346319636', phone = '31988594152', company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = 'b8038757-a427-4c4d-ba92-2034d6e07028';
UPDATE public.user_roles SET company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = 'b8038757-a427-4c4d-ba92-2034d6e07028';

-- Izabela Ferreira Loredo (izaloredo.mkt@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('80425018-7512-416b-81b6-a8aefda0132a', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'izaloredo.mkt@gmail.com', '', '2026-01-25T23:04:29.000Z', '2026-01-25T23:04:29.000Z', '2026-01-26T16:26:12.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Izabela Ferreira Loredo"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('c382e364-2a9d-42e0-9f06-206dad129456', '80425018-7512-416b-81b6-a8aefda0132a', '{"sub":"80425018-7512-416b-81b6-a8aefda0132a","email":"izaloredo.mkt@gmail.com","email_verified":true}', 'email', '80425018-7512-416b-81b6-a8aefda0132a', '2026-01-25T23:04:29.000Z', '2026-01-26T16:26:12.000Z', '2026-01-26T16:26:13.000Z');
UPDATE public.profiles SET name = 'Izabela Ferreira Loredo', cpf = '09056759671', phone = '31992525718', company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '80425018-7512-416b-81b6-a8aefda0132a';
UPDATE public.user_roles SET company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '80425018-7512-416b-81b6-a8aefda0132a';

-- Priscila Soares  (priscilasoares02@yahoo.com.br) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('ebf95dd3-e5f6-4d8f-8d1f-8c8161be2a6a', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'priscilasoares02@yahoo.com.br', '', '2026-01-25T23:04:49.000Z', '2026-01-25T23:04:49.000Z', '2026-01-27T17:06:02.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Priscila Soares "}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('343ff022-867d-44e8-b000-5706a88d3324', 'ebf95dd3-e5f6-4d8f-8d1f-8c8161be2a6a', '{"sub":"ebf95dd3-e5f6-4d8f-8d1f-8c8161be2a6a","email":"priscilasoares02@yahoo.com.br","email_verified":true}', 'email', 'ebf95dd3-e5f6-4d8f-8d1f-8c8161be2a6a', '2026-01-25T23:04:49.000Z', '2026-01-27T17:06:02.000Z', '2026-01-27T17:06:03.000Z');
UPDATE public.profiles SET name = 'Priscila Soares ', cpf = '30873192877', phone = '12981378555', company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = 'ebf95dd3-e5f6-4d8f-8d1f-8c8161be2a6a';
UPDATE public.user_roles SET company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = 'ebf95dd3-e5f6-4d8f-8d1f-8c8161be2a6a';

-- Ariane Roberta Santiago Freitas (ariane.santiago0112@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('da01d3d5-e5c9-435e-96bd-94ec745381fb', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'ariane.santiago0112@gmail.com', '', '2026-01-25T23:55:33.000Z', '2026-01-25T23:55:33.000Z', '2026-01-26T23:28:49.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Ariane Roberta Santiago Freitas"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('d2b96aae-4a82-4e0e-9c0f-236ef1f8b798', 'da01d3d5-e5c9-435e-96bd-94ec745381fb', '{"sub":"da01d3d5-e5c9-435e-96bd-94ec745381fb","email":"ariane.santiago0112@gmail.com","email_verified":true}', 'email', 'da01d3d5-e5c9-435e-96bd-94ec745381fb', '2026-01-25T23:55:33.000Z', '2026-01-26T23:28:49.000Z', '2026-01-26T23:28:49.000Z');
UPDATE public.profiles SET name = 'Ariane Roberta Santiago Freitas', cpf = '40040957861', phone = '41995445221', company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = 'da01d3d5-e5c9-435e-96bd-94ec745381fb';
UPDATE public.user_roles SET company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = 'da01d3d5-e5c9-435e-96bd-94ec745381fb';

-- Rafael Victor de Oliveira (rafael6ptc@hotmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('e071da69-4a7d-4a18-8aea-810fc2c24f75', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'rafael6ptc@hotmail.com', '', '2026-01-26T01:50:37.000Z', '2026-01-26T01:50:37.000Z', '2026-01-26T01:58:05.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Rafael Victor de Oliveira"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('592a8aee-2184-43f2-aae2-a74686c964db', 'e071da69-4a7d-4a18-8aea-810fc2c24f75', '{"sub":"e071da69-4a7d-4a18-8aea-810fc2c24f75","email":"rafael6ptc@hotmail.com","email_verified":true}', 'email', 'e071da69-4a7d-4a18-8aea-810fc2c24f75', '2026-01-26T01:50:37.000Z', '2026-01-26T01:58:05.000Z', '2026-01-26T01:58:05.000Z');
UPDATE public.profiles SET name = 'Rafael Victor de Oliveira', cpf = '10484427644', phone = '34988360256', company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = 'e071da69-4a7d-4a18-8aea-810fc2c24f75';
UPDATE public.user_roles SET company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = 'e071da69-4a7d-4a18-8aea-810fc2c24f75';

-- CARLA TUTSCHKE DA SILVA RIBEIRO (mulherrealeza01@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('36d014ec-91e9-4b77-b5b5-1632a64a2ea6', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'mulherrealeza01@gmail.com', '', '2026-01-26T22:58:10.000Z', '2026-01-26T22:58:10.000Z', '2026-01-26T22:58:21.000Z', '{"provider":"email","providers":["email"]}', '{"name":"CARLA TUTSCHKE DA SILVA RIBEIRO"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('38653677-4dc6-4ec9-8b20-1917d826ef14', '36d014ec-91e9-4b77-b5b5-1632a64a2ea6', '{"sub":"36d014ec-91e9-4b77-b5b5-1632a64a2ea6","email":"mulherrealeza01@gmail.com","email_verified":true}', 'email', '36d014ec-91e9-4b77-b5b5-1632a64a2ea6', '2026-01-26T22:58:10.000Z', '2026-01-26T22:58:21.000Z', '2026-01-26T22:58:21.000Z');
UPDATE public.profiles SET name = 'CARLA TUTSCHKE DA SILVA RIBEIRO', cpf = '05119431992', phone = '41998776658', company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '36d014ec-91e9-4b77-b5b5-1632a64a2ea6';
UPDATE public.user_roles SET company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '36d014ec-91e9-4b77-b5b5-1632a64a2ea6';

-- Patrícia do Carmo Rezende Tomé (patriciarezende22@hotmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('61632ff5-835e-4c21-9de7-65f28279cc4f', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'patriciarezende22@hotmail.com', '', '2026-01-27T17:32:12.000Z', '2026-01-27T17:32:12.000Z', '2026-01-30T20:36:54.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Patrícia do Carmo Rezende Tomé"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('1d46958e-c657-4d38-b63a-5ee76e409750', '61632ff5-835e-4c21-9de7-65f28279cc4f', '{"sub":"61632ff5-835e-4c21-9de7-65f28279cc4f","email":"patriciarezende22@hotmail.com","email_verified":true}', 'email', '61632ff5-835e-4c21-9de7-65f28279cc4f', '2026-01-27T17:32:12.000Z', '2026-01-30T20:36:54.000Z', '2026-01-30T20:36:54.000Z');
UPDATE public.profiles SET name = 'Patrícia do Carmo Rezende Tomé', cpf = '07257116636', phone = '12996449509', company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '61632ff5-835e-4c21-9de7-65f28279cc4f';
UPDATE public.user_roles SET company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '61632ff5-835e-4c21-9de7-65f28279cc4f';

-- Anie Karenina (aniekarenina@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('65e1f437-a2db-4f0c-bcc4-a165b9c1081c', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'aniekarenina@gmail.com', '', '2026-01-28T20:10:14.000Z', '2026-01-28T20:10:14.000Z', '2026-01-29T20:16:09.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Anie Karenina"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('1852910b-9766-4c3e-97fb-b7e732562f8f', '65e1f437-a2db-4f0c-bcc4-a165b9c1081c', '{"sub":"65e1f437-a2db-4f0c-bcc4-a165b9c1081c","email":"aniekarenina@gmail.com","email_verified":true}', 'email', '65e1f437-a2db-4f0c-bcc4-a165b9c1081c', '2026-01-28T20:10:14.000Z', '2026-01-29T20:16:09.000Z', '2026-01-29T20:16:09.000Z');
UPDATE public.profiles SET name = 'Anie Karenina', cpf = '07554595636', phone = '31984958570', company_id = 'e7e206de-3ae7-46a9-a48a-4ae882ee2a18' WHERE user_id = '65e1f437-a2db-4f0c-bcc4-a165b9c1081c';
UPDATE public.user_roles SET company_id = 'e7e206de-3ae7-46a9-a48a-4ae882ee2a18' WHERE user_id = '65e1f437-a2db-4f0c-bcc4-a165b9c1081c';

-- Esley Castelar Rodrigues (esleycastelar@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('edc4814c-4f61-4b63-9832-380e844b4598', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'esleycastelar@gmail.com', '', '2026-01-28T20:54:57.000Z', '2026-01-28T20:54:57.000Z', '2026-01-29T21:31:02.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Esley Castelar Rodrigues"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('6d8b89fd-6cc3-4401-975d-e66c83ded7a9', 'edc4814c-4f61-4b63-9832-380e844b4598', '{"sub":"edc4814c-4f61-4b63-9832-380e844b4598","email":"esleycastelar@gmail.com","email_verified":true}', 'email', 'edc4814c-4f61-4b63-9832-380e844b4598', '2026-01-28T20:54:57.000Z', '2026-01-29T21:31:02.000Z', '2026-01-29T21:31:02.000Z');
UPDATE public.profiles SET name = 'Esley Castelar Rodrigues', cpf = '04132055680', phone = '31992704326', company_id = 'e7e206de-3ae7-46a9-a48a-4ae882ee2a18', department_id = '84c8872a-1b34-4a62-979a-183b7b80a529' WHERE user_id = 'edc4814c-4f61-4b63-9832-380e844b4598';
UPDATE public.user_roles SET company_id = 'e7e206de-3ae7-46a9-a48a-4ae882ee2a18' WHERE user_id = 'edc4814c-4f61-4b63-9832-380e844b4598';

-- FRANKY LUCIO VALERIO BARBOSA (frankybarbosa56@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('db1a2c68-df7b-4e80-a44d-63d9d4d06363', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'frankybarbosa56@gmail.com', '', '2026-01-28T23:07:21.000Z', '2026-01-28T23:07:21.000Z', '2026-01-29T00:50:09.000Z', '{"provider":"email","providers":["email"]}', '{"name":"FRANKY LUCIO VALERIO BARBOSA"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('072ac820-cfe8-4591-bf20-7020cff99fd4', 'db1a2c68-df7b-4e80-a44d-63d9d4d06363', '{"sub":"db1a2c68-df7b-4e80-a44d-63d9d4d06363","email":"frankybarbosa56@gmail.com","email_verified":true}', 'email', 'db1a2c68-df7b-4e80-a44d-63d9d4d06363', '2026-01-28T23:07:21.000Z', '2026-01-29T00:50:09.000Z', '2026-01-29T00:50:10.000Z');
UPDATE public.profiles SET name = 'FRANKY LUCIO VALERIO BARBOSA', cpf = '13111814661', phone = '31992183319', company_id = 'e7e206de-3ae7-46a9-a48a-4ae882ee2a18', department_id = '84c8872a-1b34-4a62-979a-183b7b80a529' WHERE user_id = 'db1a2c68-df7b-4e80-a44d-63d9d4d06363';
UPDATE public.user_roles SET company_id = 'e7e206de-3ae7-46a9-a48a-4ae882ee2a18' WHERE user_id = 'db1a2c68-df7b-4e80-a44d-63d9d4d06363';

-- Grace Kelly dos Passos  (gracekpassos@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('d2dacf82-01ae-47dc-b6ce-2d4c337eb559', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'gracekpassos@gmail.com', '', '2026-01-28T23:13:16.000Z', '2026-01-28T23:13:16.000Z', '2026-01-29T03:54:25.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Grace Kelly dos Passos "}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('75d50246-13e2-41d1-95f0-7d2482b266ff', 'd2dacf82-01ae-47dc-b6ce-2d4c337eb559', '{"sub":"d2dacf82-01ae-47dc-b6ce-2d4c337eb559","email":"gracekpassos@gmail.com","email_verified":true}', 'email', 'd2dacf82-01ae-47dc-b6ce-2d4c337eb559', '2026-01-28T23:13:16.000Z', '2026-01-29T03:54:25.000Z', '2026-01-29T03:54:26.000Z');
UPDATE public.profiles SET name = 'Grace Kelly dos Passos ', cpf = '00058922016', phone = '47991465013', company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = 'd2dacf82-01ae-47dc-b6ce-2d4c337eb559';
UPDATE public.user_roles SET company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = 'd2dacf82-01ae-47dc-b6ce-2d4c337eb559';

-- Thalia de jesus da hora da silva  (Thalia.dahora@outlook.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('739fef25-d4df-4ec9-af0a-4484f8639ac6', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'Thalia.dahora@outlook.com', '', '2026-01-29T01:30:06.000Z', '2026-01-29T01:30:06.000Z', '2026-01-29T01:53:55.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Thalia de jesus da hora da silva "}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('9dcc4b85-ddae-45d0-894a-6b3a25cdb8f9', '739fef25-d4df-4ec9-af0a-4484f8639ac6', '{"sub":"739fef25-d4df-4ec9-af0a-4484f8639ac6","email":"Thalia.dahora@outlook.com","email_verified":true}', 'email', '739fef25-d4df-4ec9-af0a-4484f8639ac6', '2026-01-29T01:30:06.000Z', '2026-01-29T01:53:55.000Z', '2026-01-29T01:53:55.000Z');
UPDATE public.profiles SET name = 'Thalia de jesus da hora da silva ', cpf = '44686003814', phone = '2299610631', company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '739fef25-d4df-4ec9-af0a-4484f8639ac6';
UPDATE public.user_roles SET company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '739fef25-d4df-4ec9-af0a-4484f8639ac6';

-- Luiz Fernando Maluf (luizfernando.maluf@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('05d75e4e-f770-4c0b-89e5-8a34c2627172', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'luizfernando.maluf@gmail.com', '', '2026-01-29T20:07:51.000Z', '2026-01-29T20:07:51.000Z', '2026-01-29T20:11:53.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Luiz Fernando Maluf"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('2a6438cb-294f-4070-b382-b5fcaf2a30b9', '05d75e4e-f770-4c0b-89e5-8a34c2627172', '{"sub":"05d75e4e-f770-4c0b-89e5-8a34c2627172","email":"luizfernando.maluf@gmail.com","email_verified":true}', 'email', '05d75e4e-f770-4c0b-89e5-8a34c2627172', '2026-01-29T20:07:51.000Z', '2026-01-29T20:11:53.000Z', '2026-01-29T20:11:53.000Z');
UPDATE public.profiles SET name = 'Luiz Fernando Maluf', cpf = '18709384880', phone = '11991437693', company_id = 'e7e206de-3ae7-46a9-a48a-4ae882ee2a18', department_id = '84c8872a-1b34-4a62-979a-183b7b80a529' WHERE user_id = '05d75e4e-f770-4c0b-89e5-8a34c2627172';
UPDATE public.user_roles SET company_id = 'e7e206de-3ae7-46a9-a48a-4ae882ee2a18' WHERE user_id = '05d75e4e-f770-4c0b-89e5-8a34c2627172';

-- DJESMI TOMÉ (djesmi@hotmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('e44a3f67-ae4a-4e17-be20-68473e9ef1cf', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'djesmi@hotmail.com', '', '2026-01-29T20:56:46.000Z', '2026-01-29T20:56:46.000Z', '2026-02-05T19:47:45.000Z', '{"provider":"email","providers":["email"]}', '{"name":"DJESMI TOMÉ"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('f2c7ff6b-a4af-47d1-8021-702592b44f89', 'e44a3f67-ae4a-4e17-be20-68473e9ef1cf', '{"sub":"e44a3f67-ae4a-4e17-be20-68473e9ef1cf","email":"djesmi@hotmail.com","email_verified":true}', 'email', 'e44a3f67-ae4a-4e17-be20-68473e9ef1cf', '2026-01-29T20:56:46.000Z', '2026-02-05T19:47:45.000Z', '2026-02-05T19:47:44.000Z');
UPDATE public.profiles SET name = 'DJESMI TOMÉ', cpf = '06494867662', phone = '12981449453', company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = 'e44a3f67-ae4a-4e17-be20-68473e9ef1cf';
UPDATE public.user_roles SET company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = 'e44a3f67-ae4a-4e17-be20-68473e9ef1cf';

-- Jaqueline Sousa Epifanio (jsepifanio2@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('c364d7cc-8064-4877-bee1-8bf71cd1bf26', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'jsepifanio2@gmail.com', '', '2026-01-30T23:14:17.000Z', '2026-01-30T23:14:17.000Z', '2026-01-30T23:17:47.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Jaqueline Sousa Epifanio"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('ea7e1bf4-8093-4c26-ae56-e136a576613c', 'c364d7cc-8064-4877-bee1-8bf71cd1bf26', '{"sub":"c364d7cc-8064-4877-bee1-8bf71cd1bf26","email":"jsepifanio2@gmail.com","email_verified":true}', 'email', 'c364d7cc-8064-4877-bee1-8bf71cd1bf26', '2026-01-30T23:14:17.000Z', '2026-01-30T23:17:47.000Z', '2026-01-30T23:17:48.000Z');
UPDATE public.profiles SET name = 'Jaqueline Sousa Epifanio', cpf = '11781633690', phone = '37999616845', company_id = 'e7e206de-3ae7-46a9-a48a-4ae882ee2a18', department_id = '84c8872a-1b34-4a62-979a-183b7b80a529' WHERE user_id = 'c364d7cc-8064-4877-bee1-8bf71cd1bf26';
UPDATE public.user_roles SET company_id = 'e7e206de-3ae7-46a9-a48a-4ae882ee2a18' WHERE user_id = 'c364d7cc-8064-4877-bee1-8bf71cd1bf26';

-- Normandia (normandia@dnaia.ai) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('c52c2f38-3f66-4611-950a-9202bb29ac0b', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'normandia@dnaia.ai', '', '2026-02-06T22:41:48.000Z', '2026-02-06T22:41:48.000Z', '2026-02-06T22:41:48.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Normandia"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('d9c94c92-f9b3-48ca-8198-e6801c870ab8', 'c52c2f38-3f66-4611-950a-9202bb29ac0b', '{"sub":"c52c2f38-3f66-4611-950a-9202bb29ac0b","email":"normandia@dnaia.ai","email_verified":true}', 'email', 'c52c2f38-3f66-4611-950a-9202bb29ac0b', '2026-02-06T22:41:48.000Z', '2026-02-06T22:41:48.000Z', '2026-02-06T22:41:48.000Z');
UPDATE public.profiles SET name = 'Normandia', cpf = '06847654627', phone = '31984499268', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'c52c2f38-3f66-4611-950a-9202bb29ac0b';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'c52c2f38-3f66-4611-950a-9202bb29ac0b';

-- Teste Usuario 1 (teste.1770407502698.295.1@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('6e04320c-cf16-4ff2-8188-a954a1135462', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502698.295.1@loadtest.com', '', '2026-02-06T22:51:45.000Z', '2026-02-06T22:51:45.000Z', '2026-02-06T22:51:45.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 1"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('e81da4f3-9105-41d0-9bca-d8134f09f3f1', '6e04320c-cf16-4ff2-8188-a954a1135462', '{"sub":"6e04320c-cf16-4ff2-8188-a954a1135462","email":"teste.1770407502698.295.1@loadtest.com","email_verified":true}', 'email', '6e04320c-cf16-4ff2-8188-a954a1135462', '2026-02-06T22:51:45.000Z', '2026-02-06T22:51:45.000Z', '2026-02-06T22:51:46.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 1', cpf = '10000000001', phone = '11900000001', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '6e04320c-cf16-4ff2-8188-a954a1135462';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '6e04320c-cf16-4ff2-8188-a954a1135462';

-- Teste Usuario 65 (teste.1770407502828.1808.65@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('d4de7028-1104-45d2-9443-d3608920d575', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502828.1808.65@loadtest.com', '', '2026-02-06T22:51:46.000Z', '2026-02-06T22:51:46.000Z', '2026-02-06T22:51:46.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 65"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('43397203-f4a3-4afa-994d-1dd6bbf6e981', 'd4de7028-1104-45d2-9443-d3608920d575', '{"sub":"d4de7028-1104-45d2-9443-d3608920d575","email":"teste.1770407502828.1808.65@loadtest.com","email_verified":true}', 'email', 'd4de7028-1104-45d2-9443-d3608920d575', '2026-02-06T22:51:46.000Z', '2026-02-06T22:51:46.000Z', '2026-02-06T22:51:46.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 65', cpf = '10000000065', phone = '11900000065', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'd4de7028-1104-45d2-9443-d3608920d575';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'd4de7028-1104-45d2-9443-d3608920d575';

-- Teste Usuario 3 (teste.1770407502776.3720.3@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('51eb7d50-349b-4e3c-b73c-53de846431d5', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502776.3720.3@loadtest.com', '', '2026-02-06T22:51:46.000Z', '2026-02-06T22:51:46.000Z', '2026-02-06T22:51:46.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 3"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('b44f4ff5-0aa4-4301-8de8-538e7e20d86b', '51eb7d50-349b-4e3c-b73c-53de846431d5', '{"sub":"51eb7d50-349b-4e3c-b73c-53de846431d5","email":"teste.1770407502776.3720.3@loadtest.com","email_verified":true}', 'email', '51eb7d50-349b-4e3c-b73c-53de846431d5', '2026-02-06T22:51:46.000Z', '2026-02-06T22:51:46.000Z', '2026-02-06T22:51:47.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 3', cpf = '10000000003', phone = '11900000003', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '51eb7d50-349b-4e3c-b73c-53de846431d5';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '51eb7d50-349b-4e3c-b73c-53de846431d5';

-- Teste Usuario 75 (teste.1770407502835.7735.75@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('bd9b1a2d-b678-4929-9e3f-53272e74d564', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502835.7735.75@loadtest.com', '', '2026-02-06T22:51:47.000Z', '2026-02-06T22:51:47.000Z', '2026-02-06T22:51:47.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 75"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('03f7ae9f-5d67-4e58-ab13-5e10d621bc2c', 'bd9b1a2d-b678-4929-9e3f-53272e74d564', '{"sub":"bd9b1a2d-b678-4929-9e3f-53272e74d564","email":"teste.1770407502835.7735.75@loadtest.com","email_verified":true}', 'email', 'bd9b1a2d-b678-4929-9e3f-53272e74d564', '2026-02-06T22:51:47.000Z', '2026-02-06T22:51:47.000Z', '2026-02-06T22:51:47.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 75', cpf = '10000000075', phone = '11900000075', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'bd9b1a2d-b678-4929-9e3f-53272e74d564';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'bd9b1a2d-b678-4929-9e3f-53272e74d564';

-- Teste Usuario 82 (teste.1770407502840.1592.82@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('eb114284-a493-4916-a48d-4f42b6792d83', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502840.1592.82@loadtest.com', '', '2026-02-06T22:51:47.000Z', '2026-02-06T22:51:47.000Z', '2026-02-06T22:51:47.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 82"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('f73b5da5-9823-4519-8041-a3ea2dbb976e', 'eb114284-a493-4916-a48d-4f42b6792d83', '{"sub":"eb114284-a493-4916-a48d-4f42b6792d83","email":"teste.1770407502840.1592.82@loadtest.com","email_verified":true}', 'email', 'eb114284-a493-4916-a48d-4f42b6792d83', '2026-02-06T22:51:47.000Z', '2026-02-06T22:51:47.000Z', '2026-02-06T22:51:47.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 82', cpf = '10000000082', phone = '11900000082', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'eb114284-a493-4916-a48d-4f42b6792d83';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'eb114284-a493-4916-a48d-4f42b6792d83';

-- Teste Usuario 4 (teste.1770407502778.6251.4@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('ea645afb-24b1-467f-8683-cc1d28d7a8b9', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502778.6251.4@loadtest.com', '', '2026-02-06T22:51:48.000Z', '2026-02-06T22:51:48.000Z', '2026-02-06T22:51:48.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 4"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('2faba34c-86e0-4baf-ba29-6d22209500eb', 'ea645afb-24b1-467f-8683-cc1d28d7a8b9', '{"sub":"ea645afb-24b1-467f-8683-cc1d28d7a8b9","email":"teste.1770407502778.6251.4@loadtest.com","email_verified":true}', 'email', 'ea645afb-24b1-467f-8683-cc1d28d7a8b9', '2026-02-06T22:51:48.000Z', '2026-02-06T22:51:48.000Z', '2026-02-06T22:51:48.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 4', cpf = '10000000004', phone = '11900000004', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'ea645afb-24b1-467f-8683-cc1d28d7a8b9';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'ea645afb-24b1-467f-8683-cc1d28d7a8b9';

-- Teste Usuario 70 (teste.1770407502832.9984.70@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('ff5e9bba-75ee-4fd8-91c9-edb5c64babc3', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502832.9984.70@loadtest.com', '', '2026-02-06T22:51:48.000Z', '2026-02-06T22:51:48.000Z', '2026-02-06T22:51:48.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 70"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('283cebe0-0053-48b0-87ec-396c25091945', 'ff5e9bba-75ee-4fd8-91c9-edb5c64babc3', '{"sub":"ff5e9bba-75ee-4fd8-91c9-edb5c64babc3","email":"teste.1770407502832.9984.70@loadtest.com","email_verified":true}', 'email', 'ff5e9bba-75ee-4fd8-91c9-edb5c64babc3', '2026-02-06T22:51:48.000Z', '2026-02-06T22:51:48.000Z', '2026-02-06T22:51:48.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 70', cpf = '10000000070', phone = '11900000070', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'ff5e9bba-75ee-4fd8-91c9-edb5c64babc3';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'ff5e9bba-75ee-4fd8-91c9-edb5c64babc3';

-- Teste Usuario 6 (teste.1770407502780.1844.6@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('b23aa13a-51c8-451e-918a-78350f3e9ae5', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502780.1844.6@loadtest.com', '', '2026-02-06T22:51:48.000Z', '2026-02-06T22:51:48.000Z', '2026-02-06T22:51:48.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 6"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('ff820523-74a8-4083-9a8e-215a2124f320', 'b23aa13a-51c8-451e-918a-78350f3e9ae5', '{"sub":"b23aa13a-51c8-451e-918a-78350f3e9ae5","email":"teste.1770407502780.1844.6@loadtest.com","email_verified":true}', 'email', 'b23aa13a-51c8-451e-918a-78350f3e9ae5', '2026-02-06T22:51:48.000Z', '2026-02-06T22:51:48.000Z', '2026-02-06T22:51:49.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 6', cpf = '10000000006', phone = '11900000006', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'b23aa13a-51c8-451e-918a-78350f3e9ae5';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'b23aa13a-51c8-451e-918a-78350f3e9ae5';

-- Teste Usuario 7 (teste.1770407502781.2325.7@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('3eb78e98-af81-47c6-99d4-5fd0d5d73be0', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502781.2325.7@loadtest.com', '', '2026-02-06T22:51:49.000Z', '2026-02-06T22:51:49.000Z', '2026-02-06T22:51:49.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 7"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('94f4d921-aa9e-4a30-a4db-141db00bb683', '3eb78e98-af81-47c6-99d4-5fd0d5d73be0', '{"sub":"3eb78e98-af81-47c6-99d4-5fd0d5d73be0","email":"teste.1770407502781.2325.7@loadtest.com","email_verified":true}', 'email', '3eb78e98-af81-47c6-99d4-5fd0d5d73be0', '2026-02-06T22:51:49.000Z', '2026-02-06T22:51:49.000Z', '2026-02-06T22:51:49.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 7', cpf = '10000000007', phone = '11900000007', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '3eb78e98-af81-47c6-99d4-5fd0d5d73be0';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '3eb78e98-af81-47c6-99d4-5fd0d5d73be0';
