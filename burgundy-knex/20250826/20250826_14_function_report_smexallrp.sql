drop function report_smexallrp;

CREATE OR REPLACE FUNCTION dbo.report_smexallrp(p_lin_id character varying, p_ou_code character varying, p_invoice_date_from character varying, p_invoice_date_to character varying, p_vendor_code character varying, p_account_code character varying, p_expense_code character varying, p_cost_center_code character varying, p_project_code character varying, p_requester_code character varying, p_show_detail boolean, user_login integer)
 RETURNS TABLE(f_company_name character varying, f_branch_name character varying, f_print_date timestamp with time zone, f_document_id numeric, f_document_item_id numeric, f_document_item_expense_id numeric, f_program_type character varying, f_invoice_number character varying, f_invoice_date character varying, f_invoice_desc character varying, f_vendor_code character varying, f_vendor_name character varying, f_vendor_branch_code character varying, f_vendor_branch_name character varying, f_vendor_tax_id character varying, f_expense_desc character varying, f_expense_group_code character varying, f_expense_group_name character varying, f_expense_code character varying, f_expense_name character varying, f_account_code character varying, f_account_name character varying, f_cost_center_code character varying, f_cost_center_name character varying, f_project_code character varying, f_project_name character varying, f_document_no character varying, f_document_date character varying, f_document_status character varying, f_requester_code character varying, f_requester_name character varying, f_base_amount numeric, f_vat_amount numeric, f_amount numeric, f_cri_vendor character varying)
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
		SELECT 	get_company_code_name(
										p_lin_id
										, prq_exp.company_code
									 )									::CHARACTER VARYING AS f_company_name,
			    get_branch_code_name(
										p_lin_id
										, prq_exp.branch_code
									)									::CHARACTER VARYING AS f_branch_name,
				current_timestamp 										AS f_print_date,
				prq_item.prq_document_id 								::NUMERIC AS f_document_id,
				prq_exp.prq_document_item_id 							::NUMERIC AS f_document_item_id,
				prq_exp.prq_document_item_expense_id 					::NUMERIC AS f_document_item_expense_id,
				wf.work_flow_type_code									::CHARACTER VARYING AS f_program_type,
				prq_item.available_document_number						::CHARACTER VARYING AS f_invoice_number,
				to_char(prq_item.available_document_date, 'dd/MM/yyyy')	::CHARACTER VARYING AS f_invoice_date,
				prq_item.description									::CHARACTER VARYING AS f_invoice_desc,
				prq_item.vendor_code									::CHARACTER VARYING AS f_vendor_code,
				CASE WHEN vd.is_onetime = TRUE THEN prq_item.vendor_name 
					 ELSE vdl.vendor_name
					  END												::CHARACTER VARYING AS f_vendor_name,
			    prq_item.vendor_branch_code								::CHARACTER VARYING AS f_vendor_branch_code,
			    prq_item.vendor_branch_name								::CHARACTER VARYING AS f_vendor_branch_name,
			    prq_item.vendor_tax_id									::CHARACTER VARYING AS f_vendor_tax_id,
			    prq_exp.description										::CHARACTER VARYING AS f_expense_desc,
			    prq_exp.expense_group_code								::CHARACTER VARYING AS f_expense_group_code,
			    exp_gl.expense_group_name								::CHARACTER VARYING AS f_expense_group_name,
			    prq_exp.expense_code									::CHARACTER VARYING AS f_expense_code,
			    exp_l.expense_name										::CHARACTER VARYING AS f_expense_name,
			    "exp".account_code										::CHARACTER VARYING AS f_account_code,
			    acc_l.account_name										::CHARACTER VARYING AS f_account_name,
			    prq_exp.cost_center_code								::CHARACTER VARYING AS f_cost_center_code,
			    cost_l.cost_center_name									::CHARACTER VARYING AS f_cost_center_name,
			    prq_exp.project_code									::CHARACTER VARYING AS f_project_code,
			    pj_l.project_name										::CHARACTER VARYING AS f_project_name,
			    wf.document_no											::CHARACTER VARYING AS f_document_no,
			    to_char(wf.document_date, 'dd/MM/yyyy')					::CHARACTER VARYING AS f_document_date,
			    wf_stt_l.status_desc									::CHARACTER VARYING AS f_document_status,
			    wf.requester_user_code									::CHARACTER VARYING AS f_requester_code,
			    dbo.get_employee_name(	p_lin_id, 
			    						prq_exp.company_code, 
			    						prq_exp.branch_code, 
			    						wf.requester_user_code
		    						 )									::CHARACTER VARYING AS f_requester_name,
		    	prq_exp.amount_local									::NUMERIC AS f_base_amount,
		    	(prq_exp.amount_local * ((prq_item.total_vat_amount_local * 100) / prq_item.total_base_amount_local)) / 100 ::NUMERIC AS f_vat_amount,
	    		prq_exp.amount_local + ((prq_exp.amount_local * ((prq_item.total_vat_amount_local * 100) / prq_item.total_base_amount_local)) / 100) ::NUMERIC AS f_amount,
		    	vdl_cri.vendor_name 									::CHARACTER VARYING AS f_cri_vendor
		FROM 		prq_document_item_expense AS prq_exp
		LEFT JOIN 	prq_document_item AS prq_item ON prq_item.prq_document_item_id = prq_exp.prq_document_item_id
		LEFT JOIN 	prq_document AS prq_doc ON prq_doc.prq_document_id = prq_item.prq_document_id
		LEFT JOIN 	work_flow AS wf ON wf.work_flow_id = prq_doc.work_flow_id
		LEFT JOIN 	db_vendor AS vd ON vd.vendor_code = prq_item.vendor_code 
								   AND vd.company_code = prq_item.company_code
		LEFT JOIN 	db_vendor_lang AS vdl ON vdl.vendor_code = prq_item.vendor_code
									     AND vdl.company_code = prq_item.company_code 
									     AND vdl.language_code = p_lin_id
		LEFT JOIN 	db_vendor AS vd_cri ON vd_cri.vendor_code = prq_item.vendor_code 
								   	   AND vd_cri.company_code = prq_item.company_code
		LEFT JOIN 	db_vendor_lang AS vdl_cri ON vdl_cri.vendor_code = prq_item.vendor_code
									         AND vdl_cri.company_code = prq_item.company_code 
									         AND vdl_cri.language_code = p_lin_id									     
		LEFT JOIN 	db_income_expense_group_lang AS exp_gl ON exp_gl.expense_group_code = prq_exp.expense_group_code 
														  AND exp_gl.company_code = prq_exp.company_code
														  AND exp_gl.language_code = p_lin_id
		LEFT JOIN 	db_income_expense AS "exp" ON "exp".company_code = prq_exp.company_code 
											  AND "exp".expense_group_code = prq_exp.expense_group_code
											  AND "exp".expense_code = prq_exp.expense_code
		LEFT JOIN 	db_income_expense_lang AS exp_l ON exp_l.company_code = prq_exp.company_code 
												   AND exp_l.expense_group_code = prq_exp.expense_group_code 
												   AND exp_l.expense_code = prq_exp.expense_code
												   AND exp_l.language_code = p_lin_id
		LEFT JOIN 	db_account_lang AS acc_l ON acc_l.company_code = "exp".company_code
										    AND acc_l.account_code = "exp".account_code
										    AND acc_l.language_code = p_lin_id
		LEFT JOIN 	db_cost_center_lang AS cost_l ON cost_l.company_code = prq_exp.company_code 
											     AND cost_l.cost_center_code = prq_exp.cost_center_code
											     AND cost_l.language_code = p_lin_id
		LEFT JOIN 	db_project_lang AS pj_l ON pj_l.company_code = prq_exp.company_code 
										   AND pj_l.project_code = prq_exp.project_code
										   AND pj_l.language_code = p_lin_id
		LEFT JOIN 	db_doc_status_lang AS wf_stt_l ON wf_stt_l.company_code = prq_exp.company_code 
												  AND wf_stt_l.table_name = 'Document'
												  AND wf_stt_l.column_name = 'Status'
												  AND wf_stt_l.status_value = wf.status
												  AND wf_stt_l.language_code = p_lin_id
		WHERE 	1=1
		AND 	wf.status NOT IN ('Cancel', 'Draft')
		AND		COALESCE(prq_exp.company_code, '') = COALESCE(p_ou_code, prq_exp.company_code, '')
		AND 	COALESCE(prq_item.available_document_date::DATE, '1970-01-01'::DATE) BETWEEN
																						COALESCE(p_invoice_date_from::DATE, prq_item.available_document_date::DATE, '1970-01-01'::DATE)
																					 AND
																					 	COALESCE(p_invoice_date_to::DATE, prq_item.available_document_date::DATE, '1970-01-01'::DATE)
		AND		COALESCE(prq_item.vendor_code, '') = COALESCE(p_vendor_code, prq_item.vendor_code, '')
		AND		COALESCE("exp".account_code, '') = COALESCE(p_account_code, "exp".account_code, '')
		AND		COALESCE("exp".expense_code, '') = COALESCE(p_expense_code, "exp".expense_code, '')
		AND		COALESCE(prq_exp.cost_center_code, '') = COALESCE(p_cost_center_code, prq_exp.cost_center_code, '')
		AND		COALESCE(prq_exp.project_code, '') = COALESCE(p_project_code, prq_exp.project_code, '')
		AND		COALESCE(wf.requester_user_code, '') = COALESCE(p_requester_code, wf.requester_user_code, '')
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
		union all
		
		select  get_company_code_name(p_lin_id, fed.company_code)		::CHARACTER VARYING AS f_company_name,
			    get_branch_code_name(p_lin_id, fed.branch_code)			::CHARACTER VARYING AS f_branch_name,
				current_timestamp 										AS f_print_date,
				fei.expense_document_id 								::NUMERIC AS f_document_id,
				feii.expense_invoice_id 								::NUMERIC AS f_document_item_id,
				feii.expense_invoice_item_id 							::NUMERIC AS f_document_item_expense_id,
				wf.work_flow_type_code									::CHARACTER VARYING AS f_program_type,
				fei.invoice_no 											::CHARACTER VARYING AS f_invoice_number,
				to_char(fei.invoice_date, 'dd/MM/yyyy')					::CHARACTER VARYING AS f_invoice_date,
				fei.invoice_description 								::CHARACTER VARYING AS f_invoice_desc,
				null													::CHARACTER VARYING AS f_vendor_code,
				fei.vendor_name 										::CHARACTER VARYING AS f_vendor_name,
			    fei.vendor_branch_code									::CHARACTER VARYING AS f_vendor_branch_code,
			    null													::CHARACTER VARYING AS f_vendor_branch_name,
			    fei.vendor_tax_id										::CHARACTER VARYING AS f_vendor_tax_id,
			    feii.expense_description								::CHARACTER VARYING AS f_expense_desc,
			    exp_gl.expense_group_code								::CHARACTER VARYING AS f_expense_group_code,
			    exp_gl.expense_group_name								::CHARACTER VARYING AS f_expense_group_name,
			    feii.expense_code										::CHARACTER VARYING AS f_expense_code,
			    exp_l.expense_name										::CHARACTER VARYING AS f_expense_name,
			    "exp".account_code										::CHARACTER VARYING AS f_account_code,
			    acc_l.account_name										::CHARACTER VARYING AS f_account_name,
			    feii.cost_center_code									::CHARACTER VARYING AS f_cost_center_code,
			    cost_l.cost_center_name									::CHARACTER VARYING AS f_cost_center_name,
			    feii.project_code										::CHARACTER VARYING AS f_project_code,
			    pj_l.project_name										::CHARACTER VARYING AS f_project_name,
			    wf.document_no											::CHARACTER VARYING AS f_document_no,
			    to_char(wf.document_date, 'dd/MM/yyyy')					::CHARACTER VARYING AS f_document_date,
			    wf_stt_l.status_desc									::CHARACTER VARYING AS f_document_status,
			    wf.requester_user_code									::CHARACTER VARYING AS f_requester_code,
			    dbo.get_employee_name(	p_lin_id, 
			    						feii.company_code, 
			    						feii.branch_code, 
			    						wf.requester_user_code)			::CHARACTER VARYING AS f_requester_name,
		    	feii.base_amount * COALESCE(feii.exchange_rate ,1) 		::NUMERIC AS f_base_amount,
		    	feii.vat_amount * COALESCE(feii.exchange_rate ,1) 		::NUMERIC AS f_vat_amount,
		    	(feii.base_amount * COALESCE(feii.exchange_rate ,1)) + (feii.vat_amount * COALESCE(feii.exchange_rate ,1)) ::NUMERIC AS f_amount,
		    	NULL  													::CHARACTER VARYING AS f_cri_vendor
		FROM fn_expense_invoice_item AS feii
		LEFT JOIN 	fn_expense_invoice AS fei on fei.expense_invoice_id  = feii.expense_invoice_id 
		LEFT JOIN 	fn_expense_document AS fed on fed.expense_document_id = fei.expense_document_id 
		LEFT JOIN 	fn_expense_mileage AS fem on fem.expense_document_id = fed.expense_document_id 
		LEFT JOIN 	fn_expense_perdiem AS fep on fep.expense_document_id = fed.expense_document_id 
		LEFT JOIN 	work_flow AS wf ON wf.work_flow_id = fed.work_flow_id
		LEFT JOIN 	db_income_expense AS "exp" ON "exp".company_code = feii.company_code
										  AND "exp".expense_code = feii.expense_code
		LEFT JOIN 	db_income_expense_lang AS exp_l ON exp_l.company_code = feii.company_code
										   AND exp_l.expense_code = feii.expense_code
										   AND exp_l.language_code = p_lin_id
		LEFT JOIN 	db_income_expense_group_lang AS exp_gl ON exp_gl.expense_group_code = exp_l.expense_group_code 
										  AND exp_gl.company_code = exp_l.company_code
										  AND exp_gl.language_code = p_lin_id
		LEFT JOIN 	db_account_lang AS acc_l ON acc_l.company_code = "exp".company_code
									    AND acc_l.account_code = "exp".account_code
									    AND acc_l.language_code = p_lin_id
		LEFT JOIN 	db_cost_center_lang AS cost_l ON cost_l.company_code = feii.company_code 
									     AND cost_l.cost_center_code = feii.cost_center_code
									     AND cost_l.language_code = p_lin_id
		LEFT JOIN 	db_project_lang AS pj_l ON pj_l.company_code = feii.company_code 
										   AND pj_l.project_code = feii.project_code
										   AND pj_l.language_code = p_lin_id
		LEFT JOIN 	db_doc_status_lang AS wf_stt_l ON wf_stt_l.company_code = feii.company_code 
											  AND wf_stt_l.table_name = 'Document'
											  AND wf_stt_l.column_name = 'Status'
											  AND wf_stt_l.status_value = wf.status
											  AND wf_stt_l.language_code = p_lin_id
		WHERE 1=1
		AND wf.status IN ('WaitForVerify' ,'WaitForApproveVerify' ,'WaitForMoneyTransfer' ,'Complete')
		AND	COALESCE(fed.company_code, '') = COALESCE(p_ou_code, fed.company_code, '')
		AND COALESCE(fei.invoice_date ::DATE, '1970-01-01'::DATE) BETWEEN
						COALESCE(p_invoice_date_from::DATE, fei.invoice_date::DATE, '1970-01-01'::DATE)
					 AND
					 	COALESCE(p_invoice_date_to::DATE, fei.invoice_date::DATE, '1970-01-01'::DATE)
		AND	COALESCE("exp".account_code, '') = COALESCE(p_account_code, "exp".account_code, '')
		AND	COALESCE("exp".expense_code, '') = COALESCE(p_expense_code, "exp".expense_code, '')
		AND	COALESCE(feii.cost_center_code, '') = COALESCE(p_cost_center_code, feii.cost_center_code, '')
		AND	COALESCE(feii.project_code, '') = COALESCE(p_project_code, feii.project_code, '')
		AND	COALESCE(wf.requester_user_code, '') = COALESCE(p_requester_code, wf.requester_user_code, '')
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
		union all
		select  get_company_code_name(p_lin_id, fed.company_code)		::CHARACTER VARYING AS f_company_name,
			    get_branch_code_name(p_lin_id, fed.branch_code)			::CHARACTER VARYING AS f_branch_name,
				current_timestamp 										AS f_print_date,
				fem.expense_document_id 								::NUMERIC AS f_document_id,
				femi.expense_mileage_id 								::NUMERIC AS f_document_item_id,
				femi.mileage_item_id 									::NUMERIC AS f_document_item_expense_id,
				wf.work_flow_type_code									::CHARACTER VARYING AS f_program_type,
				null													::CHARACTER VARYING AS f_invoice_number,
				null													::CHARACTER VARYING AS f_invoice_date,
				fem.description 										::CHARACTER VARYING AS f_invoice_desc,
				null													::CHARACTER VARYING AS f_vendor_code,
				null													::CHARACTER VARYING AS f_vendor_name,
			    null													::CHARACTER VARYING AS f_vendor_branch_code,
			    null													::CHARACTER VARYING AS f_vendor_branch_name,
			    null													::CHARACTER VARYING AS f_vendor_tax_id,
			    fem.description											::CHARACTER VARYING AS f_expense_desc,
			    exp_gl.expense_group_code								::CHARACTER VARYING AS f_expense_group_code,
			    exp_gl.expense_group_name								::CHARACTER VARYING AS f_expense_group_name,
			    fem.expense_code										::CHARACTER VARYING AS f_expense_code,
			    exp_l.expense_name										::CHARACTER VARYING AS f_expense_name,
			    "exp".account_code										::CHARACTER VARYING AS f_account_code,
			    acc_l.account_name										::CHARACTER VARYING AS f_account_name,
			    fem.cost_center_code									::CHARACTER VARYING AS f_cost_center_code,
			    cost_l.cost_center_name									::CHARACTER VARYING AS f_cost_center_name,
			    fem.project_code										::CHARACTER VARYING AS f_project_code,
			    pj_l.project_name										::CHARACTER VARYING AS f_project_name,
			    wf.document_no											::CHARACTER VARYING AS f_document_no,
			    to_char(wf.document_date, 'dd/MM/yyyy')					::CHARACTER VARYING AS f_document_date,
			    wf_stt_l.status_desc									::CHARACTER VARYING AS f_document_status,
			    wf.requester_user_code									::CHARACTER VARYING AS f_requester_code,
			    dbo.get_employee_name(	p_lin_id, 
			    						femi.company_code, 
			    						femi.branch_code, 
			    						wf.requester_user_code)			::CHARACTER VARYING AS f_requester_name,
		    	femi.curr_amount * COALESCE(femi.exchange_rate ,1) 		::NUMERIC AS f_base_amount,
		    	0		::NUMERIC AS f_vat_amount,
		    	(femi.curr_amount * COALESCE(femi.exchange_rate ,1))     ::NUMERIC AS f_amount,
		    	NULL  													::CHARACTER VARYING AS f_cri_vendor
		FROM fn_expense_mileage_item AS femi
		LEFT JOIN 	fn_expense_mileage AS fem on fem.expense_mileage_id  = femi.expense_mileage_id 
		LEFT JOIN 	fn_expense_document AS fed on fed.expense_document_id = fem.expense_document_id 
		LEFT JOIN 	work_flow AS wf ON wf.work_flow_id = fed.work_flow_id
		LEFT JOIN 	db_income_expense AS "exp" ON "exp".company_code = femi.company_code
										  AND "exp".expense_code = fem.expense_code
		LEFT JOIN 	db_income_expense_lang AS exp_l ON exp_l.company_code = fem.company_code
										   AND exp_l.expense_code = fem.expense_code
										   AND exp_l.language_code = p_lin_id
		LEFT JOIN 	db_income_expense_group_lang AS exp_gl ON exp_gl.expense_group_code = exp_l.expense_group_code 
										  AND exp_gl.company_code = exp_l.company_code
										  AND exp_gl.language_code = p_lin_id
		LEFT JOIN 	db_account_lang AS acc_l ON acc_l.company_code = "exp".company_code
									    AND acc_l.account_code = "exp".account_code
									    AND acc_l.language_code = p_lin_id
		LEFT JOIN 	db_cost_center_lang AS cost_l ON cost_l.company_code = fem.company_code 
									     AND cost_l.cost_center_code = fem.cost_center_code
									     AND cost_l.language_code = p_lin_id
		LEFT JOIN 	db_project_lang AS pj_l ON pj_l.company_code = fem.company_code 
										   AND pj_l.project_code = fem.project_code
										   AND pj_l.language_code = p_lin_id
		LEFT JOIN 	db_doc_status_lang AS wf_stt_l ON wf_stt_l.company_code = femi.company_code 
											  AND wf_stt_l.table_name = 'Document'
											  AND wf_stt_l.column_name = 'Status'
											  AND wf_stt_l.status_value = wf.status
											  AND wf_stt_l.language_code = p_lin_id
		WHERE 1=1
		AND wf.status IN ('WaitForVerify' ,'WaitForApproveVerify' ,'WaitForMoneyTransfer' ,'Complete')
		AND	COALESCE(fed.company_code, '') = COALESCE(p_ou_code, fed.company_code, '')
		AND	COALESCE("exp".account_code, '') = COALESCE(p_account_code, "exp".account_code, '')
		AND	COALESCE("exp".expense_code, '') = COALESCE(p_expense_code, "exp".expense_code, '')
		AND	COALESCE(fem.cost_center_code, '') = COALESCE(p_cost_center_code, fem.cost_center_code, '')
		AND	COALESCE(fem.project_code, '') = COALESCE(p_project_code, fem.project_code, '')
		AND	COALESCE(wf.requester_user_code, '') = COALESCE(p_requester_code, wf.requester_user_code, '')
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
		union all
		select  get_company_code_name(p_lin_id, fed.company_code)		::CHARACTER VARYING AS f_company_name,
			    get_branch_code_name(p_lin_id, fed.branch_code)			::CHARACTER VARYING AS f_branch_name,
				current_timestamp 										AS f_print_date,
				fep.expense_document_id 								::NUMERIC AS f_document_id,
				fepi.expense_perdiem_id 								::NUMERIC AS f_document_item_id,
				fepi.perdiem_item_id 									::NUMERIC AS f_document_item_expense_id,
				wf.work_flow_type_code									::CHARACTER VARYING AS f_program_type,
				null													::CHARACTER VARYING AS f_invoice_number,
				null													::CHARACTER VARYING AS f_invoice_date,
				null 													::CHARACTER VARYING AS f_invoice_desc,
				null													::CHARACTER VARYING AS f_vendor_code,
				null													::CHARACTER VARYING AS f_vendor_name,
			    null													::CHARACTER VARYING AS f_vendor_branch_code,
			    null													::CHARACTER VARYING AS f_vendor_branch_name,
			    null													::CHARACTER VARYING AS f_vendor_tax_id,
			    fepi.perdiem_detail 									::CHARACTER VARYING AS f_expense_desc,
			    exp_gl.expense_group_code								::CHARACTER VARYING AS f_expense_group_code,
			    exp_gl.expense_group_name								::CHARACTER VARYING AS f_expense_group_name,
			    fep.expense_code										::CHARACTER VARYING AS f_expense_code,
			    exp_l.expense_name										::CHARACTER VARYING AS f_expense_name,
			    "exp".account_code										::CHARACTER VARYING AS f_account_code,
			    acc_l.account_name										::CHARACTER VARYING AS f_account_name,
			    fep.cost_center_code									::CHARACTER VARYING AS f_cost_center_code,
			    cost_l.cost_center_name									::CHARACTER VARYING AS f_cost_center_name,
			    fep.project_code										::CHARACTER VARYING AS f_project_code,
			    pj_l.project_name										::CHARACTER VARYING AS f_project_name,
			    wf.document_no											::CHARACTER VARYING AS f_document_no,
			    to_char(wf.document_date, 'dd/MM/yyyy')					::CHARACTER VARYING AS f_document_date,
			    wf_stt_l.status_desc									::CHARACTER VARYING AS f_document_status,
			    wf.requester_user_code									::CHARACTER VARYING AS f_requester_code,
			    dbo.get_employee_name(	p_lin_id, 
			    						fepi.company_code, 
			    						fepi.branch_code, 
			    						wf.requester_user_code)			::CHARACTER VARYING AS f_requester_name,
		    	fepi.curr_amount * COALESCE(fepi.exchange_rate ,1) 		::NUMERIC AS f_base_amount,
		    	0		::NUMERIC AS f_vat_amount,
		    	(fepi.curr_amount * COALESCE(fepi.exchange_rate ,1))     ::NUMERIC AS f_amount,
		    	NULL  													::CHARACTER VARYING AS f_cri_vendor
		FROM fn_expense_perdiem_item AS fepi
		LEFT JOIN 	fn_expense_perdiem AS fep on fep.expense_perdiem_id  = fepi.expense_perdiem_id 
		LEFT JOIN 	fn_expense_document AS fed on fed.expense_document_id = fep.expense_document_id 
		LEFT JOIN 	work_flow AS wf ON wf.work_flow_id = fed.work_flow_id
		LEFT JOIN 	db_income_expense AS "exp" ON "exp".company_code = fepi.company_code
										  AND "exp".expense_code = fep.expense_code
		LEFT JOIN 	db_income_expense_lang AS exp_l ON exp_l.company_code = fep.company_code
										   AND exp_l.expense_code = fep.expense_code
										   AND exp_l.language_code = p_lin_id
		LEFT JOIN 	db_income_expense_group_lang AS exp_gl ON exp_gl.expense_group_code = exp_l.expense_group_code 
										  AND exp_gl.company_code = exp_l.company_code
										  AND exp_gl.language_code = p_lin_id
		LEFT JOIN 	db_account_lang AS acc_l ON acc_l.company_code = "exp".company_code
									    AND acc_l.account_code = "exp".account_code
									    AND acc_l.language_code = p_lin_id
		LEFT JOIN 	db_cost_center_lang AS cost_l ON cost_l.company_code = fep.company_code 
									     AND cost_l.cost_center_code = fep.cost_center_code
									     AND cost_l.language_code = p_lin_id
		LEFT JOIN 	db_project_lang AS pj_l ON pj_l.company_code = fep.company_code 
										   AND pj_l.project_code = fep.project_code
										   AND pj_l.language_code = p_lin_id
		LEFT JOIN 	db_doc_status_lang AS wf_stt_l ON wf_stt_l.company_code = fepi.company_code 
											  AND wf_stt_l.table_name = 'Document'
											  AND wf_stt_l.column_name = 'Status'
											  AND wf_stt_l.status_value = wf.status
											  AND wf_stt_l.language_code = p_lin_id
		WHERE 1=1
		AND wf.status IN ('WaitForVerify' ,'WaitForApproveVerify' ,'WaitForMoneyTransfer' ,'Complete')
		AND	COALESCE(fed.company_code, '') = COALESCE(p_ou_code, fed.company_code, '')
		AND	COALESCE("exp".account_code, '') = COALESCE(p_account_code, "exp".account_code, '')
		AND	COALESCE("exp".expense_code, '') = COALESCE(p_expense_code, "exp".expense_code, '')
		AND	COALESCE(fep.cost_center_code, '') = COALESCE(p_cost_center_code, fep.cost_center_code, '')
		AND	COALESCE(fep.project_code, '') = COALESCE(p_project_code, fep.project_code, '')
		AND	COALESCE(wf.requester_user_code, '') = COALESCE(p_requester_code, wf.requester_user_code, '')
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
		union all
		select  get_company_code_name(p_lin_id, pd.company_code)		::CHARACTER VARYING AS f_company_name,
			    get_branch_code_name(p_lin_id, pd.branch_code)			::CHARACTER VARYING AS f_branch_name,
				current_timestamp 										AS f_print_date,
				pdi.pc_document_id 								::NUMERIC AS f_document_id,
				pdii.pc_document_invoice_id  							::NUMERIC AS f_document_item_id,
				pdii.pc_document_invoice_item_id  						::NUMERIC AS f_document_item_expense_id,
				wf.work_flow_type_code									::CHARACTER VARYING AS f_program_type,
				pdi.invoice_no 											::CHARACTER VARYING AS f_invoice_number,
				to_char(pdi.invoice_date, 'dd/MM/yyyy')					::CHARACTER VARYING AS f_invoice_date,
				pdi.invoice_description 								::CHARACTER VARYING AS f_invoice_desc,
				null													::CHARACTER VARYING AS f_vendor_code,
				pdi.vendor_name 										::CHARACTER VARYING AS f_vendor_name,
			    pdi.vendor_branch_code									::CHARACTER VARYING AS f_vendor_branch_code,
			    null													::CHARACTER VARYING AS f_vendor_branch_name,
			    pdi.vendor_tax_id										::CHARACTER VARYING AS f_vendor_tax_id,
			    pdii.expense_description 								::CHARACTER VARYING AS f_expense_desc,
			    exp_gl.expense_group_code								::CHARACTER VARYING AS f_expense_group_code,
			    exp_gl.expense_group_name								::CHARACTER VARYING AS f_expense_group_name,
			    pdii.expense_code										::CHARACTER VARYING AS f_expense_code,
			    exp_l.expense_name										::CHARACTER VARYING AS f_expense_name,
			    "exp".account_code										::CHARACTER VARYING AS f_account_code,
			    acc_l.account_name										::CHARACTER VARYING AS f_account_name,
			    pdii.cost_center_code									::CHARACTER VARYING AS f_cost_center_code,
			    cost_l.cost_center_name									::CHARACTER VARYING AS f_cost_center_name,
			    pdii.project_code										::CHARACTER VARYING AS f_project_code,
			    pj_l.project_name										::CHARACTER VARYING AS f_project_name,
			    wf.document_no											::CHARACTER VARYING AS f_document_no,
			    to_char(wf.document_date, 'dd/MM/yyyy')					::CHARACTER VARYING AS f_document_date,
			    wf_stt_l.status_desc									::CHARACTER VARYING AS f_document_status,
			    wf.requester_user_code									::CHARACTER VARYING AS f_requester_code,
			    dbo.get_employee_name(	p_lin_id, 
			    						pdii.company_code, 
			    						pdii.branch_code, 
			    						wf.requester_user_code)			::CHARACTER VARYING AS f_requester_name,
		    	pdii.base_amount * COALESCE(pdii.exchange_rate ,1) 		::NUMERIC AS f_base_amount,
		    	pdii.vat_amount * COALESCE(pdii.exchange_rate ,1) 		::NUMERIC AS f_vat_amount,
		    	(pdii.base_amount * COALESCE(pdii.exchange_rate ,1)) + (pdii.vat_amount * COALESCE(pdii.exchange_rate ,1)) ::NUMERIC AS f_amount,
		    	NULL  													::CHARACTER VARYING AS f_cri_vendor
		FROM pc_document_invoice_item AS pdii
		LEFT JOIN 	pc_document_invoice AS pdi on pdi.pc_document_invoice_id = pdii.pc_document_invoice_id 
		LEFT JOIN 	pc_document AS pd on pd.pc_document_id = pdi.pc_document_id
		LEFT JOIN 	work_flow AS wf ON wf.work_flow_id = pd.work_flow_id
		LEFT JOIN 	db_income_expense AS "exp" ON "exp".company_code = pdii.company_code
										  AND "exp".expense_code = pdii.expense_code
		LEFT JOIN 	db_income_expense_lang AS exp_l ON exp_l.company_code = pdii.company_code
										   AND exp_l.expense_code = pdii.expense_code
										   AND exp_l.language_code = p_lin_id
		LEFT JOIN 	db_income_expense_group_lang AS exp_gl ON exp_gl.expense_group_code = exp_l.expense_group_code 
										  AND exp_gl.company_code = exp_l.company_code
										  AND exp_gl.language_code = p_lin_id
		LEFT JOIN 	db_account_lang AS acc_l ON acc_l.company_code = "exp".company_code
									    AND acc_l.account_code = "exp".account_code
									    AND acc_l.language_code = p_lin_id
		LEFT JOIN 	db_cost_center_lang AS cost_l ON cost_l.company_code = pdii.company_code 
									     AND cost_l.cost_center_code = pdii.cost_center_code
									     AND cost_l.language_code = p_lin_id
		LEFT JOIN 	db_project_lang AS pj_l ON pj_l.company_code = pdii.company_code 
										   AND pj_l.project_code = pdii.project_code
										   AND pj_l.language_code = p_lin_id
		LEFT JOIN 	db_doc_status_lang AS wf_stt_l ON wf_stt_l.company_code = pdii.company_code 
											  AND wf_stt_l.table_name = 'Document'
											  AND wf_stt_l.column_name = 'Status'
											  AND wf_stt_l.status_value = wf.status
											  AND wf_stt_l.language_code = p_lin_id
		WHERE 1=1
		and wf.work_flow_sub_type_code = 'PCQ'
		AND wf.status IN ('WaitForVerify' ,'WaitForApproveVerify' ,'WaitForMoneyTransfer' ,'Complete')
		AND	COALESCE(pd.company_code, '') = COALESCE(p_ou_code, pd.company_code, '')
		AND COALESCE(pdi.invoice_date ::DATE, '1970-01-01'::DATE) BETWEEN
						COALESCE(p_invoice_date_from::DATE, pdi.invoice_date::DATE, '1970-01-01'::DATE)
					 AND
					 	COALESCE(p_invoice_date_to::DATE, pdi.invoice_date::DATE, '1970-01-01'::DATE)
		AND	COALESCE("exp".account_code, '') = COALESCE(p_account_code, "exp".account_code, '')
		AND	COALESCE("exp".expense_code, '') = COALESCE(p_expense_code, "exp".expense_code, '')
		AND	COALESCE(pdii.cost_center_code, '') = COALESCE(p_cost_center_code, pdii.cost_center_code, '')
		AND	COALESCE(pdii.project_code, '') = COALESCE(p_project_code, pdii.project_code, '')
		AND	COALESCE(wf.requester_user_code, '') = COALESCE(p_requester_code, wf.requester_user_code, '')
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
	union all
		select  get_company_code_name(p_lin_id, pd.company_code)		::CHARACTER VARYING AS f_company_name,
			    get_branch_code_name(p_lin_id, pd.branch_code)			::CHARACTER VARYING AS f_branch_name,
				current_timestamp 										AS f_print_date,
				pdm.pc_document_id  								::NUMERIC AS f_document_id,
				pdmi.pc_document_mileage_id  							::NUMERIC AS f_document_item_id,
				pdmi.pc_document_mileage_item_id  						::NUMERIC AS f_document_item_expense_id,
				wf.work_flow_type_code									::CHARACTER VARYING AS f_program_type,
				null													::CHARACTER VARYING AS f_invoice_number,
				null													::CHARACTER VARYING AS f_invoice_date,
				pdm.description 										::CHARACTER VARYING AS f_invoice_desc,
				null													::CHARACTER VARYING AS f_vendor_code,
				null													::CHARACTER VARYING AS f_vendor_name,
			    null													::CHARACTER VARYING AS f_vendor_branch_code,
			    null													::CHARACTER VARYING AS f_vendor_branch_name,
			    null													::CHARACTER VARYING AS f_vendor_tax_id,
			    pdm.description											::CHARACTER VARYING AS f_expense_desc,
			    exp_gl.expense_group_code								::CHARACTER VARYING AS f_expense_group_code,
			    exp_gl.expense_group_name								::CHARACTER VARYING AS f_expense_group_name,
			    pdm.expense_code										::CHARACTER VARYING AS f_expense_code,
			    exp_l.expense_name										::CHARACTER VARYING AS f_expense_name,
			    "exp".account_code										::CHARACTER VARYING AS f_account_code,
			    acc_l.account_name										::CHARACTER VARYING AS f_account_name,
			    pdm.cost_center_code									::CHARACTER VARYING AS f_cost_center_code,
			    cost_l.cost_center_name									::CHARACTER VARYING AS f_cost_center_name,
			    pdm.project_code										::CHARACTER VARYING AS f_project_code,
			    pj_l.project_name										::CHARACTER VARYING AS f_project_name,
			    wf.document_no											::CHARACTER VARYING AS f_document_no,
			    to_char(wf.document_date, 'dd/MM/yyyy')					::CHARACTER VARYING AS f_document_date,
			    wf_stt_l.status_desc									::CHARACTER VARYING AS f_document_status,
			    wf.requester_user_code									::CHARACTER VARYING AS f_requester_code,
			    dbo.get_employee_name(	p_lin_id, 
			    						pdmi.company_code, 
			    						pdmi.branch_code, 
			    						wf.requester_user_code)			::CHARACTER VARYING AS f_requester_name,
		    	pdmi.curr_amount * COALESCE(pdmi.exchange_rate ,1) 		::NUMERIC AS f_base_amount,
		    	0		::NUMERIC AS f_vat_amount,
		    	(pdmi.curr_amount * COALESCE(pdmi.exchange_rate ,1))     ::NUMERIC AS f_amount,
		    	NULL  													::CHARACTER VARYING AS f_cri_vendor
		FROM pc_document_mileage_item AS pdmi
		LEFT JOIN 	pc_document_mileage AS pdm on pdm.pc_document_mileage_id  = pdmi.pc_document_mileage_id  
		LEFT JOIN 	pc_document AS pd on pd.pc_document_id  = pdm.pc_document_id  
		LEFT JOIN 	work_flow AS wf ON wf.work_flow_id = pd.work_flow_id
		LEFT JOIN 	db_income_expense AS "exp" ON "exp".company_code = pdmi.company_code
										  AND "exp".expense_code = pdm.expense_code
		LEFT JOIN 	db_income_expense_lang AS exp_l ON exp_l.company_code = pdm.company_code
										   AND exp_l.expense_code = pdm.expense_code
										   AND exp_l.language_code = p_lin_id
		LEFT JOIN 	db_income_expense_group_lang AS exp_gl ON exp_gl.expense_group_code = exp_l.expense_group_code 
										  AND exp_gl.company_code = exp_l.company_code
										  AND exp_gl.language_code = p_lin_id
		LEFT JOIN 	db_account_lang AS acc_l ON acc_l.company_code = "exp".company_code
									    AND acc_l.account_code = "exp".account_code
									    AND acc_l.language_code = p_lin_id
		LEFT JOIN 	db_cost_center_lang AS cost_l ON cost_l.company_code = pdm.company_code 
									     AND cost_l.cost_center_code = pdm.cost_center_code
									     AND cost_l.language_code = p_lin_id
		LEFT JOIN 	db_project_lang AS pj_l ON pj_l.company_code = pdm.company_code 
										   AND pj_l.project_code = pdm.project_code
										   AND pj_l.language_code = p_lin_id
		LEFT JOIN 	db_doc_status_lang AS wf_stt_l ON wf_stt_l.company_code = pdmi.company_code 
											  AND wf_stt_l.table_name = 'Document'
											  AND wf_stt_l.column_name = 'Status'
											  AND wf_stt_l.status_value = wf.status
											  AND wf_stt_l.language_code = p_lin_id
		WHERE 1=1
		and wf.work_flow_sub_type_code = 'PCQ'
		AND wf.status IN ('WaitForVerify' ,'WaitForApproveVerify' ,'WaitForMoneyTransfer' ,'Complete')
		AND	COALESCE(pd.company_code, '') = COALESCE(p_ou_code, pd.company_code, '')
		AND	COALESCE("exp".account_code, '') = COALESCE(p_account_code, "exp".account_code, '')
		AND	COALESCE("exp".expense_code, '') = COALESCE(p_expense_code, "exp".expense_code, '')
		AND	COALESCE(pdm.cost_center_code, '') = COALESCE(p_cost_center_code, pdm.cost_center_code, '')
		AND	COALESCE(pdm.project_code, '') = COALESCE(p_project_code, pdm.project_code, '')
		AND	COALESCE(wf.requester_user_code, '') = COALESCE(p_requester_code, wf.requester_user_code, '')
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
	;END;
$function$
;
