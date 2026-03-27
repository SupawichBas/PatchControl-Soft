-- DROP FUNCTION erp.po_format_date_for_report(date, varchar);

CREATE OR REPLACE FUNCTION erp.po_format_date_for_report(receipt_date date, p_lin_id character varying)
 RETURNS text
 LANGUAGE plpgsql
AS $function$
DECLARE 
    format_date varchar(200);
BEGIN
    select case when receipt_date is not null then 
					case p_lin_id when 'TH' then 
							concat(to_char(extract(day from receipt_date) ,'FM09') ,'/' ,to_char(extract(month from receipt_date) ,'FM09') ,'/' ,to_char(extract(year from receipt_date) +543 ,'FM9999'))
						else
							concat(to_char(extract(day from receipt_date) ,'FM09') ,'/' ,to_char(extract(month from receipt_date) ,'FM09') ,'/' ,to_char(extract(year from receipt_date) ,'FM9999'))
						end
					end::character varying as doc_date
	into format_date;
	RETURN format_date;
END;
$function$
;
