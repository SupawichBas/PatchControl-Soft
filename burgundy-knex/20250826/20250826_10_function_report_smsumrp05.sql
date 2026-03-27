drop function report_smsumrp05;

CREATE OR REPLACE FUNCTION dbo.report_smsumrp05(p_lin_id character varying, p_ou_code character varying, p_branch_code character varying, p_cost_center_code character varying, p_requester_code character varying, p_invoice_date_from character varying, p_invoice_date_to character varying, p_doc_date_from character varying, p_doc_date_to character varying, p_doc_no character varying, p_vendor_code character varying, p_show_detail boolean, user_login integer)
 RETURNS TABLE(f_company_name character varying, f_branch_name character varying, f_print_date timestamp with time zone, f_invoice_no character varying, f_invoice_type_code character varying, f_invoice_type_name character varying, f_invoice_date character varying, f_invoice_desc character varying, f_document_no character varying, f_document_date character varying, f_document_status character varying, f_approver_code character varying, f_approver_name character varying, f_approve_date character varying, f_days_waiting numeric, f_requester_code character varying, f_requester_name character varying, f_verify_type character varying, f_delivery_status character varying, f_staff_code character varying, f_staff_name character varying, f_vendor_code character varying, f_vendor_name character varying, f_vendor_branch_code character varying, f_vendor_branch_name character varying, f_vendor_tax_id character varying, f_base_amount numeric, f_vat_amount numeric, f_amount numeric, f_wht_amount numeric, f_net_amount numeric, f_cri_vendor character varying, tabel character varying)
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
		SELECT 	get_company_code_name(
										p_lin_id
										, prq_item.company_code
									 )																									::CHARACTER VARYING AS f_company_name,
			    get_branch_code_name(
										p_lin_id
										, prq_item.branch_code
									)																									::CHARACTER VARYING AS f_branch_name,
				current_timestamp 																										AS f_print_date,
				NULLIF(prq_item.available_document_number, '')																			::CHARACTER VARYING AS	f_invoice_no,
				NULLIF(prq_item.available_document_code, '')																			::CHARACTER VARYING AS	f_invoice_type_code,
				NULLIF(lis_doc_ty_l.value_text, '')																						::CHARACTER VARYING AS	f_invoice_type_name,
				to_char(prq_item.available_document_date, 'dd/MM/yyyy')																	::CHARACTER VARYING AS 	f_invoice_date,
				NULLIF(prq_item.description, '')																						::CHARACTER VARYING AS	f_invoice_desc,
				NULLIF(wf.document_no, '')																								::CHARACTER VARYING AS	f_document_no,
				to_char(wf.document_date, 'dd/MM/yyyy')																					::CHARACTER VARYING AS 	f_document_date,
				NULLIF(wf_stt_l.status_desc, '')																						::CHARACTER VARYING AS 	f_document_status,
				NULLIF(wf.approver_user_code, '')																						::CHARACTER VARYING AS 	f_approver_code,
				dbo.get_employee_name(	p_lin_id, 
			    						prq_item.company_code, 
			    						prq_item.branch_code, 
			    						wf.approver_user_code
		    						 )																									::CHARACTER VARYING AS 	f_approver_name,
		    	to_char(wfa.action_date, 'dd/MM/yyyy')																					::CHARACTER VARYING AS 	f_approve_date,
		    	COALESCE((current_timestamp::date - wfa.action_date::date), 0) 															::NUMERIC AS f_days_waiting,
			    wf.requester_user_code																									::CHARACTER VARYING AS 	f_requester_code,
			    dbo.get_employee_name(	p_lin_id, 
			    						prq_item.company_code, 
			    						prq_item.branch_code, 
			    						wf.requester_user_code
		    						 )																									::CHARACTER VARYING AS 	f_requester_name,
		    	l_verify.value_text																										::CHARACTER VARYING AS 	f_verify_type,
		    	CASE WHEN COALESCE(prq_item.is_receive_original_document, FALSE) = FALSE THEN CASE WHEN p_lin_id = 'TH' THEN N'รอนำส่ง'
		    																					   ELSE 'Waiting for delivery'
		    																					    END 
		    		 ELSE CASE WHEN p_lin_id = 'TH' THEN N'นำส่งแล้ว'
							   ELSE 'Already delivered'
							    END 
		    		  END 																												::CHARACTER VARYING AS 	f_delivery_status,
			    COALESCE(wfa_staff.new_approver_code, wfa_staff.doa_approver_code) 														::CHARACTER VARYING AS 	f_staff_code,
			    dbo.get_employee_name(	p_lin_id, 
			    						prq_item.company_code, 
			    						prq_item.branch_code, 
			    						COALESCE(wfa_staff.new_approver_code, wfa_staff.doa_approver_code)
		    						 )																									::CHARACTER VARYING AS 	f_staff_name,
				prq_item.vendor_code																									::CHARACTER VARYING AS f_vendor_code,
				CASE WHEN vd.is_onetime = TRUE THEN prq_item.vendor_name 
					 ELSE vdl.vendor_name
					  END																												::CHARACTER VARYING AS f_vendor_name,
			    prq_item.vendor_branch_code																								::CHARACTER VARYING AS f_vendor_branch_code,
			    prq_item.vendor_branch_name																								::CHARACTER VARYING AS f_vendor_branch_name,
			    prq_item.vendor_tax_id																									::CHARACTER VARYING AS f_vendor_tax_id,
			    prq_item.total_base_amount_local 																						::NUMERIC AS f_base_amount,
		    	prq_item.total_vat_amount_local 																						::NUMERIC AS f_vat_amount,
		    	prq_item.total_amount_local																								::NUMERIC AS f_amount,
		    	prq_item.total_wht_amount_local																							::NUMERIC AS f_wht_amount,
		    	prq_item.total_net_amount_local 																						::NUMERIC AS f_net_amount,
		    	vdl_cri.vendor_name 																									::CHARACTER VARYING AS f_cri_vendor,
			    concat('Prq',prq_item.prq_document_item_id)							::CHARACTER VARYING AS tabel
		FROM		work_flow	AS	wf
		LEFT JOIN	prq_document	AS	prq	ON	prq.work_flow_id = wf.work_flow_id 
		LEFT JOIN 	prq_document_item	AS	prq_item	ON	prq_item.prq_document_id = prq.prq_document_id
		LEFT JOIN	prq_document_item_expense	AS	prq_exp	ON	prq_exp.prq_document_item_id = prq_item.prq_document_item_id
		LEFT JOIN 	db_list_value_lang	AS	lis_doc_ty_l	ON	lis_doc_ty_l.company_code = prq_item.company_code 
														   AND	lis_doc_ty_l.group_code = 'AvailableDocument'
														   AND 	lis_doc_ty_l.value = prq_item.available_document_code
														   AND	lis_doc_ty_l.language_code = p_lin_id
		LEFT JOIN 	db_doc_status	AS 	wf_stt	ON	wf_stt.company_code = wf.company_code 
											   AND 	wf_stt.status_value = wf.status
											   AND 	wf_stt.table_name = 'PRQDocument'
											   AND 	wf_stt.column_name = 'Status'
		LEFT JOIN 	db_doc_status_lang	AS 	wf_stt_l	ON 	wf_stt_l.company_code = wf_stt.company_code 
													   AND 	wf_stt_l.status_value = wf_stt.status_value
												       AND 	wf_stt_l.table_name = 'PRQDocument'
												       AND 	wf_stt_l.column_name = 'Status'
												       AND 	wf_stt_l.language_code = p_lin_id
		LEFT JOIN 	work_flow_approval	AS	wfa	ON 	wfa.work_flow_id = wf.work_flow_id 
											   AND	COALESCE(wfa.new_approver_code, wfa.doa_approver_code) = wf.approver_user_code
		LEFT JOIN 	db_list_value_lang	AS 	l_verify	ON 	l_verify.company_code = prq.company_code 
													   AND 	l_verify.group_code = 'VerifyType'
													   AND 	l_verify.value = prq.verify_type
													   AND 	l_verify.language_code = p_lin_id
		LEFT JOIN 	work_flow_approval	AS 	wfa_staff	ON 	wfa_staff.work_flow_id = wf.work_flow_id
													   AND	wfa_staff.approver_type = 'PRQ_ACC_STAFF'
													   AND 	wfa_staff.action_date IS NOT NULL
		LEFT JOIN 	db_vendor	AS 	vd	ON vd.vendor_code = prq_item.vendor_code 
								   	   AND vd.company_code = prq_item.company_code
		LEFT JOIN 	db_vendor_lang	AS 	vdl	ON vdl.vendor_code = prq_item.vendor_code
									       AND vdl.company_code = prq_item.company_code 
									       AND vdl.language_code = p_lin_id	
		LEFT JOIN 	db_vendor	AS 	vd_cri	ON vd_cri.vendor_code = prq_item.vendor_code 
								   	       AND vd_cri.company_code = prq_item.company_code
		LEFT JOIN 	db_vendor_lang	AS 	vdl_cri	ON vdl_cri.vendor_code = prq_item.vendor_code
									           AND vdl_cri.company_code = prq_item.company_code 
									           AND vdl_cri.language_code = p_lin_id										       
		WHERE	1=1
		AND	wf.work_flow_type_code = 'PRQ'
		AND	wf_stt.order_seq > 7 -- MORE THEN 'WAIT FOR APPROVE'
		AND	(
				COALESCE(prq_item.is_receive_original_document, FALSE) = FALSE 
				AND 
				COALESCE(prq.is_receive_original_document, FALSE) = FALSE
			)
		AND	wf.company_code = p_ou_code
		AND	wf.requester_user_code = COALESCE(p_requester_code, wf.requester_user_code)
		AND	COALESCE(prq_item.available_document_date::DATE, '1970-01-01'::DATE) BETWEEN
																				COALESCE(p_invoice_date_from::DATE, prq_item.available_document_date::DATE, '1970-01-01'::DATE)
																				 AND
																				 COALESCE(p_invoice_date_to::DATE, prq_item.available_document_date::DATE, '1970-01-01'::DATE)
		AND	COALESCE(wf.document_date::DATE, '1970-01-01'::DATE) BETWEEN
																 COALESCE(p_doc_date_from::DATE, wf.document_date::DATE, '1970-01-01'::DATE)
																 AND
																 COALESCE(p_doc_date_to::DATE, wf.document_date::DATE, '1970-01-01'::DATE)
		AND	COALESCE(prq_item.vendor_code, '') = COALESCE(p_vendor_code, prq_item.vendor_code, '')
		AND	COALESCE(wf.document_no, '') = COALESCE(p_doc_no, wf.document_no, '')
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
		UNION 
		SELECT 	get_company_code_name(p_lin_id, fei.company_code)							::CHARACTER VARYING AS f_company_name,
			    get_branch_code_name(p_lin_id, fei.branch_code )							::CHARACTER VARYING AS f_branch_name ,
			    current_timestamp 																				AS f_print_date,
				NULLIF(fei.invoice_no , '')													::CHARACTER VARYING AS	f_invoice_no,
				NULLIF('OtherDocument', '')													::CHARACTER VARYING AS	f_invoice_type_code,
				NULLIF(lis_doc_ty_l.value_text, '')::CHARACTER VARYING AS	f_invoice_type_name ,
				to_char(fei.invoice_date , 'dd/MM/yyyy')																				::CHARACTER VARYING AS 	f_invoice_date,
				NULLIF(fei.invoice_description , '')																					::CHARACTER VARYING AS	f_invoice_desc,
				NULLIF(wf.document_no, '')																								::CHARACTER VARYING AS	f_document_no,
				to_char(wf.document_date, 'dd/MM/yyyy')																					::CHARACTER VARYING AS 	f_document_date,
				NULLIF(wf_stt_l.status_desc, '')																						::CHARACTER VARYING AS 	f_document_status,
				NULLIF(wf.approver_user_code, '')																						::CHARACTER VARYING AS 	f_approver_code,
				dbo.get_employee_name(p_lin_id, wf.company_code, wf.branch_code, wf.approver_user_code)								::CHARACTER VARYING AS 	f_approver_name,
		    	to_char(wfa.action_date, 'dd/MM/yyyy')																					::CHARACTER VARYING AS 	f_approve_date,
		    	COALESCE((current_timestamp::date - wfa.action_date::date), 0) 															::NUMERIC AS f_days_waiting,
			    wf.requester_user_code																									::CHARACTER VARYING AS 	f_requester_code,
			    dbo.get_employee_name(p_lin_id, wf.company_code, wf.branch_code, wf.requester_user_code )								::CHARACTER VARYING AS 	f_requester_name,
		    	l_verify.value_text																										::CHARACTER VARYING AS 	f_verify_type,
		    	CASE WHEN COALESCE(fed.is_receive_original_document, FALSE) = FALSE 
	    				THEN 	CASE 	WHEN p_lin_id = 'TH' 
		    							THEN N'รอนำส่ง'
		    							ELSE 'Waiting for delivery'
						    	END 
		    		 	ELSE 	CASE 	WHEN p_lin_id = 'TH' 
		    		 					THEN N'นำส่งแล้ว'
							   			ELSE 'Already delivered'
							    END 
    		  	END 																												::CHARACTER VARYING AS 	f_delivery_status,
			    COALESCE(wfa_staff.new_approver_code, wfa_staff.doa_approver_code) 														::CHARACTER VARYING AS 	f_staff_code,
			    dbo.get_employee_name(	p_lin_id, wf.company_code, wf.branch_code ,COALESCE(wfa_staff.new_approver_code, wfa_staff.doa_approver_code))																									::CHARACTER VARYING AS 	f_staff_name,
				''																														::CHARACTER VARYING AS f_vendor_code,
				fei.vendor_name 																										::CHARACTER VARYING AS f_vendor_name,
			    fei.vendor_branch_code 																									::CHARACTER VARYING AS f_vendor_branch_code,
			    '' 																														::CHARACTER VARYING AS f_vendor_branch_name,
			    fei.vendor_tax_id 																										::CHARACTER VARYING AS f_vendor_tax_id,
			    fei.base_amount_local  				 																					::NUMERIC AS f_base_amount,
		    	fei.vat_amount_local  																									::NUMERIC AS f_vat_amount,
		    	fei.total_amount_local 																									::NUMERIC AS f_amount,
		    	fei.wht_amount_local 																									::NUMERIC AS f_wht_amount,
		    	fei.net_amount_local  																									::NUMERIC AS f_net_amount,
		    	null 																													::CHARACTER VARYING AS f_cri_vendor,
			    concat('invoice',fei.expense_invoice_id)							::CHARACTER VARYING AS tabel
		FROM 	work_flow AS wf 
				LEFT JOIN fn_expense_document fed ON fed.work_flow_id  = wf.work_flow_id 
				inner JOIN fn_expense_invoice fei ON fei.expense_document_id = fed.expense_document_id 
				LEFT JOIN db_list_value_lang AS	lis_doc_ty_l	ON	lis_doc_ty_l.company_code = fei.company_code 
														   AND	lis_doc_ty_l.group_code = 'AvailableDocument'
														   AND 	lis_doc_ty_l.value = 'OtherDocument'
														   AND	lis_doc_ty_l.language_code = p_lin_id
				LEFT JOIN db_doc_status	AS wf_stt 	ON	wf_stt.company_code = wf.company_code 
												   	AND wf_stt.status_value = wf.status
												   	AND wf_stt.table_name = 'FnExpenseDocument'
												   	AND wf_stt.column_name = 'Status'
				LEFT JOIN db_doc_status_lang AS wf_stt_l 	ON 	wf_stt_l.company_code = wf_stt.company_code 
													   		AND wf_stt_l.status_value = wf_stt.status_value
												       		AND wf_stt_l.table_name = 'FnExpenseDocument'
												       		AND wf_stt_l.column_name = 'Status'
												       		AND wf_stt_l.language_code = p_lin_id
		       	LEFT JOIN work_flow_approval AS	wfa	ON 	wfa.work_flow_id = wf.work_flow_id 
											   		AND	COALESCE(wfa.new_approver_code, wfa.doa_approver_code) = wf.approver_user_code
				LEFT JOIN 	work_flow_approval	AS 	wfa_staff	ON 	wfa_staff.work_flow_id = wf.work_flow_id
													   AND	wfa_staff.approver_type = 'EX_ACC_STAFF'
													   AND 	wfa_staff.action_date IS NOT NULL
				LEFT JOIN 	db_list_value_lang	AS 	l_verify	ON 	l_verify.company_code = wf.company_code 
													   AND 	l_verify.group_code = 'VerifyType'
													   AND 	l_verify.value = fed.verify_type 
													   AND 	l_verify.language_code = p_lin_id
		WHERE 	1=1
				AND	wf.work_flow_type_code = 'EX'
				AND	wf_stt.order_seq > 7 -- MORE THEN 'WAIT FOR APPROVE'
				AND	COALESCE(fed.is_receive_original_document, FALSE) = FALSE 
				AND	wf.company_code = p_ou_code
				AND COALESCE(wf.branch_code, '') = COALESCE(p_branch_code, wf.branch_code, '')
				AND COALESCE(wf.division_code, '') = COALESCE(p_cost_center_code, wf.division_code, '')
				AND	COALESCE(wf.requester_user_code, '') = COALESCE(p_requester_code, wf.requester_user_code, '')
				AND	COALESCE(fei.invoice_date ::DATE, '1970-01-01'::DATE) BETWEEN
																						 COALESCE(p_invoice_date_from::DATE, fei.invoice_date::DATE, '1970-01-01'::DATE)
																						 AND
																						 COALESCE(p_invoice_date_to::DATE, fei.invoice_date::DATE, '1970-01-01'::DATE)
				AND	COALESCE(wf.document_date::DATE, '1970-01-01'::DATE) BETWEEN
																		 COALESCE(p_doc_date_from::DATE, wf.document_date::DATE, '1970-01-01'::DATE)
																		 AND
																		 COALESCE(p_doc_date_to::DATE, wf.document_date::DATE, '1970-01-01'::DATE)
				AND	'X' = COALESCE(p_vendor_code, 'X')
				AND	COALESCE(wf.document_no, '') = COALESCE(p_doc_no, wf.document_no, '')
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
		UNION 
		SELECT 	get_company_code_name(p_lin_id, fem.company_code)							::CHARACTER VARYING AS f_company_name,
			    get_branch_code_name(p_lin_id, fem.branch_code )							::CHARACTER VARYING AS f_branch_name ,
			    current_timestamp 																				AS f_print_date,
				NULLIF(null , '')													::CHARACTER VARYING AS	f_invoice_no,
				NULLIF('OtherDocument', '')													::CHARACTER VARYING AS	f_invoice_type_code,
				NULLIF(lis_doc_ty_l.value_text, '')::CHARACTER VARYING AS	f_invoice_type_name ,
				to_char(fem.mileage_date  , 'dd/MM/yyyy')																				::CHARACTER VARYING AS 	f_invoice_date,
				NULLIF(null , '')																					::CHARACTER VARYING AS	f_invoice_desc,
				NULLIF(wf.document_no, '')																								::CHARACTER VARYING AS	f_document_no,
				to_char(wf.document_date, 'dd/MM/yyyy')																					::CHARACTER VARYING AS 	f_document_date,
				NULLIF(wf_stt_l.status_desc, '')																						::CHARACTER VARYING AS 	f_document_status,
				NULLIF(wf.approver_user_code, '')																						::CHARACTER VARYING AS 	f_approver_code,
				dbo.get_employee_name(p_lin_id, wf.company_code, wf.branch_code, wf.approver_user_code)								::CHARACTER VARYING AS 	f_approver_name,
		    	to_char(wfa.action_date, 'dd/MM/yyyy')																					::CHARACTER VARYING AS 	f_approve_date,
		    	COALESCE((current_timestamp::date - wfa.action_date::date), 0) 															::NUMERIC AS f_days_waiting,
			    wf.requester_user_code																									::CHARACTER VARYING AS 	f_requester_code,
			    dbo.get_employee_name(p_lin_id, wf.company_code, wf.branch_code, wf.requester_user_code )								::CHARACTER VARYING AS 	f_requester_name,
		    	l_verify.value_text																										::CHARACTER VARYING AS 	f_verify_type,
		    	CASE WHEN COALESCE(fed.is_receive_original_document, FALSE) = FALSE 
	    				THEN 	CASE 	WHEN p_lin_id = 'TH' 
		    							THEN N'รอนำส่ง'
		    							ELSE 'Waiting for delivery'
						    	END 
		    		 	ELSE 	CASE 	WHEN p_lin_id = 'TH' 
		    		 					THEN N'นำส่งแล้ว'
							   			ELSE 'Already delivered'
							    END 
    		  	END 																												::CHARACTER VARYING AS 	f_delivery_status,
			    COALESCE(wfa_staff.new_approver_code, wfa_staff.doa_approver_code) 														::CHARACTER VARYING AS 	f_staff_code,
			    dbo.get_employee_name(	p_lin_id, wf.company_code, wf.branch_code ,COALESCE(wfa_staff.new_approver_code, wfa_staff.doa_approver_code))																									::CHARACTER VARYING AS 	f_staff_name,
				''																														::CHARACTER VARYING AS f_vendor_code,
				null 																										::CHARACTER VARYING AS f_vendor_name,
			    null 																									::CHARACTER VARYING AS f_vendor_branch_code,
			    '' 																														::CHARACTER VARYING AS f_vendor_branch_name,
			    null 																													::CHARACTER VARYING AS f_vendor_tax_id,
			    femi.curr_amount * COALESCE(femi.exchange_rate ,1)  				 													::NUMERIC AS f_base_amount,
		    	0  																														::NUMERIC AS f_vat_amount,
		    	(femi.curr_amount * COALESCE(femi.exchange_rate ,1))																	::NUMERIC AS f_amount,
		    	0 																														::NUMERIC AS f_wht_amount,
		    	0					 																									::NUMERIC AS f_net_amount,
		    	null 																													::CHARACTER VARYING AS f_cri_vendor,
			    concat('mileage',femi.mileage_item_id)							::CHARACTER VARYING AS tabel
		FROM 	work_flow AS wf 
				LEFT JOIN fn_expense_document fed ON fed.work_flow_id  = wf.work_flow_id 
				inner JOIN fn_expense_mileage fem ON fem.expense_document_id = fed.expense_document_id 
				LEFT JOIN fn_expense_mileage_item femi ON femi.expense_mileage_id = fem.expense_mileage_id  
				LEFT JOIN db_list_value_lang AS	lis_doc_ty_l	ON	lis_doc_ty_l.company_code = fem.company_code 
														   AND	lis_doc_ty_l.group_code = 'AvailableDocument'
														   AND 	lis_doc_ty_l.value = 'OtherDocument'
														   AND	lis_doc_ty_l.language_code = p_lin_id
				LEFT JOIN db_doc_status	AS wf_stt 	ON	wf_stt.company_code = wf.company_code 
												   	AND wf_stt.status_value = wf.status
												   	AND wf_stt.table_name = 'FnExpenseDocument'
												   	AND wf_stt.column_name = 'Status'
				LEFT JOIN db_doc_status_lang AS wf_stt_l 	ON 	wf_stt_l.company_code = wf_stt.company_code 
													   		AND wf_stt_l.status_value = wf_stt.status_value
												       		AND wf_stt_l.table_name = 'FnExpenseDocument'
												       		AND wf_stt_l.column_name = 'Status'
												       		AND wf_stt_l.language_code = p_lin_id
		       	LEFT JOIN work_flow_approval AS	wfa	ON 	wfa.work_flow_id = wf.work_flow_id 
											   		AND	COALESCE(wfa.new_approver_code, wfa.doa_approver_code) = wf.approver_user_code
				LEFT JOIN 	work_flow_approval	AS 	wfa_staff	ON 	wfa_staff.work_flow_id = wf.work_flow_id
													   AND	wfa_staff.approver_type = 'EX_ACC_STAFF'
													   AND 	wfa_staff.action_date IS NOT NULL
				LEFT JOIN 	db_list_value_lang	AS 	l_verify	ON 	l_verify.company_code = wf.company_code 
													   AND 	l_verify.group_code = 'VerifyType'
													   AND 	l_verify.value = fed.verify_type 
													   AND 	l_verify.language_code = p_lin_id
		WHERE 	1=1
				AND	wf.work_flow_type_code = 'EX'
				AND	wf_stt.order_seq > 7 -- MORE THEN 'WAIT FOR APPROVE'
				AND	COALESCE(fed.is_receive_original_document, FALSE) = FALSE 
				AND	wf.company_code = p_ou_code
				AND COALESCE(wf.branch_code, '') = COALESCE(p_branch_code, wf.branch_code, '')
				AND COALESCE(wf.division_code, '') = COALESCE(p_cost_center_code, wf.division_code, '')
				AND	COALESCE(wf.requester_user_code, '') = COALESCE(p_requester_code, wf.requester_user_code, '')
				AND	COALESCE(fem.mileage_date ::DATE, '1970-01-01'::DATE) BETWEEN
																		 COALESCE(p_invoice_date_from::DATE, fem.mileage_date::DATE, '1970-01-01'::DATE)
																		 AND
																		 COALESCE(p_invoice_date_to::DATE, fem.mileage_date::DATE, '1970-01-01'::DATE)
				AND	COALESCE(wf.document_date::DATE, '1970-01-01'::DATE) BETWEEN
																		 COALESCE(p_doc_date_from::DATE, wf.document_date::DATE, '1970-01-01'::DATE)
																		 AND
																		 COALESCE(p_doc_date_to::DATE, wf.document_date::DATE, '1970-01-01'::DATE)
				AND	'X' = COALESCE(p_vendor_code, 'X')
				AND	COALESCE(wf.document_no, '') = COALESCE(p_doc_no, wf.document_no, '')
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
		UNION 
		SELECT 	get_company_code_name(p_lin_id, fep.company_code)							::CHARACTER VARYING AS f_company_name,
			    get_branch_code_name(p_lin_id, fep.branch_code )							::CHARACTER VARYING AS f_branch_name ,
			    current_timestamp 																				AS f_print_date,
				NULLIF(null , '')													::CHARACTER VARYING AS	f_invoice_no,
				NULLIF('OtherDocument', '')													::CHARACTER VARYING AS	f_invoice_type_code,
				NULLIF(lis_doc_ty_l.value_text, '')::CHARACTER VARYING AS	f_invoice_type_name ,
				null																				::CHARACTER VARYING AS 	f_invoice_date,
				NULLIF(null , '')																					::CHARACTER VARYING AS	f_invoice_desc,
				NULLIF(wf.document_no, '')																								::CHARACTER VARYING AS	f_document_no,
				to_char(wf.document_date, 'dd/MM/yyyy')																					::CHARACTER VARYING AS 	f_document_date,
				NULLIF(wf_stt_l.status_desc, '')																						::CHARACTER VARYING AS 	f_document_status,
				NULLIF(wf.approver_user_code, '')																						::CHARACTER VARYING AS 	f_approver_code,
				dbo.get_employee_name(p_lin_id, wf.company_code, wf.branch_code, wf.approver_user_code)								::CHARACTER VARYING AS 	f_approver_name,
		    	to_char(wfa.action_date, 'dd/MM/yyyy')																					::CHARACTER VARYING AS 	f_approve_date,
		    	COALESCE((current_timestamp::date - wfa.action_date::date), 0) 															::NUMERIC AS f_days_waiting,
			    wf.requester_user_code																									::CHARACTER VARYING AS 	f_requester_code,
			    dbo.get_employee_name(p_lin_id, wf.company_code, wf.branch_code, wf.requester_user_code )								::CHARACTER VARYING AS 	f_requester_name,
		    	l_verify.value_text																										::CHARACTER VARYING AS 	f_verify_type,
		    	CASE WHEN COALESCE(fed.is_receive_original_document, FALSE) = FALSE 
	    				THEN 	CASE 	WHEN p_lin_id = 'TH' 
		    							THEN N'รอนำส่ง'
		    							ELSE 'Waiting for delivery'
						    	END 
		    		 	ELSE 	CASE 	WHEN p_lin_id = 'TH' 
		    		 					THEN N'นำส่งแล้ว'
							   			ELSE 'Already delivered'
							    END 
    		  	END 																												::CHARACTER VARYING AS 	f_delivery_status,
			    COALESCE(wfa_staff.new_approver_code, wfa_staff.doa_approver_code) 														::CHARACTER VARYING AS 	f_staff_code,
			    dbo.get_employee_name(	p_lin_id, wf.company_code, wf.branch_code ,COALESCE(wfa_staff.new_approver_code, wfa_staff.doa_approver_code))																									::CHARACTER VARYING AS 	f_staff_name,
				''																														::CHARACTER VARYING AS f_vendor_code,
				null 																										::CHARACTER VARYING AS f_vendor_name,
			    null 																									::CHARACTER VARYING AS f_vendor_branch_code,
			    '' 																														::CHARACTER VARYING AS f_vendor_branch_name,
			    null 																													::CHARACTER VARYING AS f_vendor_tax_id,
			    fepi.curr_amount * COALESCE(fepi.exchange_rate ,1)  				 													::NUMERIC AS f_base_amount,
		    	0  																														::NUMERIC AS f_vat_amount,
		    	(fepi.curr_amount * COALESCE(fepi.exchange_rate ,1))																	::NUMERIC AS f_amount,
		    	0 																														::NUMERIC AS f_wht_amount,
		    	0					 																									::NUMERIC AS f_net_amount,
		    	null 																													::CHARACTER VARYING AS f_cri_vendor,
			    concat('perdiem',fepi.perdiem_item_id)							::CHARACTER VARYING AS tabel
		FROM 	work_flow AS wf 
				LEFT JOIN fn_expense_document fed ON fed.work_flow_id  = wf.work_flow_id 
				inner JOIN fn_expense_perdiem fep ON fep.expense_document_id = fed.expense_document_id 
				LEFT JOIN fn_expense_perdiem_item fepi ON fepi.expense_perdiem_id  = fep.expense_perdiem_id  
				LEFT JOIN db_list_value_lang AS	lis_doc_ty_l	ON	lis_doc_ty_l.company_code = fep.company_code 
														   AND	lis_doc_ty_l.group_code = 'AvailableDocument'
														   AND 	lis_doc_ty_l.value = 'OtherDocument'
														   AND	lis_doc_ty_l.language_code = p_lin_id
				LEFT JOIN db_doc_status	AS wf_stt 	ON	wf_stt.company_code = wf.company_code 
												   	AND wf_stt.status_value = wf.status
												   	AND wf_stt.table_name = 'FnExpenseDocument'
												   	AND wf_stt.column_name = 'Status'
				LEFT JOIN db_doc_status_lang AS wf_stt_l 	ON 	wf_stt_l.company_code = wf_stt.company_code 
													   		AND wf_stt_l.status_value = wf_stt.status_value
												       		AND wf_stt_l.table_name = 'FnExpenseDocument'
												       		AND wf_stt_l.column_name = 'Status'
												       		AND wf_stt_l.language_code = p_lin_id
		       	LEFT JOIN work_flow_approval AS	wfa	ON 	wfa.work_flow_id = wf.work_flow_id 
											   		AND	COALESCE(wfa.new_approver_code, wfa.doa_approver_code) = wf.approver_user_code
				LEFT JOIN 	work_flow_approval	AS 	wfa_staff	ON 	wfa_staff.work_flow_id = wf.work_flow_id
													   AND	wfa_staff.approver_type = 'EX_ACC_STAFF'
													   AND 	wfa_staff.action_date IS NOT NULL
				LEFT JOIN 	db_list_value_lang	AS 	l_verify	ON 	l_verify.company_code = wf.company_code 
													   AND 	l_verify.group_code = 'VerifyType'
													   AND 	l_verify.value = fed.verify_type 
													   AND 	l_verify.language_code = p_lin_id
		WHERE 	1=1
				AND	wf.work_flow_type_code = 'EX'
				AND	wf_stt.order_seq > 7 -- MORE THEN 'WAIT FOR APPROVE'
				AND	COALESCE(fed.is_receive_original_document, FALSE) = FALSE 
				AND	wf.company_code = p_ou_code
				AND COALESCE(wf.branch_code, '') = COALESCE(p_branch_code, wf.branch_code, '')
				AND COALESCE(wf.division_code, '') = COALESCE(p_cost_center_code, wf.division_code, '')
				AND	COALESCE(wf.requester_user_code, '') = COALESCE(p_requester_code, wf.requester_user_code, '')
--				AND	COALESCE(fep.date ::DATE, '1970-01-01'::DATE) BETWEEN
--																		 COALESCE(p_invoice_date_from::DATE, fep.date::DATE, '1970-01-01'::DATE)
--																		 AND
--																		 COALESCE(p_invoice_date_to::DATE, fep.date::DATE, '1970-01-01'::DATE)
				AND	COALESCE(wf.document_date::DATE, '1970-01-01'::DATE) BETWEEN
																		 COALESCE(p_doc_date_from::DATE, wf.document_date::DATE, '1970-01-01'::DATE)
																		 AND
																		 COALESCE(p_doc_date_to::DATE, wf.document_date::DATE, '1970-01-01'::DATE)
				AND	'X' = COALESCE(p_vendor_code, 'X')
				AND	COALESCE(wf.document_no, '') = COALESCE(p_doc_no, wf.document_no, '')
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
	UNION 
	SELECT 	get_company_code_name(p_lin_id, pdi.company_code)							::CHARACTER VARYING AS f_company_name,
			    get_branch_code_name(p_lin_id, pdi.branch_code )							::CHARACTER VARYING AS f_branch_name ,
			    current_timestamp 																				AS f_print_date,
				NULLIF(pdi.invoice_no , '')													::CHARACTER VARYING AS	f_invoice_no,
				NULLIF('OtherDocument', '')													::CHARACTER VARYING AS	f_invoice_type_code,
				NULLIF(lis_doc_ty_l.value_text, '')::CHARACTER VARYING AS	f_invoice_type_name ,
				to_char(pdi.invoice_date , 'dd/MM/yyyy')																				::CHARACTER VARYING AS 	f_invoice_date,
				NULLIF(pdi.invoice_description , '')																					::CHARACTER VARYING AS	f_invoice_desc,
				NULLIF(wf.document_no, '')																								::CHARACTER VARYING AS	f_document_no,
				to_char(wf.document_date, 'dd/MM/yyyy')																					::CHARACTER VARYING AS 	f_document_date,
				NULLIF(wf_stt_l.status_desc, '')																						::CHARACTER VARYING AS 	f_document_status,
				NULLIF(wf.approver_user_code, '')																						::CHARACTER VARYING AS 	f_approver_code,
				dbo.get_employee_name(p_lin_id, wf.company_code, wf.branch_code, wf.approver_user_code)								::CHARACTER VARYING AS 	f_approver_name,
		    	to_char(wfa.action_date, 'dd/MM/yyyy')																					::CHARACTER VARYING AS 	f_approve_date,
		    	COALESCE((current_timestamp::date - wfa.action_date::date), 0) 															::NUMERIC AS f_days_waiting,
			    wf.requester_user_code																									::CHARACTER VARYING AS 	f_requester_code,
			    dbo.get_employee_name(p_lin_id, wf.company_code, wf.branch_code, wf.requester_user_code )								::CHARACTER VARYING AS 	f_requester_name,
		    	l_verify.value_text																										::CHARACTER VARYING AS 	f_verify_type,
		    	CASE WHEN COALESCE(pd.is_receive_original_document, FALSE) = FALSE 
	    				THEN 	CASE 	WHEN p_lin_id = 'TH' 
		    							THEN N'รอนำส่ง'
		    							ELSE 'Waiting for delivery'
						    	END 
		    		 	ELSE 	CASE 	WHEN p_lin_id = 'TH' 
		    		 					THEN N'นำส่งแล้ว'
							   			ELSE 'Already delivered'
							    END 
    		  	END 																												::CHARACTER VARYING AS 	f_delivery_status,
			    COALESCE(wfa_staff.new_approver_code, wfa_staff.doa_approver_code) 														::CHARACTER VARYING AS 	f_staff_code,
			    dbo.get_employee_name(	p_lin_id, wf.company_code, wf.branch_code ,COALESCE(wfa_staff.new_approver_code, wfa_staff.doa_approver_code))																									::CHARACTER VARYING AS 	f_staff_name,
				''																														::CHARACTER VARYING AS f_vendor_code,
				pdi.vendor_name 																										::CHARACTER VARYING AS f_vendor_name,
			    pdi.vendor_branch_code 																									::CHARACTER VARYING AS f_vendor_branch_code,
			    '' 																														::CHARACTER VARYING AS f_vendor_branch_name,
			    pdi.vendor_tax_id 																										::CHARACTER VARYING AS f_vendor_tax_id,
			    pdi.base_amount_local  				 																					::NUMERIC AS f_base_amount,
		    	pdi.vat_amount_local  																									::NUMERIC AS f_vat_amount,
		    	pdi.total_amount_local 																									::NUMERIC AS f_amount,
		    	pdi.wht_amount_local 																									::NUMERIC AS f_wht_amount,
		    	pdi.net_amount_local  																									::NUMERIC AS f_net_amount,
		    	null 																													::CHARACTER VARYING AS f_cri_vendor,
			    concat('PcDocinvoice',pdi.pc_document_invoice_id)							::CHARACTER VARYING AS tabel
		FROM 	work_flow AS wf 
				LEFT JOIN pc_document pd ON pd.work_flow_id  = wf.work_flow_id 
				inner JOIN pc_document_invoice pdi ON pdi.pc_document_id = pd.pc_document_id  
				LEFT JOIN db_list_value_lang AS	lis_doc_ty_l	ON	lis_doc_ty_l.company_code = pdi.company_code 
														   AND	lis_doc_ty_l.group_code = 'AvailableDocument'
														   AND 	lis_doc_ty_l.value = 'OtherDocument'
														   AND	lis_doc_ty_l.language_code = p_lin_id
				LEFT JOIN db_doc_status	AS wf_stt 	ON	wf_stt.company_code = wf.company_code 
												   	AND wf_stt.status_value = wf.status
												   	AND wf_stt.table_name = 'FnExpenseDocument'
												   	AND wf_stt.column_name = 'Status'
				LEFT JOIN db_doc_status_lang AS wf_stt_l 	ON 	wf_stt_l.company_code = wf_stt.company_code 
													   		AND wf_stt_l.status_value = wf_stt.status_value
												       		AND wf_stt_l.table_name = 'FnExpenseDocument'
												       		AND wf_stt_l.column_name = 'Status'
												       		AND wf_stt_l.language_code = p_lin_id
		       	LEFT JOIN work_flow_approval AS	wfa	ON 	wfa.work_flow_id = wf.work_flow_id 
											   		AND	COALESCE(wfa.new_approver_code, wfa.doa_approver_code) = wf.approver_user_code
				LEFT JOIN 	work_flow_approval	AS 	wfa_staff	ON 	wfa_staff.work_flow_id = wf.work_flow_id
													   AND	wfa_staff.approver_type = 'EX_ACC_STAFF'
													   AND 	wfa_staff.action_date IS NOT NULL
				LEFT JOIN 	db_list_value_lang	AS 	l_verify	ON 	l_verify.company_code = wf.company_code 
													   AND 	l_verify.group_code = 'VerifyType'
													   AND 	l_verify.value = pd.verify_type 
													   AND 	l_verify.language_code = p_lin_id
		WHERE 	1=1
				AND	wf.work_flow_sub_type_code = 'PCQ'
				AND	wf_stt.order_seq > 7 -- MORE THEN 'WAIT FOR APPROVE'
				AND	COALESCE(pd.is_receive_original_document, FALSE) = FALSE 
				AND	wf.company_code = p_ou_code
				AND COALESCE(wf.branch_code, '') = COALESCE(p_branch_code, wf.branch_code, '')
				AND COALESCE(wf.division_code, '') = COALESCE(p_cost_center_code, wf.division_code, '')
				AND	COALESCE(wf.requester_user_code, '') = COALESCE(p_requester_code, wf.requester_user_code, '')
				AND	COALESCE(pdi.invoice_date ::DATE, '1970-01-01'::DATE) BETWEEN
																						 COALESCE(p_invoice_date_from::DATE, pdi.invoice_date::DATE, '1970-01-01'::DATE)
																						 AND
																						 COALESCE(p_invoice_date_to::DATE, pdi.invoice_date::DATE, '1970-01-01'::DATE)
				AND	COALESCE(wf.document_date::DATE, '1970-01-01'::DATE) BETWEEN
																		 COALESCE(p_doc_date_from::DATE, wf.document_date::DATE, '1970-01-01'::DATE)
																		 AND
																		 COALESCE(p_doc_date_to::DATE, wf.document_date::DATE, '1970-01-01'::DATE)
				AND	'X' = COALESCE(p_vendor_code, 'X')
				AND	COALESCE(wf.document_no, '') = COALESCE(p_doc_no, wf.document_no, '')
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
		UNION 
		SELECT 	get_company_code_name(p_lin_id, pdm.company_code)							::CHARACTER VARYING AS f_company_name,
			    get_branch_code_name(p_lin_id, pdm.branch_code )							::CHARACTER VARYING AS f_branch_name ,
			    current_timestamp 																				AS f_print_date,
				NULLIF(null , '')													::CHARACTER VARYING AS	f_invoice_no,
				NULLIF('OtherDocument', '')													::CHARACTER VARYING AS	f_invoice_type_code,
				NULLIF(lis_doc_ty_l.value_text, '')::CHARACTER VARYING AS	f_invoice_type_name ,
				to_char(pdm.mileage_date  , 'dd/MM/yyyy')																				::CHARACTER VARYING AS 	f_invoice_date,
				NULLIF(null , '')																					::CHARACTER VARYING AS	f_invoice_desc,
				NULLIF(wf.document_no, '')																								::CHARACTER VARYING AS	f_document_no,
				to_char(wf.document_date, 'dd/MM/yyyy')																					::CHARACTER VARYING AS 	f_document_date,
				NULLIF(wf_stt_l.status_desc, '')																						::CHARACTER VARYING AS 	f_document_status,
				NULLIF(wf.approver_user_code, '')																						::CHARACTER VARYING AS 	f_approver_code,
				dbo.get_employee_name(p_lin_id, wf.company_code, wf.branch_code, wf.approver_user_code)								::CHARACTER VARYING AS 	f_approver_name,
		    	to_char(wfa.action_date, 'dd/MM/yyyy')																					::CHARACTER VARYING AS 	f_approve_date,
		    	COALESCE((current_timestamp::date - wfa.action_date::date), 0) 															::NUMERIC AS f_days_waiting,
			    wf.requester_user_code																									::CHARACTER VARYING AS 	f_requester_code,
			    dbo.get_employee_name(p_lin_id, wf.company_code, wf.branch_code, wf.requester_user_code )								::CHARACTER VARYING AS 	f_requester_name,
		    	l_verify.value_text																										::CHARACTER VARYING AS 	f_verify_type,
		    	CASE WHEN COALESCE(pd.is_receive_original_document, FALSE) = FALSE 
	    				THEN 	CASE 	WHEN p_lin_id = 'TH' 
		    							THEN N'รอนำส่ง'
		    							ELSE 'Waiting for delivery'
						    	END 
		    		 	ELSE 	CASE 	WHEN p_lin_id = 'TH' 
		    		 					THEN N'นำส่งแล้ว'
							   			ELSE 'Already delivered'
							    END 
    		  	END 																												::CHARACTER VARYING AS 	f_delivery_status,
			    COALESCE(wfa_staff.new_approver_code, wfa_staff.doa_approver_code) 														::CHARACTER VARYING AS 	f_staff_code,
			    dbo.get_employee_name(	p_lin_id, wf.company_code, wf.branch_code ,COALESCE(wfa_staff.new_approver_code, wfa_staff.doa_approver_code))																									::CHARACTER VARYING AS 	f_staff_name,
				''																														::CHARACTER VARYING AS f_vendor_code,
				null 																										::CHARACTER VARYING AS f_vendor_name,
			    null 																									::CHARACTER VARYING AS f_vendor_branch_code,
			    '' 																														::CHARACTER VARYING AS f_vendor_branch_name,
			    null 																													::CHARACTER VARYING AS f_vendor_tax_id,
			    pdmi.curr_amount * COALESCE(pdmi.exchange_rate ,1)  				 													::NUMERIC AS f_base_amount,
		    	0  																														::NUMERIC AS f_vat_amount,
		    	(pdmi.curr_amount * COALESCE(pdmi.exchange_rate ,1))																	::NUMERIC AS f_amount,
		    	0 																														::NUMERIC AS f_wht_amount,
		    	0					 																									::NUMERIC AS f_net_amount,
		    	null 																													::CHARACTER VARYING AS f_cri_vendor,
			    concat('PcDocmileage',pdmi.pc_document_mileage_item_id)							::CHARACTER VARYING AS tabel
		FROM 	work_flow AS wf 
				LEFT JOIN pc_document pd ON pd.work_flow_id  = wf.work_flow_id 
				inner JOIN pc_document_mileage pdm ON pdm.pc_document_id = pd.pc_document_id 
				LEFT JOIN pc_document_mileage_item pdmi ON pdmi.pc_document_mileage_id = pdm.pc_document_mileage_id  
				LEFT JOIN db_list_value_lang AS	lis_doc_ty_l	ON	lis_doc_ty_l.company_code = pdm.company_code 
														   AND	lis_doc_ty_l.group_code = 'AvailableDocument'
														   AND 	lis_doc_ty_l.value = 'OtherDocument'
														   AND	lis_doc_ty_l.language_code = p_lin_id
				LEFT JOIN db_doc_status	AS wf_stt 	ON	wf_stt.company_code = wf.company_code 
												   	AND wf_stt.status_value = wf.status
												   	AND wf_stt.table_name = 'FnExpenseDocument'
												   	AND wf_stt.column_name = 'Status'
				LEFT JOIN db_doc_status_lang AS wf_stt_l 	ON 	wf_stt_l.company_code = wf_stt.company_code 
													   		AND wf_stt_l.status_value = wf_stt.status_value
												       		AND wf_stt_l.table_name = 'FnExpenseDocument'
												       		AND wf_stt_l.column_name = 'Status'
												       		AND wf_stt_l.language_code = p_lin_id
		       	LEFT JOIN work_flow_approval AS	wfa	ON 	wfa.work_flow_id = wf.work_flow_id 
											   		AND	COALESCE(wfa.new_approver_code, wfa.doa_approver_code) = wf.approver_user_code
				LEFT JOIN 	work_flow_approval	AS 	wfa_staff	ON 	wfa_staff.work_flow_id = wf.work_flow_id
													   AND	wfa_staff.approver_type = 'EX_ACC_STAFF'
													   AND 	wfa_staff.action_date IS NOT NULL
				LEFT JOIN 	db_list_value_lang	AS 	l_verify	ON 	l_verify.company_code = wf.company_code 
													   AND 	l_verify.group_code = 'VerifyType'
													   AND 	l_verify.value = pd.verify_type 
													   AND 	l_verify.language_code = p_lin_id
		WHERE 	1=1
				AND	wf.work_flow_sub_type_code = 'PCQ'
				AND	wf_stt.order_seq > 7 -- MORE THEN 'WAIT FOR APPROVE'
				AND	COALESCE(pd.is_receive_original_document, FALSE) = FALSE 
				AND	wf.company_code = p_ou_code
				AND COALESCE(wf.branch_code, '') = COALESCE(p_branch_code, wf.branch_code, '')
				AND COALESCE(wf.division_code, '') = COALESCE(p_cost_center_code, wf.division_code, '')
				AND	COALESCE(wf.requester_user_code, '') = COALESCE(p_requester_code, wf.requester_user_code, '')
				AND	COALESCE(pdm.mileage_date ::DATE, '1970-01-01'::DATE) BETWEEN
																		 COALESCE(p_invoice_date_from::DATE, pdm.mileage_date::DATE, '1970-01-01'::DATE)
																		 AND
																		 COALESCE(p_invoice_date_to::DATE, pdm.mileage_date::DATE, '1970-01-01'::DATE)
				AND	COALESCE(wf.document_date::DATE, '1970-01-01'::DATE) BETWEEN
																		 COALESCE(p_doc_date_from::DATE, wf.document_date::DATE, '1970-01-01'::DATE)
																		 AND
																		 COALESCE(p_doc_date_to::DATE, wf.document_date::DATE, '1970-01-01'::DATE)
				AND	'X' = COALESCE(p_vendor_code, 'X')
				AND	COALESCE(wf.document_no, '') = COALESCE(p_doc_no, wf.document_no, '')
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
	-- End query
	;END;
$function$
;
