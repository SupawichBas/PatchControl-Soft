INSERT INTO db_list_value
(company_code, group_code, value, description, parent_group_code, parent_value, "sequence", active, created_by, created_date, created_program)
VALUES('KNEX', 'TravelBy', 'PublicBus', 'รถโดยสารสาธารณะ', NULL, NULL, 7, true, 'Script', CURRENT_TIMESTAMP, 'Migrate');


UPDATE db_list_value
SET active=false, updated_by='Script', updated_date=CURRENT_TIMESTAMP, updated_program='Migrate'
WHERE company_code='KNEX' AND group_code='TravelBy' AND value='Train';
UPDATE db_list_value
SET active=false, updated_by='Script', updated_date=CURRENT_TIMESTAMP, updated_program='Migrate'
WHERE company_code='KNEX' AND group_code='TravelBy' AND value='Transportation';



INSERT INTO db_list_value_lang
(company_code, group_code, value, language_code, value_text, created_by, created_date, created_program)
VALUES('KNEX', 'TravelBy', 'PublicBus', 'EN', 'Public Bus', 'Script', CURRENT_TIMESTAMP, 'Migrate');
INSERT INTO db_list_value_lang
(company_code, group_code, value, language_code, value_text, created_by, created_date, created_program)
VALUES('KNEX', 'TravelBy', 'PublicBus', 'TH', 'รถโดยสารสาธารณะ', 'Script', CURRENT_TIMESTAMP, 'Migrate');
