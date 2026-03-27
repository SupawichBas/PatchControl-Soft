INSERT INTO su_program
(program_code, program_name, program_path, system_code, module_code, created_by, created_date, created_program)
VALUES('PORP10', 'รายงานใบขออนุมัติดำเนินการ', '/po/porp10', 'ERP', 'PO', 'Script', current_timestamp, 'Script');




INSERT INTO su_program_label
(program_code, field_name, language_code, label_name, system_code, module_code, created_by, created_date, created_program)
VALUES('PORP10', 'Criteria.Header', 'EN', 'รายงานใบขออนุมัติดำเนินการ', 'ERP', 'PO', 'Script', current_timestamp, 'Script');
INSERT INTO su_program_label
(program_code, field_name, language_code, label_name, system_code, module_code, created_by, created_date, created_program)
VALUES('PORP10', 'Criteria.Header', 'TH', 'รายงานใบขออนุมัติดำเนินการ', 'ERP', 'PO', 'Script', current_timestamp, 'Script');
INSERT INTO su_program_label
(program_code, field_name, language_code, label_name, system_code, module_code, created_by, created_date, created_program)
VALUES('PORP10', 'Organization', 'EN', 'Procurement/Hiring Division from', 'ERP', 'PO', 'Script', current_timestamp, 'Script');
INSERT INTO su_program_label
(program_code, field_name, language_code, label_name, system_code, module_code, created_by, created_date, created_program)
VALUES('PORP10', 'Organization', 'TH', 'หน่วยงานจัดซื้อ/จัดจ้างตั้งแต่', 'ERP', 'PO', 'Script', current_timestamp, 'Script');
INSERT INTO su_program_label
(program_code, field_name, language_code, label_name, system_code, module_code, created_by, created_date, created_program)
VALUES('PORP10', 'StartDate', 'EN', 'Date of Process Approval Request from', 'ERP', 'PO', 'Script', current_timestamp, 'Script');
INSERT INTO su_program_label
(program_code, field_name, language_code, label_name, system_code, module_code, created_by, created_date, created_program)
VALUES('PORP10', 'StartDate', 'TH', 'วันที่ใบขออนุมัติดำเนินการ', 'ERP', 'PO', 'Script', current_timestamp, 'Script');
INSERT INTO su_program_label
(program_code, field_name, language_code, label_name, system_code, module_code, created_by, created_date, created_program)
VALUES('PORP10', 'StartDocNo', 'EN', 'Process Approval Request No. from', 'ERP', 'PO', 'Script', current_timestamp, 'Script');
INSERT INTO su_program_label
(program_code, field_name, language_code, label_name, system_code, module_code, created_by, created_date, created_program)
VALUES('PORP10', 'StartDocNo', 'TH', 'เลขที่ใบขออนุมัติดำเนินการ', 'ERP', 'PO', 'Script', current_timestamp, 'Script');
INSERT INTO su_program_label
(program_code, field_name, language_code, label_name, system_code, module_code, created_by, created_date, created_program)
VALUES('PORP10', 'Status', 'EN', 'Status', 'ERP', 'PO', 'Script', current_timestamp, 'Script');
INSERT INTO su_program_label
(program_code, field_name, language_code, label_name, system_code, module_code, created_by, created_date, created_program)
VALUES('PORP10', 'Status', 'TH', 'สถานะ', 'ERP', 'PO', 'Script', current_timestamp, 'Script');
INSERT INTO su_program_label
(program_code, field_name, language_code, label_name, system_code, module_code, created_by, created_date, created_program)
VALUES('PORP10', 'SubProduct', 'EN', 'Procurement Request Type', 'ERP', 'PO', 'Script', current_timestamp, 'Script');
INSERT INTO su_program_label
(program_code, field_name, language_code, label_name, system_code, module_code, created_by, created_date, created_program)
VALUES('PORP10', 'SubProduct', 'TH', 'ประเภทรายการขอซื้อ/จ้าง', 'ERP', 'PO', 'Script', current_timestamp, 'Script');
INSERT INTO su_program_label
(program_code, field_name, language_code, label_name, system_code, module_code, created_by, created_date, created_program)
VALUES('PORP10', 'To', 'EN', 'To', 'ERP', 'PO', 'Script', current_timestamp, 'Script');
INSERT INTO su_program_label
(program_code, field_name, language_code, label_name, system_code, module_code, created_by, created_date, created_program)
VALUES('PORP10', 'To', 'TH', 'ถึง', 'ERP', 'PO', 'Script', current_timestamp, 'Script');







INSERT INTO su_report_label
(program_code, field_name, language_code, label_name, system_code, module_code, created_by, created_date, created_program)
VALUES('PORP10', 'ALL', 'TH', 'ทั้งหมด', 'ERP', 'PO', NULL, NULL, NULL);
INSERT INTO su_report_label
(program_code, field_name, language_code, label_name, system_code, module_code, created_by, created_date, created_program)
VALUES('PORP10', 'ALL', 'EN', 'Total', 'ERP', 'PO', NULL, NULL, NULL);
INSERT INTO su_report_label
(program_code, field_name, language_code, label_name, system_code, module_code, created_by, created_date, created_program)
VALUES('PORP10', 'Amt', 'TH', 'จำนวนเงิน', 'ERP', 'PO', NULL, NULL, NULL);
INSERT INTO su_report_label
(program_code, field_name, language_code, label_name, system_code, module_code, created_by, created_date, created_program)
VALUES('PORP10', 'Amt', 'EN', 'Amount', 'ERP', 'PO', NULL, NULL, NULL);
INSERT INTO su_report_label
(program_code, field_name, language_code, label_name, system_code, module_code, created_by, created_date, created_program)
VALUES('PORP10', 'DiscBaht', 'TH', 'ส่วนลด(บาท)', 'ERP', 'PO', NULL, NULL, NULL);
INSERT INTO su_report_label
(program_code, field_name, language_code, label_name, system_code, module_code, created_by, created_date, created_program)
VALUES('PORP10', 'DiscBaht', 'EN', 'Discount (Baht)', 'ERP', 'PO', NULL, NULL, NULL);
INSERT INTO su_report_label
(program_code, field_name, language_code, label_name, system_code, module_code, created_by, created_date, created_program)
VALUES('PORP10', 'DiscPer', 'TH', 'ส่วนลด(%)', 'ERP', 'PO', NULL, NULL, NULL);
INSERT INTO su_report_label
(program_code, field_name, language_code, label_name, system_code, module_code, created_by, created_date, created_program)
VALUES('PORP10', 'DiscPer', 'EN', 'Discount (%)', 'ERP', 'PO', NULL, NULL, NULL);
INSERT INTO su_report_label
(program_code, field_name, language_code, label_name, system_code, module_code, created_by, created_date, created_program)
VALUES('PORP10', 'END', 'TH', 'สิ้นสุด', 'ERP', 'PO', NULL, NULL, NULL);
INSERT INTO su_report_label
(program_code, field_name, language_code, label_name, system_code, module_code, created_by, created_date, created_program)
VALUES('PORP10', 'END', 'EN', 'End', 'ERP', 'PO', NULL, NULL, NULL);
INSERT INTO su_report_label
(program_code, field_name, language_code, label_name, system_code, module_code, created_by, created_date, created_program)
VALUES('PORP10', 'EndDocDate', 'EN', 'Total by date of the Process approval request', 'ERP', 'PO', NULL, NULL, NULL);
INSERT INTO su_report_label
(program_code, field_name, language_code, label_name, system_code, module_code, created_by, created_date, created_program)
VALUES('PORP10', 'EndDocDate', 'TH', 'รวมตามวันที่ใบขออนุมัติดำเนินการ', 'ERP', 'PO', NULL, NULL, NULL);
INSERT INTO su_report_label
(program_code, field_name, language_code, label_name, system_code, module_code, created_by, created_date, created_program)
VALUES('PORP10', 'EndPcNo', 'EN', 'Total by the Process approval request permit number', 'ERP', 'PO', NULL, NULL, NULL);
INSERT INTO su_report_label
(program_code, field_name, language_code, label_name, system_code, module_code, created_by, created_date, created_program)
VALUES('PORP10', 'EndPcNo', 'TH', 'รวมตามเลขที่ใบขออนุมัติดำเนินการ', 'ERP', 'PO', NULL, NULL, NULL);
INSERT INTO su_report_label
(program_code, field_name, language_code, label_name, system_code, module_code, created_by, created_date, created_program)
VALUES('PORP10', 'No', 'EN', 'No.', 'ERP', 'PO', NULL, NULL, NULL);
INSERT INTO su_report_label
(program_code, field_name, language_code, label_name, system_code, module_code, created_by, created_date, created_program)
VALUES('PORP10', 'No', 'TH', 'ลำดับที่', 'ERP', 'PO', NULL, NULL, NULL);
INSERT INTO su_report_label
(program_code, field_name, language_code, label_name, system_code, module_code, created_by, created_date, created_program)
VALUES('PORP10', 'NoData', 'TH', 'ไม่พบข้อมูล', 'ERP', 'PO', NULL, NULL, NULL);
INSERT INTO su_report_label
(program_code, field_name, language_code, label_name, system_code, module_code, created_by, created_date, created_program)
VALUES('PORP10', 'NoData', 'EN', 'NoData', 'ERP', 'PO', NULL, NULL, NULL);
INSERT INTO su_report_label
(program_code, field_name, language_code, label_name, system_code, module_code, created_by, created_date, created_program)
VALUES('PORP10', 'OrganizationCodeName', 'TH', 'หน่วยงานจัดซื้อ/จัดจ้าง', 'ERP', 'PO', NULL, NULL, NULL);
INSERT INTO su_report_label
(program_code, field_name, language_code, label_name, system_code, module_code, created_by, created_date, created_program)
VALUES('PORP10', 'OrganizationCodeName', 'EN', 'Procurement/Hiring unit', 'ERP', 'PO', NULL, NULL, NULL);
INSERT INTO su_report_label
(program_code, field_name, language_code, label_name, system_code, module_code, created_by, created_date, created_program)
VALUES('PORP10', 'PCDate', 'EN', 'Procurement Permit Date', 'ERP', 'PO', NULL, NULL, NULL);
INSERT INTO su_report_label
(program_code, field_name, language_code, label_name, system_code, module_code, created_by, created_date, created_program)
VALUES('PORP10', 'PCDate', 'TH', 'วันที่ใบขออนุมัติดำเนินการ', 'ERP', 'PO', NULL, NULL, NULL);
INSERT INTO su_report_label
(program_code, field_name, language_code, label_name, system_code, module_code, created_by, created_date, created_program)
VALUES('PORP10', 'PRMethod', 'TH', 'วิธีจัดซื้อ/จัดจ้าง', 'ERP', 'PO', NULL, NULL, NULL);
INSERT INTO su_report_label
(program_code, field_name, language_code, label_name, system_code, module_code, created_by, created_date, created_program)
VALUES('PORP10', 'PRMethod', 'EN', 'Procurement/Hiring method', 'ERP', 'PO', NULL, NULL, NULL);
INSERT INTO su_report_label
(program_code, field_name, language_code, label_name, system_code, module_code, created_by, created_date, created_program)
VALUES('PORP10', 'PCNo', 'EN', 'Procurement permit number', 'ERP', 'PO', NULL, NULL, NULL);
INSERT INTO su_report_label
(program_code, field_name, language_code, label_name, system_code, module_code, created_by, created_date, created_program)
VALUES('PORP10', 'PCNo', 'TH', 'เลขที่ใบขออนุมัติดำเนินการ', 'ERP', 'PO', NULL, NULL, NULL);
INSERT INTO su_report_label
(program_code, field_name, language_code, label_name, system_code, module_code, created_by, created_date, created_program)
VALUES('PORP10', 'P_Date', 'TH', 'ตั้งแต่วันที่ใบขออนุมัติดำเนินการ', 'ERP', 'PO', NULL, NULL, NULL);
INSERT INTO su_report_label
(program_code, field_name, language_code, label_name, system_code, module_code, created_by, created_date, created_program)
VALUES('PORP10', 'P_Date', 'EN', 'Process approval request Date From', 'ERP', 'PO', NULL, NULL, NULL);
INSERT INTO su_report_label
(program_code, field_name, language_code, label_name, system_code, module_code, created_by, created_date, created_program)
VALUES('PORP10', 'P_DocNo', 'TH', 'ตั้งแต่เลขที่ใบขออนุมัติดำเนินการ', 'ERP', 'PO', NULL, NULL, NULL);
INSERT INTO su_report_label
(program_code, field_name, language_code, label_name, system_code, module_code, created_by, created_date, created_program)
VALUES('PORP10', 'P_DocNo', 'EN', 'Process approval request No. From', 'ERP', 'PO', NULL, NULL, NULL);
INSERT INTO su_report_label
(program_code, field_name, language_code, label_name, system_code, module_code, created_by, created_date, created_program)
VALUES('PORP10', 'P_Organization', 'TH', 'ตั้งแต่หน่วยงานจัดซื้อ/จัดจ้าง', 'ERP', 'PO', NULL, NULL, NULL);
INSERT INTO su_report_label
(program_code, field_name, language_code, label_name, system_code, module_code, created_by, created_date, created_program)
VALUES('PORP10', 'P_Organization', 'EN', 'Procurement/Hiring Division From', 'ERP', 'PO', NULL, NULL, NULL);
INSERT INTO su_report_label
(program_code, field_name, language_code, label_name, system_code, module_code, created_by, created_date, created_program)
VALUES('PORP10', 'P_ProductType', 'TH', 'ประเภทรายการขอซื้อ/จ้าง', 'ERP', 'PO', NULL, NULL, NULL);
INSERT INTO su_report_label
(program_code, field_name, language_code, label_name, system_code, module_code, created_by, created_date, created_program)
VALUES('PORP10', 'P_ProductType', 'EN', 'Procurement Request Type', 'ERP', 'PO', NULL, NULL, NULL);
INSERT INTO su_report_label
(program_code, field_name, language_code, label_name, system_code, module_code, created_by, created_date, created_program)
VALUES('PORP10', 'PageNo', 'TH', 'หน้าที่', 'ERP', 'PO', NULL, NULL, NULL);
INSERT INTO su_report_label
(program_code, field_name, language_code, label_name, system_code, module_code, created_by, created_date, created_program)
VALUES('PORP10', 'PageNo', 'EN', 'Page No.', 'ERP', 'PO', NULL, NULL, NULL);
INSERT INTO su_report_label
(program_code, field_name, language_code, label_name, system_code, module_code, created_by, created_date, created_program)
VALUES('PORP10', 'PQNo', 'TH', 'เลขที่ใบขออนุมัติจัดซื้อ/จัดจ้าง พร้อมแต่งตั้งคณะกรรมการ', 'ERP', 'PO', NULL, NULL, NULL);
INSERT INTO su_report_label
(program_code, field_name, language_code, label_name, system_code, module_code, created_by, created_date, created_program)
VALUES('PORP10', 'PQNo', 'EN', 'Procurement/Hiring No.', 'ERP', 'PO', NULL, NULL, NULL);
INSERT INTO su_report_label
(program_code, field_name, language_code, label_name, system_code, module_code, created_by, created_date, created_program)
VALUES('PORP10', 'PrintBy', 'TH', 'ผู้พิมพ์', 'ERP', 'PO', NULL, NULL, NULL);
INSERT INTO su_report_label
(program_code, field_name, language_code, label_name, system_code, module_code, created_by, created_date, created_program)
VALUES('PORP10', 'PrintBy', 'EN', 'Printed by', 'ERP', 'PO', NULL, NULL, NULL);
INSERT INTO su_report_label
(program_code, field_name, language_code, label_name, system_code, module_code, created_by, created_date, created_program)
VALUES('PORP10', 'PrintDate', 'TH', 'วันที่พิมพ์', 'ERP', 'PO', NULL, NULL, NULL);
INSERT INTO su_report_label
(program_code, field_name, language_code, label_name, system_code, module_code, created_by, created_date, created_program)
VALUES('PORP10', 'PrintDate', 'EN', 'Print date', 'ERP', 'PO', NULL, NULL, NULL);
INSERT INTO su_report_label
(program_code, field_name, language_code, label_name, system_code, module_code, created_by, created_date, created_program)
VALUES('PORP10', 'ProductCode', 'TH', 'รหัสสินค้า', 'ERP', 'PO', NULL, NULL, NULL);
INSERT INTO su_report_label
(program_code, field_name, language_code, label_name, system_code, module_code, created_by, created_date, created_program)
VALUES('PORP10', 'ProductCode', 'EN', 'Product code', 'ERP', 'PO', NULL, NULL, NULL);
INSERT INTO su_report_label
(program_code, field_name, language_code, label_name, system_code, module_code, created_by, created_date, created_program)
VALUES('PORP10', 'ProductName', 'TH', 'ชื่อสินค้า', 'ERP', 'PO', NULL, NULL, NULL);
INSERT INTO su_report_label
(program_code, field_name, language_code, label_name, system_code, module_code, created_by, created_date, created_program)
VALUES('PORP10', 'ProductName', 'EN', 'Product name', 'ERP', 'PO', NULL, NULL, NULL);
INSERT INTO su_report_label
(program_code, field_name, language_code, label_name, system_code, module_code, created_by, created_date, created_program)
VALUES('PORP10', 'ProgramCode', 'TH', 'รหัสโปรแกรม', 'ERP', 'PO', NULL, NULL, NULL);
INSERT INTO su_report_label
(program_code, field_name, language_code, label_name, system_code, module_code, created_by, created_date, created_program)
VALUES('PORP10', 'ProgramCode', 'EN', 'Program code', 'ERP', 'PO', NULL, NULL, NULL);
INSERT INTO su_report_label
(program_code, field_name, language_code, label_name, system_code, module_code, created_by, created_date, created_program)
VALUES('PORP10', 'ProgramCodes', 'TH', 'PORP10', 'ERP', 'PO', NULL, NULL, NULL);
INSERT INTO su_report_label
(program_code, field_name, language_code, label_name, system_code, module_code, created_by, created_date, created_program)
VALUES('PORP10', 'ProgramCodes', 'EN', 'PORP10', 'ERP', 'PO', NULL, NULL, NULL);
INSERT INTO su_report_label
(program_code, field_name, language_code, label_name, system_code, module_code, created_by, created_date, created_program)
VALUES('PORP10', 'Qty', 'TH', 'จำนวน', 'ERP', 'PO', NULL, NULL, NULL);
INSERT INTO su_report_label
(program_code, field_name, language_code, label_name, system_code, module_code, created_by, created_date, created_program)
VALUES('PORP10', 'Qty', 'EN', 'Quantity', 'ERP', 'PO', NULL, NULL, NULL);
INSERT INTO su_report_label
(program_code, field_name, language_code, label_name, system_code, module_code, created_by, created_date, created_program)
VALUES('PORP10', 'Remark', 'TH', 'รายละเอียด', 'ERP', 'PO', NULL, NULL, NULL);
INSERT INTO su_report_label
(program_code, field_name, language_code, label_name, system_code, module_code, created_by, created_date, created_program)
VALUES('PORP10', 'Remark', 'EN', 'Details', 'ERP', 'PO', NULL, NULL, NULL);
INSERT INTO su_report_label
(program_code, field_name, language_code, label_name, system_code, module_code, created_by, created_date, created_program)
VALUES('PORP10', 'ReportName', 'EN', 'Process Approval Request Report', 'ERP', 'PO', NULL, NULL, NULL);
INSERT INTO su_report_label
(program_code, field_name, language_code, label_name, system_code, module_code, created_by, created_date, created_program)
VALUES('PORP10', 'ReportName', 'TH', 'รายงานใบขออนุมัติดำเนินการ', 'ERP', 'PO', NULL, NULL, NULL);
INSERT INTO su_report_label
(program_code, field_name, language_code, label_name, system_code, module_code, created_by, created_date, created_program)
VALUES('PORP10', 'START', 'TH', 'เริ่มต้น', 'ERP', 'PO', NULL, NULL, NULL);
INSERT INTO su_report_label
(program_code, field_name, language_code, label_name, system_code, module_code, created_by, created_date, created_program)
VALUES('PORP10', 'START', 'EN', 'Start', 'ERP', 'PO', NULL, NULL, NULL);
INSERT INTO su_report_label
(program_code, field_name, language_code, label_name, system_code, module_code, created_by, created_date, created_program)
VALUES('PORP10', 'Status', 'TH', 'สถานะ', 'ERP', 'PO', NULL, NULL, NULL);
INSERT INTO su_report_label
(program_code, field_name, language_code, label_name, system_code, module_code, created_by, created_date, created_program)
VALUES('PORP10', 'Status', 'EN', 'Status', 'ERP', 'PO', NULL, NULL, NULL);
INSERT INTO su_report_label
(program_code, field_name, language_code, label_name, system_code, module_code, created_by, created_date, created_program)
VALUES('PORP10', 'Subject', 'TH', 'เรื่อง', 'ERP', 'PO', NULL, NULL, NULL);
INSERT INTO su_report_label
(program_code, field_name, language_code, label_name, system_code, module_code, created_by, created_date, created_program)
VALUES('PORP10', 'Subject', 'EN', 'Subject', 'ERP', 'PO', NULL, NULL, NULL);
INSERT INTO su_report_label
(program_code, field_name, language_code, label_name, system_code, module_code, created_by, created_date, created_program)
VALUES('PORP10', 'To', 'TH', 'ถึง', 'ERP', 'PO', NULL, NULL, NULL);
INSERT INTO su_report_label
(program_code, field_name, language_code, label_name, system_code, module_code, created_by, created_date, created_program)
VALUES('PORP10', 'To', 'EN', 'To', 'ERP', 'PO', NULL, NULL, NULL);
INSERT INTO su_report_label
(program_code, field_name, language_code, label_name, system_code, module_code, created_by, created_date, created_program)
VALUES('PORP10', 'UmsName', 'TH', 'หน่วยนับ', 'ERP', 'PO', NULL, NULL, NULL);
INSERT INTO su_report_label
(program_code, field_name, language_code, label_name, system_code, module_code, created_by, created_date, created_program)
VALUES('PORP10', 'UmsName', 'EN', 'Unit', 'ERP', 'PO', NULL, NULL, NULL);
INSERT INTO su_report_label
(program_code, field_name, language_code, label_name, system_code, module_code, created_by, created_date, created_program)
VALUES('PORP10', 'UnitPrice', 'TH', 'ราคาต่อหน่วย', 'ERP', 'PO', NULL, NULL, NULL);
INSERT INTO su_report_label
(program_code, field_name, language_code, label_name, system_code, module_code, created_by, created_date, created_program)
VALUES('PORP10', 'UnitPrice', 'EN', 'Unit price', 'ERP', 'PO', NULL, NULL, NULL);
INSERT INTO su_report_label
(program_code, field_name, language_code, label_name, system_code, module_code, created_by, created_date, created_program)
VALUES('PORP10', 'VAT_E', 'TH', 'แยกภาษี  ', 'ERP', 'PO', NULL, NULL, NULL);
INSERT INTO su_report_label
(program_code, field_name, language_code, label_name, system_code, module_code, created_by, created_date, created_program)
VALUES('PORP10', 'VAT_E', 'EN', 'Tax separated', 'ERP', 'PO', NULL, NULL, NULL);
INSERT INTO su_report_label
(program_code, field_name, language_code, label_name, system_code, module_code, created_by, created_date, created_program)
VALUES('PORP10', 'VAT_I', 'TH', 'รวมภาษี  ', 'ERP', 'PO', NULL, NULL, NULL);
INSERT INTO su_report_label
(program_code, field_name, language_code, label_name, system_code, module_code, created_by, created_date, created_program)
VALUES('PORP10', 'VAT_I', 'EN', 'Include tax', 'ERP', 'PO', NULL, NULL, NULL);
INSERT INTO su_report_label
(program_code, field_name, language_code, label_name, system_code, module_code, created_by, created_date, created_program)
VALUES('PORP10', 'VAT_N', 'TH', 'ไม่คิดภาษี', 'ERP', 'PO', NULL, NULL, NULL);
INSERT INTO su_report_label
(program_code, field_name, language_code, label_name, system_code, module_code, created_by, created_date, created_program)
VALUES('PORP10', 'VAT_N', 'EN', 'No tax', 'ERP', 'PO', NULL, NULL, NULL);
INSERT INTO su_report_label
(program_code, field_name, language_code, label_name, system_code, module_code, created_by, created_date, created_program)
VALUES('PORP10', 'VatAmt', 'TH', 'มูลค่าภาษี', 'ERP', 'PO', NULL, NULL, NULL);
INSERT INTO su_report_label
(program_code, field_name, language_code, label_name, system_code, module_code, created_by, created_date, created_program)
VALUES('PORP10', 'VatAmt', 'EN', 'Tax value', 'ERP', 'PO', NULL, NULL, NULL);
