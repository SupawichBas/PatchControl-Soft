drop function report_smexrp01;

CREATE OR REPLACE FUNCTION dbo.report_smexrp01(user_company_code character varying, p_lin_id character varying, p_company_code character varying, p_branch_code character varying, p_division_code character varying, p_requester_user_code character varying, p_s_date character varying, p_e_date character varying, p_sub_type_code character varying, user_login integer, p_status character varying)
 RETURNS TABLE(h_company character varying, p_companybranch character varying, p_division character varying, p_emp character varying, p_document_sub_type character varying, p_status_name character varying, running_number integer, division_code character varying, division_name character varying, document_date character varying, document_no character varying, subject character varying, requester_user_code character varying, full_name character varying, position_name character varying, email character varying, status character varying, work_flow_id integer, work_flow_type_code character varying, navigatereport character varying)
 LANGUAGE plpgsql
AS $function$ 

declare UserCompany varchar(20);
declare UserCode varchar(20);
declare CheckPrivilege varchar(1);

begin
	UserCompany = get_user_company_code(user_login);
	UserCode = get_user_code(user_login);
	CheckPrivilege = dbo.get_user_privilege(UserCompany, user_login);
    RETURN QUERY
   select 
	(concat(get_company_code_name(p_lin_id, p_company_code),' / ',
	get_branch_code_name(p_lin_id, p_branch_code)))::varchar  as H_Company,
    get_companycode_branchcode(p_lin_id, p_company_code,p_branch_code)::varchar  as P_CompanyBranch,
	coalesce (dbo.get_division_name(p_lin_id, p_company_code, p_branch_code, p_division_code), dbo.get_report_label_name('SMEXRP01', 'ALL', p_lin_id))::varchar  as P_Division,
	coalesce (dbo.get_employee_name(p_lin_id, p_company_code, p_branch_code, p_requester_user_code), dbo.get_report_label_name('SMEXRP01', 'ALL', p_lin_id))::varchar  as P_Emp,
	coalesce (dbo.get_document_sub_type(p_lin_id, p_sub_type_code), dbo.get_report_label_name('SMEXRP01', 'ALL', p_lin_id))::varchar  as P_Document_Sub_Type,
	coalesce (dbo.get_status_name(p_lin_id, p_company_code, p_status), dbo.get_report_label_name('SMEXRP01', 'ALL', p_lin_id))::varchar  as P_Status_Name,
	ROW_NUMBER() OVER (PARTITION BY wf.division_code ORDER BY wf.division_code)::integer AS running_number,
	wf.division_code::varchar division_code,
	dol.organization_name::varchar Division_Name,
	to_char(wf.document_date , 'dd/MM/yyyy')::varchar document_date,
	wf.document_no::varchar document_no,
	wf.subject::varchar subject,
	wf.requester_user_code::varchar requester_user_code,
	concat(del.first_name ,' ',del.last_name)::varchar as full_name,
	dpl.position_name::varchar position_name,
	de.email::varchar as email,
	dsl.status_desc::varchar status,
	wf.work_flow_id::integer as work_flow_id,
	wf.work_flow_type_code::varchar as work_flow_type_code,
	dbo.get_su_system_configuration('NavigateReport', 'NavigateReport')::varchar as NavigateReport
--	,* 
from work_flow wf 
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
	and	 CAST(wf.document_date AS DATE)
		between coalesce(to_date(p_s_date,'DD/MM/YYYY') , to_date('01/01/0001','dd/mm/yyyy'))
		and coalesce(to_date(p_e_date,'DD/MM/YYYY') , to_date('31/12/9999','dd/mm/yyyy'))
	and wf.work_flow_sub_type_code = coalesce (p_sub_type_code, wf.work_flow_sub_type_code)--'TAD'
--	AND (wf.creator_user_code = user_login 
--		OR wf.requester_user_code = user_login
--		or wf.approver_user_code = user_login)
	and wf.status = coalesce (p_status, wf.status)
	AND ( EXISTS (select get_exists_on_report(wf.work_flow_id, UserCode))
	         or wf.requester_user_code = UserCode 
	         or wf.creator_user_code = UserCode
	         )
	/*AND (
		    (
		    CheckPrivilege = '1'
		    --1=1
		    and
		    EXISTS (
	            SELECT 'x' FROM su_user_organization suo
	            WHERE suo.user_id = user_login --214
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
	ORDER BY wf.division_code,cast(wf.document_date as date) , wf.document_no ;
END;
$function$
;
