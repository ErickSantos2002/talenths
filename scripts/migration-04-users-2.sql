-- ============================================
-- Talent-IA Migration - Part 4/8: Users 101-200 (batch 2/5)
-- Generated: 2026-02-13T20:29:31.264Z
-- EXECUTE IN ORDER: Part 4 of 8
-- ============================================

-- Mayara Dias (mayaradias.tur@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('050c82a1-ffaf-45f4-b370-f0d30b34a9e6', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'mayaradias.tur@gmail.com', '', '2026-01-14T01:20:09.000Z', '2026-01-14T01:20:09.000Z', '2026-01-14T15:05:37.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Mayara Dias"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('db7dac66-5a35-42c5-a5f8-af6aa0227a03', '050c82a1-ffaf-45f4-b370-f0d30b34a9e6', '{"sub":"050c82a1-ffaf-45f4-b370-f0d30b34a9e6","email":"mayaradias.tur@gmail.com","email_verified":true}', 'email', '050c82a1-ffaf-45f4-b370-f0d30b34a9e6', '2026-01-14T01:20:09.000Z', '2026-01-14T15:05:37.000Z', '2026-01-14T15:05:37.000Z');
UPDATE public.profiles SET name = 'Mayara Dias', cpf = '13680526652', phone = '31996952207', company_id = 'edea5e96-20ea-40a8-8cb8-0988cd74869c' WHERE user_id = '050c82a1-ffaf-45f4-b370-f0d30b34a9e6';
UPDATE public.user_roles SET company_id = 'edea5e96-20ea-40a8-8cb8-0988cd74869c' WHERE user_id = '050c82a1-ffaf-45f4-b370-f0d30b34a9e6';

-- Rodrigo Nascimento (digowars@gmail.com) | Role: company_admin
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('51f6d97a-284d-4985-86e0-2fda9b2f0a5d', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'digowars@gmail.com', '', '2026-01-14T18:05:37.000Z', '2026-01-14T18:05:37.000Z', '2026-01-24T05:37:56.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Rodrigo Nascimento"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('8eb4df4c-fd97-40f3-8377-65693903876b', '51f6d97a-284d-4985-86e0-2fda9b2f0a5d', '{"sub":"51f6d97a-284d-4985-86e0-2fda9b2f0a5d","email":"digowars@gmail.com","email_verified":true}', 'email', '51f6d97a-284d-4985-86e0-2fda9b2f0a5d', '2026-01-14T18:05:37.000Z', '2026-01-24T05:37:56.000Z', '2026-01-24T05:37:56.000Z');
UPDATE public.profiles SET name = 'Rodrigo Nascimento', cpf = '06748391610', phone = '31991249442', company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '51f6d97a-284d-4985-86e0-2fda9b2f0a5d';
UPDATE public.user_roles SET role = 'company_admin'::public.app_role, company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '51f6d97a-284d-4985-86e0-2fda9b2f0a5d';

-- DANIEL GAIA DA SILVA (daniel.gaia@varejaodastintas.com.br) | Role: company_admin
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('94fc4eef-dd77-449c-8582-63786b082bd1', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'daniel.gaia@varejaodastintas.com.br', '', '2026-01-16T17:09:02.000Z', '2026-01-16T17:09:02.000Z', '2026-01-20T19:31:36.000Z', '{"provider":"email","providers":["email"]}', '{"name":"DANIEL GAIA DA SILVA"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('633efbe5-5a81-4b1b-a3cb-958d0e0258a3', '94fc4eef-dd77-449c-8582-63786b082bd1', '{"sub":"94fc4eef-dd77-449c-8582-63786b082bd1","email":"daniel.gaia@varejaodastintas.com.br","email_verified":true}', 'email', '94fc4eef-dd77-449c-8582-63786b082bd1', '2026-01-16T17:09:02.000Z', '2026-01-20T19:31:36.000Z', '2026-01-16T17:09:02.000Z');
UPDATE public.profiles SET name = 'DANIEL GAIA DA SILVA', cpf = '06266026619', phone = '31986492310', company_id = '8e247e6c-fa9f-4045-bd65-7fa0bce736c8', department_id = 'cabf6bc5-044e-4e8b-9868-f87b6d99ff72' WHERE user_id = '94fc4eef-dd77-449c-8582-63786b082bd1';
UPDATE public.user_roles SET role = 'company_admin'::public.app_role, company_id = '8e247e6c-fa9f-4045-bd65-7fa0bce736c8' WHERE user_id = '94fc4eef-dd77-449c-8582-63786b082bd1';

-- Alberto Angrisano Costa  (aangrisano@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('20c649ba-344e-4d4b-92eb-a7c55f19e539', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'aangrisano@gmail.com', '', '2026-01-16T20:39:54.000Z', '2026-01-16T20:39:54.000Z', '2026-01-19T15:39:16.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Alberto Angrisano Costa "}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('b703e6ad-2a84-465b-b3d6-69280c2c088c', '20c649ba-344e-4d4b-92eb-a7c55f19e539', '{"sub":"20c649ba-344e-4d4b-92eb-a7c55f19e539","email":"aangrisano@gmail.com","email_verified":true}', 'email', '20c649ba-344e-4d4b-92eb-a7c55f19e539', '2026-01-16T20:39:54.000Z', '2026-01-19T15:39:16.000Z', '2026-01-19T15:39:16.000Z');
UPDATE public.profiles SET name = 'Alberto Angrisano Costa ', cpf = '06106484708', phone = '21983987190', company_id = 'e7e206de-3ae7-46a9-a48a-4ae882ee2a18', department_id = '84c8872a-1b34-4a62-979a-183b7b80a529' WHERE user_id = '20c649ba-344e-4d4b-92eb-a7c55f19e539';
UPDATE public.user_roles SET company_id = 'e7e206de-3ae7-46a9-a48a-4ae882ee2a18' WHERE user_id = '20c649ba-344e-4d4b-92eb-a7c55f19e539';

-- Test User With Password (test_with_password_1768589940269@example.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('d873a9e5-2e1d-4ead-b31b-b95079242724', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'test_with_password_1768589940269@example.com', '', '2026-01-16T21:59:00.000Z', '2026-01-16T21:59:00.000Z', '2026-01-16T21:59:00.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Test User With Password"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('8286a023-00d4-4b76-86a5-529ae030b87f', 'd873a9e5-2e1d-4ead-b31b-b95079242724', '{"sub":"d873a9e5-2e1d-4ead-b31b-b95079242724","email":"test_with_password_1768589940269@example.com","email_verified":true}', 'email', 'd873a9e5-2e1d-4ead-b31b-b95079242724', '2026-01-16T21:59:00.000Z', '2026-01-16T21:59:00.000Z', '2026-01-16T21:59:01.000Z');
UPDATE public.profiles SET name = 'Test User With Password', cpf = '12345678901', phone = '11999999999', company_id = 'c124c2d4-1bea-4c5a-bc5f-fdf8d0a67b47' WHERE user_id = 'd873a9e5-2e1d-4ead-b31b-b95079242724';
UPDATE public.user_roles SET company_id = 'c124c2d4-1bea-4c5a-bc5f-fdf8d0a67b47' WHERE user_id = 'd873a9e5-2e1d-4ead-b31b-b95079242724';

-- Test User Without Password (test_without_password_1768589940874@example.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('d9ef8366-4ab1-4efa-b441-586c30710098', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'test_without_password_1768589940874@example.com', '', '2026-01-16T21:59:00.000Z', '2026-01-16T21:59:00.000Z', '2026-01-16T21:59:00.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Test User Without Password"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('3c72226b-c9e9-4e87-b786-5426ddf3758c', 'd9ef8366-4ab1-4efa-b441-586c30710098', '{"sub":"d9ef8366-4ab1-4efa-b441-586c30710098","email":"test_without_password_1768589940874@example.com","email_verified":true}', 'email', 'd9ef8366-4ab1-4efa-b441-586c30710098', '2026-01-16T21:59:00.000Z', '2026-01-16T21:59:00.000Z', '2026-01-16T21:59:01.000Z');
UPDATE public.profiles SET name = 'Test User Without Password', cpf = '12345678902', phone = '11988888888', company_id = 'c124c2d4-1bea-4c5a-bc5f-fdf8d0a67b47' WHERE user_id = 'd9ef8366-4ab1-4efa-b441-586c30710098';
UPDATE public.user_roles SET company_id = 'c124c2d4-1bea-4c5a-bc5f-fdf8d0a67b47' WHERE user_id = 'd9ef8366-4ab1-4efa-b441-586c30710098';

-- Normandia teste (rnrsouza@hotmail.com) | Role: company_admin
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('ed95dbfe-bd7b-4abc-a0e9-108350b946e9', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'rnrsouza@hotmail.com', '', '2026-01-20T20:05:36.000Z', '2026-01-20T20:05:36.000Z', '2026-01-25T15:33:42.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Normandia teste"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('5e1397e0-2b37-4eb2-ada7-17fb760d2459', 'ed95dbfe-bd7b-4abc-a0e9-108350b946e9', '{"sub":"ed95dbfe-bd7b-4abc-a0e9-108350b946e9","email":"rnrsouza@hotmail.com","email_verified":true}', 'email', 'ed95dbfe-bd7b-4abc-a0e9-108350b946e9', '2026-01-20T20:05:36.000Z', '2026-01-25T15:33:42.000Z', '2026-01-25T15:33:43.000Z');
UPDATE public.profiles SET name = 'Normandia teste', cpf = '06847654627', phone = '31984499268', company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = 'ed95dbfe-bd7b-4abc-a0e9-108350b946e9';
UPDATE public.user_roles SET role = 'company_admin'::public.app_role, company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = 'ed95dbfe-bd7b-4abc-a0e9-108350b946e9';

-- Kaw Bicalho (kawbicalho@gmail.com) | Role: company_admin
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('2bb95345-2b61-4b26-821d-b4c35a88c60e', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'kawbicalho@gmail.com', '', '2026-01-20T20:16:57.000Z', '2026-01-20T20:16:57.000Z', '2026-01-20T20:17:25.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Kaw Bicalho"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('58ac17c8-d39f-47d3-8665-812ff0309560', '2bb95345-2b61-4b26-821d-b4c35a88c60e', '{"sub":"2bb95345-2b61-4b26-821d-b4c35a88c60e","email":"kawbicalho@gmail.com","email_verified":true}', 'email', '2bb95345-2b61-4b26-821d-b4c35a88c60e', '2026-01-20T20:16:57.000Z', '2026-01-20T20:17:25.000Z', '2026-01-20T20:17:26.000Z');
UPDATE public.profiles SET name = 'Kaw Bicalho', cpf = '09244736659', phone = '31992171438', company_id = '0d002a99-fdbb-4172-a87a-6c7d1bcef882' WHERE user_id = '2bb95345-2b61-4b26-821d-b4c35a88c60e';
UPDATE public.user_roles SET role = 'company_admin'::public.app_role, company_id = '0d002a99-fdbb-4172-a87a-6c7d1bcef882' WHERE user_id = '2bb95345-2b61-4b26-821d-b4c35a88c60e';

-- GABRIELA DIAS (GABIDIASJ@GMAIL.COM) | Role: company_admin
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('5b8275b2-9f23-4eb5-9492-655700d462fc', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'GABIDIASJ@GMAIL.COM', '', '2026-01-21T17:21:36.000Z', '2026-01-21T17:21:36.000Z', '2026-01-23T17:59:44.000Z', '{"provider":"email","providers":["email"]}', '{"name":"GABRIELA DIAS"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('8a24f5df-947c-4b7d-ac71-5850dc6ebc56', '5b8275b2-9f23-4eb5-9492-655700d462fc', '{"sub":"5b8275b2-9f23-4eb5-9492-655700d462fc","email":"GABIDIASJ@GMAIL.COM","email_verified":true}', 'email', '5b8275b2-9f23-4eb5-9492-655700d462fc', '2026-01-21T17:21:36.000Z', '2026-01-23T17:59:44.000Z', '2026-01-23T17:59:45.000Z');
UPDATE public.profiles SET name = 'GABRIELA DIAS', cpf = '40293442835', phone = '11947461837', company_id = '0439a92b-e154-42a8-9f01-687c0602194f' WHERE user_id = '5b8275b2-9f23-4eb5-9492-655700d462fc';
UPDATE public.user_roles SET role = 'company_admin'::public.app_role, company_id = '0439a92b-e154-42a8-9f01-687c0602194f' WHERE user_id = '5b8275b2-9f23-4eb5-9492-655700d462fc';

-- Djalma Neto (financeiro01@healthsafetytech.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('5e5f0966-1b59-4a7b-bade-a81899cf60c1', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'financeiro01@healthsafetytech.com', '', '2026-01-22T20:55:12.000Z', '2026-01-22T20:55:12.000Z', '2026-01-23T17:52:25.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Djalma Neto"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('fca2f858-bf94-4bce-8e23-2197f2453dd4', '5e5f0966-1b59-4a7b-bade-a81899cf60c1', '{"sub":"5e5f0966-1b59-4a7b-bade-a81899cf60c1","email":"financeiro01@healthsafetytech.com","email_verified":true}', 'email', '5e5f0966-1b59-4a7b-bade-a81899cf60c1', '2026-01-22T20:55:12.000Z', '2026-01-23T17:52:25.000Z', '2026-01-22T20:55:12.000Z');
UPDATE public.profiles SET name = 'Djalma Neto', cpf = '12249648450', phone = '81997107258', company_id = '5dc0d6af-ea86-43cb-ab1d-3b231de50834', department_id = '19cb9bca-0191-48c3-9538-33b0a4f0ab4d' WHERE user_id = '5e5f0966-1b59-4a7b-bade-a81899cf60c1';
UPDATE public.user_roles SET company_id = '5dc0d6af-ea86-43cb-ab1d-3b231de50834' WHERE user_id = '5e5f0966-1b59-4a7b-bade-a81899cf60c1';

-- Gislayne Nunes (comercial01@healthsafetytech.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('542990a6-f86f-4d45-b301-0dc69fd7336e', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'comercial01@healthsafetytech.com', '', '2026-01-22T21:01:00.000Z', '2026-01-22T21:01:00.000Z', '2026-01-23T17:52:18.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Gislayne Nunes"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('b330e7fe-caef-4f42-90a2-eb9867e10fda', '542990a6-f86f-4d45-b301-0dc69fd7336e', '{"sub":"542990a6-f86f-4d45-b301-0dc69fd7336e","email":"comercial01@healthsafetytech.com","email_verified":true}', 'email', '542990a6-f86f-4d45-b301-0dc69fd7336e', '2026-01-22T21:01:00.000Z', '2026-01-23T17:52:18.000Z', '2026-01-22T21:01:00.000Z');
UPDATE public.profiles SET name = 'Gislayne Nunes', cpf = '087597534-80', phone = '819 8343 0721', company_id = '5dc0d6af-ea86-43cb-ab1d-3b231de50834', department_id = '21137faa-f57b-457e-9f20-7faa13b9fc8f' WHERE user_id = '542990a6-f86f-4d45-b301-0dc69fd7336e';
UPDATE public.user_roles SET company_id = '5dc0d6af-ea86-43cb-ab1d-3b231de50834' WHERE user_id = '542990a6-f86f-4d45-b301-0dc69fd7336e';

-- Hyago Guimaraes (qualidade01@healthsafetytech.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('340d8731-7f92-4f47-a525-50045baf89eb', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'qualidade01@healthsafetytech.com', '', '2026-01-22T21:02:00.000Z', '2026-01-22T21:02:00.000Z', '2026-01-23T17:52:13.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Hyago Guimaraes"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('3a1ae45d-740b-4bf1-b325-f7eea503f223', '340d8731-7f92-4f47-a525-50045baf89eb', '{"sub":"340d8731-7f92-4f47-a525-50045baf89eb","email":"qualidade01@healthsafetytech.com","email_verified":true}', 'email', '340d8731-7f92-4f47-a525-50045baf89eb', '2026-01-22T21:02:00.000Z', '2026-01-23T17:52:13.000Z', '2026-01-22T21:02:00.000Z');
UPDATE public.profiles SET name = 'Hyago Guimaraes', cpf = '083972964-25', phone = '819 9762 7512', company_id = '5dc0d6af-ea86-43cb-ab1d-3b231de50834', department_id = 'dea905ea-2ec3-441a-bbe6-68fce45e0216' WHERE user_id = '340d8731-7f92-4f47-a525-50045baf89eb';
UPDATE public.user_roles SET company_id = '5dc0d6af-ea86-43cb-ab1d-3b231de50834' WHERE user_id = '340d8731-7f92-4f47-a525-50045baf89eb';

-- Ellen Elis (servicos01@healthsafetytech.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('7002073a-26ba-4772-8663-d366aaf38e75', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'servicos01@healthsafetytech.com', '', '2026-01-22T21:04:05.000Z', '2026-01-22T21:04:05.000Z', '2026-01-23T17:52:06.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Ellen Elis"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('dd9bfc07-a95e-44e7-b479-f003e23e5d10', '7002073a-26ba-4772-8663-d366aaf38e75', '{"sub":"7002073a-26ba-4772-8663-d366aaf38e75","email":"servicos01@healthsafetytech.com","email_verified":true}', 'email', '7002073a-26ba-4772-8663-d366aaf38e75', '2026-01-22T21:04:05.000Z', '2026-01-23T17:52:06.000Z', '2026-01-22T21:04:05.000Z');
UPDATE public.profiles SET name = 'Ellen Elis', cpf = '707884864-03', phone = '819 9667 8651', company_id = '5dc0d6af-ea86-43cb-ab1d-3b231de50834', department_id = '966ff0b6-d35f-4d6e-8728-6463b64c20a5' WHERE user_id = '7002073a-26ba-4772-8663-d366aaf38e75';
UPDATE public.user_roles SET company_id = '5dc0d6af-ea86-43cb-ab1d-3b231de50834' WHERE user_id = '7002073a-26ba-4772-8663-d366aaf38e75';

-- Walbert Santos (laboratorio01@healthsafetytech.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('fd0646ee-3389-4bbd-b2b9-8e9b9f147644', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'laboratorio01@healthsafetytech.com', '', '2026-01-22T21:46:59.000Z', '2026-01-22T21:46:59.000Z', '2026-01-23T17:52:02.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Walbert Santos"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('65884126-8e36-401f-ba82-908fab99b836', 'fd0646ee-3389-4bbd-b2b9-8e9b9f147644', '{"sub":"fd0646ee-3389-4bbd-b2b9-8e9b9f147644","email":"laboratorio01@healthsafetytech.com","email_verified":true}', 'email', 'fd0646ee-3389-4bbd-b2b9-8e9b9f147644', '2026-01-22T21:46:59.000Z', '2026-01-23T17:52:02.000Z', '2026-01-22T21:46:59.000Z');
UPDATE public.profiles SET name = 'Walbert Santos', cpf = '029491124-39', phone = '819 9184 5653', company_id = '5dc0d6af-ea86-43cb-ab1d-3b231de50834', department_id = '729499ea-36c5-4dd4-8b8d-1f43037235f4' WHERE user_id = 'fd0646ee-3389-4bbd-b2b9-8e9b9f147644';
UPDATE public.user_roles SET company_id = '5dc0d6af-ea86-43cb-ab1d-3b231de50834' WHERE user_id = 'fd0646ee-3389-4bbd-b2b9-8e9b9f147644';

-- Leandro Victor (expedicao01@healthsafetytech.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('22346c35-be93-4bc6-9f73-e57b4e691b2a', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'expedicao01@healthsafetytech.com', '', '2026-01-22T21:52:56.000Z', '2026-01-22T21:52:56.000Z', '2026-01-23T17:51:54.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Leandro Victor"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('3ad2fe6f-2c88-4e5a-ac68-a51072a46e11', '22346c35-be93-4bc6-9f73-e57b4e691b2a', '{"sub":"22346c35-be93-4bc6-9f73-e57b4e691b2a","email":"expedicao01@healthsafetytech.com","email_verified":true}', 'email', '22346c35-be93-4bc6-9f73-e57b4e691b2a', '2026-01-22T21:52:56.000Z', '2026-01-23T17:51:54.000Z', '2026-01-22T21:52:56.000Z');
UPDATE public.profiles SET name = 'Leandro Victor', cpf = '033910544-50', phone = '819 8872 0636', company_id = '5dc0d6af-ea86-43cb-ab1d-3b231de50834', department_id = 'ecbfa438-ecd7-4834-b121-a257457f8436' WHERE user_id = '22346c35-be93-4bc6-9f73-e57b4e691b2a';
UPDATE public.user_roles SET company_id = '5dc0d6af-ea86-43cb-ab1d-3b231de50834' WHERE user_id = '22346c35-be93-4bc6-9f73-e57b4e691b2a';

-- Erick Dantas (ti@healthsafetytech.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('fcf22817-f8ca-4e56-abce-700ed569666f', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'ti@healthsafetytech.com', '', '2026-01-22T22:18:48.000Z', '2026-01-22T22:18:48.000Z', '2026-01-23T21:01:32.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Erick Dantas"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('74a28190-9a3d-4c87-85d7-6f8a8f08ed52', 'fcf22817-f8ca-4e56-abce-700ed569666f', '{"sub":"fcf22817-f8ca-4e56-abce-700ed569666f","email":"ti@healthsafetytech.com","email_verified":true}', 'email', 'fcf22817-f8ca-4e56-abce-700ed569666f', '2026-01-22T22:18:48.000Z', '2026-01-23T21:01:32.000Z', '2026-01-23T21:01:32.000Z');
UPDATE public.profiles SET name = 'Erick Dantas', cpf = '715017244-01', phone = '819 8864 0445', company_id = '5dc0d6af-ea86-43cb-ab1d-3b231de50834', department_id = '78f4af47-7aac-4d8a-add9-cdd67edff119' WHERE user_id = 'fcf22817-f8ca-4e56-abce-700ed569666f';
UPDATE public.user_roles SET company_id = '5dc0d6af-ea86-43cb-ab1d-3b231de50834' WHERE user_id = 'fcf22817-f8ca-4e56-abce-700ed569666f';

-- Rafael Pontes (expedicao02@healthsafetytech.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('2fefb50e-50c1-4f31-a1e8-b0adb200399b', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'expedicao02@healthsafetytech.com', '', '2026-01-22T22:19:35.000Z', '2026-01-22T22:19:35.000Z', '2026-01-23T17:51:41.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Rafael Pontes"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('e3c46314-5ddb-443a-a397-7cdef9e458e0', '2fefb50e-50c1-4f31-a1e8-b0adb200399b', '{"sub":"2fefb50e-50c1-4f31-a1e8-b0adb200399b","email":"expedicao02@healthsafetytech.com","email_verified":true}', 'email', '2fefb50e-50c1-4f31-a1e8-b0adb200399b', '2026-01-22T22:19:35.000Z', '2026-01-23T17:51:41.000Z', '2026-01-22T22:19:35.000Z');
UPDATE public.profiles SET name = 'Rafael Pontes', cpf = '032831414-52', phone = '819 9827 6203', company_id = '5dc0d6af-ea86-43cb-ab1d-3b231de50834', department_id = 'ecbfa438-ecd7-4834-b121-a257457f8436' WHERE user_id = '2fefb50e-50c1-4f31-a1e8-b0adb200399b';
UPDATE public.user_roles SET company_id = '5dc0d6af-ea86-43cb-ab1d-3b231de50834' WHERE user_id = '2fefb50e-50c1-4f31-a1e8-b0adb200399b';

-- Adriana Oliveira (comercial02@healthsafetytech.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('6c19a2ff-c317-48bc-a9f6-37bf2b5b93b2', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'comercial02@healthsafetytech.com', '', '2026-01-22T22:20:10.000Z', '2026-01-22T22:20:10.000Z', '2026-01-23T17:51:33.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Adriana Oliveira"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('46fd0962-f588-463c-987a-e40ecc092f7b', '6c19a2ff-c317-48bc-a9f6-37bf2b5b93b2', '{"sub":"6c19a2ff-c317-48bc-a9f6-37bf2b5b93b2","email":"comercial02@healthsafetytech.com","email_verified":true}', 'email', '6c19a2ff-c317-48bc-a9f6-37bf2b5b93b2', '2026-01-22T22:20:10.000Z', '2026-01-23T17:51:33.000Z', '2026-01-22T22:20:10.000Z');
UPDATE public.profiles SET name = 'Adriana Oliveira', cpf = '105096534-56', phone = '819 8960-7280', company_id = '5dc0d6af-ea86-43cb-ab1d-3b231de50834', department_id = '21137faa-f57b-457e-9f20-7faa13b9fc8f' WHERE user_id = '6c19a2ff-c317-48bc-a9f6-37bf2b5b93b2';
UPDATE public.user_roles SET company_id = '5dc0d6af-ea86-43cb-ab1d-3b231de50834' WHERE user_id = '6c19a2ff-c317-48bc-a9f6-37bf2b5b93b2';

-- Welton Kellyson (ti02@healthsafetytech.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('e1baa135-585a-4eff-9706-943043c6082c', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'ti02@healthsafetytech.com', '', '2026-01-22T22:22:11.000Z', '2026-01-22T22:22:11.000Z', '2026-01-23T17:51:27.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Welton Kellyson"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('0884ab8c-b88f-4f43-9c9b-18ec57b060fc', 'e1baa135-585a-4eff-9706-943043c6082c', '{"sub":"e1baa135-585a-4eff-9706-943043c6082c","email":"ti02@healthsafetytech.com","email_verified":true}', 'email', 'e1baa135-585a-4eff-9706-943043c6082c', '2026-01-22T22:22:11.000Z', '2026-01-23T17:51:27.000Z', '2026-01-22T22:22:11.000Z');
UPDATE public.profiles SET name = 'Welton Kellyson', cpf = '140763664-25', phone = '819 9901-8603', company_id = '5dc0d6af-ea86-43cb-ab1d-3b231de50834', department_id = '78f4af47-7aac-4d8a-add9-cdd67edff119' WHERE user_id = 'e1baa135-585a-4eff-9706-943043c6082c';
UPDATE public.user_roles SET company_id = '5dc0d6af-ea86-43cb-ab1d-3b231de50834' WHERE user_id = 'e1baa135-585a-4eff-9706-943043c6082c';

-- Sandra Cristina (comercial03@healthsafetytech.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('413636ba-52bd-4dcc-867b-01ea4ccc86e6', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'comercial03@healthsafetytech.com', '', '2026-01-22T22:22:38.000Z', '2026-01-22T22:22:38.000Z', '2026-01-23T17:51:19.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Sandra Cristina"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('c0222139-3a78-42cf-a03c-147421670209', '413636ba-52bd-4dcc-867b-01ea4ccc86e6', '{"sub":"413636ba-52bd-4dcc-867b-01ea4ccc86e6","email":"comercial03@healthsafetytech.com","email_verified":true}', 'email', '413636ba-52bd-4dcc-867b-01ea4ccc86e6', '2026-01-22T22:22:38.000Z', '2026-01-23T17:51:19.000Z', '2026-01-22T22:22:38.000Z');
UPDATE public.profiles SET name = 'Sandra Cristina', cpf = '027935014-76', phone = '819 9802-3555', company_id = '5dc0d6af-ea86-43cb-ab1d-3b231de50834', department_id = '21137faa-f57b-457e-9f20-7faa13b9fc8f' WHERE user_id = '413636ba-52bd-4dcc-867b-01ea4ccc86e6';
UPDATE public.user_roles SET company_id = '5dc0d6af-ea86-43cb-ab1d-3b231de50834' WHERE user_id = '413636ba-52bd-4dcc-867b-01ea4ccc86e6';

-- Eduardo Luna (comercial04@healthsafetytech.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('a631e765-8fe9-4c84-a060-be9f269e26f4', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'comercial04@healthsafetytech.com', '', '2026-01-22T22:23:11.000Z', '2026-01-22T22:23:11.000Z', '2026-01-23T17:51:08.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Eduardo Luna"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('9cef2497-e2a3-4b18-b6cd-796709dc9096', 'a631e765-8fe9-4c84-a060-be9f269e26f4', '{"sub":"a631e765-8fe9-4c84-a060-be9f269e26f4","email":"comercial04@healthsafetytech.com","email_verified":true}', 'email', 'a631e765-8fe9-4c84-a060-be9f269e26f4', '2026-01-22T22:23:11.000Z', '2026-01-23T17:51:08.000Z', '2026-01-22T22:23:11.000Z');
UPDATE public.profiles SET name = 'Eduardo Luna', cpf = '014353694-08', phone = '819 9919-7982', company_id = '5dc0d6af-ea86-43cb-ab1d-3b231de50834', department_id = '21137faa-f57b-457e-9f20-7faa13b9fc8f' WHERE user_id = 'a631e765-8fe9-4c84-a060-be9f269e26f4';
UPDATE public.user_roles SET company_id = '5dc0d6af-ea86-43cb-ab1d-3b231de50834' WHERE user_id = 'a631e765-8fe9-4c84-a060-be9f269e26f4';

-- Gustavo Oliveira (qualidade02@healthsafetytech.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('76311d30-67a1-4d84-abdf-97e381a2e00d', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'qualidade02@healthsafetytech.com', '', '2026-01-22T22:24:25.000Z', '2026-01-22T22:24:25.000Z', '2026-01-23T17:50:59.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Gustavo Oliveira"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('2bdbf3c6-2102-49e3-a5c6-63b17f0181b7', '76311d30-67a1-4d84-abdf-97e381a2e00d', '{"sub":"76311d30-67a1-4d84-abdf-97e381a2e00d","email":"qualidade02@healthsafetytech.com","email_verified":true}', 'email', '76311d30-67a1-4d84-abdf-97e381a2e00d', '2026-01-22T22:24:25.000Z', '2026-01-23T17:50:59.000Z', '2026-01-22T22:24:25.000Z');
UPDATE public.profiles SET name = 'Gustavo Oliveira', cpf = '137994054-02', phone = '81 98337-9094', company_id = '5dc0d6af-ea86-43cb-ab1d-3b231de50834', department_id = 'dea905ea-2ec3-441a-bbe6-68fce45e0216' WHERE user_id = '76311d30-67a1-4d84-abdf-97e381a2e00d';
UPDATE public.user_roles SET company_id = '5dc0d6af-ea86-43cb-ab1d-3b231de50834' WHERE user_id = '76311d30-67a1-4d84-abdf-97e381a2e00d';

-- Letícia Nunes (servicos02@healthsafetytech.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('2ff5ec92-dd20-433e-9ff9-8e18a7f2b0c6', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'servicos02@healthsafetytech.com', '', '2026-01-22T22:24:49.000Z', '2026-01-22T22:24:49.000Z', '2026-01-23T21:48:20.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Letícia Nunes"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('e98a55d0-110d-48ae-9ca3-50a4bb967faa', '2ff5ec92-dd20-433e-9ff9-8e18a7f2b0c6', '{"sub":"2ff5ec92-dd20-433e-9ff9-8e18a7f2b0c6","email":"servicos02@healthsafetytech.com","email_verified":true}', 'email', '2ff5ec92-dd20-433e-9ff9-8e18a7f2b0c6', '2026-01-22T22:24:49.000Z', '2026-01-23T21:48:20.000Z', '2026-01-23T21:48:20.000Z');
UPDATE public.profiles SET name = 'Letícia Nunes', cpf = '092986114-04', phone = '81 97314-0645', company_id = '5dc0d6af-ea86-43cb-ab1d-3b231de50834', department_id = '966ff0b6-d35f-4d6e-8728-6463b64c20a5' WHERE user_id = '2ff5ec92-dd20-433e-9ff9-8e18a7f2b0c6';
UPDATE public.user_roles SET company_id = '5dc0d6af-ea86-43cb-ab1d-3b231de50834' WHERE user_id = '2ff5ec92-dd20-433e-9ff9-8e18a7f2b0c6';

-- Paulo Henrique (laboratorio02@healthsafetytech.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('b4941eea-04b3-4757-ba28-e41e82b1f6ea', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'laboratorio02@healthsafetytech.com', '', '2026-01-22T22:25:10.000Z', '2026-01-22T22:25:10.000Z', '2026-01-23T17:50:45.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Paulo Henrique"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('5841091d-aa2e-4255-ad60-64181f8587cc', 'b4941eea-04b3-4757-ba28-e41e82b1f6ea', '{"sub":"b4941eea-04b3-4757-ba28-e41e82b1f6ea","email":"laboratorio02@healthsafetytech.com","email_verified":true}', 'email', 'b4941eea-04b3-4757-ba28-e41e82b1f6ea', '2026-01-22T22:25:10.000Z', '2026-01-23T17:50:45.000Z', '2026-01-22T22:25:10.000Z');
UPDATE public.profiles SET name = 'Paulo Henrique', cpf = '110681254-97', phone = '81 99526-6217', company_id = '5dc0d6af-ea86-43cb-ab1d-3b231de50834', department_id = '729499ea-36c5-4dd4-8b8d-1f43037235f4' WHERE user_id = 'b4941eea-04b3-4757-ba28-e41e82b1f6ea';
UPDATE public.user_roles SET company_id = '5dc0d6af-ea86-43cb-ab1d-3b231de50834' WHERE user_id = 'b4941eea-04b3-4757-ba28-e41e82b1f6ea';

-- Lucas Azevedo (expedicao03@healthsafetytech.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('c8d9dfbc-0fcc-43f1-b451-bf073423fd2d', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'expedicao03@healthsafetytech.com', '', '2026-01-22T22:25:38.000Z', '2026-01-22T22:25:38.000Z', '2026-01-23T17:50:37.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Lucas Azevedo"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('312fe360-3e4a-43ab-ab84-21d9924329f4', 'c8d9dfbc-0fcc-43f1-b451-bf073423fd2d', '{"sub":"c8d9dfbc-0fcc-43f1-b451-bf073423fd2d","email":"expedicao03@healthsafetytech.com","email_verified":true}', 'email', 'c8d9dfbc-0fcc-43f1-b451-bf073423fd2d', '2026-01-22T22:25:38.000Z', '2026-01-23T17:50:37.000Z', '2026-01-22T22:25:38.000Z');
UPDATE public.profiles SET name = 'Lucas Azevedo', cpf = '108327804-56', phone = '81 98873-6755', company_id = '5dc0d6af-ea86-43cb-ab1d-3b231de50834', department_id = 'ecbfa438-ecd7-4834-b121-a257457f8436' WHERE user_id = 'c8d9dfbc-0fcc-43f1-b451-bf073423fd2d';
UPDATE public.user_roles SET company_id = '5dc0d6af-ea86-43cb-ab1d-3b231de50834' WHERE user_id = 'c8d9dfbc-0fcc-43f1-b451-bf073423fd2d';

-- Gabriel Moura (suporte01@healthsafetytech.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('cb3085ac-10ac-4560-94b3-2c7e8a5037a1', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'suporte01@healthsafetytech.com', '', '2026-01-22T22:26:07.000Z', '2026-01-22T22:26:07.000Z', '2026-01-23T17:50:31.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Gabriel Moura"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('b96ee54b-84a0-47ae-950f-541d316b8323', 'cb3085ac-10ac-4560-94b3-2c7e8a5037a1', '{"sub":"cb3085ac-10ac-4560-94b3-2c7e8a5037a1","email":"suporte01@healthsafetytech.com","email_verified":true}', 'email', 'cb3085ac-10ac-4560-94b3-2c7e8a5037a1', '2026-01-22T22:26:07.000Z', '2026-01-23T17:50:31.000Z', '2026-01-22T22:26:07.000Z');
UPDATE public.profiles SET name = 'Gabriel Moura', cpf = '131086264-85', phone = '81 99677-7334', company_id = '5dc0d6af-ea86-43cb-ab1d-3b231de50834', department_id = 'c9e183af-3987-4350-92cf-77272d8353fd' WHERE user_id = 'cb3085ac-10ac-4560-94b3-2c7e8a5037a1';
UPDATE public.user_roles SET company_id = '5dc0d6af-ea86-43cb-ab1d-3b231de50834' WHERE user_id = 'cb3085ac-10ac-4560-94b3-2c7e8a5037a1';

-- Lara Cocri (comercial05@healthsafetytech.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('2186f5c1-926b-44a6-bd8e-eec3bdabf459', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'comercial05@healthsafetytech.com', '', '2026-01-22T22:26:26.000Z', '2026-01-22T22:26:26.000Z', '2026-01-23T17:50:25.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Lara Cocri"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('053b4767-8651-4e64-b7c1-17cf35c7fc4a', '2186f5c1-926b-44a6-bd8e-eec3bdabf459', '{"sub":"2186f5c1-926b-44a6-bd8e-eec3bdabf459","email":"comercial05@healthsafetytech.com","email_verified":true}', 'email', '2186f5c1-926b-44a6-bd8e-eec3bdabf459', '2026-01-22T22:26:26.000Z', '2026-01-23T17:50:25.000Z', '2026-01-22T22:26:26.000Z');
UPDATE public.profiles SET name = 'Lara Cocri', cpf = '711439414-46', phone = '81 99829-9288', company_id = '5dc0d6af-ea86-43cb-ab1d-3b231de50834', department_id = '21137faa-f57b-457e-9f20-7faa13b9fc8f' WHERE user_id = '2186f5c1-926b-44a6-bd8e-eec3bdabf459';
UPDATE public.user_roles SET company_id = '5dc0d6af-ea86-43cb-ab1d-3b231de50834' WHERE user_id = '2186f5c1-926b-44a6-bd8e-eec3bdabf459';

-- Suelen Patrícia (suporte02@healthsafetytech.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('d72b135a-66af-4b97-a42b-65ef5cee72af', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'suporte02@healthsafetytech.com', '', '2026-01-22T22:30:45.000Z', '2026-01-22T22:30:45.000Z', '2026-01-23T17:50:18.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Suelen Patrícia"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('40d1599d-6b1a-439a-99f6-c18d44173762', 'd72b135a-66af-4b97-a42b-65ef5cee72af', '{"sub":"d72b135a-66af-4b97-a42b-65ef5cee72af","email":"suporte02@healthsafetytech.com","email_verified":true}', 'email', 'd72b135a-66af-4b97-a42b-65ef5cee72af', '2026-01-22T22:30:45.000Z', '2026-01-23T17:50:18.000Z', '2026-01-22T22:30:45.000Z');
UPDATE public.profiles SET name = 'Suelen Patrícia', cpf = '073031404-92', phone = '81 98691-3498', company_id = '5dc0d6af-ea86-43cb-ab1d-3b231de50834', department_id = 'c9e183af-3987-4350-92cf-77272d8353fd' WHERE user_id = 'd72b135a-66af-4b97-a42b-65ef5cee72af';
UPDATE public.user_roles SET company_id = '5dc0d6af-ea86-43cb-ab1d-3b231de50834' WHERE user_id = 'd72b135a-66af-4b97-a42b-65ef5cee72af';

-- Rickelme David (ti03@healthsafetytech.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('eb957d01-4cbc-4eef-989b-c8ac03da0e96', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'ti03@healthsafetytech.com', '', '2026-01-22T22:31:18.000Z', '2026-01-22T22:31:18.000Z', '2026-01-23T17:50:10.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Rickelme David"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('b8d120c2-e00f-4756-9483-eea93621cf10', 'eb957d01-4cbc-4eef-989b-c8ac03da0e96', '{"sub":"eb957d01-4cbc-4eef-989b-c8ac03da0e96","email":"ti03@healthsafetytech.com","email_verified":true}', 'email', 'eb957d01-4cbc-4eef-989b-c8ac03da0e96', '2026-01-22T22:31:18.000Z', '2026-01-23T17:50:10.000Z', '2026-01-22T22:31:18.000Z');
UPDATE public.profiles SET name = 'Rickelme David', cpf = '131460544-50', phone = '81 99801-7466', company_id = '5dc0d6af-ea86-43cb-ab1d-3b231de50834', department_id = '78f4af47-7aac-4d8a-add9-cdd67edff119' WHERE user_id = 'eb957d01-4cbc-4eef-989b-c8ac03da0e96';
UPDATE public.user_roles SET company_id = '5dc0d6af-ea86-43cb-ab1d-3b231de50834' WHERE user_id = 'eb957d01-4cbc-4eef-989b-c8ac03da0e96';

-- Surama Carvalho Pereira (surama@etcetal.com.br) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('bfd886e6-6482-43c9-875c-9f4cf3b3f244', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'surama@etcetal.com.br', '', '2026-01-22T23:13:06.000Z', '2026-01-22T23:13:06.000Z', '2026-01-23T23:11:06.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Surama Carvalho Pereira"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('7ba02b34-b703-4ed1-95e7-825035164b10', 'bfd886e6-6482-43c9-875c-9f4cf3b3f244', '{"sub":"bfd886e6-6482-43c9-875c-9f4cf3b3f244","email":"surama@etcetal.com.br","email_verified":true}', 'email', 'bfd886e6-6482-43c9-875c-9f4cf3b3f244', '2026-01-22T23:13:06.000Z', '2026-01-23T23:11:06.000Z', '2026-01-23T23:11:07.000Z');
UPDATE public.profiles SET name = 'Surama Carvalho Pereira', cpf = '75818477649', phone = '31991337120', company_id = 'edea5e96-20ea-40a8-8cb8-0988cd74869c' WHERE user_id = 'bfd886e6-6482-43c9-875c-9f4cf3b3f244';
UPDATE public.user_roles SET company_id = 'edea5e96-20ea-40a8-8cb8-0988cd74869c' WHERE user_id = 'bfd886e6-6482-43c9-875c-9f4cf3b3f244';

-- walbert santos (walbertsantos@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('572e96af-f84f-44a3-a86d-c4952df1306c', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'walbertsantos@gmail.com', '', '2026-01-23T19:48:17.000Z', '2026-01-23T19:48:17.000Z', '2026-01-23T20:07:16.000Z', '{"provider":"email","providers":["email"]}', '{"name":"walbert santos"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('5fdd86de-5f91-477b-9285-fb1aff1aedd8', '572e96af-f84f-44a3-a86d-c4952df1306c', '{"sub":"572e96af-f84f-44a3-a86d-c4952df1306c","email":"walbertsantos@gmail.com","email_verified":true}', 'email', '572e96af-f84f-44a3-a86d-c4952df1306c', '2026-01-23T19:48:17.000Z', '2026-01-23T20:07:16.000Z', '2026-01-23T20:07:17.000Z');
UPDATE public.profiles SET name = 'walbert santos', cpf = '02949112439', phone = '8199184565', company_id = '5dc0d6af-ea86-43cb-ab1d-3b231de50834', department_id = '729499ea-36c5-4dd4-8b8d-1f43037235f4' WHERE user_id = '572e96af-f84f-44a3-a86d-c4952df1306c';
UPDATE public.user_roles SET company_id = '5dc0d6af-ea86-43cb-ab1d-3b231de50834' WHERE user_id = '572e96af-f84f-44a3-a86d-c4952df1306c';

-- Lara Leite Duarte Cocri (sdr3@healthsafety.com.br) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('b8e0b154-729d-4fd5-81b6-ee0d2777dca9', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'sdr3@healthsafety.com.br', '', '2026-01-23T20:07:14.000Z', '2026-01-23T20:07:14.000Z', '2026-01-23T20:51:08.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Lara Leite Duarte Cocri"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('f2e0c43e-5cad-45e2-a7a0-7ccf2866335a', 'b8e0b154-729d-4fd5-81b6-ee0d2777dca9', '{"sub":"b8e0b154-729d-4fd5-81b6-ee0d2777dca9","email":"sdr3@healthsafety.com.br","email_verified":true}', 'email', 'b8e0b154-729d-4fd5-81b6-ee0d2777dca9', '2026-01-23T20:07:14.000Z', '2026-01-23T20:51:08.000Z', '2026-01-23T20:51:08.000Z');
UPDATE public.profiles SET name = 'Lara Leite Duarte Cocri', cpf = '71143941446', phone = '81998299288', company_id = '5dc0d6af-ea86-43cb-ab1d-3b231de50834', department_id = '21137faa-f57b-457e-9f20-7faa13b9fc8f' WHERE user_id = 'b8e0b154-729d-4fd5-81b6-ee0d2777dca9';
UPDATE public.user_roles SET company_id = '5dc0d6af-ea86-43cb-ab1d-3b231de50834' WHERE user_id = 'b8e0b154-729d-4fd5-81b6-ee0d2777dca9';

-- Adriana Oliveira da paz  (adriana_diana_oliveira@hotmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('2f663c42-4dd3-4258-ac7f-707446381bc3', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'adriana_diana_oliveira@hotmail.com', '', '2026-01-23T20:15:24.000Z', '2026-01-23T20:15:24.000Z', '2026-01-23T20:48:51.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Adriana Oliveira da paz "}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('f9d04aad-d2d5-44b6-8832-5f56b0bc045f', '2f663c42-4dd3-4258-ac7f-707446381bc3', '{"sub":"2f663c42-4dd3-4258-ac7f-707446381bc3","email":"adriana_diana_oliveira@hotmail.com","email_verified":true}', 'email', '2f663c42-4dd3-4258-ac7f-707446381bc3', '2026-01-23T20:15:24.000Z', '2026-01-23T20:48:51.000Z', '2026-01-23T20:48:51.000Z');
UPDATE public.profiles SET name = 'Adriana Oliveira da paz ', cpf = '10509653456', phone = '81989607280', company_id = '5dc0d6af-ea86-43cb-ab1d-3b231de50834', department_id = '21137faa-f57b-457e-9f20-7faa13b9fc8f' WHERE user_id = '2f663c42-4dd3-4258-ac7f-707446381bc3';
UPDATE public.user_roles SET company_id = '5dc0d6af-ea86-43cb-ab1d-3b231de50834' WHERE user_id = '2f663c42-4dd3-4258-ac7f-707446381bc3';

-- GISLAYNE NUNES  (gynunes62@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('2394f782-59a2-44e1-9dbd-64715b62dc55', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'gynunes62@gmail.com', '', '2026-01-23T20:20:54.000Z', '2026-01-23T20:20:54.000Z', '2026-01-23T21:36:27.000Z', '{"provider":"email","providers":["email"]}', '{"name":"GISLAYNE NUNES "}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('134fe461-f9fb-4fd0-9f73-310a345c28cb', '2394f782-59a2-44e1-9dbd-64715b62dc55', '{"sub":"2394f782-59a2-44e1-9dbd-64715b62dc55","email":"gynunes62@gmail.com","email_verified":true}', 'email', '2394f782-59a2-44e1-9dbd-64715b62dc55', '2026-01-23T20:20:54.000Z', '2026-01-23T21:36:27.000Z', '2026-01-23T21:36:27.000Z');
UPDATE public.profiles SET name = 'GISLAYNE NUNES ', cpf = '08759753480', phone = '81999359090', company_id = '5dc0d6af-ea86-43cb-ab1d-3b231de50834', department_id = '21137faa-f57b-457e-9f20-7faa13b9fc8f' WHERE user_id = '2394f782-59a2-44e1-9dbd-64715b62dc55';
UPDATE public.user_roles SET company_id = '5dc0d6af-ea86-43cb-ab1d-3b231de50834' WHERE user_id = '2394f782-59a2-44e1-9dbd-64715b62dc55';

-- Djalma Neto  (djalmanetobeto@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('88578956-d804-49a2-9c97-2de0317bb444', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'djalmanetobeto@gmail.com', '', '2026-01-23T20:28:44.000Z', '2026-01-23T20:28:44.000Z', '2026-01-23T20:41:40.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Djalma Neto "}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('b15e2372-2df0-4d18-a7c8-378bd240e798', '88578956-d804-49a2-9c97-2de0317bb444', '{"sub":"88578956-d804-49a2-9c97-2de0317bb444","email":"djalmanetobeto@gmail.com","email_verified":true}', 'email', '88578956-d804-49a2-9c97-2de0317bb444', '2026-01-23T20:28:44.000Z', '2026-01-23T20:41:40.000Z', '2026-01-23T20:41:41.000Z');
UPDATE public.profiles SET name = 'Djalma Neto ', cpf = '12249648450', phone = '81997107258', company_id = '5dc0d6af-ea86-43cb-ab1d-3b231de50834', department_id = '19cb9bca-0191-48c3-9538-33b0a4f0ab4d' WHERE user_id = '88578956-d804-49a2-9c97-2de0317bb444';
UPDATE public.user_roles SET company_id = '5dc0d6af-ea86-43cb-ab1d-3b231de50834' WHERE user_id = '88578956-d804-49a2-9c97-2de0317bb444';

-- Sandra Cristina Araujo Silva (sandraa.cristina@hotmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('fc0c12f1-82f3-4a5b-ad14-fc65b5eb35f9', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'sandraa.cristina@hotmail.com', '', '2026-01-23T20:31:11.000Z', '2026-01-23T20:31:11.000Z', '2026-01-23T22:01:17.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Sandra Cristina Araujo Silva"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('a4d28897-5f43-415a-9272-f4069c0ac215', 'fc0c12f1-82f3-4a5b-ad14-fc65b5eb35f9', '{"sub":"fc0c12f1-82f3-4a5b-ad14-fc65b5eb35f9","email":"sandraa.cristina@hotmail.com","email_verified":true}', 'email', 'fc0c12f1-82f3-4a5b-ad14-fc65b5eb35f9', '2026-01-23T20:31:11.000Z', '2026-01-23T22:01:17.000Z', '2026-01-23T22:01:18.000Z');
UPDATE public.profiles SET name = 'Sandra Cristina Araujo Silva', cpf = '02793501476', phone = '81998023555', company_id = '5dc0d6af-ea86-43cb-ab1d-3b231de50834', department_id = '21137faa-f57b-457e-9f20-7faa13b9fc8f' WHERE user_id = 'fc0c12f1-82f3-4a5b-ad14-fc65b5eb35f9';
UPDATE public.user_roles SET company_id = '5dc0d6af-ea86-43cb-ab1d-3b231de50834' WHERE user_id = 'fc0c12f1-82f3-4a5b-ad14-fc65b5eb35f9';

-- Gustavo Oliveira dos Prazeres (gopme12@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('1a679d1f-623d-4bd6-8535-93cd4bafd040', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'gopme12@gmail.com', '', '2026-01-23T20:35:10.000Z', '2026-01-23T20:35:10.000Z', '2026-01-23T21:25:23.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Gustavo Oliveira dos Prazeres"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('873283bc-d1a5-441b-83e3-c525f9fdfc0d', '1a679d1f-623d-4bd6-8535-93cd4bafd040', '{"sub":"1a679d1f-623d-4bd6-8535-93cd4bafd040","email":"gopme12@gmail.com","email_verified":true}', 'email', '1a679d1f-623d-4bd6-8535-93cd4bafd040', '2026-01-23T20:35:10.000Z', '2026-01-23T21:25:23.000Z', '2026-01-23T21:25:23.000Z');
UPDATE public.profiles SET name = 'Gustavo Oliveira dos Prazeres', cpf = '13799405402', phone = '81983379094', company_id = '5dc0d6af-ea86-43cb-ab1d-3b231de50834', department_id = 'dea905ea-2ec3-441a-bbe6-68fce45e0216' WHERE user_id = '1a679d1f-623d-4bd6-8535-93cd4bafd040';
UPDATE public.user_roles SET company_id = '5dc0d6af-ea86-43cb-ab1d-3b231de50834' WHERE user_id = '1a679d1f-623d-4bd6-8535-93cd4bafd040';

-- Welton kellyson da Silva Alves (weltonkellyson24@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('6ec2632c-d87c-46db-ac01-9bbc72deb179', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'weltonkellyson24@gmail.com', '', '2026-01-23T20:41:18.000Z', '2026-01-23T20:41:18.000Z', '2026-01-23T20:59:59.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Welton kellyson da Silva Alves"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('0dddb6f1-0797-4833-8269-c92ca7f1a7a4', '6ec2632c-d87c-46db-ac01-9bbc72deb179', '{"sub":"6ec2632c-d87c-46db-ac01-9bbc72deb179","email":"weltonkellyson24@gmail.com","email_verified":true}', 'email', '6ec2632c-d87c-46db-ac01-9bbc72deb179', '2026-01-23T20:41:18.000Z', '2026-01-23T20:59:59.000Z', '2026-01-23T21:00:00.000Z');
UPDATE public.profiles SET name = 'Welton kellyson da Silva Alves', cpf = '14076366425', phone = '81999018603', company_id = '5dc0d6af-ea86-43cb-ab1d-3b231de50834', department_id = '78f4af47-7aac-4d8a-add9-cdd67edff119' WHERE user_id = '6ec2632c-d87c-46db-ac01-9bbc72deb179';
UPDATE public.user_roles SET company_id = '5dc0d6af-ea86-43cb-ab1d-3b231de50834' WHERE user_id = '6ec2632c-d87c-46db-ac01-9bbc72deb179';

-- Eduardo Luna (sdr1@healthsafety.com.br) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('761db23c-6ac5-4f59-9bc4-9bbbbbb01db7', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'sdr1@healthsafety.com.br', '', '2026-01-23T20:48:16.000Z', '2026-01-23T20:48:16.000Z', '2026-01-23T21:07:09.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Eduardo Luna"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('8f15be05-3379-4d22-aadd-d752d689cd68', '761db23c-6ac5-4f59-9bc4-9bbbbbb01db7', '{"sub":"761db23c-6ac5-4f59-9bc4-9bbbbbb01db7","email":"sdr1@healthsafety.com.br","email_verified":true}', 'email', '761db23c-6ac5-4f59-9bc4-9bbbbbb01db7', '2026-01-23T20:48:16.000Z', '2026-01-23T21:07:09.000Z', '2026-01-23T21:07:09.000Z');
UPDATE public.profiles SET name = 'Eduardo Luna', cpf = '01435369408', phone = '81999197982', company_id = '5dc0d6af-ea86-43cb-ab1d-3b231de50834', department_id = '21137faa-f57b-457e-9f20-7faa13b9fc8f' WHERE user_id = '761db23c-6ac5-4f59-9bc4-9bbbbbb01db7';
UPDATE public.user_roles SET company_id = '5dc0d6af-ea86-43cb-ab1d-3b231de50834' WHERE user_id = '761db23c-6ac5-4f59-9bc4-9bbbbbb01db7';

-- GABRIEL MOURA WANDERLEY DA SILVA (gmswanderley@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('60c06a56-4e25-4289-95d3-5ff2a16d8b87', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'gmswanderley@gmail.com', '', '2026-01-23T21:00:14.000Z', '2026-01-23T21:00:14.000Z', '2026-01-23T22:11:37.000Z', '{"provider":"email","providers":["email"]}', '{"name":"GABRIEL MOURA WANDERLEY DA SILVA"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('6f86e256-ea15-4d40-b569-51cd51d74aab', '60c06a56-4e25-4289-95d3-5ff2a16d8b87', '{"sub":"60c06a56-4e25-4289-95d3-5ff2a16d8b87","email":"gmswanderley@gmail.com","email_verified":true}', 'email', '60c06a56-4e25-4289-95d3-5ff2a16d8b87', '2026-01-23T21:00:14.000Z', '2026-01-23T22:11:37.000Z', '2026-01-23T22:11:37.000Z');
UPDATE public.profiles SET name = 'GABRIEL MOURA WANDERLEY DA SILVA', cpf = '13108626485', phone = '81996774334', company_id = '5dc0d6af-ea86-43cb-ab1d-3b231de50834', department_id = 'c9e183af-3987-4350-92cf-77272d8353fd' WHERE user_id = '60c06a56-4e25-4289-95d3-5ff2a16d8b87';
UPDATE public.user_roles SET company_id = '5dc0d6af-ea86-43cb-ab1d-3b231de50834' WHERE user_id = '60c06a56-4e25-4289-95d3-5ff2a16d8b87';

-- Suelen Patricia Batista De Santana (suelenpatricia957@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('b7f447a9-4008-4d94-a35b-ccf1a5de8427', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'suelenpatricia957@gmail.com', '', '2026-01-23T21:01:31.000Z', '2026-01-23T21:01:31.000Z', '2026-01-24T01:36:59.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Suelen Patricia Batista De Santana"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('d7ef0b13-0518-4419-8587-bd1df19be92f', 'b7f447a9-4008-4d94-a35b-ccf1a5de8427', '{"sub":"b7f447a9-4008-4d94-a35b-ccf1a5de8427","email":"suelenpatricia957@gmail.com","email_verified":true}', 'email', 'b7f447a9-4008-4d94-a35b-ccf1a5de8427', '2026-01-23T21:01:31.000Z', '2026-01-24T01:36:59.000Z', '2026-01-24T01:36:58.000Z');
UPDATE public.profiles SET name = 'Suelen Patricia Batista De Santana', cpf = '07303140492', phone = '81981562774', company_id = '5dc0d6af-ea86-43cb-ab1d-3b231de50834', department_id = 'c9e183af-3987-4350-92cf-77272d8353fd' WHERE user_id = 'b7f447a9-4008-4d94-a35b-ccf1a5de8427';
UPDATE public.user_roles SET company_id = '5dc0d6af-ea86-43cb-ab1d-3b231de50834' WHERE user_id = 'b7f447a9-4008-4d94-a35b-ccf1a5de8427';

-- Rickelme David Silva Cavalcante (rickelmepe@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('c2e453cb-f825-49d1-af71-e04bc106b7cf', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'rickelmepe@gmail.com', '', '2026-01-23T21:03:45.000Z', '2026-01-23T21:03:45.000Z', '2026-01-26T20:20:02.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Rickelme David Silva Cavalcante"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('fed5cbd5-738c-4383-a496-cd80688fec71', 'c2e453cb-f825-49d1-af71-e04bc106b7cf', '{"sub":"c2e453cb-f825-49d1-af71-e04bc106b7cf","email":"rickelmepe@gmail.com","email_verified":true}', 'email', 'c2e453cb-f825-49d1-af71-e04bc106b7cf', '2026-01-23T21:03:45.000Z', '2026-01-26T20:20:02.000Z', '2026-01-26T20:20:02.000Z');
UPDATE public.profiles SET name = 'Rickelme David Silva Cavalcante', cpf = '13146054450', phone = '81998017466', company_id = '5dc0d6af-ea86-43cb-ab1d-3b231de50834', department_id = '78f4af47-7aac-4d8a-add9-cdd67edff119' WHERE user_id = 'c2e453cb-f825-49d1-af71-e04bc106b7cf';
UPDATE public.user_roles SET company_id = '5dc0d6af-ea86-43cb-ab1d-3b231de50834' WHERE user_id = 'c2e453cb-f825-49d1-af71-e04bc106b7cf';

-- Suelen patricia batista de santana (suelenpatricia957@gmai.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('7c442434-07df-44d1-98d9-aa2188fe662e', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'suelenpatricia957@gmai.com', '', '2026-01-23T21:03:57.000Z', '2026-01-23T21:03:57.000Z', '2026-01-23T21:12:23.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Suelen patricia batista de santana"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('f1d6bab5-9647-4281-ae52-be52084b18eb', '7c442434-07df-44d1-98d9-aa2188fe662e', '{"sub":"7c442434-07df-44d1-98d9-aa2188fe662e","email":"suelenpatricia957@gmai.com","email_verified":true}', 'email', '7c442434-07df-44d1-98d9-aa2188fe662e', '2026-01-23T21:03:57.000Z', '2026-01-23T21:12:23.000Z', '2026-01-23T21:12:23.000Z');
UPDATE public.profiles SET name = 'Suelen patricia batista de santana', cpf = '07303140492', phone = '81986913498', company_id = '5dc0d6af-ea86-43cb-ab1d-3b231de50834', department_id = 'c9e183af-3987-4350-92cf-77272d8353fd' WHERE user_id = '7c442434-07df-44d1-98d9-aa2188fe662e';
UPDATE public.user_roles SET company_id = '5dc0d6af-ea86-43cb-ab1d-3b231de50834' WHERE user_id = '7c442434-07df-44d1-98d9-aa2188fe662e';

-- Ellen Elis (ellenelis87@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('5e6f72af-fe12-49c1-ac15-970370a47eba', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'ellenelis87@gmail.com', '', '2026-01-23T21:04:11.000Z', '2026-01-23T21:04:11.000Z', '2026-01-23T22:21:40.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Ellen Elis"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('7e355e6c-d01c-4883-a4d7-a4d815595051', '5e6f72af-fe12-49c1-ac15-970370a47eba', '{"sub":"5e6f72af-fe12-49c1-ac15-970370a47eba","email":"ellenelis87@gmail.com","email_verified":true}', 'email', '5e6f72af-fe12-49c1-ac15-970370a47eba', '2026-01-23T21:04:11.000Z', '2026-01-23T22:21:40.000Z', '2026-01-23T22:21:41.000Z');
UPDATE public.profiles SET name = 'Ellen Elis', cpf = '70788486403', phone = '81988198651', company_id = '5dc0d6af-ea86-43cb-ab1d-3b231de50834', department_id = '966ff0b6-d35f-4d6e-8728-6463b64c20a5' WHERE user_id = '5e6f72af-fe12-49c1-ac15-970370a47eba';
UPDATE public.user_roles SET company_id = '5dc0d6af-ea86-43cb-ab1d-3b231de50834' WHERE user_id = '5e6f72af-fe12-49c1-ac15-970370a47eba';

-- Lucas azevedo da silva  (lucas.azevedo3009@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('a776e5ff-4add-422d-9e0a-af6e4c33197b', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'lucas.azevedo3009@gmail.com', '', '2026-01-23T21:06:27.000Z', '2026-01-23T21:06:27.000Z', '2026-01-23T21:20:18.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Lucas azevedo da silva "}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('14302b49-c797-4ae5-8453-63f41f6d7a42', 'a776e5ff-4add-422d-9e0a-af6e4c33197b', '{"sub":"a776e5ff-4add-422d-9e0a-af6e4c33197b","email":"lucas.azevedo3009@gmail.com","email_verified":true}', 'email', 'a776e5ff-4add-422d-9e0a-af6e4c33197b', '2026-01-23T21:06:27.000Z', '2026-01-23T21:20:18.000Z', '2026-01-23T21:20:18.000Z');
UPDATE public.profiles SET name = 'Lucas azevedo da silva ', cpf = '10832780456', phone = '81988736755', company_id = '5dc0d6af-ea86-43cb-ab1d-3b231de50834', department_id = 'ecbfa438-ecd7-4834-b121-a257457f8436' WHERE user_id = 'a776e5ff-4add-422d-9e0a-af6e4c33197b';
UPDATE public.user_roles SET company_id = '5dc0d6af-ea86-43cb-ab1d-3b231de50834' WHERE user_id = 'a776e5ff-4add-422d-9e0a-af6e4c33197b';

-- Leandro Victor Da Silva (leandroepronto3.1lvs@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('90fb9c09-8a75-47aa-9759-384f98e8b253', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'leandroepronto3.1lvs@gmail.com', '', '2026-01-23T22:20:24.000Z', '2026-01-23T22:20:24.000Z', '2026-01-25T01:51:07.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Leandro Victor Da Silva"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('7c9ea661-33db-4e07-9894-5eca3f89389e', '90fb9c09-8a75-47aa-9759-384f98e8b253', '{"sub":"90fb9c09-8a75-47aa-9759-384f98e8b253","email":"leandroepronto3.1lvs@gmail.com","email_verified":true}', 'email', '90fb9c09-8a75-47aa-9759-384f98e8b253', '2026-01-23T22:20:24.000Z', '2026-01-25T01:51:07.000Z', '2026-01-25T01:51:07.000Z');
UPDATE public.profiles SET name = 'Leandro Victor Da Silva', cpf = '03391054450', phone = '81988720636', company_id = '5dc0d6af-ea86-43cb-ab1d-3b231de50834', department_id = 'ecbfa438-ecd7-4834-b121-a257457f8436' WHERE user_id = '90fb9c09-8a75-47aa-9759-384f98e8b253';
UPDATE public.user_roles SET company_id = '5dc0d6af-ea86-43cb-ab1d-3b231de50834' WHERE user_id = '90fb9c09-8a75-47aa-9759-384f98e8b253';

-- Fabiano diniz santos (fabianodinizsantos@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('2347b752-02e5-438f-9962-76a814f1a18c', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'fabianodinizsantos@gmail.com', '', '2026-01-24T23:30:31.000Z', '2026-01-24T23:30:31.000Z', '2026-01-24T23:32:18.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Fabiano diniz santos"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('b99f89ad-7d85-47b5-9d43-3b8f0c5d3578', '2347b752-02e5-438f-9962-76a814f1a18c', '{"sub":"2347b752-02e5-438f-9962-76a814f1a18c","email":"fabianodinizsantos@gmail.com","email_verified":true}', 'email', '2347b752-02e5-438f-9962-76a814f1a18c', '2026-01-24T23:30:31.000Z', '2026-01-24T23:32:18.000Z', '2026-01-24T23:32:18.000Z');
UPDATE public.profiles SET name = 'Fabiano diniz santos', cpf = '00826320651', phone = '31991845450', company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '2347b752-02e5-438f-9962-76a814f1a18c';
UPDATE public.user_roles SET company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '2347b752-02e5-438f-9962-76a814f1a18c';

-- Rogério Caetano (rgcaetanofujitsu@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('fbc506eb-adea-4e1f-bcbf-10198c72914e', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'rgcaetanofujitsu@gmail.com', '', '2026-01-24T23:30:34.000Z', '2026-01-24T23:30:34.000Z', '2026-01-25T15:34:36.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Rogério Caetano"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('6ac3a329-44da-44f7-afe5-ed882d8056f7', 'fbc506eb-adea-4e1f-bcbf-10198c72914e', '{"sub":"fbc506eb-adea-4e1f-bcbf-10198c72914e","email":"rgcaetanofujitsu@gmail.com","email_verified":true}', 'email', 'fbc506eb-adea-4e1f-bcbf-10198c72914e', '2026-01-24T23:30:34.000Z', '2026-01-25T15:34:36.000Z', '2026-01-25T15:34:37.000Z');
UPDATE public.profiles SET name = 'Rogério Caetano', cpf = '12504640803', phone = '11940847476', company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = 'fbc506eb-adea-4e1f-bcbf-10198c72914e';
UPDATE public.user_roles SET company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = 'fbc506eb-adea-4e1f-bcbf-10198c72914e';

-- GIANCARLO DAL MULIN (giancarlodalmulin@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('e73dc61f-1f7b-4fcb-85a7-25eefaeb0022', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'giancarlodalmulin@gmail.com', '', '2026-01-24T23:30:41.000Z', '2026-01-24T23:30:41.000Z', '2026-01-28T23:21:17.000Z', '{"provider":"email","providers":["email"]}', '{"name":"GIANCARLO DAL MULIN"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('d30bfc30-5a55-45b3-972b-108f0a5b6a9e', 'e73dc61f-1f7b-4fcb-85a7-25eefaeb0022', '{"sub":"e73dc61f-1f7b-4fcb-85a7-25eefaeb0022","email":"giancarlodalmulin@gmail.com","email_verified":true}', 'email', 'e73dc61f-1f7b-4fcb-85a7-25eefaeb0022', '2026-01-24T23:30:41.000Z', '2026-01-28T23:21:17.000Z', '2026-01-28T23:21:17.000Z');
UPDATE public.profiles SET name = 'GIANCARLO DAL MULIN', cpf = '95307982020', phone = '51997075248', company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = 'e73dc61f-1f7b-4fcb-85a7-25eefaeb0022';
UPDATE public.user_roles SET company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = 'e73dc61f-1f7b-4fcb-85a7-25eefaeb0022';

-- Rodrigo Araujo (ronetju2019@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('8ea8d77d-89c3-4c2b-a747-f88cc51a225e', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'ronetju2019@gmail.com', '', '2026-01-24T23:30:46.000Z', '2026-01-24T23:30:46.000Z', '2026-01-25T15:30:01.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Rodrigo Araujo"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('03864d4f-2031-4edb-8d6f-1972835bb327', '8ea8d77d-89c3-4c2b-a747-f88cc51a225e', '{"sub":"8ea8d77d-89c3-4c2b-a747-f88cc51a225e","email":"ronetju2019@gmail.com","email_verified":true}', 'email', '8ea8d77d-89c3-4c2b-a747-f88cc51a225e', '2026-01-24T23:30:46.000Z', '2026-01-25T15:30:01.000Z', '2026-01-25T15:30:02.000Z');
UPDATE public.profiles SET name = 'Rodrigo Araujo', cpf = '08131149773', phone = '27997300312', company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '8ea8d77d-89c3-4c2b-a747-f88cc51a225e';
UPDATE public.user_roles SET company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '8ea8d77d-89c3-4c2b-a747-f88cc51a225e';

-- VALERIA MARTA  (valeria.educacional@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('a4279c16-27be-4665-97ec-a09e2b614b1b', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'valeria.educacional@gmail.com', '', '2026-01-24T23:30:49.000Z', '2026-01-24T23:30:49.000Z', '2026-01-24T23:32:40.000Z', '{"provider":"email","providers":["email"]}', '{"name":"VALERIA MARTA "}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('f3e1f3a2-40dd-41d4-9c81-0100282f63a3', 'a4279c16-27be-4665-97ec-a09e2b614b1b', '{"sub":"a4279c16-27be-4665-97ec-a09e2b614b1b","email":"valeria.educacional@gmail.com","email_verified":true}', 'email', 'a4279c16-27be-4665-97ec-a09e2b614b1b', '2026-01-24T23:30:49.000Z', '2026-01-24T23:32:40.000Z', '2026-01-24T23:32:40.000Z');
UPDATE public.profiles SET name = 'VALERIA MARTA ', cpf = '95609172691', phone = '31996218864', company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = 'a4279c16-27be-4665-97ec-a09e2b614b1b';
UPDATE public.user_roles SET company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = 'a4279c16-27be-4665-97ec-a09e2b614b1b';

-- Andreia Aparecida Rangel Santos (dede_rangel@yahoo.com.br) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('64cf5636-a300-407c-8b69-5f04118f38c5', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'dede_rangel@yahoo.com.br', '', '2026-01-24T23:30:50.000Z', '2026-01-24T23:30:50.000Z', '2026-01-26T15:19:30.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Andreia Aparecida Rangel Santos"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('5991a179-975e-4a16-9b28-e27ffe236cba', '64cf5636-a300-407c-8b69-5f04118f38c5', '{"sub":"64cf5636-a300-407c-8b69-5f04118f38c5","email":"dede_rangel@yahoo.com.br","email_verified":true}', 'email', '64cf5636-a300-407c-8b69-5f04118f38c5', '2026-01-24T23:30:50.000Z', '2026-01-26T15:19:30.000Z', '2026-01-26T15:19:30.000Z');
UPDATE public.profiles SET name = 'Andreia Aparecida Rangel Santos', cpf = '32985600812', phone = '11975952053', company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '64cf5636-a300-407c-8b69-5f04118f38c5';
UPDATE public.user_roles SET company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '64cf5636-a300-407c-8b69-5f04118f38c5';

-- Renato Corrêa Magalhães de Paula (renato.correa@oktz.com.br) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('2d7ed9b2-c3e2-4a5b-a0fa-d85469d75ddd', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'renato.correa@oktz.com.br', '', '2026-01-24T23:30:51.000Z', '2026-01-24T23:30:51.000Z', '2026-01-27T17:21:59.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Renato Corrêa Magalhães de Paula"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('880cdd68-9375-4ba3-b643-8903574fe24a', '2d7ed9b2-c3e2-4a5b-a0fa-d85469d75ddd', '{"sub":"2d7ed9b2-c3e2-4a5b-a0fa-d85469d75ddd","email":"renato.correa@oktz.com.br","email_verified":true}', 'email', '2d7ed9b2-c3e2-4a5b-a0fa-d85469d75ddd', '2026-01-24T23:30:51.000Z', '2026-01-27T17:21:59.000Z', '2026-01-27T17:21:58.000Z');
UPDATE public.profiles SET name = 'Renato Corrêa Magalhães de Paula', cpf = '05451677603', phone = '31996161869', company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '2d7ed9b2-c3e2-4a5b-a0fa-d85469d75ddd';
UPDATE public.user_roles SET company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '2d7ed9b2-c3e2-4a5b-a0fa-d85469d75ddd';

-- Eduardo Guietti (institutoalupo@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('310ee73e-88d1-4816-91e3-1b7e53fe1a8c', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'institutoalupo@gmail.com', '', '2026-01-24T23:30:59.000Z', '2026-01-24T23:30:59.000Z', '2026-01-24T23:36:28.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Eduardo Guietti"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('ecc0e638-bec0-4417-b9b9-29df6300506c', '310ee73e-88d1-4816-91e3-1b7e53fe1a8c', '{"sub":"310ee73e-88d1-4816-91e3-1b7e53fe1a8c","email":"institutoalupo@gmail.com","email_verified":true}', 'email', '310ee73e-88d1-4816-91e3-1b7e53fe1a8c', '2026-01-24T23:30:59.000Z', '2026-01-24T23:36:28.000Z', '2026-01-24T23:36:29.000Z');
UPDATE public.profiles SET name = 'Eduardo Guietti', cpf = '34930836883', phone = '31997024172', company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '310ee73e-88d1-4816-91e3-1b7e53fe1a8c';
UPDATE public.user_roles SET company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '310ee73e-88d1-4816-91e3-1b7e53fe1a8c';

-- Fabio Marques Ferreira (fabio.marfer@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('9cdb3c3e-f353-45ce-95c5-f6d6adc15eca', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'fabio.marfer@gmail.com', '', '2026-01-24T23:31:05.000Z', '2026-01-24T23:31:05.000Z', '2026-01-25T19:49:50.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Fabio Marques Ferreira"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('e97d32ce-2683-4163-a792-803b0936b435', '9cdb3c3e-f353-45ce-95c5-f6d6adc15eca', '{"sub":"9cdb3c3e-f353-45ce-95c5-f6d6adc15eca","email":"fabio.marfer@gmail.com","email_verified":true}', 'email', '9cdb3c3e-f353-45ce-95c5-f6d6adc15eca', '2026-01-24T23:31:05.000Z', '2026-01-25T19:49:50.000Z', '2026-01-25T19:49:50.000Z');
UPDATE public.profiles SET name = 'Fabio Marques Ferreira', cpf = '37892348859', phone = '11985214694', company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '9cdb3c3e-f353-45ce-95c5-f6d6adc15eca';
UPDATE public.user_roles SET company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '9cdb3c3e-f353-45ce-95c5-f6d6adc15eca';

-- José Welinton da Silva  (welintonsilva690@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('34efb53e-b209-4518-a4b8-0279182daf2b', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'welintonsilva690@gmail.com', '', '2026-01-24T23:31:09.000Z', '2026-01-24T23:31:09.000Z', '2026-01-25T16:25:12.000Z', '{"provider":"email","providers":["email"]}', '{"name":"José Welinton da Silva "}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('6935bc54-0e06-453e-9464-38fbd45fceb4', '34efb53e-b209-4518-a4b8-0279182daf2b', '{"sub":"34efb53e-b209-4518-a4b8-0279182daf2b","email":"welintonsilva690@gmail.com","email_verified":true}', 'email', '34efb53e-b209-4518-a4b8-0279182daf2b', '2026-01-24T23:31:09.000Z', '2026-01-25T16:25:12.000Z', '2026-01-25T16:25:12.000Z');
UPDATE public.profiles SET name = 'José Welinton da Silva ', cpf = '12363680456', phone = '84988077198', company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '34efb53e-b209-4518-a4b8-0279182daf2b';
UPDATE public.user_roles SET company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '34efb53e-b209-4518-a4b8-0279182daf2b';

-- Manoel Juarez de Alencar Souza Junior (jrmagrafil@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('a4000e35-eda3-4888-bd0d-463b2d752d89', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'jrmagrafil@gmail.com', '', '2026-01-24T23:31:14.000Z', '2026-01-24T23:31:14.000Z', '2026-01-25T00:15:41.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Manoel Juarez de Alencar Souza Junior"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('13b59681-f67a-4f1a-9b3d-d085a1cb8768', 'a4000e35-eda3-4888-bd0d-463b2d752d89', '{"sub":"a4000e35-eda3-4888-bd0d-463b2d752d89","email":"jrmagrafil@gmail.com","email_verified":true}', 'email', 'a4000e35-eda3-4888-bd0d-463b2d752d89', '2026-01-24T23:31:14.000Z', '2026-01-25T00:15:41.000Z', '2026-01-25T00:15:42.000Z');
UPDATE public.profiles SET name = 'Manoel Juarez de Alencar Souza Junior', cpf = '03665748330', phone = '86999010947', company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = 'a4000e35-eda3-4888-bd0d-463b2d752d89';
UPDATE public.user_roles SET company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = 'a4000e35-eda3-4888-bd0d-463b2d752d89';

-- Maria Regina Alcantara (lua77@uol.com.br) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('892d9946-e824-41c9-934a-30cbec8586be', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'lua77@uol.com.br', '', '2026-01-24T23:31:18.000Z', '2026-01-24T23:31:18.000Z', '2026-01-26T01:23:51.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Maria Regina Alcantara"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('2f768fde-4a2e-44f8-843e-807eecc1c3cc', '892d9946-e824-41c9-934a-30cbec8586be', '{"sub":"892d9946-e824-41c9-934a-30cbec8586be","email":"lua77@uol.com.br","email_verified":true}', 'email', '892d9946-e824-41c9-934a-30cbec8586be', '2026-01-24T23:31:18.000Z', '2026-01-26T01:23:51.000Z', '2026-01-26T01:23:51.000Z');
UPDATE public.profiles SET name = 'Maria Regina Alcantara', cpf = '10580544818', phone = '11949917008', company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '892d9946-e824-41c9-934a-30cbec8586be';
UPDATE public.user_roles SET company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '892d9946-e824-41c9-934a-30cbec8586be';

-- MARCO ANTONIO MARTINS DE OLIVEIRA JUNIOR (Marcoamojr@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('1051abd0-26d7-44ba-9f69-c076e8b6b265', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'Marcoamojr@gmail.com', '', '2026-01-24T23:31:25.000Z', '2026-01-24T23:31:25.000Z', '2026-01-25T15:21:58.000Z', '{"provider":"email","providers":["email"]}', '{"name":"MARCO ANTONIO MARTINS DE OLIVEIRA JUNIOR"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('4e142eac-43f8-4303-ad1e-b85bc64bebd7', '1051abd0-26d7-44ba-9f69-c076e8b6b265', '{"sub":"1051abd0-26d7-44ba-9f69-c076e8b6b265","email":"Marcoamojr@gmail.com","email_verified":true}', 'email', '1051abd0-26d7-44ba-9f69-c076e8b6b265', '2026-01-24T23:31:25.000Z', '2026-01-25T15:21:58.000Z', '2026-01-25T15:21:58.000Z');
UPDATE public.profiles SET name = 'MARCO ANTONIO MARTINS DE OLIVEIRA JUNIOR', cpf = '02589640579', phone = '73998100641', company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '1051abd0-26d7-44ba-9f69-c076e8b6b265';
UPDATE public.user_roles SET company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '1051abd0-26d7-44ba-9f69-c076e8b6b265';

-- JULIANA COSTA CAMPOS (julianacosta_15@hotmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('1ff80f93-8e48-410e-b0aa-6dfaf8756beb', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'julianacosta_15@hotmail.com', '', '2026-01-24T23:31:34.000Z', '2026-01-24T23:31:34.000Z', '2026-01-24T23:58:39.000Z', '{"provider":"email","providers":["email"]}', '{"name":"JULIANA COSTA CAMPOS"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('983a8949-61e8-4c7c-a77b-1cb516407934', '1ff80f93-8e48-410e-b0aa-6dfaf8756beb', '{"sub":"1ff80f93-8e48-410e-b0aa-6dfaf8756beb","email":"julianacosta_15@hotmail.com","email_verified":true}', 'email', '1ff80f93-8e48-410e-b0aa-6dfaf8756beb', '2026-01-24T23:31:34.000Z', '2026-01-24T23:58:39.000Z', '2026-01-24T23:58:39.000Z');
UPDATE public.profiles SET name = 'JULIANA COSTA CAMPOS', cpf = '00949081175', phone = '62993056929', company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '1ff80f93-8e48-410e-b0aa-6dfaf8756beb';
UPDATE public.user_roles SET company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '1ff80f93-8e48-410e-b0aa-6dfaf8756beb';

-- Fernanda Arceno (fernanda_arceno@hotmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('63a26924-a70b-4a8e-a9e9-9b8849f05cf9', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'fernanda_arceno@hotmail.com', '', '2026-01-24T23:31:43.000Z', '2026-01-24T23:31:43.000Z', '2026-01-25T21:28:00.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Fernanda Arceno"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('3cb06faa-c78c-45e1-968b-1b8922f9e3bb', '63a26924-a70b-4a8e-a9e9-9b8849f05cf9', '{"sub":"63a26924-a70b-4a8e-a9e9-9b8849f05cf9","email":"fernanda_arceno@hotmail.com","email_verified":true}', 'email', '63a26924-a70b-4a8e-a9e9-9b8849f05cf9', '2026-01-24T23:31:43.000Z', '2026-01-25T21:28:00.000Z', '2026-01-25T21:28:00.000Z');
UPDATE public.profiles SET name = 'Fernanda Arceno', cpf = '11319701957', phone = '48991606346', company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '63a26924-a70b-4a8e-a9e9-9b8849f05cf9';
UPDATE public.user_roles SET company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '63a26924-a70b-4a8e-a9e9-9b8849f05cf9';

-- Mauricio Silva (mauriciosilva1590@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('0d67d27a-b042-4f0d-ae75-d04324408045', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'mauriciosilva1590@gmail.com', '', '2026-01-24T23:31:45.000Z', '2026-01-24T23:31:45.000Z', '2026-01-25T04:21:33.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Mauricio Silva"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('8b560096-0c81-4c6b-880d-eff802d99799', '0d67d27a-b042-4f0d-ae75-d04324408045', '{"sub":"0d67d27a-b042-4f0d-ae75-d04324408045","email":"mauriciosilva1590@gmail.com","email_verified":true}', 'email', '0d67d27a-b042-4f0d-ae75-d04324408045', '2026-01-24T23:31:45.000Z', '2026-01-25T04:21:33.000Z', '2026-01-25T04:21:33.000Z');
UPDATE public.profiles SET name = 'Mauricio Silva', cpf = '86288960586', phone = '71992781850', company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '0d67d27a-b042-4f0d-ae75-d04324408045';
UPDATE public.user_roles SET company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '0d67d27a-b042-4f0d-ae75-d04324408045';

-- AMILTON GUEDES SOARES FREITAS (amiltonguedes2009@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('e2e7483c-18ce-4f39-94f2-3f6809337f9e', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'amiltonguedes2009@gmail.com', '', '2026-01-24T23:31:47.000Z', '2026-01-24T23:31:47.000Z', '2026-01-26T22:58:39.000Z', '{"provider":"email","providers":["email"]}', '{"name":"AMILTON GUEDES SOARES FREITAS"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('177d93ad-43d5-44ec-b316-72672a052e52', 'e2e7483c-18ce-4f39-94f2-3f6809337f9e', '{"sub":"e2e7483c-18ce-4f39-94f2-3f6809337f9e","email":"amiltonguedes2009@gmail.com","email_verified":true}', 'email', 'e2e7483c-18ce-4f39-94f2-3f6809337f9e', '2026-01-24T23:31:47.000Z', '2026-01-26T22:58:39.000Z', '2026-01-26T22:58:39.000Z');
UPDATE public.profiles SET name = 'AMILTON GUEDES SOARES FREITAS', cpf = '29549473813', phone = '41998325865', company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = 'e2e7483c-18ce-4f39-94f2-3f6809337f9e';
UPDATE public.user_roles SET company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = 'e2e7483c-18ce-4f39-94f2-3f6809337f9e';

-- Vinícius Leal Faria (viniciusleal@ymail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('bc6cfff8-99e6-430f-80be-3c791bf848e7', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'viniciusleal@ymail.com', '', '2026-01-24T23:31:48.000Z', '2026-01-24T23:31:48.000Z', '2026-01-24T23:33:16.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Vinícius Leal Faria"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('33733fb7-6a05-4f81-8a11-7109d69149f7', 'bc6cfff8-99e6-430f-80be-3c791bf848e7', '{"sub":"bc6cfff8-99e6-430f-80be-3c791bf848e7","email":"viniciusleal@ymail.com","email_verified":true}', 'email', 'bc6cfff8-99e6-430f-80be-3c791bf848e7', '2026-01-24T23:31:48.000Z', '2026-01-24T23:33:16.000Z', '2026-01-24T23:33:17.000Z');
UPDATE public.profiles SET name = 'Vinícius Leal Faria', cpf = '05134634610', phone = '32988434656', company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = 'bc6cfff8-99e6-430f-80be-3c791bf848e7';
UPDATE public.user_roles SET company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = 'bc6cfff8-99e6-430f-80be-3c791bf848e7';

-- Gilberto Luis maranhao (gilberto.maranhao78@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('ff575eeb-97c1-4452-a214-981e25c09ba9', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'gilberto.maranhao78@gmail.com', '', '2026-01-24T23:32:01.000Z', '2026-01-24T23:32:01.000Z', '2026-01-26T18:28:44.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Gilberto Luis maranhao"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('e11338e3-fa76-4d09-abbe-c05441ccbeeb', 'ff575eeb-97c1-4452-a214-981e25c09ba9', '{"sub":"ff575eeb-97c1-4452-a214-981e25c09ba9","email":"gilberto.maranhao78@gmail.com","email_verified":true}', 'email', 'ff575eeb-97c1-4452-a214-981e25c09ba9', '2026-01-24T23:32:01.000Z', '2026-01-26T18:28:44.000Z', '2026-01-26T18:28:43.000Z');
UPDATE public.profiles SET name = 'Gilberto Luis maranhao', cpf = '27262598805', phone = '12991842761', company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = 'ff575eeb-97c1-4452-a214-981e25c09ba9';
UPDATE public.user_roles SET company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = 'ff575eeb-97c1-4452-a214-981e25c09ba9';

-- Jocemar Martins Calado (jocemarmartinscalado@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('55c94483-1721-4670-bec2-3cce39309ad8', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'jocemarmartinscalado@gmail.com', '', '2026-01-24T23:32:10.000Z', '2026-01-24T23:32:10.000Z', '2026-01-25T17:00:47.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Jocemar Martins Calado"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('169f4dd4-f672-4c09-83b4-ac1dc8f91bb3', '55c94483-1721-4670-bec2-3cce39309ad8', '{"sub":"55c94483-1721-4670-bec2-3cce39309ad8","email":"jocemarmartinscalado@gmail.com","email_verified":true}', 'email', '55c94483-1721-4670-bec2-3cce39309ad8', '2026-01-24T23:32:10.000Z', '2026-01-25T17:00:47.000Z', '2026-01-25T17:00:47.000Z');
UPDATE public.profiles SET name = 'Jocemar Martins Calado', cpf = '62279181487', phone = '85999565378', company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '55c94483-1721-4670-bec2-3cce39309ad8';
UPDATE public.user_roles SET company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '55c94483-1721-4670-bec2-3cce39309ad8';

-- Ricardo Akiyo Minasse Tomita  (ricardo.a.m.tomita@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('521cbb06-f7b7-4bbb-bf7e-416690e8a196', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'ricardo.a.m.tomita@gmail.com', '', '2026-01-24T23:32:11.000Z', '2026-01-24T23:32:11.000Z', '2026-01-29T00:41:19.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Ricardo Akiyo Minasse Tomita "}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('0dc8177b-806e-4720-aa98-145ca00e1b4e', '521cbb06-f7b7-4bbb-bf7e-416690e8a196', '{"sub":"521cbb06-f7b7-4bbb-bf7e-416690e8a196","email":"ricardo.a.m.tomita@gmail.com","email_verified":true}', 'email', '521cbb06-f7b7-4bbb-bf7e-416690e8a196', '2026-01-24T23:32:11.000Z', '2026-01-29T00:41:19.000Z', '2026-01-29T00:41:18.000Z');
UPDATE public.profiles SET name = 'Ricardo Akiyo Minasse Tomita ', cpf = '46886895869', phone = '11993918554', company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '521cbb06-f7b7-4bbb-bf7e-416690e8a196';
UPDATE public.user_roles SET company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '521cbb06-f7b7-4bbb-bf7e-416690e8a196';

-- Livia (ljordaosilva@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('3083d0f3-3401-4730-be53-b63a16a1b7e8', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'ljordaosilva@gmail.com', '', '2026-01-24T23:32:16.000Z', '2026-01-24T23:32:16.000Z', '2026-01-24T23:32:23.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Livia"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('30414c3f-4d4d-4298-a509-93dcf15f2ded', '3083d0f3-3401-4730-be53-b63a16a1b7e8', '{"sub":"3083d0f3-3401-4730-be53-b63a16a1b7e8","email":"ljordaosilva@gmail.com","email_verified":true}', 'email', '3083d0f3-3401-4730-be53-b63a16a1b7e8', '2026-01-24T23:32:16.000Z', '2026-01-24T23:32:23.000Z', '2026-01-24T23:32:24.000Z');
UPDATE public.profiles SET name = 'Livia', cpf = '08974814617', phone = '3291197382', company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '3083d0f3-3401-4730-be53-b63a16a1b7e8';
UPDATE public.user_roles SET company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '3083d0f3-3401-4730-be53-b63a16a1b7e8';

-- MARCELO NOVAES PUGLIESI (marpugliesi@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('0587beef-8098-4d05-98d3-bf3ac30c1cc7', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'marpugliesi@gmail.com', '', '2026-01-24T23:32:19.000Z', '2026-01-24T23:32:19.000Z', '2026-01-24T23:32:29.000Z', '{"provider":"email","providers":["email"]}', '{"name":"MARCELO NOVAES PUGLIESI"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('e03cd182-c3a1-4346-a340-a5c431971da9', '0587beef-8098-4d05-98d3-bf3ac30c1cc7', '{"sub":"0587beef-8098-4d05-98d3-bf3ac30c1cc7","email":"marpugliesi@gmail.com","email_verified":true}', 'email', '0587beef-8098-4d05-98d3-bf3ac30c1cc7', '2026-01-24T23:32:19.000Z', '2026-01-24T23:32:29.000Z', '2026-01-24T23:32:29.000Z');
UPDATE public.profiles SET name = 'MARCELO NOVAES PUGLIESI', cpf = '71879005115', phone = '67992218655', company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '0587beef-8098-4d05-98d3-bf3ac30c1cc7';
UPDATE public.user_roles SET company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '0587beef-8098-4d05-98d3-bf3ac30c1cc7';

-- Pedro Victor Silva Moraes (pedro@reclick.com.br) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('2a765679-d6ee-422f-a6d3-885e35b3f3d2', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'pedro@reclick.com.br', '', '2026-01-24T23:32:19.000Z', '2026-01-24T23:32:19.000Z', '2026-01-24T23:36:34.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Pedro Victor Silva Moraes"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('7778b734-e997-4100-8bdc-254bfe6ef0a1', '2a765679-d6ee-422f-a6d3-885e35b3f3d2', '{"sub":"2a765679-d6ee-422f-a6d3-885e35b3f3d2","email":"pedro@reclick.com.br","email_verified":true}', 'email', '2a765679-d6ee-422f-a6d3-885e35b3f3d2', '2026-01-24T23:32:19.000Z', '2026-01-24T23:36:34.000Z', '2026-01-24T23:36:35.000Z');
UPDATE public.profiles SET name = 'Pedro Victor Silva Moraes', cpf = '10724912657', phone = '31991208164', company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '2a765679-d6ee-422f-a6d3-885e35b3f3d2';
UPDATE public.user_roles SET company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '2a765679-d6ee-422f-a6d3-885e35b3f3d2';

-- Fabiana Monteiro Santiago Cardoso (fabmontsant@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('92f1a6d1-947b-46ee-a341-78454e83e562', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'fabmontsant@gmail.com', '', '2026-01-24T23:32:22.000Z', '2026-01-24T23:32:22.000Z', '2026-01-27T23:34:15.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Fabiana Monteiro Santiago Cardoso"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('a8542c9b-c147-46da-a494-14b767727993', '92f1a6d1-947b-46ee-a341-78454e83e562', '{"sub":"92f1a6d1-947b-46ee-a341-78454e83e562","email":"fabmontsant@gmail.com","email_verified":true}', 'email', '92f1a6d1-947b-46ee-a341-78454e83e562', '2026-01-24T23:32:22.000Z', '2026-01-27T23:34:15.000Z', '2026-01-27T23:34:14.000Z');
UPDATE public.profiles SET name = 'Fabiana Monteiro Santiago Cardoso', cpf = '03075862606', phone = '35999726850', company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '92f1a6d1-947b-46ee-a341-78454e83e562';
UPDATE public.user_roles SET company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '92f1a6d1-947b-46ee-a341-78454e83e562';

-- ANDRE RODRIGUES MANGINI (europalugares@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('bb631b8d-1d7e-4dca-9bc3-2945e94a1864', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'europalugares@gmail.com', '', '2026-01-24T23:32:22.000Z', '2026-01-24T23:32:22.000Z', '2026-01-24T23:56:24.000Z', '{"provider":"email","providers":["email"]}', '{"name":"ANDRE RODRIGUES MANGINI"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('a73afa90-a5f7-45f2-845a-9b53644fb5fe', 'bb631b8d-1d7e-4dca-9bc3-2945e94a1864', '{"sub":"bb631b8d-1d7e-4dca-9bc3-2945e94a1864","email":"europalugares@gmail.com","email_verified":true}', 'email', 'bb631b8d-1d7e-4dca-9bc3-2945e94a1864', '2026-01-24T23:32:22.000Z', '2026-01-24T23:56:24.000Z', '2026-01-24T23:56:24.000Z');
UPDATE public.profiles SET name = 'ANDRE RODRIGUES MANGINI', cpf = '02813680745', phone = '21981406866', company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = 'bb631b8d-1d7e-4dca-9bc3-2945e94a1864';
UPDATE public.user_roles SET company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = 'bb631b8d-1d7e-4dca-9bc3-2945e94a1864';

-- Luis Gildevam Rodrigues de Lima Junior (gildevamjunior@hotmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('85b7674a-e934-4059-ba67-8e0a8941839a', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'gildevamjunior@hotmail.com', '', '2026-01-24T23:32:23.000Z', '2026-01-24T23:32:23.000Z', '2026-01-25T09:28:03.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Luis Gildevam Rodrigues de Lima Junior"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('3278f08c-b980-409b-a830-cf1d41a4c137', '85b7674a-e934-4059-ba67-8e0a8941839a', '{"sub":"85b7674a-e934-4059-ba67-8e0a8941839a","email":"gildevamjunior@hotmail.com","email_verified":true}', 'email', '85b7674a-e934-4059-ba67-8e0a8941839a', '2026-01-24T23:32:23.000Z', '2026-01-25T09:28:03.000Z', '2026-01-25T09:28:03.000Z');
UPDATE public.profiles SET name = 'Luis Gildevam Rodrigues de Lima Junior', cpf = '02829039335', phone = '85991835460', company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '85b7674a-e934-4059-ba67-8e0a8941839a';
UPDATE public.user_roles SET company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '85b7674a-e934-4059-ba67-8e0a8941839a';

-- Alexandre Diniz César (alexandre.diniz.cesar@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('4259775d-b209-4e82-88cc-8d702074200e', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'alexandre.diniz.cesar@gmail.com', '', '2026-01-24T23:32:24.000Z', '2026-01-24T23:32:24.000Z', '2026-01-24T23:57:29.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Alexandre Diniz César"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('f0327c99-c3de-439b-9405-3cae10b4f340', '4259775d-b209-4e82-88cc-8d702074200e', '{"sub":"4259775d-b209-4e82-88cc-8d702074200e","email":"alexandre.diniz.cesar@gmail.com","email_verified":true}', 'email', '4259775d-b209-4e82-88cc-8d702074200e', '2026-01-24T23:32:24.000Z', '2026-01-24T23:57:29.000Z', '2026-01-24T23:57:29.000Z');
UPDATE public.profiles SET name = 'Alexandre Diniz César', cpf = '85948241653', phone = '31988581060', company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '4259775d-b209-4e82-88cc-8d702074200e';
UPDATE public.user_roles SET company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '4259775d-b209-4e82-88cc-8d702074200e';

-- Gabriela Mariana Dauer Rodrigues (gabrieladauer@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('e225f293-5fb8-408a-a1bd-c954dfec991c', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'gabrieladauer@gmail.com', '', '2026-01-24T23:32:27.000Z', '2026-01-24T23:32:27.000Z', '2026-01-25T22:56:35.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Gabriela Mariana Dauer Rodrigues"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('353858b7-ce9c-4498-8cd6-f667f2d9e711', 'e225f293-5fb8-408a-a1bd-c954dfec991c', '{"sub":"e225f293-5fb8-408a-a1bd-c954dfec991c","email":"gabrieladauer@gmail.com","email_verified":true}', 'email', 'e225f293-5fb8-408a-a1bd-c954dfec991c', '2026-01-24T23:32:27.000Z', '2026-01-25T22:56:35.000Z', '2026-01-25T22:56:35.000Z');
UPDATE public.profiles SET name = 'Gabriela Mariana Dauer Rodrigues', cpf = '36647957847', phone = '11989398959', company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = 'e225f293-5fb8-408a-a1bd-c954dfec991c';
UPDATE public.user_roles SET company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = 'e225f293-5fb8-408a-a1bd-c954dfec991c';

-- Claudenice Carvalho dos Santos Souza (claudenice_lem@hotmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('649df813-87b8-410a-a173-4bdb8cf91d7b', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'claudenice_lem@hotmail.com', '', '2026-01-24T23:32:32.000Z', '2026-01-24T23:32:32.000Z', '2026-01-24T23:34:43.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Claudenice Carvalho dos Santos Souza"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('10967040-1447-46c4-9d85-db51873fca90', '649df813-87b8-410a-a173-4bdb8cf91d7b', '{"sub":"649df813-87b8-410a-a173-4bdb8cf91d7b","email":"claudenice_lem@hotmail.com","email_verified":true}', 'email', '649df813-87b8-410a-a173-4bdb8cf91d7b', '2026-01-24T23:32:32.000Z', '2026-01-24T23:34:43.000Z', '2026-01-24T23:34:43.000Z');
UPDATE public.profiles SET name = 'Claudenice Carvalho dos Santos Souza', cpf = '62777190178', phone = '77998156272', company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '649df813-87b8-410a-a173-4bdb8cf91d7b';
UPDATE public.user_roles SET company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '649df813-87b8-410a-a173-4bdb8cf91d7b';

-- Erika Christina Berner Vieira Weinberg  (art3dstd@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('9038b998-1260-4d87-bb34-e2c336723a37', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'art3dstd@gmail.com', '', '2026-01-24T23:32:33.000Z', '2026-01-24T23:32:33.000Z', '2026-01-26T02:10:53.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Erika Christina Berner Vieira Weinberg "}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('ecd3b0a7-f2df-4e80-ad14-34d2ccbdd386', '9038b998-1260-4d87-bb34-e2c336723a37', '{"sub":"9038b998-1260-4d87-bb34-e2c336723a37","email":"art3dstd@gmail.com","email_verified":true}', 'email', '9038b998-1260-4d87-bb34-e2c336723a37', '2026-01-24T23:32:33.000Z', '2026-01-26T02:10:53.000Z', '2026-01-26T02:10:54.000Z');
UPDATE public.profiles SET name = 'Erika Christina Berner Vieira Weinberg ', cpf = '07585044704', phone = '24988571977', company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '9038b998-1260-4d87-bb34-e2c336723a37';
UPDATE public.user_roles SET company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '9038b998-1260-4d87-bb34-e2c336723a37';

-- VALDEIR PEREIRA DOS SANTOS (valdeirsantos891@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('d6e928b0-13ad-464b-85f2-b4fa4df4fd58', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'valdeirsantos891@gmail.com', '', '2026-01-24T23:32:34.000Z', '2026-01-24T23:32:34.000Z', '2026-01-25T22:50:35.000Z', '{"provider":"email","providers":["email"]}', '{"name":"VALDEIR PEREIRA DOS SANTOS"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('ea223c31-50bd-4e52-8da9-554c492b1f7c', 'd6e928b0-13ad-464b-85f2-b4fa4df4fd58', '{"sub":"d6e928b0-13ad-464b-85f2-b4fa4df4fd58","email":"valdeirsantos891@gmail.com","email_verified":true}', 'email', 'd6e928b0-13ad-464b-85f2-b4fa4df4fd58', '2026-01-24T23:32:34.000Z', '2026-01-25T22:50:35.000Z', '2026-01-25T22:50:35.000Z');
UPDATE public.profiles SET name = 'VALDEIR PEREIRA DOS SANTOS', cpf = '04817263148', phone = '67981179342', company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = 'd6e928b0-13ad-464b-85f2-b4fa4df4fd58';
UPDATE public.user_roles SET company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = 'd6e928b0-13ad-464b-85f2-b4fa4df4fd58';

-- TAELIO SOUZA ALBUQUERQUE (ta.993810275@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('53fbd804-17ef-4bd5-9d65-2c68f7781bc0', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'ta.993810275@gmail.com', '', '2026-01-24T23:32:39.000Z', '2026-01-24T23:32:39.000Z', '2026-01-24T23:34:52.000Z', '{"provider":"email","providers":["email"]}', '{"name":"TAELIO SOUZA ALBUQUERQUE"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('e086083e-9376-48d8-aa56-99e24891b5d5', '53fbd804-17ef-4bd5-9d65-2c68f7781bc0', '{"sub":"53fbd804-17ef-4bd5-9d65-2c68f7781bc0","email":"ta.993810275@gmail.com","email_verified":true}', 'email', '53fbd804-17ef-4bd5-9d65-2c68f7781bc0', '2026-01-24T23:32:39.000Z', '2026-01-24T23:34:52.000Z', '2026-01-24T23:34:52.000Z');
UPDATE public.profiles SET name = 'TAELIO SOUZA ALBUQUERQUE', cpf = '02073577229', phone = '91992638279', company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '53fbd804-17ef-4bd5-9d65-2c68f7781bc0';
UPDATE public.user_roles SET company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '53fbd804-17ef-4bd5-9d65-2c68f7781bc0';

-- Ruiter Fi (ruiterfidencio@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('6ea09b0b-9a21-4bc1-9d1b-c888c7e3c9da', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'ruiterfidencio@gmail.com', '', '2026-01-24T23:32:41.000Z', '2026-01-24T23:32:41.000Z', '2026-01-24T23:50:35.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Ruiter Fi"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('c8536840-89f1-4bfe-bf7b-4adb20690281', '6ea09b0b-9a21-4bc1-9d1b-c888c7e3c9da', '{"sub":"6ea09b0b-9a21-4bc1-9d1b-c888c7e3c9da","email":"ruiterfidencio@gmail.com","email_verified":true}', 'email', '6ea09b0b-9a21-4bc1-9d1b-c888c7e3c9da', '2026-01-24T23:32:41.000Z', '2026-01-24T23:50:35.000Z', '2026-01-24T23:50:36.000Z');
UPDATE public.profiles SET name = 'Ruiter Fi', cpf = '78630495120', phone = '64999633454', company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '6ea09b0b-9a21-4bc1-9d1b-c888c7e3c9da';
UPDATE public.user_roles SET company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '6ea09b0b-9a21-4bc1-9d1b-c888c7e3c9da';

-- Eliemar Bueno (eliemarbueno@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('a0352755-69c6-47c6-9b18-28263ff1a6b5', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'eliemarbueno@gmail.com', '', '2026-01-24T23:32:43.000Z', '2026-01-24T23:32:43.000Z', '2026-02-02T03:28:35.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Eliemar Bueno"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('e5e35867-35be-48fc-8f05-0ea60501928c', 'a0352755-69c6-47c6-9b18-28263ff1a6b5', '{"sub":"a0352755-69c6-47c6-9b18-28263ff1a6b5","email":"eliemarbueno@gmail.com","email_verified":true}', 'email', 'a0352755-69c6-47c6-9b18-28263ff1a6b5', '2026-01-24T23:32:43.000Z', '2026-02-02T03:28:35.000Z', '2026-02-02T03:28:35.000Z');
UPDATE public.profiles SET name = 'Eliemar Bueno', cpf = '09631715779', phone = '27999935213', company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = 'a0352755-69c6-47c6-9b18-28263ff1a6b5';
UPDATE public.user_roles SET company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = 'a0352755-69c6-47c6-9b18-28263ff1a6b5';

-- Andreia Barreto (andreiacbarreto@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('8702213d-780c-4150-92bb-d94bdd6438c9', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'andreiacbarreto@gmail.com', '', '2026-01-24T23:32:45.000Z', '2026-01-24T23:32:45.000Z', '2026-01-26T17:47:01.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Andreia Barreto"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('9dd7f385-5ae1-4915-9b50-8308670aa97c', '8702213d-780c-4150-92bb-d94bdd6438c9', '{"sub":"8702213d-780c-4150-92bb-d94bdd6438c9","email":"andreiacbarreto@gmail.com","email_verified":true}', 'email', '8702213d-780c-4150-92bb-d94bdd6438c9', '2026-01-24T23:32:45.000Z', '2026-01-26T17:47:01.000Z', '2026-01-26T17:47:01.000Z');
UPDATE public.profiles SET name = 'Andreia Barreto', cpf = '04142156640', phone = '31987482732', company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '8702213d-780c-4150-92bb-d94bdd6438c9';
UPDATE public.user_roles SET company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '8702213d-780c-4150-92bb-d94bdd6438c9';

-- Dorotéia Marra  (doromarra@hotmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('80d26d4a-5fee-4436-be55-62c890e387e8', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'doromarra@hotmail.com', '', '2026-01-24T23:32:46.000Z', '2026-01-24T23:32:46.000Z', '2026-01-24T23:43:32.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Dorotéia Marra "}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('7daa1d82-a705-44f0-9c0c-eaf8da62a591', '80d26d4a-5fee-4436-be55-62c890e387e8', '{"sub":"80d26d4a-5fee-4436-be55-62c890e387e8","email":"doromarra@hotmail.com","email_verified":true}', 'email', '80d26d4a-5fee-4436-be55-62c890e387e8', '2026-01-24T23:32:46.000Z', '2026-01-24T23:43:32.000Z', '2026-01-24T23:43:32.000Z');
UPDATE public.profiles SET name = 'Dorotéia Marra ', cpf = '00538007885', phone = '17981514798', company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '80d26d4a-5fee-4436-be55-62c890e387e8';
UPDATE public.user_roles SET company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '80d26d4a-5fee-4436-be55-62c890e387e8';

-- Suelen Ribeiro (suelenribeiro@gestaomatriz.com.br) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('8dcb2afd-3886-42a2-b21e-8ec26e109a4b', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'suelenribeiro@gestaomatriz.com.br', '', '2026-01-24T23:32:48.000Z', '2026-01-24T23:32:48.000Z', '2026-01-25T22:14:01.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Suelen Ribeiro"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('415b868b-18a0-4dc3-a94a-c1ac771d904b', '8dcb2afd-3886-42a2-b21e-8ec26e109a4b', '{"sub":"8dcb2afd-3886-42a2-b21e-8ec26e109a4b","email":"suelenribeiro@gestaomatriz.com.br","email_verified":true}', 'email', '8dcb2afd-3886-42a2-b21e-8ec26e109a4b', '2026-01-24T23:32:48.000Z', '2026-01-25T22:14:01.000Z', '2026-01-25T22:14:01.000Z');
UPDATE public.profiles SET name = 'Suelen Ribeiro', cpf = '00036046086', phone = '51980630525', company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '8dcb2afd-3886-42a2-b21e-8ec26e109a4b';
UPDATE public.user_roles SET company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '8dcb2afd-3886-42a2-b21e-8ec26e109a4b';

-- Giliardi Rodriguez (grodriguez@piattino.com.br) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('3a9ba956-6b78-42dc-b22f-61ea30489e54', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'grodriguez@piattino.com.br', '', '2026-01-24T23:32:49.000Z', '2026-01-24T23:32:49.000Z', '2026-01-24T23:34:49.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Giliardi Rodriguez"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('57358c59-d6bb-4880-9af7-28eb82200425', '3a9ba956-6b78-42dc-b22f-61ea30489e54', '{"sub":"3a9ba956-6b78-42dc-b22f-61ea30489e54","email":"grodriguez@piattino.com.br","email_verified":true}', 'email', '3a9ba956-6b78-42dc-b22f-61ea30489e54', '2026-01-24T23:32:49.000Z', '2026-01-24T23:34:49.000Z', '2026-01-24T23:34:49.000Z');
UPDATE public.profiles SET name = 'Giliardi Rodriguez', cpf = '21375662813', phone = '11982860424', company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '3a9ba956-6b78-42dc-b22f-61ea30489e54';
UPDATE public.user_roles SET company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '3a9ba956-6b78-42dc-b22f-61ea30489e54';

-- LEANDRO CARLOS SPENER XAVIER (lcsxavier@hotmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('5482b08b-cd05-41b1-97b6-17976b1925b7', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'lcsxavier@hotmail.com', '', '2026-01-24T23:32:49.000Z', '2026-01-24T23:32:49.000Z', '2026-01-24T23:35:18.000Z', '{"provider":"email","providers":["email"]}', '{"name":"LEANDRO CARLOS SPENER XAVIER"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('4ddd3de5-9538-4266-9edf-d1fa01d5ac19', '5482b08b-cd05-41b1-97b6-17976b1925b7', '{"sub":"5482b08b-cd05-41b1-97b6-17976b1925b7","email":"lcsxavier@hotmail.com","email_verified":true}', 'email', '5482b08b-cd05-41b1-97b6-17976b1925b7', '2026-01-24T23:32:49.000Z', '2026-01-24T23:35:18.000Z', '2026-01-24T23:35:18.000Z');
UPDATE public.profiles SET name = 'LEANDRO CARLOS SPENER XAVIER', cpf = '02185525727', phone = '92994962739', company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '5482b08b-cd05-41b1-97b6-17976b1925b7';
UPDATE public.user_roles SET company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '5482b08b-cd05-41b1-97b6-17976b1925b7';

-- Bruna Arruda Capeloa (brunaarruda1712@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('7d4ab9a5-f7c6-4241-8d13-ac9981679adf', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'brunaarruda1712@gmail.com', '', '2026-01-24T23:32:49.000Z', '2026-01-24T23:32:49.000Z', '2026-01-25T22:52:42.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Bruna Arruda Capeloa"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('a8096e8d-5f20-4ccf-af21-b7d8e1c36f03', '7d4ab9a5-f7c6-4241-8d13-ac9981679adf', '{"sub":"7d4ab9a5-f7c6-4241-8d13-ac9981679adf","email":"brunaarruda1712@gmail.com","email_verified":true}', 'email', '7d4ab9a5-f7c6-4241-8d13-ac9981679adf', '2026-01-24T23:32:49.000Z', '2026-01-25T22:52:42.000Z', '2026-01-25T22:52:43.000Z');
UPDATE public.profiles SET name = 'Bruna Arruda Capeloa', cpf = '41362028819', phone = '11957939767', company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '7d4ab9a5-f7c6-4241-8d13-ac9981679adf';
UPDATE public.user_roles SET company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '7d4ab9a5-f7c6-4241-8d13-ac9981679adf';

-- Maisa de A Forster Machado (maisahfm@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('91c64925-7029-4ac2-b906-b50f365ee56b', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'maisahfm@gmail.com', '', '2026-01-24T23:32:51.000Z', '2026-01-24T23:32:51.000Z', '2026-01-24T23:54:43.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Maisa de A Forster Machado"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('38fa2545-e392-4a5b-adff-7fb78010c0d3', '91c64925-7029-4ac2-b906-b50f365ee56b', '{"sub":"91c64925-7029-4ac2-b906-b50f365ee56b","email":"maisahfm@gmail.com","email_verified":true}', 'email', '91c64925-7029-4ac2-b906-b50f365ee56b', '2026-01-24T23:32:51.000Z', '2026-01-24T23:54:43.000Z', '2026-01-24T23:54:44.000Z');
UPDATE public.profiles SET name = 'Maisa de A Forster Machado', cpf = '01441610871', phone = '11995249246', company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '91c64925-7029-4ac2-b906-b50f365ee56b';
UPDATE public.user_roles SET company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '91c64925-7029-4ac2-b906-b50f365ee56b';

-- Júlio César Salvador (gccotia.combate@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('1e89946b-cd1e-44be-9324-0eece60ba966', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'gccotia.combate@gmail.com', '', '2026-01-24T23:32:59.000Z', '2026-01-24T23:32:59.000Z', '2026-01-25T22:33:13.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Júlio César Salvador"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('273b7803-b560-495e-ad78-d7f08cea6a59', '1e89946b-cd1e-44be-9324-0eece60ba966', '{"sub":"1e89946b-cd1e-44be-9324-0eece60ba966","email":"gccotia.combate@gmail.com","email_verified":true}', 'email', '1e89946b-cd1e-44be-9324-0eece60ba966', '2026-01-24T23:32:59.000Z', '2026-01-25T22:33:13.000Z', '2026-01-25T22:33:14.000Z');
UPDATE public.profiles SET name = 'Júlio César Salvador', cpf = '12255060850', phone = '11978918514', company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '1e89946b-cd1e-44be-9324-0eece60ba966';
UPDATE public.user_roles SET company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '1e89946b-cd1e-44be-9324-0eece60ba966';

-- JULIANA ARAUJO BOTELHO BETTINI (jubettini@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('7a103808-ed3e-4c4c-9cc8-02be571d6c1e', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'jubettini@gmail.com', '', '2026-01-24T23:32:59.000Z', '2026-01-24T23:32:59.000Z', '2026-01-26T15:58:23.000Z', '{"provider":"email","providers":["email"]}', '{"name":"JULIANA ARAUJO BOTELHO BETTINI"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('852947d0-805d-4e51-8045-f3686b510b41', '7a103808-ed3e-4c4c-9cc8-02be571d6c1e', '{"sub":"7a103808-ed3e-4c4c-9cc8-02be571d6c1e","email":"jubettini@gmail.com","email_verified":true}', 'email', '7a103808-ed3e-4c4c-9cc8-02be571d6c1e', '2026-01-24T23:32:59.000Z', '2026-01-26T15:58:23.000Z', '2026-01-26T15:58:23.000Z');
UPDATE public.profiles SET name = 'JULIANA ARAUJO BOTELHO BETTINI', cpf = '98752464920', phone = '47992071502', company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '7a103808-ed3e-4c4c-9cc8-02be571d6c1e';
UPDATE public.user_roles SET company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '7a103808-ed3e-4c4c-9cc8-02be571d6c1e';

-- Carina Reis de Mattos (rmatoscarina@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('413b65b3-02d7-4526-a2d9-2272cf7522b1', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'rmatoscarina@gmail.com', '', '2026-01-24T23:33:02.000Z', '2026-01-24T23:33:02.000Z', '2026-01-24T23:58:07.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Carina Reis de Mattos"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('8a29b949-6507-47a4-a07d-40fa243bc9f3', '413b65b3-02d7-4526-a2d9-2272cf7522b1', '{"sub":"413b65b3-02d7-4526-a2d9-2272cf7522b1","email":"rmatoscarina@gmail.com","email_verified":true}', 'email', '413b65b3-02d7-4526-a2d9-2272cf7522b1', '2026-01-24T23:33:02.000Z', '2026-01-24T23:58:07.000Z', '2026-01-24T23:58:08.000Z');
UPDATE public.profiles SET name = 'Carina Reis de Mattos', cpf = '10737754613', phone = '31988371414', company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '413b65b3-02d7-4526-a2d9-2272cf7522b1';
UPDATE public.user_roles SET company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '413b65b3-02d7-4526-a2d9-2272cf7522b1';

-- Gisele kelermam (gkgloballink@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('07acf84d-2489-451d-9533-0fbeb5e30c8b', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'gkgloballink@gmail.com', '', '2026-01-24T23:33:04.000Z', '2026-01-24T23:33:04.000Z', '2026-01-25T16:10:39.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Gisele kelermam"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('c7145f6b-fc43-45a6-acbc-9277fead3af7', '07acf84d-2489-451d-9533-0fbeb5e30c8b', '{"sub":"07acf84d-2489-451d-9533-0fbeb5e30c8b","email":"gkgloballink@gmail.com","email_verified":true}', 'email', '07acf84d-2489-451d-9533-0fbeb5e30c8b', '2026-01-24T23:33:04.000Z', '2026-01-25T16:10:39.000Z', '2026-01-25T16:10:39.000Z');
UPDATE public.profiles SET name = 'Gisele kelermam', cpf = '00837028060', phone = '11989157816', company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '07acf84d-2489-451d-9533-0fbeb5e30c8b';
UPDATE public.user_roles SET company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '07acf84d-2489-451d-9533-0fbeb5e30c8b';

-- Maria Eduarda Souza Branco (mariaeduardabranco1991@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('55aece0e-0c2b-413f-a938-03963e00f9d4', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'mariaeduardabranco1991@gmail.com', '', '2026-01-24T23:33:12.000Z', '2026-01-24T23:33:12.000Z', '2026-01-25T18:37:23.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Maria Eduarda Souza Branco"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('4ec138fa-1aed-43b8-9af1-09069a460b40', '55aece0e-0c2b-413f-a938-03963e00f9d4', '{"sub":"55aece0e-0c2b-413f-a938-03963e00f9d4","email":"mariaeduardabranco1991@gmail.com","email_verified":true}', 'email', '55aece0e-0c2b-413f-a938-03963e00f9d4', '2026-01-24T23:33:12.000Z', '2026-01-25T18:37:23.000Z', '2026-01-25T18:37:23.000Z');
UPDATE public.profiles SET name = 'Maria Eduarda Souza Branco', cpf = '41102829854', phone = '18996221356', company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '55aece0e-0c2b-413f-a938-03963e00f9d4';
UPDATE public.user_roles SET company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '55aece0e-0c2b-413f-a938-03963e00f9d4';

-- PATRICIA DE ANDRADE FIGUEIRA TEIXEIRA (jornalistapatriciateixeira@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('db64f148-e85a-4649-b48a-b2cecec855d9', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'jornalistapatriciateixeira@gmail.com', '', '2026-01-24T23:33:13.000Z', '2026-01-24T23:33:13.000Z', '2026-01-26T20:32:20.000Z', '{"provider":"email","providers":["email"]}', '{"name":"PATRICIA DE ANDRADE FIGUEIRA TEIXEIRA"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('39348b6c-b837-41c2-bdbe-56688f33529b', 'db64f148-e85a-4649-b48a-b2cecec855d9', '{"sub":"db64f148-e85a-4649-b48a-b2cecec855d9","email":"jornalistapatriciateixeira@gmail.com","email_verified":true}', 'email', 'db64f148-e85a-4649-b48a-b2cecec855d9', '2026-01-24T23:33:13.000Z', '2026-01-26T20:32:20.000Z', '2026-01-26T20:32:21.000Z');
UPDATE public.profiles SET name = 'PATRICIA DE ANDRADE FIGUEIRA TEIXEIRA', cpf = '10114925712', phone = '21987156685', company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = 'db64f148-e85a-4649-b48a-b2cecec855d9';
UPDATE public.user_roles SET company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = 'db64f148-e85a-4649-b48a-b2cecec855d9';

-- ELISA PEREIRA DE JESUS BARBOSA (elisapj@hotmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('c708ca87-f179-41c8-8f6d-988dd6a40b2f', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'elisapj@hotmail.com', '', '2026-01-24T23:33:13.000Z', '2026-01-24T23:33:13.000Z', '2026-01-24T23:34:15.000Z', '{"provider":"email","providers":["email"]}', '{"name":"ELISA PEREIRA DE JESUS BARBOSA"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('c35d0305-28cf-401e-8912-139f185b3cb1', 'c708ca87-f179-41c8-8f6d-988dd6a40b2f', '{"sub":"c708ca87-f179-41c8-8f6d-988dd6a40b2f","email":"elisapj@hotmail.com","email_verified":true}', 'email', 'c708ca87-f179-41c8-8f6d-988dd6a40b2f', '2026-01-24T23:33:13.000Z', '2026-01-24T23:34:15.000Z', '2026-01-24T23:34:15.000Z');
UPDATE public.profiles SET name = 'ELISA PEREIRA DE JESUS BARBOSA', cpf = '02705173595', phone = '71991311657', company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = 'c708ca87-f179-41c8-8f6d-988dd6a40b2f';
UPDATE public.user_roles SET company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = 'c708ca87-f179-41c8-8f6d-988dd6a40b2f';

-- Carla Tutschke  (harmonia5x.mentorias@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('13bef866-8e19-43b8-b27b-fd6bf63ee9de', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'harmonia5x.mentorias@gmail.com', '', '2026-01-24T23:33:13.000Z', '2026-01-24T23:33:13.000Z', '2026-01-25T18:42:40.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Carla Tutschke "}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('7ba4eb9a-d324-4554-90ad-47ca90779bcb', '13bef866-8e19-43b8-b27b-fd6bf63ee9de', '{"sub":"13bef866-8e19-43b8-b27b-fd6bf63ee9de","email":"harmonia5x.mentorias@gmail.com","email_verified":true}', 'email', '13bef866-8e19-43b8-b27b-fd6bf63ee9de', '2026-01-24T23:33:13.000Z', '2026-01-25T18:42:40.000Z', '2026-01-25T18:42:41.000Z');
UPDATE public.profiles SET name = 'Carla Tutschke ', cpf = '05119431992', phone = '41984518385', company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '13bef866-8e19-43b8-b27b-fd6bf63ee9de';
UPDATE public.user_roles SET company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '13bef866-8e19-43b8-b27b-fd6bf63ee9de';

-- Savana Danuza Zamai  (savanazamai@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('f93a028b-2507-4d8a-9089-c8ba0e05e246', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'savanazamai@gmail.com', '', '2026-01-24T23:33:16.000Z', '2026-01-24T23:33:16.000Z', '2026-01-25T22:45:02.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Savana Danuza Zamai "}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('e49e063e-8078-4a5d-b990-e44c50c68950', 'f93a028b-2507-4d8a-9089-c8ba0e05e246', '{"sub":"f93a028b-2507-4d8a-9089-c8ba0e05e246","email":"savanazamai@gmail.com","email_verified":true}', 'email', 'f93a028b-2507-4d8a-9089-c8ba0e05e246', '2026-01-24T23:33:16.000Z', '2026-01-25T22:45:02.000Z', '2026-01-25T22:45:03.000Z');
UPDATE public.profiles SET name = 'Savana Danuza Zamai ', cpf = '31317301889', phone = '16993253819', company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = 'f93a028b-2507-4d8a-9089-c8ba0e05e246';
UPDATE public.user_roles SET company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = 'f93a028b-2507-4d8a-9089-c8ba0e05e246';

-- Fabio Oliveira (phabioliveira@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('1bdf8efe-2830-4783-83ef-a58d06afd366', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'phabioliveira@gmail.com', '', '2026-01-24T23:33:21.000Z', '2026-01-24T23:33:21.000Z', '2026-01-25T00:13:19.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Fabio Oliveira"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('0d7e6282-ef90-42c8-acb0-7f889d4809f0', '1bdf8efe-2830-4783-83ef-a58d06afd366', '{"sub":"1bdf8efe-2830-4783-83ef-a58d06afd366","email":"phabioliveira@gmail.com","email_verified":true}', 'email', '1bdf8efe-2830-4783-83ef-a58d06afd366', '2026-01-24T23:33:21.000Z', '2026-01-25T00:13:19.000Z', '2026-01-25T00:13:20.000Z');
UPDATE public.profiles SET name = 'Fabio Oliveira', cpf = '94232245553', phone = '71981234489', company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '1bdf8efe-2830-4783-83ef-a58d06afd366';
UPDATE public.user_roles SET company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '1bdf8efe-2830-4783-83ef-a58d06afd366';

-- FERNANDA ALVES ROCHA (frs8176@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('7e623bb9-6592-48e1-9a9d-1b30ce0437c7', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'frs8176@gmail.com', '', '2026-01-24T23:33:22.000Z', '2026-01-24T23:33:22.000Z', '2026-01-24T23:33:47.000Z', '{"provider":"email","providers":["email"]}', '{"name":"FERNANDA ALVES ROCHA"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('e43bc2c6-78cc-4400-b2b4-499351e45d52', '7e623bb9-6592-48e1-9a9d-1b30ce0437c7', '{"sub":"7e623bb9-6592-48e1-9a9d-1b30ce0437c7","email":"frs8176@gmail.com","email_verified":true}', 'email', '7e623bb9-6592-48e1-9a9d-1b30ce0437c7', '2026-01-24T23:33:22.000Z', '2026-01-24T23:33:47.000Z', '2026-01-24T23:33:48.000Z');
UPDATE public.profiles SET name = 'FERNANDA ALVES ROCHA', cpf = '04767277744', phone = '21968049699', company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '7e623bb9-6592-48e1-9a9d-1b30ce0437c7';
UPDATE public.user_roles SET company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '7e623bb9-6592-48e1-9a9d-1b30ce0437c7';

-- Rose Mary martins (unapackembalagens@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('eafb71b3-0a0c-44de-a625-9af315527570', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'unapackembalagens@gmail.com', '', '2026-01-24T23:33:27.000Z', '2026-01-24T23:33:27.000Z', '2026-01-24T23:51:11.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Rose Mary martins"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('ebaa0f4b-61b5-4777-8b71-52c1e4be36a4', 'eafb71b3-0a0c-44de-a625-9af315527570', '{"sub":"eafb71b3-0a0c-44de-a625-9af315527570","email":"unapackembalagens@gmail.com","email_verified":true}', 'email', 'eafb71b3-0a0c-44de-a625-9af315527570', '2026-01-24T23:33:27.000Z', '2026-01-24T23:51:11.000Z', '2026-01-24T23:51:12.000Z');
UPDATE public.profiles SET name = 'Rose Mary martins', cpf = '04417894809', phone = '11956008186', company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = 'eafb71b3-0a0c-44de-a625-9af315527570';
UPDATE public.user_roles SET company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = 'eafb71b3-0a0c-44de-a625-9af315527570';
