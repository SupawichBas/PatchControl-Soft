DROP FUNCTION dbo.report_smpcod04_sub1;

CREATE OR REPLACE FUNCTION dbo.report_smpcod04_sub1(p_lin_id character varying, p_work_flow_id integer)
 RETURNS TABLE(pc_document_id integer, pc_document_invoice_id integer, invoice_no character varying, vendor_name character varying, invoice_date character varying, invoice_description character varying, pc_document_invoice_item_id integer, expense_code character varying, expense_name character varying, expense_description character varying, curr_amount numeric, base_amount numeric, vat_rate numeric, vat_amount numeric, wht_amount numeric, total_amount numeric, pcq_total_amount numeric, memo character varying, currency_code character varying, local_amount numeric, base_amount_local numeric, vat_amount_local numeric, wht_amount_local numeric, total_amount_local numeric, base_amount_local_item numeric, net_amount numeric, net_amount_local numeric, base_amount_item numeric)
 LANGUAGE plpgsql
AS $function$ 
BEGIN
    RETURN QUERY
    select
    pd.pc_document_id ::integer as pc_document_id,
	pdi.pc_document_invoice_id  ::integer as pc_document_invoice_id,
	pdi.invoice_no ::varchar as invoice_no,
	pdi.vendor_name ::varchar as vendor_name,
	to_CHAR(pdi.invoice_date,'DD/MM/YYYY')::varchar as invoice_date,
	pdi.invoice_description::varchar as invoice_description,
	pdii.pc_document_invoice_item_id ::integer as pc_document_invoice_item_id,
	pdii.expense_code::varchar expense_code,
	diel.expense_name::varchar as expense_name,
	pdii.expense_description::varchar as expense_description,
	coalesce(pdii.curr_amount,0)::numeric as curr_amount,
	coalesce(pdi.base_amount,0)::numeric as base_amount,
	coalesce(pdi.vat_rate,0)::numeric as vat_rate,
	coalesce(pdi.vat_amount,0)::numeric as vat_amount,
	coalesce(pdi.wht_amount,0)::numeric as wht_amount,
	coalesce(pdi.total_amount,0)::numeric as total_amount,
	coalesce(pd.pcq_total_amount,0)::numeric as pcq_total_amount,
	wf.memo::varchar as memo,
	pdii.currency_code::varchar as currency_code,
	coalesce(pdii.local_amount,0)::numeric as local_amount,
	coalesce(pdi.base_amount_local,0)::numeric as base_amount_local,
	coalesce(pdi.vat_amount_local,0)::numeric as vat_amount_local,
	coalesce(pdi.wht_amount_local,0)::numeric as wht_amount_local,
	coalesce(pdi.total_amount_local,0)::numeric as total_amount_local,
	coalesce(pdii.base_amount_local ,0)::numeric as base_amount_local_item,
	coalesce(pdi.net_amount,0)::numeric as net_amount,
	coalesce(pdi.net_amount_local,0)::numeric as net_amount_local,
	coalesce(pdii.base_amount,0)::numeric as base_amount_item
    FROM 
        work_flow wf 
        LEFT JOIN pc_document pd on pd.work_flow_id = wf.work_flow_id 
        LEFT join pc_document_invoice pdi on pd.pc_document_id = pdi.pc_document_id 
        LEFT join pc_document_invoice_item pdii on pdi.pc_document_invoice_id = pdii.pc_document_invoice_id 
        LEFT join db_income_expense die on die.expense_code = pdii.expense_code 
        	and die.company_code = pdii.company_code 
	   	LEFT JOIN db_income_expense_lang diel on diel.expense_code = die.expense_code
	   		and diel.company_code = die.company_code 
       		and diel.expense_group_code = die.expense_group_code 
	    	and diel.language_code = p_lin_id
    WHERE 
        wf.work_flow_id = p_work_flow_id
      ORDER BY pdi.pc_document_invoice_id,pdii.pc_document_invoice_item_id ;
END;
$function$
;
