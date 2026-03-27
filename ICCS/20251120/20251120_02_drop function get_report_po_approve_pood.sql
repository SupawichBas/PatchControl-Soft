drop function get_report_po_approve_pood32;

CREATE OR REPLACE FUNCTION erp.get_report_po_approve_pood32(p_lin_id character varying, p_company_code character varying, p_doc_type character varying, p_doc_no character varying)
 RETURNS TABLE(work_flow_id integer, label_sign character varying, signature_image character varying, emp_name character varying, position_approve_desc character varying, approve_date character varying, approve_date_format character varying)
 LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN QUERY
select pwf.work_flow_id::integer as work_flow_id,
    concat('(','ลงชื่อ',')')::character varying AS label_sign,
	case when emp.personal_id is not null and emp.signature_image_id is not null
			then concat((select sp.parameter_value  from su_parameter sp 
							where sp.parameter_group_code = 'ContentPath'
							and sp.parameter_code = 'SignatureURL')
							,'?PersonalId=',emp.personal_id,'&ContentId=',emp.signature_image_id)
			else null end::character varying as signature_image,
    emp.emp_name::character varying AS emp_name,
    pwf.position_approve_desc::character varying AS position_approve_desc,
    erp.po_get_fromat_approve_date(pwf.approve_date::date)::character varying AS approve_date,
    concat('สั่ง ณ วันที่ ',erp.po_format_date_thai(null,null,null, pwf.approve_date::date ,p_lin_id))::character varying as approve_date_format
from po_work_flow pwf
left join db_employee_name(p_lin_id) emp on emp.emp_id = (select su.emp_id from su_user su where su.user_id = pwf.approve_by_id limit 1)
where pwf.company_code = p_company_code--'000'
and pwf.doc_type = p_doc_type--'PQ'
and pwf.doc_no = p_doc_no--'111PQ69010009'
order by pwf.seq desc
limit 1;
END;
$function$
;
