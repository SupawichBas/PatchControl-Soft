-- DROP FUNCTION dbo.report_smexod02_sub(varchar, int4);

CREATE OR REPLACE FUNCTION dbo.report_smexod02_sub(p_lin_id character varying, p_work_flow_id integer)
 RETURNS TABLE(expense_document_id integer, expense_invoice_id integer, invoice_no character varying, vendor_name character varying, invoice_date character varying, invoice_description character varying, expense_invoice_item_id integer, expense_code character varying, expense_name character varying, expense_description character varying, curr_amount numeric, base_amount numeric, vat_rate numeric, vat_amount numeric, wht_amount numeric, total_amount numeric, total_expense_amount numeric, memo character varying, currency_code character varying, local_amount numeric, base_amount_local numeric, vat_amount_local numeric, wht_amount_local numeric, total_amount_local numeric, base_amount_local_item numeric)
 LANGUAGE plpgsql
AS $function$ 
BEGIN
    RETURN QUERY
    select
	fed.expense_document_id::integer as expense_document_id,
	fei.expense_invoice_id ::integer as expense_invoice_id,
	fei.invoice_no::varchar as invoice_no,
	fei.vendor_name::varchar as vendor_name,
	to_CHAR(fei.invoice_date,'DD/MM/YYYY')::varchar as invoice_date,
	fei.invoice_description::varchar as invoice_description,
	feii.expense_invoice_item_id::integer as expense_invoice_item_id,
	feii.expense_code::varchar expense_code,
	diel.expense_name::varchar as expense_name,
	feii.expense_description::varchar as expense_description,
	coalesce(feii.curr_amount,0)::numeric as curr_amount,
	coalesce(fei.base_amount,0)::numeric as base_amount,
	coalesce(fei.vat_rate,0)::numeric as vat_rate,
	coalesce(fei.vat_amount,0)::numeric as vat_amount,
	coalesce(fei.wht_amount,0)::numeric as wht_amount,
	coalesce(fei.total_amount,0)::numeric as total_amount,
	coalesce(fed.total_expense_amount,0)::numeric as total_expense_amount,
	wf.memo::varchar as memo,
	feii.currency_code::varchar as currency_code,
	coalesce(feii.local_amount,0)::numeric as local_amount,
	coalesce(fei.base_amount_local,0)::numeric as base_amount_local,
	coalesce(fei.vat_amount_local,0)::numeric as vat_amount_local,
	coalesce(fei.wht_amount_local,0)::numeric as wht_amount_local,
	coalesce(fei.total_amount_local,0)::numeric as total_amount_local,
	coalesce(feii.base_amount_local ,0)::numeric as base_amount_local_item
    FROM 
        work_flow wf 
        LEFT JOIN fn_expense_document fed on fed.work_flow_id = wf.work_flow_id  
        LEFT join fn_expense_invoice fei on fei.expense_document_id = fed.expense_document_id 
        LEFT join fn_expense_invoice_item feii on feii.expense_invoice_id = fei.expense_invoice_id 
        LEFT join db_income_expense die on die.expense_code = feii.expense_code
        		and die.company_code = feii.company_code
       	LEFT JOIN db_income_expense_lang diel on diel.expense_code = die.expense_code
       		and diel.company_code = die.company_code 
       		and diel.expense_group_code = die.expense_group_code
        	and diel.language_code = p_lin_id
    WHERE 
        wf.work_flow_id = p_work_flow_id
       and fei.is_replacement_for_receipt = true
      ORDER BY fei.expense_invoice_id;
END;
$function$
;
