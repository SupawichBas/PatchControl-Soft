ALTER TABLE erp.po_committee_type_lang ALTER COLUMN committee_type_name TYPE varchar(200) USING committee_type_name::varchar;
