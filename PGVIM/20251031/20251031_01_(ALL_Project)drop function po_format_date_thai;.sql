drop function po_format_date_thai;

CREATE OR REPLACE FUNCTION erp.po_format_date_thai(labelday character varying, labelmonth character varying, labelyear character varying, receipt_date date, p_lin_id character varying)
 RETURNS text
 LANGUAGE plpgsql
AS $function$
DECLARE 
    format_date_thai varchar(200);
BEGIN
    select concat(coalesce(labelday,''),
		    case when labelday is null then '' else ' 'end,
			concat(to_char(receipt_date, 'FMDD')),
		    ' ',
		    coalesce(labelmonth,''),
		    case when labelmonth is null then '' else ' 'end,
		    Monthlang.value_text,
		    ' ',
		    coalesce(labelyear,''),
		    case when labelmonth is null then '' else ' 'end,
		    to_char(extract(year from receipt_date) +543 ,'FM9999'))
	into format_date_thai
	from db_list_value_lang Monthlang
	where Monthlang.group_code = 'Month'
	and Monthlang.value = TO_CHAR(receipt_date, 'FMMM')
	and lower(Monthlang.language_code) = lower(p_lin_id);
	return format_date_thai;
END;
$function$
;
