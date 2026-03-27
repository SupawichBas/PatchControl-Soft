UPDATE db_list_value_lang
SET value_text='วันที่ประกาศร่าง เอกสารประกวดราคาอิเล็กทรอนิกส์/รายงานขอซื้อขอจ้าง', updated_by='Migrate', updated_date=current_timestamp, updated_program='Migrate'
WHERE group_code='VariablePODT12' and value='Variable3' and  language_code='TH';
