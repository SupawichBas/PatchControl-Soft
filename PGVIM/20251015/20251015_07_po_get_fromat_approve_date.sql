CREATE OR REPLACE FUNCTION erp.po_get_fromat_approve_date(p_date_value date)
 RETURNS character varying
 LANGUAGE plpgsql
AS $function$
DECLARE
    formatted_date character varying;
BEGIN
    IF p_date_value IS NOT NULL THEN
        formatted_date := concat(
            to_char(p_date_value, 'FMDD'), '/',
            to_char(p_date_value, 'FMMM'), '/',
            to_char(extract(year FROM p_date_value) + 543, 'FM9999')
        );
    ELSE
        formatted_date := '.............../.............../...............';
    END IF;

    RETURN formatted_date;
END;
$function$
;
