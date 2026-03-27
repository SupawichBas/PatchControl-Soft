DROP FUNCTION dbo.report_smexod03_sub3;

CREATE OR REPLACE FUNCTION dbo.report_smexod03_sub3(p_lin_id character varying, p_work_flow_id integer)
 RETURNS TABLE(expense_perdiem_id integer, expense_code character varying, expense_name character varying, description character varying, perdiem_item_id integer, perdiem_date character varying, perdiem_detail character varying, item_perdiem_amount numeric, perdiem_amount numeric, currency_code character varying, perdiem_local_amount numeric, local_amount numeric)
 LANGUAGE plpgsql
AS $function$ 
BEGIN
    RETURN QUERY
SELECT fep.expense_perdiem_id::integer AS expense_perdiem_id,
	diel.expense_code::varchar AS expense_code,
	diel.expense_name::varchar AS expense_name,
	fep.description::varchar AS description,
	fepi.perdiem_item_id::integer AS perdiem_item_id,
	to_CHAR( fepi.perdiem_date,'DD/MM/YYYY')::varchar AS perdiem_date,
	fepi.perdiem_detail::varchar AS perdiem_detail,
	coalesce(fepi.curr_amount,0)::numeric AS item_perdiem_amount,
	coalesce(fep.curr_amount,0)::numeric AS perdiem_amount,
	fepi.currency_code::varchar AS currency_code,
	coalesce(fep.local_amount,0)::numeric AS perdiem_local_amount,
	coalesce(fepi.local_amount,0)::numeric AS local_amount
FROM fn_expense_perdiem fep
	left join fn_expense_perdiem_item fepi ON fepi.expense_perdiem_id = fep.expense_perdiem_id 
	LEFT join db_income_expense die ON die.expense_code = fep.expense_code 
		and die.company_code = fep.company_code 
   	LEFT JOIN db_income_expense_lang diel on diel.expense_code = die.expense_code
   		and diel.company_code = die.company_code 
		and diel.expense_group_code = die.expense_group_code 
    	and diel.language_code = p_lin_id
WHERE 
	 fep.work_flow_id =  p_work_flow_id
     ORDER BY fep.expense_perdiem_id;
END;
$function$
;
