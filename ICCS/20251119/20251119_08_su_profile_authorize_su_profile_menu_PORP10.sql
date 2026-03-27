
INSERT INTO su_profile_menu
(profile_code, menu_code, created_by, created_date, created_program)
VALUES('PO_ADMIN', '3005PO300004', 'Script', current_timestamp, 'Script');
INSERT INTO su_profile_menu
(profile_code, menu_code, created_by, created_date, created_program)
VALUES('PO_APPROVE', '3005PO300004', 'Script', current_timestamp, 'Script');
INSERT INTO su_profile_menu
(profile_code, menu_code, created_by, created_date, created_program)
VALUES('PO_CENTER', '3005PO300004', 'Script', current_timestamp, 'Script');
INSERT INTO su_profile_menu
(profile_code, menu_code, created_by, created_date, created_program)
VALUES('PO_ALL', '3005PO300004', 'Script', current_timestamp, 'Script');



INSERT INTO su_profile_authorize
(profile_code, program_code, authorize_code, created_by, created_date, created_program)
VALUES('PO_ADMIN', 'PORP10', 'View', 'Script', current_timestamp, 'Script');
INSERT INTO su_profile_authorize
(profile_code, program_code, authorize_code, created_by, created_date, created_program)
VALUES('PO_ADMIN', 'PORP10', 'Print', 'Script', current_timestamp, 'Script');

INSERT INTO su_profile_authorize
(profile_code, program_code, authorize_code, created_by, created_date, created_program)
VALUES('PO_APPROVE', 'PORP10', 'View', 'Script', current_timestamp, 'Script');
INSERT INTO su_profile_authorize
(profile_code, program_code, authorize_code, created_by, created_date, created_program)
VALUES('PO_APPROVE', 'PORP10', 'Print', 'Script', current_timestamp, 'Script');

INSERT INTO su_profile_authorize
(profile_code, program_code, authorize_code, created_by, created_date, created_program)
VALUES('PO_CENTER', 'PORP10', 'View', 'Script', current_timestamp, 'Script');
INSERT INTO su_profile_authorize
(profile_code, program_code, authorize_code, created_by, created_date, created_program)
VALUES('PO_CENTER', 'PORP10', 'Print', 'Script', current_timestamp, 'Script');

INSERT INTO su_profile_authorize
(profile_code, program_code, authorize_code, created_by, created_date, created_program)
VALUES('PO_ALL', 'PORP10', 'View', 'Script', current_timestamp, 'Script');
INSERT INTO su_profile_authorize
(profile_code, program_code, authorize_code, created_by, created_date, created_program)
VALUES('PO_ALL', 'PORP10', 'Print', 'Script', current_timestamp, 'Script');
