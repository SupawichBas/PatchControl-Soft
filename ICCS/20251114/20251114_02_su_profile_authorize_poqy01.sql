-- DEV UAT
-- INSERT INTO su_profile_authorize
-- (profile_code, program_code, authorize_code, created_by, created_date, created_program)
-- VALUES('ALL', 'POQY01', 'View', 'Script', current_timestamp, 'Script');
-- INSERT INTO su_profile_authorize
-- (profile_code, program_code, authorize_code, created_by, created_date, created_program)
-- VALUES('ALL', 'POQY01', 'Print', 'Script', current_timestamp, 'Script');
-- INSERT INTO su_profile_authorize
-- (profile_code, program_code, authorize_code, created_by, created_date, created_program)
-- VALUES('PO_ALL', 'POQY01', 'Print', 'Script', current_timestamp, 'Script');
-- INSERT INTO su_profile_authorize
-- (profile_code, program_code, authorize_code, created_by, created_date, created_program)
-- VALUES('PO_ALL', 'POQY01', 'View', 'Script', current_timestamp, 'Script');
-- INSERT INTO su_profile_authorize
-- (profile_code, program_code, authorize_code, created_by, created_date, created_program)
-- VALUES('PO_USER', 'POQY01', 'Print', 'Script', current_timestamp, 'Script');
-- INSERT INTO su_profile_authorize
-- (profile_code, program_code, authorize_code, created_by, created_date, created_program)
-- VALUES('PO_USER', 'POQY01', 'View', 'Script', current_timestamp, 'Script');
-- INSERT INTO su_profile_authorize
-- (profile_code, program_code, authorize_code, created_by, created_date, created_program)
-- VALUES('PO_CENTER', 'POQY01', 'Print', 'Script', current_timestamp, 'Script');
-- INSERT INTO su_profile_authorize
-- (profile_code, program_code, authorize_code, created_by, created_date, created_program)
-- VALUES('PO_CENTER', 'POQY01', 'View', 'Script', current_timestamp, 'Script');



-- PROD
INSERT INTO su_profile_authorize
(profile_code, program_code, authorize_code, created_by, created_date, created_program)
VALUES('PO_ADMIN', 'POQY01', 'View', 'Script', current_timestamp, 'Script');
INSERT INTO su_profile_authorize
(profile_code, program_code, authorize_code, created_by, created_date, created_program)
VALUES('PO_ADMIN', 'POQY01', 'Print', 'Script', current_timestamp, 'Script');

INSERT INTO su_profile_authorize
(profile_code, program_code, authorize_code, created_by, created_date, created_program)
VALUES('PO_APPROVE', 'POQY01', 'View', 'Script', current_timestamp, 'Script');
INSERT INTO su_profile_authorize
(profile_code, program_code, authorize_code, created_by, created_date, created_program)
VALUES('PO_APPROVE', 'POQY01', 'Print', 'Script', current_timestamp, 'Script');

INSERT INTO su_profile_authorize
(profile_code, program_code, authorize_code, created_by, created_date, created_program)
VALUES('PO_CENTER', 'POQY01', 'View', 'Script', current_timestamp, 'Script');
INSERT INTO su_profile_authorize
(profile_code, program_code, authorize_code, created_by, created_date, created_program)
VALUES('PO_CENTER', 'POQY01', 'Print', 'Script', current_timestamp, 'Script');