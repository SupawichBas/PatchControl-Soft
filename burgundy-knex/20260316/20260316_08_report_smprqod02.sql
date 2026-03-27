DROP FUNCTION dbo.report_smprqod02;

CREATE OR REPLACE FUNCTION dbo.report_smprqod02(p_lin_id character varying, p_work_flow_id integer)
 RETURNS TABLE(address_name_1 character varying, company_name character varying, work_flow_id integer, prefix_name character varying, full_name character varying, position_name character varying, email character varying, mobile_no character varying, subject character varying, document_date character varying, document_no character varying, payment_date character varying, status character varying, prq_document_id integer, prq_document_item_id integer, vendor_code character varying, vendor_name character varying, available_document_number character varying, available_document_date character varying, description character varying, value_text character varying, bank_short_name character varying, payment_bank_account_number character varying, payment_bank_account_name character varying, currency_code character varying, prq_document_item_expense_id integer, expense_code character varying, expense_name character varying, cost_center_code character varying, cost_center_name character varying, expense_description character varying, amount numeric, amount_local numeric, total_base_amount numeric, vat_rate integer, total_vat_amount numeric, total_wht_amount numeric, total_amount numeric, total_net_amount numeric, total_base_amount_local numeric, total_vat_amount_local numeric, total_wht_amount_local numeric, total_amount_local numeric, total_net_amount_local numeric, total_prq_net_amount_local numeric, memo character varying, apex_doc_no character varying, apex_doc_date character varying, appv_doc_no character varying, appv_doc_date character varying)
 LANGUAGE plpgsql
AS $function$ 
BEGIN
    RETURN QUERY
SELECT
	dbo.get_company_address_name(p_lin_id, wf.company_code)::varchar  address_name_1,
	dbo.get_company_name(p_lin_id, wf.company_code)::varchar company_name,
    wf.work_flow_id::integer AS work_flow_id,
    dpl2.prefix_name::varchar AS prefix_name,
	concat(del.first_name ,' ',del.last_name,' (',de.emp_code,')')::varchar AS full_name,
	dpl.position_name::varchar AS position_name,
	de.email::varchar AS email,
	de.mobile_no::varchar AS mobile_no,
	wf.subject::varchar AS subject,
	to_CHAR(wf.document_date,'DD/MM/YYYY')::varchar AS document_date,
	wf.document_no::varchar AS document_no,
	to_CHAR(pd.payment_date,'DD/MM/YYYY')::varchar AS payment_date,
	dsl.status_desc::varchar AS status,
	pd.prq_document_id::integer AS prq_document_id,
	pdi.prq_document_item_id::integer AS prq_document_item_id,
	pdi.vendor_code::varchar AS vendor_code,
	pdi.vendor_name::varchar AS vendor_name,
	pdi.available_document_number::varchar AS available_document_number,
	to_CHAR(pdi.available_document_date,'DD/MM/YYYY')::varchar as available_document_date,
	pdi.description::varchar AS description,
	dlvl.value_text::varchar AS value_text,
	db.bank_short_name::varchar AS bank_short_name,
	pdi.payment_bank_account_number::varchar AS payment_bank_account_number,
	pdi.payment_bank_account_name::varchar AS payment_bank_account_name,
	pdi.currency_code::varchar AS currency_code,
	pdie.prq_document_item_expense_id::integer AS prq_document_item_expense_id,
	pdie.expense_code::varchar AS expense_code,
	diel.expense_name::varchar AS expense_name,
	pdie.cost_center_code::varchar AS cost_center_code,
	dccl.cost_center_name::varchar AS cost_center_name,
	pdie.description::varchar AS expense_description,
	pdie.amount::numeric AS amount,
	pdie.amount_local::numeric AS amount_local,
	pdi.total_base_amount::numeric AS total_base_amount,
	pdi.vat_rate::integer AS vat_rate,
	pdi.total_vat_amount::numeric AS total_vat_amount,
	pdi.total_wht_amount::numeric AS total_wht_amount,
	pdi.total_amount::numeric AS total_amount,
	pdi.total_net_amount::numeric AS total_net_amount,
	pdi.total_base_amount_local::numeric AS total_base_amount_local,
	pdi.total_vat_amount_local::numeric AS total_vat_amount_local,
	pdi.total_wht_amount_local::numeric AS total_wht_amount_local,
	pdi.total_amount_local::numeric AS total_amount_local,
	pdi.total_net_amount_local::numeric AS total_net_amount_local,
	pd.total_net_amount_local::numeric AS total_prq_net_amount_local,
	wf.memo::varchar AS memo,
	CASE 
	    WHEN wf.status IN ('WaitForMoneyTransfer', 'Complete') THEN wfi_apex.apex_doc_no 
	    ELSE NULL 
	END::varchar AS apex_doc_no,
	CASE 
	    WHEN wf.status IN ('WaitForMoneyTransfer', 'Complete') THEN to_char(wfi_apex.apex_doc_date, 'DD/MM/YYYY') 
	    ELSE NULL 
	END::varchar AS apex_doc_date,
	CASE 
	    WHEN wf.status IN ('WaitForMoneyTransfer', 'Complete') AND pdi.is_payment IS TRUE THEN wfi_appv.appv_doc_no 
	    ELSE NULL 
	END::varchar AS appv_doc_no,
	CASE 
	    WHEN wf.status IN ('WaitForMoneyTransfer', 'Complete') AND pdi.is_payment IS TRUE THEN to_char(wfi_appv.appv_doc_date, 'DD/MM/YYYY') 
	    ELSE NULL 
	END::varchar AS appv_doc_date
    FROM work_flow wf 
        LEFT JOIN prq_document pd ON pd.work_flow_id = wf.work_flow_id  
								AND pd.company_code = wf.company_code 
        LEFT JOIN prq_document_item pdi ON pdi.prq_document_id = pd.prq_document_id 
								AND pdi.company_code = wf.company_code 	
        LEFT JOIN prq_document_item_expense pdie ON pdie.prq_document_item_id = pdi.prq_document_item_id 
								AND pdie.company_code = wf.company_code 	
        LEFT JOIN db_income_expense die on die.expense_code = pdie.expense_code
    							AND die.company_code = wf.company_code
	   	LEFT JOIN db_income_expense_lang diel on diel.expense_code = die.expense_code
						   		and diel.company_code = die.company_code 
						   		and diel.expense_group_code = die.expense_group_code
						    	and diel.language_code = p_lin_id
        LEFT JOIN db_employee de ON de.emp_code = wf.requester_user_code
								AND de.company_code = wf.company_code 
    	LEFT JOIN db_employee_lang del ON del.emp_code = de.emp_code 
								AND del.company_code = de.company_code 
								AND del.language_code = p_lin_id
    	LEFT JOIN db_position_lang dpl ON dpl.position_code = de.position_code 
								AND dpl.company_code = de.company_code 
								AND dpl.language_code = p_lin_id
        LEFT JOIN db_prefix dp on dp.prefix_code = de.prefix_code 
								AND dp.company_code = wf.company_code
    	LEFT JOIN db_prefix_lang dpl2 on dpl2.prefix_code = dp.prefix_code 
		        				AND dpl2.company_code = dp.company_code 
								AND dpl2.language_code = p_lin_id
    	LEFT JOIN db_bank db ON db.bank_code = pdi.payment_bank_code
	        					AND db.company_code = wf.company_code 
		LEFT JOIN db_bank_lang dbl ON dbl.bank_code = db.bank_code
					        	AND dbl.company_code = db.company_code 
    							AND dbl.language_code = p_lin_id
        LEFT JOIN db_doc_status dds ON dds.status_value = wf.status
					        	AND dds.company_code = wf.company_code 
					        	AND dds.table_name = 'Document'
					        	AND dds.column_name = 'Status'
    	LEFT JOIN db_doc_status_lang dsl ON dsl.status_value = dds.status_value
					            AND dsl.company_code = dds.company_code 
					            AND dsl.table_name = 'Document'
					            AND dsl.column_name = 'Status'
					            AND dsl.language_code = p_lin_id
      	LEFT JOIN db_list_value dlv ON dlv.value = pdi.payment_method_code
					        	AND dlv.company_code = wf.company_code 
					        	AND dlv.group_code = 'PRQPaymentMethod'
		LEFT JOIN db_list_value_lang dlvl ON dlvl.group_code = dlv.group_code 
		        				AND dlvl.company_code = dlv.company_code 
								AND dlvl.value = dlv.value
								AND dlvl.language_code = p_lin_id
		LEFT JOIN db_cost_center dcc ON dcc.cost_center_code = pdie.cost_center_code 
				        		AND dcc.company_code = wf.company_code
		LEFT JOIN db_cost_center_lang dccl ON dccl.cost_center_code = dcc.cost_center_code
								AND dccl.company_code = dcc.company_code 
								AND dccl.language_code = p_lin_id
		LEFT JOIN (
					    SELECT 
					        trn.ap_transaction_id,
					        wfi.doc_no AS apex_doc_no,
					        wfi.doc_date AS apex_doc_date,
					        trn.burg_workflow_id AS workflow_id
					    FROM work_flow_interface wfi
					    LEFT JOIN itf_ap_transaction trn 
					        ON trn.burg_workflow_id = wfi.work_flow_id 
					        AND trn.process_id = wfi.process_id  
					    WHERE wfi.sub_type = 'APEX01'
						AND wfi.work_flow_id = p_work_flow_id 
					) wfi_apex 
					    ON wfi_apex.ap_transaction_id = pdi.ref_ap_transaction_id 
	    LEFT JOIN (
					    SELECT 
					        trn.ap_transaction_id,
					        wfi.doc_no AS appv_doc_no,
					        wfi.doc_date AS appv_doc_date,
					        trn.burg_workflow_id AS workflow_id
					    FROM work_flow_interface wfi
					    LEFT JOIN itf_ap_transaction trn 
					        ON trn.burg_workflow_id = wfi.work_flow_id 
					        AND trn.process_id = wfi.process_id  
					    WHERE wfi.sub_type = 'APPV01'
						AND wfi.work_flow_id = p_work_flow_id 
					) wfi_appv 
					    ON wfi_appv.ap_transaction_id = pdi.ref_ap_transaction_id
    WHERE wf.work_flow_id = p_work_flow_id
	ORDER BY pdi.prq_document_item_id ;
END;
$function$
;
