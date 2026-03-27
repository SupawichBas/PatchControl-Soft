UPDATE su_program_label
SET label_name='Setup Cost Center Department', system_code='DB', module_code='EXP', created_by='Script', created_date='2024-09-13 10:39:49.698', created_program='Migrate', updated_by=NULL, updated_date=NULL, updated_program=NULL
WHERE program_code='SMDBRT19' AND field_name='Header' AND language_code='EN';
UPDATE su_program_label
SET label_name='โปรแกรมจัดการหน่วยงานต้นทุน', system_code='DB', module_code='EXP', created_by='Script', created_date='2024-09-13 10:39:49.698', created_program='Migrate', updated_by=NULL, updated_date=NULL, updated_program=NULL
WHERE program_code='SMDBRT19' AND field_name='Header' AND language_code='TH';
UPDATE su_menu_label
SET menu_name='Setup Cost Center Department', system_code='EXP', created_by='Script', created_date='2024-09-10 14:22:44.351', created_program='Migrate', updated_by=NULL, updated_date=NULL, updated_program=NULL, description='Setup Cost Center'
WHERE menu_code='M0000800110' AND language_code='EN';
UPDATE su_menu_label
SET menu_name='โปรแกรมจัดการหน่วยงานต้นทุน', system_code='EXP', created_by='Script', created_date='2024-09-10 14:22:44.351', created_program='Migrate', updated_by=NULL, updated_date=NULL, updated_program=NULL, description='โปรแกรมจัดการหน่วยงาน'
WHERE menu_code='M0000800110' AND language_code='TH';



