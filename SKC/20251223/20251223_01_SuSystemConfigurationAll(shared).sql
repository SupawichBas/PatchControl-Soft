-- Service Center
INSERT INTO SuSystemConfigurationAll
(ConfigurationGroupCode, ConfigurationName, ConfigurationValue, [Sequence], Description, Active, CreatedBy, CreatedDate, CreatedProgram, SystemCode, AllowClient)
VALUES
(N'ParameterSrcDocument', N'ServiceCenterParams7_1', N'DY751', 1, N'(CostCenter สำหรับ หน่วยงานศูนย์บริการ  = DY751XXXXX)', 1, N'Script', CURRENT_TIMESTAMP, N'Migrate', N'EXP', 0),
(N'ParameterSrcDocument', N'ServiceCenterParams7_2', N'ผู้ช่วยผู้จัดการศูนย์บริการ', 1, N'ตำแหน่ง ที่มีคำว่า "ผู้ช่วยผู้จัดการศูนย์บริการ" ', 1, N'Script', CURRENT_TIMESTAMP, N'Migrate', N'EXP', 0),
(N'ParameterSrcDocument', N'ServiceCenterParams7_3', N'S1,S2', 1, N'ระดับพนักงาน "S1 - S2"', 1, N'Script', CURRENT_TIMESTAMP, N'Migrate', N'EXP', 0),
(N'ParameterSrcDocument', N'ServiceCenterParams7_4', N'ผู้จัดการศูนย์บริการ', 1, N'ตำแหน่ง ที่มีคำว่า "ผู้จัดการศูนย์บริการ"', 1, N'Script', CURRENT_TIMESTAMP, N'Migrate', N'EXP', 0),
(N'ParameterSrcDocument', N'ServiceCenterParams7_5', N'S1,S2,S3', 1, N'ระดับพนักงาน "S1 - S3"', 1, N'Script', CURRENT_TIMESTAMP, N'Migrate', N'EXP', 0),
(N'ParameterSrcDocument', N'ServiceCenterParams7_6', N'ผู้ช่วยผู้จัดการ', 1, N'ตำแหน่ง ที่มีคำว่า "ผู้ช่วยผู้จัดการ"', 1, N'Script', CURRENT_TIMESTAMP, N'Migrate', N'EXP', 0),
(N'ParameterSrcDocument', N'ServiceCenterParams7_7', N'S3,S4,S5', 1, N'ระดับพนักงาน "S3 - S5"', 1, N'Script', CURRENT_TIMESTAMP, N'Migrate', N'EXP', 0),
(N'ParameterSrcDocument', N'ServiceCenterParams7_8', N'ผู้จัดการส่วน', 1, N'ตำแหน่ง ที่มีคำว่า "ผู้จัดการส่วน"', 1, N'Script', CURRENT_TIMESTAMP, N'Migrate', N'EXP', 0),
(N'ParameterSrcDocument', N'ServiceCenterParams7_9', N'M1,M2', 1, N'ระดับพนักงาน "M1 หรือ M2"', 1, N'Script', CURRENT_TIMESTAMP, N'Migrate', N'EXP', 0),
(N'ParameterSrcDocument', N'ServiceCenterParams7_10', N'ผู้จัดการฝ่าย', 1, N'ตำแหน่ง ที่มีคำว่า "ผู้จัดการฝ่าย"', 1, N'Script', CURRENT_TIMESTAMP, N'Migrate', N'EXP', 0),
(N'ParameterSrcDocument', N'ServiceCenterParams7_11', N'M2,M3', 1, N'ระดับพนักงาน "M2 หรือ M3"', 1, N'Script', CURRENT_TIMESTAMP, N'Migrate', N'EXP', 0);