-- DROP FUNCTION dbo.report_smpcod04_sub2(varchar, int4);

CREATE OR REPLACE FUNCTION dbo.report_smpcod04_sub2(p_lin_id character varying, p_work_flow_id integer)
 RETURNS TABLE(pc_document_mileage_id integer, expense_code character varying, expense_name character varying, description character varying, mileage_rate numeric, mileage_from character varying, mileage_to character varying, mileage_distance numeric, total_amount numeric, currency_code character varying, curr_amount numeric)
 LANGUAGE plpgsql
AS $function$ 
BEGIN
    RETURN QUERY
SELECT pdm.pc_document_mileage_id ::integer as pc_document_mileage_id,
	diel.expense_code::varchar as expense_code,
	diel.expense_name::varchar as expense_name,
	pdm.description::varchar as description,
	coalesce(pdm.mileage_rate,0)::numeric  as mileage_rate,
	pdm.mileage_from::varchar as mileage_from,
	pdm.mileage_to::varchar as mileage_to,
	coalesce(pdm.mileage_distance,0)::numeric  as mileage_distance,
	coalesce(pdm.local_amount,0)::numeric as total_amount,
	pdm.currency_code::varchar as currency_code,
	coalesce(pdm.curr_amount,0)::numeric as curr_amount
FROM pc_document_mileage pdm 
	LEFT join db_income_expense die ON die.expense_code = pdm.expense_code 
		and die.company_code = pdm.company_code 
   	LEFT JOIN db_income_expense_lang diel on diel.expense_code = die.expense_code
   		and diel.company_code = die.company_code 
		and diel.expense_group_code = die.expense_group_code 
    	and diel.language_code = p_lin_id
WHERE 
	 pdm.work_flow_id =  p_work_flow_id
     ORDER BY pdm.pc_document_mileage_id;
END;
$function$
;
