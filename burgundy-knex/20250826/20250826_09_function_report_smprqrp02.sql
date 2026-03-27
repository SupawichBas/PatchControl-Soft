drop function report_smprqrp02;

CREATE OR REPLACE FUNCTION dbo.report_smprqrp02(p_lin_id character varying, p_company_code character varying, p_branch_code character varying, p_division_code character varying, p_requester_user_code character varying, p_vendor_code character varying, p_payment_start_date character varying, p_payment_end_date character varying, p_availabel_start_date character varying, p_availabel_end_date character varying, p_document_start_date character varying, p_document_end_date character varying, user_login integer)
 RETURNS TABLE(h_company character varying, p_vendor_name character varying, p_requester_name character varying, vendor_code character varying, vendor_name character varying, vendor_branch_code character varying, vendor_branch_name character varying, vendor_tax_id character varying, available_document character varying, available_document_number character varying, available_document_date character varying, description character varying, document_no character varying, status_desc character varying, payment_date character varying, over_due_date character varying, payment_method character varying, bank_short_name character varying, bank_name character varying, payment_bank_account_name character varying, payment_bank_account_number character varying, requester_user_code character varying, requester_user_name character varying, total_base_amount_local numeric, total_vat_amount_local numeric, total_amount_local numeric, total_wht_amount_local numeric, total_net_amount_local numeric, work_flow_id integer, work_flow_type_code character varying, navigatereport character varying)
 LANGUAGE plpgsql
AS $function$
declare UserCompany varchar(20);
declare UserCode varchar(20);
declare CheckPrivilege varchar(1);
BEGIN
	UserCompany = get_user_company_code(user_login);
	UserCode = get_user_code(user_login);
	CheckPrivilege = dbo.get_user_privilege(UserCompany, user_login);
    RETURN QUERY
    SELECT 
        		(concat(get_company_code_name(p_lin_id, p_company_code), ' / ', get_branch_code_name(p_lin_id, p_branch_code)))::varchar AS h_company, 
		        coalesce(dbo.get_vendor_name(p_lin_id, p_vendor_code), dbo.get_report_label_name('SMEXRP01', 'ALL', p_lin_id))::varchar AS p_vendor_name, 
		        coalesce(dbo.get_employee_name(p_lin_id, p_company_code, p_branch_code, p_requester_user_code), dbo.get_report_label_name('SMEXRP01', 'ALL', p_lin_id))::varchar AS p_requester_name, 
		        pdi.vendor_code::varchar AS vendor_code, 
		        CASE 
		            WHEN dv.is_onetime THEN pdi.vendor_name
		            ELSE dvl.vendor_name 
		        END::varchar AS vendor_name, 
		        pdi.vendor_branch_code::varchar AS vendor_branch_code, 
		        pdi.vendor_branch_name::varchar AS vendor_branch_name, 
		        pdi.vendor_tax_id::varchar AS vendor_tax_id, 
		        dbo.get_list_value(p_lin_id, p_company_code, 'AvailableDocument', pdi.available_document_code)::varchar AS available_document, 
		        pdi.available_document_number::varchar AS available_document_number, 
		        to_char(pdi.available_document_date ,'dd/MM/yyyy')::varchar AS available_document_date, 
		        pdi.description::varchar AS description, 
		        wf.document_no::varchar AS document_no, 
		        ddsl.status_desc::varchar AS status_desc, 
		        to_char(pd.payment_date ,'dd/MM/yyyy') ::varchar AS payment_date, 
		        CASE 
		            WHEN CURRENT_TIMESTAMP > pd.payment_date THEN EXTRACT(DAY FROM (CURRENT_TIMESTAMP - pd.payment_date))::varchar 
		            ELSE '0' 
		        END AS over_due_date, 
		        dbo.get_list_value(p_lin_id, p_company_code, 'PRQPaymentMethod', pdi.payment_method_code)::varchar AS payment_method, 
		        db.bank_short_name::varchar AS bank_short_name, 
		        dbl.bank_name::varchar AS bank_name, 
		        pdi.payment_bank_account_name::varchar AS payment_bank_account_name, 
		        pdi.payment_bank_account_number::varchar AS payment_bank_account_number, 
		        wf.requester_user_code::varchar AS requester_user_code, 
		        dbo.get_employee_name(p_lin_id, p_company_code, p_branch_code, wf.requester_user_code)::varchar AS requester_user_name, 
		        pdi.total_base_amount_local::numeric AS total_base_amount_local, 
		        pdi.total_vat_amount_local::numeric AS total_vat_amount_local, 
		        pdi.total_amount_local::numeric AS total_amount_local, 
		        pdi.total_wht_amount_local::numeric AS total_wht_amount_local, 
		        pdi.total_net_amount_local::numeric AS total_net_amount_local,
		        wf.work_flow_id ::integer work_flow_id,
				wf.work_flow_type_code ::varchar as work_flow_type_code,
				dbo.get_su_system_configuration('NavigateReport', 'NavigateReport')::varchar as NavigateReport
    FROM 		prq_document_item pdi
    LEFT JOIN 	prq_document pd ON pd.prq_document_id = pdi.prq_document_id 
    LEFT JOIN 	work_flow wf ON wf.work_flow_id = pd.work_flow_id 
    LEFT JOIN 	db_vendor dv ON dv.vendor_code = pdi.vendor_code AND dv.company_code = wf.company_code
    LEFT JOIN 	db_vendor_lang dvl ON dvl.vendor_code = pdi.vendor_code AND dvl.company_code = wf.company_code AND dvl.language_code = p_lin_id
    LEFT JOIN 	db_doc_status_lang ddsl ON ddsl.status_value = wf.status AND ddsl.company_code = wf.company_code AND ddsl.table_name = 'PRQDocument' AND ddsl.column_name = 'Status' AND ddsl.language_code = p_lin_id
    LEFT JOIN 	db_bank db ON db.bank_code = pdi.payment_bank_code AND db.company_code = wf.company_code
    LEFT JOIN 	db_bank_lang dbl ON dbl.bank_code = pdi.payment_bank_code AND dbl.company_code = wf.company_code AND dbl.language_code = p_lin_id
    LEFT JOIN 	db_employee_lang req ON req.emp_code = wf.requester_user_code AND req.language_code = p_lin_id 
    WHERE 		wf.company_code = p_company_code 
		        AND wf.branch_code = p_branch_code 
		        AND wf.division_code = coalesce(p_division_code, wf.division_code) 
		        AND wf.requester_user_code = coalesce(p_requester_user_code, wf.requester_user_code) 
		        AND pdi.vendor_code = coalesce(p_vendor_code, pdi.vendor_code)
		        AND COALESCE(CAST(pd.payment_date AS DATE),to_date('01/01/0001','dd/mm/yyyy')) BETWEEN coalesce(to_date(p_payment_start_date, 'DD/MM/YYYY'), to_date('01/01/0001', 'dd/mm/yyyy'))
		            AND coalesce(to_date(p_payment_end_date, 'DD/MM/YYYY'), to_date('31/12/9999', 'dd/mm/yyyy'))
		        AND COALESCE(CAST(pdi.available_document_date AS DATE),to_date('01/01/0001','dd/mm/yyyy')) BETWEEN coalesce(to_date(p_availabel_start_date, 'DD/MM/YYYY'), to_date('01/01/0001', 'dd/mm/yyyy'))
		            AND coalesce(to_date(p_availabel_end_date, 'DD/MM/YYYY'), to_date('31/12/9999', 'dd/mm/yyyy'))
		        AND COALESCE(CAST(wf.document_date AS DATE),to_date('01/01/0001','dd/mm/yyyy')) BETWEEN coalesce(to_date(p_document_start_date, 'DD/MM/YYYY'), to_date('01/01/0001', 'dd/mm/yyyy'))
		            AND coalesce(to_date(p_document_end_date, 'DD/MM/YYYY'), to_date('31/12/9999', 'dd/mm/yyyy'))
		        AND wf.status NOT IN ('New', 'Draft', 'Cancel', 'Complete')
		        AND pdi.is_payment = FALSE 
				and EXISTS (select get_exists_on_report(wf.work_flow_id, UserCode))
		        -- AND (
				--     (
				--     CheckPrivilege = '1'
				--     and
				--     EXISTS (
			    --         SELECT 'x' FROM su_user_organization suo
			    --         WHERE suo.user_id = user_login --'63025'--ALL Doc'62020'
			    --         AND suo.company_code = wf.company_code
			    --         and suo.profile_type = 'Document'
			    --     		))
				--     OR EXISTS (
				--         SELECT 'x' FROM su_user_authorized sua 
				--         WHERE sua.authorized_emp_code = wf.requester_user_code
				--         AND sua.emp_code = UserCode
				--     		) 
				--     OR (wf.requester_user_code = UserCode 
				--     OR wf.creator_user_code = UserCode )
				-- 	)
	ORDER BY 	pd.payment_date ,pdi.vendor_code ,pdi.branch_code;
END;
$function$
;
