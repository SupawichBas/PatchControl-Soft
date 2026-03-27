UPDATE db_parameter
SET parameter_value='100000', order_seq=1, remark='(PORP09) วงเงินไม่เกิน 100,000 บาท', created_by='DB_Migrate_20241206', created_date='2024-12-06 11:53:54.382', created_program='Script', updated_by='Script', updated_date='2024-12-06 11:53:54.382', updated_program='Script', "version"=NULL
WHERE pgm_setup='PO' AND parameter_name='ParameterWhereAmtReportPorp07';