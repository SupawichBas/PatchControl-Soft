 DROP FUNCTION erp.po_format_month_date_thai;

CREATE OR REPLACE FUNCTION erp.po_format_month_date_thai(receipt_date date, p_lin_id character varying)
 RETURNS text
 LANGUAGE plpgsql
AS $function$
DECLARE 
    format_month_thai varchar(200);
BEGIN
    select concat(Monthlang.value_text)
	into format_month_thai
	from db_list_value_lang Monthlang
	where Monthlang.group_code = 'Month'
	and Monthlang.value = TO_CHAR(receipt_date, 'FMMM')
	and lower(Monthlang.language_code) = lower(p_lin_id);
	return format_month_thai;
END;
$function$
;
