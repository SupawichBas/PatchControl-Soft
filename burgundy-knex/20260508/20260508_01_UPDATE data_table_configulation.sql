UPDATE data_table_configulation
SET column_label='label.SMTADT01.IsFlight', "column_type"='Icon'::dbo."column_type", column_custom='[{"iconName": "check","iconLabel": "isflight","iconValue":"TRUE","iconOnly":true},{"iconName": "close","iconLabel": "isflight","iconValue":"FALSE","iconOnly":true}]', column_align='text-center', column_sequence=130, header_align='text-center', "filter_type"='Radio'::dbo."filter_type", filter_api='IsFlightList', sort=true, display=true, active=true, created_by='Procedure_Copy', created_date='2025-04-01 16:10:31.011', created_program='Procedure_Copy', updated_by='Migrate', updated_date=current_timestamp, updated_program='Migrate'
WHERE company_code='KNEX' AND table_name='TripAllTrip' AND column_name='isFlight';
UPDATE data_table_configulation
SET column_label='label.SMTADT01.IsHotel', "column_type"='Icon'::dbo."column_type", column_custom='[{"iconName": "check","iconLabel": "ishotel","iconValue":"TRUE","iconOnly":true},{"iconName": "close","iconLabel": "ishotel","iconValue":"FALSE","iconOnly":true}]', column_align='text-center', column_sequence=140, header_align='text-center', "filter_type"='Radio'::dbo."filter_type", filter_api='IsHotelList', sort=true, display=true, active=true, created_by='Procedure_Copy', created_date='2025-04-01 16:10:31.011', created_program='Procedure_Copy', updated_by='Migrate', updated_date=current_timestamp, updated_program='Migrate'
WHERE company_code='KNEX' AND table_name='TripAllTrip' AND column_name='isHotel';

INSERT INTO db_list_value
(company_code, group_code, value, description, parent_group_code, parent_value, "sequence", active, created_by, created_date, created_program, updated_by, updated_date, updated_program)
VALUES('KNEX', 'IsFlightList', 'NO', 'Has No IsFlightList', NULL, NULL, 3, true, 'Procedure_Copy', '2025-11-24 15:12:22.932', 'Procedure_Copy', 'Migrate', current_timestamp, 'Migrate');
UPDATE db_list_value
SET description='Has Cancel IsHotelList', parent_group_code=NULL, parent_value=NULL, "sequence"=2, active=true, created_by='Procedure_Copy', created_date='2025-11-24 15:12:22.932', created_program='Procedure_Copy', updated_by='Migrate', updated_date=current_timestamp, updated_program='Migrate'
WHERE company_code='KNEX' AND group_code='IsFlightList' AND value='FALSE';
INSERT INTO db_list_value
(company_code, group_code, value, description, parent_group_code, parent_value, "sequence", active, created_by, created_date, created_program, updated_by, updated_date, updated_program)
VALUES('KNEX', 'IsHotelList', 'NO', 'Has No IsHotelList', NULL, NULL, 3, true, 'Procedure_Copy', '2025-11-24 15:12:22.932', 'Procedure_Copy', 'Migrate', current_timestamp, 'Migrate');
UPDATE db_list_value
SET description='Has Cancel IsHotelList', parent_group_code=NULL, parent_value=NULL, "sequence"=2, active=true, created_by='Procedure_Copy', created_date='2025-11-24 15:12:22.932', created_program='Procedure_Copy', updated_by='Migrate', updated_date=current_timestamp, updated_program='Migrate'
WHERE company_code='KNEX' AND group_code='IsHotelList' AND value='FALSE';

UPDATE db_list_value_lang
SET value_text='Has Cancel Is Flight', created_by='Procedure_Copy', created_date='2025-11-24 15:14:58.979', created_program='Procedure_Copy', updated_by='Migrate', updated_date=current_timestamp, updated_program='Migrate', value_json=NULL
WHERE company_code='KNEX' AND group_code='IsFlightList' AND value='FALSE' AND language_code='EN';
UPDATE db_list_value_lang
SET value_text='ยกเลิกการจองตั๋วเครื่องบิน', created_by='Procedure_Copy', created_date='2025-11-24 15:14:58.979', created_program='Procedure_Copy', updated_by='Migrate', updated_date=current_timestamp, updated_program='Migrate', value_json=NULL
WHERE company_code='KNEX' AND group_code='IsFlightList' AND value='FALSE' AND language_code='TH';
INSERT INTO db_list_value_lang
(company_code, group_code, value, language_code, value_text, created_by, created_date, created_program, updated_by, updated_date, updated_program, value_json)
VALUES('KNEX', 'IsFlightList', 'NO', 'EN', 'Has No Is Flight', 'Procedure_Copy', '2025-11-24 15:14:58.979', 'Procedure_Copy', 'Migrate', current_timestamp, 'Migrate', NULL);
INSERT INTO db_list_value_lang
(company_code, group_code, value, language_code, value_text, created_by, created_date, created_program, updated_by, updated_date, updated_program, value_json)
VALUES('KNEX', 'IsFlightList', 'NO', 'TH', 'ไม่มีการจองตั๋วเครื่องบิน', 'Procedure_Copy', '2025-11-24 15:14:58.979', 'Procedure_Copy', 'Migrate', current_timestamp, 'Migrate', NULL);

UPDATE db_list_value_lang
SET value_text='Has Cancel Is Hotel', created_by='Procedure_Copy', created_date='2025-11-24 15:14:58.979', created_program='Procedure_Copy', updated_by='Migrate', updated_date=current_timestamp, updated_program='Migrate', value_json=NULL
WHERE company_code='KNEX' AND group_code='IsHotelList' AND value='FALSE' AND language_code='EN';
UPDATE db_list_value_lang
SET value_text='ยกเลิกการจองโรงแรม', created_by='Procedure_Copy', created_date='2025-11-24 15:14:58.979', created_program='Procedure_Copy', updated_by='Migrate', updated_date=current_timestamp, updated_program='Migrate', value_json=NULL
WHERE company_code='KNEX' AND group_code='IsHotelList' AND value='FALSE' AND language_code='TH';
INSERT INTO db_list_value_lang
(company_code, group_code, value, language_code, value_text, created_by, created_date, created_program, updated_by, updated_date, updated_program, value_json)
VALUES('KNEX', 'IsHotelList', 'NO', 'EN', 'Has No Is Hotel', 'Procedure_Copy', '2025-11-24 15:14:58.979', 'Procedure_Copy', 'Migrate', current_timestamp, 'Migrate', NULL);
INSERT INTO db_list_value_lang
(company_code, group_code, value, language_code, value_text, created_by, created_date, created_program, updated_by, updated_date, updated_program, value_json)
VALUES('KNEX', 'IsHotelList', 'NO', 'TH', 'ไม่มีการจองโรงแรม', 'Procedure_Copy', '2025-11-24 15:14:58.979', 'Procedure_Copy', 'Migrate', current_timestamp, 'Migrate', NULL);