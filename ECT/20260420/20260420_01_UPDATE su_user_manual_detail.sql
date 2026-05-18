UPDATE su_user_manual_detail
SET active = false,
    updated_by ='script',
    updated_date = CURRENT_TIMESTAMP,
    updated_program = 'script'
WHERE group_code='UserTraining' AND value='2-2';

UPDATE su_user_manual_detail
SET description='1-1 ขั้นตอนการจัดทำคำของบประมาณบริหารองค์กรประจำปี', updated_by='script', updated_date=CURRENT_TIMESTAMP, updated_program='script'
WHERE group_code='UserTraining' AND value='1-1';
UPDATE su_user_manual_detail
SET description='1-2 ขั้นตอนการจัดทำคำของบประมาณโครงการประจำปี', updated_by='script', updated_date=CURRENT_TIMESTAMP, updated_program='script'
WHERE group_code='UserTraining' AND value='1-2';
UPDATE su_user_manual_detail
SET description='2. การเบิกจ่ายกรณีจัดซื้อจัดจ้าง', updated_by='script', updated_date=CURRENT_TIMESTAMP, updated_program='script'
WHERE group_code='UserTraining' AND value='2';
UPDATE su_user_manual_detail
SET description='2-1 ขั้นตอนขอเบิกจ่ายกรณีจัดซื้อจัดจ้าง', updated_by='script', updated_date=CURRENT_TIMESTAMP, updated_program='script'
WHERE group_code='UserTraining' AND value='2-1';
UPDATE su_user_manual_detail
SET description='3. การเบิกจ่ายทั่วไป', updated_by='script', updated_date=CURRENT_TIMESTAMP, updated_program='script'
WHERE group_code='UserTraining' AND value='3';
UPDATE su_user_manual_detail
SET description='3-1 ขั้นตอนเบิกจ่ายทั่วไป',updated_by='script', updated_date=CURRENT_TIMESTAMP, updated_program='script'
WHERE group_code='UserTraining' AND value='3-1';
UPDATE su_user_manual_detail
SET description='5. การรับเงินเพื่อตั้งเบิก',updated_by='script', updated_date=CURRENT_TIMESTAMP, updated_program='script'
WHERE group_code='UserTraining' AND value='5';
UPDATE su_user_manual_detail
SET description='5-1 การรับเงิน-ตั้งเบิกเงิน',updated_by='script', updated_date=CURRENT_TIMESTAMP, updated_program='script'
WHERE group_code='UserTraining' AND value='5-1';
UPDATE su_user_manual_detail
SET description='8. ลูกหนี้อื่นๆ',updated_by='script', updated_date=CURRENT_TIMESTAMP, updated_program='script'
WHERE group_code='UserTraining' AND value='8';
UPDATE su_user_manual_detail
SET description='8-1 ขั้นตอนการตั้งหนี้ลูกหนี้',updated_by='script', updated_date=CURRENT_TIMESTAMP, updated_program='script'
WHERE group_code='UserTraining' AND value='8-1';



--Lang

UPDATE su_user_manual_detail_lang
SET value_text='1-1 ขั้นตอนการจัดทำคำของบประมาณบริหารองค์กรประจำปี', updated_by='script', updated_date=CURRENT_TIMESTAMP, updated_program='script'
WHERE group_code='UserTraining' AND value='1-1' AND language_code='TH';
UPDATE su_user_manual_detail_lang
SET value_text='1-1 ขั้นตอนการจัดทำคำของบประมาณบริหารองค์กรประจำปี', updated_by='script', updated_date=CURRENT_TIMESTAMP, updated_program='script'
WHERE group_code='UserTraining' AND value='1-1' AND language_code='EN';

UPDATE su_user_manual_detail_lang
SET value_text='1-2 ขั้นตอนการจัดทำคำของบประมาณโครงการประจำปี', updated_by='script', updated_date=CURRENT_TIMESTAMP, updated_program='script'
WHERE group_code='UserTraining' AND value='1-2' AND language_code='TH';
UPDATE su_user_manual_detail_lang
SET value_text='1-2 ขั้นตอนการจัดทำคำของบประมาณโครงการประจำปี', updated_by='script', updated_date=CURRENT_TIMESTAMP, updated_program='script'
WHERE group_code='UserTraining' AND value='1-2' AND language_code='EN';

UPDATE su_user_manual_detail_lang
SET value_text='2. การเบิกจ่ายกรณีจัดซื้อจัดจ้าง', updated_by='script', updated_date=CURRENT_TIMESTAMP, updated_program='script'
WHERE group_code='UserTraining' AND value='2' AND language_code='TH';
UPDATE su_user_manual_detail_lang
SET value_text='2. การเบิกจ่ายกรณีจัดซื้อจัดจ้าง', updated_by='script', updated_date=CURRENT_TIMESTAMP, updated_program='script'
WHERE group_code='UserTraining' AND value='2' AND language_code='EN';

UPDATE su_user_manual_detail_lang
SET value_text='2-1 ขั้นตอนขอเบิกจ่ายกรณีจัดซื้อจัดจ้าง', updated_by='script', updated_date=CURRENT_TIMESTAMP, updated_program='script'
WHERE group_code='UserTraining' AND value='2-1' AND language_code='TH';
UPDATE su_user_manual_detail_lang
SET value_text='2-1 ขั้นตอนขอเบิกจ่ายกรณีจัดซื้อจัดจ้าง', updated_by='script', updated_date=CURRENT_TIMESTAMP, updated_program='script'
WHERE group_code='UserTraining' AND value='2-1' AND language_code='EN';

UPDATE su_user_manual_detail_lang
SET value_text='3. การเบิกจ่ายทั่วไป', updated_by='script', updated_date=CURRENT_TIMESTAMP, updated_program='script'
WHERE group_code='UserTraining' AND value='3' AND language_code='TH';
UPDATE su_user_manual_detail_lang
SET value_text='3. การเบิกจ่ายทั่วไป', updated_by='script', updated_date=CURRENT_TIMESTAMP, updated_program='script'
WHERE group_code='UserTraining' AND value='3' AND language_code='EN';

UPDATE su_user_manual_detail_lang
SET value_text='3-1 ขั้นตอนเบิกจ่ายทั่วไป', updated_by='script', updated_date=CURRENT_TIMESTAMP, updated_program='script'
WHERE group_code='UserTraining' AND value='3-1' AND language_code='TH';
UPDATE su_user_manual_detail_lang
SET value_text='3-1 ขั้นตอนเบิกจ่ายทั่วไป', updated_by='script', updated_date=CURRENT_TIMESTAMP, updated_program='script'
WHERE group_code='UserTraining' AND value='3-1' AND language_code='EN';

UPDATE su_user_manual_detail_lang
SET value_text='5. การรับเงินเพื่อตั้งเบิก', updated_by='script', updated_date=CURRENT_TIMESTAMP, updated_program='script'
WHERE group_code='UserTraining' AND value='5' AND language_code='TH';
UPDATE su_user_manual_detail_lang
SET value_text='5. การรับเงินเพื่อตั้งเบิก', updated_by='script', updated_date=CURRENT_TIMESTAMP, updated_program='script'
WHERE group_code='UserTraining' AND value='5' AND language_code='EN';

UPDATE su_user_manual_detail_lang
SET value_text='5-1 การรับเงิน-ตั้งเบิกเงิน', updated_by='script', updated_date=CURRENT_TIMESTAMP, updated_program='script'
WHERE group_code='UserTraining' AND value='5-1' AND language_code='TH';
UPDATE su_user_manual_detail_lang
SET value_text='5-1 การรับเงิน-ตั้งเบิกเงิน', updated_by='script', updated_date=CURRENT_TIMESTAMP, updated_program='script'
WHERE group_code='UserTraining' AND value='5-1' AND language_code='EN';

UPDATE su_user_manual_detail_lang
SET value_text='8. ลูกหนี้อื่นๆ', updated_by='script', updated_date=CURRENT_TIMESTAMP, updated_program='script'
WHERE group_code='UserTraining' AND value='8' AND language_code='TH';
UPDATE su_user_manual_detail_lang
SET value_text='8. ลูกหนี้อื่นๆ', updated_by='script', updated_date=CURRENT_TIMESTAMP, updated_program='script'
WHERE group_code='UserTraining' AND value='8' AND language_code='EN';


UPDATE su_user_manual_detail_lang
SET value_text='9-2 ขั้นตอนการจัดทำแผนและผลการปฏิบัติงาน(แบบ กกต.301)', updated_by='script', updated_date=CURRENT_TIMESTAMP, updated_program='script'
WHERE group_code='UserTraining' AND value='9-2' AND language_code='TH';
UPDATE su_user_manual_detail_lang
SET value_text='9-2 ขั้นตอนการจัดทำแผนและผลการปฏิบัติงาน(แบบ กกต.301)', updated_by='script', updated_date=CURRENT_TIMESTAMP, updated_program='script'
WHERE group_code='UserTraining' AND value='9-2' AND language_code='EN';

UPDATE su_user_manual_detail_lang
SET value_text='9-3 ขั้นตอนการประเมินผลตัวชี้วัดตามกิจกรรมรอง', updated_by='script', updated_date=CURRENT_TIMESTAMP, updated_program='script'
WHERE group_code='UserTraining' AND value='9-3' AND language_code='TH';
UPDATE su_user_manual_detail_lang
SET value_text='9-3 ขั้นตอนการประเมินผลตัวชี้วัดตามกิจกรรมรอง', updated_by='script', updated_date=CURRENT_TIMESTAMP, updated_program='script'
WHERE group_code='UserTraining' AND value='9-3' AND language_code='EN';