-- DROP FUNCTION erp.report_pood02_sub(varchar, int4);

CREATE OR REPLACE FUNCTION erp.report_pood02_sub(p_lin_id character varying, p_procurement_master_id integer)
 RETURNS TABLE(position_name character varying, emp_name character varying, url character varying)
 LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN QUERY
select a.procurement_officer_posi::character varying as position_name,
		case when emp.emp_name is not null then concat('( ',emp.emp_name,' )') else ''end::character varying as emp_name,
		case when emp.personal_id is not null and emp.signature_image_id is not null and a.status not in ('N','B','D','C')
			then concat((select sp.parameter_value  from su_parameter sp 
							where sp.parameter_group_code = 'ContentPath'
							and sp.parameter_code = 'SignatureURL')
							,'?PersonalId=',emp.personal_id,'&ContentId=',emp.signature_image_id)
			else null end::character varying as url
from po_procurement_master a
left join po_work_flow pwf on a.company_code = pwf.company_code 
		and a.doc_type = pwf.doc_type 
		and a.procurement_no = pwf.doc_no 
		and pwf.approve_type = 'Initailtor'
		and pwf.approve_by_id = (select su.user_id from su_user su where su.emp_id = a.procurement_officer_emp_id limit 1)
left join db_employee_name(p_lin_id) emp on emp.emp_id = a.procurement_officer_emp_id
where a.procurement_master_id = p_procurement_master_id
limit 1;
END;
$function$
;
