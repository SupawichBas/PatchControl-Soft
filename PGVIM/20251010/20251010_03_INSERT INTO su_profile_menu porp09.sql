--UAT
-- INSERT INTO su_profile_menu
-- (profile_code, menu_code, created_by, created_date, created_program)
-- VALUES('ALL', '3005PO300003', 'Script', current_timestamp, 'Script');

-- INSERT INTO su_profile_authorize
-- (profile_code, program_code, authorize_code, created_by, created_date, created_program)
-- VALUES('ALL', 'PORP09', 'View', 'Script', current_timestamp, 'Script');
-- INSERT INTO su_profile_authorize
-- (profile_code, program_code, authorize_code, created_by, created_date, created_program)
-- VALUES('ALL', 'PORP09', 'Print', 'Script', current_timestamp, 'Script');
-- INSERT INTO su_profile_authorize
-- (profile_code, program_code, authorize_code, created_by, created_date, created_program)
-- VALUES('PO_ALL', 'PORP09', 'Print', 'Script', current_timestamp, 'Script');
-- INSERT INTO su_profile_authorize
-- (profile_code, program_code, authorize_code, created_by, created_date, created_program)
-- VALUES('PO_ALL', 'PORP09', 'View', 'Script', current_timestamp, 'Script');
-- INSERT INTO su_profile_authorize
-- (profile_code, program_code, authorize_code, created_by, created_date, created_program)
-- VALUES('PO_USER', 'PORP09', 'Add', 'Script', current_timestamp, 'Script');
-- INSERT INTO su_profile_authorize
-- (profile_code, program_code, authorize_code, created_by, created_date, created_program)
-- VALUES('PO_USER', 'PORP09', 'Cancel', 'Script', current_timestamp, 'Script');
-- INSERT INTO su_profile_authorize
-- (profile_code, program_code, authorize_code, created_by, created_date, created_program)
-- VALUES('PO_USER', 'PORP09', 'Delete', 'Script', current_timestamp, 'Script');
-- INSERT INTO su_profile_authorize
-- (profile_code, program_code, authorize_code, created_by, created_date, created_program)
-- VALUES('PO_USER', 'PORP09', 'Edit', 'Script', current_timestamp, 'Script');
-- INSERT INTO su_profile_authorize
-- (profile_code, program_code, authorize_code, created_by, created_date, created_program)
-- VALUES('PO_USER', 'PORP09', 'Print', 'Script', current_timestamp, 'Script');
-- INSERT INTO su_profile_authorize
-- (profile_code, program_code, authorize_code, created_by, created_date, created_program)
-- VALUES('PO_USER', 'PORP09', 'View', 'Script', current_timestamp, 'Script');
-- INSERT INTO su_profile_authorize
-- (profile_code, program_code, authorize_code, created_by, created_date, created_program)
-- VALUES('PO_CENTER', 'PORP09', 'Add', 'Script', current_timestamp, 'Script');
-- INSERT INTO su_profile_authorize
-- (profile_code, program_code, authorize_code, created_by, created_date, created_program)
-- VALUES('PO_CENTER', 'PORP09', 'Cancel', 'Script', current_timestamp, 'Script');
-- INSERT INTO su_profile_authorize
-- (profile_code, program_code, authorize_code, created_by, created_date, created_program)
-- VALUES('PO_CENTER', 'PORP09', 'Delete', 'Script', current_timestamp, 'Script');
-- INSERT INTO su_profile_authorize
-- (profile_code, program_code, authorize_code, created_by, created_date, created_program)
-- VALUES('PO_CENTER', 'PORP09', 'Edit', 'Script', current_timestamp, 'Script');
-- INSERT INTO su_profile_authorize
-- (profile_code, program_code, authorize_code, created_by, created_date, created_program)
-- VALUES('PO_CENTER', 'PORP09', 'Print', 'Script', current_timestamp, 'Script');
-- INSERT INTO su_profile_authorize
-- (profile_code, program_code, authorize_code, created_by, created_date, created_program)
-- VALUES('PO_CENTER', 'PORP09', 'View', 'Script', current_timestamp, 'Script');





-- PROD
INSERT INTO su_profile_menu
(profile_code, menu_code, created_by, created_date, created_program)
VALUES('PO_ADMIN', '3005PO300003', 'Script', current_timestamp, 'Script');
INSERT INTO su_profile_menu
(profile_code, menu_code, created_by, created_date, created_program)
VALUES('PO_APPROVE', '3005PO300003', 'Script', current_timestamp, 'Script');
INSERT INTO su_profile_menu
(profile_code, menu_code, created_by, created_date, created_program)
VALUES('PO_CENTER', '3005PO300003', 'Script', current_timestamp, 'Script');
INSERT INTO su_profile_menu
(profile_code, menu_code, created_by, created_date, created_program)
VALUES('PO_STAFF', '3005PO300003', 'Script', current_timestamp, 'Script');



INSERT INTO su_profile_authorize
(profile_code, program_code, authorize_code, created_by, created_date, created_program)
VALUES('PO_ADMIN', 'PORP09', 'View', 'Script', current_timestamp, 'Script');
INSERT INTO su_profile_authorize
(profile_code, program_code, authorize_code, created_by, created_date, created_program)
VALUES('PO_ADMIN', 'PORP09', 'Print', 'Script', current_timestamp, 'Script');

INSERT INTO su_profile_authorize
(profile_code, program_code, authorize_code, created_by, created_date, created_program)
VALUES('PO_APPROVE', 'PORP09', 'View', 'Script', current_timestamp, 'Script');
INSERT INTO su_profile_authorize
(profile_code, program_code, authorize_code, created_by, created_date, created_program)
VALUES('PO_APPROVE', 'PORP09', 'Print', 'Script', current_timestamp, 'Script');

INSERT INTO su_profile_authorize
(profile_code, program_code, authorize_code, created_by, created_date, created_program)
VALUES('PO_CENTER', 'PORP09', 'View', 'Script', current_timestamp, 'Script');
INSERT INTO su_profile_authorize
(profile_code, program_code, authorize_code, created_by, created_date, created_program)
VALUES('PO_CENTER', 'PORP09', 'Print', 'Script', current_timestamp, 'Script');

INSERT INTO su_profile_authorize
(profile_code, program_code, authorize_code, created_by, created_date, created_program)
VALUES('PO_STAFF', 'PORP09', 'View', 'Script', current_timestamp, 'Script');
INSERT INTO su_profile_authorize
(profile_code, program_code, authorize_code, created_by, created_date, created_program)
VALUES('PO_STAFF', 'PORP09', 'Print', 'Script', current_timestamp, 'Script');