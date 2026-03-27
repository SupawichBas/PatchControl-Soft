-- DROP FUNCTION dbo.report_smprqrp01(varchar, varchar, varchar, varchar, varchar, varchar, varchar, varchar, varchar, varchar, varchar, int4);

CREATE OR REPLACE FUNCTION dbo.report_smprqrp01(p_lin_id character varying, p_company_code character varying, p_branch_code character varying, p_division_code character varying, p_requester_user_code character varying, p_available_document_code character varying, p_vendor_code character varying, p_availabel_start_date character varying, p_availabel_end_date character varying, p_document_start_date character varying, p_document_end_date character varying, user_login integer)
 RETURNS TABLE(h_company character varying, p_vendor_name character varying, p_requester_name character varying, p_available_document_name character varying, vendor_code character varying, vendor_name character varying, vendor_branch_code character varying, vendor_branch_name character varying, vendor_tax_id character varying, available_document character varying, available_document_number character varying, available_document_date character varying, description character varying, document_no character varying, requester_user_code character varying, requester_user_name character varying, total_base_amount_local numeric, total_vat_amount_local numeric, total_amount_local numeric, total_wht_amount_local numeric, total_net_amount_local numeric, work_flow_id integer, work_flow_type_code character varying, navigatereport character varying)
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
					(concat(get_company_code_name(p_lin_id, p_company_code),' / ',get_branch_code_name(p_lin_id, p_branch_code)))::varchar  as h_company	
					,coalesce (dbo.get_vendor_name(p_lin_id, p_vendor_code), dbo.get_report_label_name('SMEXRP01', 'ALL', p_lin_id))::varchar  as p_vendor_name
					,coalesce (dbo.get_employee_name(p_lin_id, p_company_code, p_branch_code, p_requester_user_code), dbo.get_report_label_name('SMEXRP01', 'ALL', p_lin_id))::varchar  as p_requester_name
					,coalesce (dbo.get_list_value(p_lin_id ,p_company_code,'AvailableDocument',p_available_document_code), dbo.get_report_label_name('SMEXRP01', 'ALL', p_lin_id))::varchar  as p_available_document_name
					,pdi.vendor_code ::varchar AS vendor_code 
					,CASE 
						WHEN dv.is_onetime THEN 
							pdi.vendor_name
						ELSE dvl.vendor_name
					END ::varchar AS vendor_name
					,CASE 
				        WHEN pdi.vendor_branch_code IS NULL OR pdi.vendor_branch_code = '' THEN '00000'
				        WHEN LENGTH(pdi.vendor_branch_code) < 5 THEN LPAD(pdi.vendor_branch_code, 5, '0')
				        ELSE pdi.vendor_branch_code
				    END ::varchar AS vendor_branch_code
					,pdi.vendor_branch_name ::varchar AS vendor_branch_name 
					,pdi.vendor_tax_id ::varchar AS vendor_tax_id 
					,dbo.get_list_value(p_lin_id ,p_company_code,'AvailableDocument',pdi.available_document_code) ::varchar AS available_document
					,pdi.available_document_number ::varchar AS available_document_number
					,to_char(pdi.available_document_date ,'dd/MM/yyyy') ::varchar AS available_document_date 
					,pdi.description ::varchar AS description
					,wf.document_no ::varchar AS document_no
					,wf.requester_user_code ::varchar AS requester_user_code
					,dbo.get_employee_name(p_lin_id, p_company_code, p_branch_code, wf.requester_user_code) ::varchar AS requester_user_name
					,pdi.total_base_amount_local  ::NUMERIC AS total_base_amount_local
					,pdi.total_vat_amount_local ::NUMERIC AS total_vat_amount_local
					,pdi.total_amount_local ::NUMERIC AS total_amount_local
					,pdi.total_wht_amount_local ::NUMERIC AS total_wht_amount_local
					,pdi.total_net_amount_local ::NUMERIC AS total_net_amount_local
					,wf.work_flow_id ::integer work_flow_id
					,wf.work_flow_type_code ::varchar as work_flow_type_code
					,concat(dbo.get_su_system_configuration('NavigateReport', 'NavigateReport'),wf.work_flow_id,'/',wf.work_flow_type_code)::varchar as NavigateReport
		FROM 		prq_document_item pdi
		LEFT JOIN 	prq_document pd ON pd.prq_document_id = pdi.prq_document_id 
		LEFT JOIN 	work_flow wf ON wf.work_flow_id = pd.work_flow_id 
		LEFT JOIN 	db_vendor dv ON dv.vendor_code = pdi.vendor_code
						AND dv.company_code = wf.company_code
		LEFT JOIN 	db_vendor_lang dvl ON dvl.vendor_code = pdi.vendor_code
						AND dvl.company_code = wf.company_code
						AND dvl.language_code = p_lin_id 
		LEFT JOIN 	db_employee_lang req ON req.emp_code = wf.requester_user_code 
						AND req.language_code = p_lin_id 
		WHERE 		wf.company_code = p_company_code --SS
					AND wf.branch_code = p_branch_code
					AND wf.division_code = coalesce(p_division_code, wf.division_code)
					AND wf.requester_user_code = coalesce(p_requester_user_code, wf.requester_user_code)
					AND pdi.available_document_code = coalesce(p_available_document_code, pdi.available_document_code)
					AND pdi.vendor_code = coalesce(p_vendor_code, pdi.vendor_code)				
					AND COALESCE(CAST(pdi.available_document_date AS DATE),to_date('01/01/0001','dd/mm/yyyy')) BETWEEN coalesce(to_date(p_availabel_start_date,'DD/MM/YYYY') , to_date('01/01/0001','dd/mm/yyyy'))
						AND coalesce(to_date(p_availabel_end_date,'DD/MM/YYYY') , to_date('31/12/9999','dd/mm/yyyy'))
					AND COALESCE(CAST(wf.document_date AS DATE) ,to_date('01/01/0001','dd/mm/yyyy')) BETWEEN coalesce(to_date(p_document_start_date,'DD/MM/YYYY') , to_date('01/01/0001','dd/mm/yyyy'))
						AND coalesce(to_date(p_document_end_date,'DD/MM/YYYY') , to_date('31/12/9999','dd/mm/yyyy'))
					AND wf.status NOT IN ('Draft', 'Cancel')
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
		ORDER BY 	pdi.vendor_code ASC,pdi.available_document_date ASC,wf.document_no ASC;
	END;
$function$
;
