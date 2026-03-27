-- DROP FUNCTION dbo.report_smexod03_sub2(varchar, int4);

CREATE OR REPLACE FUNCTION dbo.report_smexod03_sub2(p_lin_id character varying, p_work_flow_id integer)
 RETURNS TABLE(expense_mileage_id integer, expense_code character varying, expense_name character varying, description character varying, mileage_rate numeric, mileage_from character varying, mileage_to character varying, mileage_distance numeric, total_amount numeric, currency_code character varying, curr_amount numeric)
 LANGUAGE plpgsql
AS $function$ 
BEGIN
    RETURN QUERY
SELECT fem.expense_mileage_id::integer as expense_mileage_id,
	diel.expense_code::varchar as expense_code,
	diel.expense_name::varchar as expense_name,
	fem.description::varchar as description,
	coalesce(fem.mileage_rate,0)::numeric  as mileage_rate,
	fem.mileage_from::varchar as mileage_from,
	fem.mileage_to::varchar as mileage_to,
	coalesce(fem.mileage_distance,0)::numeric  as mileage_distance,
	coalesce(fem.local_amount,0)::numeric as total_amount,
	fem.currency_code::varchar as currency_code,
	coalesce(fem.curr_amount,0)::numeric as curr_amount
FROM fn_expense_mileage fem
	LEFT join db_income_expense die ON die.expense_code = fem.expense_code 
		and die.company_code = fem.company_code 
   	LEFT JOIN db_income_expense_lang diel on diel.expense_code = die.expense_code
   		and diel.company_code = die.company_code 
		and diel.expense_group_code = die.expense_group_code 
    	and diel.language_code = p_lin_id
WHERE 
	 fem.work_flow_id =  p_work_flow_id
     ORDER BY fem.expense_mileage_id;
END;
$function$
;
