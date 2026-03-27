ALTER TABLE ta_document_traveller ADD cancelflight bool NULL;
COMMENT ON COLUMN ta_document_traveller.cancelflight IS 'ยกเลิกการจองตั๋วเครื่องบิน';

ALTER TABLE ta_document_traveller ADD cancelhotel bool NULL;
COMMENT ON COLUMN ta_document_traveller.cancelhotel IS 'ยกเลิกการจองโรงแรม/ที่พัก';



ALTER TABLE ta_document_traveller ADD flight_remark varchar(500) NULL;
COMMENT ON COLUMN ta_document_traveller.flight_remark IS 'หมายเลขการจองตั๋วเครื่องบิน / รายละเอียด';



ALTER TABLE ta_document_traveller ADD hotel_remark varchar(500) NULL;
COMMENT ON COLUMN ta_document_traveller.hotel_remark IS 'หมายเลขการจองโรงแรม/ที่พัก / รายละเอียด';




INSERT INTO su_profile
(profile_code, description, active, created_by, created_date, created_program, profiletype, profile_group)
VALUES('TA_HR', 'Taraveller Human', true, 'Script', current_timestamp, 'Migrate', 'Document', 'User');

INSERT INTO su_profile_lang
(profile_code, language_code, profile_name, created_by, created_date, created_program, updated_by, updated_date, updated_program)
VALUES('TA_HR', 'EN', 'ฝ่ายทรัพยากรบุคคลสำหรับการเดินทาง', 'Script', current_timestamp, 'Script', NULL, NULL, NULL);
INSERT INTO su_profile_lang
(profile_code, language_code, profile_name, created_by, created_date, created_program, updated_by, updated_date, updated_program)
VALUES('TA_HR', 'TH', 'ฝ่ายทรัพยากรบุคคลสำหรับการเดินทาง', 'Script', current_timestamp, 'Script', NULL, NULL, NULL);


INSERT INTO su_field_group_configuration
(program_code, profile_code, field_group, page_status, visible_flag, editable_flag, active, created_by, created_date, created_program)
VALUES
('SMTADT02', 'TA_HR', 'Draft', 'Complete', true, false, true, 'Script', current_timestamp, 'Migrate'),
('SMTADT02', 'TA_HR', 'General', 'Complete', true, true, true, 'Script', current_timestamp, 'Migrate'),
('SMTADT02', 'TA_HR', 'New', 'Complete', true, false, true, 'Script', current_timestamp, 'Migrate');



INSERT INTO su_program_label
(program_code, field_name, language_code, label_name, system_code, module_code, created_by, created_date, created_program)
VALUES
('SMTADT02', 'BookingAirplane', 'EN', 'Booking Airplane Tickets', 'SM', 'EX', 'Script', current_timestamp, 'Migrate'),
('SMTADT02', 'BookingAirplane', 'TH', 'การจองตั๋วเครื่องบิน', 'SM', 'EX', 'Script', current_timestamp, 'Migrate'),
('SMTADT02', 'BookingHotel', 'EN', 'Booking Hotel/Accommodation', 'SM', 'EX', 'Script', current_timestamp, 'Migrate'),
('SMTADT02', 'BookingHotel', 'TH', 'การจองโรงแรม/ที่พัก', 'SM', 'EX', 'Script', current_timestamp, 'Migrate'),
('SMTADT02', 'BookingDetails', 'EN', 'Reservation Number/Details', 'SM', 'EX', 'Script', current_timestamp, 'Migrate'),
('SMTADT02', 'BookingDetails', 'TH', 'หมายเลขการจอง / รายละเอียด', 'SM', 'EX', 'Script', current_timestamp, 'Migrate'),
('SMTADT02', 'CancelReservationFlight', 'EN', 'Cancel Flight Reservation', 'SM', 'EX', 'Script', current_timestamp, 'Migrate'),
('SMTADT02', 'CancelReservationFlight', 'TH', 'ยกเลิกการจองตั๋วเครื่องบิน', 'SM', 'EX', 'Script', current_timestamp, 'Migrate'),
('SMTADT02', 'CancelReservationHotel', 'EN', 'Cancel Hotel/Accommodation', 'SM', 'EX', 'Script', current_timestamp, 'Migrate'),
('SMTADT02', 'CancelReservationHotel', 'TH', 'ยกเลิกการจองโรงแรม/ที่พัก', 'SM', 'EX', 'Script', current_timestamp, 'Migrate'),
('SMTADT02', 'CancelReservation', 'EN', 'Cancel Reservation', 'SM', 'EX', 'Script', current_timestamp, 'Migrate'),
('SMTADT02', 'CancelReservation', 'TH', 'ยกเลิกการจอง', 'SM', 'EX', 'Script', current_timestamp, 'Migrate');
