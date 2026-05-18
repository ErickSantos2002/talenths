-- ============================================
-- Talent-IA Migration - Part 3/8: Users 1-100 (batch 1/5)
-- Generated: 2026-02-13T20:29:31.260Z
-- EXECUTE IN ORDER: Part 3 of 8
-- ============================================

-- Buscar ID (operacoes@buscarid.com) | Role: master_admin
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('9d019c9c-379a-4f0a-a89f-8b91f7b9e2e7', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'operacoes@buscarid.com', '', '2025-11-07T21:26:33.000Z', '2025-11-07T21:26:33.000Z', '2026-02-06T22:15:53.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Buscar ID"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('32173b5b-486c-4f70-9290-2eaaf6fabd94', '9d019c9c-379a-4f0a-a89f-8b91f7b9e2e7', '{"sub":"9d019c9c-379a-4f0a-a89f-8b91f7b9e2e7","email":"operacoes@buscarid.com","email_verified":true}', 'email', '9d019c9c-379a-4f0a-a89f-8b91f7b9e2e7', '2025-11-07T21:26:33.000Z', '2026-02-06T22:15:53.000Z', '2026-02-06T22:15:52.000Z');
UPDATE public.profiles SET name = 'Buscar ID', company_id = '676787b8-c5ab-4211-a54d-7ed10769011e' WHERE user_id = '9d019c9c-379a-4f0a-a89f-8b91f7b9e2e7';
UPDATE public.user_roles SET role = 'master_admin'::public.app_role, company_id = '676787b8-c5ab-4211-a54d-7ed10769011e' WHERE user_id = '9d019c9c-379a-4f0a-a89f-8b91f7b9e2e7';

-- Rodrigo Normandia (rodrigonormandia@buscarid.com) | Role: master_admin
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('14a6bbd5-f9a2-4408-8624-469dcd8104e4', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'rodrigonormandia@buscarid.com', '', '2025-11-07T22:27:44.000Z', '2025-11-07T22:27:44.000Z', '2026-02-07T18:21:44.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Rodrigo Normandia"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('cc58d75a-962f-4e8d-b2b1-8328981e00c1', '14a6bbd5-f9a2-4408-8624-469dcd8104e4', '{"sub":"14a6bbd5-f9a2-4408-8624-469dcd8104e4","email":"rodrigonormandia@buscarid.com","email_verified":true}', 'email', '14a6bbd5-f9a2-4408-8624-469dcd8104e4', '2025-11-07T22:27:44.000Z', '2026-02-07T18:21:44.000Z', '2026-01-25T22:21:46.000Z');
UPDATE public.profiles SET name = 'Rodrigo Normandia', company_id = '676787b8-c5ab-4211-a54d-7ed10769011e', department_id = '5c64a5ed-d52e-4816-9623-0a93edfea173' WHERE user_id = '14a6bbd5-f9a2-4408-8624-469dcd8104e4';
UPDATE public.user_roles SET role = 'master_admin'::public.app_role, company_id = '676787b8-c5ab-4211-a54d-7ed10769011e' WHERE user_id = '14a6bbd5-f9a2-4408-8624-469dcd8104e4';

-- Kaw Bicalho (kaw@buscarid.com) | Role: master_admin
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('78935cf0-09da-4497-a05d-30843eb755f1', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'kaw@buscarid.com', '', '2025-11-07T22:28:11.000Z', '2025-11-07T22:28:11.000Z', '2026-01-25T19:59:48.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Kaw Bicalho"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('44b64127-211b-4f83-86a8-7dc26c775d68', '78935cf0-09da-4497-a05d-30843eb755f1', '{"sub":"78935cf0-09da-4497-a05d-30843eb755f1","email":"kaw@buscarid.com","email_verified":true}', 'email', '78935cf0-09da-4497-a05d-30843eb755f1', '2025-11-07T22:28:11.000Z', '2026-01-25T19:59:48.000Z', '2026-01-25T19:59:48.000Z');
UPDATE public.profiles SET name = 'Kaw Bicalho', company_id = '676787b8-c5ab-4211-a54d-7ed10769011e', department_id = '3198739e-7022-4088-a15f-070c268366f8' WHERE user_id = '78935cf0-09da-4497-a05d-30843eb755f1';
UPDATE public.user_roles SET role = 'master_admin'::public.app_role, company_id = '676787b8-c5ab-4211-a54d-7ed10769011e' WHERE user_id = '78935cf0-09da-4497-a05d-30843eb755f1';

-- Jussara Rodrigues (jussara@buscarid.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('f0a74317-11c4-4d07-a08d-a89fdb2f193f', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'jussara@buscarid.com', '', '2025-11-08T21:07:04.000Z', '2025-11-08T21:07:04.000Z', '2025-11-17T05:57:01.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Jussara Rodrigues"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('b173ffe7-d4a3-403c-b259-88b1bd1ac9b2', 'f0a74317-11c4-4d07-a08d-a89fdb2f193f', '{"sub":"f0a74317-11c4-4d07-a08d-a89fdb2f193f","email":"jussara@buscarid.com","email_verified":true}', 'email', 'f0a74317-11c4-4d07-a08d-a89fdb2f193f', '2025-11-08T21:07:04.000Z', '2025-11-17T05:57:01.000Z', '2025-11-08T21:36:24.000Z');
UPDATE public.profiles SET name = 'Jussara Rodrigues', company_id = 'f4a26bda-f920-40ec-a7f4-780fbd52eb7d' WHERE user_id = 'f0a74317-11c4-4d07-a08d-a89fdb2f193f';
UPDATE public.user_roles SET company_id = 'f4a26bda-f920-40ec-a7f4-780fbd52eb7d' WHERE user_id = 'f0a74317-11c4-4d07-a08d-a89fdb2f193f';

-- Flávia Nascimento (draflaviareumatobh@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('48910eb8-1d81-4c44-88e2-0ea61ed82c7c', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'draflaviareumatobh@gmail.com', '', '2025-11-08T21:51:02.000Z', '2025-11-08T21:51:02.000Z', '2025-11-17T05:57:01.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Flávia Nascimento"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('16ff42e3-50a2-4c8d-9cde-77af448de2a5', '48910eb8-1d81-4c44-88e2-0ea61ed82c7c', '{"sub":"48910eb8-1d81-4c44-88e2-0ea61ed82c7c","email":"draflaviareumatobh@gmail.com","email_verified":true}', 'email', '48910eb8-1d81-4c44-88e2-0ea61ed82c7c', '2025-11-08T21:51:02.000Z', '2025-11-17T05:57:01.000Z', '2025-11-08T21:55:24.000Z');
UPDATE public.profiles SET name = 'Flávia Nascimento', company_id = 'f4a26bda-f920-40ec-a7f4-780fbd52eb7d' WHERE user_id = '48910eb8-1d81-4c44-88e2-0ea61ed82c7c';
UPDATE public.user_roles SET company_id = 'f4a26bda-f920-40ec-a7f4-780fbd52eb7d' WHERE user_id = '48910eb8-1d81-4c44-88e2-0ea61ed82c7c';

-- Rodrigo Teixeira (rodrigo@sabecomo.com.br) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('df8aeccd-4309-4bcb-90b4-2eb2b6187667', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'rodrigo@sabecomo.com.br', '', '2025-11-08T21:59:35.000Z', '2025-11-08T21:59:35.000Z', '2025-11-17T05:57:01.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Rodrigo Teixeira"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('07dc8137-7f23-40d4-bb79-25571e40a18c', 'df8aeccd-4309-4bcb-90b4-2eb2b6187667', '{"sub":"df8aeccd-4309-4bcb-90b4-2eb2b6187667","email":"rodrigo@sabecomo.com.br","email_verified":true}', 'email', 'df8aeccd-4309-4bcb-90b4-2eb2b6187667', '2025-11-08T21:59:35.000Z', '2025-11-17T05:57:01.000Z', '2025-11-17T02:04:14.000Z');
UPDATE public.profiles SET name = 'Rodrigo Teixeira', company_id = 'f4a26bda-f920-40ec-a7f4-780fbd52eb7d' WHERE user_id = 'df8aeccd-4309-4bcb-90b4-2eb2b6187667';
UPDATE public.user_roles SET company_id = 'f4a26bda-f920-40ec-a7f4-780fbd52eb7d' WHERE user_id = 'df8aeccd-4309-4bcb-90b4-2eb2b6187667';

-- Nicholson Pimentel (nicholsongp@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('a8ee64e4-e4a7-44da-b4ca-75e5be82dbdd', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'nicholsongp@gmail.com', '', '2025-11-11T19:55:35.000Z', '2025-11-11T19:55:35.000Z', '2025-11-17T05:57:01.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Nicholson Pimentel"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('65eeaf92-d08d-4876-b142-2e897b73baa3', 'a8ee64e4-e4a7-44da-b4ca-75e5be82dbdd', '{"sub":"a8ee64e4-e4a7-44da-b4ca-75e5be82dbdd","email":"nicholsongp@gmail.com","email_verified":true}', 'email', 'a8ee64e4-e4a7-44da-b4ca-75e5be82dbdd', '2025-11-11T19:55:35.000Z', '2025-11-17T05:57:01.000Z', '2025-11-11T20:22:27.000Z');
UPDATE public.profiles SET name = 'Nicholson Pimentel', company_id = 'f4a26bda-f920-40ec-a7f4-780fbd52eb7d' WHERE user_id = 'a8ee64e4-e4a7-44da-b4ca-75e5be82dbdd';
UPDATE public.user_roles SET company_id = 'f4a26bda-f920-40ec-a7f4-780fbd52eb7d' WHERE user_id = 'a8ee64e4-e4a7-44da-b4ca-75e5be82dbdd';

-- Andre Wandenkolken Afonso (andrewafonso@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('ae36418a-7ba3-48e5-953e-aec4a37c14a5', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'andrewafonso@gmail.com', '', '2025-11-12T02:43:15.000Z', '2025-11-12T02:43:15.000Z', '2026-01-14T19:58:20.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Andre Wandenkolken Afonso"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('4c906f9d-26e4-4c67-8388-8ecd1d55ea09', 'ae36418a-7ba3-48e5-953e-aec4a37c14a5', '{"sub":"ae36418a-7ba3-48e5-953e-aec4a37c14a5","email":"andrewafonso@gmail.com","email_verified":true}', 'email', 'ae36418a-7ba3-48e5-953e-aec4a37c14a5', '2025-11-12T02:43:15.000Z', '2026-01-14T19:58:20.000Z', '2026-01-14T19:58:21.000Z');
UPDATE public.profiles SET name = 'Andre Wandenkolken Afonso', company_id = 'edea5e96-20ea-40a8-8cb8-0988cd74869c' WHERE user_id = 'ae36418a-7ba3-48e5-953e-aec4a37c14a5';
UPDATE public.user_roles SET company_id = 'edea5e96-20ea-40a8-8cb8-0988cd74869c' WHERE user_id = 'ae36418a-7ba3-48e5-953e-aec4a37c14a5';

-- Anie Karenina (anie.karenina@buffalodigital.com.br) | Role: company_admin
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('be03a20e-1cfd-453e-8c3e-18cceda2ba6a', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'anie.karenina@buffalodigital.com.br', '', '2025-11-12T02:43:29.000Z', '2025-11-12T02:43:29.000Z', '2026-01-30T21:55:53.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Anie Karenina"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('66d9ff2f-73d3-4ddc-8e61-4228fed730ae', 'be03a20e-1cfd-453e-8c3e-18cceda2ba6a', '{"sub":"be03a20e-1cfd-453e-8c3e-18cceda2ba6a","email":"anie.karenina@buffalodigital.com.br","email_verified":true}', 'email', 'be03a20e-1cfd-453e-8c3e-18cceda2ba6a', '2025-11-12T02:43:29.000Z', '2026-01-30T21:55:53.000Z', '2026-01-30T21:55:53.000Z');
UPDATE public.profiles SET name = 'Anie Karenina', company_id = 'e7e206de-3ae7-46a9-a48a-4ae882ee2a18', department_id = '65b7220c-3bd4-4b1f-9186-310a7641e0b9' WHERE user_id = 'be03a20e-1cfd-453e-8c3e-18cceda2ba6a';
UPDATE public.user_roles SET role = 'company_admin'::public.app_role, company_id = 'e7e206de-3ae7-46a9-a48a-4ae882ee2a18' WHERE user_id = 'be03a20e-1cfd-453e-8c3e-18cceda2ba6a';

-- Fernando Jin (fernandojin@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('3e5657e3-bba6-44e2-995a-2f49416dbdfd', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'fernandojin@gmail.com', '', '2025-11-12T02:43:37.000Z', '2025-11-12T02:43:37.000Z', '2025-11-17T05:57:01.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Fernando Jin"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('ec18d687-e027-431b-a172-1b5e9be272c5', '3e5657e3-bba6-44e2-995a-2f49416dbdfd', '{"sub":"3e5657e3-bba6-44e2-995a-2f49416dbdfd","email":"fernandojin@gmail.com","email_verified":true}', 'email', '3e5657e3-bba6-44e2-995a-2f49416dbdfd', '2025-11-12T02:43:37.000Z', '2025-11-17T05:57:01.000Z', '2025-11-12T12:31:06.000Z');
UPDATE public.profiles SET name = 'Fernando Jin', company_id = 'f4a26bda-f920-40ec-a7f4-780fbd52eb7d' WHERE user_id = '3e5657e3-bba6-44e2-995a-2f49416dbdfd';
UPDATE public.user_roles SET company_id = 'f4a26bda-f920-40ec-a7f4-780fbd52eb7d' WHERE user_id = '3e5657e3-bba6-44e2-995a-2f49416dbdfd';

-- Daniel Gaia (danielgaia13@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('2bcf02b8-f3ff-4bfb-8122-0a07948cc674', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'danielgaia13@gmail.com', '', '2025-11-12T03:02:43.000Z', '2025-11-12T03:02:43.000Z', '2026-01-16T17:29:20.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Daniel Gaia"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('f196ff4c-1517-42e1-9d4c-6b05f50e1cec', '2bcf02b8-f3ff-4bfb-8122-0a07948cc674', '{"sub":"2bcf02b8-f3ff-4bfb-8122-0a07948cc674","email":"danielgaia13@gmail.com","email_verified":true}', 'email', '2bcf02b8-f3ff-4bfb-8122-0a07948cc674', '2025-11-12T03:02:43.000Z', '2026-01-16T17:29:20.000Z', '2026-01-16T17:29:21.000Z');
UPDATE public.profiles SET name = 'Daniel Gaia', company_id = 'f4a26bda-f920-40ec-a7f4-780fbd52eb7d' WHERE user_id = '2bcf02b8-f3ff-4bfb-8122-0a07948cc674';
UPDATE public.user_roles SET company_id = 'f4a26bda-f920-40ec-a7f4-780fbd52eb7d' WHERE user_id = '2bcf02b8-f3ff-4bfb-8122-0a07948cc674';

-- Filipe Lopes (filipejclopes@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('7bb35be6-ff86-47f6-9374-19b10f10a0cc', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'filipejclopes@gmail.com', '', '2025-11-12T15:26:04.000Z', '2025-11-12T15:26:04.000Z', '2025-11-17T05:57:01.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Filipe Lopes"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('cff2297b-75ee-425b-a4a6-4be6aa8e006b', '7bb35be6-ff86-47f6-9374-19b10f10a0cc', '{"sub":"7bb35be6-ff86-47f6-9374-19b10f10a0cc","email":"filipejclopes@gmail.com","email_verified":true}', 'email', '7bb35be6-ff86-47f6-9374-19b10f10a0cc', '2025-11-12T15:26:04.000Z', '2025-11-17T05:57:01.000Z', '2025-11-12T15:39:49.000Z');
UPDATE public.profiles SET name = 'Filipe Lopes', company_id = 'f4a26bda-f920-40ec-a7f4-780fbd52eb7d' WHERE user_id = '7bb35be6-ff86-47f6-9374-19b10f10a0cc';
UPDATE public.user_roles SET company_id = 'f4a26bda-f920-40ec-a7f4-780fbd52eb7d' WHERE user_id = '7bb35be6-ff86-47f6-9374-19b10f10a0cc';

-- Surama Carvalho (sura.carvalho@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('1d69552d-0f08-4107-ae92-ea4e2288b55d', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'sura.carvalho@gmail.com', '', '2025-11-12T15:27:11.000Z', '2025-11-12T15:27:11.000Z', '2025-11-17T05:57:01.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Surama Carvalho"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('311857df-63a9-45fa-b82d-486665941b9e', '1d69552d-0f08-4107-ae92-ea4e2288b55d', '{"sub":"1d69552d-0f08-4107-ae92-ea4e2288b55d","email":"sura.carvalho@gmail.com","email_verified":true}', 'email', '1d69552d-0f08-4107-ae92-ea4e2288b55d', '2025-11-12T15:27:11.000Z', '2025-11-17T05:57:01.000Z', '2025-11-12T15:27:13.000Z');
UPDATE public.profiles SET name = 'Surama Carvalho', company_id = 'f4a26bda-f920-40ec-a7f4-780fbd52eb7d' WHERE user_id = '1d69552d-0f08-4107-ae92-ea4e2288b55d';
UPDATE public.user_roles SET company_id = 'f4a26bda-f920-40ec-a7f4-780fbd52eb7d' WHERE user_id = '1d69552d-0f08-4107-ae92-ea4e2288b55d';

-- Renato Lopes (renatolopesevolve@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('60fb4b64-d278-4332-be48-b626b2fb9a06', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'renatolopesevolve@gmail.com', '', '2025-11-14T20:00:29.000Z', '2025-11-14T20:00:29.000Z', '2025-12-05T19:36:23.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Renato Lopes"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('d438319d-97e4-4dd5-9c83-8a96a9e8e6a6', '60fb4b64-d278-4332-be48-b626b2fb9a06', '{"sub":"60fb4b64-d278-4332-be48-b626b2fb9a06","email":"renatolopesevolve@gmail.com","email_verified":true}', 'email', '60fb4b64-d278-4332-be48-b626b2fb9a06', '2025-11-14T20:00:29.000Z', '2025-12-05T19:36:23.000Z', '2025-12-05T19:36:22.000Z');
UPDATE public.profiles SET name = 'Renato Lopes', company_id = 'f4a26bda-f920-40ec-a7f4-780fbd52eb7d' WHERE user_id = '60fb4b64-d278-4332-be48-b626b2fb9a06';
UPDATE public.user_roles SET company_id = 'f4a26bda-f920-40ec-a7f4-780fbd52eb7d' WHERE user_id = '60fb4b64-d278-4332-be48-b626b2fb9a06';

-- Letícia Morelli (leticia@maxupconsultoria.com.br) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('9cceadf6-af6f-4e48-8b69-3ad2b2528b74', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'leticia@maxupconsultoria.com.br', '', '2025-11-15T21:15:41.000Z', '2025-11-15T21:15:41.000Z', '2025-12-02T23:44:27.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Letícia Morelli"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('522044c8-433a-4219-a994-ab71df18aca2', '9cceadf6-af6f-4e48-8b69-3ad2b2528b74', '{"sub":"9cceadf6-af6f-4e48-8b69-3ad2b2528b74","email":"leticia@maxupconsultoria.com.br","email_verified":true}', 'email', '9cceadf6-af6f-4e48-8b69-3ad2b2528b74', '2025-11-15T21:15:41.000Z', '2025-12-02T23:44:27.000Z', '2025-12-02T23:44:28.000Z');
UPDATE public.profiles SET name = 'Letícia Morelli', company_id = 'eacd7080-2b72-4439-ad12-3db8ce76678d' WHERE user_id = '9cceadf6-af6f-4e48-8b69-3ad2b2528b74';
UPDATE public.user_roles SET company_id = 'eacd7080-2b72-4439-ad12-3db8ce76678d' WHERE user_id = '9cceadf6-af6f-4e48-8b69-3ad2b2528b74';

-- Roberta Caldas Simões (rbetasim@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('98b52c1d-caa9-4ea4-a065-cd40c8a1e2d3', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'rbetasim@gmail.com', '', '2025-11-15T21:15:43.000Z', '2025-11-15T21:15:43.000Z', '2025-11-17T05:57:01.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Roberta Caldas Simões"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('00ced961-d486-42a0-8c34-320023299ce1', '98b52c1d-caa9-4ea4-a065-cd40c8a1e2d3', '{"sub":"98b52c1d-caa9-4ea4-a065-cd40c8a1e2d3","email":"rbetasim@gmail.com","email_verified":true}', 'email', '98b52c1d-caa9-4ea4-a065-cd40c8a1e2d3', '2025-11-15T21:15:43.000Z', '2025-11-17T05:57:01.000Z', '2025-11-15T21:46:28.000Z');
UPDATE public.profiles SET name = 'Roberta Caldas Simões', company_id = 'f4a26bda-f920-40ec-a7f4-780fbd52eb7d' WHERE user_id = '98b52c1d-caa9-4ea4-a065-cd40c8a1e2d3';
UPDATE public.user_roles SET company_id = 'f4a26bda-f920-40ec-a7f4-780fbd52eb7d' WHERE user_id = '98b52c1d-caa9-4ea4-a065-cd40c8a1e2d3';

-- Eva Lariss (evalarissa157@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('2fb9d4c5-9082-46a6-937d-f3a5e4303556', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'evalarissa157@gmail.com', '', '2025-11-15T21:15:48.000Z', '2025-11-15T21:15:48.000Z', '2025-11-17T05:57:01.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Eva Lariss"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('f5537b92-176f-4371-ba43-91674199fcc2', '2fb9d4c5-9082-46a6-937d-f3a5e4303556', '{"sub":"2fb9d4c5-9082-46a6-937d-f3a5e4303556","email":"evalarissa157@gmail.com","email_verified":true}', 'email', '2fb9d4c5-9082-46a6-937d-f3a5e4303556', '2025-11-15T21:15:48.000Z', '2025-11-17T05:57:01.000Z', '2025-11-15T23:13:13.000Z');
UPDATE public.profiles SET name = 'Eva Lariss', company_id = 'f4a26bda-f920-40ec-a7f4-780fbd52eb7d' WHERE user_id = '2fb9d4c5-9082-46a6-937d-f3a5e4303556';
UPDATE public.user_roles SET company_id = 'f4a26bda-f920-40ec-a7f4-780fbd52eb7d' WHERE user_id = '2fb9d4c5-9082-46a6-937d-f3a5e4303556';

-- LAURA DOMINGUES (lalacorrea@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('8d263ef6-6a6a-4e52-9ede-b71984246cab', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'lalacorrea@gmail.com', '', '2025-11-15T21:15:57.000Z', '2025-11-15T21:15:57.000Z', '2025-11-17T05:57:01.000Z', '{"provider":"email","providers":["email"]}', '{"name":"LAURA DOMINGUES"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('09b3e899-393e-4241-8dc2-131c31336bb2', '8d263ef6-6a6a-4e52-9ede-b71984246cab', '{"sub":"8d263ef6-6a6a-4e52-9ede-b71984246cab","email":"lalacorrea@gmail.com","email_verified":true}', 'email', '8d263ef6-6a6a-4e52-9ede-b71984246cab', '2025-11-15T21:15:57.000Z', '2025-11-17T05:57:01.000Z', '2025-11-15T23:12:02.000Z');
UPDATE public.profiles SET name = 'LAURA DOMINGUES', company_id = 'f4a26bda-f920-40ec-a7f4-780fbd52eb7d' WHERE user_id = '8d263ef6-6a6a-4e52-9ede-b71984246cab';
UPDATE public.user_roles SET company_id = 'f4a26bda-f920-40ec-a7f4-780fbd52eb7d' WHERE user_id = '8d263ef6-6a6a-4e52-9ede-b71984246cab';

-- Henrique Hamerski (henriquehamerski@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('4ab84bdb-d826-4d54-a6ad-552bd52fa96b', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'henriquehamerski@gmail.com', '', '2025-11-15T21:16:06.000Z', '2025-11-15T21:16:06.000Z', '2025-11-17T05:57:01.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Henrique Hamerski"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('29ab80db-44ac-41d7-94db-296df1bbb975', '4ab84bdb-d826-4d54-a6ad-552bd52fa96b', '{"sub":"4ab84bdb-d826-4d54-a6ad-552bd52fa96b","email":"henriquehamerski@gmail.com","email_verified":true}', 'email', '4ab84bdb-d826-4d54-a6ad-552bd52fa96b', '2025-11-15T21:16:06.000Z', '2025-11-17T05:57:01.000Z', '2025-11-15T21:29:33.000Z');
UPDATE public.profiles SET name = 'Henrique Hamerski', company_id = 'f4a26bda-f920-40ec-a7f4-780fbd52eb7d' WHERE user_id = '4ab84bdb-d826-4d54-a6ad-552bd52fa96b';
UPDATE public.user_roles SET company_id = 'f4a26bda-f920-40ec-a7f4-780fbd52eb7d' WHERE user_id = '4ab84bdb-d826-4d54-a6ad-552bd52fa96b';

-- Leonardo Rotela (leodavidrotela91@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('229d1d84-a78a-4f07-8560-96ac8d081c78', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'leodavidrotela91@gmail.com', '', '2025-11-15T21:16:11.000Z', '2025-11-15T21:16:11.000Z', '2025-11-17T05:57:01.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Leonardo Rotela"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('ddc438b2-e51c-4e6a-89f9-e21cfb285937', '229d1d84-a78a-4f07-8560-96ac8d081c78', '{"sub":"229d1d84-a78a-4f07-8560-96ac8d081c78","email":"leodavidrotela91@gmail.com","email_verified":true}', 'email', '229d1d84-a78a-4f07-8560-96ac8d081c78', '2025-11-15T21:16:11.000Z', '2025-11-17T05:57:01.000Z', '2025-11-15T22:51:22.000Z');
UPDATE public.profiles SET name = 'Leonardo Rotela', company_id = 'f4a26bda-f920-40ec-a7f4-780fbd52eb7d' WHERE user_id = '229d1d84-a78a-4f07-8560-96ac8d081c78';
UPDATE public.user_roles SET company_id = 'f4a26bda-f920-40ec-a7f4-780fbd52eb7d' WHERE user_id = '229d1d84-a78a-4f07-8560-96ac8d081c78';

-- Júlia Maia (maia.jpm@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('f1f1a018-6743-494c-a69b-851d255bbcdc', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'maia.jpm@gmail.com', '', '2025-11-15T21:16:12.000Z', '2025-11-15T21:16:12.000Z', '2025-11-17T05:57:01.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Júlia Maia"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('e43a1afb-cce0-4209-be3d-4519180806f4', 'f1f1a018-6743-494c-a69b-851d255bbcdc', '{"sub":"f1f1a018-6743-494c-a69b-851d255bbcdc","email":"maia.jpm@gmail.com","email_verified":true}', 'email', 'f1f1a018-6743-494c-a69b-851d255bbcdc', '2025-11-15T21:16:12.000Z', '2025-11-17T05:57:01.000Z', '2025-11-15T22:58:58.000Z');
UPDATE public.profiles SET name = 'Júlia Maia', company_id = 'f4a26bda-f920-40ec-a7f4-780fbd52eb7d' WHERE user_id = 'f1f1a018-6743-494c-a69b-851d255bbcdc';
UPDATE public.user_roles SET company_id = 'f4a26bda-f920-40ec-a7f4-780fbd52eb7d' WHERE user_id = 'f1f1a018-6743-494c-a69b-851d255bbcdc';

-- Dayane Sousa (dayane@maxupconsultoria.com.br) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('bc7f81f9-65e5-42fe-8569-09b0714ccc26', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'dayane@maxupconsultoria.com.br', '', '2025-11-15T21:16:13.000Z', '2025-11-15T21:16:13.000Z', '2025-11-17T05:57:01.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Dayane Sousa"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('241af152-eb91-42c4-8d5f-928b3236aff5', 'bc7f81f9-65e5-42fe-8569-09b0714ccc26', '{"sub":"bc7f81f9-65e5-42fe-8569-09b0714ccc26","email":"dayane@maxupconsultoria.com.br","email_verified":true}', 'email', 'bc7f81f9-65e5-42fe-8569-09b0714ccc26', '2025-11-15T21:16:13.000Z', '2025-11-17T05:57:01.000Z', '2025-11-15T21:26:00.000Z');
UPDATE public.profiles SET name = 'Dayane Sousa', company_id = 'f4a26bda-f920-40ec-a7f4-780fbd52eb7d' WHERE user_id = 'bc7f81f9-65e5-42fe-8569-09b0714ccc26';
UPDATE public.user_roles SET company_id = 'f4a26bda-f920-40ec-a7f4-780fbd52eb7d' WHERE user_id = 'bc7f81f9-65e5-42fe-8569-09b0714ccc26';

-- Christiano Soares (christianobsr@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('e9e7e896-3dff-4775-9dab-65ed42b115f9', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'christianobsr@gmail.com', '', '2025-11-15T21:16:16.000Z', '2025-11-15T21:16:16.000Z', '2026-01-28T16:09:54.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Christiano Soares"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('a06fd546-14b2-487f-87f6-6e4fd9fc2bc2', 'e9e7e896-3dff-4775-9dab-65ed42b115f9', '{"sub":"e9e7e896-3dff-4775-9dab-65ed42b115f9","email":"christianobsr@gmail.com","email_verified":true}', 'email', 'e9e7e896-3dff-4775-9dab-65ed42b115f9', '2025-11-15T21:16:16.000Z', '2026-01-28T16:09:54.000Z', '2026-01-28T16:09:54.000Z');
UPDATE public.profiles SET name = 'Christiano Soares', company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = 'e9e7e896-3dff-4775-9dab-65ed42b115f9';
UPDATE public.user_roles SET company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = 'e9e7e896-3dff-4775-9dab-65ed42b115f9';

-- Gabriel Andrade (andradegoval2013@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('ee9b77d5-95ec-4aff-a757-6166d2b2a1e5', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'andradegoval2013@gmail.com', '', '2025-11-15T21:16:33.000Z', '2025-11-15T21:16:33.000Z', '2025-11-17T05:57:01.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Gabriel Andrade"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('3bcf5e50-56a9-42be-b16e-cec86051a2e0', 'ee9b77d5-95ec-4aff-a757-6166d2b2a1e5', '{"sub":"ee9b77d5-95ec-4aff-a757-6166d2b2a1e5","email":"andradegoval2013@gmail.com","email_verified":true}', 'email', 'ee9b77d5-95ec-4aff-a757-6166d2b2a1e5', '2025-11-15T21:16:33.000Z', '2025-11-17T05:57:01.000Z', '2025-11-15T22:12:22.000Z');
UPDATE public.profiles SET name = 'Gabriel Andrade', company_id = 'f4a26bda-f920-40ec-a7f4-780fbd52eb7d' WHERE user_id = 'ee9b77d5-95ec-4aff-a757-6166d2b2a1e5';
UPDATE public.user_roles SET company_id = 'f4a26bda-f920-40ec-a7f4-780fbd52eb7d' WHERE user_id = 'ee9b77d5-95ec-4aff-a757-6166d2b2a1e5';

-- Marcos Augusto Cândido (maugustocand@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('6d7dc871-fc6f-44cb-ba5f-6a560bb93c4e', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'maugustocand@gmail.com', '', '2025-11-15T21:16:38.000Z', '2025-11-15T21:16:38.000Z', '2025-11-17T05:57:01.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Marcos Augusto Cândido"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('7e37152f-272e-40fb-b88d-a3ea1c242f2b', '6d7dc871-fc6f-44cb-ba5f-6a560bb93c4e', '{"sub":"6d7dc871-fc6f-44cb-ba5f-6a560bb93c4e","email":"maugustocand@gmail.com","email_verified":true}', 'email', '6d7dc871-fc6f-44cb-ba5f-6a560bb93c4e', '2025-11-15T21:16:38.000Z', '2025-11-17T05:57:01.000Z', '2025-11-15T21:34:28.000Z');
UPDATE public.profiles SET name = 'Marcos Augusto Cândido', company_id = 'f4a26bda-f920-40ec-a7f4-780fbd52eb7d' WHERE user_id = '6d7dc871-fc6f-44cb-ba5f-6a560bb93c4e';
UPDATE public.user_roles SET company_id = 'f4a26bda-f920-40ec-a7f4-780fbd52eb7d' WHERE user_id = '6d7dc871-fc6f-44cb-ba5f-6a560bb93c4e';

-- Setor Financeiro Albanez e Maia Advogados (raquel@albanezemaia.adv.br) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('73512cc1-3f8f-4ef0-990a-554c6f3eea33', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'raquel@albanezemaia.adv.br', '', '2025-11-15T21:28:55.000Z', '2025-11-15T21:28:55.000Z', '2025-11-17T05:57:01.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Setor Financeiro Albanez e Maia Advogados"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('e52aa9f7-6289-49a3-8346-362e13320e54', '73512cc1-3f8f-4ef0-990a-554c6f3eea33', '{"sub":"73512cc1-3f8f-4ef0-990a-554c6f3eea33","email":"raquel@albanezemaia.adv.br","email_verified":true}', 'email', '73512cc1-3f8f-4ef0-990a-554c6f3eea33', '2025-11-15T21:28:55.000Z', '2025-11-17T05:57:01.000Z', '2025-11-15T22:41:40.000Z');
UPDATE public.profiles SET name = 'Setor Financeiro Albanez e Maia Advogados', company_id = 'f4a26bda-f920-40ec-a7f4-780fbd52eb7d' WHERE user_id = '73512cc1-3f8f-4ef0-990a-554c6f3eea33';
UPDATE public.user_roles SET company_id = 'f4a26bda-f920-40ec-a7f4-780fbd52eb7d' WHERE user_id = '73512cc1-3f8f-4ef0-990a-554c6f3eea33';

-- Francis Angeli (francis@maxupconsultoria.com.br) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('4e933eb7-9445-47d0-b0aa-63648fd036a5', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'francis@maxupconsultoria.com.br', '', '2025-11-15T22:23:49.000Z', '2025-11-15T22:23:49.000Z', '2025-11-17T05:49:42.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Francis Angeli"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('d8aa2789-3575-4703-85d4-0e97c2249f29', '4e933eb7-9445-47d0-b0aa-63648fd036a5', '{"sub":"4e933eb7-9445-47d0-b0aa-63648fd036a5","email":"francis@maxupconsultoria.com.br","email_verified":true}', 'email', '4e933eb7-9445-47d0-b0aa-63648fd036a5', '2025-11-15T22:23:49.000Z', '2025-11-17T05:49:42.000Z', '2025-11-15T22:24:50.000Z');
UPDATE public.profiles SET name = 'Francis Angeli', company_id = 'f4a26bda-f920-40ec-a7f4-780fbd52eb7d' WHERE user_id = '4e933eb7-9445-47d0-b0aa-63648fd036a5';
UPDATE public.user_roles SET company_id = 'f4a26bda-f920-40ec-a7f4-780fbd52eb7d' WHERE user_id = '4e933eb7-9445-47d0-b0aa-63648fd036a5';

-- Admin Teste (admin@teste.com) | Role: company_admin
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('f764438f-b19d-4cc8-9a02-17beccafc201', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'admin@teste.com', '', '2025-11-16T21:58:13.000Z', '2025-11-16T21:58:13.000Z', '2025-11-16T21:58:13.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Admin Teste"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('96552c61-f619-44c2-850d-493ffdd5746a', 'f764438f-b19d-4cc8-9a02-17beccafc201', '{"sub":"f764438f-b19d-4cc8-9a02-17beccafc201","email":"admin@teste.com","email_verified":true}', 'email', 'f764438f-b19d-4cc8-9a02-17beccafc201', '2025-11-16T21:58:13.000Z', '2025-11-16T21:58:13.000Z', '2025-11-16T21:58:13.000Z');
UPDATE public.profiles SET name = 'Admin Teste', cpf = '000.000.000-00', phone = '(00) 00000-0000', company_id = 'f4a26bda-f920-40ec-a7f4-780fbd52eb7d' WHERE user_id = 'f764438f-b19d-4cc8-9a02-17beccafc201';
UPDATE public.user_roles SET role = 'company_admin'::public.app_role, company_id = 'f4a26bda-f920-40ec-a7f4-780fbd52eb7d' WHERE user_id = 'f764438f-b19d-4cc8-9a02-17beccafc201';

-- Ana Carolina Frescurato da Silva (carol@buscarid.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('e011641c-7fff-4930-955d-a94c2b03a826', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'carol@buscarid.com', '', '2025-11-17T17:40:37.000Z', '2025-11-17T17:40:37.000Z', '2025-11-17T17:40:37.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Ana Carolina Frescurato da Silva"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('9d886f21-45a5-4599-ba59-42cf15be3708', 'e011641c-7fff-4930-955d-a94c2b03a826', '{"sub":"e011641c-7fff-4930-955d-a94c2b03a826","email":"carol@buscarid.com","email_verified":true}', 'email', 'e011641c-7fff-4930-955d-a94c2b03a826', '2025-11-17T17:40:37.000Z', '2025-11-17T17:40:37.000Z', '2025-11-17T17:40:38.000Z');
UPDATE public.profiles SET name = 'Ana Carolina Frescurato da Silva', cpf = '13860554689', phone = '31994419120', company_id = '676787b8-c5ab-4211-a54d-7ed10769011e', department_id = 'f0714258-92b7-41ba-b62f-762806c1d8ad' WHERE user_id = 'e011641c-7fff-4930-955d-a94c2b03a826';
UPDATE public.user_roles SET company_id = '676787b8-c5ab-4211-a54d-7ed10769011e' WHERE user_id = 'e011641c-7fff-4930-955d-a94c2b03a826';

-- Rodrigo Nascimento (rodrigo@buscarid.com) | Role: master_admin
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('a81ca3b8-39e3-4990-b938-8c382601afcb', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'rodrigo@buscarid.com', '', '2025-11-18T02:21:31.000Z', '2025-11-18T02:21:31.000Z', '2026-01-26T02:49:37.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Rodrigo Nascimento"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('2aa61295-fe1d-469f-a733-4de8b829edf9', 'a81ca3b8-39e3-4990-b938-8c382601afcb', '{"sub":"a81ca3b8-39e3-4990-b938-8c382601afcb","email":"rodrigo@buscarid.com","email_verified":true}', 'email', 'a81ca3b8-39e3-4990-b938-8c382601afcb', '2025-11-18T02:21:31.000Z', '2026-01-26T02:49:37.000Z', '2026-01-26T02:49:37.000Z');
UPDATE public.profiles SET name = 'Rodrigo Nascimento', company_id = '676787b8-c5ab-4211-a54d-7ed10769011e' WHERE user_id = 'a81ca3b8-39e3-4990-b938-8c382601afcb';
UPDATE public.user_roles SET role = 'master_admin'::public.app_role, company_id = '676787b8-c5ab-4211-a54d-7ed10769011e' WHERE user_id = 'a81ca3b8-39e3-4990-b938-8c382601afcb';

-- Eduardo Ponce (duponce.mcc@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('658a693e-c356-4381-8d2a-8105b92c912a', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'duponce.mcc@gmail.com', '', '2025-11-21T00:10:40.000Z', '2025-11-21T00:10:40.000Z', '2025-11-21T00:14:41.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Eduardo Ponce"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('11d86f29-29a7-42e5-b389-638b992c1cc6', '658a693e-c356-4381-8d2a-8105b92c912a', '{"sub":"658a693e-c356-4381-8d2a-8105b92c912a","email":"duponce.mcc@gmail.com","email_verified":true}', 'email', '658a693e-c356-4381-8d2a-8105b92c912a', '2025-11-21T00:10:40.000Z', '2025-11-21T00:14:41.000Z', '2025-11-21T00:14:42.000Z');
UPDATE public.profiles SET name = 'Eduardo Ponce', cpf = '00147107652', phone = '31984301334', company_id = '3a40ee54-e122-47b8-bd81-0b3998e98d04' WHERE user_id = '658a693e-c356-4381-8d2a-8105b92c912a';
UPDATE public.user_roles SET company_id = '3a40ee54-e122-47b8-bd81-0b3998e98d04' WHERE user_id = '658a693e-c356-4381-8d2a-8105b92c912a';

-- Lucas de Paulo Chaves (lukedepaulo@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('f36966f7-bca7-45a7-95bf-7323a53b82a7', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'lukedepaulo@gmail.com', '', '2025-12-02T23:17:16.000Z', '2025-12-02T23:17:16.000Z', '2025-12-14T02:12:33.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Lucas de Paulo Chaves"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('6c493cb4-f7bf-464d-b3e6-1a9458b8f7b3', 'f36966f7-bca7-45a7-95bf-7323a53b82a7', '{"sub":"f36966f7-bca7-45a7-95bf-7323a53b82a7","email":"lukedepaulo@gmail.com","email_verified":true}', 'email', 'f36966f7-bca7-45a7-95bf-7323a53b82a7', '2025-12-02T23:17:16.000Z', '2025-12-14T02:12:33.000Z', '2025-12-14T02:12:32.000Z');
UPDATE public.profiles SET name = 'Lucas de Paulo Chaves', cpf = '11247430650', phone = '31984738582', company_id = 'eacd7080-2b72-4439-ad12-3db8ce76678d' WHERE user_id = 'f36966f7-bca7-45a7-95bf-7323a53b82a7';
UPDATE public.user_roles SET company_id = 'eacd7080-2b72-4439-ad12-3db8ce76678d' WHERE user_id = 'f36966f7-bca7-45a7-95bf-7323a53b82a7';

-- Jéssica Lisboa Maia (jessica.maia@fundacaocdlbh.org.br) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('dfa11ca2-9859-4aea-8e5d-4a3bd0defb8a', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'jessica.maia@fundacaocdlbh.org.br', '', '2025-12-02T23:17:18.000Z', '2025-12-02T23:17:18.000Z', '2025-12-02T23:47:37.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Jéssica Lisboa Maia"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('d73fdccd-7bba-4fb5-804f-e17b05f8202a', 'dfa11ca2-9859-4aea-8e5d-4a3bd0defb8a', '{"sub":"dfa11ca2-9859-4aea-8e5d-4a3bd0defb8a","email":"jessica.maia@fundacaocdlbh.org.br","email_verified":true}', 'email', 'dfa11ca2-9859-4aea-8e5d-4a3bd0defb8a', '2025-12-02T23:17:18.000Z', '2025-12-02T23:47:37.000Z', '2025-12-02T23:47:38.000Z');
UPDATE public.profiles SET name = 'Jéssica Lisboa Maia', cpf = '12602572667', phone = '31991200680', company_id = 'eacd7080-2b72-4439-ad12-3db8ce76678d' WHERE user_id = 'dfa11ca2-9859-4aea-8e5d-4a3bd0defb8a';
UPDATE public.user_roles SET company_id = 'eacd7080-2b72-4439-ad12-3db8ce76678d' WHERE user_id = 'dfa11ca2-9859-4aea-8e5d-4a3bd0defb8a';

-- Guilherme Augusto de Melo Almeida (guilherme@ctrl.cnt.br) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('c926e1b3-4e1f-45bd-a4ac-bce02cc7bd73', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'guilherme@ctrl.cnt.br', '', '2025-12-02T23:17:19.000Z', '2025-12-02T23:17:19.000Z', '2025-12-02T23:52:49.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Guilherme Augusto de Melo Almeida"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('92b84761-aaaa-44f9-b623-ba1781581019', 'c926e1b3-4e1f-45bd-a4ac-bce02cc7bd73', '{"sub":"c926e1b3-4e1f-45bd-a4ac-bce02cc7bd73","email":"guilherme@ctrl.cnt.br","email_verified":true}', 'email', 'c926e1b3-4e1f-45bd-a4ac-bce02cc7bd73', '2025-12-02T23:17:19.000Z', '2025-12-02T23:52:49.000Z', '2025-12-02T23:52:50.000Z');
UPDATE public.profiles SET name = 'Guilherme Augusto de Melo Almeida', cpf = '08879350609', phone = '31999161871', company_id = 'eacd7080-2b72-4439-ad12-3db8ce76678d' WHERE user_id = 'c926e1b3-4e1f-45bd-a4ac-bce02cc7bd73';
UPDATE public.user_roles SET company_id = 'eacd7080-2b72-4439-ad12-3db8ce76678d' WHERE user_id = 'c926e1b3-4e1f-45bd-a4ac-bce02cc7bd73';

-- Renato Dias Godinho Junior (renato_godinho@hotmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('36895bb9-a269-4356-a926-826ecad68d3b', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'renato_godinho@hotmail.com', '', '2025-12-02T23:17:21.000Z', '2025-12-02T23:17:21.000Z', '2025-12-03T00:21:03.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Renato Dias Godinho Junior"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('a1534dff-19db-4d94-9b1d-ff9d25ffba89', '36895bb9-a269-4356-a926-826ecad68d3b', '{"sub":"36895bb9-a269-4356-a926-826ecad68d3b","email":"renato_godinho@hotmail.com","email_verified":true}', 'email', '36895bb9-a269-4356-a926-826ecad68d3b', '2025-12-02T23:17:21.000Z', '2025-12-03T00:21:03.000Z', '2025-12-03T00:21:04.000Z');
UPDATE public.profiles SET name = 'Renato Dias Godinho Junior', cpf = '23085040803', phone = '31988682245', company_id = 'eacd7080-2b72-4439-ad12-3db8ce76678d' WHERE user_id = '36895bb9-a269-4356-a926-826ecad68d3b';
UPDATE public.user_roles SET company_id = 'eacd7080-2b72-4439-ad12-3db8ce76678d' WHERE user_id = '36895bb9-a269-4356-a926-826ecad68d3b';

-- Augusto Cezar Oliveira Izac  (augustoizac@gmail.con) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('6132ed9b-313a-4646-9267-bf446af0f6f1', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'augustoizac@gmail.con', '', '2025-12-02T23:17:23.000Z', '2025-12-02T23:17:23.000Z', '2025-12-03T12:34:01.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Augusto Cezar Oliveira Izac "}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('240c1e58-b6db-426d-b650-08e11f24a86c', '6132ed9b-313a-4646-9267-bf446af0f6f1', '{"sub":"6132ed9b-313a-4646-9267-bf446af0f6f1","email":"augustoizac@gmail.con","email_verified":true}', 'email', '6132ed9b-313a-4646-9267-bf446af0f6f1', '2025-12-02T23:17:23.000Z', '2025-12-03T12:34:01.000Z', '2025-12-03T12:34:01.000Z');
UPDATE public.profiles SET name = 'Augusto Cezar Oliveira Izac ', cpf = '09116522648', phone = '31984245873', company_id = 'eacd7080-2b72-4439-ad12-3db8ce76678d' WHERE user_id = '6132ed9b-313a-4646-9267-bf446af0f6f1';
UPDATE public.user_roles SET company_id = 'eacd7080-2b72-4439-ad12-3db8ce76678d' WHERE user_id = '6132ed9b-313a-4646-9267-bf446af0f6f1';

-- ALYSSON VINICIUS LIMA GUIMARAES (alysson.guimaraes@cdlbh.com.br) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('04a866ec-23fb-4e4e-b0c4-87e65496eb5a', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'alysson.guimaraes@cdlbh.com.br', '', '2025-12-02T23:17:24.000Z', '2025-12-02T23:17:24.000Z', '2025-12-03T03:20:48.000Z', '{"provider":"email","providers":["email"]}', '{"name":"ALYSSON VINICIUS LIMA GUIMARAES"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('310f0214-4c99-44a9-ac75-f64b18a773a9', '04a866ec-23fb-4e4e-b0c4-87e65496eb5a', '{"sub":"04a866ec-23fb-4e4e-b0c4-87e65496eb5a","email":"alysson.guimaraes@cdlbh.com.br","email_verified":true}', 'email', '04a866ec-23fb-4e4e-b0c4-87e65496eb5a', '2025-12-02T23:17:24.000Z', '2025-12-03T03:20:48.000Z', '2025-12-03T03:20:49.000Z');
UPDATE public.profiles SET name = 'ALYSSON VINICIUS LIMA GUIMARAES', cpf = '05222714640', phone = '31992135858', company_id = 'eacd7080-2b72-4439-ad12-3db8ce76678d' WHERE user_id = '04a866ec-23fb-4e4e-b0c4-87e65496eb5a';
UPDATE public.user_roles SET company_id = 'eacd7080-2b72-4439-ad12-3db8ce76678d' WHERE user_id = '04a866ec-23fb-4e4e-b0c4-87e65496eb5a';

-- Emely Gaspar Teles (emelygaspar@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('a12d234f-891f-4eef-b62e-951348b2cc33', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'emelygaspar@gmail.com', '', '2025-12-02T23:17:25.000Z', '2025-12-02T23:17:25.000Z', '2025-12-03T03:20:32.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Emely Gaspar Teles"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('5d5aa818-207b-4720-882c-ab9da47bd229', 'a12d234f-891f-4eef-b62e-951348b2cc33', '{"sub":"a12d234f-891f-4eef-b62e-951348b2cc33","email":"emelygaspar@gmail.com","email_verified":true}', 'email', 'a12d234f-891f-4eef-b62e-951348b2cc33', '2025-12-02T23:17:25.000Z', '2025-12-03T03:20:32.000Z', '2025-12-03T03:20:32.000Z');
UPDATE public.profiles SET name = 'Emely Gaspar Teles', cpf = '07786678638', phone = '31999426153', company_id = 'eacd7080-2b72-4439-ad12-3db8ce76678d' WHERE user_id = 'a12d234f-891f-4eef-b62e-951348b2cc33';
UPDATE public.user_roles SET company_id = 'eacd7080-2b72-4439-ad12-3db8ce76678d' WHERE user_id = 'a12d234f-891f-4eef-b62e-951348b2cc33';

-- Adriano dos Santos Boscatte  (adrianoboscatte@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('60bf313e-6b6f-4658-950a-e48887b1325b', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'adrianoboscatte@gmail.com', '', '2025-12-02T23:17:26.000Z', '2025-12-02T23:17:26.000Z', '2025-12-05T04:33:47.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Adriano dos Santos Boscatte "}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('1ea8f79b-c847-45e9-9bf8-0e13b8dec8cf', '60bf313e-6b6f-4658-950a-e48887b1325b', '{"sub":"60bf313e-6b6f-4658-950a-e48887b1325b","email":"adrianoboscatte@gmail.com","email_verified":true}', 'email', '60bf313e-6b6f-4658-950a-e48887b1325b', '2025-12-02T23:17:26.000Z', '2025-12-05T04:33:47.000Z', '2025-12-05T04:33:47.000Z');
UPDATE public.profiles SET name = 'Adriano dos Santos Boscatte ', cpf = '00138760667', phone = '31987374686', company_id = 'eacd7080-2b72-4439-ad12-3db8ce76678d' WHERE user_id = '60bf313e-6b6f-4658-950a-e48887b1325b';
UPDATE public.user_roles SET company_id = 'eacd7080-2b72-4439-ad12-3db8ce76678d' WHERE user_id = '60bf313e-6b6f-4658-950a-e48887b1325b';

-- Luísa Meneghetti Almeida Melo (luisa@cpbellaperfumes.com.br) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('18a5313a-cfa4-44d1-a9e5-74514b4778ba', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'luisa@cpbellaperfumes.com.br', '', '2025-12-02T23:17:28.000Z', '2025-12-02T23:17:28.000Z', '2025-12-02T23:50:11.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Luísa Meneghetti Almeida Melo"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('fd007647-790b-4e6c-b4a2-bf5b34456b07', '18a5313a-cfa4-44d1-a9e5-74514b4778ba', '{"sub":"18a5313a-cfa4-44d1-a9e5-74514b4778ba","email":"luisa@cpbellaperfumes.com.br","email_verified":true}', 'email', '18a5313a-cfa4-44d1-a9e5-74514b4778ba', '2025-12-02T23:17:28.000Z', '2025-12-02T23:50:11.000Z', '2025-12-02T23:50:11.000Z');
UPDATE public.profiles SET name = 'Luísa Meneghetti Almeida Melo', cpf = '13794575644', phone = '31999289667', company_id = 'eacd7080-2b72-4439-ad12-3db8ce76678d' WHERE user_id = '18a5313a-cfa4-44d1-a9e5-74514b4778ba';
UPDATE public.user_roles SET company_id = 'eacd7080-2b72-4439-ad12-3db8ce76678d' WHERE user_id = '18a5313a-cfa4-44d1-a9e5-74514b4778ba';

-- Gabriel Junqueira (gabriel.junqueira@avancoinfo.com.br) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('9c86c28d-52a8-4231-b26a-03dc6e2650f9', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'gabriel.junqueira@avancoinfo.com.br', '', '2025-12-02T23:17:31.000Z', '2025-12-02T23:17:31.000Z', '2025-12-02T23:36:07.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Gabriel Junqueira"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('082d4061-8c18-4595-a7f8-483cc65e15f8', '9c86c28d-52a8-4231-b26a-03dc6e2650f9', '{"sub":"9c86c28d-52a8-4231-b26a-03dc6e2650f9","email":"gabriel.junqueira@avancoinfo.com.br","email_verified":true}', 'email', '9c86c28d-52a8-4231-b26a-03dc6e2650f9', '2025-12-02T23:17:31.000Z', '2025-12-02T23:36:07.000Z', '2025-12-02T23:36:08.000Z');
UPDATE public.profiles SET name = 'Gabriel Junqueira', cpf = '01560949678', phone = '31982819736', company_id = 'eacd7080-2b72-4439-ad12-3db8ce76678d' WHERE user_id = '9c86c28d-52a8-4231-b26a-03dc6e2650f9';
UPDATE public.user_roles SET company_id = 'eacd7080-2b72-4439-ad12-3db8ce76678d' WHERE user_id = '9c86c28d-52a8-4231-b26a-03dc6e2650f9';

-- Joás Pessoa da Cruz (joas_pessoa@hotmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('a4d3196b-3cb0-4927-9c37-2f392d1981bb', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'joas_pessoa@hotmail.com', '', '2025-12-02T23:17:31.000Z', '2025-12-02T23:17:31.000Z', '2025-12-02T23:33:51.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Joás Pessoa da Cruz"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('9c5a74a1-53b1-43fc-bc18-ac3298051085', 'a4d3196b-3cb0-4927-9c37-2f392d1981bb', '{"sub":"a4d3196b-3cb0-4927-9c37-2f392d1981bb","email":"joas_pessoa@hotmail.com","email_verified":true}', 'email', 'a4d3196b-3cb0-4927-9c37-2f392d1981bb', '2025-12-02T23:17:31.000Z', '2025-12-02T23:33:51.000Z', '2025-12-02T23:33:51.000Z');
UPDATE public.profiles SET name = 'Joás Pessoa da Cruz', cpf = '08607452444', phone = '31982152280', company_id = 'eacd7080-2b72-4439-ad12-3db8ce76678d' WHERE user_id = 'a4d3196b-3cb0-4927-9c37-2f392d1981bb';
UPDATE public.user_roles SET company_id = 'eacd7080-2b72-4439-ad12-3db8ce76678d' WHERE user_id = 'a4d3196b-3cb0-4927-9c37-2f392d1981bb';

-- Marlucio Rodrigues da silva  (marlucio.silva@fundacaocdlbh.org) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('a709784f-2dc0-4dbe-aefb-a0bc99362de7', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'marlucio.silva@fundacaocdlbh.org', '', '2025-12-02T23:17:32.000Z', '2025-12-02T23:17:32.000Z', '2025-12-02T23:41:36.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Marlucio Rodrigues da silva "}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('bdffd85f-2464-4b26-a913-2da5ce625b50', 'a709784f-2dc0-4dbe-aefb-a0bc99362de7', '{"sub":"a709784f-2dc0-4dbe-aefb-a0bc99362de7","email":"marlucio.silva@fundacaocdlbh.org","email_verified":true}', 'email', 'a709784f-2dc0-4dbe-aefb-a0bc99362de7', '2025-12-02T23:17:32.000Z', '2025-12-02T23:41:36.000Z', '2025-12-02T23:41:36.000Z');
UPDATE public.profiles SET name = 'Marlucio Rodrigues da silva ', cpf = '05791659652', phone = '31987547509', company_id = 'eacd7080-2b72-4439-ad12-3db8ce76678d' WHERE user_id = 'a709784f-2dc0-4dbe-aefb-a0bc99362de7';
UPDATE public.user_roles SET company_id = 'eacd7080-2b72-4439-ad12-3db8ce76678d' WHERE user_id = 'a709784f-2dc0-4dbe-aefb-a0bc99362de7';

-- Bruna Silva (brunarpn@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('54b99f09-d124-47a5-b8c2-6d333951bbbe', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'brunarpn@gmail.com', '', '2025-12-02T23:17:36.000Z', '2025-12-02T23:17:36.000Z', '2026-01-01T08:48:46.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Bruna Silva"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('1f6b9d99-6205-435c-b870-585b38cfc83b', '54b99f09-d124-47a5-b8c2-6d333951bbbe', '{"sub":"54b99f09-d124-47a5-b8c2-6d333951bbbe","email":"brunarpn@gmail.com","email_verified":true}', 'email', '54b99f09-d124-47a5-b8c2-6d333951bbbe', '2025-12-02T23:17:36.000Z', '2026-01-01T08:48:46.000Z', '2026-01-01T08:48:47.000Z');
UPDATE public.profiles SET name = 'Bruna Silva', cpf = '01551315670', phone = '31989795140', company_id = 'eacd7080-2b72-4439-ad12-3db8ce76678d' WHERE user_id = '54b99f09-d124-47a5-b8c2-6d333951bbbe';
UPDATE public.user_roles SET company_id = 'eacd7080-2b72-4439-ad12-3db8ce76678d' WHERE user_id = '54b99f09-d124-47a5-b8c2-6d333951bbbe';

-- Débora Franciele goncalves  Drumond  (debora.com.mkt@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('319fe7bf-b54a-45a3-bc6d-c290c98b9cad', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'debora.com.mkt@gmail.com', '', '2025-12-02T23:17:38.000Z', '2025-12-02T23:17:38.000Z', '2025-12-02T23:29:19.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Débora Franciele goncalves  Drumond "}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('5f2e0654-e5ba-4917-af63-3f57aa96c756', '319fe7bf-b54a-45a3-bc6d-c290c98b9cad', '{"sub":"319fe7bf-b54a-45a3-bc6d-c290c98b9cad","email":"debora.com.mkt@gmail.com","email_verified":true}', 'email', '319fe7bf-b54a-45a3-bc6d-c290c98b9cad', '2025-12-02T23:17:38.000Z', '2025-12-02T23:29:19.000Z', '2025-12-02T23:29:20.000Z');
UPDATE public.profiles SET name = 'Débora Franciele goncalves  Drumond ', cpf = '12180551622', phone = '31972487091', company_id = 'eacd7080-2b72-4439-ad12-3db8ce76678d' WHERE user_id = '319fe7bf-b54a-45a3-bc6d-c290c98b9cad';
UPDATE public.user_roles SET company_id = 'eacd7080-2b72-4439-ad12-3db8ce76678d' WHERE user_id = '319fe7bf-b54a-45a3-bc6d-c290c98b9cad';

-- BRENO FERREIRA DUARTE (brenoduarte@hotmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('f8e95bac-2a37-4d19-90b5-17d2b9b713f8', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'brenoduarte@hotmail.com', '', '2025-12-02T23:17:41.000Z', '2025-12-02T23:17:41.000Z', '2025-12-03T00:51:51.000Z', '{"provider":"email","providers":["email"]}', '{"name":"BRENO FERREIRA DUARTE"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('72b5457c-46b0-4be7-8968-dba600fcf056', 'f8e95bac-2a37-4d19-90b5-17d2b9b713f8', '{"sub":"f8e95bac-2a37-4d19-90b5-17d2b9b713f8","email":"brenoduarte@hotmail.com","email_verified":true}', 'email', 'f8e95bac-2a37-4d19-90b5-17d2b9b713f8', '2025-12-02T23:17:41.000Z', '2025-12-03T00:51:51.000Z', '2025-12-03T00:51:52.000Z');
UPDATE public.profiles SET name = 'BRENO FERREIRA DUARTE', cpf = '04745961685', phone = '31999519555', company_id = 'eacd7080-2b72-4439-ad12-3db8ce76678d' WHERE user_id = 'f8e95bac-2a37-4d19-90b5-17d2b9b713f8';
UPDATE public.user_roles SET company_id = 'eacd7080-2b72-4439-ad12-3db8ce76678d' WHERE user_id = 'f8e95bac-2a37-4d19-90b5-17d2b9b713f8';

-- Wadir Proença Simão (wadir@bellaboticario.com.br) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('181cfeeb-386f-4e90-8110-22c9f85ff163', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'wadir@bellaboticario.com.br', '', '2025-12-02T23:17:43.000Z', '2025-12-02T23:17:43.000Z', '2025-12-03T03:43:06.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Wadir Proença Simão"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('c08ea8d1-db9b-4065-8e2c-f32358a1dca8', '181cfeeb-386f-4e90-8110-22c9f85ff163', '{"sub":"181cfeeb-386f-4e90-8110-22c9f85ff163","email":"wadir@bellaboticario.com.br","email_verified":true}', 'email', '181cfeeb-386f-4e90-8110-22c9f85ff163', '2025-12-02T23:17:43.000Z', '2025-12-03T03:43:06.000Z', '2025-12-03T03:43:07.000Z');
UPDATE public.profiles SET name = 'Wadir Proença Simão', cpf = '50873210620', phone = '3199769621', company_id = 'eacd7080-2b72-4439-ad12-3db8ce76678d' WHERE user_id = '181cfeeb-386f-4e90-8110-22c9f85ff163';
UPDATE public.user_roles SET company_id = 'eacd7080-2b72-4439-ad12-3db8ce76678d' WHERE user_id = '181cfeeb-386f-4e90-8110-22c9f85ff163';

-- José Ângelo de melo (joseangelo@bellaboticario.com.br) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('f7e5e509-9c83-4eb4-8c37-dcf76f858a36', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'joseangelo@bellaboticario.com.br', '', '2025-12-02T23:17:48.000Z', '2025-12-02T23:17:48.000Z', '2025-12-02T23:18:57.000Z', '{"provider":"email","providers":["email"]}', '{"name":"José Ângelo de melo"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('336192b1-f991-4c6e-be0c-63a477d29aba', 'f7e5e509-9c83-4eb4-8c37-dcf76f858a36', '{"sub":"f7e5e509-9c83-4eb4-8c37-dcf76f858a36","email":"joseangelo@bellaboticario.com.br","email_verified":true}', 'email', 'f7e5e509-9c83-4eb4-8c37-dcf76f858a36', '2025-12-02T23:17:48.000Z', '2025-12-02T23:18:57.000Z', '2025-12-02T23:18:58.000Z');
UPDATE public.profiles SET name = 'José Ângelo de melo', cpf = '37527274620', phone = '31999353010', company_id = 'eacd7080-2b72-4439-ad12-3db8ce76678d' WHERE user_id = 'f7e5e509-9c83-4eb4-8c37-dcf76f858a36';
UPDATE public.user_roles SET company_id = 'eacd7080-2b72-4439-ad12-3db8ce76678d' WHERE user_id = 'f7e5e509-9c83-4eb4-8c37-dcf76f858a36';

-- José Américo de Andrade Júnior (junioramerico@atsinformatica.com.br) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('2cd1ba73-bcba-4ca8-ade6-97219db29cd7', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'junioramerico@atsinformatica.com.br', '', '2025-12-02T23:17:51.000Z', '2025-12-02T23:17:51.000Z', '2025-12-03T04:22:33.000Z', '{"provider":"email","providers":["email"]}', '{"name":"José Américo de Andrade Júnior"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('12a5a76e-9f08-426b-aba9-9c7006216b8c', '2cd1ba73-bcba-4ca8-ade6-97219db29cd7', '{"sub":"2cd1ba73-bcba-4ca8-ade6-97219db29cd7","email":"junioramerico@atsinformatica.com.br","email_verified":true}', 'email', '2cd1ba73-bcba-4ca8-ade6-97219db29cd7', '2025-12-02T23:17:51.000Z', '2025-12-03T04:22:33.000Z', '2025-12-03T04:22:33.000Z');
UPDATE public.profiles SET name = 'José Américo de Andrade Júnior', cpf = '01234567890', phone = '31982243281', company_id = 'eacd7080-2b72-4439-ad12-3db8ce76678d' WHERE user_id = '2cd1ba73-bcba-4ca8-ade6-97219db29cd7';
UPDATE public.user_roles SET company_id = 'eacd7080-2b72-4439-ad12-3db8ce76678d' WHERE user_id = '2cd1ba73-bcba-4ca8-ade6-97219db29cd7';

-- Ulisses Samarone Pereira Coelho  (ulissessamarone@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('d3c1f74f-55a1-4dba-99f8-d4586ce6cce4', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'ulissessamarone@gmail.com', '', '2025-12-02T23:17:55.000Z', '2025-12-02T23:17:55.000Z', '2025-12-03T02:01:48.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Ulisses Samarone Pereira Coelho "}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('3e01fe28-1b28-4ecd-88fd-03f92e7cc194', 'd3c1f74f-55a1-4dba-99f8-d4586ce6cce4', '{"sub":"d3c1f74f-55a1-4dba-99f8-d4586ce6cce4","email":"ulissessamarone@gmail.com","email_verified":true}', 'email', 'd3c1f74f-55a1-4dba-99f8-d4586ce6cce4', '2025-12-02T23:17:55.000Z', '2025-12-03T02:01:48.000Z', '2025-12-03T02:01:48.000Z');
UPDATE public.profiles SET name = 'Ulisses Samarone Pereira Coelho ', cpf = '06650909602', phone = '31989572995', company_id = 'eacd7080-2b72-4439-ad12-3db8ce76678d' WHERE user_id = 'd3c1f74f-55a1-4dba-99f8-d4586ce6cce4';
UPDATE public.user_roles SET company_id = 'eacd7080-2b72-4439-ad12-3db8ce76678d' WHERE user_id = 'd3c1f74f-55a1-4dba-99f8-d4586ce6cce4';

-- Carlos Eduardo Machado de Almeida e Sousa (carloseduardo.cacaushowbh@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('cb01c4a5-d33d-47ab-b303-ae36eea535d9', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'carloseduardo.cacaushowbh@gmail.com', '', '2025-12-02T23:17:57.000Z', '2025-12-02T23:17:57.000Z', '2025-12-03T15:17:03.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Carlos Eduardo Machado de Almeida e Sousa"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('4383937c-a3ab-4f14-8173-79abce9f9733', 'cb01c4a5-d33d-47ab-b303-ae36eea535d9', '{"sub":"cb01c4a5-d33d-47ab-b303-ae36eea535d9","email":"carloseduardo.cacaushowbh@gmail.com","email_verified":true}', 'email', 'cb01c4a5-d33d-47ab-b303-ae36eea535d9', '2025-12-02T23:17:57.000Z', '2025-12-03T15:17:03.000Z', '2025-12-03T15:17:01.000Z');
UPDATE public.profiles SET name = 'Carlos Eduardo Machado de Almeida e Sousa', cpf = '01453193693', phone = '31993409349', company_id = 'eacd7080-2b72-4439-ad12-3db8ce76678d' WHERE user_id = 'cb01c4a5-d33d-47ab-b303-ae36eea535d9';
UPDATE public.user_roles SET company_id = 'eacd7080-2b72-4439-ad12-3db8ce76678d' WHERE user_id = 'cb01c4a5-d33d-47ab-b303-ae36eea535d9';

-- Carlo Eduardo Grimaldi  (carloeduardo@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('6d9866be-e0c0-46ca-921b-898a68cb9343', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'carloeduardo@gmail.com', '', '2025-12-02T23:18:07.000Z', '2025-12-02T23:18:07.000Z', '2025-12-03T03:41:02.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Carlo Eduardo Grimaldi "}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('cf31984d-ddc7-4885-86f7-8e9c5ca97d72', '6d9866be-e0c0-46ca-921b-898a68cb9343', '{"sub":"6d9866be-e0c0-46ca-921b-898a68cb9343","email":"carloeduardo@gmail.com","email_verified":true}', 'email', '6d9866be-e0c0-46ca-921b-898a68cb9343', '2025-12-02T23:18:07.000Z', '2025-12-03T03:41:02.000Z', '2025-12-03T03:41:02.000Z');
UPDATE public.profiles SET name = 'Carlo Eduardo Grimaldi ', cpf = '06241362640', phone = '31994310008', company_id = 'eacd7080-2b72-4439-ad12-3db8ce76678d' WHERE user_id = '6d9866be-e0c0-46ca-921b-898a68cb9343';
UPDATE public.user_roles SET company_id = 'eacd7080-2b72-4439-ad12-3db8ce76678d' WHERE user_id = '6d9866be-e0c0-46ca-921b-898a68cb9343';

-- Joao Victor Renault (joaovictor@cdlbh.com.br) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('fa4db06a-25fd-45f7-a2c2-e706011a553d', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'joaovictor@cdlbh.com.br', '', '2025-12-02T23:18:07.000Z', '2025-12-02T23:18:07.000Z', '2025-12-02T23:42:33.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Joao Victor Renault"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('17572e65-841d-4e2c-a418-2754f7df4716', 'fa4db06a-25fd-45f7-a2c2-e706011a553d', '{"sub":"fa4db06a-25fd-45f7-a2c2-e706011a553d","email":"joaovictor@cdlbh.com.br","email_verified":true}', 'email', 'fa4db06a-25fd-45f7-a2c2-e706011a553d', '2025-12-02T23:18:07.000Z', '2025-12-02T23:42:33.000Z', '2025-12-02T23:42:33.000Z');
UPDATE public.profiles SET name = 'Joao Victor Renault', cpf = '45524696653', phone = '31992421638', company_id = 'eacd7080-2b72-4439-ad12-3db8ce76678d' WHERE user_id = 'fa4db06a-25fd-45f7-a2c2-e706011a553d';
UPDATE public.user_roles SET company_id = 'eacd7080-2b72-4439-ad12-3db8ce76678d' WHERE user_id = 'fa4db06a-25fd-45f7-a2c2-e706011a553d';

-- Ana Lara Mendonça  (analaraest@icloud.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('20a59e0d-ad06-4a75-a076-4e906d20af51', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'analaraest@icloud.com', '', '2025-12-02T23:18:16.000Z', '2025-12-02T23:18:16.000Z', '2025-12-02T23:39:40.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Ana Lara Mendonça "}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('242e1d83-60bd-414d-8915-127ba186ea84', '20a59e0d-ad06-4a75-a076-4e906d20af51', '{"sub":"20a59e0d-ad06-4a75-a076-4e906d20af51","email":"analaraest@icloud.com","email_verified":true}', 'email', '20a59e0d-ad06-4a75-a076-4e906d20af51', '2025-12-02T23:18:16.000Z', '2025-12-02T23:39:40.000Z', '2025-12-02T23:39:41.000Z');
UPDATE public.profiles SET name = 'Ana Lara Mendonça ', cpf = '13635598690', phone = '31986179499', company_id = 'eacd7080-2b72-4439-ad12-3db8ce76678d' WHERE user_id = '20a59e0d-ad06-4a75-a076-4e906d20af51';
UPDATE public.user_roles SET company_id = 'eacd7080-2b72-4439-ad12-3db8ce76678d' WHERE user_id = '20a59e0d-ad06-4a75-a076-4e906d20af51';

-- Hitalo Carvalho (hitalocarvalho@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('49c053d1-4ed6-4842-bcb2-f9282e399972', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'hitalocarvalho@gmail.com', '', '2025-12-02T23:18:22.000Z', '2025-12-02T23:18:22.000Z', '2025-12-02T23:53:36.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Hitalo Carvalho"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('cebd576a-1759-4020-a60e-8f92b6efc16a', '49c053d1-4ed6-4842-bcb2-f9282e399972', '{"sub":"49c053d1-4ed6-4842-bcb2-f9282e399972","email":"hitalocarvalho@gmail.com","email_verified":true}', 'email', '49c053d1-4ed6-4842-bcb2-f9282e399972', '2025-12-02T23:18:22.000Z', '2025-12-02T23:53:36.000Z', '2025-12-02T23:53:36.000Z');
UPDATE public.profiles SET name = 'Hitalo Carvalho', cpf = '12923589637', phone = '38992292662', company_id = 'eacd7080-2b72-4439-ad12-3db8ce76678d' WHERE user_id = '49c053d1-4ed6-4842-bcb2-f9282e399972';
UPDATE public.user_roles SET company_id = 'eacd7080-2b72-4439-ad12-3db8ce76678d' WHERE user_id = '49c053d1-4ed6-4842-bcb2-f9282e399972';

-- Ana Karla  Morais Goncalves (anakarlamoraisg@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('65fefc70-52b5-475b-a04e-7abd2235e2cc', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'anakarlamoraisg@gmail.com', '', '2025-12-02T23:18:34.000Z', '2025-12-02T23:18:34.000Z', '2025-12-08T01:57:55.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Ana Karla  Morais Goncalves"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('06b8bbe1-022c-446e-885d-13f829c83422', '65fefc70-52b5-475b-a04e-7abd2235e2cc', '{"sub":"65fefc70-52b5-475b-a04e-7abd2235e2cc","email":"anakarlamoraisg@gmail.com","email_verified":true}', 'email', '65fefc70-52b5-475b-a04e-7abd2235e2cc', '2025-12-02T23:18:34.000Z', '2025-12-08T01:57:55.000Z', '2025-12-08T01:57:54.000Z');
UPDATE public.profiles SET name = 'Ana Karla  Morais Goncalves', cpf = '11665188685', phone = '31991535483', company_id = 'eacd7080-2b72-4439-ad12-3db8ce76678d' WHERE user_id = '65fefc70-52b5-475b-a04e-7abd2235e2cc';
UPDATE public.user_roles SET company_id = 'eacd7080-2b72-4439-ad12-3db8ce76678d' WHERE user_id = '65fefc70-52b5-475b-a04e-7abd2235e2cc';

-- Isis dos Santos Kroeff (isis.or.natural@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('c5f68c56-06f3-4f37-adfd-bfc48ef6e848', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'isis.or.natural@gmail.com', '', '2025-12-02T23:18:40.000Z', '2025-12-02T23:18:40.000Z', '2025-12-02T23:28:12.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Isis dos Santos Kroeff"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('b3944679-fd2f-4bf0-a008-22e94e83dbf2', 'c5f68c56-06f3-4f37-adfd-bfc48ef6e848', '{"sub":"c5f68c56-06f3-4f37-adfd-bfc48ef6e848","email":"isis.or.natural@gmail.com","email_verified":true}', 'email', 'c5f68c56-06f3-4f37-adfd-bfc48ef6e848', '2025-12-02T23:18:40.000Z', '2025-12-02T23:28:12.000Z', '2025-12-02T23:28:12.000Z');
UPDATE public.profiles SET name = 'Isis dos Santos Kroeff', cpf = '07316813636', phone = '31995570620', company_id = 'eacd7080-2b72-4439-ad12-3db8ce76678d' WHERE user_id = 'c5f68c56-06f3-4f37-adfd-bfc48ef6e848';
UPDATE public.user_roles SET company_id = 'eacd7080-2b72-4439-ad12-3db8ce76678d' WHERE user_id = 'c5f68c56-06f3-4f37-adfd-bfc48ef6e848';

-- Aquilis Dictis Moreira Kilão (aquilis.moreira@oktz.com.br) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('f3199ccd-f1be-439a-a46e-7c2117e382e3', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'aquilis.moreira@oktz.com.br', '', '2025-12-02T23:18:45.000Z', '2025-12-02T23:18:45.000Z', '2026-01-28T00:42:07.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Aquilis Dictis Moreira Kilão"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('cf7d6d20-de50-4672-802a-63fb6bab6201', 'f3199ccd-f1be-439a-a46e-7c2117e382e3', '{"sub":"f3199ccd-f1be-439a-a46e-7c2117e382e3","email":"aquilis.moreira@oktz.com.br","email_verified":true}', 'email', 'f3199ccd-f1be-439a-a46e-7c2117e382e3', '2025-12-02T23:18:45.000Z', '2026-01-28T00:42:07.000Z', '2026-01-28T00:42:06.000Z');
UPDATE public.profiles SET name = 'Aquilis Dictis Moreira Kilão', cpf = '03673160648', phone = '31996793230', company_id = 'eacd7080-2b72-4439-ad12-3db8ce76678d' WHERE user_id = 'f3199ccd-f1be-439a-a46e-7c2117e382e3';
UPDATE public.user_roles SET company_id = 'eacd7080-2b72-4439-ad12-3db8ce76678d' WHERE user_id = 'f3199ccd-f1be-439a-a46e-7c2117e382e3';

-- Raquel Ferreira (k.raquelferreira@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('f2b2c58e-55e3-4966-941e-d6dc8b18dc5a', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'k.raquelferreira@gmail.com', '', '2025-12-02T23:18:47.000Z', '2025-12-02T23:18:47.000Z', '2025-12-03T00:18:59.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Raquel Ferreira"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('3a6075be-5b0f-4226-b418-e6def3ae7c65', 'f2b2c58e-55e3-4966-941e-d6dc8b18dc5a', '{"sub":"f2b2c58e-55e3-4966-941e-d6dc8b18dc5a","email":"k.raquelferreira@gmail.com","email_verified":true}', 'email', 'f2b2c58e-55e3-4966-941e-d6dc8b18dc5a', '2025-12-02T23:18:47.000Z', '2025-12-03T00:18:59.000Z', '2025-12-03T00:19:00.000Z');
UPDATE public.profiles SET name = 'Raquel Ferreira', cpf = '07542443690', phone = '31984589455', company_id = 'eacd7080-2b72-4439-ad12-3db8ce76678d' WHERE user_id = 'f2b2c58e-55e3-4966-941e-d6dc8b18dc5a';
UPDATE public.user_roles SET company_id = 'eacd7080-2b72-4439-ad12-3db8ce76678d' WHERE user_id = 'f2b2c58e-55e3-4966-941e-d6dc8b18dc5a';

-- Gabriel Falci (gabrielvfalci@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('f678f5e8-85e2-421a-a8b9-920ea78c7245', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'gabrielvfalci@gmail.com', '', '2025-12-02T23:18:57.000Z', '2025-12-02T23:18:57.000Z', '2025-12-02T23:44:19.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Gabriel Falci"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('7ed3880b-cdae-4b06-98d5-70e26d69383f', 'f678f5e8-85e2-421a-a8b9-920ea78c7245', '{"sub":"f678f5e8-85e2-421a-a8b9-920ea78c7245","email":"gabrielvfalci@gmail.com","email_verified":true}', 'email', 'f678f5e8-85e2-421a-a8b9-920ea78c7245', '2025-12-02T23:18:57.000Z', '2025-12-02T23:44:19.000Z', '2025-12-02T23:44:20.000Z');
UPDATE public.profiles SET name = 'Gabriel Falci', cpf = '01266795685', phone = '31988351958', company_id = 'eacd7080-2b72-4439-ad12-3db8ce76678d' WHERE user_id = 'f678f5e8-85e2-421a-a8b9-920ea78c7245';
UPDATE public.user_roles SET company_id = 'eacd7080-2b72-4439-ad12-3db8ce76678d' WHERE user_id = 'f678f5e8-85e2-421a-a8b9-920ea78c7245';

-- Hellen Machado Ramos Xavier (hellenmr87@yahoo.com.br) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('33145e4e-007f-498a-bf74-25885277de9a', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'hellenmr87@yahoo.com.br', '', '2025-12-02T23:19:06.000Z', '2025-12-02T23:19:06.000Z', '2025-12-02T23:45:10.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Hellen Machado Ramos Xavier"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('1cb137f0-cda7-4a4f-bcfd-e1e89e690ec7', '33145e4e-007f-498a-bf74-25885277de9a', '{"sub":"33145e4e-007f-498a-bf74-25885277de9a","email":"hellenmr87@yahoo.com.br","email_verified":true}', 'email', '33145e4e-007f-498a-bf74-25885277de9a', '2025-12-02T23:19:06.000Z', '2025-12-02T23:45:10.000Z', '2025-12-02T23:45:10.000Z');
UPDATE public.profiles SET name = 'Hellen Machado Ramos Xavier', cpf = '01597557609', phone = '31991348917', company_id = 'eacd7080-2b72-4439-ad12-3db8ce76678d' WHERE user_id = '33145e4e-007f-498a-bf74-25885277de9a';
UPDATE public.user_roles SET company_id = 'eacd7080-2b72-4439-ad12-3db8ce76678d' WHERE user_id = '33145e4e-007f-498a-bf74-25885277de9a';

-- Alexandre Santos (alexandresantos@smcit.com.br) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('4ac6ac57-d037-4fe0-8dc9-3055c4210e18', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'alexandresantos@smcit.com.br', '', '2025-12-02T23:19:13.000Z', '2025-12-02T23:19:13.000Z', '2025-12-02T23:47:30.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Alexandre Santos"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('94475e76-da90-4cdd-9eb4-f41dc0caffa3', '4ac6ac57-d037-4fe0-8dc9-3055c4210e18', '{"sub":"4ac6ac57-d037-4fe0-8dc9-3055c4210e18","email":"alexandresantos@smcit.com.br","email_verified":true}', 'email', '4ac6ac57-d037-4fe0-8dc9-3055c4210e18', '2025-12-02T23:19:13.000Z', '2025-12-02T23:47:30.000Z', '2025-12-02T23:47:30.000Z');
UPDATE public.profiles SET name = 'Alexandre Santos', cpf = '01603722670', phone = '31993968637', company_id = 'eacd7080-2b72-4439-ad12-3db8ce76678d' WHERE user_id = '4ac6ac57-d037-4fe0-8dc9-3055c4210e18';
UPDATE public.user_roles SET company_id = 'eacd7080-2b72-4439-ad12-3db8ce76678d' WHERE user_id = '4ac6ac57-d037-4fe0-8dc9-3055c4210e18';

-- Fausto Sebastião Izac (faustocasabranca@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('5f6cb3b6-dc9c-4968-b615-13d45c9f0fa7', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'faustocasabranca@gmail.com', '', '2025-12-02T23:19:25.000Z', '2025-12-02T23:19:25.000Z', '2025-12-02T23:36:35.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Fausto Sebastião Izac"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('0f38225d-98b9-4052-8511-4425203a41a7', '5f6cb3b6-dc9c-4968-b615-13d45c9f0fa7', '{"sub":"5f6cb3b6-dc9c-4968-b615-13d45c9f0fa7","email":"faustocasabranca@gmail.com","email_verified":true}', 'email', '5f6cb3b6-dc9c-4968-b615-13d45c9f0fa7', '2025-12-02T23:19:25.000Z', '2025-12-02T23:36:35.000Z', '2025-12-02T23:36:35.000Z');
UPDATE public.profiles SET name = 'Fausto Sebastião Izac', cpf = '29339090659', phone = '31984242621', company_id = 'eacd7080-2b72-4439-ad12-3db8ce76678d' WHERE user_id = '5f6cb3b6-dc9c-4968-b615-13d45c9f0fa7';
UPDATE public.user_roles SET company_id = 'eacd7080-2b72-4439-ad12-3db8ce76678d' WHERE user_id = '5f6cb3b6-dc9c-4968-b615-13d45c9f0fa7';

-- Camila  (camilarvalentim@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('242b31df-fa12-4fe8-9457-f8b8b589ba39', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'camilarvalentim@gmail.com', '', '2025-12-02T23:19:32.000Z', '2025-12-02T23:19:32.000Z', '2025-12-02T23:35:30.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Camila "}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('d61a70f0-6a33-43fc-8c94-90d788405b0e', '242b31df-fa12-4fe8-9457-f8b8b589ba39', '{"sub":"242b31df-fa12-4fe8-9457-f8b8b589ba39","email":"camilarvalentim@gmail.com","email_verified":true}', 'email', '242b31df-fa12-4fe8-9457-f8b8b589ba39', '2025-12-02T23:19:32.000Z', '2025-12-02T23:35:30.000Z', '2025-12-02T23:35:31.000Z');
UPDATE public.profiles SET name = 'Camila ', cpf = '11089162600', phone = '31993972597', company_id = 'eacd7080-2b72-4439-ad12-3db8ce76678d' WHERE user_id = '242b31df-fa12-4fe8-9457-f8b8b589ba39';
UPDATE public.user_roles SET company_id = 'eacd7080-2b72-4439-ad12-3db8ce76678d' WHERE user_id = '242b31df-fa12-4fe8-9457-f8b8b589ba39';

-- Nayara Campos  (nayaralcampos@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('6cac855d-d7ac-4a62-a20b-2ea1ef27d5b7', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'nayaralcampos@gmail.com', '', '2025-12-02T23:19:44.000Z', '2025-12-02T23:19:44.000Z', '2025-12-02T23:34:46.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Nayara Campos "}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('bb6c37cb-a639-40c5-8ba4-7af371d2a6d8', '6cac855d-d7ac-4a62-a20b-2ea1ef27d5b7', '{"sub":"6cac855d-d7ac-4a62-a20b-2ea1ef27d5b7","email":"nayaralcampos@gmail.com","email_verified":true}', 'email', '6cac855d-d7ac-4a62-a20b-2ea1ef27d5b7', '2025-12-02T23:19:44.000Z', '2025-12-02T23:34:46.000Z', '2025-12-02T23:34:47.000Z');
UPDATE public.profiles SET name = 'Nayara Campos ', cpf = '09712858618', phone = '31999197296', company_id = 'eacd7080-2b72-4439-ad12-3db8ce76678d' WHERE user_id = '6cac855d-d7ac-4a62-a20b-2ea1ef27d5b7';
UPDATE public.user_roles SET company_id = 'eacd7080-2b72-4439-ad12-3db8ce76678d' WHERE user_id = '6cac855d-d7ac-4a62-a20b-2ea1ef27d5b7';

-- Vilson da Silva Mayrink (vilson.mayrink@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('5e24dd3f-f949-4962-8e7a-196d8dc7c767', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'vilson.mayrink@gmail.com', '', '2025-12-02T23:19:56.000Z', '2025-12-02T23:19:56.000Z', '2025-12-02T23:35:02.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Vilson da Silva Mayrink"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('35107c02-53d0-4e21-a7ad-8645a7362865', '5e24dd3f-f949-4962-8e7a-196d8dc7c767', '{"sub":"5e24dd3f-f949-4962-8e7a-196d8dc7c767","email":"vilson.mayrink@gmail.com","email_verified":true}', 'email', '5e24dd3f-f949-4962-8e7a-196d8dc7c767', '2025-12-02T23:19:56.000Z', '2025-12-02T23:35:02.000Z', '2025-12-02T23:35:03.000Z');
UPDATE public.profiles SET name = 'Vilson da Silva Mayrink', cpf = '80885187687', phone = '31992421943', company_id = 'eacd7080-2b72-4439-ad12-3db8ce76678d' WHERE user_id = '5e24dd3f-f949-4962-8e7a-196d8dc7c767';
UPDATE public.user_roles SET company_id = 'eacd7080-2b72-4439-ad12-3db8ce76678d' WHERE user_id = '5e24dd3f-f949-4962-8e7a-196d8dc7c767';

-- Marcos Flavio (mflaviocs@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('81e3e4f7-5e03-49e5-9a4e-14382ae5ad95', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'mflaviocs@gmail.com', '', '2025-12-02T23:19:59.000Z', '2025-12-02T23:19:59.000Z', '2025-12-02T23:26:38.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Marcos Flavio"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('ab87321f-ad06-4f7b-be6a-21892e8dd750', '81e3e4f7-5e03-49e5-9a4e-14382ae5ad95', '{"sub":"81e3e4f7-5e03-49e5-9a4e-14382ae5ad95","email":"mflaviocs@gmail.com","email_verified":true}', 'email', '81e3e4f7-5e03-49e5-9a4e-14382ae5ad95', '2025-12-02T23:19:59.000Z', '2025-12-02T23:26:38.000Z', '2025-12-02T23:26:38.000Z');
UPDATE public.profiles SET name = 'Marcos Flavio', cpf = '04593619610', phone = '31999056051', company_id = 'eacd7080-2b72-4439-ad12-3db8ce76678d' WHERE user_id = '81e3e4f7-5e03-49e5-9a4e-14382ae5ad95';
UPDATE public.user_roles SET company_id = 'eacd7080-2b72-4439-ad12-3db8ce76678d' WHERE user_id = '81e3e4f7-5e03-49e5-9a4e-14382ae5ad95';

-- LEONARDO CORREA CAMARGO (leocamargo@yahoo.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('73b773ba-95e2-494a-80ae-f89b250f7884', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'leocamargo@yahoo.com', '', '2025-12-02T23:20:18.000Z', '2025-12-02T23:20:18.000Z', '2025-12-02T23:39:21.000Z', '{"provider":"email","providers":["email"]}', '{"name":"LEONARDO CORREA CAMARGO"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('d9cf32a5-a371-4d76-a0d6-8e608d2fb7ba', '73b773ba-95e2-494a-80ae-f89b250f7884', '{"sub":"73b773ba-95e2-494a-80ae-f89b250f7884","email":"leocamargo@yahoo.com","email_verified":true}', 'email', '73b773ba-95e2-494a-80ae-f89b250f7884', '2025-12-02T23:20:18.000Z', '2025-12-02T23:39:21.000Z', '2025-12-02T23:39:21.000Z');
UPDATE public.profiles SET name = 'LEONARDO CORREA CAMARGO', cpf = '69477647691', phone = '31995721387', company_id = 'eacd7080-2b72-4439-ad12-3db8ce76678d' WHERE user_id = '73b773ba-95e2-494a-80ae-f89b250f7884';
UPDATE public.user_roles SET company_id = 'eacd7080-2b72-4439-ad12-3db8ce76678d' WHERE user_id = '73b773ba-95e2-494a-80ae-f89b250f7884';

-- João Augusto  (contato@uaiviajei.com.br) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('0a537f68-0485-4ccd-9628-5715ec52e092', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'contato@uaiviajei.com.br', '', '2025-12-02T23:20:21.000Z', '2025-12-02T23:20:21.000Z', '2025-12-03T17:25:03.000Z', '{"provider":"email","providers":["email"]}', '{"name":"João Augusto "}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('5f99b97c-6a2d-4a5d-862f-7bd21db0874e', '0a537f68-0485-4ccd-9628-5715ec52e092', '{"sub":"0a537f68-0485-4ccd-9628-5715ec52e092","email":"contato@uaiviajei.com.br","email_verified":true}', 'email', '0a537f68-0485-4ccd-9628-5715ec52e092', '2025-12-02T23:20:21.000Z', '2025-12-03T17:25:03.000Z', '2025-12-03T17:25:04.000Z');
UPDATE public.profiles SET name = 'João Augusto ', cpf = '08789574648', phone = '31991326834', company_id = 'eacd7080-2b72-4439-ad12-3db8ce76678d' WHERE user_id = '0a537f68-0485-4ccd-9628-5715ec52e092';
UPDATE public.user_roles SET company_id = 'eacd7080-2b72-4439-ad12-3db8ce76678d' WHERE user_id = '0a537f68-0485-4ccd-9628-5715ec52e092';

-- Joel Henrique de Souza Matos  (joel.souza@cdlbh.com.br) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('38da57bc-3081-498a-88f5-063381daff3f', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'joel.souza@cdlbh.com.br', '', '2025-12-02T23:21:39.000Z', '2025-12-02T23:21:39.000Z', '2025-12-02T23:42:13.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Joel Henrique de Souza Matos "}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('b3c1d095-bd81-4517-a4d3-c37b98af9c06', '38da57bc-3081-498a-88f5-063381daff3f', '{"sub":"38da57bc-3081-498a-88f5-063381daff3f","email":"joel.souza@cdlbh.com.br","email_verified":true}', 'email', '38da57bc-3081-498a-88f5-063381daff3f', '2025-12-02T23:21:39.000Z', '2025-12-02T23:42:13.000Z', '2025-12-02T23:42:13.000Z');
UPDATE public.profiles SET name = 'Joel Henrique de Souza Matos ', cpf = '01497793645', phone = '31992850092', company_id = 'eacd7080-2b72-4439-ad12-3db8ce76678d' WHERE user_id = '38da57bc-3081-498a-88f5-063381daff3f';
UPDATE public.user_roles SET company_id = 'eacd7080-2b72-4439-ad12-3db8ce76678d' WHERE user_id = '38da57bc-3081-498a-88f5-063381daff3f';

-- jose angelo de melo (joseangelo.melo@cdlbh.com.br) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('a2665fad-15c2-4206-a8bb-b0a740e1cff7', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'joseangelo.melo@cdlbh.com.br', '', '2025-12-02T23:21:41.000Z', '2025-12-02T23:21:41.000Z', '2025-12-02T23:39:23.000Z', '{"provider":"email","providers":["email"]}', '{"name":"jose angelo de melo"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('4d021883-710c-47f7-a3d8-563f8c18c470', 'a2665fad-15c2-4206-a8bb-b0a740e1cff7', '{"sub":"a2665fad-15c2-4206-a8bb-b0a740e1cff7","email":"joseangelo.melo@cdlbh.com.br","email_verified":true}', 'email', 'a2665fad-15c2-4206-a8bb-b0a740e1cff7', '2025-12-02T23:21:41.000Z', '2025-12-02T23:39:23.000Z', '2025-12-02T23:39:24.000Z');
UPDATE public.profiles SET name = 'jose angelo de melo', cpf = '37527274620', phone = '31999353060', company_id = 'eacd7080-2b72-4439-ad12-3db8ce76678d' WHERE user_id = 'a2665fad-15c2-4206-a8bb-b0a740e1cff7';
UPDATE public.user_roles SET company_id = 'eacd7080-2b72-4439-ad12-3db8ce76678d' WHERE user_id = 'a2665fad-15c2-4206-a8bb-b0a740e1cff7';

-- RODRIGO CHEIRICATTI DE CARVALHO  (rcheiricatti@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('b35eaa2c-0917-439f-9d3f-fbdb06c2fcc4', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'rcheiricatti@gmail.com', '', '2025-12-02T23:22:33.000Z', '2025-12-02T23:22:33.000Z', '2025-12-02T23:34:38.000Z', '{"provider":"email","providers":["email"]}', '{"name":"RODRIGO CHEIRICATTI DE CARVALHO "}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('99ef0f96-3a48-4099-ae4e-4c69c92ce2d7', 'b35eaa2c-0917-439f-9d3f-fbdb06c2fcc4', '{"sub":"b35eaa2c-0917-439f-9d3f-fbdb06c2fcc4","email":"rcheiricatti@gmail.com","email_verified":true}', 'email', 'b35eaa2c-0917-439f-9d3f-fbdb06c2fcc4', '2025-12-02T23:22:33.000Z', '2025-12-02T23:34:38.000Z', '2025-12-02T23:34:38.000Z');
UPDATE public.profiles SET name = 'RODRIGO CHEIRICATTI DE CARVALHO ', cpf = '03666282679', phone = '31984406999', company_id = 'eacd7080-2b72-4439-ad12-3db8ce76678d' WHERE user_id = 'b35eaa2c-0917-439f-9d3f-fbdb06c2fcc4';
UPDATE public.user_roles SET company_id = 'eacd7080-2b72-4439-ad12-3db8ce76678d' WHERE user_id = 'b35eaa2c-0917-439f-9d3f-fbdb06c2fcc4';

-- Breendon Costa (breendon.almeida@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('2f5c5fb9-0255-422b-9dfd-00cc04daab51', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'breendon.almeida@gmail.com', '', '2025-12-02T23:23:12.000Z', '2025-12-02T23:23:12.000Z', '2025-12-03T02:36:12.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Breendon Costa"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('d0dc4aaf-bc14-4ab8-a780-86a3a57368eb', '2f5c5fb9-0255-422b-9dfd-00cc04daab51', '{"sub":"2f5c5fb9-0255-422b-9dfd-00cc04daab51","email":"breendon.almeida@gmail.com","email_verified":true}', 'email', '2f5c5fb9-0255-422b-9dfd-00cc04daab51', '2025-12-02T23:23:12.000Z', '2025-12-03T02:36:12.000Z', '2025-12-03T02:36:12.000Z');
UPDATE public.profiles SET name = 'Breendon Costa', cpf = '03247424016', phone = '31984471012', company_id = 'eacd7080-2b72-4439-ad12-3db8ce76678d' WHERE user_id = '2f5c5fb9-0255-422b-9dfd-00cc04daab51';
UPDATE public.user_roles SET company_id = 'eacd7080-2b72-4439-ad12-3db8ce76678d' WHERE user_id = '2f5c5fb9-0255-422b-9dfd-00cc04daab51';

-- FLAVIO OLIVEIRA IZAC (flavioizac@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('dffded29-eb32-4de6-a67e-810a49820123', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'flavioizac@gmail.com', '', '2025-12-02T23:23:40.000Z', '2025-12-02T23:23:40.000Z', '2025-12-02T23:53:32.000Z', '{"provider":"email","providers":["email"]}', '{"name":"FLAVIO OLIVEIRA IZAC"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('e66bc698-a3a3-43f4-b43f-571d1e5e1b9f', 'dffded29-eb32-4de6-a67e-810a49820123', '{"sub":"dffded29-eb32-4de6-a67e-810a49820123","email":"flavioizac@gmail.com","email_verified":true}', 'email', 'dffded29-eb32-4de6-a67e-810a49820123', '2025-12-02T23:23:40.000Z', '2025-12-02T23:53:32.000Z', '2025-12-02T23:53:33.000Z');
UPDATE public.profiles SET name = 'FLAVIO OLIVEIRA IZAC', cpf = '07816578652', phone = '31995355247', company_id = 'eacd7080-2b72-4439-ad12-3db8ce76678d' WHERE user_id = 'dffded29-eb32-4de6-a67e-810a49820123';
UPDATE public.user_roles SET company_id = 'eacd7080-2b72-4439-ad12-3db8ce76678d' WHERE user_id = 'dffded29-eb32-4de6-a67e-810a49820123';

-- Bruno Sbraletta (bruno.sbraletta@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('53a54f47-57e9-43ce-b46a-3a90d9ec6cbb', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'bruno.sbraletta@gmail.com', '', '2025-12-02T23:25:04.000Z', '2025-12-02T23:25:04.000Z', '2025-12-03T15:06:49.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Bruno Sbraletta"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('045306d2-f0c4-4ab2-8528-da643aacfc18', '53a54f47-57e9-43ce-b46a-3a90d9ec6cbb', '{"sub":"53a54f47-57e9-43ce-b46a-3a90d9ec6cbb","email":"bruno.sbraletta@gmail.com","email_verified":true}', 'email', '53a54f47-57e9-43ce-b46a-3a90d9ec6cbb', '2025-12-02T23:25:04.000Z', '2025-12-03T15:06:49.000Z', '2025-12-03T15:06:49.000Z');
UPDATE public.profiles SET name = 'Bruno Sbraletta', cpf = '10967536693', phone = '31971260118', company_id = 'eacd7080-2b72-4439-ad12-3db8ce76678d' WHERE user_id = '53a54f47-57e9-43ce-b46a-3a90d9ec6cbb';
UPDATE public.user_roles SET company_id = 'eacd7080-2b72-4439-ad12-3db8ce76678d' WHERE user_id = '53a54f47-57e9-43ce-b46a-3a90d9ec6cbb';

-- Letícia  (hg.leticia@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('dcd90183-202e-4f81-bb6e-d355858674a4', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'hg.leticia@gmail.com', '', '2025-12-02T23:29:10.000Z', '2025-12-02T23:29:10.000Z', '2025-12-02T23:52:42.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Letícia "}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('b63d4f13-ecba-4d1c-a38f-5b865455d5d5', 'dcd90183-202e-4f81-bb6e-d355858674a4', '{"sub":"dcd90183-202e-4f81-bb6e-d355858674a4","email":"hg.leticia@gmail.com","email_verified":true}', 'email', 'dcd90183-202e-4f81-bb6e-d355858674a4', '2025-12-02T23:29:10.000Z', '2025-12-02T23:52:42.000Z', '2025-12-02T23:52:42.000Z');
UPDATE public.profiles SET name = 'Letícia ', cpf = '11068032642', phone = '31997575605', company_id = 'eacd7080-2b72-4439-ad12-3db8ce76678d' WHERE user_id = 'dcd90183-202e-4f81-bb6e-d355858674a4';
UPDATE public.user_roles SET company_id = 'eacd7080-2b72-4439-ad12-3db8ce76678d' WHERE user_id = 'dcd90183-202e-4f81-bb6e-d355858674a4';

-- Lucas  (lucaspitta@targetfroras.com.br) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('41605deb-0233-40f6-8444-5dcbf34d246e', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'lucaspitta@targetfroras.com.br', '', '2025-12-02T23:32:16.000Z', '2025-12-02T23:32:16.000Z', '2025-12-03T00:55:01.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Lucas "}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('3403fcf2-a6b8-47e4-8262-a56ccb0a3cc1', '41605deb-0233-40f6-8444-5dcbf34d246e', '{"sub":"41605deb-0233-40f6-8444-5dcbf34d246e","email":"lucaspitta@targetfroras.com.br","email_verified":true}', 'email', '41605deb-0233-40f6-8444-5dcbf34d246e', '2025-12-02T23:32:16.000Z', '2025-12-03T00:55:01.000Z', '2025-12-03T00:55:01.000Z');
UPDATE public.profiles SET name = 'Lucas ', cpf = '03977395670', phone = '31993071013', company_id = 'eacd7080-2b72-4439-ad12-3db8ce76678d' WHERE user_id = '41605deb-0233-40f6-8444-5dcbf34d246e';
UPDATE public.user_roles SET company_id = 'eacd7080-2b72-4439-ad12-3db8ce76678d' WHERE user_id = '41605deb-0233-40f6-8444-5dcbf34d246e';

-- Ana Luísa Assis Arrunátegui (ana.arrunategui@buffalodigital.com.br) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('9fed1101-ee61-4e05-82e3-dfa35afaf7d3', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'ana.arrunategui@buffalodigital.com.br', '', '2025-12-03T20:46:57.000Z', '2025-12-03T20:46:57.000Z', '2025-12-03T20:46:57.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Ana Luísa Assis Arrunátegui"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('739bf4b7-2408-4d85-b1ea-4065713c747d', '9fed1101-ee61-4e05-82e3-dfa35afaf7d3', '{"sub":"9fed1101-ee61-4e05-82e3-dfa35afaf7d3","email":"ana.arrunategui@buffalodigital.com.br","email_verified":true}', 'email', '9fed1101-ee61-4e05-82e3-dfa35afaf7d3', '2025-12-03T20:46:57.000Z', '2025-12-03T20:46:57.000Z', '2025-12-03T20:46:57.000Z');
UPDATE public.profiles SET name = 'Ana Luísa Assis Arrunátegui', cpf = '111.066.766.37', phone = '31-99661-3864', company_id = 'e7e206de-3ae7-46a9-a48a-4ae882ee2a18', department_id = 'bbfd200b-c39c-4421-8e1a-a339f83aa023' WHERE user_id = '9fed1101-ee61-4e05-82e3-dfa35afaf7d3';
UPDATE public.user_roles SET company_id = 'e7e206de-3ae7-46a9-a48a-4ae882ee2a18' WHERE user_id = '9fed1101-ee61-4e05-82e3-dfa35afaf7d3';

-- Ana Paula Souza Teixeira (ana.souza@buffalodigital.com.br) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('11e20c23-c79b-4b52-9d96-5c0989957c26', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'ana.souza@buffalodigital.com.br', '', '2025-12-03T20:48:15.000Z', '2025-12-03T20:48:15.000Z', '2025-12-18T17:05:03.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Ana Paula Souza Teixeira"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('30f801ea-3712-43bf-8e40-cfc06259f300', '11e20c23-c79b-4b52-9d96-5c0989957c26', '{"sub":"11e20c23-c79b-4b52-9d96-5c0989957c26","email":"ana.souza@buffalodigital.com.br","email_verified":true}', 'email', '11e20c23-c79b-4b52-9d96-5c0989957c26', '2025-12-03T20:48:15.000Z', '2025-12-18T17:05:03.000Z', '2025-12-18T17:05:04.000Z');
UPDATE public.profiles SET name = 'Ana Paula Souza Teixeira', cpf = '114.192.336-02', phone = '31992963605', company_id = 'e7e206de-3ae7-46a9-a48a-4ae882ee2a18', department_id = '81a21bc3-aae9-41dd-88fa-b326f460cd32' WHERE user_id = '11e20c23-c79b-4b52-9d96-5c0989957c26';
UPDATE public.user_roles SET company_id = 'e7e206de-3ae7-46a9-a48a-4ae882ee2a18' WHERE user_id = '11e20c23-c79b-4b52-9d96-5c0989957c26';

-- Anderson Bazilio Monte Rei (andy.monterei@buffalodigital.com.br) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('7e408b5d-4b05-4556-a852-ac900f92e92c', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'andy.monterei@buffalodigital.com.br', '', '2025-12-03T20:49:03.000Z', '2025-12-03T20:49:03.000Z', '2025-12-04T21:25:52.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Anderson Bazilio Monte Rei"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('4babed2a-447e-4996-8e0a-b5701cab364e', '7e408b5d-4b05-4556-a852-ac900f92e92c', '{"sub":"7e408b5d-4b05-4556-a852-ac900f92e92c","email":"andy.monterei@buffalodigital.com.br","email_verified":true}', 'email', '7e408b5d-4b05-4556-a852-ac900f92e92c', '2025-12-03T20:49:03.000Z', '2025-12-04T21:25:52.000Z', '2025-12-04T21:25:51.000Z');
UPDATE public.profiles SET name = 'Anderson Bazilio Monte Rei', cpf = '405.772.418-14', phone = '16992416963', company_id = 'e7e206de-3ae7-46a9-a48a-4ae882ee2a18', department_id = '04225d06-eca4-4fac-824a-33bd16e20d99' WHERE user_id = '7e408b5d-4b05-4556-a852-ac900f92e92c';
UPDATE public.user_roles SET company_id = 'e7e206de-3ae7-46a9-a48a-4ae882ee2a18' WHERE user_id = '7e408b5d-4b05-4556-a852-ac900f92e92c';

-- André Proença Doyle Oliva (andre.doyle@buffalodigital.com.br) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('82b0f575-9100-471a-a841-9e34a94cd777', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'andre.doyle@buffalodigital.com.br', '', '2025-12-03T20:49:53.000Z', '2025-12-03T20:49:53.000Z', '2025-12-16T07:18:23.000Z', '{"provider":"email","providers":["email"]}', '{"name":"André Proença Doyle Oliva"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('fe916320-f5f0-48cb-a5d0-8f774389e88e', '82b0f575-9100-471a-a841-9e34a94cd777', '{"sub":"82b0f575-9100-471a-a841-9e34a94cd777","email":"andre.doyle@buffalodigital.com.br","email_verified":true}', 'email', '82b0f575-9100-471a-a841-9e34a94cd777', '2025-12-03T20:49:53.000Z', '2025-12-16T07:18:23.000Z', '2025-12-16T07:18:23.000Z');
UPDATE public.profiles SET name = 'André Proença Doyle Oliva', cpf = '054.318.066-29', phone = '31988283811', company_id = 'e7e206de-3ae7-46a9-a48a-4ae882ee2a18', department_id = '65b7220c-3bd4-4b1f-9186-310a7641e0b9' WHERE user_id = '82b0f575-9100-471a-a841-9e34a94cd777';
UPDATE public.user_roles SET company_id = 'e7e206de-3ae7-46a9-a48a-4ae882ee2a18' WHERE user_id = '82b0f575-9100-471a-a841-9e34a94cd777';

-- Filippe Nilo Souza Leite (filippe.leite@buffalodigital.com.br) | Role: company_admin
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('2000fd5a-3050-4069-9b88-701a92b8b835', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'filippe.leite@buffalodigital.com.br', '', '2025-12-03T20:51:11.000Z', '2025-12-03T20:51:11.000Z', '2025-12-15T15:31:53.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Filippe Nilo Souza Leite"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('8e868eeb-6409-404b-98ad-b1ef616a57b4', '2000fd5a-3050-4069-9b88-701a92b8b835', '{"sub":"2000fd5a-3050-4069-9b88-701a92b8b835","email":"filippe.leite@buffalodigital.com.br","email_verified":true}', 'email', '2000fd5a-3050-4069-9b88-701a92b8b835', '2025-12-03T20:51:11.000Z', '2025-12-15T15:31:53.000Z', '2025-12-15T15:31:54.000Z');
UPDATE public.profiles SET name = 'Filippe Nilo Souza Leite', cpf = '080.605.626-65', phone = '31983092244', company_id = 'e7e206de-3ae7-46a9-a48a-4ae882ee2a18', department_id = '65b7220c-3bd4-4b1f-9186-310a7641e0b9' WHERE user_id = '2000fd5a-3050-4069-9b88-701a92b8b835';
UPDATE public.user_roles SET role = 'company_admin'::public.app_role, company_id = 'e7e206de-3ae7-46a9-a48a-4ae882ee2a18' WHERE user_id = '2000fd5a-3050-4069-9b88-701a92b8b835';

-- Francis William Oliveira da Silva (francis.willian@buffalodigital.com.br) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('a73b29c5-2def-44c8-9154-3b92eaa0aff2', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'francis.willian@buffalodigital.com.br', '', '2025-12-03T20:52:33.000Z', '2025-12-03T20:52:33.000Z', '2025-12-11T15:37:55.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Francis William Oliveira da Silva"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('ad4cab07-458c-4585-a74e-e0dccd2dd614', 'a73b29c5-2def-44c8-9154-3b92eaa0aff2', '{"sub":"a73b29c5-2def-44c8-9154-3b92eaa0aff2","email":"francis.willian@buffalodigital.com.br","email_verified":true}', 'email', 'a73b29c5-2def-44c8-9154-3b92eaa0aff2', '2025-12-03T20:52:33.000Z', '2025-12-11T15:37:55.000Z', '2025-12-11T15:37:56.000Z');
UPDATE public.profiles SET name = 'Francis William Oliveira da Silva', cpf = '084.368.596-42', phone = '31995474697', company_id = 'e7e206de-3ae7-46a9-a48a-4ae882ee2a18', department_id = 'be462833-5d3d-4ab0-92bb-6cd716cbbcba' WHERE user_id = 'a73b29c5-2def-44c8-9154-3b92eaa0aff2';
UPDATE public.user_roles SET company_id = 'e7e206de-3ae7-46a9-a48a-4ae882ee2a18' WHERE user_id = 'a73b29c5-2def-44c8-9154-3b92eaa0aff2';

-- Jordana Ferreira Vieira de Souza (jordana.ferreira@buffalodigital.com.br) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('204a1a9f-b3bb-4245-a50d-572173ec0e2a', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'jordana.ferreira@buffalodigital.com.br', '', '2025-12-03T20:55:45.000Z', '2025-12-03T20:55:45.000Z', '2025-12-12T15:54:39.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Jordana Ferreira Vieira de Souza"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('3195ce39-d157-404a-98b9-e0c42d7ffc47', '204a1a9f-b3bb-4245-a50d-572173ec0e2a', '{"sub":"204a1a9f-b3bb-4245-a50d-572173ec0e2a","email":"jordana.ferreira@buffalodigital.com.br","email_verified":true}', 'email', '204a1a9f-b3bb-4245-a50d-572173ec0e2a', '2025-12-03T20:55:45.000Z', '2025-12-12T15:54:39.000Z', '2025-12-12T15:54:37.000Z');
UPDATE public.profiles SET name = 'Jordana Ferreira Vieira de Souza', cpf = '149.168.097-00', phone = '32984244050', company_id = 'e7e206de-3ae7-46a9-a48a-4ae882ee2a18', department_id = '3cf6b9ad-721d-4474-8507-da7878aac2a2' WHERE user_id = '204a1a9f-b3bb-4245-a50d-572173ec0e2a';
UPDATE public.user_roles SET company_id = 'e7e206de-3ae7-46a9-a48a-4ae882ee2a18' WHERE user_id = '204a1a9f-b3bb-4245-a50d-572173ec0e2a';

-- Larissa Soares Rios (larissa.soares@buffalodigital.com.br) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('12106458-a0c2-4698-86ea-3c6d014a9b9e', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'larissa.soares@buffalodigital.com.br', '', '2025-12-03T20:56:43.000Z', '2025-12-03T20:56:43.000Z', '2025-12-04T20:53:48.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Larissa Soares Rios"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('4e842bf4-5813-4c79-af73-70f6b210a491', '12106458-a0c2-4698-86ea-3c6d014a9b9e', '{"sub":"12106458-a0c2-4698-86ea-3c6d014a9b9e","email":"larissa.soares@buffalodigital.com.br","email_verified":true}', 'email', '12106458-a0c2-4698-86ea-3c6d014a9b9e', '2025-12-03T20:56:43.000Z', '2025-12-04T20:53:48.000Z', '2025-12-04T20:53:49.000Z');
UPDATE public.profiles SET name = 'Larissa Soares Rios', cpf = '134.171.096-39', phone = '31993554953', company_id = 'e7e206de-3ae7-46a9-a48a-4ae882ee2a18', department_id = 'bbfd200b-c39c-4421-8e1a-a339f83aa023' WHERE user_id = '12106458-a0c2-4698-86ea-3c6d014a9b9e';
UPDATE public.user_roles SET company_id = 'e7e206de-3ae7-46a9-a48a-4ae882ee2a18' WHERE user_id = '12106458-a0c2-4698-86ea-3c6d014a9b9e';

-- Lucas dos Santos Vilas Boas (lucas.vilasboas@buffalodigital.com.br) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('eacac9ca-78a0-48c5-91f1-447253a14d97', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'lucas.vilasboas@buffalodigital.com.br', '', '2025-12-03T20:57:36.000Z', '2025-12-03T20:57:36.000Z', '2025-12-12T22:15:45.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Lucas dos Santos Vilas Boas"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('c904c9bf-1e51-4b0d-b8ec-cc6173897fdc', 'eacac9ca-78a0-48c5-91f1-447253a14d97', '{"sub":"eacac9ca-78a0-48c5-91f1-447253a14d97","email":"lucas.vilasboas@buffalodigital.com.br","email_verified":true}', 'email', 'eacac9ca-78a0-48c5-91f1-447253a14d97', '2025-12-03T20:57:36.000Z', '2025-12-12T22:15:45.000Z', '2025-12-12T22:15:46.000Z');
UPDATE public.profiles SET name = 'Lucas dos Santos Vilas Boas', cpf = '380.015.338-67', phone = '19992554041', company_id = 'e7e206de-3ae7-46a9-a48a-4ae882ee2a18', department_id = 'be462833-5d3d-4ab0-92bb-6cd716cbbcba' WHERE user_id = 'eacac9ca-78a0-48c5-91f1-447253a14d97';
UPDATE public.user_roles SET company_id = 'e7e206de-3ae7-46a9-a48a-4ae882ee2a18' WHERE user_id = 'eacac9ca-78a0-48c5-91f1-447253a14d97';

-- Mayra Hitomi Abeki de Oliveira (mayra.abeki@buffalodigital.com.br) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('755a2456-6806-4d18-8dcc-6a1c4f49517f', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'mayra.abeki@buffalodigital.com.br', '', '2025-12-03T20:58:28.000Z', '2025-12-03T20:58:28.000Z', '2026-01-25T06:55:49.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Mayra Hitomi Abeki de Oliveira"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('75b45f84-268c-4728-9593-f6f7437902d3', '755a2456-6806-4d18-8dcc-6a1c4f49517f', '{"sub":"755a2456-6806-4d18-8dcc-6a1c4f49517f","email":"mayra.abeki@buffalodigital.com.br","email_verified":true}', 'email', '755a2456-6806-4d18-8dcc-6a1c4f49517f', '2025-12-03T20:58:28.000Z', '2026-01-25T06:55:49.000Z', '2026-01-25T06:55:50.000Z');
UPDATE public.profiles SET name = 'Mayra Hitomi Abeki de Oliveira', cpf = '082.573.946-29', phone = '31993196062', company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '755a2456-6806-4d18-8dcc-6a1c4f49517f';
UPDATE public.user_roles SET company_id = 'cef65338-e661-4197-b9d0-798c41cca1d9' WHERE user_id = '755a2456-6806-4d18-8dcc-6a1c4f49517f';

-- Patricia de Oliveira e Silva (patricia.oliveira@buffalodigital.com.br) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('b9a064e5-20d3-4677-a40c-bdcc0ff28d86', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'patricia.oliveira@buffalodigital.com.br', '', '2025-12-03T20:59:28.000Z', '2025-12-03T20:59:28.000Z', '2025-12-04T01:30:47.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Patricia de Oliveira e Silva"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('38472f0e-c990-462a-b0e8-2049f4119517', 'b9a064e5-20d3-4677-a40c-bdcc0ff28d86', '{"sub":"b9a064e5-20d3-4677-a40c-bdcc0ff28d86","email":"patricia.oliveira@buffalodigital.com.br","email_verified":true}', 'email', 'b9a064e5-20d3-4677-a40c-bdcc0ff28d86', '2025-12-03T20:59:28.000Z', '2025-12-04T01:30:47.000Z', '2025-12-04T01:30:47.000Z');
UPDATE public.profiles SET name = 'Patricia de Oliveira e Silva', cpf = '780.321.996-91', phone = '31987483407', company_id = 'e7e206de-3ae7-46a9-a48a-4ae882ee2a18', department_id = 'ac3fae2d-4a9f-4221-9620-d78341cf3565' WHERE user_id = 'b9a064e5-20d3-4677-a40c-bdcc0ff28d86';
UPDATE public.user_roles SET company_id = 'e7e206de-3ae7-46a9-a48a-4ae882ee2a18' WHERE user_id = 'b9a064e5-20d3-4677-a40c-bdcc0ff28d86';

-- Rafael Guilherme de Sousa (rafael.guilherme@buffalodigital.com.br) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('5b4d4c20-ff40-4055-971f-cf9551421506', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'rafael.guilherme@buffalodigital.com.br', '', '2025-12-03T21:01:31.000Z', '2025-12-03T21:01:31.000Z', '2025-12-16T16:31:16.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Rafael Guilherme de Sousa"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('330118b5-5f38-49ce-928b-c12016d6304e', '5b4d4c20-ff40-4055-971f-cf9551421506', '{"sub":"5b4d4c20-ff40-4055-971f-cf9551421506","email":"rafael.guilherme@buffalodigital.com.br","email_verified":true}', 'email', '5b4d4c20-ff40-4055-971f-cf9551421506', '2025-12-03T21:01:31.000Z', '2025-12-16T16:31:16.000Z', '2025-12-16T16:31:16.000Z');
UPDATE public.profiles SET name = 'Rafael Guilherme de Sousa', cpf = '115.359.346-70', phone = '37991796090', company_id = 'e7e206de-3ae7-46a9-a48a-4ae882ee2a18', department_id = '3cf6b9ad-721d-4474-8507-da7878aac2a2' WHERE user_id = '5b4d4c20-ff40-4055-971f-cf9551421506';
UPDATE public.user_roles SET company_id = 'e7e206de-3ae7-46a9-a48a-4ae882ee2a18' WHERE user_id = '5b4d4c20-ff40-4055-971f-cf9551421506';

-- Samira Dias Ribeiro (samira.dias@buffalodigital.com.br) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('a01fef30-7d6c-4f08-8519-ff95fed19a25', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'samira.dias@buffalodigital.com.br', '', '2025-12-03T21:02:39.000Z', '2025-12-03T21:02:39.000Z', '2025-12-04T15:53:25.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Samira Dias Ribeiro"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('63626dd4-631d-4537-aee2-1e1d570e7a10', 'a01fef30-7d6c-4f08-8519-ff95fed19a25', '{"sub":"a01fef30-7d6c-4f08-8519-ff95fed19a25","email":"samira.dias@buffalodigital.com.br","email_verified":true}', 'email', 'a01fef30-7d6c-4f08-8519-ff95fed19a25', '2025-12-03T21:02:39.000Z', '2025-12-04T15:53:25.000Z', '2025-12-04T15:53:25.000Z');
UPDATE public.profiles SET name = 'Samira Dias Ribeiro', cpf = '112.864.466-51', phone = '31998197789', company_id = 'e7e206de-3ae7-46a9-a48a-4ae882ee2a18', department_id = '93fa9604-65d6-47c2-990f-ca834c20486d' WHERE user_id = 'a01fef30-7d6c-4f08-8519-ff95fed19a25';
UPDATE public.user_roles SET company_id = 'e7e206de-3ae7-46a9-a48a-4ae882ee2a18' WHERE user_id = 'a01fef30-7d6c-4f08-8519-ff95fed19a25';

-- Thais Elisa Barbian de Souza (thais.barbian@buffalodigital.com.br) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('6204455f-d074-4682-8701-79a3239ed42f', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'thais.barbian@buffalodigital.com.br', '', '2025-12-03T21:03:33.000Z', '2025-12-03T21:03:33.000Z', '2025-12-04T01:19:26.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Thais Elisa Barbian de Souza"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('2c4405ec-349a-4e36-a7b3-fc34299462e1', '6204455f-d074-4682-8701-79a3239ed42f', '{"sub":"6204455f-d074-4682-8701-79a3239ed42f","email":"thais.barbian@buffalodigital.com.br","email_verified":true}', 'email', '6204455f-d074-4682-8701-79a3239ed42f', '2025-12-03T21:03:33.000Z', '2025-12-04T01:19:26.000Z', '2025-12-04T01:19:26.000Z');
UPDATE public.profiles SET name = 'Thais Elisa Barbian de Souza', cpf = '089.133.046-19', phone = '31998068202', company_id = 'e7e206de-3ae7-46a9-a48a-4ae882ee2a18', department_id = '81a21bc3-aae9-41dd-88fa-b326f460cd32' WHERE user_id = '6204455f-d074-4682-8701-79a3239ed42f';
UPDATE public.user_roles SET company_id = 'e7e206de-3ae7-46a9-a48a-4ae882ee2a18' WHERE user_id = '6204455f-d074-4682-8701-79a3239ed42f';

-- Claudio Moura Batitucci (claudio.batitucci@partners360.com.br) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('7c4d012d-5a6b-4deb-ac8b-0105e1366cbc', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'claudio.batitucci@partners360.com.br', '', '2025-12-08T13:57:52.000Z', '2025-12-08T13:57:52.000Z', '2025-12-08T15:36:09.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Claudio Moura Batitucci"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('d11ea868-1b77-4b43-afc6-0548485069ff', '7c4d012d-5a6b-4deb-ac8b-0105e1366cbc', '{"sub":"7c4d012d-5a6b-4deb-ac8b-0105e1366cbc","email":"claudio.batitucci@partners360.com.br","email_verified":true}', 'email', '7c4d012d-5a6b-4deb-ac8b-0105e1366cbc', '2025-12-08T13:57:52.000Z', '2025-12-08T15:36:09.000Z', '2025-12-08T15:36:08.000Z');
UPDATE public.profiles SET name = 'Claudio Moura Batitucci', cpf = '81640226672', phone = '31997370505', company_id = '8cd3d8c7-6816-4e93-bdff-4acb1d4aeb45' WHERE user_id = '7c4d012d-5a6b-4deb-ac8b-0105e1366cbc';
UPDATE public.user_roles SET company_id = '8cd3d8c7-6816-4e93-bdff-4acb1d4aeb45' WHERE user_id = '7c4d012d-5a6b-4deb-ac8b-0105e1366cbc';

-- Ana luisa assis arrunategui (analuisaarrunategui@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('ab8ab50a-feb6-47f4-be1a-1e0af02b7b3a', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'analuisaarrunategui@gmail.com', '', '2025-12-09T22:51:33.000Z', '2025-12-09T22:51:33.000Z', '2025-12-09T23:11:18.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Ana luisa assis arrunategui"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('73191c39-2e11-4fa5-9f8e-b19c806808c9', 'ab8ab50a-feb6-47f4-be1a-1e0af02b7b3a', '{"sub":"ab8ab50a-feb6-47f4-be1a-1e0af02b7b3a","email":"analuisaarrunategui@gmail.com","email_verified":true}', 'email', 'ab8ab50a-feb6-47f4-be1a-1e0af02b7b3a', '2025-12-09T22:51:33.000Z', '2025-12-09T23:11:18.000Z', '2025-12-09T23:11:18.000Z');
UPDATE public.profiles SET name = 'Ana luisa assis arrunategui', cpf = '11106676637', phone = '31983353315', company_id = 'e7e206de-3ae7-46a9-a48a-4ae882ee2a18', department_id = 'bbfd200b-c39c-4421-8e1a-a339f83aa023' WHERE user_id = 'ab8ab50a-feb6-47f4-be1a-1e0af02b7b3a';
UPDATE public.user_roles SET company_id = 'e7e206de-3ae7-46a9-a48a-4ae882ee2a18' WHERE user_id = 'ab8ab50a-feb6-47f4-be1a-1e0af02b7b3a';

-- Clayton Lisboa (clayton.lisboa@buffalodigital.com.br) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('85ea9de4-1f8c-4620-8506-c7957d71b92e', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'clayton.lisboa@buffalodigital.com.br', '', '2025-12-10T15:28:57.000Z', '2025-12-10T15:28:57.000Z', '2025-12-10T15:46:38.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Clayton Lisboa"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('948ee046-cca0-4051-817b-7fa412dcfccd', '85ea9de4-1f8c-4620-8506-c7957d71b92e', '{"sub":"85ea9de4-1f8c-4620-8506-c7957d71b92e","email":"clayton.lisboa@buffalodigital.com.br","email_verified":true}', 'email', '85ea9de4-1f8c-4620-8506-c7957d71b92e', '2025-12-10T15:28:57.000Z', '2025-12-10T15:46:38.000Z', '2025-12-10T15:46:39.000Z');
UPDATE public.profiles SET name = 'Clayton Lisboa', cpf = '11212453662', phone = '31973549980', company_id = 'e7e206de-3ae7-46a9-a48a-4ae882ee2a18', department_id = '5a9501e6-0f30-4ec8-bcab-d8220ed6d14d' WHERE user_id = '85ea9de4-1f8c-4620-8506-c7957d71b92e';
UPDATE public.user_roles SET company_id = 'e7e206de-3ae7-46a9-a48a-4ae882ee2a18' WHERE user_id = '85ea9de4-1f8c-4620-8506-c7957d71b92e';

-- Bruno Henrique Rezende (bruno.henrique@repetreciclagem.com.br) | Role: company_admin
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('df4743d0-67ce-4624-b142-db70a636e61a', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'bruno.henrique@repetreciclagem.com.br', '', '2025-12-11T16:20:45.000Z', '2025-12-11T16:20:45.000Z', '2025-12-11T16:20:45.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Bruno Henrique Rezende"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('659ce459-2e2b-46b2-a16e-6826c221622b', 'df4743d0-67ce-4624-b142-db70a636e61a', '{"sub":"df4743d0-67ce-4624-b142-db70a636e61a","email":"bruno.henrique@repetreciclagem.com.br","email_verified":true}', 'email', 'df4743d0-67ce-4624-b142-db70a636e61a', '2025-12-11T16:20:45.000Z', '2025-12-11T16:20:45.000Z', '2025-12-11T16:20:45.000Z');
UPDATE public.profiles SET name = 'Bruno Henrique Rezende', cpf = '03814542665', phone = '31995000184', company_id = '85301977-54f4-43ad-b3ae-d812cb5587c6' WHERE user_id = 'df4743d0-67ce-4624-b142-db70a636e61a';
UPDATE public.user_roles SET role = 'company_admin'::public.app_role, company_id = '85301977-54f4-43ad-b3ae-d812cb5587c6' WHERE user_id = 'df4743d0-67ce-4624-b142-db70a636e61a';

-- Nicholson Pimentel (np@healthsafetytech.com) | Role: company_admin
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('b8f712c6-defb-4b3a-957e-1067b837aa78', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'np@healthsafetytech.com', '', '2025-12-15T23:06:22.000Z', '2025-12-15T23:06:22.000Z', '2026-01-23T22:47:20.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Nicholson Pimentel"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('a9ba2280-c7c8-4f90-a610-f15cd293d9d0', 'b8f712c6-defb-4b3a-957e-1067b837aa78', '{"sub":"b8f712c6-defb-4b3a-957e-1067b837aa78","email":"np@healthsafetytech.com","email_verified":true}', 'email', 'b8f712c6-defb-4b3a-957e-1067b837aa78', '2025-12-15T23:06:22.000Z', '2026-01-23T22:47:20.000Z', '2026-01-23T22:47:20.000Z');
UPDATE public.profiles SET name = 'Nicholson Pimentel', cpf = '02153079411', phone = '81 8844-1145', company_id = '5dc0d6af-ea86-43cb-ab1d-3b231de50834' WHERE user_id = 'b8f712c6-defb-4b3a-957e-1067b837aa78';
UPDATE public.user_roles SET role = 'company_admin'::public.app_role, company_id = '5dc0d6af-ea86-43cb-ab1d-3b231de50834' WHERE user_id = 'b8f712c6-defb-4b3a-957e-1067b837aa78';

-- Alexsandra Rodrigues Matos (alexsandrarmatos@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('6943316e-bd51-46b8-bb12-17e59599d00f', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'alexsandrarmatos@gmail.com', '', '2025-12-18T00:28:15.000Z', '2025-12-18T00:28:15.000Z', '2026-01-06T04:21:36.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Alexsandra Rodrigues Matos"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('b59cff3c-064b-4132-90f3-172a2f40160a', '6943316e-bd51-46b8-bb12-17e59599d00f', '{"sub":"6943316e-bd51-46b8-bb12-17e59599d00f","email":"alexsandrarmatos@gmail.com","email_verified":true}', 'email', '6943316e-bd51-46b8-bb12-17e59599d00f', '2025-12-18T00:28:15.000Z', '2026-01-06T04:21:36.000Z', '2025-12-18T01:02:05.000Z');
UPDATE public.profiles SET name = 'Alexsandra Rodrigues Matos', cpf = '12657408605', phone = '31991111739', company_id = '676787b8-c5ab-4211-a54d-7ed10769011e' WHERE user_id = '6943316e-bd51-46b8-bb12-17e59599d00f';
UPDATE public.user_roles SET company_id = '676787b8-c5ab-4211-a54d-7ed10769011e' WHERE user_id = '6943316e-bd51-46b8-bb12-17e59599d00f';

-- Alexa Carvalho (alexa@etcetal.com.br) | Role: company_admin
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('dea8e23f-6c94-419f-b743-b944bc965a90', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'alexa@etcetal.com.br', '', '2026-01-05T17:01:18.000Z', '2026-01-05T17:01:18.000Z', '2026-02-03T15:05:46.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Alexa Carvalho"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('3755779b-5287-4c87-a8f6-92bc4a561264', 'dea8e23f-6c94-419f-b743-b944bc965a90', '{"sub":"dea8e23f-6c94-419f-b743-b944bc965a90","email":"alexa@etcetal.com.br","email_verified":true}', 'email', 'dea8e23f-6c94-419f-b743-b944bc965a90', '2026-01-05T17:01:18.000Z', '2026-02-03T15:05:46.000Z', '2026-02-03T15:05:47.000Z');
UPDATE public.profiles SET name = 'Alexa Carvalho', cpf = '758.184.506-00', phone = '(31) 99116-5380', company_id = 'edea5e96-20ea-40a8-8cb8-0988cd74869c' WHERE user_id = 'dea8e23f-6c94-419f-b743-b944bc965a90';
UPDATE public.user_roles SET role = 'company_admin'::public.app_role, company_id = 'edea5e96-20ea-40a8-8cb8-0988cd74869c' WHERE user_id = 'dea8e23f-6c94-419f-b743-b944bc965a90';

-- Lidisay Sena (adm01@healthsafetytech.com) | Role: leader
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('018b0fe6-1b73-4fa9-a471-375445cef46e', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'adm01@healthsafetytech.com', '', '2026-01-13T21:54:30.000Z', '2026-01-13T21:54:30.000Z', '2026-01-23T17:52:31.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Lidisay Sena"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('b0df70b6-d818-42bf-872e-6547251a1388', '018b0fe6-1b73-4fa9-a471-375445cef46e', '{"sub":"018b0fe6-1b73-4fa9-a471-375445cef46e","email":"adm01@healthsafetytech.com","email_verified":true}', 'email', '018b0fe6-1b73-4fa9-a471-375445cef46e', '2026-01-13T21:54:30.000Z', '2026-01-23T17:52:31.000Z', '2026-01-22T20:47:16.000Z');
UPDATE public.profiles SET name = 'Lidisay Sena', cpf = '08162660429', phone = '81998817938', company_id = '5dc0d6af-ea86-43cb-ab1d-3b231de50834', department_id = '9a6e766e-20d9-440e-8171-ae6eb4423c67' WHERE user_id = '018b0fe6-1b73-4fa9-a471-375445cef46e';
UPDATE public.user_roles SET role = 'leader'::public.app_role, company_id = '5dc0d6af-ea86-43cb-ab1d-3b231de50834' WHERE user_id = '018b0fe6-1b73-4fa9-a471-375445cef46e';

-- Hylde Rosa (hylderosa@gmail.com) | Role: user
INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, created_at, updated_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, confirmation_token, recovery_token)
VALUES ('1a8468e8-cc6c-481c-9278-90a293d48e85', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'hylderosa@gmail.com', '', '2026-01-14T00:10:29.000Z', '2026-01-14T00:10:29.000Z', '2026-01-14T00:17:35.000Z', '{"provider":"email","providers":["email"]}', '{"name":"Hylde Rosa"}', false, '', '');
INSERT INTO auth.identities (id, user_id, identity_data, provider, provider_id, created_at, updated_at, last_sign_in_at)
VALUES ('90fa0952-b63f-400c-b6f3-c5577c221c36', '1a8468e8-cc6c-481c-9278-90a293d48e85', '{"sub":"1a8468e8-cc6c-481c-9278-90a293d48e85","email":"hylderosa@gmail.com","email_verified":true}', 'email', '1a8468e8-cc6c-481c-9278-90a293d48e85', '2026-01-14T00:10:29.000Z', '2026-01-14T00:17:35.000Z', '2026-01-14T00:17:35.000Z');
UPDATE public.profiles SET name = 'Hylde Rosa', cpf = '88799743787', phone = '11990238688', company_id = 'edea5e96-20ea-40a8-8cb8-0988cd74869c' WHERE user_id = '1a8468e8-cc6c-481c-9278-90a293d48e85';
UPDATE public.user_roles SET company_id = 'edea5e96-20ea-40a8-8cb8-0988cd74869c' WHERE user_id = '1a8468e8-cc6c-481c-9278-90a293d48e85';
