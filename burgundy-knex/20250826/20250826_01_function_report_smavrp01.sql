drop function report_smavrp01;

CREATE OR REPLACE FUNCTION dbo.report_smavrp01(user_company_code character varying, p_lin_id character varying, p_company_code character varying, p_branch_code character varying, p_division_code character varying, p_requester_user_code character varying, p_s_date character varying, p_e_date character varying, p_type_of_advance character varying, user_login integer, p_status character varying)
 RETURNS TABLE(h_company character varying, p_companybranch character varying, p_division character varying, p_emp character varying, p_document_sub_type character varying, p_status_name character varying, division_code character varying, division_name character varying, av_document_id integer, running_number_av_document integer, av_document_id_count integer, document_no character varying, av_start_date character varying, av_due_date character varying, requester_user_code character varying, full_name character varying, subject character varying, dueday integer, trackingtimes integer, status_value character varying, status_name character varying, work_flow_id integer, work_flow_type_code character varying, local_amount_of_approve_ad numeric, navigatereport character varying)
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
select * from (
	select (concat(get_company_code_name(p_lin_id, p_company_code),' / ',
		get_branch_code_name(p_lin_id, p_branch_code)))::varchar  as H_Company,
		get_companycode_branchcode(p_lin_id, p_company_code,p_branch_code)::varchar  as P_CompanyBranch,
		coalesce (dbo.get_division_name(p_lin_id, p_company_code, p_branch_code, p_division_code), dbo.get_report_label_name('SMAVRP01', 'ALL', p_lin_id))::varchar  as P_Division,
		coalesce (dbo.get_employee_name(p_lin_id, p_company_code, p_branch_code, p_requester_user_code), dbo.get_report_label_name('SMAVRP01', 'ALL', p_lin_id))::varchar  as P_Emp,
		coalesce (dbo.get_document_sub_type(p_lin_id, p_type_of_advance), dbo.get_report_label_name('SMAVRP01', 'ALL', p_lin_id))::varchar  as P_Document_Sub_Type,
		coalesce (dbo.get_status_name(p_lin_id, p_company_code, p_status), dbo.get_report_label_name('SMAVRP01', 'ALL', p_lin_id))::varchar  as P_Status_Name,
		wf.division_code::varchar as division_code,
		dol.organization_name::varchar as Division_Name,
		ad.av_document_id::integer as av_document_id,--group
--		adi.av_document_item_id::integer as av_document_item_id,
		ROW_NUMBER() OVER (PARTITION BY ad.av_document_id ORDER BY wf.division_code ASC)::integer as running_number_av_document,
		COUNT(ad.av_document_id) OVER (PARTITION BY ad.av_document_id)::integer AS av_document_id_count,
		wf.document_no::varchar as document_no,
		to_char(ad.av_start_date , 'dd/MM/yyyy')::varchar as av_start_date ,
		to_char(ad.av_due_date , 'dd/MM/yyyy')::varchar as av_due_date ,
		wf.requester_user_code::varchar as requester_user_code,
		concat(del.first_name ,' ',del.last_name)::varchar as full_name,
		--wf.subject::varchar as subject,
		 case when wf.work_flow_sub_type_code = 'AVR' then  wf.subject  
             else 
              (select value_text from db_list_value_lang dlvl 
                        where  dlvl.company_code = wf.company_code 
			        	and dlvl.group_code = 'AdvanceSubject'
			        	and dlvl.language_code = p_lin_id 
			        	and dlvl.value = wf.subject) end ::varchar as subject,
--		adi.curr_amount::numeric as curr_amount,
--		adi.currency_code::varchar as currency_code,
--		adi.local_amount_of_approve::numeric as local_amount_of_approve ,
--		coalesce(adi.local_amount_of_payment,coalesce(adi.local_amount_of_approve,0))::numeric as local_amount_of_approve,
		dbo.get_number_of_days_overdue(CAST(ad.av_due_date AS DATE),dbo.get_min_date_approver_for_fn_expense_document(ad.av_document_id))::integer as DueDay,
		dbo.get_tracking_times_wht(CAST(ad.av_due_date AS DATE))::integer as TrackingTimes,
		wf.status::varchar as status_value,
		dsl.status_desc::varchar as status_name,
		wf.work_flow_id::integer as work_flow_id,
		wf.work_flow_type_code::varchar as work_flow_type_code,
		coalesce(ad.local_amount_of_payment,coalesce(ad.local_amount_of_approve,0))::numeric as local_amount_of_approve_ad,
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
		join av_document ad on ad.work_flow_id = wf.work_flow_id 
--		join av_document_item adi on adi.av_document_id = ad.av_document_id 
	where wf.company_code = p_company_code--'SS'
		and wf.branch_code = p_branch_code--'NSC'
		and wf.division_code = coalesce (p_division_code, wf.division_code)--'NSC001'
		and wf.requester_user_code = coalesce (p_requester_user_code, wf.requester_user_code)--'63025'
		and	 CAST(ad.av_due_date AS DATE)
			between coalesce(to_date(p_s_date,'DD/MM/YYYY') , to_date('01/01/0001','dd/mm/yyyy'))
			and coalesce(to_date(p_e_date,'DD/MM/YYYY') , to_date('31/12/9999','dd/mm/yyyy'))
		AND   wf.status  IN ('Complete', 'OutstandingAdvance')
		and ad.type_of_advance = coalesce (p_type_of_advance, ad.type_of_advance)--'AVO'
		and wf.status = coalesce (p_status, wf.status)
		AND   CAST(ad.av_due_date as DATE) < CAST(coalesce(ad.complete_date, current_date) as DATE)
		and EXISTS (select get_exists_on_report(wf.work_flow_id, UserCode))
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
		ORDER BY wf.division_code,ad.av_document_id
) m
where m.DueDay > 0;

END;
$function$
;
