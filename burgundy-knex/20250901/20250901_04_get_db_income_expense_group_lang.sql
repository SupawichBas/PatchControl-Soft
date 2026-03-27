drop function get_db_income_expense_group_lang;

CREATE OR REPLACE FUNCTION dbo.get_db_income_expense_group_lang(p_company_code character varying, p_configuration_value character varying, p_lin_id character varying)
 RETURNS text
 LANGUAGE plpgsql
AS $function$
DECLARE expense_group_name text := '';
begin
	
	select dlvl.value_text
	into expense_group_name
		from db_list_value_lang dlvl 
		where dlvl.company_code = p_company_code
		and dlvl.value = p_configuration_value
		and dlvl.language_code = p_lin_id;
    RETURN expense_group_name;
END;
$function$
;
