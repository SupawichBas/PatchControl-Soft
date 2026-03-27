UPDATE DbDocStatus
SET OrderSeq=5, UpdBy='Script', UpdDate=CURRENT_TIMESTAMP, UpdProgID='Migrate'
WHERE TableName=N'SrcDocument'and ColumnName=N'Status'and StatusValue=N'Complete' ;