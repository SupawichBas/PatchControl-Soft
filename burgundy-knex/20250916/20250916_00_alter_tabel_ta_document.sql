ALTER TABLE dbo.ta_document ALTER COLUMN from_date TYPE timestamptz USING from_date::timestamptz;
ALTER TABLE dbo.ta_document ALTER COLUMN to_date TYPE timestamptz USING to_date::timestamptz;

ALTER TABLE dbo.ta_document_schedule ALTER COLUMN "date" TYPE timestamptz USING "date"::timestamptz;