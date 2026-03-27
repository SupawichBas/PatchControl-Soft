drop function report_smexrp02;

CREATE OR REPLACE FUNCTION dbo.report_smexrp02(user_company_code character varying, p_lin_id character varying, p_company_code character varying, p_branch_code character varying, p_division_code character varying, p_requester_user_code character varying, p_doc_no character varying, p_s_date character varying, p_e_date character varying, p_s_approve_date character varying, p_e_approve_date character varying, user_login integer, p_status character varying, p_checkbox_1 boolean, p_checkbox_2 boolean, p_checkbox_3 boolean, p_checkbox_4 boolean, p_checkbox_5 boolean)
 RETURNS TABLE(h_company character varying, p_companybranch character varying, p_division character varying, p_emp character varying, p_document_no character varying, p_status_name character varying, work_flow_id integer, division_code character varying, division_name character varying, document_date character varying, document_no character varying, requester_user_code character varying, full_name character varying, subject character varying, l_case1 character varying, l_case2 character varying, l_case3 character varying, l_case4 character varying, case1 numeric, case2 numeric, case3 numeric, case4 numeric, other numeric, total_expense_amount numeric, status_value character varying, status_name character varying, work_flow_type_code character varying, navigatereport character varying)
 LANGUAGE plpgsql
AS $function$ 
declare UserCompany varchar(20);
declare UserCode varchar(20);
declare CheckPrivilege varchar(1);
declare checkbox_1 varchar(50);
declare checkbox_2 varchar(50);
declare checkbox_3 varchar(50);
declare checkbox_4 varchar(50);
begin
	UserCompany = get_user_company_code(user_login);
	UserCode = get_user_code(user_login);
	CheckPrivilege = dbo.get_user_privilege(UserCompany, user_login);
	checkbox_1 = (SELECT dbo.get_configuration_value('DB', 'Checkbox_1_ExpenseGroupSMEXRP02'));
	checkbox_2 = (SELECT dbo.get_configuration_value('DB', 'Checkbox_2_ExpenseGroupSMEXRP02'));
	checkbox_3 = (SELECT dbo.get_configuration_value('DB', 'Checkbox_3_ExpenseGroupSMEXRP02'));
	checkbox_4 = (SELECT dbo.get_configuration_value('DB', 'Checkbox_4_ExpenseGroupSMEXRP02'));
    RETURN QUERY
select * from (
select (concat(get_company_code_name(p_lin_id, p_company_code),' / ',
	get_branch_code_name(p_lin_id, p_branch_code)))::varchar  as H_Company,
	get_companycode_branchcode(p_lin_id, p_company_code,p_branch_code)::varchar  as P_CompanyBranch,
	coalesce (dbo.get_division_name(p_lin_id, p_company_code, p_branch_code, p_division_code), dbo.get_report_label_name('SMEXRP02', 'ALL', p_lin_id))::varchar  as P_Division,
	coalesce (dbo.get_employee_name(p_lin_id, p_company_code, p_branch_code, p_requester_user_code), dbo.get_report_label_name('SMEXRP02', 'ALL', p_lin_id))::varchar  as P_Emp,
  	coalesce(p_doc_no,dbo.get_report_label_name('SMEXRP02', 'ALL', p_lin_id)) as P_document_no,
--	coalesce (dbo.get_document_sub_type(p_lin_id, p_sub_type_code), dbo.get_report_label_name('SMEXRP02', 'ALL', p_lin_id))::varchar  as P_Document_Sub_Type,
	coalesce (dbo.get_status_name(p_lin_id, p_company_code, p_status), dbo.get_report_label_name('SMEXRP02', 'ALL', p_lin_id))::varchar  as P_Status_Name,
	wf.work_flow_id::integer work_flow_id,
	wf.division_code::varchar division_code,
	dol.organization_name::varchar Division_Name,
	to_char(wf.document_date , 'dd/MM/yyyy')::varchar document_date,
	wf.document_no::varchar document_no,
	wf.requester_user_code::varchar requester_user_code,
	concat(del.first_name ,' ',del.last_name)::varchar as full_name,
	wf.subject::varchar subject,
	dbo.get_db_income_expense_group_lang(wf.company_code,checkbox_1, p_lin_id)::varchar L_Case1,
	dbo.get_db_income_expense_group_lang(wf.company_code,checkbox_2, p_lin_id)::varchar L_Case2,
	dbo.get_db_income_expense_group_lang(wf.company_code,checkbox_3, p_lin_id)::varchar L_Case3,
	dbo.get_db_income_expense_group_lang(wf.company_code,checkbox_4, p_lin_id)::varchar L_Case4,
	coalesce(dbo.get_expense_amount(wf.work_flow_id , checkbox_1),0)::numeric as Case1,
	coalesce(dbo.get_expense_amount(wf.work_flow_id , checkbox_2),0)::numeric as Case2,
	coalesce(dbo.get_expense_amount(wf.work_flow_id , checkbox_3),0)::numeric as Case3,
	coalesce(dbo.get_expense_amount(wf.work_flow_id , checkbox_4),0)::numeric as Case4,
	ROUND(
	(coalesce(fed.total_expense_amount,0)-(
	coalesce(dbo.get_expense_amount(wf.work_flow_id , checkbox_1),0)+
	coalesce(dbo.get_expense_amount(wf.work_flow_id , checkbox_2),0)+
	coalesce(dbo.get_expense_amount(wf.work_flow_id , checkbox_3),0)+
	coalesce(dbo.get_expense_amount(wf.work_flow_id , checkbox_4),0)
	)), 2
	)::numeric as Other,
	coalesce(fed.total_expense_amount,0)::numeric as total_expense_amount,
	wf.status ::varchar status_value,
	dsl.status_desc::varchar status_name,
	wf.work_flow_type_code::varchar as work_flow_type_code,
	concat(dbo.get_su_system_configuration('NavigateReport', 'NavigateReport'),wf.work_flow_id,'/',wf.work_flow_type_code)::varchar as NavigateReport
from work_flow wf 
	JOIN fn_expense_document fed on fed.work_flow_id = wf.work_flow_id 
--    left join fn_expense_invoice fei on fei.expense_document_id = fed.expense_document_id 
--    left join fn_expense_invoice_item feii on feii.expense_invoice_id = fei.expense_invoice_id 
--    	left join db_income_expense income_expense_invoice_item on income_expense_invoice_item.expense_code = feii.expense_code
--    left JOIN fn_expense_mileage fem on fem.expense_document_id = fed.expense_document_id
--    	left join db_income_expense income_expense_mileage on income_expense_mileage.expense_code = fem.expense_code 
--    left JOIN fn_expense_perdiem fep on fep.expense_document_id = fed.expense_document_id
--    	left join db_income_expense income_expense_perdiemon on income_expense_perdiemon.expense_code = fep.expense_code 
	join db_organization_lang dol on dol.organization_code = wf.division_code 
			and dol.language_code = p_lin_id
	LEFT JOIN db_employee de ON de.emp_code = wf.requester_user_code
	    LEFT JOIN db_employee_lang del ON de.emp_code = del.emp_code AND del.language_code = p_lin_id
	LEFT JOIN db_position_lang dpl ON dpl.position_code = de.position_code AND dpl.language_code = p_lin_id 
		and dpl.company_code = de.company_code 
	JOIN db_doc_status dds ON dds.status_value = wf.status
		and dds.company_code = wf.company_code 
		and dds.table_name = 'Document'
		and dds.column_name = 'Status'
	JOIN db_doc_status_lang dsl ON dsl.status_value = dds.status_value
	    AND dsl.company_code = wf.company_code 
	    AND dsl.table_name = 'Document'
	    AND dsl.column_name = 'Status'
	    AND dsl.language_code = p_lin_id --'TH'
where wf.company_code = p_company_code--'SS'
	and wf.branch_code = p_branch_code--'NSC'
	and wf.division_code = coalesce (p_division_code, wf.division_code)--'NSC001'
	and wf.requester_user_code = coalesce (p_requester_user_code, wf.requester_user_code)--'63025'
	and wf.document_no = coalesce(p_doc_no,wf.document_no)--'SSNSC-EX24010047'
	and	 CAST(wf.document_date AS DATE)
		between coalesce(to_date(p_s_date,'DD/MM/YYYY') , to_date('01/01/0001','dd/mm/yyyy'))
		and coalesce(to_date(p_e_date,'DD/MM/YYYY') , to_date('31/12/9999','dd/mm/yyyy'))
	and	 CAST(wf.approve_date AS DATE)
		between coalesce(to_date(p_s_approve_date,'DD/MM/YYYY') , to_date('01/01/0001','dd/mm/yyyy'))
		and coalesce(to_date(p_e_approve_date,'DD/MM/YYYY') , to_date('31/12/9999','dd/mm/yyyy'))
--	and wf.work_flow_sub_type_code = coalesce (p_sub_type_code, wf.work_flow_sub_type_code)--'EXP'
	and wf.status != 'Cancel'
	and wf.status = coalesce (p_status, wf.status)
	AND ( EXISTS (select get_exists_on_report(wf.work_flow_id, UserCode))
			or wf.requester_user_code = UserCode 
			or wf.creator_user_code = UserCode
			)	-- AND (
	-- 	    (
	-- 	    CheckPrivilege = '1'
	-- 	    and
	-- 	    EXISTS (
	--             SELECT 'x' FROM su_user_organization suo
	--             WHERE suo.user_id = user_login --214
	--             AND suo.company_code = wf.company_code
	--             and suo.profile_type = 'Document'
	--         		))
	-- 	    OR EXISTS (
	-- 	        SELECT 'x' FROM su_user_authorized sua 
	-- 	        WHERE sua.authorized_emp_code = de.emp_code
	-- 	        AND sua.emp_code = UserCode
	-- 	    		) 
	-- 	    OR (wf.requester_user_code = UserCode 
	-- 	    OR wf.creator_user_code = UserCode )
	-- 		)
	and (
			(p_checkbox_1 = true 
				and coalesce(dbo.get_expense_amount(wf.work_flow_id ,checkbox_1),0) > 0
			)
			or 
			(p_checkbox_2 = true 
				and coalesce(dbo.get_expense_amount(wf.work_flow_id,checkbox_2),0) > 0
			)
			or 
			(p_checkbox_3 = true 
			and coalesce(dbo.get_expense_amount(wf.work_flow_id,checkbox_3),0) > 0
			)
			or 
			(p_checkbox_4 = true 
			and coalesce(dbo.get_expense_amount(wf.work_flow_id,checkbox_4),0) > 0
			)
			or (p_checkbox_5 = true and (coalesce(fed.total_expense_amount,0)-
							(coalesce(dbo.get_expense_amount(wf.work_flow_id ,checkbox_1),0)+
							coalesce(dbo.get_expense_amount(wf.work_flow_id,checkbox_2),0)+
							coalesce(dbo.get_expense_amount(wf.work_flow_id,checkbox_3),0)+
							coalesce(dbo.get_expense_amount(wf.work_flow_id,checkbox_4),0))
										)>0)
		)
UNION ALL
select (concat(get_company_code_name(p_lin_id, p_company_code),' / ',
	get_branch_code_name(p_lin_id, p_branch_code)))::varchar  as H_Company,
	get_companycode_branchcode(p_lin_id, p_company_code,p_branch_code)::varchar  as P_CompanyBranch,
	coalesce (dbo.get_division_name(p_lin_id, p_company_code, p_branch_code, p_division_code), dbo.get_report_label_name('SMEXRP02', 'ALL', p_lin_id))::varchar  as P_Division,
	coalesce (dbo.get_employee_name(p_lin_id, p_company_code, p_branch_code, p_requester_user_code), dbo.get_report_label_name('SMEXRP02', 'ALL', p_lin_id))::varchar  as P_Emp,
  	coalesce(p_doc_no,dbo.get_report_label_name('SMEXRP02', 'ALL', p_lin_id)) as P_document_no,
--	coalesce (dbo.get_document_sub_type(p_lin_id, p_sub_type_code), dbo.get_report_label_name('SMEXRP02', 'ALL', p_lin_id))::varchar  as P_Document_Sub_Type,
	coalesce (dbo.get_status_name(p_lin_id, p_company_code, p_status), dbo.get_report_label_name('SMEXRP02', 'ALL', p_lin_id))::varchar  as P_Status_Name,
	wf.work_flow_id::integer work_flow_id,
	wf.division_code::varchar division_code,
	dol.organization_name::varchar Division_Name,
	to_char(wf.document_date , 'dd/MM/yyyy')::varchar document_date,
	wf.document_no::varchar document_no,
	wf.requester_user_code::varchar requester_user_code,
	concat(del.first_name ,' ',del.last_name)::varchar as full_name,
	wf.subject::varchar subject,
	dbo.get_db_income_expense_group_lang(wf.company_code,checkbox_1, p_lin_id)::varchar L_Case1,
	dbo.get_db_income_expense_group_lang(wf.company_code,checkbox_2, p_lin_id)::varchar L_Case2,
	dbo.get_db_income_expense_group_lang(wf.company_code,checkbox_3, p_lin_id)::varchar L_Case3,
	dbo.get_db_income_expense_group_lang(wf.company_code,checkbox_4, p_lin_id)::varchar L_Case4,
	coalesce(dbo.get_expense_amount(wf.work_flow_id , checkbox_1),0)::numeric as Case1,
	coalesce(dbo.get_expense_amount(wf.work_flow_id , checkbox_2),0)::numeric as Case2,
	coalesce(dbo.get_expense_amount(wf.work_flow_id , checkbox_3),0)::numeric as Case3,
	coalesce(dbo.get_expense_amount(wf.work_flow_id , checkbox_4),0)::numeric as Case4,
	ROUND(
	(coalesce(pd.pcq_total_amount,0)-(
	coalesce(dbo.get_expense_amount(wf.work_flow_id , checkbox_1),0)+
	coalesce(dbo.get_expense_amount(wf.work_flow_id , checkbox_2),0)+
	coalesce(dbo.get_expense_amount(wf.work_flow_id , checkbox_3),0)+
	coalesce(dbo.get_expense_amount(wf.work_flow_id , checkbox_4),0)
	)), 2
	)::numeric as Other,
	coalesce(pd.pcq_total_amount,0)::numeric as total_expense_amount,
	wf.status ::varchar status_value,
	dsl.status_desc::varchar status_name,
	wf.work_flow_type_code::varchar as work_flow_type_code,
	concat(dbo.get_su_system_configuration('NavigateReport', 'NavigateReport'),wf.work_flow_id,'/',wf.work_flow_type_code)::varchar as NavigateReport
from work_flow wf 
	JOIN pc_document pd on pd.work_flow_id = wf.work_flow_id
	join db_organization_lang dol on dol.organization_code = wf.division_code 
			and dol.language_code = p_lin_id
	LEFT JOIN db_employee de ON de.emp_code = wf.requester_user_code
	    LEFT JOIN db_employee_lang del ON de.emp_code = del.emp_code AND del.language_code = p_lin_id
	LEFT JOIN db_position_lang dpl ON dpl.position_code = de.position_code AND dpl.language_code = p_lin_id 
		and dpl.company_code = de.company_code 
	JOIN db_doc_status dds ON dds.status_value = wf.status
		and dds.company_code = wf.company_code 
		and dds.table_name = 'Document'
		and dds.column_name = 'Status'
	JOIN db_doc_status_lang dsl ON dsl.status_value = dds.status_value
	    AND dsl.company_code = wf.company_code 
	    AND dsl.table_name = 'Document'
	    AND dsl.column_name = 'Status'
	    AND dsl.language_code = p_lin_id --'TH'
where wf.company_code = p_company_code--'SS'
	and wf.branch_code = p_branch_code--'NSC'
	and wf.division_code = coalesce (p_division_code, wf.division_code)--'NSC001'
	and wf.requester_user_code = coalesce (p_requester_user_code, wf.requester_user_code)--'63025'
	and wf.document_no = coalesce(p_doc_no,wf.document_no)--'SSNSC-EX24010047'
	and	 CAST(wf.document_date AS DATE)
		between coalesce(to_date(p_s_date,'DD/MM/YYYY') , to_date('01/01/0001','dd/mm/yyyy'))
		and coalesce(to_date(p_e_date,'DD/MM/YYYY') , to_date('31/12/9999','dd/mm/yyyy'))
	and	 CAST(wf.approve_date AS DATE)
		between coalesce(to_date(p_s_approve_date,'DD/MM/YYYY') , to_date('01/01/0001','dd/mm/yyyy'))
		and coalesce(to_date(p_e_approve_date,'DD/MM/YYYY') , to_date('31/12/9999','dd/mm/yyyy'))
	and wf.status != 'Cancel'
	and wf.work_flow_sub_type_code = 'PCQ'
	and wf.status = coalesce (p_status, wf.status)
	AND ( EXISTS (select get_exists_on_report(wf.work_flow_id, UserCode))
			or wf.requester_user_code = UserCode 
			or wf.creator_user_code = UserCode
			)
	-- AND (
	-- 	    (
	-- 	    CheckPrivilege = '1'
	-- 	    and
	-- 	    EXISTS (
	--             SELECT 'x' FROM su_user_organization suo
	--             WHERE suo.user_id = user_login --214
	--             AND suo.company_code = wf.company_code
	--             and suo.profile_type = 'Document'
	--         		))
	-- 	    OR EXISTS (
	-- 	        SELECT 'x' FROM su_user_authorized sua 
	-- 	        WHERE sua.authorized_emp_code = de.emp_code
	-- 	        AND sua.emp_code = UserCode
	-- 	    		) 
	-- 	    OR (wf.requester_user_code = UserCode 
	-- 	    OR wf.creator_user_code = UserCode )
	-- 		)
	and (
			(p_checkbox_1 = true 
				and coalesce(dbo.get_expense_amount(wf.work_flow_id ,checkbox_1),0) > 0
			)
			or 
			(p_checkbox_2 = true 
				and coalesce(dbo.get_expense_amount(wf.work_flow_id,checkbox_2),0) > 0
			)
			or 
			(p_checkbox_3 = true 
			and coalesce(dbo.get_expense_amount(wf.work_flow_id,checkbox_3),0) > 0
			)
			or 
			(p_checkbox_4 = true 
			and coalesce(dbo.get_expense_amount(wf.work_flow_id,checkbox_4),0) > 0
			)
			or (p_checkbox_5 = true and (coalesce(pd.pcq_total_amount,0)-
							(coalesce(dbo.get_expense_amount(wf.work_flow_id ,checkbox_1),0)+
							coalesce(dbo.get_expense_amount(wf.work_flow_id,checkbox_2),0)+
							coalesce(dbo.get_expense_amount(wf.work_flow_id,checkbox_3),0)+
							coalesce(dbo.get_expense_amount(wf.work_flow_id,checkbox_4),0))
										)>0)
		)
) var
ORDER BY var.division_code,TO_DATE(var.document_date, 'DD/MM/YYYY'),var.document_no;
END;
$function$
;
