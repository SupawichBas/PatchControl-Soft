-- DROP FUNCTION erp.report_pood13_sub_sign(varchar, int4);

CREATE OR REPLACE FUNCTION erp.report_pood13_sub_sign(p_lin_id character varying, p_guaranty_master_id integer)
 RETURNS TABLE(sign1 character varying, emp_name character varying, position_name character varying, url character varying)
 LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN QUERY
select concat('ลงชื่อ')::character varying as sign1,
		coalesce(concat('(', recieve.emp_name, ')'), '')::character varying as emp_name,
		concat('ผู้คืนหลักประกัน')::character varying as position_name,
		case when recieve.personal_id is not null and recieve.signature_image_id is not null and a.status not in ('N','C')
			then concat((select sp.parameter_value  from su_parameter sp 
							where sp.parameter_group_code = 'ContentPath'
							and sp.parameter_code = 'SignatureURL')
							,'?PersonalId=',recieve.personal_id,'&ContentId=',recieve.signature_image_id)
			else null end::character varying as url
	from po_guaranty_master a 
		left join db_employee_name(p_lin_id) recieve on recieve.emp_id  = a.return_emp_id
	where a.guaranty_master_id = p_guaranty_master_id
	;
END;
$function$
;
