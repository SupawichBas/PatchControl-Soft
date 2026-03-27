UPDATE db_list_value
SET description='เครื่องบิน', parent_group_code=NULL, parent_value=NULL, "sequence"=1, active=true, created_by='Procedure_Copy', created_date='2025-04-01 16:10:31.011', created_program='Procedure_Copy', updated_by=NULL, updated_date=NULL, updated_program=NULL
WHERE company_code='KNEX' AND group_code='TravelBy' AND value='Airplane';
UPDATE db_list_value
SET description='รถยนต์บริษัท', parent_group_code=NULL, parent_value=NULL, "sequence"=2, active=true, created_by='Procedure_Copy', created_date='2025-04-01 16:10:31.011', created_program='Procedure_Copy', updated_by=NULL, updated_date=NULL, updated_program=NULL
WHERE company_code='KNEX' AND group_code='TravelBy' AND value='CompanyCar';
UPDATE db_list_value
SET description='รถยนต์ส่วนตัว', parent_group_code=NULL, parent_value=NULL, "sequence"=3, active=true, created_by='Procedure_Copy', created_date='2025-04-01 16:10:31.011', created_program='Procedure_Copy', updated_by=NULL, updated_date=NULL, updated_program=NULL
WHERE company_code='KNEX' AND group_code='TravelBy' AND value='OwnCar';
UPDATE db_list_value
SET description='รถยนต์เช่า', parent_group_code=NULL, parent_value=NULL, "sequence"=4, active=true, created_by='Procedure_Copy', created_date='2025-04-01 16:10:31.011', created_program='Procedure_Copy', updated_by=NULL, updated_date=NULL, updated_program=NULL
WHERE company_code='KNEX' AND group_code='TravelBy' AND value='RentCar';
UPDATE db_list_value
SET description='รถไฟ', parent_group_code=NULL, parent_value=NULL, "sequence"=5, active=false, created_by='Procedure_Copy', created_date='2025-04-01 16:10:31.011', created_program='Procedure_Copy', updated_by='Script', updated_date='2025-09-10 16:04:48.925', updated_program='Migrate'
WHERE company_code='KNEX' AND group_code='TravelBy' AND value='Train';
UPDATE db_list_value
SET description='รถยนต์โดยสาร', parent_group_code=NULL, parent_value=NULL, "sequence"=6, active=false, created_by='Procedure_Copy', created_date='2025-04-01 16:10:31.011', created_program='Procedure_Copy', updated_by='Script', updated_date='2025-09-10 16:04:48.925', updated_program='Migrate'
WHERE company_code='KNEX' AND group_code='TravelBy' AND value='Transportation';
