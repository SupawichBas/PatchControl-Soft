drop function report_smavrp02;

CREATE OR REPLACE FUNCTION dbo.report_smavrp02(user_company_code character varying, p_lin_id character varying, p_company_code character varying, p_branch_code character varying, p_division_code character varying, p_requester_user_code character varying, p_fix_av_doc_no character varying, p_fix_s_date character varying, p_fix_e_date character varying, p_ex_s_date character varying, p_ex_e_date character varying, user_login integer)
 RETURNS TABLE(h_company character varying, p_companybranch character varying, p_division character varying, p_emp character varying, p_document_no character varying, document_no character varying, work_flow_id integer, work_flow_type_code character varying, av_start_date character varying, av_due_date character varying, localamountofapprove numeric, navigatereport character varying)
 LANGUAGE plpgsql
AS $function$ 
declare UserCompany varchar(20);
declare UserCode varchar(20);
declare CheckPrivilege varchar(1);
declare WorkFlowSubTypeCode varchar(5);
begin
	UserCompany = get_user_company_code(user_login);
	UserCode = get_user_code(user_login);
	CheckPrivilege = dbo.get_user_privilege(UserCompany, user_login);
	WorkFlowSubTypeCode = 'AVF';
    RETURN QUERY
select temp_data.* from 
(
	--fn_expense_invoice --fn_expense_invoice_item
	select (concat(get_company_code_name(p_lin_id, p_company_code),' / ',
	get_branch_code_name(p_lin_id, p_branch_code)))::varchar  as H_Company,
	get_companycode_branchcode(p_lin_id, p_company_code,p_branch_code)::varchar as P_CompanyBranch
	,dbo.get_division_name(p_lin_id, p_company_code, p_branch_code, wf.division_code)::varchar  as P_Division
	,dbo.get_employee_name(p_lin_id, p_company_code, p_branch_code, wf.requester_user_code)::varchar  as P_Emp
	,coalesce(p_fix_av_doc_no,dbo.get_report_label_name('SMEXRP02', 'ALL', p_lin_id))::varchar  as P_document_no
	,wf.document_no::varchar  as document_no--ORDER by 6
	,wf.work_flow_id::integer  as work_flow_id
	,wf.work_flow_type_code::varchar as work_flow_type_code
	--
	,to_char(av.av_start_date , 'dd/MM/yyyy')::varchar as av_start_date
	,to_char(av.av_due_date , 'dd/MM/yyyy')::varchar as av_due_date
	,ROUND(coalesce(av.local_amount_of_approve ,0)::numeric, 2) as LocalAmountOfApprove
--	,exwf.work_flow_id::integer as ex_work_flow_id
--	,exwf.document_no::varchar as ex_document_no
--	,exwf.document_date::date as ex_document_date
--	--
--	,ROUND(coalesce(fed.total_expense_amount ,0)::numeric, 2) as ExpenseTotalAmount --ORDER by 15
--	,ROUND(coalesce(fed.total_expense_amount ,0) / coalesce(av.local_amount_of_approve ,1)::numeric, 2) as ExpenseDocumentClearingRatio --ORDER BY 16
--	--
--	,diel.expense_code::varchar as expense_code
--	,diel.expense_name::varchar as expense_name
--	--
--	,ROUND(coalesce(feii.curr_amount ,0)::numeric,2) as AccountLocalAmount --ORDER by 19
--	--
--	,to_char(exwf.document_date,'MM')::varchar as MonthCode
--	,to_char(exwf.document_date,'yyyy')::varchar as YearCode
--	,CONCAT(dbo.get_month_name(p_lin_id, exwf.document_date::date ), '-', to_char(exwf.document_date,'yyyy'))::varchar as MonthYear
	,dbo.get_su_system_configuration('NavigateReport', 'NavigateReport')::varchar as NavigateReport
	from work_flow wf
	INNER JOIN av_document av on av.work_flow_id = wf.work_flow_id
	INNER JOIN fn_expense_reference fer on fer.reference_workflow_id = av.work_flow_id
	INNER JOIN fn_expense_document fed on fed.work_flow_id = fer.work_flow_id
	INNER join fn_expense_invoice fei on fei.expense_document_id = fed.expense_document_id 
		and fei.company_code = fed.company_code 
	INNER join fn_expense_invoice_item feii on feii.expense_invoice_id = fei.expense_invoice_id
		and feii.company_code = fei.company_code 
	left join db_income_expense_lang diel on diel.expense_code = feii.expense_code
		and diel.company_code = feii.company_code 
		and diel.language_code = p_lin_id
	INNER JOIN work_flow exwf on exwf.work_flow_id = fed.work_flow_id 
	LEFT JOIN db_employee de ON de.emp_code = wf.requester_user_code
	LEFT JOIN db_employee_lang del ON de.emp_code = del.emp_code AND del.language_code = p_lin_id
		and del.company_code = de.company_code 
	where wf.company_code = p_company_code--'SS'
		and wf.branch_code = p_branch_code--'NSC'
		and wf.division_code = coalesce (p_division_code, wf.division_code)--'NSC001'
		and wf.requester_user_code = coalesce (p_requester_user_code, wf.requester_user_code)--'63025'
		and wf.document_no  = coalesce (p_fix_av_doc_no, wf.document_no)
		and	 CAST(av.av_start_date AS DATE)
			between coalesce(to_date(p_fix_s_date,'DD/MM/YYYY') , to_date('01/01/0001','dd/mm/yyyy'))
			and coalesce(to_date(p_fix_e_date,'DD/MM/YYYY') , to_date('31/12/9999','dd/mm/yyyy'))
		and	 CAST(exwf.document_date AS DATE)
			between coalesce(to_date(p_ex_s_date,'DD/MM/YYYY') , to_date('01/01/0001','dd/mm/yyyy'))
			and coalesce(to_date(p_ex_e_date,'DD/MM/YYYY') , to_date('31/12/9999','dd/mm/yyyy'))
		AND   exwf.status <> 'Cancel'
		and wf.work_flow_sub_type_code = WorkFlowSubTypeCode
	    AND ( EXISTS (select get_exists_on_report(wf.work_flow_id, UserCode))
	         or wf.requester_user_code = UserCode 
	         or wf.creator_user_code = UserCode
	         )
	    /*
		    (
		    CheckPrivilege = '1'
		    and
		    EXISTS (
	            SELECT 'x' FROM su_user_organization suo
	            WHERE suo.user_id = user_login --'63025'--ALL Doc'62020'
	            AND suo.company_code = wf.company_code
	            and suo.profile_type = 'Document'
	        		))
		    OR EXISTS (
		        SELECT 'x' FROM su_user_authorized sua 
		        WHERE sua.authorized_emp_code = de.emp_code
		        AND sua.emp_code = UserCode
		    		) 
		    OR (wf.requester_user_code = UserCode 
		    OR wf.creator_user_code = UserCode )*/
		    
			
			
	------fn_expense_perdiem
	union all
	select (concat(get_company_code_name(p_lin_id, p_company_code),' / ',
	get_branch_code_name(p_lin_id, p_branch_code)))::varchar  as H_Company,
	get_companycode_branchcode(p_lin_id, p_company_code,p_branch_code)::varchar   as P_CompanyBranch
	,dbo.get_division_name(p_lin_id, p_company_code, p_branch_code, wf.division_code)::varchar  as P_Division
	,dbo.get_employee_name(p_lin_id, p_company_code, p_branch_code, wf.requester_user_code)::varchar  as P_Emp
	,coalesce(p_fix_av_doc_no,dbo.get_report_label_name('SMEXRP02', 'ALL', p_lin_id))::varchar  as P_document_no
	,wf.document_no::varchar  as document_no--ORDER by 6
	,wf.work_flow_id::integer  as work_flow_id
	,wf.work_flow_type_code::varchar as work_flow_type_code
	--
	,to_char(av.av_start_date , 'dd/MM/yyyy')::varchar as av_start_date
	,to_char(av.av_due_date , 'dd/MM/yyyy')::varchar as av_due_date
	,ROUND(coalesce(av.local_amount_of_approve ,0)::numeric,2) as LocalAmountOfApprove
--	,exwf.work_flow_id::integer as ex_work_flow_id
--	,exwf.document_no::varchar as ex_document_no
--	,exwf.document_date::date as ex_document_date
--	--
--	,ROUND(coalesce(fed.total_expense_amount ,0)::numeric,2) as ExpenseTotalAmount --ORDER by 15
--	,ROUND(coalesce(fed.total_expense_amount ,0) / coalesce(av.local_amount_of_approve ,1)::numeric,2) as ExpenseDocumentClearingRatio --ORDER BY 16
--	--
--	,diel.expense_code::varchar as expense_code
--	,diel.expense_name::varchar as expense_name
--	--
--	,ROUND(coalesce(fep.local_amount ,0)::numeric,2) as AccountLocalAmount --ORDER by 19
--	--
--	,to_char(exwf.document_date,'MM')::varchar as MonthCode
--	,to_char(exwf.document_date,'yyyy')::varchar as YearCode
--	,CONCAT(dbo.get_month_name(p_lin_id, exwf.document_date::date ), '-', to_char(exwf.document_date,'yyyy'))::varchar as MonthYear
	,dbo.get_su_system_configuration('NavigateReport', 'NavigateReport')::varchar as NavigateReport
	from work_flow wf
	INNER join av_document av on av.work_flow_id = wf.work_flow_id
	INNER JOIN fn_expense_reference fer on fer.reference_workflow_id = av.work_flow_id
	inner JOIN fn_expense_document fed on fed.work_flow_id = fer.work_flow_id
	INNER join fn_expense_perdiem fep on fep.expense_document_id = fed.expense_document_id
	left join db_income_expense_lang diel on diel.expense_code = fep.expense_code
		and diel.company_code = fep.company_code 
		and diel.language_code = p_lin_id
	INNER JOIN work_flow exwf on exwf.work_flow_id = fed.work_flow_id 
	LEFT JOIN db_employee de ON de.emp_code = wf.requester_user_code
	LEFT JOIN db_employee_lang del ON de.emp_code = del.emp_code AND del.language_code = p_lin_id
		and del.company_code = de.company_code 
	where wf.company_code = p_company_code--'SS'
		and wf.branch_code = p_branch_code--'NSC'
		and wf.division_code = coalesce (p_division_code, wf.division_code)--'NSC001'
		and wf.requester_user_code = coalesce (p_requester_user_code, wf.requester_user_code)--'63025'
		and wf.document_no  = coalesce (p_fix_av_doc_no, wf.document_no)
		and	 CAST(av.av_start_date AS DATE)
			between coalesce(to_date(p_fix_s_date,'DD/MM/YYYY') , to_date('01/01/0001','dd/mm/yyyy'))
			and coalesce(to_date(p_fix_e_date,'DD/MM/YYYY') , to_date('31/12/9999','dd/mm/yyyy'))
		and	 CAST(exwf.document_date AS DATE)
			between coalesce(to_date(p_ex_s_date,'DD/MM/YYYY') , to_date('01/01/0001','dd/mm/yyyy'))
			and coalesce(to_date(p_ex_e_date,'DD/MM/YYYY') , to_date('31/12/9999','dd/mm/yyyy'))
		AND   exwf.status <> 'Cancel'
		and wf.work_flow_sub_type_code = WorkFlowSubTypeCode
		AND ( EXISTS (select get_exists_on_report(wf.work_flow_id, UserCode))
	         or wf.requester_user_code = UserCode 
	         or wf.creator_user_code = UserCode
	         )
	    /*AND (
		    (
		    CheckPrivilege = '1'
		    and
		    EXISTS (
	            SELECT 'x' FROM su_user_organization suo
	            WHERE suo.user_id = user_login --'63025'--ALL Doc'62020'
	            AND suo.company_code = wf.company_code
	            and suo.profile_type = 'Document'
	        		))
		    OR EXISTS (
		        SELECT 'x' FROM su_user_authorized sua 
		        WHERE sua.authorized_emp_code = de.emp_code
		        AND sua.emp_code = UserCode
		    		) 
		    OR (wf.requester_user_code = UserCode 
		    OR wf.creator_user_code = UserCode )
			)*/
	------fn_expense_mileage
	union all
	select (concat(get_company_code_name(p_lin_id, p_company_code),' / ',
	get_branch_code_name(p_lin_id, p_branch_code)))::varchar  as H_Company,
	get_companycode_branchcode(p_lin_id, p_company_code,p_branch_code)::varchar  as P_CompanyBranch
	,dbo.get_division_name(p_lin_id, p_company_code, p_branch_code, wf.division_code)::varchar  as P_Division
	,dbo.get_employee_name(p_lin_id, p_company_code, p_branch_code, wf.requester_user_code)::varchar  as P_Emp
	,coalesce(p_fix_av_doc_no,dbo.get_report_label_name('SMEXRP02', 'ALL', p_lin_id))::varchar  as P_document_no
	,wf.document_no::varchar  as document_no--ORDER by 6
	,wf.work_flow_id::integer  as work_flow_id
	,wf.work_flow_type_code::varchar as work_flow_type_code
	--
	,to_char(av.av_start_date , 'dd/MM/yyyy')::varchar as av_start_date
	,to_char(av.av_due_date , 'dd/MM/yyyy')::varchar as av_due_date
	,ROUND(coalesce(av.local_amount_of_approve ,0)::numeric,2) as LocalAmountOfApprove
--	,exwf.work_flow_id::integer as ex_work_flow_id
--	,exwf.document_no::varchar as ex_document_no
--	,exwf.document_date::date as ex_document_date
--	--
--	,ROUND(coalesce(fed.total_expense_amount ,0)::numeric,2) as ExpenseTotalAmount --ORDER by 15
--	,ROUND(coalesce(fed.total_expense_amount ,0) / coalesce(av.local_amount_of_approve ,1)::numeric,2) as ExpenseDocumentClearingRatio --ORDER BY 16
--	--
--	,diel.expense_code::varchar as expense_code
--	,diel.expense_name::varchar as expense_name
--	--
--	,ROUND(coalesce(fem.local_amount ,0)::numeric,2) as AccountLocalAmount --ORDER by 19
--	--
--	,to_char(exwf.document_date,'MM')::varchar as MonthCode
--	,to_char(exwf.document_date,'yyyy')::varchar as YearCode
--	,CONCAT(dbo.get_month_name(p_lin_id, exwf.document_date::date ), '-', to_char(exwf.document_date,'yyyy'))::varchar as MonthYear
	,dbo.get_su_system_configuration('NavigateReport', 'NavigateReport')::varchar as NavigateReport
	from work_flow wf
	INNER JOIN av_document av on av.work_flow_id = wf.work_flow_id
	INNER JOIN fn_expense_reference fer on fer.reference_workflow_id = av.work_flow_id
	INNER JOIN fn_expense_document fed on fed.work_flow_id = fer.work_flow_id
	INNER join fn_expense_mileage fem on fem.expense_document_id = fed.expense_document_id
	--INNER join fn_expense_perdiem fep on fep.expense_document_id = fed.expense_document_id
	left join db_income_expense_lang diel on diel.expense_code = fem.expense_code
		and diel.company_code = fem.company_code 
		and diel.language_code = p_lin_id
	INNER JOIN work_flow exwf on exwf.work_flow_id = fed.work_flow_id 
	LEFT JOIN db_employee de ON de.emp_code = wf.requester_user_code
	LEFT JOIN db_employee_lang del ON de.emp_code = del.emp_code AND del.language_code = p_lin_id
		and del.company_code = de.company_code 
	where wf.company_code = p_company_code--'SS'
		and wf.branch_code = p_branch_code--'NSC'
		and wf.division_code = coalesce (p_division_code, wf.division_code)--'NSC001'
		and wf.requester_user_code = coalesce (p_requester_user_code, wf.requester_user_code)--'63025'
		and wf.document_no  = coalesce (p_fix_av_doc_no, wf.document_no)
		and	 CAST(av.av_start_date AS DATE)
			between coalesce(to_date(p_fix_s_date,'DD/MM/YYYY') , to_date('01/01/0001','dd/mm/yyyy'))
			and coalesce(to_date(p_fix_e_date,'DD/MM/YYYY') , to_date('31/12/9999','dd/mm/yyyy'))
		and	 CAST(exwf.document_date AS DATE)
			between coalesce(to_date(p_ex_s_date,'DD/MM/YYYY') , to_date('01/01/0001','dd/mm/yyyy'))
			and coalesce(to_date(p_ex_e_date,'DD/MM/YYYY') , to_date('31/12/9999','dd/mm/yyyy'))
		AND   exwf.status <> 'Cancel'
		and wf.work_flow_sub_type_code = WorkFlowSubTypeCode
		AND ( EXISTS (select get_exists_on_report(wf.work_flow_id, UserCode))
	         or wf.requester_user_code = UserCode 
	         or wf.creator_user_code = UserCode
	         )
	    /*AND (
		    (
		    CheckPrivilege = '1'
		    and
		    EXISTS (
	            SELECT 'x' FROM su_user_organization suo
	            WHERE suo.user_id = user_login --'63025'--ALL Doc'62020'
	            AND suo.company_code = wf.company_code
	            and suo.profile_type = 'Document'
	        		))
		    OR EXISTS (
		        SELECT 'x' FROM su_user_authorized sua 
		        WHERE sua.authorized_emp_code = de.emp_code
		        AND sua.emp_code = UserCode
		    		) 
		    OR (wf.requester_user_code = UserCode 
		    OR wf.creator_user_code = UserCode )
			)*/
			
		ORDER by 6
   ) as temp_data
  group by 1,2,3,4,5,6,7,8,9,10,11,12;

END;
$function$
;
