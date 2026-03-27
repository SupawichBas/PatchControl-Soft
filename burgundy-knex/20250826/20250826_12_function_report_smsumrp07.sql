drop function report_smsumrp07;

CREATE OR REPLACE FUNCTION dbo.report_smsumrp07(p_lin_id character varying, p_company_code character varying, p_branch_code character varying, p_division_code character varying, p_vendor_code character varying, p_vendor_branch_code character varying, p_invoice_date_from character varying, p_invoice_date_to character varying, p_document_date_from character varying, p_document_date_to character varying, p_doc_no character varying, p_requester_code character varying, user_login integer)
 RETURNS TABLE(h_company_name character varying, h_branch_name character varying, h_vendor_tax_id character varying, h_vendor_name character varying, h_vendor_branch_name character varying, h_current_time timestamp without time zone, f_invoice_no character varying, f_invoice_date character varying, f_vendor_code character varying, f_vendor_name character varying, f_vendor_tax_id character varying, f_vendor_branch_code character varying, f_vendor_branch_name character varying, f_vat_rate numeric, f_total_base_amount_local numeric, f_total_vat_amount_local numeric, f_total_amount_local numeric)
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
        get_company_code_name(p_lin_id, prq_item.company_code)::varchar AS h_company_name,
        get_branch_code_name(p_lin_id, prq_item.branch_code)::varchar AS h_branch_name,
        CASE 
            WHEN p_vendor_code IS NOT NULL AND dv.tax_no != '' THEN dv.tax_no
            ELSE dbo.get_report_label_name('SMSUMRP07', 'ALL', p_lin_id)
        END ::varchar AS h_vendor_tax_id,
        COALESCE(dbo.get_vendor_name(p_lin_id, p_vendor_code), dbo.get_report_label_name('SMSUMRP07', 'ALL', p_lin_id)) ::varchar AS h_vendor_name,
        COALESCE(dbo.get_vendor_branch_name(p_lin_id, p_vendor_code, p_vendor_branch_code), dbo.get_report_label_name('SMSUMRP07', 'ALL', p_lin_id)) ::varchar AS h_vendor_branch_name,
        current_timestamp ::timestamp AS h_current_time,
        prq_item.available_document_number ::varchar AS f_invoice_no,
        to_char(prq_item.available_document_date, 'dd/MM/yyyy')::varchar AS f_invoice_date,
        prq_item.vendor_code ::varchar AS f_vendor_code,
        CASE 
            WHEN dv.is_onetime THEN prq_item.vendor_name
            ELSE dvl.vendor_name
        END ::varchar AS f_vendor_name,
        prq_item.vendor_tax_id ::varchar AS f_vendor_tax_id,
        prq_item.vendor_branch_code ::varchar AS f_vendor_branch_code,
        CASE 
            WHEN dv.is_onetime THEN prq_item.vendor_branch_name
            ELSE dvbl.vendor_branch_name
        END ::varchar AS f_vendor_branch_name,
        prq_item.vat_rate ::numeric AS f_vat_rate,
        prq_item.total_base_amount_local ::numeric AS f_total_base_amount_local,
        prq_item.total_vat_amount_local ::numeric AS f_total_vat_amount_local,
        prq_item.total_amount_local ::numeric AS f_total_amount_local
    FROM 
        prq_document_item prq_item
    LEFT JOIN 
        prq_document prq ON prq.prq_document_id = prq_item.prq_document_id
    LEFT JOIN 
        work_flow wf ON wf.work_flow_id = prq.work_flow_id
    LEFT JOIN 
        db_vendor dv ON dv.company_code = prq_item.company_code 
                      AND dv.vendor_code = prq_item.vendor_code 
    LEFT JOIN 
        db_vendor_lang dvl ON dvl.company_code = prq_item.company_code 
                           AND dvl.vendor_code = prq_item.vendor_code 
                           AND dvl.language_code = p_lin_id
    LEFT JOIN 
        db_vendor_branch_lang dvbl ON dvbl.company_code = prq_item.company_code 
                                   AND dvbl.vendor_code = prq_item.vendor_code 
                                   AND dvbl.vendor_branch_code = prq_item.vendor_branch_code 
                                   AND dvbl.language_code = p_lin_id
    WHERE 
        prq_item.company_code = p_company_code
        AND prq_item.branch_code = p_branch_code
        AND prq_item.division_code = COALESCE(p_division_code, prq_item.division_code)
        AND COALESCE(prq_item.vendor_code, '') = COALESCE(p_vendor_code, prq_item.vendor_code, '')
        AND COALESCE(prq_item.vendor_branch_code, '') = COALESCE(p_vendor_branch_code, prq_item.vendor_branch_code, '')
        AND	COALESCE(wf.document_no, '') = COALESCE(p_doc_no, wf.document_no, '')
		AND	COALESCE(wf.requester_user_code, '') = COALESCE(p_requester_code, wf.requester_user_code, '')
        AND COALESCE(prq_item.available_document_date::DATE, '1970-01-01'::DATE) BETWEEN
            COALESCE(p_invoice_date_from::DATE, prq_item.available_document_date::DATE, '1970-01-01'::DATE)
            AND COALESCE(p_invoice_date_to::DATE, prq_item.available_document_date::DATE, '1970-01-01'::DATE)
        AND COALESCE(wf.document_date::DATE, '1970-01-01'::DATE) BETWEEN
            COALESCE(p_document_date_from::DATE, wf.document_date::DATE, '1970-01-01'::DATE)
            AND COALESCE(p_document_date_to::DATE, wf.document_date::DATE, '1970-01-01'::DATE)
		and EXISTS (select get_exists_on_report(wf.work_flow_id, UserCode))
		-- AND (
		--     (
		--     CheckPrivilege = '1'
		--     and
		--     EXISTS (
	    --         SELECT 'x' FROM su_user_organization suo
	    --         WHERE suo.user_id = user_login --'214'
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
        ;
END;
$function$
;
