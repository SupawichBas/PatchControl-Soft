-- 1. ลบ Constraint เดิมออกก่อน
ALTER TABLE po_ms_default_values 
DROP CONSTRAINT uqpo_ms_default_values;

-- 2. สร้าง Constraint ใหม่โดยจับคู่ 2 คอลัมน์
ALTER TABLE po_ms_default_values 
ADD CONSTRAINT uqpo_ms_default_values UNIQUE (div_code, ms_div_code);