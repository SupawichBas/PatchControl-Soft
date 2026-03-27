ALTER TABLE dbo.ta_document ADD work_performance text NULL;
COMMENT ON COLUMN dbo.ta_document.work_performance IS 'รายละเอียดผลการปฏิบัติงาน เมื่อสถานะเสร็จสมบูรณ์';