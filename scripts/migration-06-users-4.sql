-- ============================================
-- Talent-IA Migration - Part 6/8: Users 301-400 (batch 4/5)
-- Generated: 2026-02-13T20:29:31.269Z
-- EXECUTE IN ORDER: Part 6 of 8
-- ============================================

-- Teste Usuario 10 (teste.1770407502787.4792.10@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('d5b65182-b8c6-4016-b48b-0543e93ba6ac', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502787.4792.10@loadtest.com', '', '2026-02-06T22:51:49.000Z', '2026-02-06T22:51:49.000Z', '2026-02-06T22:51:49.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 10"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('cb36b299-4c21-45ae-89b1-5f9cd15efbfd', 'd5b65182-b8c6-4016-b48b-0543e93ba6ac', '{"sub":"d5b65182-b8c6-4016-b48b-0543e93ba6ac","email":"teste.1770407502787.4792.10@loadtest.com","email_verified":true}', 'email', 'd5b65182-b8c6-4016-b48b-0543e93ba6ac', '2026-02-06T22:51:49.000Z', '2026-02-06T22:51:49.000Z', '2026-02-06T22:51:50.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 10', cpf = '10000000010', phone = '11900000010', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'd5b65182-b8c6-4016-b48b-0543e93ba6ac';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'd5b65182-b8c6-4016-b48b-0543e93ba6ac';

-- Teste Usuario 79 (teste.1770407502838.7504.79@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('683367ac-65d9-4b04-937d-75793cb70e14', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502838.7504.79@loadtest.com', '', '2026-02-06T22:51:50.000Z', '2026-02-06T22:51:50.000Z', '2026-02-06T22:51:50.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 79"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('39efc29b-c610-4b91-90fb-5c550be30733', '683367ac-65d9-4b04-937d-75793cb70e14', '{"sub":"683367ac-65d9-4b04-937d-75793cb70e14","email":"teste.1770407502838.7504.79@loadtest.com","email_verified":true}', 'email', '683367ac-65d9-4b04-937d-75793cb70e14', '2026-02-06T22:51:50.000Z', '2026-02-06T22:51:50.000Z', '2026-02-06T22:51:50.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 79', cpf = '10000000079', phone = '11900000079', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '683367ac-65d9-4b04-937d-75793cb70e14';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '683367ac-65d9-4b04-937d-75793cb70e14';

-- Teste Usuario 14 (teste.1770407502790.5763.14@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('71edbafe-f762-42f3-903e-40b316efcb73', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502790.5763.14@loadtest.com', '', '2026-02-06T22:51:50.000Z', '2026-02-06T22:51:50.000Z', '2026-02-06T22:51:50.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 14"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('1091f9d2-44e5-4935-b7bb-77fd4513e431', '71edbafe-f762-42f3-903e-40b316efcb73', '{"sub":"71edbafe-f762-42f3-903e-40b316efcb73","email":"teste.1770407502790.5763.14@loadtest.com","email_verified":true}', 'email', '71edbafe-f762-42f3-903e-40b316efcb73', '2026-02-06T22:51:50.000Z', '2026-02-06T22:51:50.000Z', '2026-02-06T22:51:51.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 14', cpf = '10000000014', phone = '11900000014', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '71edbafe-f762-42f3-903e-40b316efcb73';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '71edbafe-f762-42f3-903e-40b316efcb73';

-- Teste Usuario 2 (teste.1770407502774.8536.2@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('a725a977-f7df-47be-9dd9-482e6add218b', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502774.8536.2@loadtest.com', '', '2026-02-06T22:51:51.000Z', '2026-02-06T22:51:51.000Z', '2026-02-06T22:51:51.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 2"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('401382c2-ee50-4a5d-936e-23c8a7cb5b80', 'a725a977-f7df-47be-9dd9-482e6add218b', '{"sub":"a725a977-f7df-47be-9dd9-482e6add218b","email":"teste.1770407502774.8536.2@loadtest.com","email_verified":true}', 'email', 'a725a977-f7df-47be-9dd9-482e6add218b', '2026-02-06T22:51:51.000Z', '2026-02-06T22:51:51.000Z', '2026-02-06T22:51:51.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 2', cpf = '10000000002', phone = '11900000002', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'a725a977-f7df-47be-9dd9-482e6add218b';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'a725a977-f7df-47be-9dd9-482e6add218b';

-- Teste Usuario 19 (teste.1770407502794.8959.19@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('146da6cb-e35c-42e1-8cd8-b6cf057a4de7', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502794.8959.19@loadtest.com', '', '2026-02-06T22:51:51.000Z', '2026-02-06T22:51:51.000Z', '2026-02-06T22:51:51.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 19"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('4fd77b22-c324-4dbb-9b3f-eecb2d285580', '146da6cb-e35c-42e1-8cd8-b6cf057a4de7', '{"sub":"146da6cb-e35c-42e1-8cd8-b6cf057a4de7","email":"teste.1770407502794.8959.19@loadtest.com","email_verified":true}', 'email', '146da6cb-e35c-42e1-8cd8-b6cf057a4de7', '2026-02-06T22:51:51.000Z', '2026-02-06T22:51:51.000Z', '2026-02-06T22:51:51.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 19', cpf = '10000000019', phone = '11900000019', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '146da6cb-e35c-42e1-8cd8-b6cf057a4de7';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '146da6cb-e35c-42e1-8cd8-b6cf057a4de7';

-- Teste Usuario 5 (teste.1770407502779.6787.5@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('1c62782b-99b2-411c-94bc-86fd1a6b14d4', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502779.6787.5@loadtest.com', '', '2026-02-06T22:51:51.000Z', '2026-02-06T22:51:51.000Z', '2026-02-06T22:51:51.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 5"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('42c868e4-d1e2-47a7-9c57-2606508f5a15', '1c62782b-99b2-411c-94bc-86fd1a6b14d4', '{"sub":"1c62782b-99b2-411c-94bc-86fd1a6b14d4","email":"teste.1770407502779.6787.5@loadtest.com","email_verified":true}', 'email', '1c62782b-99b2-411c-94bc-86fd1a6b14d4', '2026-02-06T22:51:51.000Z', '2026-02-06T22:51:51.000Z', '2026-02-06T22:51:52.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 5', cpf = '10000000005', phone = '11900000005', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '1c62782b-99b2-411c-94bc-86fd1a6b14d4';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '1c62782b-99b2-411c-94bc-86fd1a6b14d4';

-- Teste Usuario 9 (teste.1770407502783.5086.9@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('01214e67-5a1a-4901-813c-0268b44a072b', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502783.5086.9@loadtest.com', '', '2026-02-06T22:51:52.000Z', '2026-02-06T22:51:52.000Z', '2026-02-06T22:51:52.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 9"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('572071e9-ab35-49fa-a057-8b4b11a20803', '01214e67-5a1a-4901-813c-0268b44a072b', '{"sub":"01214e67-5a1a-4901-813c-0268b44a072b","email":"teste.1770407502783.5086.9@loadtest.com","email_verified":true}', 'email', '01214e67-5a1a-4901-813c-0268b44a072b', '2026-02-06T22:51:52.000Z', '2026-02-06T22:51:52.000Z', '2026-02-06T22:51:52.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 9', cpf = '10000000009', phone = '11900000009', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '01214e67-5a1a-4901-813c-0268b44a072b';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '01214e67-5a1a-4901-813c-0268b44a072b';

-- Teste Usuario 15 (teste.1770407502791.8698.15@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('22985648-da14-492f-af16-2811b3f8cdd4', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502791.8698.15@loadtest.com', '', '2026-02-06T22:51:52.000Z', '2026-02-06T22:51:52.000Z', '2026-02-06T22:51:52.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 15"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('49aa72bf-45e1-46a5-aec7-2340545da194', '22985648-da14-492f-af16-2811b3f8cdd4', '{"sub":"22985648-da14-492f-af16-2811b3f8cdd4","email":"teste.1770407502791.8698.15@loadtest.com","email_verified":true}', 'email', '22985648-da14-492f-af16-2811b3f8cdd4', '2026-02-06T22:51:52.000Z', '2026-02-06T22:51:52.000Z', '2026-02-06T22:51:53.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 15', cpf = '10000000015', phone = '11900000015', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '22985648-da14-492f-af16-2811b3f8cdd4';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '22985648-da14-492f-af16-2811b3f8cdd4';

-- Teste Usuario 11 (teste.1770407502788.3329.11@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('9f906154-4498-4bfa-9e87-1f507364c3e6', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502788.3329.11@loadtest.com', '', '2026-02-06T22:51:53.000Z', '2026-02-06T22:51:53.000Z', '2026-02-06T22:51:53.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 11"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('89c52d9f-0295-42d6-a811-fa8c2c16af5b', '9f906154-4498-4bfa-9e87-1f507364c3e6', '{"sub":"9f906154-4498-4bfa-9e87-1f507364c3e6","email":"teste.1770407502788.3329.11@loadtest.com","email_verified":true}', 'email', '9f906154-4498-4bfa-9e87-1f507364c3e6', '2026-02-06T22:51:53.000Z', '2026-02-06T22:51:53.000Z', '2026-02-06T22:51:53.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 11', cpf = '10000000011', phone = '11900000011', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '9f906154-4498-4bfa-9e87-1f507364c3e6';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '9f906154-4498-4bfa-9e87-1f507364c3e6';

-- Teste Usuario 18 (teste.1770407502793.4788.18@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('d6221eec-d654-4750-9b7c-e5ba8a93aaab', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502793.4788.18@loadtest.com', '', '2026-02-06T22:51:53.000Z', '2026-02-06T22:51:53.000Z', '2026-02-06T22:51:53.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 18"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('3e78ee6a-e1fa-4a86-9375-8eaebeffedce', 'd6221eec-d654-4750-9b7c-e5ba8a93aaab', '{"sub":"d6221eec-d654-4750-9b7c-e5ba8a93aaab","email":"teste.1770407502793.4788.18@loadtest.com","email_verified":true}', 'email', 'd6221eec-d654-4750-9b7c-e5ba8a93aaab', '2026-02-06T22:51:53.000Z', '2026-02-06T22:51:53.000Z', '2026-02-06T22:51:54.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 18', cpf = '10000000018', phone = '11900000018', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'd6221eec-d654-4750-9b7c-e5ba8a93aaab';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'd6221eec-d654-4750-9b7c-e5ba8a93aaab';

-- Teste Usuario 26 (teste.1770407502799.9290.26@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('9fdffc8c-994c-4f83-b9c6-962d6e62f82d', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502799.9290.26@loadtest.com', '', '2026-02-06T22:51:54.000Z', '2026-02-06T22:51:54.000Z', '2026-02-06T22:51:54.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 26"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('740a734c-b5dd-4c07-8196-add223480c80', '9fdffc8c-994c-4f83-b9c6-962d6e62f82d', '{"sub":"9fdffc8c-994c-4f83-b9c6-962d6e62f82d","email":"teste.1770407502799.9290.26@loadtest.com","email_verified":true}', 'email', '9fdffc8c-994c-4f83-b9c6-962d6e62f82d', '2026-02-06T22:51:54.000Z', '2026-02-06T22:51:54.000Z', '2026-02-06T22:51:54.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 26', cpf = '10000000026', phone = '11900000026', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '9fdffc8c-994c-4f83-b9c6-962d6e62f82d';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '9fdffc8c-994c-4f83-b9c6-962d6e62f82d';

-- Teste Usuario 16 (teste.1770407502792.1908.16@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('bef2641c-d203-4f23-9b74-49e482665771', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502792.1908.16@loadtest.com', '', '2026-02-06T22:51:54.000Z', '2026-02-06T22:51:54.000Z', '2026-02-06T22:51:54.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 16"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('46fc9943-4f83-4944-8836-f16bb699e02c', 'bef2641c-d203-4f23-9b74-49e482665771', '{"sub":"bef2641c-d203-4f23-9b74-49e482665771","email":"teste.1770407502792.1908.16@loadtest.com","email_verified":true}', 'email', 'bef2641c-d203-4f23-9b74-49e482665771', '2026-02-06T22:51:54.000Z', '2026-02-06T22:51:54.000Z', '2026-02-06T22:51:54.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 16', cpf = '10000000016', phone = '11900000016', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'bef2641c-d203-4f23-9b74-49e482665771';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'bef2641c-d203-4f23-9b74-49e482665771';

-- Teste Usuario 13 (teste.1770407502790.6360.13@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('0c667663-8b67-4a61-be08-8f8ddd50bb1b', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502790.6360.13@loadtest.com', '', '2026-02-06T22:51:55.000Z', '2026-02-06T22:51:55.000Z', '2026-02-06T22:51:55.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 13"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('6b5de7a5-c96e-4b12-8362-03ae86f37a67', '0c667663-8b67-4a61-be08-8f8ddd50bb1b', '{"sub":"0c667663-8b67-4a61-be08-8f8ddd50bb1b","email":"teste.1770407502790.6360.13@loadtest.com","email_verified":true}', 'email', '0c667663-8b67-4a61-be08-8f8ddd50bb1b', '2026-02-06T22:51:55.000Z', '2026-02-06T22:51:55.000Z', '2026-02-06T22:51:55.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 13', cpf = '10000000013', phone = '11900000013', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '0c667663-8b67-4a61-be08-8f8ddd50bb1b';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '0c667663-8b67-4a61-be08-8f8ddd50bb1b';

-- Teste Usuario 8 (teste.1770407502782.1842.8@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('96e06b14-4dee-4f0d-b03a-9e282e59e133', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502782.1842.8@loadtest.com', '', '2026-02-06T22:51:55.000Z', '2026-02-06T22:51:55.000Z', '2026-02-06T22:51:55.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 8"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('8aa2edf4-1875-4a51-837f-c618da3f3f66', '96e06b14-4dee-4f0d-b03a-9e282e59e133', '{"sub":"96e06b14-4dee-4f0d-b03a-9e282e59e133","email":"teste.1770407502782.1842.8@loadtest.com","email_verified":true}', 'email', '96e06b14-4dee-4f0d-b03a-9e282e59e133', '2026-02-06T22:51:55.000Z', '2026-02-06T22:51:55.000Z', '2026-02-06T22:51:55.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 8', cpf = '10000000008', phone = '11900000008', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '96e06b14-4dee-4f0d-b03a-9e282e59e133';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '96e06b14-4dee-4f0d-b03a-9e282e59e133';

-- Teste Usuario 20 (teste.1770407502794.2994.20@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('c31f0fe1-60ac-4967-b604-7e1649d7cf31', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502794.2994.20@loadtest.com', '', '2026-02-06T22:51:55.000Z', '2026-02-06T22:51:55.000Z', '2026-02-06T22:51:55.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 20"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('2c7e0d7e-fac3-446e-aabb-3d8056b56b5f', 'c31f0fe1-60ac-4967-b604-7e1649d7cf31', '{"sub":"c31f0fe1-60ac-4967-b604-7e1649d7cf31","email":"teste.1770407502794.2994.20@loadtest.com","email_verified":true}', 'email', 'c31f0fe1-60ac-4967-b604-7e1649d7cf31', '2026-02-06T22:51:55.000Z', '2026-02-06T22:51:55.000Z', '2026-02-06T22:51:56.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 20', cpf = '10000000020', phone = '11900000020', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'c31f0fe1-60ac-4967-b604-7e1649d7cf31';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'c31f0fe1-60ac-4967-b604-7e1649d7cf31';

-- Teste Usuario 17 (teste.1770407502792.5820.17@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('eedab7e1-8ef4-400f-b6c0-6473117a06b2', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502792.5820.17@loadtest.com', '', '2026-02-06T22:51:56.000Z', '2026-02-06T22:51:56.000Z', '2026-02-06T22:51:56.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 17"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('29602393-9d5f-4f6f-b495-a7833e7930af', 'eedab7e1-8ef4-400f-b6c0-6473117a06b2', '{"sub":"eedab7e1-8ef4-400f-b6c0-6473117a06b2","email":"teste.1770407502792.5820.17@loadtest.com","email_verified":true}', 'email', 'eedab7e1-8ef4-400f-b6c0-6473117a06b2', '2026-02-06T22:51:56.000Z', '2026-02-06T22:51:56.000Z', '2026-02-06T22:51:56.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 17', cpf = '10000000017', phone = '11900000017', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'eedab7e1-8ef4-400f-b6c0-6473117a06b2';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'eedab7e1-8ef4-400f-b6c0-6473117a06b2';

-- Teste Usuario 24 (teste.1770407502797.9054.24@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('fb39bf59-9f80-451b-b332-027ea8b04dde', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502797.9054.24@loadtest.com', '', '2026-02-06T22:51:56.000Z', '2026-02-06T22:51:56.000Z', '2026-02-06T22:51:56.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 24"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('b33e3e37-976c-4a60-b513-d2279912d319', 'fb39bf59-9f80-451b-b332-027ea8b04dde', '{"sub":"fb39bf59-9f80-451b-b332-027ea8b04dde","email":"teste.1770407502797.9054.24@loadtest.com","email_verified":true}', 'email', 'fb39bf59-9f80-451b-b332-027ea8b04dde', '2026-02-06T22:51:56.000Z', '2026-02-06T22:51:56.000Z', '2026-02-06T22:51:57.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 24', cpf = '10000000024', phone = '11900000024', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'fb39bf59-9f80-451b-b332-027ea8b04dde';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'fb39bf59-9f80-451b-b332-027ea8b04dde';

-- Teste Usuario 12 (teste.1770407502789.2226.12@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('bf1e2764-046f-48ca-8024-4c9e337cf91b', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502789.2226.12@loadtest.com', '', '2026-02-06T22:51:57.000Z', '2026-02-06T22:51:57.000Z', '2026-02-06T22:51:57.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 12"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('2d4dc94c-e7bc-49b4-9f2b-86a96c6d8578', 'bf1e2764-046f-48ca-8024-4c9e337cf91b', '{"sub":"bf1e2764-046f-48ca-8024-4c9e337cf91b","email":"teste.1770407502789.2226.12@loadtest.com","email_verified":true}', 'email', 'bf1e2764-046f-48ca-8024-4c9e337cf91b', '2026-02-06T22:51:57.000Z', '2026-02-06T22:51:57.000Z', '2026-02-06T22:51:57.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 12', cpf = '10000000012', phone = '11900000012', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'bf1e2764-046f-48ca-8024-4c9e337cf91b';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'bf1e2764-046f-48ca-8024-4c9e337cf91b';

-- Teste Usuario 21 (teste.1770407502795.633.21@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('d065a67b-9939-46da-b507-ce2c12df878e', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502795.633.21@loadtest.com', '', '2026-02-06T22:51:57.000Z', '2026-02-06T22:51:57.000Z', '2026-02-06T22:51:57.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 21"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('9b5614ba-d540-403e-82da-a387d8053bfa', 'd065a67b-9939-46da-b507-ce2c12df878e', '{"sub":"d065a67b-9939-46da-b507-ce2c12df878e","email":"teste.1770407502795.633.21@loadtest.com","email_verified":true}', 'email', 'd065a67b-9939-46da-b507-ce2c12df878e', '2026-02-06T22:51:57.000Z', '2026-02-06T22:51:57.000Z', '2026-02-06T22:51:58.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 21', cpf = '10000000021', phone = '11900000021', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'd065a67b-9939-46da-b507-ce2c12df878e';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'd065a67b-9939-46da-b507-ce2c12df878e';

-- Teste Usuario 27 (teste.1770407502799.4935.27@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('1db34ed5-2913-449b-a450-9a177d33d187', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502799.4935.27@loadtest.com', '', '2026-02-06T22:51:58.000Z', '2026-02-06T22:51:58.000Z', '2026-02-06T22:51:58.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 27"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('9ab2fb86-e47b-45e9-9a1e-a1826a8c962a', '1db34ed5-2913-449b-a450-9a177d33d187', '{"sub":"1db34ed5-2913-449b-a450-9a177d33d187","email":"teste.1770407502799.4935.27@loadtest.com","email_verified":true}', 'email', '1db34ed5-2913-449b-a450-9a177d33d187', '2026-02-06T22:51:58.000Z', '2026-02-06T22:51:58.000Z', '2026-02-06T22:51:58.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 27', cpf = '10000000027', phone = '11900000027', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '1db34ed5-2913-449b-a450-9a177d33d187';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '1db34ed5-2913-449b-a450-9a177d33d187';

-- Teste Usuario 23 (teste.1770407502797.88.23@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('2c976caf-6e09-4150-8235-4c5c95db0e0d', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502797.88.23@loadtest.com', '', '2026-02-06T22:51:58.000Z', '2026-02-06T22:51:58.000Z', '2026-02-06T22:51:58.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 23"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('e6ceb607-660e-424c-ac6f-47d375688bc6', '2c976caf-6e09-4150-8235-4c5c95db0e0d', '{"sub":"2c976caf-6e09-4150-8235-4c5c95db0e0d","email":"teste.1770407502797.88.23@loadtest.com","email_verified":true}', 'email', '2c976caf-6e09-4150-8235-4c5c95db0e0d', '2026-02-06T22:51:58.000Z', '2026-02-06T22:51:58.000Z', '2026-02-06T22:51:58.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 23', cpf = '10000000023', phone = '11900000023', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '2c976caf-6e09-4150-8235-4c5c95db0e0d';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '2c976caf-6e09-4150-8235-4c5c95db0e0d';

-- Teste Usuario 28 (teste.1770407502800.3937.28@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('b50d710c-7137-4170-bbf5-3fbd51afcc50', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502800.3937.28@loadtest.com', '', '2026-02-06T22:51:58.000Z', '2026-02-06T22:51:58.000Z', '2026-02-06T22:51:58.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 28"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('2444bfa1-b699-4af2-82be-7357f582b35d', 'b50d710c-7137-4170-bbf5-3fbd51afcc50', '{"sub":"b50d710c-7137-4170-bbf5-3fbd51afcc50","email":"teste.1770407502800.3937.28@loadtest.com","email_verified":true}', 'email', 'b50d710c-7137-4170-bbf5-3fbd51afcc50', '2026-02-06T22:51:58.000Z', '2026-02-06T22:51:58.000Z', '2026-02-06T22:51:59.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 28', cpf = '10000000028', phone = '11900000028', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'b50d710c-7137-4170-bbf5-3fbd51afcc50';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'b50d710c-7137-4170-bbf5-3fbd51afcc50';

-- Teste Usuario 40 (teste.1770407502809.8639.40@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('e1d59013-7d3b-4dc6-876c-45f86341e069', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502809.8639.40@loadtest.com', '', '2026-02-06T22:51:59.000Z', '2026-02-06T22:51:59.000Z', '2026-02-06T22:51:59.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 40"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('be11b0d6-8f4c-46ce-9e09-6ff1ab3b77a1', 'e1d59013-7d3b-4dc6-876c-45f86341e069', '{"sub":"e1d59013-7d3b-4dc6-876c-45f86341e069","email":"teste.1770407502809.8639.40@loadtest.com","email_verified":true}', 'email', 'e1d59013-7d3b-4dc6-876c-45f86341e069', '2026-02-06T22:51:59.000Z', '2026-02-06T22:51:59.000Z', '2026-02-06T22:51:59.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 40', cpf = '10000000040', phone = '11900000040', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'e1d59013-7d3b-4dc6-876c-45f86341e069';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'e1d59013-7d3b-4dc6-876c-45f86341e069';

-- Teste Usuario 22 (teste.1770407502796.2487.22@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('70cb9cfc-b3d7-454b-be3e-e6b3ea7ab731', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502796.2487.22@loadtest.com', '', '2026-02-06T22:51:59.000Z', '2026-02-06T22:51:59.000Z', '2026-02-06T22:51:59.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 22"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('46113779-0b1e-49da-bf30-6f34aff41efb', '70cb9cfc-b3d7-454b-be3e-e6b3ea7ab731', '{"sub":"70cb9cfc-b3d7-454b-be3e-e6b3ea7ab731","email":"teste.1770407502796.2487.22@loadtest.com","email_verified":true}', 'email', '70cb9cfc-b3d7-454b-be3e-e6b3ea7ab731', '2026-02-06T22:51:59.000Z', '2026-02-06T22:51:59.000Z', '2026-02-06T22:52:00.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 22', cpf = '10000000022', phone = '11900000022', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '70cb9cfc-b3d7-454b-be3e-e6b3ea7ab731';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '70cb9cfc-b3d7-454b-be3e-e6b3ea7ab731';

-- Teste Usuario 25 (teste.1770407502798.3500.25@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('e79b5340-96a2-4351-bba6-f0d2597a2874', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502798.3500.25@loadtest.com', '', '2026-02-06T22:52:00.000Z', '2026-02-06T22:52:00.000Z', '2026-02-06T22:52:00.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 25"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('5f931879-d441-4140-a8f2-690085bd1d38', 'e79b5340-96a2-4351-bba6-f0d2597a2874', '{"sub":"e79b5340-96a2-4351-bba6-f0d2597a2874","email":"teste.1770407502798.3500.25@loadtest.com","email_verified":true}', 'email', 'e79b5340-96a2-4351-bba6-f0d2597a2874', '2026-02-06T22:52:00.000Z', '2026-02-06T22:52:00.000Z', '2026-02-06T22:52:00.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 25', cpf = '10000000025', phone = '11900000025', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'e79b5340-96a2-4351-bba6-f0d2597a2874';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'e79b5340-96a2-4351-bba6-f0d2597a2874';

-- Teste Usuario 85 (teste.1770407502844.9283.85@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('1f7ec9cf-02cb-444d-a3a3-01a72941f70e', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502844.9283.85@loadtest.com', '', '2026-02-06T22:52:00.000Z', '2026-02-06T22:52:00.000Z', '2026-02-06T22:52:00.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 85"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('d15e2c80-146b-4585-9eba-1a9553fc8f60', '1f7ec9cf-02cb-444d-a3a3-01a72941f70e', '{"sub":"1f7ec9cf-02cb-444d-a3a3-01a72941f70e","email":"teste.1770407502844.9283.85@loadtest.com","email_verified":true}', 'email', '1f7ec9cf-02cb-444d-a3a3-01a72941f70e', '2026-02-06T22:52:00.000Z', '2026-02-06T22:52:00.000Z', '2026-02-06T22:52:01.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 85', cpf = '10000000085', phone = '11900000085', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '1f7ec9cf-02cb-444d-a3a3-01a72941f70e';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '1f7ec9cf-02cb-444d-a3a3-01a72941f70e';

-- Teste Usuario 44 (teste.1770407502812.7425.44@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('70cf6635-1877-4d1b-805e-d247ba9a5777', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502812.7425.44@loadtest.com', '', '2026-02-06T22:52:01.000Z', '2026-02-06T22:52:01.000Z', '2026-02-06T22:52:01.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 44"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('4fe0d54d-0dc5-49c1-9386-3b9c63d25445', '70cf6635-1877-4d1b-805e-d247ba9a5777', '{"sub":"70cf6635-1877-4d1b-805e-d247ba9a5777","email":"teste.1770407502812.7425.44@loadtest.com","email_verified":true}', 'email', '70cf6635-1877-4d1b-805e-d247ba9a5777', '2026-02-06T22:52:01.000Z', '2026-02-06T22:52:01.000Z', '2026-02-06T22:52:01.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 44', cpf = '10000000044', phone = '11900000044', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '70cf6635-1877-4d1b-805e-d247ba9a5777';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '70cf6635-1877-4d1b-805e-d247ba9a5777';

-- Teste Usuario 51 (teste.1770407502817.1818.51@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('23fa07b9-c623-43b4-9a57-da31ead82571', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502817.1818.51@loadtest.com', '', '2026-02-06T22:52:01.000Z', '2026-02-06T22:52:01.000Z', '2026-02-06T22:52:01.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 51"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('5fd71021-af94-49d9-b69f-9c5a5d623966', '23fa07b9-c623-43b4-9a57-da31ead82571', '{"sub":"23fa07b9-c623-43b4-9a57-da31ead82571","email":"teste.1770407502817.1818.51@loadtest.com","email_verified":true}', 'email', '23fa07b9-c623-43b4-9a57-da31ead82571', '2026-02-06T22:52:01.000Z', '2026-02-06T22:52:01.000Z', '2026-02-06T22:52:02.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 51', cpf = '10000000051', phone = '11900000051', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '23fa07b9-c623-43b4-9a57-da31ead82571';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '23fa07b9-c623-43b4-9a57-da31ead82571';

-- Teste Usuario 29 (teste.1770407502801.7249.29@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('ef19e5ab-f572-4de4-bb2b-e20bf5423e11', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502801.7249.29@loadtest.com', '', '2026-02-06T22:52:02.000Z', '2026-02-06T22:52:02.000Z', '2026-02-06T22:52:02.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 29"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('964cf3fc-d4e7-41a9-802f-e1ae76f31003', 'ef19e5ab-f572-4de4-bb2b-e20bf5423e11', '{"sub":"ef19e5ab-f572-4de4-bb2b-e20bf5423e11","email":"teste.1770407502801.7249.29@loadtest.com","email_verified":true}', 'email', 'ef19e5ab-f572-4de4-bb2b-e20bf5423e11', '2026-02-06T22:52:02.000Z', '2026-02-06T22:52:02.000Z', '2026-02-06T22:52:02.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 29', cpf = '10000000029', phone = '11900000029', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'ef19e5ab-f572-4de4-bb2b-e20bf5423e11';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'ef19e5ab-f572-4de4-bb2b-e20bf5423e11';

-- Teste Usuario 33 (teste.1770407502804.838.33@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('e1d5859f-b764-48f8-8b23-6e15624d2aa4', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502804.838.33@loadtest.com', '', '2026-02-06T22:52:02.000Z', '2026-02-06T22:52:02.000Z', '2026-02-06T22:52:02.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 33"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('1da9bc72-2a74-43a3-abb1-2c138af23b4b', 'e1d5859f-b764-48f8-8b23-6e15624d2aa4', '{"sub":"e1d5859f-b764-48f8-8b23-6e15624d2aa4","email":"teste.1770407502804.838.33@loadtest.com","email_verified":true}', 'email', 'e1d5859f-b764-48f8-8b23-6e15624d2aa4', '2026-02-06T22:52:02.000Z', '2026-02-06T22:52:02.000Z', '2026-02-06T22:52:02.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 33', cpf = '10000000033', phone = '11900000033', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'e1d5859f-b764-48f8-8b23-6e15624d2aa4';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'e1d5859f-b764-48f8-8b23-6e15624d2aa4';

-- Teste Usuario 38 (teste.1770407502807.2556.38@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('2b01d52e-76c3-4610-ba17-11110ee501a1', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502807.2556.38@loadtest.com', '', '2026-02-06T22:52:02.000Z', '2026-02-06T22:52:02.000Z', '2026-02-06T22:52:02.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 38"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('e811baf0-b350-4197-b05b-68f5a40f6771', '2b01d52e-76c3-4610-ba17-11110ee501a1', '{"sub":"2b01d52e-76c3-4610-ba17-11110ee501a1","email":"teste.1770407502807.2556.38@loadtest.com","email_verified":true}', 'email', '2b01d52e-76c3-4610-ba17-11110ee501a1', '2026-02-06T22:52:02.000Z', '2026-02-06T22:52:02.000Z', '2026-02-06T22:52:03.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 38', cpf = '10000000038', phone = '11900000038', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '2b01d52e-76c3-4610-ba17-11110ee501a1';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '2b01d52e-76c3-4610-ba17-11110ee501a1';

-- Teste Usuario 31 (teste.1770407502802.5574.31@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('deb5c06b-9f6c-44d0-ad1d-2afeee0f9cd0', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502802.5574.31@loadtest.com', '', '2026-02-06T22:52:03.000Z', '2026-02-06T22:52:03.000Z', '2026-02-06T22:52:03.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 31"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('70efe230-aa8d-473d-b0b5-30f07a8b42ea', 'deb5c06b-9f6c-44d0-ad1d-2afeee0f9cd0', '{"sub":"deb5c06b-9f6c-44d0-ad1d-2afeee0f9cd0","email":"teste.1770407502802.5574.31@loadtest.com","email_verified":true}', 'email', 'deb5c06b-9f6c-44d0-ad1d-2afeee0f9cd0', '2026-02-06T22:52:03.000Z', '2026-02-06T22:52:03.000Z', '2026-02-06T22:52:03.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 31', cpf = '10000000031', phone = '11900000031', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'deb5c06b-9f6c-44d0-ad1d-2afeee0f9cd0';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'deb5c06b-9f6c-44d0-ad1d-2afeee0f9cd0';

-- Teste Usuario 37 (teste.1770407502807.8803.37@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('9892d9e6-548e-4a67-a5d0-bfcfb464df40', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502807.8803.37@loadtest.com', '', '2026-02-06T22:52:03.000Z', '2026-02-06T22:52:03.000Z', '2026-02-06T22:52:03.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 37"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('725b9430-6c5b-4a0f-a20a-9debf4072e07', '9892d9e6-548e-4a67-a5d0-bfcfb464df40', '{"sub":"9892d9e6-548e-4a67-a5d0-bfcfb464df40","email":"teste.1770407502807.8803.37@loadtest.com","email_verified":true}', 'email', '9892d9e6-548e-4a67-a5d0-bfcfb464df40', '2026-02-06T22:52:03.000Z', '2026-02-06T22:52:03.000Z', '2026-02-06T22:52:04.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 37', cpf = '10000000037', phone = '11900000037', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '9892d9e6-548e-4a67-a5d0-bfcfb464df40';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '9892d9e6-548e-4a67-a5d0-bfcfb464df40';

-- Teste Usuario 34 (teste.1770407502805.3595.34@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('f4c1a0fc-207e-4e79-a7e5-31652d3bae1b', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502805.3595.34@loadtest.com', '', '2026-02-06T22:52:04.000Z', '2026-02-06T22:52:04.000Z', '2026-02-06T22:52:04.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 34"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('7905c62b-28da-457b-9756-59250eb61196', 'f4c1a0fc-207e-4e79-a7e5-31652d3bae1b', '{"sub":"f4c1a0fc-207e-4e79-a7e5-31652d3bae1b","email":"teste.1770407502805.3595.34@loadtest.com","email_verified":true}', 'email', 'f4c1a0fc-207e-4e79-a7e5-31652d3bae1b', '2026-02-06T22:52:04.000Z', '2026-02-06T22:52:04.000Z', '2026-02-06T22:52:04.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 34', cpf = '10000000034', phone = '11900000034', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'f4c1a0fc-207e-4e79-a7e5-31652d3bae1b';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'f4c1a0fc-207e-4e79-a7e5-31652d3bae1b';

-- Teste Usuario 42 (teste.1770407502810.1305.42@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('e601be62-3c96-4a38-8530-9267c85a938e', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502810.1305.42@loadtest.com', '', '2026-02-06T22:52:04.000Z', '2026-02-06T22:52:04.000Z', '2026-02-06T22:52:04.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 42"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('ce863f87-10c4-4d94-b70d-7a924c85d987', 'e601be62-3c96-4a38-8530-9267c85a938e', '{"sub":"e601be62-3c96-4a38-8530-9267c85a938e","email":"teste.1770407502810.1305.42@loadtest.com","email_verified":true}', 'email', 'e601be62-3c96-4a38-8530-9267c85a938e', '2026-02-06T22:52:04.000Z', '2026-02-06T22:52:04.000Z', '2026-02-06T22:52:05.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 42', cpf = '10000000042', phone = '11900000042', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'e601be62-3c96-4a38-8530-9267c85a938e';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'e601be62-3c96-4a38-8530-9267c85a938e';

-- Teste Usuario 32 (teste.1770407502803.639.32@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('264e9598-0324-4a23-9c1c-d0b86c535099', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502803.639.32@loadtest.com', '', '2026-02-06T22:52:05.000Z', '2026-02-06T22:52:05.000Z', '2026-02-06T22:52:05.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 32"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('e1067c33-90e2-404b-bbf7-f00cc4f0ea3a', '264e9598-0324-4a23-9c1c-d0b86c535099', '{"sub":"264e9598-0324-4a23-9c1c-d0b86c535099","email":"teste.1770407502803.639.32@loadtest.com","email_verified":true}', 'email', '264e9598-0324-4a23-9c1c-d0b86c535099', '2026-02-06T22:52:05.000Z', '2026-02-06T22:52:05.000Z', '2026-02-06T22:52:05.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 32', cpf = '10000000032', phone = '11900000032', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '264e9598-0324-4a23-9c1c-d0b86c535099';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '264e9598-0324-4a23-9c1c-d0b86c535099';

-- Teste Usuario 46 (teste.1770407502813.4674.46@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('5f8ea7af-5d56-42c3-a46c-63e34f239549', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502813.4674.46@loadtest.com', '', '2026-02-06T22:52:05.000Z', '2026-02-06T22:52:05.000Z', '2026-02-06T22:52:05.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 46"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('2c6e65b4-0d55-4318-8356-f7c074d94965', '5f8ea7af-5d56-42c3-a46c-63e34f239549', '{"sub":"5f8ea7af-5d56-42c3-a46c-63e34f239549","email":"teste.1770407502813.4674.46@loadtest.com","email_verified":true}', 'email', '5f8ea7af-5d56-42c3-a46c-63e34f239549', '2026-02-06T22:52:05.000Z', '2026-02-06T22:52:05.000Z', '2026-02-06T22:52:05.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 46', cpf = '10000000046', phone = '11900000046', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '5f8ea7af-5d56-42c3-a46c-63e34f239549';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '5f8ea7af-5d56-42c3-a46c-63e34f239549';

-- Teste Usuario 48 (teste.1770407502814.5100.48@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('1a4f7d4e-16dc-4e72-9bd5-a31215a7645f', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502814.5100.48@loadtest.com', '', '2026-02-06T22:52:06.000Z', '2026-02-06T22:52:06.000Z', '2026-02-06T22:52:06.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 48"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('5a8385c1-e4fb-4e35-92cb-f9bf025a4d2d', '1a4f7d4e-16dc-4e72-9bd5-a31215a7645f', '{"sub":"1a4f7d4e-16dc-4e72-9bd5-a31215a7645f","email":"teste.1770407502814.5100.48@loadtest.com","email_verified":true}', 'email', '1a4f7d4e-16dc-4e72-9bd5-a31215a7645f', '2026-02-06T22:52:06.000Z', '2026-02-06T22:52:06.000Z', '2026-02-06T22:52:06.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 48', cpf = '10000000048', phone = '11900000048', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '1a4f7d4e-16dc-4e72-9bd5-a31215a7645f';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '1a4f7d4e-16dc-4e72-9bd5-a31215a7645f';

-- Teste Usuario 47 (teste.1770407502814.91.47@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('fdc5e636-0b68-4cee-acc9-222da14f2782', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502814.91.47@loadtest.com', '', '2026-02-06T22:52:06.000Z', '2026-02-06T22:52:06.000Z', '2026-02-06T22:52:06.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 47"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('83cb7874-136a-41e4-a007-41f5ab3dabac', 'fdc5e636-0b68-4cee-acc9-222da14f2782', '{"sub":"fdc5e636-0b68-4cee-acc9-222da14f2782","email":"teste.1770407502814.91.47@loadtest.com","email_verified":true}', 'email', 'fdc5e636-0b68-4cee-acc9-222da14f2782', '2026-02-06T22:52:06.000Z', '2026-02-06T22:52:06.000Z', '2026-02-06T22:52:06.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 47', cpf = '10000000047', phone = '11900000047', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'fdc5e636-0b68-4cee-acc9-222da14f2782';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'fdc5e636-0b68-4cee-acc9-222da14f2782';

-- Teste Usuario 45 (teste.1770407502812.6317.45@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('66dc2bf4-0917-493c-8331-5f266ccfbf91', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502812.6317.45@loadtest.com', '', '2026-02-06T22:52:06.000Z', '2026-02-06T22:52:06.000Z', '2026-02-06T22:52:06.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 45"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('345b8514-86d1-4e52-b96c-e64127e82333', '66dc2bf4-0917-493c-8331-5f266ccfbf91', '{"sub":"66dc2bf4-0917-493c-8331-5f266ccfbf91","email":"teste.1770407502812.6317.45@loadtest.com","email_verified":true}', 'email', '66dc2bf4-0917-493c-8331-5f266ccfbf91', '2026-02-06T22:52:06.000Z', '2026-02-06T22:52:06.000Z', '2026-02-06T22:52:07.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 45', cpf = '10000000045', phone = '11900000045', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '66dc2bf4-0917-493c-8331-5f266ccfbf91';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '66dc2bf4-0917-493c-8331-5f266ccfbf91';

-- Teste Usuario 55 (teste.1770407502821.686.55@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('079aedfc-6ba7-4ecd-9714-9728ca1ea366', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502821.686.55@loadtest.com', '', '2026-02-06T22:52:07.000Z', '2026-02-06T22:52:07.000Z', '2026-02-06T22:52:07.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 55"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('1569eb43-fd7a-40c9-873c-885584412740', '079aedfc-6ba7-4ecd-9714-9728ca1ea366', '{"sub":"079aedfc-6ba7-4ecd-9714-9728ca1ea366","email":"teste.1770407502821.686.55@loadtest.com","email_verified":true}', 'email', '079aedfc-6ba7-4ecd-9714-9728ca1ea366', '2026-02-06T22:52:07.000Z', '2026-02-06T22:52:07.000Z', '2026-02-06T22:52:07.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 55', cpf = '10000000055', phone = '11900000055', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '079aedfc-6ba7-4ecd-9714-9728ca1ea366';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '079aedfc-6ba7-4ecd-9714-9728ca1ea366';

-- Teste Usuario 30 (teste.1770407502802.9551.30@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('319ffe52-604c-496a-9cb7-5fd21f04e2b9', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502802.9551.30@loadtest.com', '', '2026-02-06T22:52:07.000Z', '2026-02-06T22:52:07.000Z', '2026-02-06T22:52:07.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 30"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('3e23239b-e96e-4ed3-a869-f11b3bb30ebc', '319ffe52-604c-496a-9cb7-5fd21f04e2b9', '{"sub":"319ffe52-604c-496a-9cb7-5fd21f04e2b9","email":"teste.1770407502802.9551.30@loadtest.com","email_verified":true}', 'email', '319ffe52-604c-496a-9cb7-5fd21f04e2b9', '2026-02-06T22:52:07.000Z', '2026-02-06T22:52:07.000Z', '2026-02-06T22:52:08.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 30', cpf = '10000000030', phone = '11900000030', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '319ffe52-604c-496a-9cb7-5fd21f04e2b9';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '319ffe52-604c-496a-9cb7-5fd21f04e2b9';

-- Teste Usuario 59 (teste.1770407502824.6799.59@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('3d672678-9697-4fb6-a40d-770c2fce1305', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502824.6799.59@loadtest.com', '', '2026-02-06T22:52:08.000Z', '2026-02-06T22:52:08.000Z', '2026-02-06T22:52:08.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 59"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('dae296c7-e5e1-44ff-a46a-474229a2884b', '3d672678-9697-4fb6-a40d-770c2fce1305', '{"sub":"3d672678-9697-4fb6-a40d-770c2fce1305","email":"teste.1770407502824.6799.59@loadtest.com","email_verified":true}', 'email', '3d672678-9697-4fb6-a40d-770c2fce1305', '2026-02-06T22:52:08.000Z', '2026-02-06T22:52:08.000Z', '2026-02-06T22:52:08.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 59', cpf = '10000000059', phone = '11900000059', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '3d672678-9697-4fb6-a40d-770c2fce1305';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '3d672678-9697-4fb6-a40d-770c2fce1305';

-- Teste Usuario 61 (teste.1770407502825.7736.61@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('8db7ff9b-1b05-4e6e-b7e3-191120fa3e6b', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502825.7736.61@loadtest.com', '', '2026-02-06T22:52:08.000Z', '2026-02-06T22:52:08.000Z', '2026-02-06T22:52:08.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 61"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('20721019-0732-4975-b2ba-e701b7f8f5d2', '8db7ff9b-1b05-4e6e-b7e3-191120fa3e6b', '{"sub":"8db7ff9b-1b05-4e6e-b7e3-191120fa3e6b","email":"teste.1770407502825.7736.61@loadtest.com","email_verified":true}', 'email', '8db7ff9b-1b05-4e6e-b7e3-191120fa3e6b', '2026-02-06T22:52:08.000Z', '2026-02-06T22:52:08.000Z', '2026-02-06T22:52:09.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 61', cpf = '10000000061', phone = '11900000061', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '8db7ff9b-1b05-4e6e-b7e3-191120fa3e6b';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '8db7ff9b-1b05-4e6e-b7e3-191120fa3e6b';

-- Teste Usuario 100 (teste.1770407502854.3743.100@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('a23c97a8-84ea-45a2-801d-f53bea9acfd5', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502854.3743.100@loadtest.com', '', '2026-02-06T22:52:09.000Z', '2026-02-06T22:52:09.000Z', '2026-02-06T22:52:09.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 100"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('50a3f278-7bb3-46b4-bdd4-f5aedb2b0745', 'a23c97a8-84ea-45a2-801d-f53bea9acfd5', '{"sub":"a23c97a8-84ea-45a2-801d-f53bea9acfd5","email":"teste.1770407502854.3743.100@loadtest.com","email_verified":true}', 'email', 'a23c97a8-84ea-45a2-801d-f53bea9acfd5', '2026-02-06T22:52:09.000Z', '2026-02-06T22:52:09.000Z', '2026-02-06T22:52:09.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 100', cpf = '10000000100', phone = '11900000100', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'a23c97a8-84ea-45a2-801d-f53bea9acfd5';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'a23c97a8-84ea-45a2-801d-f53bea9acfd5';

-- Teste Usuario 77 (teste.1770407502837.7792.77@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('fce46910-f194-4e3c-ab6b-818c72a8cfa3', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502837.7792.77@loadtest.com', '', '2026-02-06T22:52:09.000Z', '2026-02-06T22:52:09.000Z', '2026-02-06T22:52:09.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 77"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('411736a7-d531-4e34-a2da-1e18371549d6', 'fce46910-f194-4e3c-ab6b-818c72a8cfa3', '{"sub":"fce46910-f194-4e3c-ab6b-818c72a8cfa3","email":"teste.1770407502837.7792.77@loadtest.com","email_verified":true}', 'email', 'fce46910-f194-4e3c-ab6b-818c72a8cfa3', '2026-02-06T22:52:09.000Z', '2026-02-06T22:52:09.000Z', '2026-02-06T22:52:09.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 77', cpf = '10000000077', phone = '11900000077', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'fce46910-f194-4e3c-ab6b-818c72a8cfa3';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'fce46910-f194-4e3c-ab6b-818c72a8cfa3';

-- Teste Usuario 53 (teste.1770407502820.3572.53@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('678859ce-3cf0-40f2-a181-d7eeef73260f', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502820.3572.53@loadtest.com', '', '2026-02-06T22:52:09.000Z', '2026-02-06T22:52:09.000Z', '2026-02-06T22:52:09.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 53"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('83bc1268-044d-4b8b-9780-85f50b8ea380', '678859ce-3cf0-40f2-a181-d7eeef73260f', '{"sub":"678859ce-3cf0-40f2-a181-d7eeef73260f","email":"teste.1770407502820.3572.53@loadtest.com","email_verified":true}', 'email', '678859ce-3cf0-40f2-a181-d7eeef73260f', '2026-02-06T22:52:09.000Z', '2026-02-06T22:52:09.000Z', '2026-02-06T22:52:10.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 53', cpf = '10000000053', phone = '11900000053', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '678859ce-3cf0-40f2-a181-d7eeef73260f';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '678859ce-3cf0-40f2-a181-d7eeef73260f';

-- Teste Usuario 50 (teste.1770407502816.7977.50@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('a9ad7145-a206-4305-b00c-5d1a45c7e586', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502816.7977.50@loadtest.com', '', '2026-02-06T22:52:10.000Z', '2026-02-06T22:52:10.000Z', '2026-02-06T22:52:10.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 50"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('c97a54b4-124a-499b-b761-6e27e51c12c9', 'a9ad7145-a206-4305-b00c-5d1a45c7e586', '{"sub":"a9ad7145-a206-4305-b00c-5d1a45c7e586","email":"teste.1770407502816.7977.50@loadtest.com","email_verified":true}', 'email', 'a9ad7145-a206-4305-b00c-5d1a45c7e586', '2026-02-06T22:52:10.000Z', '2026-02-06T22:52:10.000Z', '2026-02-06T22:52:10.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 50', cpf = '10000000050', phone = '11900000050', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'a9ad7145-a206-4305-b00c-5d1a45c7e586';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'a9ad7145-a206-4305-b00c-5d1a45c7e586';

-- Teste Usuario 56 (teste.1770407502822.3591.56@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('bad4d7c8-5b0c-46f2-b4f9-24a2a4575b56', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502822.3591.56@loadtest.com', '', '2026-02-06T22:52:10.000Z', '2026-02-06T22:52:10.000Z', '2026-02-06T22:52:10.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 56"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('8b521003-d006-4411-837d-5d150888c192', 'bad4d7c8-5b0c-46f2-b4f9-24a2a4575b56', '{"sub":"bad4d7c8-5b0c-46f2-b4f9-24a2a4575b56","email":"teste.1770407502822.3591.56@loadtest.com","email_verified":true}', 'email', 'bad4d7c8-5b0c-46f2-b4f9-24a2a4575b56', '2026-02-06T22:52:10.000Z', '2026-02-06T22:52:10.000Z', '2026-02-06T22:52:11.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 56', cpf = '10000000056', phone = '11900000056', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'bad4d7c8-5b0c-46f2-b4f9-24a2a4575b56';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'bad4d7c8-5b0c-46f2-b4f9-24a2a4575b56';

-- Teste Usuario 91 (teste.1770407502848.3271.91@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('ccce6e6c-b294-45c0-b900-135867dabf5d', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502848.3271.91@loadtest.com', '', '2026-02-06T22:52:11.000Z', '2026-02-06T22:52:11.000Z', '2026-02-06T22:52:11.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 91"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('2b2fad69-1403-4b4c-9c94-ecf6d658d18e', 'ccce6e6c-b294-45c0-b900-135867dabf5d', '{"sub":"ccce6e6c-b294-45c0-b900-135867dabf5d","email":"teste.1770407502848.3271.91@loadtest.com","email_verified":true}', 'email', 'ccce6e6c-b294-45c0-b900-135867dabf5d', '2026-02-06T22:52:11.000Z', '2026-02-06T22:52:11.000Z', '2026-02-06T22:52:11.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 91', cpf = '10000000091', phone = '11900000091', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'ccce6e6c-b294-45c0-b900-135867dabf5d';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'ccce6e6c-b294-45c0-b900-135867dabf5d';

-- Teste Usuario 54 (teste.1770407502820.7427.54@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('2306d466-b9cd-4880-87e6-ec5159eb1ff3', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502820.7427.54@loadtest.com', '', '2026-02-06T22:52:11.000Z', '2026-02-06T22:52:11.000Z', '2026-02-06T22:52:11.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 54"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('d4a4103d-bafe-46f3-a130-caa4add7cb5c', '2306d466-b9cd-4880-87e6-ec5159eb1ff3', '{"sub":"2306d466-b9cd-4880-87e6-ec5159eb1ff3","email":"teste.1770407502820.7427.54@loadtest.com","email_verified":true}', 'email', '2306d466-b9cd-4880-87e6-ec5159eb1ff3', '2026-02-06T22:52:11.000Z', '2026-02-06T22:52:11.000Z', '2026-02-06T22:52:12.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 54', cpf = '10000000054', phone = '11900000054', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '2306d466-b9cd-4880-87e6-ec5159eb1ff3';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '2306d466-b9cd-4880-87e6-ec5159eb1ff3';

-- Teste Usuario 36 (teste.1770407502806.7146.36@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('f3c2255d-635c-41de-97aa-7b500c1cc36e', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502806.7146.36@loadtest.com', '', '2026-02-06T22:52:12.000Z', '2026-02-06T22:52:12.000Z', '2026-02-06T22:52:12.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 36"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('e38827e6-bce1-4bdd-9f59-1cae9e28843e', 'f3c2255d-635c-41de-97aa-7b500c1cc36e', '{"sub":"f3c2255d-635c-41de-97aa-7b500c1cc36e","email":"teste.1770407502806.7146.36@loadtest.com","email_verified":true}', 'email', 'f3c2255d-635c-41de-97aa-7b500c1cc36e', '2026-02-06T22:52:12.000Z', '2026-02-06T22:52:12.000Z', '2026-02-06T22:52:12.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 36', cpf = '10000000036', phone = '11900000036', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'f3c2255d-635c-41de-97aa-7b500c1cc36e';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'f3c2255d-635c-41de-97aa-7b500c1cc36e';

-- Teste Usuario 58 (teste.1770407502823.5604.58@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('f3046dfb-be9b-4e2f-aaa0-b3640bb7e8c3', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502823.5604.58@loadtest.com', '', '2026-02-06T22:52:12.000Z', '2026-02-06T22:52:12.000Z', '2026-02-06T22:52:12.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 58"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('03a592fe-39fd-44e8-85dd-902dd54b929e', 'f3046dfb-be9b-4e2f-aaa0-b3640bb7e8c3', '{"sub":"f3046dfb-be9b-4e2f-aaa0-b3640bb7e8c3","email":"teste.1770407502823.5604.58@loadtest.com","email_verified":true}', 'email', 'f3046dfb-be9b-4e2f-aaa0-b3640bb7e8c3', '2026-02-06T22:52:12.000Z', '2026-02-06T22:52:12.000Z', '2026-02-06T22:52:12.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 58', cpf = '10000000058', phone = '11900000058', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'f3046dfb-be9b-4e2f-aaa0-b3640bb7e8c3';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'f3046dfb-be9b-4e2f-aaa0-b3640bb7e8c3';

-- Teste Usuario 49 (teste.1770407502815.8109.49@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('b0edfa38-f31b-422b-84ae-dfe3880431cc', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502815.8109.49@loadtest.com', '', '2026-02-06T22:52:13.000Z', '2026-02-06T22:52:13.000Z', '2026-02-06T22:52:13.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 49"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('4db2847e-7362-4654-998e-50ec3b0d756e', 'b0edfa38-f31b-422b-84ae-dfe3880431cc', '{"sub":"b0edfa38-f31b-422b-84ae-dfe3880431cc","email":"teste.1770407502815.8109.49@loadtest.com","email_verified":true}', 'email', 'b0edfa38-f31b-422b-84ae-dfe3880431cc', '2026-02-06T22:52:13.000Z', '2026-02-06T22:52:13.000Z', '2026-02-06T22:52:13.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 49', cpf = '10000000049', phone = '11900000049', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'b0edfa38-f31b-422b-84ae-dfe3880431cc';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'b0edfa38-f31b-422b-84ae-dfe3880431cc';

-- Teste Usuario 66 (teste.1770407502829.7652.66@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('3d6d0c43-c9a6-4cab-aa89-ae8a829c6c38', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502829.7652.66@loadtest.com', '', '2026-02-06T22:52:13.000Z', '2026-02-06T22:52:13.000Z', '2026-02-06T22:52:13.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 66"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('9556dabf-34f0-417c-99ac-43dbcc34d461', '3d6d0c43-c9a6-4cab-aa89-ae8a829c6c38', '{"sub":"3d6d0c43-c9a6-4cab-aa89-ae8a829c6c38","email":"teste.1770407502829.7652.66@loadtest.com","email_verified":true}', 'email', '3d6d0c43-c9a6-4cab-aa89-ae8a829c6c38', '2026-02-06T22:52:13.000Z', '2026-02-06T22:52:13.000Z', '2026-02-06T22:52:13.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 66', cpf = '10000000066', phone = '11900000066', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '3d6d0c43-c9a6-4cab-aa89-ae8a829c6c38';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '3d6d0c43-c9a6-4cab-aa89-ae8a829c6c38';

-- Teste Usuario 69 (teste.1770407502831.8929.69@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('7372a609-8186-4c78-9c56-37a0c8d131ee', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502831.8929.69@loadtest.com', '', '2026-02-06T22:52:13.000Z', '2026-02-06T22:52:13.000Z', '2026-02-06T22:52:13.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 69"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('365274f9-6e1d-4fbd-a730-d7dc9874ffb7', '7372a609-8186-4c78-9c56-37a0c8d131ee', '{"sub":"7372a609-8186-4c78-9c56-37a0c8d131ee","email":"teste.1770407502831.8929.69@loadtest.com","email_verified":true}', 'email', '7372a609-8186-4c78-9c56-37a0c8d131ee', '2026-02-06T22:52:13.000Z', '2026-02-06T22:52:13.000Z', '2026-02-06T22:52:14.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 69', cpf = '10000000069', phone = '11900000069', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '7372a609-8186-4c78-9c56-37a0c8d131ee';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '7372a609-8186-4c78-9c56-37a0c8d131ee';

-- Teste Usuario 68 (teste.1770407502830.6365.68@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('d5edf0fa-7322-4efb-8aae-d75c0b9a8afe', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502830.6365.68@loadtest.com', '', '2026-02-06T22:52:14.000Z', '2026-02-06T22:52:14.000Z', '2026-02-06T22:52:14.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 68"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('9ca3709c-177c-497f-baae-805403bacba8', 'd5edf0fa-7322-4efb-8aae-d75c0b9a8afe', '{"sub":"d5edf0fa-7322-4efb-8aae-d75c0b9a8afe","email":"teste.1770407502830.6365.68@loadtest.com","email_verified":true}', 'email', 'd5edf0fa-7322-4efb-8aae-d75c0b9a8afe', '2026-02-06T22:52:14.000Z', '2026-02-06T22:52:14.000Z', '2026-02-06T22:52:14.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 68', cpf = '10000000068', phone = '11900000068', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'd5edf0fa-7322-4efb-8aae-d75c0b9a8afe';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'd5edf0fa-7322-4efb-8aae-d75c0b9a8afe';

-- Teste Usuario 93 (teste.1770407502849.6833.93@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('b6bab5cd-8c9e-46bd-b6dc-e9080606296d', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502849.6833.93@loadtest.com', '', '2026-02-06T22:52:14.000Z', '2026-02-06T22:52:14.000Z', '2026-02-06T22:52:14.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 93"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('4e264b34-d439-4ecf-ae8b-3a0647246ef2', 'b6bab5cd-8c9e-46bd-b6dc-e9080606296d', '{"sub":"b6bab5cd-8c9e-46bd-b6dc-e9080606296d","email":"teste.1770407502849.6833.93@loadtest.com","email_verified":true}', 'email', 'b6bab5cd-8c9e-46bd-b6dc-e9080606296d', '2026-02-06T22:52:14.000Z', '2026-02-06T22:52:14.000Z', '2026-02-06T22:52:15.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 93', cpf = '10000000093', phone = '11900000093', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'b6bab5cd-8c9e-46bd-b6dc-e9080606296d';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'b6bab5cd-8c9e-46bd-b6dc-e9080606296d';

-- Teste Usuario 96 (teste.1770407502852.4811.96@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('a7982a49-97a6-433d-b4ab-e8e67f308c7e', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502852.4811.96@loadtest.com', '', '2026-02-06T22:52:15.000Z', '2026-02-06T22:52:15.000Z', '2026-02-06T22:52:15.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 96"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('576194e9-fbea-4a62-8c6e-cdc792dc6016', 'a7982a49-97a6-433d-b4ab-e8e67f308c7e', '{"sub":"a7982a49-97a6-433d-b4ab-e8e67f308c7e","email":"teste.1770407502852.4811.96@loadtest.com","email_verified":true}', 'email', 'a7982a49-97a6-433d-b4ab-e8e67f308c7e', '2026-02-06T22:52:15.000Z', '2026-02-06T22:52:15.000Z', '2026-02-06T22:52:15.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 96', cpf = '10000000096', phone = '11900000096', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'a7982a49-97a6-433d-b4ab-e8e67f308c7e';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'a7982a49-97a6-433d-b4ab-e8e67f308c7e';

-- Teste Usuario 57 (teste.1770407502822.2671.57@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('5ce614bb-a889-43a6-a511-32b547b0eb3e', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502822.2671.57@loadtest.com', '', '2026-02-06T22:52:15.000Z', '2026-02-06T22:52:15.000Z', '2026-02-06T22:52:15.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 57"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('16358bfe-fbe7-4082-b57d-53f85170ed55', '5ce614bb-a889-43a6-a511-32b547b0eb3e', '{"sub":"5ce614bb-a889-43a6-a511-32b547b0eb3e","email":"teste.1770407502822.2671.57@loadtest.com","email_verified":true}', 'email', '5ce614bb-a889-43a6-a511-32b547b0eb3e', '2026-02-06T22:52:15.000Z', '2026-02-06T22:52:15.000Z', '2026-02-06T22:52:16.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 57', cpf = '10000000057', phone = '11900000057', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '5ce614bb-a889-43a6-a511-32b547b0eb3e';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '5ce614bb-a889-43a6-a511-32b547b0eb3e';

-- Teste Usuario 64 (teste.1770407502828.3342.64@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('3150755d-c2bb-4ffd-b844-975380642a22', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502828.3342.64@loadtest.com', '', '2026-02-06T22:52:16.000Z', '2026-02-06T22:52:16.000Z', '2026-02-06T22:52:16.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 64"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('bb53b424-27fa-4b5e-931a-1979882e2f0d', '3150755d-c2bb-4ffd-b844-975380642a22', '{"sub":"3150755d-c2bb-4ffd-b844-975380642a22","email":"teste.1770407502828.3342.64@loadtest.com","email_verified":true}', 'email', '3150755d-c2bb-4ffd-b844-975380642a22', '2026-02-06T22:52:16.000Z', '2026-02-06T22:52:16.000Z', '2026-02-06T22:52:16.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 64', cpf = '10000000064', phone = '11900000064', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '3150755d-c2bb-4ffd-b844-975380642a22';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '3150755d-c2bb-4ffd-b844-975380642a22';

-- Teste Usuario 76 (teste.1770407502836.5557.76@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('93446eec-34c8-4097-8d76-2fe3397be25b', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502836.5557.76@loadtest.com', '', '2026-02-06T22:52:16.000Z', '2026-02-06T22:52:16.000Z', '2026-02-06T22:52:16.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 76"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('864d810e-5116-4231-b5b9-1d08c75db76f', '93446eec-34c8-4097-8d76-2fe3397be25b', '{"sub":"93446eec-34c8-4097-8d76-2fe3397be25b","email":"teste.1770407502836.5557.76@loadtest.com","email_verified":true}', 'email', '93446eec-34c8-4097-8d76-2fe3397be25b', '2026-02-06T22:52:16.000Z', '2026-02-06T22:52:16.000Z', '2026-02-06T22:52:16.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 76', cpf = '10000000076', phone = '11900000076', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '93446eec-34c8-4097-8d76-2fe3397be25b';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '93446eec-34c8-4097-8d76-2fe3397be25b';

-- Teste Usuario 78 (teste.1770407502838.1172.78@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('40e07108-2b87-48c2-baef-cd9a04affc0e', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502838.1172.78@loadtest.com', '', '2026-02-06T22:52:16.000Z', '2026-02-06T22:52:16.000Z', '2026-02-06T22:52:16.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 78"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('b5a1f4d8-1a18-4993-90d6-0d56cfd22b2c', '40e07108-2b87-48c2-baef-cd9a04affc0e', '{"sub":"40e07108-2b87-48c2-baef-cd9a04affc0e","email":"teste.1770407502838.1172.78@loadtest.com","email_verified":true}', 'email', '40e07108-2b87-48c2-baef-cd9a04affc0e', '2026-02-06T22:52:16.000Z', '2026-02-06T22:52:16.000Z', '2026-02-06T22:52:17.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 78', cpf = '10000000078', phone = '11900000078', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '40e07108-2b87-48c2-baef-cd9a04affc0e';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '40e07108-2b87-48c2-baef-cd9a04affc0e';

-- Teste Usuario 71 (teste.1770407502833.6207.71@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('d32c3873-b4dc-42f2-91e5-9a9fdecc032e', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502833.6207.71@loadtest.com', '', '2026-02-06T22:52:17.000Z', '2026-02-06T22:52:17.000Z', '2026-02-06T22:52:17.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 71"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('524a0aa0-da43-4cb0-aff0-18d00a3e0c89', 'd32c3873-b4dc-42f2-91e5-9a9fdecc032e', '{"sub":"d32c3873-b4dc-42f2-91e5-9a9fdecc032e","email":"teste.1770407502833.6207.71@loadtest.com","email_verified":true}', 'email', 'd32c3873-b4dc-42f2-91e5-9a9fdecc032e', '2026-02-06T22:52:17.000Z', '2026-02-06T22:52:17.000Z', '2026-02-06T22:52:17.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 71', cpf = '10000000071', phone = '11900000071', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'd32c3873-b4dc-42f2-91e5-9a9fdecc032e';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'd32c3873-b4dc-42f2-91e5-9a9fdecc032e';

-- Teste Usuario 39 (teste.1770407502808.6910.39@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('06205af5-d367-4f57-bfc0-cf2aa13f32db', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502808.6910.39@loadtest.com', '', '2026-02-06T22:52:17.000Z', '2026-02-06T22:52:17.000Z', '2026-02-06T22:52:17.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 39"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('f61841ae-945d-4406-9513-eed338a39546', '06205af5-d367-4f57-bfc0-cf2aa13f32db', '{"sub":"06205af5-d367-4f57-bfc0-cf2aa13f32db","email":"teste.1770407502808.6910.39@loadtest.com","email_verified":true}', 'email', '06205af5-d367-4f57-bfc0-cf2aa13f32db', '2026-02-06T22:52:17.000Z', '2026-02-06T22:52:17.000Z', '2026-02-06T22:52:18.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 39', cpf = '10000000039', phone = '11900000039', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '06205af5-d367-4f57-bfc0-cf2aa13f32db';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '06205af5-d367-4f57-bfc0-cf2aa13f32db';

-- Teste Usuario 41 (teste.1770407502809.9820.41@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('c4417fe7-9736-4198-88bf-32de38f551ee', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502809.9820.41@loadtest.com', '', '2026-02-06T22:52:18.000Z', '2026-02-06T22:52:18.000Z', '2026-02-06T22:52:18.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 41"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('b76e3da1-005b-4d2b-9562-f6a2c281298f', 'c4417fe7-9736-4198-88bf-32de38f551ee', '{"sub":"c4417fe7-9736-4198-88bf-32de38f551ee","email":"teste.1770407502809.9820.41@loadtest.com","email_verified":true}', 'email', 'c4417fe7-9736-4198-88bf-32de38f551ee', '2026-02-06T22:52:18.000Z', '2026-02-06T22:52:18.000Z', '2026-02-06T22:52:18.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 41', cpf = '10000000041', phone = '11900000041', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'c4417fe7-9736-4198-88bf-32de38f551ee';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'c4417fe7-9736-4198-88bf-32de38f551ee';

-- Teste Usuario 72 (teste.1770407502833.5914.72@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('62af018b-88a4-4938-8f73-18baddf78788', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502833.5914.72@loadtest.com', '', '2026-02-06T22:52:18.000Z', '2026-02-06T22:52:18.000Z', '2026-02-06T22:52:18.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 72"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('35dcc9da-6651-44ac-a54d-375a03a7d242', '62af018b-88a4-4938-8f73-18baddf78788', '{"sub":"62af018b-88a4-4938-8f73-18baddf78788","email":"teste.1770407502833.5914.72@loadtest.com","email_verified":true}', 'email', '62af018b-88a4-4938-8f73-18baddf78788', '2026-02-06T22:52:18.000Z', '2026-02-06T22:52:18.000Z', '2026-02-06T22:52:19.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 72', cpf = '10000000072', phone = '11900000072', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '62af018b-88a4-4938-8f73-18baddf78788';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '62af018b-88a4-4938-8f73-18baddf78788';

-- Teste Usuario 67 (teste.1770407502830.2584.67@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('c9d68db0-f7fa-48ad-8616-f052b4c34dc8', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502830.2584.67@loadtest.com', '', '2026-02-06T22:52:19.000Z', '2026-02-06T22:52:19.000Z', '2026-02-06T22:52:19.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 67"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('30b13510-2478-40e5-8f3e-ed4bbc2abde3', 'c9d68db0-f7fa-48ad-8616-f052b4c34dc8', '{"sub":"c9d68db0-f7fa-48ad-8616-f052b4c34dc8","email":"teste.1770407502830.2584.67@loadtest.com","email_verified":true}', 'email', 'c9d68db0-f7fa-48ad-8616-f052b4c34dc8', '2026-02-06T22:52:19.000Z', '2026-02-06T22:52:19.000Z', '2026-02-06T22:52:19.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 67', cpf = '10000000067', phone = '11900000067', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'c9d68db0-f7fa-48ad-8616-f052b4c34dc8';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'c9d68db0-f7fa-48ad-8616-f052b4c34dc8';

-- Teste Usuario 73 (teste.1770407502834.8835.73@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('61204888-a741-40b9-a1f2-f67fe3f46433', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502834.8835.73@loadtest.com', '', '2026-02-06T22:52:19.000Z', '2026-02-06T22:52:19.000Z', '2026-02-06T22:52:19.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 73"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('8c1866b0-d13d-41dd-b7c4-a39376eb7fcf', '61204888-a741-40b9-a1f2-f67fe3f46433', '{"sub":"61204888-a741-40b9-a1f2-f67fe3f46433","email":"teste.1770407502834.8835.73@loadtest.com","email_verified":true}', 'email', '61204888-a741-40b9-a1f2-f67fe3f46433', '2026-02-06T22:52:19.000Z', '2026-02-06T22:52:19.000Z', '2026-02-06T22:52:19.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 73', cpf = '10000000073', phone = '11900000073', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '61204888-a741-40b9-a1f2-f67fe3f46433';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '61204888-a741-40b9-a1f2-f67fe3f46433';

-- Teste Usuario 83 (teste.1770407502843.5992.83@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('c13305e0-cab6-4cbd-b108-ed90b199bdc9', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502843.5992.83@loadtest.com', '', '2026-02-06T22:52:20.000Z', '2026-02-06T22:52:20.000Z', '2026-02-06T22:52:20.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 83"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('b6107445-cef5-49af-9647-0828806f5929', 'c13305e0-cab6-4cbd-b108-ed90b199bdc9', '{"sub":"c13305e0-cab6-4cbd-b108-ed90b199bdc9","email":"teste.1770407502843.5992.83@loadtest.com","email_verified":true}', 'email', 'c13305e0-cab6-4cbd-b108-ed90b199bdc9', '2026-02-06T22:52:20.000Z', '2026-02-06T22:52:20.000Z', '2026-02-06T22:52:20.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 83', cpf = '10000000083', phone = '11900000083', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'c13305e0-cab6-4cbd-b108-ed90b199bdc9';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'c13305e0-cab6-4cbd-b108-ed90b199bdc9';

-- Teste Usuario 43 (teste.1770407502811.3994.43@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('be91af8c-4cf0-471a-ac72-a6d570d9f41e', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502811.3994.43@loadtest.com', '', '2026-02-06T22:52:20.000Z', '2026-02-06T22:52:20.000Z', '2026-02-06T22:52:20.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 43"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('ad0be8e6-a12b-445e-9ca5-b508eb88434c', 'be91af8c-4cf0-471a-ac72-a6d570d9f41e', '{"sub":"be91af8c-4cf0-471a-ac72-a6d570d9f41e","email":"teste.1770407502811.3994.43@loadtest.com","email_verified":true}', 'email', 'be91af8c-4cf0-471a-ac72-a6d570d9f41e', '2026-02-06T22:52:20.000Z', '2026-02-06T22:52:20.000Z', '2026-02-06T22:52:20.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 43', cpf = '10000000043', phone = '11900000043', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'be91af8c-4cf0-471a-ac72-a6d570d9f41e';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'be91af8c-4cf0-471a-ac72-a6d570d9f41e';

-- Teste Usuario 62 (teste.1770407502826.6293.62@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('578fe5e7-0b4c-4ba8-afa5-fd094f85434c', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502826.6293.62@loadtest.com', '', '2026-02-06T22:52:20.000Z', '2026-02-06T22:52:20.000Z', '2026-02-06T22:52:20.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 62"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('5e544b20-e66d-40e1-a104-12ced1cee924', '578fe5e7-0b4c-4ba8-afa5-fd094f85434c', '{"sub":"578fe5e7-0b4c-4ba8-afa5-fd094f85434c","email":"teste.1770407502826.6293.62@loadtest.com","email_verified":true}', 'email', '578fe5e7-0b4c-4ba8-afa5-fd094f85434c', '2026-02-06T22:52:20.000Z', '2026-02-06T22:52:20.000Z', '2026-02-06T22:52:21.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 62', cpf = '10000000062', phone = '11900000062', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '578fe5e7-0b4c-4ba8-afa5-fd094f85434c';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '578fe5e7-0b4c-4ba8-afa5-fd094f85434c';

-- Teste Usuario 52 (teste.1770407502819.622.52@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('cfb272d2-86c7-4c6b-9fea-17355db0daca', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502819.622.52@loadtest.com', '', '2026-02-06T22:52:21.000Z', '2026-02-06T22:52:21.000Z', '2026-02-06T22:52:21.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 52"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('0f5ebb55-3200-40e4-ad0b-b309333ca8a1', 'cfb272d2-86c7-4c6b-9fea-17355db0daca', '{"sub":"cfb272d2-86c7-4c6b-9fea-17355db0daca","email":"teste.1770407502819.622.52@loadtest.com","email_verified":true}', 'email', 'cfb272d2-86c7-4c6b-9fea-17355db0daca', '2026-02-06T22:52:21.000Z', '2026-02-06T22:52:21.000Z', '2026-02-06T22:52:21.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 52', cpf = '10000000052', phone = '11900000052', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'cfb272d2-86c7-4c6b-9fea-17355db0daca';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'cfb272d2-86c7-4c6b-9fea-17355db0daca';

-- Teste Usuario 81 (teste.1770407502840.9087.81@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('fae14bef-49c7-4340-b83a-d5f5c6d32dbf', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502840.9087.81@loadtest.com', '', '2026-02-06T22:52:21.000Z', '2026-02-06T22:52:21.000Z', '2026-02-06T22:52:21.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 81"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('1a415901-202f-45df-be77-6ade6329baaa', 'fae14bef-49c7-4340-b83a-d5f5c6d32dbf', '{"sub":"fae14bef-49c7-4340-b83a-d5f5c6d32dbf","email":"teste.1770407502840.9087.81@loadtest.com","email_verified":true}', 'email', 'fae14bef-49c7-4340-b83a-d5f5c6d32dbf', '2026-02-06T22:52:21.000Z', '2026-02-06T22:52:21.000Z', '2026-02-06T22:52:22.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 81', cpf = '10000000081', phone = '11900000081', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'fae14bef-49c7-4340-b83a-d5f5c6d32dbf';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'fae14bef-49c7-4340-b83a-d5f5c6d32dbf';

-- Teste Usuario 86 (teste.1770407502845.1246.86@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('94282ec8-e608-460b-89f7-ec411332cfc0', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502845.1246.86@loadtest.com', '', '2026-02-06T22:52:22.000Z', '2026-02-06T22:52:22.000Z', '2026-02-06T22:52:22.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 86"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('f89772f7-e123-4c15-9ee3-282ef3881a70', '94282ec8-e608-460b-89f7-ec411332cfc0', '{"sub":"94282ec8-e608-460b-89f7-ec411332cfc0","email":"teste.1770407502845.1246.86@loadtest.com","email_verified":true}', 'email', '94282ec8-e608-460b-89f7-ec411332cfc0', '2026-02-06T22:52:22.000Z', '2026-02-06T22:52:22.000Z', '2026-02-06T22:52:22.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 86', cpf = '10000000086', phone = '11900000086', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '94282ec8-e608-460b-89f7-ec411332cfc0';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '94282ec8-e608-460b-89f7-ec411332cfc0';

-- Teste Usuario 74 (teste.1770407502835.7276.74@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('dd618093-cd66-4093-826f-77dd8760439e', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502835.7276.74@loadtest.com', '', '2026-02-06T22:52:22.000Z', '2026-02-06T22:52:22.000Z', '2026-02-06T22:52:22.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 74"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('17ffd572-c6ea-4243-9b0e-873bf16c73e0', 'dd618093-cd66-4093-826f-77dd8760439e', '{"sub":"dd618093-cd66-4093-826f-77dd8760439e","email":"teste.1770407502835.7276.74@loadtest.com","email_verified":true}', 'email', 'dd618093-cd66-4093-826f-77dd8760439e', '2026-02-06T22:52:22.000Z', '2026-02-06T22:52:22.000Z', '2026-02-06T22:52:23.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 74', cpf = '10000000074', phone = '11900000074', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'dd618093-cd66-4093-826f-77dd8760439e';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'dd618093-cd66-4093-826f-77dd8760439e';

-- Teste Usuario 95 (teste.1770407502851.9235.95@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('8cac2141-4a6b-4875-8891-d15356fd9f7d', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502851.9235.95@loadtest.com', '', '2026-02-06T22:52:23.000Z', '2026-02-06T22:52:23.000Z', '2026-02-06T22:52:23.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 95"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('2237682f-888d-45c9-8678-4cb4fcbc9639', '8cac2141-4a6b-4875-8891-d15356fd9f7d', '{"sub":"8cac2141-4a6b-4875-8891-d15356fd9f7d","email":"teste.1770407502851.9235.95@loadtest.com","email_verified":true}', 'email', '8cac2141-4a6b-4875-8891-d15356fd9f7d', '2026-02-06T22:52:23.000Z', '2026-02-06T22:52:23.000Z', '2026-02-06T22:52:23.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 95', cpf = '10000000095', phone = '11900000095', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '8cac2141-4a6b-4875-8891-d15356fd9f7d';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '8cac2141-4a6b-4875-8891-d15356fd9f7d';

-- Teste Usuario 94 (teste.1770407502850.4530.94@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('ebbad6b2-f786-4fa7-8eb1-709e23fa06e5', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502850.4530.94@loadtest.com', '', '2026-02-06T22:52:23.000Z', '2026-02-06T22:52:23.000Z', '2026-02-06T22:52:23.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 94"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('2aaaaa1d-c15f-4980-993f-8ff6cff0448b', 'ebbad6b2-f786-4fa7-8eb1-709e23fa06e5', '{"sub":"ebbad6b2-f786-4fa7-8eb1-709e23fa06e5","email":"teste.1770407502850.4530.94@loadtest.com","email_verified":true}', 'email', 'ebbad6b2-f786-4fa7-8eb1-709e23fa06e5', '2026-02-06T22:52:23.000Z', '2026-02-06T22:52:23.000Z', '2026-02-06T22:52:23.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 94', cpf = '10000000094', phone = '11900000094', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'ebbad6b2-f786-4fa7-8eb1-709e23fa06e5';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'ebbad6b2-f786-4fa7-8eb1-709e23fa06e5';

-- Teste Usuario 84 (teste.1770407502843.6905.84@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('dbe59884-3ff5-4235-80ad-c7fa19a890ee', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502843.6905.84@loadtest.com', '', '2026-02-06T22:52:23.000Z', '2026-02-06T22:52:23.000Z', '2026-02-06T22:52:23.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 84"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('dabdb59e-b494-4336-83d0-7e3d4403703a', 'dbe59884-3ff5-4235-80ad-c7fa19a890ee', '{"sub":"dbe59884-3ff5-4235-80ad-c7fa19a890ee","email":"teste.1770407502843.6905.84@loadtest.com","email_verified":true}', 'email', 'dbe59884-3ff5-4235-80ad-c7fa19a890ee', '2026-02-06T22:52:23.000Z', '2026-02-06T22:52:23.000Z', '2026-02-06T22:52:24.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 84', cpf = '10000000084', phone = '11900000084', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'dbe59884-3ff5-4235-80ad-c7fa19a890ee';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'dbe59884-3ff5-4235-80ad-c7fa19a890ee';

-- Teste Usuario 35 (teste.1770407502805.4344.35@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('08b6ce0b-5810-4fda-9459-10b15138f16d', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502805.4344.35@loadtest.com', '', '2026-02-06T22:52:24.000Z', '2026-02-06T22:52:24.000Z', '2026-02-06T22:52:24.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 35"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('fe6e160d-dd08-4eaa-81db-f1067aa15f81', '08b6ce0b-5810-4fda-9459-10b15138f16d', '{"sub":"08b6ce0b-5810-4fda-9459-10b15138f16d","email":"teste.1770407502805.4344.35@loadtest.com","email_verified":true}', 'email', '08b6ce0b-5810-4fda-9459-10b15138f16d', '2026-02-06T22:52:24.000Z', '2026-02-06T22:52:24.000Z', '2026-02-06T22:52:24.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 35', cpf = '10000000035', phone = '11900000035', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '08b6ce0b-5810-4fda-9459-10b15138f16d';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '08b6ce0b-5810-4fda-9459-10b15138f16d';

-- Teste Usuario 87 (teste.1770407502845.4977.87@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('054770c5-f502-4165-86b0-a83e76a5fae2', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502845.4977.87@loadtest.com', '', '2026-02-06T22:52:24.000Z', '2026-02-06T22:52:24.000Z', '2026-02-06T22:52:24.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 87"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('9b4666d7-13cb-44bc-b353-f490ea39c192', '054770c5-f502-4165-86b0-a83e76a5fae2', '{"sub":"054770c5-f502-4165-86b0-a83e76a5fae2","email":"teste.1770407502845.4977.87@loadtest.com","email_verified":true}', 'email', '054770c5-f502-4165-86b0-a83e76a5fae2', '2026-02-06T22:52:24.000Z', '2026-02-06T22:52:24.000Z', '2026-02-06T22:52:25.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 87', cpf = '10000000087', phone = '11900000087', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '054770c5-f502-4165-86b0-a83e76a5fae2';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '054770c5-f502-4165-86b0-a83e76a5fae2';

-- Teste Usuario 89 (teste.1770407502847.5521.89@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('623ea031-8088-405f-94cf-8910bf8a80d9', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502847.5521.89@loadtest.com', '', '2026-02-06T22:52:25.000Z', '2026-02-06T22:52:25.000Z', '2026-02-06T22:52:25.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 89"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('6721d184-1abd-4771-98cb-18b184760b9e', '623ea031-8088-405f-94cf-8910bf8a80d9', '{"sub":"623ea031-8088-405f-94cf-8910bf8a80d9","email":"teste.1770407502847.5521.89@loadtest.com","email_verified":true}', 'email', '623ea031-8088-405f-94cf-8910bf8a80d9', '2026-02-06T22:52:25.000Z', '2026-02-06T22:52:25.000Z', '2026-02-06T22:52:25.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 89', cpf = '10000000089', phone = '11900000089', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '623ea031-8088-405f-94cf-8910bf8a80d9';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '623ea031-8088-405f-94cf-8910bf8a80d9';

-- Teste Usuario 63 (teste.1770407502827.3784.63@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('f6bccc37-6724-462b-acb4-7405be2bcfc6', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502827.3784.63@loadtest.com', '', '2026-02-06T22:52:25.000Z', '2026-02-06T22:52:25.000Z', '2026-02-06T22:52:25.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 63"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('24808d8a-6ec5-419d-8f40-5af5f5517c1d', 'f6bccc37-6724-462b-acb4-7405be2bcfc6', '{"sub":"f6bccc37-6724-462b-acb4-7405be2bcfc6","email":"teste.1770407502827.3784.63@loadtest.com","email_verified":true}', 'email', 'f6bccc37-6724-462b-acb4-7405be2bcfc6', '2026-02-06T22:52:25.000Z', '2026-02-06T22:52:25.000Z', '2026-02-06T22:52:26.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 63', cpf = '10000000063', phone = '11900000063', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'f6bccc37-6724-462b-acb4-7405be2bcfc6';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'f6bccc37-6724-462b-acb4-7405be2bcfc6';

-- Teste Usuario 98 (teste.1770407502853.9817.98@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('4f73f91a-2915-4976-8b85-fa0eafa75179', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502853.9817.98@loadtest.com', '', '2026-02-06T22:52:26.000Z', '2026-02-06T22:52:26.000Z', '2026-02-06T22:52:26.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 98"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('9d626799-fcba-42aa-b90f-920230afef98', '4f73f91a-2915-4976-8b85-fa0eafa75179', '{"sub":"4f73f91a-2915-4976-8b85-fa0eafa75179","email":"teste.1770407502853.9817.98@loadtest.com","email_verified":true}', 'email', '4f73f91a-2915-4976-8b85-fa0eafa75179', '2026-02-06T22:52:26.000Z', '2026-02-06T22:52:26.000Z', '2026-02-06T22:52:26.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 98', cpf = '10000000098', phone = '11900000098', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '4f73f91a-2915-4976-8b85-fa0eafa75179';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '4f73f91a-2915-4976-8b85-fa0eafa75179';

-- Teste Usuario 97 (teste.1770407502852.2289.97@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('766411b3-b9dd-426a-97ca-323c0b29c849', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502852.2289.97@loadtest.com', '', '2026-02-06T22:52:26.000Z', '2026-02-06T22:52:26.000Z', '2026-02-06T22:52:26.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 97"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('d3d90ddc-4893-4f1e-be83-8bc8a2c81d75', '766411b3-b9dd-426a-97ca-323c0b29c849', '{"sub":"766411b3-b9dd-426a-97ca-323c0b29c849","email":"teste.1770407502852.2289.97@loadtest.com","email_verified":true}', 'email', '766411b3-b9dd-426a-97ca-323c0b29c849', '2026-02-06T22:52:26.000Z', '2026-02-06T22:52:26.000Z', '2026-02-06T22:52:26.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 97', cpf = '10000000097', phone = '11900000097', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '766411b3-b9dd-426a-97ca-323c0b29c849';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '766411b3-b9dd-426a-97ca-323c0b29c849';

-- Teste Usuario 88 (teste.1770407502846.2061.88@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('79685b90-27c4-4668-b304-d659e1aed16c', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502846.2061.88@loadtest.com', '', '2026-02-06T22:52:26.000Z', '2026-02-06T22:52:26.000Z', '2026-02-06T22:52:26.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 88"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('cbeecd61-74d5-40d6-a0aa-17b4ea584aa2', '79685b90-27c4-4668-b304-d659e1aed16c', '{"sub":"79685b90-27c4-4668-b304-d659e1aed16c","email":"teste.1770407502846.2061.88@loadtest.com","email_verified":true}', 'email', '79685b90-27c4-4668-b304-d659e1aed16c', '2026-02-06T22:52:26.000Z', '2026-02-06T22:52:26.000Z', '2026-02-06T22:52:27.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 88', cpf = '10000000088', phone = '11900000088', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '79685b90-27c4-4668-b304-d659e1aed16c';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '79685b90-27c4-4668-b304-d659e1aed16c';

-- Teste Usuario 99 (teste.1770407502854.7936.99@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('8e4171a6-b12b-4760-95e0-7e08440f0565', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502854.7936.99@loadtest.com', '', '2026-02-06T22:52:27.000Z', '2026-02-06T22:52:27.000Z', '2026-02-06T22:52:27.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 99"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('8cc0f911-ed05-47b9-966e-052be7700080', '8e4171a6-b12b-4760-95e0-7e08440f0565', '{"sub":"8e4171a6-b12b-4760-95e0-7e08440f0565","email":"teste.1770407502854.7936.99@loadtest.com","email_verified":true}', 'email', '8e4171a6-b12b-4760-95e0-7e08440f0565', '2026-02-06T22:52:27.000Z', '2026-02-06T22:52:27.000Z', '2026-02-06T22:52:27.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 99', cpf = '10000000099', phone = '11900000099', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '8e4171a6-b12b-4760-95e0-7e08440f0565';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '8e4171a6-b12b-4760-95e0-7e08440f0565';

-- Teste Usuario 60 (teste.1770407502825.8057.60@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('dc3d793e-88e1-4963-9d4c-7d8e4ef1e73c', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502825.8057.60@loadtest.com', '', '2026-02-06T22:52:27.000Z', '2026-02-06T22:52:27.000Z', '2026-02-06T22:52:27.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 60"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('3bb2fa45-2912-409e-a5f1-e5456d306df2', 'dc3d793e-88e1-4963-9d4c-7d8e4ef1e73c', '{"sub":"dc3d793e-88e1-4963-9d4c-7d8e4ef1e73c","email":"teste.1770407502825.8057.60@loadtest.com","email_verified":true}', 'email', 'dc3d793e-88e1-4963-9d4c-7d8e4ef1e73c', '2026-02-06T22:52:27.000Z', '2026-02-06T22:52:27.000Z', '2026-02-06T22:52:28.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 60', cpf = '10000000060', phone = '11900000060', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'dc3d793e-88e1-4963-9d4c-7d8e4ef1e73c';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'dc3d793e-88e1-4963-9d4c-7d8e4ef1e73c';

-- Teste Usuario 80 (teste.1770407502839.4597.80@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('379d6231-81ff-407d-9d21-4429418215db', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502839.4597.80@loadtest.com', '', '2026-02-06T22:52:28.000Z', '2026-02-06T22:52:28.000Z', '2026-02-06T22:52:28.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 80"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('8c16ec0e-b2a8-4cbf-8e65-0688af28b3b4', '379d6231-81ff-407d-9d21-4429418215db', '{"sub":"379d6231-81ff-407d-9d21-4429418215db","email":"teste.1770407502839.4597.80@loadtest.com","email_verified":true}', 'email', '379d6231-81ff-407d-9d21-4429418215db', '2026-02-06T22:52:28.000Z', '2026-02-06T22:52:28.000Z', '2026-02-06T22:52:28.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 80', cpf = '10000000080', phone = '11900000080', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '379d6231-81ff-407d-9d21-4429418215db';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '379d6231-81ff-407d-9d21-4429418215db';

-- Teste Usuario 92 (teste.1770407502849.994.92@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('a67672bf-f05d-4a10-ade8-7247ab06808d', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502849.994.92@loadtest.com', '', '2026-02-06T22:52:28.000Z', '2026-02-06T22:52:28.000Z', '2026-02-06T22:52:28.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 92"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('e734966a-a7f0-4735-a3d0-03178e3be6da', 'a67672bf-f05d-4a10-ade8-7247ab06808d', '{"sub":"a67672bf-f05d-4a10-ade8-7247ab06808d","email":"teste.1770407502849.994.92@loadtest.com","email_verified":true}', 'email', 'a67672bf-f05d-4a10-ade8-7247ab06808d', '2026-02-06T22:52:28.000Z', '2026-02-06T22:52:28.000Z', '2026-02-06T22:52:29.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 92', cpf = '10000000092', phone = '11900000092', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'a67672bf-f05d-4a10-ade8-7247ab06808d';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'a67672bf-f05d-4a10-ade8-7247ab06808d';

-- Teste Usuario 90 (teste.1770407502847.5668.90@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('e0dbd1cd-16a7-47b9-a897-c7801aee94f2', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407502847.5668.90@loadtest.com', '', '2026-02-06T22:52:29.000Z', '2026-02-06T22:52:29.000Z', '2026-02-06T22:52:29.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 90"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('6bc0e23a-c469-45af-acd4-21a33b4e2185', 'e0dbd1cd-16a7-47b9-a897-c7801aee94f2', '{"sub":"e0dbd1cd-16a7-47b9-a897-c7801aee94f2","email":"teste.1770407502847.5668.90@loadtest.com","email_verified":true}', 'email', 'e0dbd1cd-16a7-47b9-a897-c7801aee94f2', '2026-02-06T22:52:29.000Z', '2026-02-06T22:52:29.000Z', '2026-02-06T22:52:29.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 90', cpf = '10000000090', phone = '11900000090', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'e0dbd1cd-16a7-47b9-a897-c7801aee94f2';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'e0dbd1cd-16a7-47b9-a897-c7801aee94f2';

-- Teste Usuario 3 (teste.1770407690211.1531.3@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('3442ca7c-8250-42cc-93d2-3d357a93bd45', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690211.1531.3@loadtest.com', '', '2026-02-06T22:54:53.000Z', '2026-02-06T22:54:53.000Z', '2026-02-06T22:54:53.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 3"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('59c15829-2b1f-4161-ab0d-6802df9732ad', '3442ca7c-8250-42cc-93d2-3d357a93bd45', '{"sub":"3442ca7c-8250-42cc-93d2-3d357a93bd45","email":"teste.1770407690211.1531.3@loadtest.com","email_verified":true}', 'email', '3442ca7c-8250-42cc-93d2-3d357a93bd45', '2026-02-06T22:54:53.000Z', '2026-02-06T22:54:53.000Z', '2026-02-06T22:54:53.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 3', cpf = '10000000003', phone = '11900000003', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '3442ca7c-8250-42cc-93d2-3d357a93bd45';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '3442ca7c-8250-42cc-93d2-3d357a93bd45';

-- Teste Usuario 4 (teste.1770407690212.586.4@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('b7308550-a5c2-4a52-b98b-226d528c7804', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690212.586.4@loadtest.com', '', '2026-02-06T22:54:53.000Z', '2026-02-06T22:54:53.000Z', '2026-02-06T22:54:53.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 4"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('b91deabb-efc9-484c-8c50-e105002d1ad2', 'b7308550-a5c2-4a52-b98b-226d528c7804', '{"sub":"b7308550-a5c2-4a52-b98b-226d528c7804","email":"teste.1770407690212.586.4@loadtest.com","email_verified":true}', 'email', 'b7308550-a5c2-4a52-b98b-226d528c7804', '2026-02-06T22:54:53.000Z', '2026-02-06T22:54:53.000Z', '2026-02-06T22:54:54.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 4', cpf = '10000000004', phone = '11900000004', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'b7308550-a5c2-4a52-b98b-226d528c7804';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'b7308550-a5c2-4a52-b98b-226d528c7804';

-- Teste Usuario 37 (teste.1770407690243.8803.37@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('0b85187d-2cb0-48c5-82f6-a6f4702c5162', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690243.8803.37@loadtest.com', '', '2026-02-06T22:54:54.000Z', '2026-02-06T22:54:54.000Z', '2026-02-06T22:54:54.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 37"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('955a68d5-ada8-4d41-946f-4fdec2cd2656', '0b85187d-2cb0-48c5-82f6-a6f4702c5162', '{"sub":"0b85187d-2cb0-48c5-82f6-a6f4702c5162","email":"teste.1770407690243.8803.37@loadtest.com","email_verified":true}', 'email', '0b85187d-2cb0-48c5-82f6-a6f4702c5162', '2026-02-06T22:54:54.000Z', '2026-02-06T22:54:54.000Z', '2026-02-06T22:54:54.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 37', cpf = '10000000037', phone = '11900000037', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '0b85187d-2cb0-48c5-82f6-a6f4702c5162';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '0b85187d-2cb0-48c5-82f6-a6f4702c5162';

-- Teste Usuario 2 (teste.1770407690209.3334.2@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('cef7f589-1009-4b0e-92a9-85a70ac81f95', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690209.3334.2@loadtest.com', '', '2026-02-06T22:54:54.000Z', '2026-02-06T22:54:54.000Z', '2026-02-06T22:54:54.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 2"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('b6065406-c2ff-4752-b14d-a2ebe5acb523', 'cef7f589-1009-4b0e-92a9-85a70ac81f95', '{"sub":"cef7f589-1009-4b0e-92a9-85a70ac81f95","email":"teste.1770407690209.3334.2@loadtest.com","email_verified":true}', 'email', 'cef7f589-1009-4b0e-92a9-85a70ac81f95', '2026-02-06T22:54:54.000Z', '2026-02-06T22:54:54.000Z', '2026-02-06T22:54:54.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 2', cpf = '10000000002', phone = '11900000002', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'cef7f589-1009-4b0e-92a9-85a70ac81f95';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'cef7f589-1009-4b0e-92a9-85a70ac81f95';

-- Teste Usuario 26 (teste.1770407690235.1067.26@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('75e72112-2938-4974-b9c1-5ee30130c077', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690235.1067.26@loadtest.com', '', '2026-02-06T22:54:55.000Z', '2026-02-06T22:54:55.000Z', '2026-02-06T22:54:55.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 26"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('92e775f5-fea7-4050-9a0f-f1e4d5457555', '75e72112-2938-4974-b9c1-5ee30130c077', '{"sub":"75e72112-2938-4974-b9c1-5ee30130c077","email":"teste.1770407690235.1067.26@loadtest.com","email_verified":true}', 'email', '75e72112-2938-4974-b9c1-5ee30130c077', '2026-02-06T22:54:55.000Z', '2026-02-06T22:54:55.000Z', '2026-02-06T22:54:55.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 26', cpf = '10000000026', phone = '11900000026', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '75e72112-2938-4974-b9c1-5ee30130c077';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '75e72112-2938-4974-b9c1-5ee30130c077';

-- Teste Usuario 15 (teste.1770407690227.6234.15@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('e27453ad-d50c-4e1b-8b5f-e35156b45736', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690227.6234.15@loadtest.com', '', '2026-02-06T22:54:55.000Z', '2026-02-06T22:54:55.000Z', '2026-02-06T22:54:55.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 15"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('67f2819c-68d9-4826-bd0e-1ac97b016bed', 'e27453ad-d50c-4e1b-8b5f-e35156b45736', '{"sub":"e27453ad-d50c-4e1b-8b5f-e35156b45736","email":"teste.1770407690227.6234.15@loadtest.com","email_verified":true}', 'email', 'e27453ad-d50c-4e1b-8b5f-e35156b45736', '2026-02-06T22:54:55.000Z', '2026-02-06T22:54:55.000Z', '2026-02-06T22:54:55.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 15', cpf = '10000000015', phone = '11900000015', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'e27453ad-d50c-4e1b-8b5f-e35156b45736';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'e27453ad-d50c-4e1b-8b5f-e35156b45736';

-- Teste Usuario 35 (teste.1770407690241.4133.35@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('ea87b5a3-d292-4a4e-bae5-0c16b470206e', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690241.4133.35@loadtest.com', '', '2026-02-06T22:54:55.000Z', '2026-02-06T22:54:55.000Z', '2026-02-06T22:54:55.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 35"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('61687192-c2d6-4b11-8add-f7fd5c760e6a', 'ea87b5a3-d292-4a4e-bae5-0c16b470206e', '{"sub":"ea87b5a3-d292-4a4e-bae5-0c16b470206e","email":"teste.1770407690241.4133.35@loadtest.com","email_verified":true}', 'email', 'ea87b5a3-d292-4a4e-bae5-0c16b470206e', '2026-02-06T22:54:55.000Z', '2026-02-06T22:54:55.000Z', '2026-02-06T22:54:56.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 35', cpf = '10000000035', phone = '11900000035', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'ea87b5a3-d292-4a4e-bae5-0c16b470206e';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'ea87b5a3-d292-4a4e-bae5-0c16b470206e';

-- Teste Usuario 79 (teste.1770407690276.7795.79@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('f1a875e0-406e-40a5-bbb1-b998c129a69b', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690276.7795.79@loadtest.com', '', '2026-02-06T22:54:56.000Z', '2026-02-06T22:54:56.000Z', '2026-02-06T22:54:56.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 79"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('b036a543-f82b-4c2d-825b-925e727c29bf', 'f1a875e0-406e-40a5-bbb1-b998c129a69b', '{"sub":"f1a875e0-406e-40a5-bbb1-b998c129a69b","email":"teste.1770407690276.7795.79@loadtest.com","email_verified":true}', 'email', 'f1a875e0-406e-40a5-bbb1-b998c129a69b', '2026-02-06T22:54:56.000Z', '2026-02-06T22:54:56.000Z', '2026-02-06T22:54:56.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 79', cpf = '10000000079', phone = '11900000079', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'f1a875e0-406e-40a5-bbb1-b998c129a69b';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'f1a875e0-406e-40a5-bbb1-b998c129a69b';

-- Teste Usuario 6 (teste.1770407690215.2245.6@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('40f1dc52-9a91-48ed-b4f5-5016ee2d54b9', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690215.2245.6@loadtest.com', '', '2026-02-06T22:54:56.000Z', '2026-02-06T22:54:56.000Z', '2026-02-06T22:54:56.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 6"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('e7e8981e-1356-423b-8502-efdb3dfc99f4', '40f1dc52-9a91-48ed-b4f5-5016ee2d54b9', '{"sub":"40f1dc52-9a91-48ed-b4f5-5016ee2d54b9","email":"teste.1770407690215.2245.6@loadtest.com","email_verified":true}', 'email', '40f1dc52-9a91-48ed-b4f5-5016ee2d54b9', '2026-02-06T22:54:56.000Z', '2026-02-06T22:54:56.000Z', '2026-02-06T22:54:57.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 6', cpf = '10000000006', phone = '11900000006', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '40f1dc52-9a91-48ed-b4f5-5016ee2d54b9';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '40f1dc52-9a91-48ed-b4f5-5016ee2d54b9';
