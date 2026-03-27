drop function report_smpcod02;

CREATE OR REPLACE FUNCTION dbo.report_smpcod02(p_lin_id character varying, p_work_flow_id integer)
 RETURNS TABLE(address_name_1 character varying, company_name character varying, work_flow_id integer, full_name character varying, position_name character varying, email character varying, mobile_no character varying, subject character varying, pcc_payment_cash_name character varying, effective_date character varying, document_date character varying, document_no character varying, bank_name character varying, bank_account_no character varying, status character varying, pc_document_id integer, rate numeric, currency_code character varying, pcc_current_total_amount numeric, pcc_limit_amount_per_transaction numeric, full_name_approver character varying, full_name_approver_payment character varying, memo character varying, work_flow_sub_type_code character varying)
 LANGUAGE plpgsql
AS $function$ 
BEGIN
    RETURN QUERY
SELECT 
    	dbo.get_company_address_name(p_lin_id, wf.company_code)::varchar  address_name_1,
    	dbo.get_company_name(p_lin_id, wf.company_code)::varchar company_name,
        wf.work_flow_id::integer as work_flow_id,
        concat(del.first_name, ' ', del.last_name,' (',de.emp_code,')')::varchar as full_name,
        dpl.position_name::varchar as position_name,
        de.email::varchar as email,
        coalesce('***-***' || substring(de.mobile_no::varchar, 8),'-')::varchar as mobile_no,
        wf.subject::varchar as subject,
        pd.pcc_payment_cash_name::varchar as pcc_payment_cash_name,
        to_CHAR(pd.effective_date_custodian,'DD/MM/YYYY')::varchar as effective_date,
        to_CHAR(wf.document_date,'DD/MM/YYYY')::varchar as document_date,
        wf.document_no::varchar as document_no,
        dbl.bank_name::varchar as bank_name,
        pd.additional_bank_account_no ::varchar as bank_account_no,
        dsl.status_desc::varchar as status,
        pd.pc_document_id  ::integer as pc_document_id,
        coalesce(null,1)::numeric as rate,
        coalesce(null,'THB')::varchar as currency_code,
        coalesce(pd.pcc_current_total_amount ,0)::numeric as pcc_current_total_amount,
        coalesce(pd.pcc_current_limit_amount_per_transaction ,0)::numeric as pcc_limit_amount_per_transaction,
        concat(delwfa.first_name, ' ', delwfa.last_name)::varchar as full_name_approver,
        concat(poal.first_name, ' ', poal.last_name)::varchar as full_name_approver_payment,
        wf.memo::varchar as memo,
        wf.work_flow_sub_type_code::varchar as work_flow_sub_type_code
    FROM 
        work_flow wf 
        LEFT JOIN pc_document pd on pd.work_flow_id = wf.work_flow_id 
        LEFT JOIN db_employee de ON de.emp_code = wf.requester_user_code
            LEFT JOIN db_employee_lang del ON de.emp_code = del.emp_code AND del.language_code = p_lin_id
        LEFT JOIN db_position_lang dpl ON dpl.position_code = de.position_code AND dpl.language_code = p_lin_id
        	and dpl.company_code = de.company_code
        LEFT JOIN db_bank_lang dbl ON dbl.bank_code = pd.additional_bank_code
        	and dbl.company_code = pd.company_code 
            AND dbl.language_code = p_lin_id
        LEFT JOIN db_doc_status dds ON dds.status_value = wf.status
            AND dds.company_code = wf.company_code 
            AND dds.table_name = 'PccDocument'
            AND dds.column_name = 'Status'
        LEFT JOIN db_doc_status_lang dsl ON dsl.status_value = dds.status_value
            AND dsl.company_code = wf.company_code 
            AND dsl.table_name = 'PccDocument'
            AND dsl.column_name = 'Status'
            AND dsl.language_code = p_lin_id
        --approver_user_code
        LEFT JOIN db_employee_lang delwfa ON wf.approver_user_code = delwfa.emp_code AND delwfa.language_code = p_lin_id
        -- 
	    --full_name_approver_payment
	    LEFT JOIN db_employee_lang poal ON coalesce(pd.pcc_payment_current_approve,pd.pcc_payment_approve) = poal.emp_code 
	    		AND poal.language_code = p_lin_id
    WHERE 
        wf.work_flow_id = p_work_flow_id
    ORDER BY pd.pc_document_id ;
    
END;
$function$
;
