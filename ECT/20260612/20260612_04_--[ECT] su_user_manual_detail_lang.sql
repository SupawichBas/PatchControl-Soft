--[ECT] su_user_manual_detail_lang
INSERT INTO su_user_manual_detail_lang 
(group_code, value, language_code, value_text, created_by, created_date, created_program, updated_by, updated_date, updated_program)

-- ส่วนของภาษาไทย (TH)
SELECT 
    group_code, 
    value, 
    'TH' AS language_code, 
    description AS value_text, 
    created_by, 
    created_date, 
    created_program, 
    updated_by, 
    updated_date, 
    updated_program
FROM su_user_manual_detail
WHERE group_code = 'UserVdoTraining'

UNION ALL

-- ส่วนของภาษาอังกฤษ (EN)
SELECT
    group_code, 
    value, 
    'EN' AS language_code, 
    description AS value_text, -- สามารถแก้ข้อความภาษาอังกฤษได้ตามต้องการ
    created_by, 
    created_date, 
    created_program, 
    updated_by, 
    updated_date, 
    updated_program
FROM su_user_manual_detail
WHERE group_code = 'UserVdoTraining'

order by 2;