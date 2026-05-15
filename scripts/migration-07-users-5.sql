-- ============================================
-- Talent-IA Migration - Part 7/8: Users 401-493 (batch 5/5)
-- Generated: 2026-02-13T20:29:31.271Z
-- EXECUTE IN ORDER: Part 7 of 8
-- ============================================

-- Teste Usuario 38 (teste.1770407690244.3322.38@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('ffe828e7-3477-4e96-8775-8649eaee26b4', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690244.3322.38@loadtest.com', '', '2026-02-06T22:54:57.000Z', '2026-02-06T22:54:57.000Z', '2026-02-06T22:54:57.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 38"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('8bffc693-05f8-4bf5-8b8a-69d622952742', 'ffe828e7-3477-4e96-8775-8649eaee26b4', '{"sub":"ffe828e7-3477-4e96-8775-8649eaee26b4","email":"teste.1770407690244.3322.38@loadtest.com","email_verified":true}', 'email', 'ffe828e7-3477-4e96-8775-8649eaee26b4', '2026-02-06T22:54:57.000Z', '2026-02-06T22:54:57.000Z', '2026-02-06T22:54:57.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 38', cpf = '10000000038', phone = '11900000038', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'ffe828e7-3477-4e96-8775-8649eaee26b4';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'ffe828e7-3477-4e96-8775-8649eaee26b4';

-- Teste Usuario 7 (teste.1770407690216.9743.7@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('129bfae4-9452-4fad-b5ea-624b3a755641', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690216.9743.7@loadtest.com', '', '2026-02-06T22:54:57.000Z', '2026-02-06T22:54:57.000Z', '2026-02-06T22:54:57.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 7"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('5e677cfa-2926-401d-911b-0dab82b7f27a', '129bfae4-9452-4fad-b5ea-624b3a755641', '{"sub":"129bfae4-9452-4fad-b5ea-624b3a755641","email":"teste.1770407690216.9743.7@loadtest.com","email_verified":true}', 'email', '129bfae4-9452-4fad-b5ea-624b3a755641', '2026-02-06T22:54:57.000Z', '2026-02-06T22:54:57.000Z', '2026-02-06T22:54:58.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 7', cpf = '10000000007', phone = '11900000007', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '129bfae4-9452-4fad-b5ea-624b3a755641';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '129bfae4-9452-4fad-b5ea-624b3a755641';

-- Teste Usuario 16 (teste.1770407690227.9576.16@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('46549c29-fda6-4e7e-848a-caedf0a6b634', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690227.9576.16@loadtest.com', '', '2026-02-06T22:54:58.000Z', '2026-02-06T22:54:58.000Z', '2026-02-06T22:54:58.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 16"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('8b31473a-6da6-43f6-93c2-285c176f0a1c', '46549c29-fda6-4e7e-848a-caedf0a6b634', '{"sub":"46549c29-fda6-4e7e-848a-caedf0a6b634","email":"teste.1770407690227.9576.16@loadtest.com","email_verified":true}', 'email', '46549c29-fda6-4e7e-848a-caedf0a6b634', '2026-02-06T22:54:58.000Z', '2026-02-06T22:54:58.000Z', '2026-02-06T22:54:58.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 16', cpf = '10000000016', phone = '11900000016', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '46549c29-fda6-4e7e-848a-caedf0a6b634';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '46549c29-fda6-4e7e-848a-caedf0a6b634';

-- Teste Usuario 9 (teste.1770407690219.4381.9@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('fda9a93b-41ea-4aa1-ada5-c807f2a58877', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690219.4381.9@loadtest.com', '', '2026-02-06T22:54:58.000Z', '2026-02-06T22:54:58.000Z', '2026-02-06T22:54:58.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 9"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('d302e8fd-f98b-43eb-8237-214fe2b045c4', 'fda9a93b-41ea-4aa1-ada5-c807f2a58877', '{"sub":"fda9a93b-41ea-4aa1-ada5-c807f2a58877","email":"teste.1770407690219.4381.9@loadtest.com","email_verified":true}', 'email', 'fda9a93b-41ea-4aa1-ada5-c807f2a58877', '2026-02-06T22:54:58.000Z', '2026-02-06T22:54:58.000Z', '2026-02-06T22:54:58.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 9', cpf = '10000000009', phone = '11900000009', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'fda9a93b-41ea-4aa1-ada5-c807f2a58877';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'fda9a93b-41ea-4aa1-ada5-c807f2a58877';

-- Teste Usuario 17 (teste.1770407690228.9114.17@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('d074f49b-e4be-4e32-a197-2f9ea3e30398', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690228.9114.17@loadtest.com', '', '2026-02-06T22:54:58.000Z', '2026-02-06T22:54:58.000Z', '2026-02-06T22:54:58.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 17"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('3829a400-9259-43d3-953c-fb5eb7b15cf2', 'd074f49b-e4be-4e32-a197-2f9ea3e30398', '{"sub":"d074f49b-e4be-4e32-a197-2f9ea3e30398","email":"teste.1770407690228.9114.17@loadtest.com","email_verified":true}', 'email', 'd074f49b-e4be-4e32-a197-2f9ea3e30398', '2026-02-06T22:54:58.000Z', '2026-02-06T22:54:58.000Z', '2026-02-06T22:54:59.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 17', cpf = '10000000017', phone = '11900000017', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'd074f49b-e4be-4e32-a197-2f9ea3e30398';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'd074f49b-e4be-4e32-a197-2f9ea3e30398';

-- Teste Usuario 5 (teste.1770407690214.3263.5@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('c070b5bb-afae-4ae1-aad9-9e8e6a984129', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690214.3263.5@loadtest.com', '', '2026-02-06T22:54:59.000Z', '2026-02-06T22:54:59.000Z', '2026-02-06T22:54:59.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 5"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('ee3be27c-bbaa-404a-88c8-e635d27426f9', 'c070b5bb-afae-4ae1-aad9-9e8e6a984129', '{"sub":"c070b5bb-afae-4ae1-aad9-9e8e6a984129","email":"teste.1770407690214.3263.5@loadtest.com","email_verified":true}', 'email', 'c070b5bb-afae-4ae1-aad9-9e8e6a984129', '2026-02-06T22:54:59.000Z', '2026-02-06T22:54:59.000Z', '2026-02-06T22:54:59.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 5', cpf = '10000000005', phone = '11900000005', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'c070b5bb-afae-4ae1-aad9-9e8e6a984129';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'c070b5bb-afae-4ae1-aad9-9e8e6a984129';

-- Teste Usuario 8 (teste.1770407690217.3651.8@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('301f0a7b-20a2-4048-b3ef-b0680d7edd57', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690217.3651.8@loadtest.com', '', '2026-02-06T22:54:59.000Z', '2026-02-06T22:54:59.000Z', '2026-02-06T22:54:59.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 8"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('dee97bbc-bb0e-478b-835a-36930d413515', '301f0a7b-20a2-4048-b3ef-b0680d7edd57', '{"sub":"301f0a7b-20a2-4048-b3ef-b0680d7edd57","email":"teste.1770407690217.3651.8@loadtest.com","email_verified":true}', 'email', '301f0a7b-20a2-4048-b3ef-b0680d7edd57', '2026-02-06T22:54:59.000Z', '2026-02-06T22:54:59.000Z', '2026-02-06T22:55:00.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 8', cpf = '10000000008', phone = '11900000008', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '301f0a7b-20a2-4048-b3ef-b0680d7edd57';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '301f0a7b-20a2-4048-b3ef-b0680d7edd57';

-- Teste Usuario 11 (teste.1770407690223.2026.11@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('2dad1720-00f2-4aee-af92-85f592d91f8c', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690223.2026.11@loadtest.com', '', '2026-02-06T22:55:00.000Z', '2026-02-06T22:55:00.000Z', '2026-02-06T22:55:00.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 11"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('3286e6d6-6b37-4c9f-a7ca-45654a8151a7', '2dad1720-00f2-4aee-af92-85f592d91f8c', '{"sub":"2dad1720-00f2-4aee-af92-85f592d91f8c","email":"teste.1770407690223.2026.11@loadtest.com","email_verified":true}', 'email', '2dad1720-00f2-4aee-af92-85f592d91f8c', '2026-02-06T22:55:00.000Z', '2026-02-06T22:55:00.000Z', '2026-02-06T22:55:00.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 11', cpf = '10000000011', phone = '11900000011', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '2dad1720-00f2-4aee-af92-85f592d91f8c';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '2dad1720-00f2-4aee-af92-85f592d91f8c';

-- Teste Usuario 23 (teste.1770407690232.3655.23@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('fb6109f0-0e46-4f8c-a917-fffe03ef1fa2', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690232.3655.23@loadtest.com', '', '2026-02-06T22:55:00.000Z', '2026-02-06T22:55:00.000Z', '2026-02-06T22:55:00.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 23"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('27b3d94d-47d1-4da8-82b1-198e4e6060dc', 'fb6109f0-0e46-4f8c-a917-fffe03ef1fa2', '{"sub":"fb6109f0-0e46-4f8c-a917-fffe03ef1fa2","email":"teste.1770407690232.3655.23@loadtest.com","email_verified":true}', 'email', 'fb6109f0-0e46-4f8c-a917-fffe03ef1fa2', '2026-02-06T22:55:00.000Z', '2026-02-06T22:55:00.000Z', '2026-02-06T22:55:01.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 23', cpf = '10000000023', phone = '11900000023', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'fb6109f0-0e46-4f8c-a917-fffe03ef1fa2';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'fb6109f0-0e46-4f8c-a917-fffe03ef1fa2';

-- Teste Usuario 13 (teste.1770407690225.8671.13@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('63f88c66-23d5-4f0b-a044-37fe3b22c9d6', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690225.8671.13@loadtest.com', '', '2026-02-06T22:55:01.000Z', '2026-02-06T22:55:01.000Z', '2026-02-06T22:55:01.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 13"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('1000cbbc-ae33-4645-9b40-16ba4d8e35d2', '63f88c66-23d5-4f0b-a044-37fe3b22c9d6', '{"sub":"63f88c66-23d5-4f0b-a044-37fe3b22c9d6","email":"teste.1770407690225.8671.13@loadtest.com","email_verified":true}', 'email', '63f88c66-23d5-4f0b-a044-37fe3b22c9d6', '2026-02-06T22:55:01.000Z', '2026-02-06T22:55:01.000Z', '2026-02-06T22:55:01.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 13', cpf = '10000000013', phone = '11900000013', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '63f88c66-23d5-4f0b-a044-37fe3b22c9d6';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '63f88c66-23d5-4f0b-a044-37fe3b22c9d6';

-- Teste Usuario 14 (teste.1770407690226.6602.14@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('eb9796cc-ae56-4d27-bb37-033d8540b85b', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690226.6602.14@loadtest.com', '', '2026-02-06T22:55:01.000Z', '2026-02-06T22:55:01.000Z', '2026-02-06T22:55:01.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 14"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('5ae1c38a-6675-4ebe-8f4e-387fb1ffc12b', 'eb9796cc-ae56-4d27-bb37-033d8540b85b', '{"sub":"eb9796cc-ae56-4d27-bb37-033d8540b85b","email":"teste.1770407690226.6602.14@loadtest.com","email_verified":true}', 'email', 'eb9796cc-ae56-4d27-bb37-033d8540b85b', '2026-02-06T22:55:01.000Z', '2026-02-06T22:55:01.000Z', '2026-02-06T22:55:02.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 14', cpf = '10000000014', phone = '11900000014', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'eb9796cc-ae56-4d27-bb37-033d8540b85b';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'eb9796cc-ae56-4d27-bb37-033d8540b85b';

-- Teste Usuario 1 (teste.1770407690133.9371.1@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('73ce4440-353d-4826-a147-1a02588b6428', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690133.9371.1@loadtest.com', '', '2026-02-06T22:55:02.000Z', '2026-02-06T22:55:02.000Z', '2026-02-06T22:55:02.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 1"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('e5faa75b-1a1b-455c-8d25-57c191b73910', '73ce4440-353d-4826-a147-1a02588b6428', '{"sub":"73ce4440-353d-4826-a147-1a02588b6428","email":"teste.1770407690133.9371.1@loadtest.com","email_verified":true}', 'email', '73ce4440-353d-4826-a147-1a02588b6428', '2026-02-06T22:55:02.000Z', '2026-02-06T22:55:02.000Z', '2026-02-06T22:55:02.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 1', cpf = '10000000001', phone = '11900000001', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '73ce4440-353d-4826-a147-1a02588b6428';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '73ce4440-353d-4826-a147-1a02588b6428';

-- Teste Usuario 12 (teste.1770407690224.7187.12@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('f07b2308-1d3f-4179-97fa-16d63b62547a', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690224.7187.12@loadtest.com', '', '2026-02-06T22:55:02.000Z', '2026-02-06T22:55:02.000Z', '2026-02-06T22:55:02.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 12"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('450485ff-2161-43f7-aa26-b1b11378031a', 'f07b2308-1d3f-4179-97fa-16d63b62547a', '{"sub":"f07b2308-1d3f-4179-97fa-16d63b62547a","email":"teste.1770407690224.7187.12@loadtest.com","email_verified":true}', 'email', 'f07b2308-1d3f-4179-97fa-16d63b62547a', '2026-02-06T22:55:02.000Z', '2026-02-06T22:55:02.000Z', '2026-02-06T22:55:03.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 12', cpf = '10000000012', phone = '11900000012', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'f07b2308-1d3f-4179-97fa-16d63b62547a';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'f07b2308-1d3f-4179-97fa-16d63b62547a';

-- Teste Usuario 10 (teste.1770407690222.1109.10@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('6840b69e-76f4-46af-8867-e41e5ea26eee', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690222.1109.10@loadtest.com', '', '2026-02-06T22:55:03.000Z', '2026-02-06T22:55:03.000Z', '2026-02-06T22:55:03.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 10"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('df7d4dae-308b-4fd0-95c4-31322a04dd46', '6840b69e-76f4-46af-8867-e41e5ea26eee', '{"sub":"6840b69e-76f4-46af-8867-e41e5ea26eee","email":"teste.1770407690222.1109.10@loadtest.com","email_verified":true}', 'email', '6840b69e-76f4-46af-8867-e41e5ea26eee', '2026-02-06T22:55:03.000Z', '2026-02-06T22:55:03.000Z', '2026-02-06T22:55:03.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 10', cpf = '10000000010', phone = '11900000010', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '6840b69e-76f4-46af-8867-e41e5ea26eee';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '6840b69e-76f4-46af-8867-e41e5ea26eee';

-- Teste Usuario 18 (teste.1770407690229.7066.18@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('7ad5dfa0-8ef3-48a3-881c-c7a1c5e4e915', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690229.7066.18@loadtest.com', '', '2026-02-06T22:55:03.000Z', '2026-02-06T22:55:03.000Z', '2026-02-06T22:55:03.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 18"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('e3c3aee4-d2d7-4f61-abc7-fcc8393d0083', '7ad5dfa0-8ef3-48a3-881c-c7a1c5e4e915', '{"sub":"7ad5dfa0-8ef3-48a3-881c-c7a1c5e4e915","email":"teste.1770407690229.7066.18@loadtest.com","email_verified":true}', 'email', '7ad5dfa0-8ef3-48a3-881c-c7a1c5e4e915', '2026-02-06T22:55:03.000Z', '2026-02-06T22:55:03.000Z', '2026-02-06T22:55:03.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 18', cpf = '10000000018', phone = '11900000018', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '7ad5dfa0-8ef3-48a3-881c-c7a1c5e4e915';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '7ad5dfa0-8ef3-48a3-881c-c7a1c5e4e915';

-- Teste Usuario 24 (teste.1770407690233.7493.24@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('88b68b19-9e51-4679-a19f-2ee526cbae18', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690233.7493.24@loadtest.com', '', '2026-02-06T22:55:03.000Z', '2026-02-06T22:55:03.000Z', '2026-02-06T22:55:03.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 24"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('4850fd16-7164-4787-8b02-536e3389eedc', '88b68b19-9e51-4679-a19f-2ee526cbae18', '{"sub":"88b68b19-9e51-4679-a19f-2ee526cbae18","email":"teste.1770407690233.7493.24@loadtest.com","email_verified":true}', 'email', '88b68b19-9e51-4679-a19f-2ee526cbae18', '2026-02-06T22:55:03.000Z', '2026-02-06T22:55:03.000Z', '2026-02-06T22:55:04.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 24', cpf = '10000000024', phone = '11900000024', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '88b68b19-9e51-4679-a19f-2ee526cbae18';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '88b68b19-9e51-4679-a19f-2ee526cbae18';

-- Teste Usuario 30 (teste.1770407690238.2076.30@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('ed0ca8ef-112e-4bce-a3b0-1e6e60ed9e03', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690238.2076.30@loadtest.com', '', '2026-02-06T22:55:04.000Z', '2026-02-06T22:55:04.000Z', '2026-02-06T22:55:04.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 30"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('b65335d5-f506-453f-bf1a-adbe2a27cd64', 'ed0ca8ef-112e-4bce-a3b0-1e6e60ed9e03', '{"sub":"ed0ca8ef-112e-4bce-a3b0-1e6e60ed9e03","email":"teste.1770407690238.2076.30@loadtest.com","email_verified":true}', 'email', 'ed0ca8ef-112e-4bce-a3b0-1e6e60ed9e03', '2026-02-06T22:55:04.000Z', '2026-02-06T22:55:04.000Z', '2026-02-06T22:55:04.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 30', cpf = '10000000030', phone = '11900000030', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'ed0ca8ef-112e-4bce-a3b0-1e6e60ed9e03';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'ed0ca8ef-112e-4bce-a3b0-1e6e60ed9e03';

-- Teste Usuario 21 (teste.1770407690231.9376.21@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('fdc2c59a-53dd-44f2-a0d9-d2df3af48920', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690231.9376.21@loadtest.com', '', '2026-02-06T22:55:04.000Z', '2026-02-06T22:55:04.000Z', '2026-02-06T22:55:04.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 21"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('1bbaa35c-a485-45d2-8f64-2c794b40925c', 'fdc2c59a-53dd-44f2-a0d9-d2df3af48920', '{"sub":"fdc2c59a-53dd-44f2-a0d9-d2df3af48920","email":"teste.1770407690231.9376.21@loadtest.com","email_verified":true}', 'email', 'fdc2c59a-53dd-44f2-a0d9-d2df3af48920', '2026-02-06T22:55:04.000Z', '2026-02-06T22:55:04.000Z', '2026-02-06T22:55:05.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 21', cpf = '10000000021', phone = '11900000021', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'fdc2c59a-53dd-44f2-a0d9-d2df3af48920';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'fdc2c59a-53dd-44f2-a0d9-d2df3af48920';

-- Teste Usuario 29 (teste.1770407690237.9313.29@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('4c1b25e0-fb89-4a05-af1f-0b42ae36de89', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690237.9313.29@loadtest.com', '', '2026-02-06T22:55:05.000Z', '2026-02-06T22:55:05.000Z', '2026-02-06T22:55:05.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 29"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('3b4b44e5-cf6d-44f2-8e99-e34e6d31c597', '4c1b25e0-fb89-4a05-af1f-0b42ae36de89', '{"sub":"4c1b25e0-fb89-4a05-af1f-0b42ae36de89","email":"teste.1770407690237.9313.29@loadtest.com","email_verified":true}', 'email', '4c1b25e0-fb89-4a05-af1f-0b42ae36de89', '2026-02-06T22:55:05.000Z', '2026-02-06T22:55:05.000Z', '2026-02-06T22:55:05.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 29', cpf = '10000000029', phone = '11900000029', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '4c1b25e0-fb89-4a05-af1f-0b42ae36de89';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '4c1b25e0-fb89-4a05-af1f-0b42ae36de89';

-- Teste Usuario 25 (teste.1770407690234.1856.25@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('1d9c1e8e-cc6e-44a2-af22-8ef086f19ef4', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690234.1856.25@loadtest.com', '', '2026-02-06T22:55:05.000Z', '2026-02-06T22:55:05.000Z', '2026-02-06T22:55:05.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 25"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('b80fcbd1-5267-4e91-a675-281b34711c7d', '1d9c1e8e-cc6e-44a2-af22-8ef086f19ef4', '{"sub":"1d9c1e8e-cc6e-44a2-af22-8ef086f19ef4","email":"teste.1770407690234.1856.25@loadtest.com","email_verified":true}', 'email', '1d9c1e8e-cc6e-44a2-af22-8ef086f19ef4', '2026-02-06T22:55:05.000Z', '2026-02-06T22:55:05.000Z', '2026-02-06T22:55:06.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 25', cpf = '10000000025', phone = '11900000025', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '1d9c1e8e-cc6e-44a2-af22-8ef086f19ef4';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '1d9c1e8e-cc6e-44a2-af22-8ef086f19ef4';

-- Teste Usuario 19 (teste.1770407690230.669.19@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('36ecff41-97fd-476d-90f0-acc319650e65', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690230.669.19@loadtest.com', '', '2026-02-06T22:55:06.000Z', '2026-02-06T22:55:06.000Z', '2026-02-06T22:55:06.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 19"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('2de9897d-d893-4f80-9ce7-3472860364b0', '36ecff41-97fd-476d-90f0-acc319650e65', '{"sub":"36ecff41-97fd-476d-90f0-acc319650e65","email":"teste.1770407690230.669.19@loadtest.com","email_verified":true}', 'email', '36ecff41-97fd-476d-90f0-acc319650e65', '2026-02-06T22:55:06.000Z', '2026-02-06T22:55:06.000Z', '2026-02-06T22:55:06.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 19', cpf = '10000000019', phone = '11900000019', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '36ecff41-97fd-476d-90f0-acc319650e65';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '36ecff41-97fd-476d-90f0-acc319650e65';

-- Teste Usuario 33 (teste.1770407690240.3703.33@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('47672775-7988-45c9-a18e-cb15ac77088b', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690240.3703.33@loadtest.com', '', '2026-02-06T22:55:06.000Z', '2026-02-06T22:55:06.000Z', '2026-02-06T22:55:06.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 33"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('a02adb04-ed6e-4fce-b28c-45cd2c6d5263', '47672775-7988-45c9-a18e-cb15ac77088b', '{"sub":"47672775-7988-45c9-a18e-cb15ac77088b","email":"teste.1770407690240.3703.33@loadtest.com","email_verified":true}', 'email', '47672775-7988-45c9-a18e-cb15ac77088b', '2026-02-06T22:55:06.000Z', '2026-02-06T22:55:06.000Z', '2026-02-06T22:55:06.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 33', cpf = '10000000033', phone = '11900000033', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '47672775-7988-45c9-a18e-cb15ac77088b';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '47672775-7988-45c9-a18e-cb15ac77088b';

-- Teste Usuario 34 (teste.1770407690241.5217.34@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('828ef2dc-d029-4a5e-a0a2-36e95dc92fd9', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690241.5217.34@loadtest.com', '', '2026-02-06T22:55:07.000Z', '2026-02-06T22:55:07.000Z', '2026-02-06T22:55:07.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 34"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('bb26f861-26a0-43af-b092-874468248c25', '828ef2dc-d029-4a5e-a0a2-36e95dc92fd9', '{"sub":"828ef2dc-d029-4a5e-a0a2-36e95dc92fd9","email":"teste.1770407690241.5217.34@loadtest.com","email_verified":true}', 'email', '828ef2dc-d029-4a5e-a0a2-36e95dc92fd9', '2026-02-06T22:55:07.000Z', '2026-02-06T22:55:07.000Z', '2026-02-06T22:55:07.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 34', cpf = '10000000034', phone = '11900000034', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '828ef2dc-d029-4a5e-a0a2-36e95dc92fd9';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '828ef2dc-d029-4a5e-a0a2-36e95dc92fd9';

-- Teste Usuario 20 (teste.1770407690230.664.20@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('e623b815-6fb4-4782-bf40-cc413908e032', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690230.664.20@loadtest.com', '', '2026-02-06T22:55:07.000Z', '2026-02-06T22:55:07.000Z', '2026-02-06T22:55:07.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 20"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('6328acc8-53a5-4dfb-96c4-7ea0c5477880', 'e623b815-6fb4-4782-bf40-cc413908e032', '{"sub":"e623b815-6fb4-4782-bf40-cc413908e032","email":"teste.1770407690230.664.20@loadtest.com","email_verified":true}', 'email', 'e623b815-6fb4-4782-bf40-cc413908e032', '2026-02-06T22:55:07.000Z', '2026-02-06T22:55:07.000Z', '2026-02-06T22:55:07.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 20', cpf = '10000000020', phone = '11900000020', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'e623b815-6fb4-4782-bf40-cc413908e032';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'e623b815-6fb4-4782-bf40-cc413908e032';

-- Teste Usuario 27 (teste.1770407690235.9352.27@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('9616cc77-ba76-4638-8d2b-1581ea70b8bd', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690235.9352.27@loadtest.com', '', '2026-02-06T22:55:07.000Z', '2026-02-06T22:55:07.000Z', '2026-02-06T22:55:07.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 27"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('2554bdd8-fc9e-49a3-8fa3-5c43d46c3bdd', '9616cc77-ba76-4638-8d2b-1581ea70b8bd', '{"sub":"9616cc77-ba76-4638-8d2b-1581ea70b8bd","email":"teste.1770407690235.9352.27@loadtest.com","email_verified":true}', 'email', '9616cc77-ba76-4638-8d2b-1581ea70b8bd', '2026-02-06T22:55:07.000Z', '2026-02-06T22:55:07.000Z', '2026-02-06T22:55:08.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 27', cpf = '10000000027', phone = '11900000027', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '9616cc77-ba76-4638-8d2b-1581ea70b8bd';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '9616cc77-ba76-4638-8d2b-1581ea70b8bd';

-- Teste Usuario 59 (teste.1770407690261.2597.59@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('e6b4fbcc-ee1c-4bff-b14e-8a0375119962', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690261.2597.59@loadtest.com', '', '2026-02-06T22:55:08.000Z', '2026-02-06T22:55:08.000Z', '2026-02-06T22:55:08.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 59"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('08ded04d-b044-4c15-a115-cdb58803e2df', 'e6b4fbcc-ee1c-4bff-b14e-8a0375119962', '{"sub":"e6b4fbcc-ee1c-4bff-b14e-8a0375119962","email":"teste.1770407690261.2597.59@loadtest.com","email_verified":true}', 'email', 'e6b4fbcc-ee1c-4bff-b14e-8a0375119962', '2026-02-06T22:55:08.000Z', '2026-02-06T22:55:08.000Z', '2026-02-06T22:55:08.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 59', cpf = '10000000059', phone = '11900000059', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'e6b4fbcc-ee1c-4bff-b14e-8a0375119962';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'e6b4fbcc-ee1c-4bff-b14e-8a0375119962';

-- Teste Usuario 47 (teste.1770407690250.1441.47@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('141d1c81-ac75-4f3e-a9e5-9710cb4f9b4a', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690250.1441.47@loadtest.com', '', '2026-02-06T22:55:08.000Z', '2026-02-06T22:55:08.000Z', '2026-02-06T22:55:08.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 47"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('5fce3016-7fde-4b21-8900-b744028a4919', '141d1c81-ac75-4f3e-a9e5-9710cb4f9b4a', '{"sub":"141d1c81-ac75-4f3e-a9e5-9710cb4f9b4a","email":"teste.1770407690250.1441.47@loadtest.com","email_verified":true}', 'email', '141d1c81-ac75-4f3e-a9e5-9710cb4f9b4a', '2026-02-06T22:55:08.000Z', '2026-02-06T22:55:08.000Z', '2026-02-06T22:55:09.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 47', cpf = '10000000047', phone = '11900000047', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '141d1c81-ac75-4f3e-a9e5-9710cb4f9b4a';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '141d1c81-ac75-4f3e-a9e5-9710cb4f9b4a';

-- Teste Usuario 36 (teste.1770407690242.5416.36@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('b02e08a2-539e-4171-8754-7ba9d9bdc877', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690242.5416.36@loadtest.com', '', '2026-02-06T22:55:09.000Z', '2026-02-06T22:55:09.000Z', '2026-02-06T22:55:09.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 36"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('12d43532-03ce-4ced-a331-98cf6d1e7891', 'b02e08a2-539e-4171-8754-7ba9d9bdc877', '{"sub":"b02e08a2-539e-4171-8754-7ba9d9bdc877","email":"teste.1770407690242.5416.36@loadtest.com","email_verified":true}', 'email', 'b02e08a2-539e-4171-8754-7ba9d9bdc877', '2026-02-06T22:55:09.000Z', '2026-02-06T22:55:09.000Z', '2026-02-06T22:55:09.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 36', cpf = '10000000036', phone = '11900000036', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'b02e08a2-539e-4171-8754-7ba9d9bdc877';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'b02e08a2-539e-4171-8754-7ba9d9bdc877';

-- Teste Usuario 28 (teste.1770407690236.9777.28@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('b802bf77-15a6-448f-93d9-63586e8537a7', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690236.9777.28@loadtest.com', '', '2026-02-06T22:55:09.000Z', '2026-02-06T22:55:09.000Z', '2026-02-06T22:55:09.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 28"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('fe6bc86d-e8db-4389-a60e-b0a011ccdb89', 'b802bf77-15a6-448f-93d9-63586e8537a7', '{"sub":"b802bf77-15a6-448f-93d9-63586e8537a7","email":"teste.1770407690236.9777.28@loadtest.com","email_verified":true}', 'email', 'b802bf77-15a6-448f-93d9-63586e8537a7', '2026-02-06T22:55:09.000Z', '2026-02-06T22:55:09.000Z', '2026-02-06T22:55:10.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 28', cpf = '10000000028', phone = '11900000028', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'b802bf77-15a6-448f-93d9-63586e8537a7';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'b802bf77-15a6-448f-93d9-63586e8537a7';

-- Teste Usuario 39 (teste.1770407690244.4796.39@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('e6880e5f-1676-4f55-b0db-af3f11f96bcd', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690244.4796.39@loadtest.com', '', '2026-02-06T22:55:10.000Z', '2026-02-06T22:55:10.000Z', '2026-02-06T22:55:10.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 39"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('6c9033f3-1ff4-4db6-b699-28277873ed06', 'e6880e5f-1676-4f55-b0db-af3f11f96bcd', '{"sub":"e6880e5f-1676-4f55-b0db-af3f11f96bcd","email":"teste.1770407690244.4796.39@loadtest.com","email_verified":true}', 'email', 'e6880e5f-1676-4f55-b0db-af3f11f96bcd', '2026-02-06T22:55:10.000Z', '2026-02-06T22:55:10.000Z', '2026-02-06T22:55:10.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 39', cpf = '10000000039', phone = '11900000039', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'e6880e5f-1676-4f55-b0db-af3f11f96bcd';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'e6880e5f-1676-4f55-b0db-af3f11f96bcd';

-- Teste Usuario 60 (teste.1770407690262.4676.60@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('03fc9361-2221-4941-a11b-5807007c4a91', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690262.4676.60@loadtest.com', '', '2026-02-06T22:55:10.000Z', '2026-02-06T22:55:10.000Z', '2026-02-06T22:55:10.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 60"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('87361e2d-95a6-43fa-b6c3-7eb4b0d118a4', '03fc9361-2221-4941-a11b-5807007c4a91', '{"sub":"03fc9361-2221-4941-a11b-5807007c4a91","email":"teste.1770407690262.4676.60@loadtest.com","email_verified":true}', 'email', '03fc9361-2221-4941-a11b-5807007c4a91', '2026-02-06T22:55:10.000Z', '2026-02-06T22:55:10.000Z', '2026-02-06T22:55:10.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 60', cpf = '10000000060', phone = '11900000060', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '03fc9361-2221-4941-a11b-5807007c4a91';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '03fc9361-2221-4941-a11b-5807007c4a91';

-- Teste Usuario 52 (teste.1770407690256.6181.52@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('99df0b54-e90a-4e5c-8da7-cd7a80bec2b8', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690256.6181.52@loadtest.com', '', '2026-02-06T22:55:10.000Z', '2026-02-06T22:55:10.000Z', '2026-02-06T22:55:10.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 52"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('62ba446b-a3d6-4ff8-8f1e-f8e0407e3110', '99df0b54-e90a-4e5c-8da7-cd7a80bec2b8', '{"sub":"99df0b54-e90a-4e5c-8da7-cd7a80bec2b8","email":"teste.1770407690256.6181.52@loadtest.com","email_verified":true}', 'email', '99df0b54-e90a-4e5c-8da7-cd7a80bec2b8', '2026-02-06T22:55:10.000Z', '2026-02-06T22:55:10.000Z', '2026-02-06T22:55:11.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 52', cpf = '10000000052', phone = '11900000052', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '99df0b54-e90a-4e5c-8da7-cd7a80bec2b8';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '99df0b54-e90a-4e5c-8da7-cd7a80bec2b8';

-- Teste Usuario 45 (teste.1770407690249.4124.45@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('144efa3e-e0d7-4cff-b9a0-e8f3f9f182ef', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690249.4124.45@loadtest.com', '', '2026-02-06T22:55:11.000Z', '2026-02-06T22:55:11.000Z', '2026-02-06T22:55:11.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 45"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('f43c56d1-0a4c-4b14-a8de-bf59ef7c47a2', '144efa3e-e0d7-4cff-b9a0-e8f3f9f182ef', '{"sub":"144efa3e-e0d7-4cff-b9a0-e8f3f9f182ef","email":"teste.1770407690249.4124.45@loadtest.com","email_verified":true}', 'email', '144efa3e-e0d7-4cff-b9a0-e8f3f9f182ef', '2026-02-06T22:55:11.000Z', '2026-02-06T22:55:11.000Z', '2026-02-06T22:55:11.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 45', cpf = '10000000045', phone = '11900000045', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '144efa3e-e0d7-4cff-b9a0-e8f3f9f182ef';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '144efa3e-e0d7-4cff-b9a0-e8f3f9f182ef';

-- Teste Usuario 48 (teste.1770407690251.2476.48@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('854a67b7-7db0-4b45-b025-d01dadb6619c', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690251.2476.48@loadtest.com', '', '2026-02-06T22:55:11.000Z', '2026-02-06T22:55:11.000Z', '2026-02-06T22:55:11.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 48"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('c65c8d4f-43a6-4c13-a090-8f5387554da2', '854a67b7-7db0-4b45-b025-d01dadb6619c', '{"sub":"854a67b7-7db0-4b45-b025-d01dadb6619c","email":"teste.1770407690251.2476.48@loadtest.com","email_verified":true}', 'email', '854a67b7-7db0-4b45-b025-d01dadb6619c', '2026-02-06T22:55:11.000Z', '2026-02-06T22:55:11.000Z', '2026-02-06T22:55:12.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 48', cpf = '10000000048', phone = '11900000048', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '854a67b7-7db0-4b45-b025-d01dadb6619c';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '854a67b7-7db0-4b45-b025-d01dadb6619c';

-- Teste Usuario 49 (teste.1770407690252.6543.49@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('1b939ef8-d7e7-41e3-b066-a5d8541d72a7', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690252.6543.49@loadtest.com', '', '2026-02-06T22:55:12.000Z', '2026-02-06T22:55:12.000Z', '2026-02-06T22:55:12.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 49"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('17320bd0-2723-4a2d-ab0c-3dff2ba29a6e', '1b939ef8-d7e7-41e3-b066-a5d8541d72a7', '{"sub":"1b939ef8-d7e7-41e3-b066-a5d8541d72a7","email":"teste.1770407690252.6543.49@loadtest.com","email_verified":true}', 'email', '1b939ef8-d7e7-41e3-b066-a5d8541d72a7', '2026-02-06T22:55:12.000Z', '2026-02-06T22:55:12.000Z', '2026-02-06T22:55:12.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 49', cpf = '10000000049', phone = '11900000049', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '1b939ef8-d7e7-41e3-b066-a5d8541d72a7';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '1b939ef8-d7e7-41e3-b066-a5d8541d72a7';

-- Teste Usuario 62 (teste.1770407690263.5572.62@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('0cc3fb0d-3b73-4824-a60f-f1ba25bca2eb', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690263.5572.62@loadtest.com', '', '2026-02-06T22:55:12.000Z', '2026-02-06T22:55:12.000Z', '2026-02-06T22:55:12.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 62"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('3bee9464-a83c-4dba-a33a-98553afd3939', '0cc3fb0d-3b73-4824-a60f-f1ba25bca2eb', '{"sub":"0cc3fb0d-3b73-4824-a60f-f1ba25bca2eb","email":"teste.1770407690263.5572.62@loadtest.com","email_verified":true}', 'email', '0cc3fb0d-3b73-4824-a60f-f1ba25bca2eb', '2026-02-06T22:55:12.000Z', '2026-02-06T22:55:12.000Z', '2026-02-06T22:55:13.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 62', cpf = '10000000062', phone = '11900000062', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '0cc3fb0d-3b73-4824-a60f-f1ba25bca2eb';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '0cc3fb0d-3b73-4824-a60f-f1ba25bca2eb';

-- Teste Usuario 83 (teste.1770407690279.5335.83@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('fdb0ac6c-31e1-4a85-82e0-974bd88e779d', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690279.5335.83@loadtest.com', '', '2026-02-06T22:55:13.000Z', '2026-02-06T22:55:13.000Z', '2026-02-06T22:55:13.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 83"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('a7c219c2-81a8-40d6-b262-65dd946153e7', 'fdb0ac6c-31e1-4a85-82e0-974bd88e779d', '{"sub":"fdb0ac6c-31e1-4a85-82e0-974bd88e779d","email":"teste.1770407690279.5335.83@loadtest.com","email_verified":true}', 'email', 'fdb0ac6c-31e1-4a85-82e0-974bd88e779d', '2026-02-06T22:55:13.000Z', '2026-02-06T22:55:13.000Z', '2026-02-06T22:55:13.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 83', cpf = '10000000083', phone = '11900000083', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'fdb0ac6c-31e1-4a85-82e0-974bd88e779d';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'fdb0ac6c-31e1-4a85-82e0-974bd88e779d';

-- Teste Usuario 40 (teste.1770407690245.4292.40@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('19553190-65b6-45c1-aa0f-e7d76dab62b9', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690245.4292.40@loadtest.com', '', '2026-02-06T22:55:13.000Z', '2026-02-06T22:55:13.000Z', '2026-02-06T22:55:13.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 40"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('1164160b-5b83-432c-be31-1fd50cdacd2f', '19553190-65b6-45c1-aa0f-e7d76dab62b9', '{"sub":"19553190-65b6-45c1-aa0f-e7d76dab62b9","email":"teste.1770407690245.4292.40@loadtest.com","email_verified":true}', 'email', '19553190-65b6-45c1-aa0f-e7d76dab62b9', '2026-02-06T22:55:13.000Z', '2026-02-06T22:55:13.000Z', '2026-02-06T22:55:14.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 40', cpf = '10000000040', phone = '11900000040', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '19553190-65b6-45c1-aa0f-e7d76dab62b9';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '19553190-65b6-45c1-aa0f-e7d76dab62b9';

-- Teste Usuario 41 (teste.1770407690246.9634.41@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('497c7770-6b04-4a31-91d0-22ce6fd2dece', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690246.9634.41@loadtest.com', '', '2026-02-06T22:55:14.000Z', '2026-02-06T22:55:14.000Z', '2026-02-06T22:55:14.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 41"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('b7266a56-804d-404b-945a-d2e01320f9a6', '497c7770-6b04-4a31-91d0-22ce6fd2dece', '{"sub":"497c7770-6b04-4a31-91d0-22ce6fd2dece","email":"teste.1770407690246.9634.41@loadtest.com","email_verified":true}', 'email', '497c7770-6b04-4a31-91d0-22ce6fd2dece', '2026-02-06T22:55:14.000Z', '2026-02-06T22:55:14.000Z', '2026-02-06T22:55:14.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 41', cpf = '10000000041', phone = '11900000041', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '497c7770-6b04-4a31-91d0-22ce6fd2dece';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '497c7770-6b04-4a31-91d0-22ce6fd2dece';

-- Teste Usuario 51 (teste.1770407690254.2193.51@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('89752362-7c4c-40a2-b34d-33010165b950', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690254.2193.51@loadtest.com', '', '2026-02-06T22:55:14.000Z', '2026-02-06T22:55:14.000Z', '2026-02-06T22:55:14.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 51"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('98f719ae-efe2-46c8-992f-b958481be9a1', '89752362-7c4c-40a2-b34d-33010165b950', '{"sub":"89752362-7c4c-40a2-b34d-33010165b950","email":"teste.1770407690254.2193.51@loadtest.com","email_verified":true}', 'email', '89752362-7c4c-40a2-b34d-33010165b950', '2026-02-06T22:55:14.000Z', '2026-02-06T22:55:14.000Z', '2026-02-06T22:55:14.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 51', cpf = '10000000051', phone = '11900000051', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '89752362-7c4c-40a2-b34d-33010165b950';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '89752362-7c4c-40a2-b34d-33010165b950';

-- Teste Usuario 54 (teste.1770407690257.7651.54@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('f241c961-5469-4d8c-99a5-909422873401', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690257.7651.54@loadtest.com', '', '2026-02-06T22:55:14.000Z', '2026-02-06T22:55:14.000Z', '2026-02-06T22:55:14.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 54"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('ef324940-8f4d-43b5-a012-b70c984e34c6', 'f241c961-5469-4d8c-99a5-909422873401', '{"sub":"f241c961-5469-4d8c-99a5-909422873401","email":"teste.1770407690257.7651.54@loadtest.com","email_verified":true}', 'email', 'f241c961-5469-4d8c-99a5-909422873401', '2026-02-06T22:55:14.000Z', '2026-02-06T22:55:14.000Z', '2026-02-06T22:55:15.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 54', cpf = '10000000054', phone = '11900000054', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'f241c961-5469-4d8c-99a5-909422873401';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'f241c961-5469-4d8c-99a5-909422873401';

-- Teste Usuario 22 (teste.1770407690232.2707.22@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('81ab8eac-ae48-4b8a-ab7b-2f915d0be592', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690232.2707.22@loadtest.com', '', '2026-02-06T22:55:15.000Z', '2026-02-06T22:55:15.000Z', '2026-02-06T22:55:15.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 22"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('d686686d-7411-4d41-ae88-5d10ad202c01', '81ab8eac-ae48-4b8a-ab7b-2f915d0be592', '{"sub":"81ab8eac-ae48-4b8a-ab7b-2f915d0be592","email":"teste.1770407690232.2707.22@loadtest.com","email_verified":true}', 'email', '81ab8eac-ae48-4b8a-ab7b-2f915d0be592', '2026-02-06T22:55:15.000Z', '2026-02-06T22:55:15.000Z', '2026-02-06T22:55:15.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 22', cpf = '10000000022', phone = '11900000022', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '81ab8eac-ae48-4b8a-ab7b-2f915d0be592';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '81ab8eac-ae48-4b8a-ab7b-2f915d0be592';

-- Teste Usuario 55 (teste.1770407690258.7258.55@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('9c64baf7-145a-491e-aee8-b5e855290bc4', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690258.7258.55@loadtest.com', '', '2026-02-06T22:55:15.000Z', '2026-02-06T22:55:15.000Z', '2026-02-06T22:55:15.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 55"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('7f238d1c-da44-4730-ad31-9d9c7ad534c1', '9c64baf7-145a-491e-aee8-b5e855290bc4', '{"sub":"9c64baf7-145a-491e-aee8-b5e855290bc4","email":"teste.1770407690258.7258.55@loadtest.com","email_verified":true}', 'email', '9c64baf7-145a-491e-aee8-b5e855290bc4', '2026-02-06T22:55:15.000Z', '2026-02-06T22:55:15.000Z', '2026-02-06T22:55:16.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 55', cpf = '10000000055', phone = '11900000055', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '9c64baf7-145a-491e-aee8-b5e855290bc4';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '9c64baf7-145a-491e-aee8-b5e855290bc4';

-- Teste Usuario 43 (teste.1770407690247.3088.43@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('74e02a28-8738-40e8-8e09-24bb425f1329', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690247.3088.43@loadtest.com', '', '2026-02-06T22:55:16.000Z', '2026-02-06T22:55:16.000Z', '2026-02-06T22:55:16.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 43"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('d1d9d11d-cd5b-43aa-85f4-a9f0d9e52e93', '74e02a28-8738-40e8-8e09-24bb425f1329', '{"sub":"74e02a28-8738-40e8-8e09-24bb425f1329","email":"teste.1770407690247.3088.43@loadtest.com","email_verified":true}', 'email', '74e02a28-8738-40e8-8e09-24bb425f1329', '2026-02-06T22:55:16.000Z', '2026-02-06T22:55:16.000Z', '2026-02-06T22:55:16.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 43', cpf = '10000000043', phone = '11900000043', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '74e02a28-8738-40e8-8e09-24bb425f1329';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '74e02a28-8738-40e8-8e09-24bb425f1329';

-- Teste Usuario 76 (teste.1770407690274.1180.76@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('4842eda7-2f7c-42d7-bcf9-ee57e635163b', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690274.1180.76@loadtest.com', '', '2026-02-06T22:55:16.000Z', '2026-02-06T22:55:16.000Z', '2026-02-06T22:55:16.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 76"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('30b28605-3c43-4307-8990-2cbac77faf97', '4842eda7-2f7c-42d7-bcf9-ee57e635163b', '{"sub":"4842eda7-2f7c-42d7-bcf9-ee57e635163b","email":"teste.1770407690274.1180.76@loadtest.com","email_verified":true}', 'email', '4842eda7-2f7c-42d7-bcf9-ee57e635163b', '2026-02-06T22:55:16.000Z', '2026-02-06T22:55:16.000Z', '2026-02-06T22:55:17.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 76', cpf = '10000000076', phone = '11900000076', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '4842eda7-2f7c-42d7-bcf9-ee57e635163b';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '4842eda7-2f7c-42d7-bcf9-ee57e635163b';

-- Teste Usuario 50 (teste.1770407690253.8130.50@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('89e465af-1e1d-4b12-b68d-5aa0c913229e', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690253.8130.50@loadtest.com', '', '2026-02-06T22:55:17.000Z', '2026-02-06T22:55:17.000Z', '2026-02-06T22:55:17.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 50"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('af69c6a8-8986-40b7-8796-d0354b33fc14', '89e465af-1e1d-4b12-b68d-5aa0c913229e', '{"sub":"89e465af-1e1d-4b12-b68d-5aa0c913229e","email":"teste.1770407690253.8130.50@loadtest.com","email_verified":true}', 'email', '89e465af-1e1d-4b12-b68d-5aa0c913229e', '2026-02-06T22:55:17.000Z', '2026-02-06T22:55:17.000Z', '2026-02-06T22:55:17.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 50', cpf = '10000000050', phone = '11900000050', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '89e465af-1e1d-4b12-b68d-5aa0c913229e';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '89e465af-1e1d-4b12-b68d-5aa0c913229e';

-- Teste Usuario 46 (teste.1770407690250.8937.46@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('048d6631-67b7-412a-88ea-39e12b5778c4', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690250.8937.46@loadtest.com', '', '2026-02-06T22:55:17.000Z', '2026-02-06T22:55:17.000Z', '2026-02-06T22:55:17.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 46"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('dd5a5eeb-614f-43df-af53-365992a05a62', '048d6631-67b7-412a-88ea-39e12b5778c4', '{"sub":"048d6631-67b7-412a-88ea-39e12b5778c4","email":"teste.1770407690250.8937.46@loadtest.com","email_verified":true}', 'email', '048d6631-67b7-412a-88ea-39e12b5778c4', '2026-02-06T22:55:17.000Z', '2026-02-06T22:55:17.000Z', '2026-02-06T22:55:17.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 46', cpf = '10000000046', phone = '11900000046', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '048d6631-67b7-412a-88ea-39e12b5778c4';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '048d6631-67b7-412a-88ea-39e12b5778c4';

-- Teste Usuario 64 (teste.1770407690265.4490.64@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('3136c3ce-a4b1-4669-b4ee-c68a059c4d4c', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690265.4490.64@loadtest.com', '', '2026-02-06T22:55:17.000Z', '2026-02-06T22:55:17.000Z', '2026-02-06T22:55:17.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 64"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('da1f2833-2f8f-4b9c-9906-eba7c6b62830', '3136c3ce-a4b1-4669-b4ee-c68a059c4d4c', '{"sub":"3136c3ce-a4b1-4669-b4ee-c68a059c4d4c","email":"teste.1770407690265.4490.64@loadtest.com","email_verified":true}', 'email', '3136c3ce-a4b1-4669-b4ee-c68a059c4d4c', '2026-02-06T22:55:17.000Z', '2026-02-06T22:55:17.000Z', '2026-02-06T22:55:18.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 64', cpf = '10000000064', phone = '11900000064', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '3136c3ce-a4b1-4669-b4ee-c68a059c4d4c';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '3136c3ce-a4b1-4669-b4ee-c68a059c4d4c';

-- Teste Usuario 44 (teste.1770407690248.2256.44@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('377902fd-e4bc-45ee-bdf9-a79f56ee0024', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690248.2256.44@loadtest.com', '', '2026-02-06T22:55:18.000Z', '2026-02-06T22:55:18.000Z', '2026-02-06T22:55:18.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 44"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('58341221-96eb-4523-a46d-8954b313d89d', '377902fd-e4bc-45ee-bdf9-a79f56ee0024', '{"sub":"377902fd-e4bc-45ee-bdf9-a79f56ee0024","email":"teste.1770407690248.2256.44@loadtest.com","email_verified":true}', 'email', '377902fd-e4bc-45ee-bdf9-a79f56ee0024', '2026-02-06T22:55:18.000Z', '2026-02-06T22:55:18.000Z', '2026-02-06T22:55:18.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 44', cpf = '10000000044', phone = '11900000044', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '377902fd-e4bc-45ee-bdf9-a79f56ee0024';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '377902fd-e4bc-45ee-bdf9-a79f56ee0024';

-- Teste Usuario 84 (teste.1770407690281.7460.84@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('5eafa593-582c-4280-9d43-a72205f7f4de', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690281.7460.84@loadtest.com', '', '2026-02-06T22:55:18.000Z', '2026-02-06T22:55:18.000Z', '2026-02-06T22:55:18.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 84"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('56b745ce-8a68-427a-add1-7f69a8efa115', '5eafa593-582c-4280-9d43-a72205f7f4de', '{"sub":"5eafa593-582c-4280-9d43-a72205f7f4de","email":"teste.1770407690281.7460.84@loadtest.com","email_verified":true}', 'email', '5eafa593-582c-4280-9d43-a72205f7f4de', '2026-02-06T22:55:18.000Z', '2026-02-06T22:55:18.000Z', '2026-02-06T22:55:19.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 84', cpf = '10000000084', phone = '11900000084', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '5eafa593-582c-4280-9d43-a72205f7f4de';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '5eafa593-582c-4280-9d43-a72205f7f4de';

-- Teste Usuario 86 (teste.1770407690283.8010.86@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('f725d0bd-bc06-484c-9464-9c4b65f024be', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690283.8010.86@loadtest.com', '', '2026-02-06T22:55:19.000Z', '2026-02-06T22:55:19.000Z', '2026-02-06T22:55:19.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 86"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('4c4e3838-45d3-4ee4-a2c1-2c6ffe0e903c', 'f725d0bd-bc06-484c-9464-9c4b65f024be', '{"sub":"f725d0bd-bc06-484c-9464-9c4b65f024be","email":"teste.1770407690283.8010.86@loadtest.com","email_verified":true}', 'email', 'f725d0bd-bc06-484c-9464-9c4b65f024be', '2026-02-06T22:55:19.000Z', '2026-02-06T22:55:19.000Z', '2026-02-06T22:55:19.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 86', cpf = '10000000086', phone = '11900000086', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'f725d0bd-bc06-484c-9464-9c4b65f024be';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'f725d0bd-bc06-484c-9464-9c4b65f024be';

-- Teste Usuario 77 (teste.1770407690275.4523.77@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('33ce0e26-61b2-4d04-a969-4478b4dbc354', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690275.4523.77@loadtest.com', '', '2026-02-06T22:55:19.000Z', '2026-02-06T22:55:19.000Z', '2026-02-06T22:55:19.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 77"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('b9cbd1e0-ef4a-435c-89e8-a4e5ff30f28c', '33ce0e26-61b2-4d04-a969-4478b4dbc354', '{"sub":"33ce0e26-61b2-4d04-a969-4478b4dbc354","email":"teste.1770407690275.4523.77@loadtest.com","email_verified":true}', 'email', '33ce0e26-61b2-4d04-a969-4478b4dbc354', '2026-02-06T22:55:19.000Z', '2026-02-06T22:55:19.000Z', '2026-02-06T22:55:20.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 77', cpf = '10000000077', phone = '11900000077', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '33ce0e26-61b2-4d04-a969-4478b4dbc354';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '33ce0e26-61b2-4d04-a969-4478b4dbc354';

-- Teste Usuario 53 (teste.1770407690257.5140.53@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('072a4ec8-2d30-4bf1-bba7-9711d67c936d', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690257.5140.53@loadtest.com', '', '2026-02-06T22:55:20.000Z', '2026-02-06T22:55:20.000Z', '2026-02-06T22:55:20.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 53"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('04d9f4ee-76c1-4276-9359-0c0b12a941a9', '072a4ec8-2d30-4bf1-bba7-9711d67c936d', '{"sub":"072a4ec8-2d30-4bf1-bba7-9711d67c936d","email":"teste.1770407690257.5140.53@loadtest.com","email_verified":true}', 'email', '072a4ec8-2d30-4bf1-bba7-9711d67c936d', '2026-02-06T22:55:20.000Z', '2026-02-06T22:55:20.000Z', '2026-02-06T22:55:20.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 53', cpf = '10000000053', phone = '11900000053', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '072a4ec8-2d30-4bf1-bba7-9711d67c936d';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '072a4ec8-2d30-4bf1-bba7-9711d67c936d';

-- Teste Usuario 99 (teste.1770407690293.9610.99@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('c2b191ac-9626-42ab-a3f1-9549c647a4ea', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690293.9610.99@loadtest.com', '', '2026-02-06T22:55:20.000Z', '2026-02-06T22:55:20.000Z', '2026-02-06T22:55:20.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 99"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('2cf240a6-374e-49af-9ca2-2cb21c769781', 'c2b191ac-9626-42ab-a3f1-9549c647a4ea', '{"sub":"c2b191ac-9626-42ab-a3f1-9549c647a4ea","email":"teste.1770407690293.9610.99@loadtest.com","email_verified":true}', 'email', 'c2b191ac-9626-42ab-a3f1-9549c647a4ea', '2026-02-06T22:55:20.000Z', '2026-02-06T22:55:20.000Z', '2026-02-06T22:55:21.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 99', cpf = '10000000099', phone = '11900000099', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'c2b191ac-9626-42ab-a3f1-9549c647a4ea';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'c2b191ac-9626-42ab-a3f1-9549c647a4ea';

-- Teste Usuario 65 (teste.1770407690266.5394.65@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('83efc86a-73b9-4ef1-b7ff-f7c12a405241', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690266.5394.65@loadtest.com', '', '2026-02-06T22:55:21.000Z', '2026-02-06T22:55:21.000Z', '2026-02-06T22:55:21.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 65"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('96cbb6c2-33c7-4874-96d1-97d4206cfa45', '83efc86a-73b9-4ef1-b7ff-f7c12a405241', '{"sub":"83efc86a-73b9-4ef1-b7ff-f7c12a405241","email":"teste.1770407690266.5394.65@loadtest.com","email_verified":true}', 'email', '83efc86a-73b9-4ef1-b7ff-f7c12a405241', '2026-02-06T22:55:21.000Z', '2026-02-06T22:55:21.000Z', '2026-02-06T22:55:21.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 65', cpf = '10000000065', phone = '11900000065', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '83efc86a-73b9-4ef1-b7ff-f7c12a405241';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '83efc86a-73b9-4ef1-b7ff-f7c12a405241';

-- Teste Usuario 89 (teste.1770407690285.707.89@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('f1b52598-0c9e-4040-bd24-59ce8c359415', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690285.707.89@loadtest.com', '', '2026-02-06T22:55:21.000Z', '2026-02-06T22:55:21.000Z', '2026-02-06T22:55:21.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 89"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('caa0b781-a5dc-4549-b601-5838f8212ac9', 'f1b52598-0c9e-4040-bd24-59ce8c359415', '{"sub":"f1b52598-0c9e-4040-bd24-59ce8c359415","email":"teste.1770407690285.707.89@loadtest.com","email_verified":true}', 'email', 'f1b52598-0c9e-4040-bd24-59ce8c359415', '2026-02-06T22:55:21.000Z', '2026-02-06T22:55:21.000Z', '2026-02-06T22:55:21.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 89', cpf = '10000000089', phone = '11900000089', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'f1b52598-0c9e-4040-bd24-59ce8c359415';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'f1b52598-0c9e-4040-bd24-59ce8c359415';

-- Teste Usuario 57 (teste.1770407690259.3613.57@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('c0e9cd99-ad59-4ded-978d-0abe0cb184de', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690259.3613.57@loadtest.com', '', '2026-02-06T22:55:21.000Z', '2026-02-06T22:55:21.000Z', '2026-02-06T22:55:21.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 57"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('d02a8ea0-cced-4fcf-846b-90ff0f4a06b7', 'c0e9cd99-ad59-4ded-978d-0abe0cb184de', '{"sub":"c0e9cd99-ad59-4ded-978d-0abe0cb184de","email":"teste.1770407690259.3613.57@loadtest.com","email_verified":true}', 'email', 'c0e9cd99-ad59-4ded-978d-0abe0cb184de', '2026-02-06T22:55:21.000Z', '2026-02-06T22:55:21.000Z', '2026-02-06T22:55:22.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 57', cpf = '10000000057', phone = '11900000057', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'c0e9cd99-ad59-4ded-978d-0abe0cb184de';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'c0e9cd99-ad59-4ded-978d-0abe0cb184de';

-- Teste Usuario 32 (teste.1770407690239.8981.32@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('e3dece6b-38cd-4084-bf5f-45b997774c01', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690239.8981.32@loadtest.com', '', '2026-02-06T22:55:22.000Z', '2026-02-06T22:55:22.000Z', '2026-02-06T22:55:22.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 32"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('59108db6-82e0-43d4-86eb-c0ff18167c9c', 'e3dece6b-38cd-4084-bf5f-45b997774c01', '{"sub":"e3dece6b-38cd-4084-bf5f-45b997774c01","email":"teste.1770407690239.8981.32@loadtest.com","email_verified":true}', 'email', 'e3dece6b-38cd-4084-bf5f-45b997774c01', '2026-02-06T22:55:22.000Z', '2026-02-06T22:55:22.000Z', '2026-02-06T22:55:22.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 32', cpf = '10000000032', phone = '11900000032', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'e3dece6b-38cd-4084-bf5f-45b997774c01';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'e3dece6b-38cd-4084-bf5f-45b997774c01';

-- Teste Usuario 69 (teste.1770407690269.2108.69@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('721bf314-887a-450a-aa8e-e9409403d88c', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690269.2108.69@loadtest.com', '', '2026-02-06T22:55:22.000Z', '2026-02-06T22:55:22.000Z', '2026-02-06T22:55:22.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 69"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('300fcdb1-e6ab-4783-aa5f-bd607ded2fc5', '721bf314-887a-450a-aa8e-e9409403d88c', '{"sub":"721bf314-887a-450a-aa8e-e9409403d88c","email":"teste.1770407690269.2108.69@loadtest.com","email_verified":true}', 'email', '721bf314-887a-450a-aa8e-e9409403d88c', '2026-02-06T22:55:22.000Z', '2026-02-06T22:55:22.000Z', '2026-02-06T22:55:23.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 69', cpf = '10000000069', phone = '11900000069', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '721bf314-887a-450a-aa8e-e9409403d88c';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '721bf314-887a-450a-aa8e-e9409403d88c';

-- Teste Usuario 66 (teste.1770407690266.1306.66@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('10805439-86ab-4588-9b14-653d9eaa519a', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690266.1306.66@loadtest.com', '', '2026-02-06T22:55:23.000Z', '2026-02-06T22:55:23.000Z', '2026-02-06T22:55:23.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 66"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('f316a7a3-7d2e-4521-8283-cd805160f22f', '10805439-86ab-4588-9b14-653d9eaa519a', '{"sub":"10805439-86ab-4588-9b14-653d9eaa519a","email":"teste.1770407690266.1306.66@loadtest.com","email_verified":true}', 'email', '10805439-86ab-4588-9b14-653d9eaa519a', '2026-02-06T22:55:23.000Z', '2026-02-06T22:55:23.000Z', '2026-02-06T22:55:23.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 66', cpf = '10000000066', phone = '11900000066', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '10805439-86ab-4588-9b14-653d9eaa519a';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '10805439-86ab-4588-9b14-653d9eaa519a';

-- Teste Usuario 58 (teste.1770407690260.2867.58@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('f78451a0-95db-4b0f-afc7-e59a1fa23842', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690260.2867.58@loadtest.com', '', '2026-02-06T22:55:23.000Z', '2026-02-06T22:55:23.000Z', '2026-02-06T22:55:23.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 58"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('aa670327-d61c-4e6a-928b-1feeb85353f9', 'f78451a0-95db-4b0f-afc7-e59a1fa23842', '{"sub":"f78451a0-95db-4b0f-afc7-e59a1fa23842","email":"teste.1770407690260.2867.58@loadtest.com","email_verified":true}', 'email', 'f78451a0-95db-4b0f-afc7-e59a1fa23842', '2026-02-06T22:55:23.000Z', '2026-02-06T22:55:23.000Z', '2026-02-06T22:55:24.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 58', cpf = '10000000058', phone = '11900000058', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'f78451a0-95db-4b0f-afc7-e59a1fa23842';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'f78451a0-95db-4b0f-afc7-e59a1fa23842';

-- Teste Usuario 73 (teste.1770407690272.7699.73@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('3653eabb-7935-4bdf-aff5-b120eb144a3b', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690272.7699.73@loadtest.com', '', '2026-02-06T22:55:24.000Z', '2026-02-06T22:55:24.000Z', '2026-02-06T22:55:24.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 73"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('dcb497ff-8e16-49aa-b30e-81e4628e615f', '3653eabb-7935-4bdf-aff5-b120eb144a3b', '{"sub":"3653eabb-7935-4bdf-aff5-b120eb144a3b","email":"teste.1770407690272.7699.73@loadtest.com","email_verified":true}', 'email', '3653eabb-7935-4bdf-aff5-b120eb144a3b', '2026-02-06T22:55:24.000Z', '2026-02-06T22:55:24.000Z', '2026-02-06T22:55:24.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 73', cpf = '10000000073', phone = '11900000073', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '3653eabb-7935-4bdf-aff5-b120eb144a3b';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '3653eabb-7935-4bdf-aff5-b120eb144a3b';

-- Teste Usuario 98 (teste.1770407690292.4846.98@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('95a4eb62-e041-4fb1-bd44-2ed821d9517c', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690292.4846.98@loadtest.com', '', '2026-02-06T22:55:24.000Z', '2026-02-06T22:55:24.000Z', '2026-02-06T22:55:24.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 98"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('2b8b0702-71da-47a2-a9c5-321133ec2a9b', '95a4eb62-e041-4fb1-bd44-2ed821d9517c', '{"sub":"95a4eb62-e041-4fb1-bd44-2ed821d9517c","email":"teste.1770407690292.4846.98@loadtest.com","email_verified":true}', 'email', '95a4eb62-e041-4fb1-bd44-2ed821d9517c', '2026-02-06T22:55:24.000Z', '2026-02-06T22:55:24.000Z', '2026-02-06T22:55:25.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 98', cpf = '10000000098', phone = '11900000098', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '95a4eb62-e041-4fb1-bd44-2ed821d9517c';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '95a4eb62-e041-4fb1-bd44-2ed821d9517c';

-- Teste Usuario 68 (teste.1770407690268.1461.68@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('5f6f38c7-23ae-41fb-8e26-bbb9f3fde3b4', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690268.1461.68@loadtest.com', '', '2026-02-06T22:55:25.000Z', '2026-02-06T22:55:25.000Z', '2026-02-06T22:55:25.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 68"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('801c33e8-3fe2-420a-918b-a1e468348c81', '5f6f38c7-23ae-41fb-8e26-bbb9f3fde3b4', '{"sub":"5f6f38c7-23ae-41fb-8e26-bbb9f3fde3b4","email":"teste.1770407690268.1461.68@loadtest.com","email_verified":true}', 'email', '5f6f38c7-23ae-41fb-8e26-bbb9f3fde3b4', '2026-02-06T22:55:25.000Z', '2026-02-06T22:55:25.000Z', '2026-02-06T22:55:25.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 68', cpf = '10000000068', phone = '11900000068', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '5f6f38c7-23ae-41fb-8e26-bbb9f3fde3b4';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '5f6f38c7-23ae-41fb-8e26-bbb9f3fde3b4';

-- Teste Usuario 56 (teste.1770407690259.896.56@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('687ac3fb-891f-47b2-a84b-6facd39a9cea', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690259.896.56@loadtest.com', '', '2026-02-06T22:55:25.000Z', '2026-02-06T22:55:25.000Z', '2026-02-06T22:55:25.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 56"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('1fd69de1-0b5f-4f22-8d78-1bb39185c7ab', '687ac3fb-891f-47b2-a84b-6facd39a9cea', '{"sub":"687ac3fb-891f-47b2-a84b-6facd39a9cea","email":"teste.1770407690259.896.56@loadtest.com","email_verified":true}', 'email', '687ac3fb-891f-47b2-a84b-6facd39a9cea', '2026-02-06T22:55:25.000Z', '2026-02-06T22:55:25.000Z', '2026-02-06T22:55:25.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 56', cpf = '10000000056', phone = '11900000056', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '687ac3fb-891f-47b2-a84b-6facd39a9cea';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '687ac3fb-891f-47b2-a84b-6facd39a9cea';

-- Teste Usuario 78 (teste.1770407690275.2336.78@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('e916d650-e945-4636-98f2-cf3bd85f9b86', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690275.2336.78@loadtest.com', '', '2026-02-06T22:55:25.000Z', '2026-02-06T22:55:25.000Z', '2026-02-06T22:55:25.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 78"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('1ddca05d-c3ef-4989-8ab9-026c3bb7f423', 'e916d650-e945-4636-98f2-cf3bd85f9b86', '{"sub":"e916d650-e945-4636-98f2-cf3bd85f9b86","email":"teste.1770407690275.2336.78@loadtest.com","email_verified":true}', 'email', 'e916d650-e945-4636-98f2-cf3bd85f9b86', '2026-02-06T22:55:25.000Z', '2026-02-06T22:55:25.000Z', '2026-02-06T22:55:26.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 78', cpf = '10000000078', phone = '11900000078', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'e916d650-e945-4636-98f2-cf3bd85f9b86';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'e916d650-e945-4636-98f2-cf3bd85f9b86';

-- Teste Usuario 90 (teste.1770407690286.1329.90@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('78d98a18-8a45-4060-9857-073d2d19ba47', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690286.1329.90@loadtest.com', '', '2026-02-06T22:55:26.000Z', '2026-02-06T22:55:26.000Z', '2026-02-06T22:55:26.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 90"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('91352804-d983-4bde-8fe6-4cd575c65a4e', '78d98a18-8a45-4060-9857-073d2d19ba47', '{"sub":"78d98a18-8a45-4060-9857-073d2d19ba47","email":"teste.1770407690286.1329.90@loadtest.com","email_verified":true}', 'email', '78d98a18-8a45-4060-9857-073d2d19ba47', '2026-02-06T22:55:26.000Z', '2026-02-06T22:55:26.000Z', '2026-02-06T22:55:26.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 90', cpf = '10000000090', phone = '11900000090', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '78d98a18-8a45-4060-9857-073d2d19ba47';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '78d98a18-8a45-4060-9857-073d2d19ba47';

-- Teste Usuario 70 (teste.1770407690269.3864.70@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('bae21fc2-b0b4-4988-8e06-ac7aff173ae0', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690269.3864.70@loadtest.com', '', '2026-02-06T22:55:26.000Z', '2026-02-06T22:55:26.000Z', '2026-02-06T22:55:26.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 70"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('3d4eb75f-146c-42f8-a0a4-4c338290a667', 'bae21fc2-b0b4-4988-8e06-ac7aff173ae0', '{"sub":"bae21fc2-b0b4-4988-8e06-ac7aff173ae0","email":"teste.1770407690269.3864.70@loadtest.com","email_verified":true}', 'email', 'bae21fc2-b0b4-4988-8e06-ac7aff173ae0', '2026-02-06T22:55:26.000Z', '2026-02-06T22:55:26.000Z', '2026-02-06T22:55:27.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 70', cpf = '10000000070', phone = '11900000070', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'bae21fc2-b0b4-4988-8e06-ac7aff173ae0';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'bae21fc2-b0b4-4988-8e06-ac7aff173ae0';

-- Teste Usuario 67 (teste.1770407690267.8922.67@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('a8986828-74f5-4d72-9ea8-d03d79476bda', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690267.8922.67@loadtest.com', '', '2026-02-06T22:55:27.000Z', '2026-02-06T22:55:27.000Z', '2026-02-06T22:55:27.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 67"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('5f1e98b3-b192-4ce9-8610-f9ec8a3769df', 'a8986828-74f5-4d72-9ea8-d03d79476bda', '{"sub":"a8986828-74f5-4d72-9ea8-d03d79476bda","email":"teste.1770407690267.8922.67@loadtest.com","email_verified":true}', 'email', 'a8986828-74f5-4d72-9ea8-d03d79476bda', '2026-02-06T22:55:27.000Z', '2026-02-06T22:55:27.000Z', '2026-02-06T22:55:27.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 67', cpf = '10000000067', phone = '11900000067', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'a8986828-74f5-4d72-9ea8-d03d79476bda';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'a8986828-74f5-4d72-9ea8-d03d79476bda';

-- Teste Usuario 88 (teste.1770407690284.5400.88@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('ee07cc7c-2002-4ab3-9a61-f0d3408bac86', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690284.5400.88@loadtest.com', '', '2026-02-06T22:55:27.000Z', '2026-02-06T22:55:27.000Z', '2026-02-06T22:55:27.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 88"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('c8d1b4c3-07f6-452a-99f1-5d7da907f0d3', 'ee07cc7c-2002-4ab3-9a61-f0d3408bac86', '{"sub":"ee07cc7c-2002-4ab3-9a61-f0d3408bac86","email":"teste.1770407690284.5400.88@loadtest.com","email_verified":true}', 'email', 'ee07cc7c-2002-4ab3-9a61-f0d3408bac86', '2026-02-06T22:55:27.000Z', '2026-02-06T22:55:27.000Z', '2026-02-06T22:55:28.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 88', cpf = '10000000088', phone = '11900000088', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'ee07cc7c-2002-4ab3-9a61-f0d3408bac86';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'ee07cc7c-2002-4ab3-9a61-f0d3408bac86';

-- Teste Usuario 87 (teste.1770407690284.3688.87@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('676cce14-19e4-4d42-9ec4-0204ee49a173', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690284.3688.87@loadtest.com', '', '2026-02-06T22:55:28.000Z', '2026-02-06T22:55:28.000Z', '2026-02-06T22:55:28.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 87"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('750aa1ac-e53c-4756-9c4e-000826ac119e', '676cce14-19e4-4d42-9ec4-0204ee49a173', '{"sub":"676cce14-19e4-4d42-9ec4-0204ee49a173","email":"teste.1770407690284.3688.87@loadtest.com","email_verified":true}', 'email', '676cce14-19e4-4d42-9ec4-0204ee49a173', '2026-02-06T22:55:28.000Z', '2026-02-06T22:55:28.000Z', '2026-02-06T22:55:28.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 87', cpf = '10000000087', phone = '11900000087', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '676cce14-19e4-4d42-9ec4-0204ee49a173';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '676cce14-19e4-4d42-9ec4-0204ee49a173';

-- Teste Usuario 92 (teste.1770407690288.1226.92@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('a94b37c4-141b-48ae-acd0-62c6dbc01188', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690288.1226.92@loadtest.com', '', '2026-02-06T22:55:28.000Z', '2026-02-06T22:55:28.000Z', '2026-02-06T22:55:28.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 92"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('667ad1e9-ee71-4b60-93b8-4dab6f4abc1d', 'a94b37c4-141b-48ae-acd0-62c6dbc01188', '{"sub":"a94b37c4-141b-48ae-acd0-62c6dbc01188","email":"teste.1770407690288.1226.92@loadtest.com","email_verified":true}', 'email', 'a94b37c4-141b-48ae-acd0-62c6dbc01188', '2026-02-06T22:55:28.000Z', '2026-02-06T22:55:28.000Z', '2026-02-06T22:55:29.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 92', cpf = '10000000092', phone = '11900000092', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'a94b37c4-141b-48ae-acd0-62c6dbc01188';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'a94b37c4-141b-48ae-acd0-62c6dbc01188';

-- Teste Usuario 91 (teste.1770407690287.6472.91@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('294011d7-9442-4bb0-bbba-4cf2b0caaed4', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690287.6472.91@loadtest.com', '', '2026-02-06T22:55:29.000Z', '2026-02-06T22:55:29.000Z', '2026-02-06T22:55:29.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 91"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('f3cb396d-1fe4-44e0-9f6c-6e25a5df957c', '294011d7-9442-4bb0-bbba-4cf2b0caaed4', '{"sub":"294011d7-9442-4bb0-bbba-4cf2b0caaed4","email":"teste.1770407690287.6472.91@loadtest.com","email_verified":true}', 'email', '294011d7-9442-4bb0-bbba-4cf2b0caaed4', '2026-02-06T22:55:29.000Z', '2026-02-06T22:55:29.000Z', '2026-02-06T22:55:29.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 91', cpf = '10000000091', phone = '11900000091', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '294011d7-9442-4bb0-bbba-4cf2b0caaed4';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '294011d7-9442-4bb0-bbba-4cf2b0caaed4';

-- Teste Usuario 74 (teste.1770407690272.6007.74@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('f8b45f0e-0e89-485c-bedd-a7269e91524b', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690272.6007.74@loadtest.com', '', '2026-02-06T22:55:29.000Z', '2026-02-06T22:55:29.000Z', '2026-02-06T22:55:29.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 74"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('37806c92-c840-4080-abf3-00e43484c4e0', 'f8b45f0e-0e89-485c-bedd-a7269e91524b', '{"sub":"f8b45f0e-0e89-485c-bedd-a7269e91524b","email":"teste.1770407690272.6007.74@loadtest.com","email_verified":true}', 'email', 'f8b45f0e-0e89-485c-bedd-a7269e91524b', '2026-02-06T22:55:29.000Z', '2026-02-06T22:55:29.000Z', '2026-02-06T22:55:29.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 74', cpf = '10000000074', phone = '11900000074', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'f8b45f0e-0e89-485c-bedd-a7269e91524b';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'f8b45f0e-0e89-485c-bedd-a7269e91524b';

-- Teste Usuario 81 (teste.1770407690278.7691.81@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('f3e947f0-3c93-438d-96a3-0690187d3435', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690278.7691.81@loadtest.com', '', '2026-02-06T22:55:29.000Z', '2026-02-06T22:55:29.000Z', '2026-02-06T22:55:29.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 81"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('4a95cde5-7377-4fa3-b4d1-75eb5696d934', 'f3e947f0-3c93-438d-96a3-0690187d3435', '{"sub":"f3e947f0-3c93-438d-96a3-0690187d3435","email":"teste.1770407690278.7691.81@loadtest.com","email_verified":true}', 'email', 'f3e947f0-3c93-438d-96a3-0690187d3435', '2026-02-06T22:55:29.000Z', '2026-02-06T22:55:29.000Z', '2026-02-06T22:55:30.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 81', cpf = '10000000081', phone = '11900000081', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'f3e947f0-3c93-438d-96a3-0690187d3435';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'f3e947f0-3c93-438d-96a3-0690187d3435';

-- Teste Usuario 75 (teste.1770407690273.133.75@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('c2ae4d08-59a0-4066-a0be-60c4bfe83e79', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690273.133.75@loadtest.com', '', '2026-02-06T22:55:30.000Z', '2026-02-06T22:55:30.000Z', '2026-02-06T22:55:30.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 75"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('5dce8f1a-3b04-45a2-aec1-1ce9ab6d0e08', 'c2ae4d08-59a0-4066-a0be-60c4bfe83e79', '{"sub":"c2ae4d08-59a0-4066-a0be-60c4bfe83e79","email":"teste.1770407690273.133.75@loadtest.com","email_verified":true}', 'email', 'c2ae4d08-59a0-4066-a0be-60c4bfe83e79', '2026-02-06T22:55:30.000Z', '2026-02-06T22:55:30.000Z', '2026-02-06T22:55:30.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 75', cpf = '10000000075', phone = '11900000075', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'c2ae4d08-59a0-4066-a0be-60c4bfe83e79';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'c2ae4d08-59a0-4066-a0be-60c4bfe83e79';

-- Teste Usuario 80 (teste.1770407690277.315.80@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('dec7950b-1845-4b7e-a6e2-ad8b2b9696d6', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690277.315.80@loadtest.com', '', '2026-02-06T22:55:30.000Z', '2026-02-06T22:55:30.000Z', '2026-02-06T22:55:30.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 80"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('c9b88781-72c3-46ee-9898-ff8b6eb195c7', 'dec7950b-1845-4b7e-a6e2-ad8b2b9696d6', '{"sub":"dec7950b-1845-4b7e-a6e2-ad8b2b9696d6","email":"teste.1770407690277.315.80@loadtest.com","email_verified":true}', 'email', 'dec7950b-1845-4b7e-a6e2-ad8b2b9696d6', '2026-02-06T22:55:30.000Z', '2026-02-06T22:55:30.000Z', '2026-02-06T22:55:31.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 80', cpf = '10000000080', phone = '11900000080', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'dec7950b-1845-4b7e-a6e2-ad8b2b9696d6';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'dec7950b-1845-4b7e-a6e2-ad8b2b9696d6';

-- Teste Usuario 72 (teste.1770407690271.6031.72@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('ea598820-4e90-43ff-a9a0-14bc0564df47', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690271.6031.72@loadtest.com', '', '2026-02-06T22:55:31.000Z', '2026-02-06T22:55:31.000Z', '2026-02-06T22:55:31.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 72"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('83733732-de30-48b8-ac28-9327a3491d6e', 'ea598820-4e90-43ff-a9a0-14bc0564df47', '{"sub":"ea598820-4e90-43ff-a9a0-14bc0564df47","email":"teste.1770407690271.6031.72@loadtest.com","email_verified":true}', 'email', 'ea598820-4e90-43ff-a9a0-14bc0564df47', '2026-02-06T22:55:31.000Z', '2026-02-06T22:55:31.000Z', '2026-02-06T22:55:31.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 72', cpf = '10000000072', phone = '11900000072', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'ea598820-4e90-43ff-a9a0-14bc0564df47';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'ea598820-4e90-43ff-a9a0-14bc0564df47';

-- Teste Usuario 93 (teste.1770407690288.5286.93@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('fe4dbbde-6fdf-4b2f-9a35-80b7175b8d8a', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690288.5286.93@loadtest.com', '', '2026-02-06T22:55:31.000Z', '2026-02-06T22:55:31.000Z', '2026-02-06T22:55:31.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 93"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('04ae3ab4-2256-48d7-ac6c-31eba236d47a', 'fe4dbbde-6fdf-4b2f-9a35-80b7175b8d8a', '{"sub":"fe4dbbde-6fdf-4b2f-9a35-80b7175b8d8a","email":"teste.1770407690288.5286.93@loadtest.com","email_verified":true}', 'email', 'fe4dbbde-6fdf-4b2f-9a35-80b7175b8d8a', '2026-02-06T22:55:31.000Z', '2026-02-06T22:55:31.000Z', '2026-02-06T22:55:32.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 93', cpf = '10000000093', phone = '11900000093', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'fe4dbbde-6fdf-4b2f-9a35-80b7175b8d8a';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'fe4dbbde-6fdf-4b2f-9a35-80b7175b8d8a';

-- Teste Usuario 61 (teste.1770407690263.6656.61@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('fe624290-4eeb-4906-8e2a-14a35b62ad75', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690263.6656.61@loadtest.com', '', '2026-02-06T22:55:32.000Z', '2026-02-06T22:55:32.000Z', '2026-02-06T22:55:32.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 61"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('b10fdbe1-7bde-48eb-9194-90f7cad7f444', 'fe624290-4eeb-4906-8e2a-14a35b62ad75', '{"sub":"fe624290-4eeb-4906-8e2a-14a35b62ad75","email":"teste.1770407690263.6656.61@loadtest.com","email_verified":true}', 'email', 'fe624290-4eeb-4906-8e2a-14a35b62ad75', '2026-02-06T22:55:32.000Z', '2026-02-06T22:55:32.000Z', '2026-02-06T22:55:32.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 61', cpf = '10000000061', phone = '11900000061', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'fe624290-4eeb-4906-8e2a-14a35b62ad75';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'fe624290-4eeb-4906-8e2a-14a35b62ad75';

-- Teste Usuario 71 (teste.1770407690270.4469.71@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('8c371657-569f-41d2-9ddf-fd7de18b2065', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690270.4469.71@loadtest.com', '', '2026-02-06T22:55:32.000Z', '2026-02-06T22:55:32.000Z', '2026-02-06T22:55:32.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 71"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('ae571696-31e9-4faf-927b-d19019401fcf', '8c371657-569f-41d2-9ddf-fd7de18b2065', '{"sub":"8c371657-569f-41d2-9ddf-fd7de18b2065","email":"teste.1770407690270.4469.71@loadtest.com","email_verified":true}', 'email', '8c371657-569f-41d2-9ddf-fd7de18b2065', '2026-02-06T22:55:32.000Z', '2026-02-06T22:55:32.000Z', '2026-02-06T22:55:32.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 71', cpf = '10000000071', phone = '11900000071', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '8c371657-569f-41d2-9ddf-fd7de18b2065';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '8c371657-569f-41d2-9ddf-fd7de18b2065';

-- Teste Usuario 100 (teste.1770407690293.7925.100@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('1e695c42-2886-406c-b8b8-b0489ab2d50d', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690293.7925.100@loadtest.com', '', '2026-02-06T22:55:32.000Z', '2026-02-06T22:55:32.000Z', '2026-02-06T22:55:32.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 100"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('d48fcfb7-bada-454b-9145-07030886eada', '1e695c42-2886-406c-b8b8-b0489ab2d50d', '{"sub":"1e695c42-2886-406c-b8b8-b0489ab2d50d","email":"teste.1770407690293.7925.100@loadtest.com","email_verified":true}', 'email', '1e695c42-2886-406c-b8b8-b0489ab2d50d', '2026-02-06T22:55:32.000Z', '2026-02-06T22:55:32.000Z', '2026-02-06T22:55:33.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 100', cpf = '10000000100', phone = '11900000100', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '1e695c42-2886-406c-b8b8-b0489ab2d50d';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '1e695c42-2886-406c-b8b8-b0489ab2d50d';

-- Teste Usuario 82 (teste.1770407690278.9123.82@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('57c919a7-e0e6-46c6-863b-c63fc53b2728', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690278.9123.82@loadtest.com', '', '2026-02-06T22:55:33.000Z', '2026-02-06T22:55:33.000Z', '2026-02-06T22:55:33.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 82"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('745b35d6-51ad-42e6-b68f-6d4547065c14', '57c919a7-e0e6-46c6-863b-c63fc53b2728', '{"sub":"57c919a7-e0e6-46c6-863b-c63fc53b2728","email":"teste.1770407690278.9123.82@loadtest.com","email_verified":true}', 'email', '57c919a7-e0e6-46c6-863b-c63fc53b2728', '2026-02-06T22:55:33.000Z', '2026-02-06T22:55:33.000Z', '2026-02-06T22:55:33.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 82', cpf = '10000000082', phone = '11900000082', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '57c919a7-e0e6-46c6-863b-c63fc53b2728';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '57c919a7-e0e6-46c6-863b-c63fc53b2728';

-- Teste Usuario 31 (teste.1770407690238.7458.31@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('c1d16927-e0cf-41c2-87a3-32cbc05f36f9', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690238.7458.31@loadtest.com', '', '2026-02-06T22:55:33.000Z', '2026-02-06T22:55:33.000Z', '2026-02-06T22:55:33.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 31"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('7413821c-8f2d-450a-9d6b-fb6b9e7516e3', 'c1d16927-e0cf-41c2-87a3-32cbc05f36f9', '{"sub":"c1d16927-e0cf-41c2-87a3-32cbc05f36f9","email":"teste.1770407690238.7458.31@loadtest.com","email_verified":true}', 'email', 'c1d16927-e0cf-41c2-87a3-32cbc05f36f9', '2026-02-06T22:55:33.000Z', '2026-02-06T22:55:33.000Z', '2026-02-06T22:55:34.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 31', cpf = '10000000031', phone = '11900000031', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'c1d16927-e0cf-41c2-87a3-32cbc05f36f9';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = 'c1d16927-e0cf-41c2-87a3-32cbc05f36f9';

-- Teste Usuario 94 (teste.1770407690289.3187.94@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('1fdce766-d6fd-4887-a2bf-3eae9f7b815e', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690289.3187.94@loadtest.com', '', '2026-02-06T22:55:34.000Z', '2026-02-06T22:55:34.000Z', '2026-02-06T22:55:34.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 94"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('7f68fc4f-efed-466a-9146-5f3f84526ceb', '1fdce766-d6fd-4887-a2bf-3eae9f7b815e', '{"sub":"1fdce766-d6fd-4887-a2bf-3eae9f7b815e","email":"teste.1770407690289.3187.94@loadtest.com","email_verified":true}', 'email', '1fdce766-d6fd-4887-a2bf-3eae9f7b815e', '2026-02-06T22:55:34.000Z', '2026-02-06T22:55:34.000Z', '2026-02-06T22:55:34.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 94', cpf = '10000000094', phone = '11900000094', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '1fdce766-d6fd-4887-a2bf-3eae9f7b815e';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '1fdce766-d6fd-4887-a2bf-3eae9f7b815e';

-- Teste Usuario 95 (teste.1770407690290.3492.95@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('354cb10e-6fa3-4eb8-b8f8-b4e8141952bd', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690290.3492.95@loadtest.com', '', '2026-02-06T22:55:34.000Z', '2026-02-06T22:55:34.000Z', '2026-02-06T22:55:34.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 95"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('32bd22ac-78b6-4bf3-92cf-fc3f16400efa', '354cb10e-6fa3-4eb8-b8f8-b4e8141952bd', '{"sub":"354cb10e-6fa3-4eb8-b8f8-b4e8141952bd","email":"teste.1770407690290.3492.95@loadtest.com","email_verified":true}', 'email', '354cb10e-6fa3-4eb8-b8f8-b4e8141952bd', '2026-02-06T22:55:34.000Z', '2026-02-06T22:55:34.000Z', '2026-02-06T22:55:35.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 95', cpf = '10000000095', phone = '11900000095', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '354cb10e-6fa3-4eb8-b8f8-b4e8141952bd';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '354cb10e-6fa3-4eb8-b8f8-b4e8141952bd';

-- Teste Usuario 42 (teste.1770407690247.4761.42@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('00aa84e3-33aa-47e1-8526-9f4971734297', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690247.4761.42@loadtest.com', '', '2026-02-06T22:55:35.000Z', '2026-02-06T22:55:35.000Z', '2026-02-06T22:55:35.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 42"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('cc904aa4-38f8-4a30-aa0d-9fc11abeb9f8', '00aa84e3-33aa-47e1-8526-9f4971734297', '{"sub":"00aa84e3-33aa-47e1-8526-9f4971734297","email":"teste.1770407690247.4761.42@loadtest.com","email_verified":true}', 'email', '00aa84e3-33aa-47e1-8526-9f4971734297', '2026-02-06T22:55:35.000Z', '2026-02-06T22:55:35.000Z', '2026-02-06T22:55:35.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 42', cpf = '10000000042', phone = '11900000042', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '00aa84e3-33aa-47e1-8526-9f4971734297';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '00aa84e3-33aa-47e1-8526-9f4971734297';

-- Teste Usuario 96 (teste.1770407690290.8948.96@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('64ff43fd-e7e7-4cc1-aebc-e14da3723f93', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690290.8948.96@loadtest.com', '', '2026-02-06T22:55:35.000Z', '2026-02-06T22:55:35.000Z', '2026-02-06T22:55:35.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 96"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('18610c7f-b87c-472e-b9a9-768130e9d5e5', '64ff43fd-e7e7-4cc1-aebc-e14da3723f93', '{"sub":"64ff43fd-e7e7-4cc1-aebc-e14da3723f93","email":"teste.1770407690290.8948.96@loadtest.com","email_verified":true}', 'email', '64ff43fd-e7e7-4cc1-aebc-e14da3723f93', '2026-02-06T22:55:35.000Z', '2026-02-06T22:55:35.000Z', '2026-02-06T22:55:36.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 96', cpf = '10000000096', phone = '11900000096', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '64ff43fd-e7e7-4cc1-aebc-e14da3723f93';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '64ff43fd-e7e7-4cc1-aebc-e14da3723f93';

-- Teste Usuario 97 (teste.1770407690291.1591.97@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('52f82c7e-9cfa-4457-82bf-b986b2bc71f9', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690291.1591.97@loadtest.com', '', '2026-02-06T22:55:36.000Z', '2026-02-06T22:55:36.000Z', '2026-02-06T22:55:36.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 97"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('0a87aef9-28d6-4391-8d4d-d51539075d6f', '52f82c7e-9cfa-4457-82bf-b986b2bc71f9', '{"sub":"52f82c7e-9cfa-4457-82bf-b986b2bc71f9","email":"teste.1770407690291.1591.97@loadtest.com","email_verified":true}', 'email', '52f82c7e-9cfa-4457-82bf-b986b2bc71f9', '2026-02-06T22:55:36.000Z', '2026-02-06T22:55:36.000Z', '2026-02-06T22:55:36.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 97', cpf = '10000000097', phone = '11900000097', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '52f82c7e-9cfa-4457-82bf-b986b2bc71f9';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '52f82c7e-9cfa-4457-82bf-b986b2bc71f9';

-- Teste Usuario 63 (teste.1770407690264.6182.63@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('804a91db-8f10-4108-9190-535846fe3d47', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690264.6182.63@loadtest.com', '', '2026-02-06T22:55:36.000Z', '2026-02-06T22:55:36.000Z', '2026-02-06T22:55:36.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 63"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('0ff8aea5-63bf-47f4-93a9-72a68ee3648d', '804a91db-8f10-4108-9190-535846fe3d47', '{"sub":"804a91db-8f10-4108-9190-535846fe3d47","email":"teste.1770407690264.6182.63@loadtest.com","email_verified":true}', 'email', '804a91db-8f10-4108-9190-535846fe3d47', '2026-02-06T22:55:36.000Z', '2026-02-06T22:55:36.000Z', '2026-02-06T22:55:36.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 63', cpf = '10000000063', phone = '11900000063', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '804a91db-8f10-4108-9190-535846fe3d47';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '804a91db-8f10-4108-9190-535846fe3d47';

-- Teste Usuario 85 (teste.1770407690282.2169.85@loadtest.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('538ad959-b9bd-4fed-8fc4-c07e092a7ed6', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'teste.1770407690282.2169.85@loadtest.com', '', '2026-02-06T22:55:36.000Z', '2026-02-06T22:55:36.000Z', '2026-02-06T22:55:36.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Teste Usuario 85"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('1b0f3793-c74c-4119-8ce2-cfa4a6c16206', '538ad959-b9bd-4fed-8fc4-c07e092a7ed6', '{"sub":"538ad959-b9bd-4fed-8fc4-c07e092a7ed6","email":"teste.1770407690282.2169.85@loadtest.com","email_verified":true}', 'email', '538ad959-b9bd-4fed-8fc4-c07e092a7ed6', '2026-02-06T22:55:36.000Z', '2026-02-06T22:55:36.000Z', '2026-02-06T22:55:37.000Z');
UPDATE public.profiles SET name = 'Teste Usuario 85', cpf = '10000000085', phone = '11900000085', company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '538ad959-b9bd-4fed-8fc4-c07e092a7ed6';
UPDATE public.user_roles SET company_id = '5052b0d7-d4d3-45e3-9adc-9b62116731a5' WHERE user_id = '538ad959-b9bd-4fed-8fc4-c07e092a7ed6';

-- Roberta Cantareira Cezar  (rcantareira@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('2c38bccc-3d93-4a5b-a955-5470a18fa75a', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'rcantareira@gmail.com', '', '2026-02-07T18:26:33.000Z', '2026-02-07T18:26:33.000Z', '2026-02-07T18:26:33.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Roberta Cantareira Cezar "}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('9271afaf-b717-4873-9312-70c4cf81494b', '2c38bccc-3d93-4a5b-a955-5470a18fa75a', '{"sub":"2c38bccc-3d93-4a5b-a955-5470a18fa75a","email":"rcantareira@gmail.com","email_verified":true}', 'email', '2c38bccc-3d93-4a5b-a955-5470a18fa75a', '2026-02-07T18:26:33.000Z', '2026-02-07T18:26:33.000Z', '2026-02-07T18:26:34.000Z');
UPDATE public.profiles SET name = 'Roberta Cantareira Cezar ', cpf = '28760277807', phone = '11998066070', company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '2c38bccc-3d93-4a5b-a955-5470a18fa75a';
UPDATE public.user_roles SET company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '2c38bccc-3d93-4a5b-a955-5470a18fa75a';

-- Bruna Silva  (brunarbsemijoias@com.br) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('1908dfdf-af29-42cb-a795-06fb18b2c7ca', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'brunarbsemijoias@com.br', '', '2026-02-09T21:59:14.000Z', '2026-02-09T21:59:14.000Z', '2026-02-09T21:59:14.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Bruna Silva "}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('a66cf374-c6e2-45d8-bfa4-ca4ee5fd7ba3', '1908dfdf-af29-42cb-a795-06fb18b2c7ca', '{"sub":"1908dfdf-af29-42cb-a795-06fb18b2c7ca","email":"brunarbsemijoias@com.br","email_verified":true}', 'email', '1908dfdf-af29-42cb-a795-06fb18b2c7ca', '2026-02-09T21:59:14.000Z', '2026-02-09T21:59:14.000Z', '2026-02-09T21:59:14.000Z');
UPDATE public.profiles SET name = 'Bruna Silva ', cpf = '01551315670', phone = '31989795140', company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '1908dfdf-af29-42cb-a795-06fb18b2c7ca';
UPDATE public.user_roles SET company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '1908dfdf-af29-42cb-a795-06fb18b2c7ca';
