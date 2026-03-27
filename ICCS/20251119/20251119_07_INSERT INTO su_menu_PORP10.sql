INSERT INTO su_menu
(menu_code, program_code, main_menu, system_code, icon, active, created_by, created_date, created_program, updated_by, updated_date, updated_program)
VALUES('3005PO300004', 'PORP10', '3005PO300000', 'ERP', 'far fa-circle fa-xs', true, 'Script', '2025-11-19 10:27:04.823', 'Script', NULL, NULL, NULL);


INSERT INTO su_menu_label
(menu_code, language_code, menu_name, system_code, created_by, created_date, created_program)
VALUES('3005PO300004', 'EN', 'รายงานใบขออนุมัติดำเนินการ', 'ERP', 'Script', current_timestamp, 'Script');
INSERT INTO su_menu_label
(menu_code, language_code, menu_name, system_code, created_by, created_date, created_program)
VALUES('3005PO300004', 'TH', 'รายงานใบขออนุมัติดำเนินการ', 'ERP', 'Script', current_timestamp, 'Script');