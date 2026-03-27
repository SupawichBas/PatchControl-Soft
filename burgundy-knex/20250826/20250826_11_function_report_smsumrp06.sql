drop function report_smsumrp06;

CREATE OR REPLACE FUNCTION dbo.report_smsumrp06(p_lin_id character varying, p_ou_code character varying, p_branch_code character varying, p_cost_center_code character varying, p_expense_code character varying, p_document_date_from character varying, p_document_date_to character varying, p_document_no character varying, user_login integer)
 RETURNS TABLE(gl_posting_master_id numeric, company_code character varying, branch_code character varying, company_name_header character varying, branch_name_header character varying, print_date timestamp with time zone, document_no character varying, document_date character varying, account_code character varying, account_name character varying, cost_center_code character varying, cost_center_name character varying, branch_name character varying, dr_amt numeric, cr_amt numeric, remark character varying)
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
	-- Start query
	
		SELECT 
			glm.gl_posting_master_id:: NUMERIC gl_posting_master_id,
			gld.company_code:: CHARACTER VARYING AS company_code, 
			gld.branch_code:: CHARACTER VARYING AS branch_code,
			NULLIF(get_company_code_name(
				p_lin_id,
				NULLIF(wf.company_code, '')
			), ''):: CHARACTER VARYING AS company_name_header,
			NULLIF(get_branch_code_name(
				p_lin_id,
				NULLIF(wf.branch_code, '')
			), ''):: CHARACTER VARYING AS branch_name_header,
			current_timestamp AS print_date,
			NULLIF(glm.document_no, ''):: CHARACTER VARYING AS document_no,
			NULLIF(to_char(glm.document_date, 'dd/MM/yyyy'), ''):: CHARACTER VARYING AS document_date,
			NULLIF(gld.account_code, ''):: CHARACTER VARYING AS account_code,
			NULLIF(acl.account_name, ''):: CHARACTER VARYING AS account_name,
			NULLIF(gld.division_code, ''):: CHARACTER VARYING AS cost_center_code,
			NULLIF(ccl.cost_center_name, ''):: CHARACTER VARYING AS cost_center_name,
			NULLIF(get_branch_code_name(
				p_lin_id,
				NULLIF(gld.branch_code, '')
			), ''):: CHARACTER VARYING AS branch_name,
			gld.dr_amt:: NUMERIC AS dr_amt,
			gld.cr_amt:: NUMERIC AS cr_amt,
			NULLIF(gld.remark, ''):: CHARACTER VARYING AS remark
		FROM gl_posting_master glm
		LEFT JOIN gl_posting_detail gld ON gld.gl_posting_master_id = glm.gl_posting_master_id 
		LEFT JOIN work_flow wf ON wf.work_flow_id = glm.work_flow_id
		LEFT JOIN db_account_lang acl ON acl.account_code = gld.account_code 
									 AND acl.company_code = gld.company_code 
									 AND acl.language_code = p_lin_id
	 	LEFT JOIN db_cost_center_lang ccl ON ccl.company_code = gld.company_code 
	 									 AND ccl.cost_center_code = gld.division_code 
	 									 AND ccl.language_code = p_lin_id 
		WHERE COALESCE(glm.is_reverse_from_interface, FALSE) = FALSE
		AND wf.company_code = COALESCE(p_ou_code, wf.company_code)
		AND wf.branch_code = COALESCE(p_branch_code, wf.branch_code)
		AND gld.division_code = COALESCE(p_cost_center_code, gld.division_code)
		AND gld.account_code = COALESCE(p_expense_code, gld.account_code)
		AND wf.document_no = COALESCE(p_document_no, wf.document_no)
		AND	COALESCE(glm.document_date::DATE, '1970-01-01'::DATE) BETWEEN
																 COALESCE(p_document_date_from::DATE, glm.document_date::DATE, '1970-01-01'::DATE)
																 AND
																 COALESCE(p_document_date_to::DATE, glm.document_date::DATE, '1970-01-01'::DATE)
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
		ORDER BY gld.gl_posting_master_id ASC, gld.gl_posting_detail_id ASC, gld.account_seq ASC
		
	-- End query
	;END;
$function$
;
