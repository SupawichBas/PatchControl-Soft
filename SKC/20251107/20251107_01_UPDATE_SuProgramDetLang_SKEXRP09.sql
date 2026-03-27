UPDATE SuProgramDetLang
SET LabelName=N'เลขที่เอกสาร', UpdBy=N'Script', UpdDate=current_timestamp, UpdProgID=N'Migrate'
WHERE ProgramId=N'SKEXRP09' and LanguageCode=N'TH' and ObjectName=N'LB_DOCUMENT_NUMBER';

UPDATE SuProgramDetLang
SET LabelName=N'เลขประจำตัวผู้เสียภาษี', UpdBy=N'Script', UpdDate=current_timestamp, UpdProgID=N'Migrate'
WHERE ProgramId=N'SKEXRP09' and LanguageCode=N'TH' and ObjectName=N'LB_VENDOR_TAX_ID';