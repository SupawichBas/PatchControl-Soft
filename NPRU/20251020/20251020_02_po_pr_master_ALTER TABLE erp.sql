ALTER TABLE erp.po_pr_master ADD report_date timestamp NULL;
COMMENT ON COLUMN erp.po_pr_master.report_date IS 'วันที่รายงานขอซื้อขอจ้าง';

ALTER TABLE erp.po_pr_master ADD report_std_price numeric(19, 2) NULL;
COMMENT ON COLUMN erp.po_pr_master.report_std_price IS 'ราคากลางของพัสดุที่จะจ้าง';
