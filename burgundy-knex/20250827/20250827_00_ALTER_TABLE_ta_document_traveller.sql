ALTER TABLE dbo.ta_document_traveller ADD IsFlight bool NULL;
COMMENT ON COLUMN dbo.ta_document_traveller.IsFlight IS 'สำหรับจองตั๋วเครื่องบิน';


ALTER TABLE dbo.ta_document_traveller ADD IsHotel bool NULL;
COMMENT ON COLUMN dbo.ta_document_traveller.IsHotel IS 'สำหรับจองโรงแรม';