--[ECT] add su_user_manual UserVdoTraining
INSERT INTO su_user_manual_master
(group_code, "sequence", description, parent_group_code, active, can_insert, can_delete, can_edit, system_control, created_by, created_date, created_program, updated_by, updated_date, updated_program)
VALUES('UserVdoTraining', NULL, 'User VDO Training', NULL, true, false, false, false, false, 'script', '2026-06-04 00:00:00.000', 'script', 'script', '2026-06-04 00:00:00.000', 'script');

INSERT INTO su_program
(program_code, program_name, program_path, system_code, module_code, created_by, created_date, created_program, updated_by, updated_date, updated_program, ds_program_code, "version")
VALUES('HELP02', 'HelpVDOService', '/help/help02', 'ERP', 'SU', NULL, NULL, NULL, 'Script', '2026-06-04 10:50:14.036', 'Script', NULL, NULL);


INSERT INTO su_menu
(menu_code, program_code, main_menu, system_code, icon, active, created_by, created_date, created_program, updated_by, updated_date, updated_program, "version")
VALUES('99US10015', 'HELP02', '99US00000', 'ERP', 'fas fa-book-reader', true, 'Script', '2026-06-04 13:55:52.464', 'Script', 'Script', '2026-06-04 13:13:26.586', 'Script', NULL);


INSERT INTO su_profile_menu
(profile_code, menu_code, created_by, created_date, created_program, updated_by, updated_date, updated_program)
VALUES
('ALL', '99US10015', 'Script', '2026-06-04 15:17:59.899', 'Script', 'Script', '2026-06-04 15:17:59.899', 'Script'),
('SU_ALL', '99US10015', 'Script', '2026-06-04 13:49:33.669', 'Script', 'Script', '2026-06-04 13:49:33.669', 'Script'),
('US_ALL', '99US10015', 'Script', '2026-06-04 14:15:35.685', 'Script', 'Script', '2026-06-04 14:15:35.685', 'Script'),
('DB_ALL', '99US10015', 'Script', '2026-06-04 14:15:35.685', 'Script', 'Script', '2026-06-04 14:15:35.685', 'Script');



INSERT INTO su_menu_label
(menu_code, language_code, menu_name, system_code, created_by, created_date, created_program, updated_by, updated_date, updated_program)
VALUES('99US10015', 'EN', 'VDO การใช้งานตามขั้นตอนงาน', 'ERP', 'Script', '2026-06-04 10:55:21.000', 'Script', 'Script', '2026-06-04 10:55:21.000', 'Script'),
VALUES('99US10015', 'TH', 'VDO การใช้งานตามขั้นตอนงาน', 'ERP', 'Script', '2026-06-04 10:55:21.000', 'Script', 'Script', '2026-06-04 10:55:21.000', 'Script');



INSERT INTO su_program_label
(program_code, field_name, language_code, label_name, system_code, module_code, created_by, created_date, created_program, updated_by, updated_date, updated_program, "version")
VALUES
('HELP02', 'Description', 'EN', 'รายละเอียด', 'ERP', 'SU', 'Script', '2026-06-04 10:55:21.000', 'Script', 'Script', '2026-06-04 10:55:21.000', 'Script', NULL),
('HELP02', 'Description', 'TH', 'รายละเอียด', 'ERP', 'SU', 'Script', '2026-06-04 10:55:21.000', 'Script', 'Script', '2026-06-04 10:55:21.000', 'Script', NULL),
('HELP02', 'ParentValue', 'EN', 'หัวข้อหลัก', 'ERP', 'SU', 'Script', '2026-06-04 10:55:21.000', 'Script', 'Script', '2026-06-04 10:55:21.000', 'Script', NULL),
('HELP02', 'ParentValue', 'TH', 'หัวข้อหลัก', 'ERP', 'SU', 'Script', '2026-06-04 10:55:21.000', 'Script', 'Script', '2026-06-04 10:55:21.000', 'Script', NULL),
('HELP02', 'ProgramName', 'EN', 'VDO การใช้งานตามขั้นตอนงาน', 'ERP', 'SU', 'Script', '2026-06-04 10:55:21.000', 'Script', 'Script', '2026-06-04 10:55:21.000', 'Script', NULL),
('HELP02', 'ProgramName', 'TH', 'VDO การใช้งานตามขั้นตอนงาน', 'ERP', 'SU', 'Script', '2026-06-04 10:55:21.000', 'Script', 'Script', '2026-06-04 10:55:21.000', 'Script', NULL),
('HELP02', 'Sequence', 'EN', 'ลำดับ', 'ERP', 'SU', 'Script', '2026-06-04 10:55:21.000', 'Script', 'Script', '2026-06-04 10:55:21.000', 'Script', NULL),
('HELP02', 'Sequence', 'TH', 'ลำดับ', 'ERP', 'SU', 'Script', '2026-06-04 10:55:21.000', 'Script', 'Script', '2026-06-04 10:55:21.000', 'Script', NULL),
('HELP02', 'Value', 'EN', 'หัวข้อ', 'ERP', 'SU', 'Script', '2026-06-04 10:55:21.000', 'Script', 'Script', '2026-06-04 10:55:21.000', 'Script', NULL),
('HELP02', 'Value', 'TH', 'หัวข้อ', 'ERP', 'SU', 'Script', '2026-06-04 10:55:21.000', 'Script', 'Script', '2026-06-04 10:55:21.000', 'Script', NULL),
('HELP02', 'ValueText', 'EN', 'ชื่อหัวข้อ', 'ERP', 'SU', 'Script', '2026-06-04 10:55:21.000', 'Script', 'Script', '2026-06-04 10:55:21.000', 'Script', NULL),
('HELP02', 'ValueText', 'TH', 'ชื่อหัวข้อ', 'ERP', 'SU', 'Script', '2026-06-04 10:55:21.000', 'Script', 'Script', '2026-06-04 10:55:21.000', 'Script', NULL);





INSERT INTO su_profile_authorize
(profile_code, program_code, authorize_code, created_by, created_date, created_program, updated_by, updated_date, updated_program)
VALUES
('ALL', 'HELP02', 'Add', 'Script', '2026-06-04 10:55:21.000', 'Script', 'Script', '2026-06-04 10:55:21.000', 'Script'),
('ALL', 'HELP02', 'Edit', 'Script', '2026-06-04 10:55:21.000', 'Script', 'Script', '2026-06-04 10:55:21.000', 'Script'),
('ALL', 'HELP02', 'Print', 'Script', '2026-06-04 10:55:21.000', 'Script', 'Script', '2026-06-04 10:55:21.000', 'Script'),
('ALL', 'HELP02', 'View', 'Script', '2026-06-04 10:55:21.000', 'Script', 'Script', '2026-06-04 10:55:21.000', 'Script'),
('SU_ALL', 'HELP02', 'View', 'Script', '2026-06-04 10:55:21.000', 'Script', 'Script', '2026-06-04 10:55:21.000', 'Script'),
('US_ALL', 'HELP02', 'Print', 'Script', '2026-06-04 10:55:21.000', 'Script', 'Script', '2026-06-04 10:55:21.000', 'Script'),
('US_ALL', 'HELP02', 'View', 'Script', '2026-06-04 10:55:21.000', 'Script', 'Script', '2026-06-04 10:55:21.000', 'Script'),
('SU_ALL', 'HELP02', 'Edit', 'Script', '2026-06-04 10:55:21.000', 'Script', 'Script', '2026-06-04 10:55:21.000', 'Script'),
('DB_ALL', 'HELP02', 'Edit', 'Script', '2026-06-04 10:55:21.000', 'Script', 'Script', '2026-06-04 10:55:21.000', 'Script');





ALTER TABLE su_user_manual_detail ADD vdo_url varchar(1000) NULL;