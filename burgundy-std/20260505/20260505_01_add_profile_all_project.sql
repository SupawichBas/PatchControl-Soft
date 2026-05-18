
INSERT INTO su_profile
(profile_code, description, active, created_by, created_date, created_program, updated_by, updated_date, updated_program, profiletype)
VALUES('ADMIN_PROJECT', 'Setup Projects For ADMIN (SMDBRT14)', true, 'Script', current_timestamp, 'Script', NULL, NULL, NULL, 'Document');



INSERT INTO su_profile_menu
(profile_code, menu_code, created_by, created_date, created_program, updated_by, updated_date, updated_program, active)
VALUES('ADMIN_PROJECT', 'M0000800075', 'Script', '2026-05-05 10:36:00.466', 'Migrate', NULL, NULL, NULL, true);

INSERT INTO su_profile_menu
(profile_code, menu_code, created_by, created_date, created_program, updated_by, updated_date, updated_program, active)
VALUES('ADMIN_PROJECT', 'M00008', 'Script', '2026-05-05 10:36:00.466', 'Migrate', NULL, NULL, NULL, true);

-- INSERT INTO su_user_profile
-- (user_id, profile_code, created_by, created_date, created_program, updated_by, updated_date, updated_program, effective_date, end_date)
-- VALUES(214, 'ALL_ADMIN', 'Script', '22026-05-05 11:19:53.544', 'Migrate', NULL, NULL, NULL, '2026-05-05 11:19:53.544', NULL);
--  INSERT INTO su_user_profile
--  (user_id, profile_code, created_by, created_date, created_program, updated_by, updated_date, updated_program, effective_date, end_date)
--  VALUES(214, 'ADMIN_PROJECT', 'Script', '22026-05-05 11:19:53.544', 'Migrate', NULL, NULL, NULL, '2026-05-05 11:19:53.544', NULL);


INSERT INTO su_system_configuration
(configuration_group_code, configuration_name, configuration_value, "sequence", description, active, created_by, created_date, created_program, updated_by, updated_date, updated_program, system_code, allow_client)
VALUES('ProfileAdminProject', 'ProgramMaster', 'ADMIN_PROJECT', 1, 'ProfileAdminProject For Master', true, 'Script', '2026-05-05 10:58:18.181', 'Migrate', NULL, NULL, NULL, 'EXP', false);


INSERT INTO su_profile_lang
(profile_code, language_code, profile_name, created_by, created_date, created_program, updated_by, updated_date, updated_program)
VALUES('ADMIN_PROJECT', 'TH', 'ผู้ดูแลระบบเพิ่มข้อมูลโปรเจกต์', 'Script', '2026-05-05 16:32:17.856', 'Migrate', NULL, NULL, NULL);
INSERT INTO su_profile_lang
(profile_code, language_code, profile_name, created_by, created_date, created_program, updated_by, updated_date, updated_program)
VALUES('ADMIN_PROJECT', 'EN', 'Administrator Added The Project Information', 'Script', '2026-05-05 16:32:17.856', 'Migrate', NULL, NULL, NULL);