INSERT INTO su_program
(program_code, program_name, program_path, system_code, module_code, created_by, created_date, created_program)
VALUES('POOD33', 'เอกสารใบเบิก', '/po/pood33', 'ERP', 'PO', 'Script', current_timestamp, 'Migrate');

-- INSERT INTO su_program_label
-- (program_code, field_name, language_code, label_name, system_code, module_code, created_by, created_date, created_program)
-- VALUES('PODT11', 'Btn.PrintBillDocument', 'EN', 'Print Bill Document', 'ERP', 'PO', 'Script', current_timestamp, 'Migrate');
-- INSERT INTO su_program_label
-- (program_code, field_name, language_code, label_name, system_code, module_code, created_by, created_date, created_program)
-- VALUES('PODT11', 'Btn.PrintBillDocument', 'TH', 'พิมพ์เอกสารใบเบิก', 'ERP', 'PO', 'Script', current_timestamp, 'Migrate');



INSERT INTO su_report_label
(program_code, field_name, language_code, label_name, system_code, module_code)
VALUES('POOD33', 'ReportName', 'TH', 'ใบเบิก-จ่ายวัสดุ', 'ERP', 'PO'),
('POOD33', 'ReportName', 'EN', 'ใบเบิก-จ่ายวัสดุ', 'ERP', 'PO'),
('POOD33', 'div_name', 'TH', 'จ่ายวัสดุจาก', 'ERP', 'PO'),
('POOD33', 'div_name', 'EN', 'จ่ายวัสดุจาก', 'ERP', 'PO'),
('POOD33', 'doc_type', 'TH', 'ประเภทการเบิกจ่ายวัสดุ', 'ERP', 'PO'),
('POOD33', 'doc_type', 'EN', 'ประเภทการเบิกจ่ายวัสดุ', 'ERP', 'PO'),
('POOD33', 'receive_no', 'TH', 'เลขที่ใบเบิกจ่ายวัสดุ', 'ERP', 'PO'),
('POOD33', 'receive_no', 'EN', 'เลขที่ใบเบิกจ่ายวัสดุ', 'ERP', 'PO'),
('POOD33', 'deliver_date', 'TH', 'วันที่เบิกจ่ายวัสดุ', 'ERP', 'PO'),
('POOD33', 'deliver_date', 'EN', 'วันที่เบิกจ่ายวัสดุ', 'ERP', 'PO'),
('POOD33', 'status_name', 'TH', 'สถานะเอกสาร', 'ERP', 'PO'),
('POOD33', 'status_name', 'EN', 'สถานะเอกสาร', 'ERP', 'PO'),
('POOD33', 'seq', 'TH', 'ลำดับที่', 'ERP', 'PO'),
('POOD33', 'seq', 'EN', 'ลำดับที่', 'ERP', 'PO'),
('POOD33', 'product_code', 'TH', 'รหัสวัสดุ', 'ERP', 'PO'),
('POOD33', 'product_code', 'EN', 'รหัสวัสดุ', 'ERP', 'PO'),
('POOD33', 'product_name', 'TH', 'ชื่อวัสดุ', 'ERP', 'PO'),
('POOD33', 'product_name', 'EN', 'ชื่อวัสดุ', 'ERP', 'PO'),
('POOD33', 'ums_name', 'TH', 'หน่วยนับ', 'ERP', 'PO'),
('POOD33', 'ums_name', 'EN', 'หน่วยนับ', 'ERP', 'PO'),
('POOD33', 'qty', 'TH', 'จำนวนรวม', 'ERP', 'PO'),
('POOD33', 'qty', 'EN', 'จำนวนรวม', 'ERP', 'PO'),
('POOD33', 'qty2', 'TH', 'จำนวนเบิก', 'ERP', 'PO'),
('POOD33', 'qty2', 'EN', 'จำนวนเบิก', 'ERP', 'PO'),
('POOD33', 'unit_price', 'TH', 'ราคาต่อหน่วย', 'ERP', 'PO'),
('POOD33', 'unit_price', 'EN', 'ราคาต่อหน่วย', 'ERP', 'PO'),
('POOD33', 'amt', 'TH', 'มูลค่า', 'ERP', 'PO'),
('POOD33', 'amt', 'EN', 'มูลค่า', 'ERP', 'PO'),
('POOD33', 'remark', 'TH', 'หมายเหตุ', 'ERP', 'PO'),
('POOD33', 'remark', 'EN', 'หมายเหตุ', 'ERP', 'PO'),
('POOD33', 'total_amt', 'TH', 'รวมมูลค่า', 'ERP', 'PO'),
('POOD33', 'total_amt', 'EN', 'รวมมูลค่า', 'ERP', 'PO'),
('POOD33', 'approve_name', 'TH', 'ผู้เบิกวัสดุ', 'ERP', 'PO'),
('POOD33', 'approve_name', 'EN', 'ผู้เบิกวัสดุ', 'ERP', 'PO'),
('POOD33', 'NoData', 'TH', 'ไม่พบข้อมูล', 'ERP', 'PO'),
('POOD33', 'NoData', 'EN', 'ไม่พบข้อมูล', 'ERP', 'PO'),
('POOD33', 'ProgramCode', 'TH', 'รหัสโปรแกรม', 'ERP', 'PO'),
('POOD33', 'ProgramCode', 'EN', 'รหัสโปรแกรม', 'ERP', 'PO'),
('POOD33', 'PrintBy', 'TH', 'ผู้พิมพ์', 'ERP', 'PO'),
('POOD33', 'PrintBy', 'EN', 'ผู้พิมพ์', 'ERP', 'PO'),
('POOD33', 'PrintDate', 'TH', 'วันที่พิมพ์', 'ERP', 'PO'),
('POOD33', 'PrintDate', 'EN', 'วันที่พิมพ์', 'ERP', 'PO');