ALTER TABLE erp.po_committee_type ADD goods_tor_committee bool NULL;
COMMENT ON COLUMN erp.po_committee_type.goods_tor_committee IS 'คณะกรรมร่าง TOR';