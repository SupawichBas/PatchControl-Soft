INSERT INTO su_program
(program_code, program_name, program_path, system_code, module_code, created_by, created_date, created_program,  ds_program_code)
VALUES('PORP09', 'รายงานใบขออนุมัติจัดซื้อ/จัดจ้าง', '/po/porp09', 'ERP', 'PO', 'Script', current_timestamp, 'Script', NULL);


INSERT INTO su_menu
(menu_code, program_code, main_menu, system_code, icon, active, created_by, created_date, created_program)
VALUES('3005PO300003', 'PORP09', '3005PO300000', 'ERP', 'far fa-circle fa-xs', true, 'Script', current_timestamp, 'Script');

INSERT INTO su_menu_label
(menu_code, language_code, menu_name, system_code, created_by, created_date, created_program)
VALUES('3005PO300003', 'EN', 'รายงานใบขออนุมัติจัดซื้อ/จัดจ้าง', 'ERP', 'Script', current_timestamp, 'Script');
INSERT INTO su_menu_label
(menu_code, language_code, menu_name, system_code, created_by, created_date, created_program)
VALUES('3005PO300003', 'TH', 'รายงานใบขออนุมัติจัดซื้อ/จัดจ้าง', 'ERP', 'Script', current_timestamp, 'Script');



