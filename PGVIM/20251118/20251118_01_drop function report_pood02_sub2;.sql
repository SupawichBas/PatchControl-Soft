drop function report_pood02_sub2;

CREATE OR REPLACE FUNCTION erp.report_pood02_sub2(p_pr_master_id integer, p_lin_id character varying)
 RETURNS TABLE(committee_type_id integer, committee_master_type_name character varying, committee_name character varying, committee_type_name character varying, image character varying, status_show_image boolean)
 LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN QUERY
select a.committee_type_id::integer as committee_type_id,
		TRIM(SPLIT_PART(pctl.committee_type_name, '(', 1))::character varying AS  committee_master_type_name,
		de2.emp_name::character varying AS  committee_name,
		dlvl.value_text::character varying AS committee_type_name,
        case when de2.personal_id is not null and de2.signature_image_id is not null
				then concat((select sp.parameter_value  from su_parameter sp 
								where sp.parameter_group_code = 'ContentPath'
								and sp.parameter_code = 'SignatureURL')
								,'?PersonalId=',de2.personal_id,'&ContentId=',de2.signature_image_id)
				else null end::character varying as image,
		case when (select ppm.status from po_pr_master ppm where ppm.pr_master_id = p_pr_master_id) in ('A','R','E') then true else false end::bool as status_show_image
from po_committee_master a
left join po_committee_type pct on pct.committee_type_id = a.committee_type_id 
		left join po_committee_type_lang pctl on pctl.committee_type_id = pct.committee_type_id 
				and lower(pctl.language_code) = lower(p_lin_id)
left join po_committee_detail b on b.committee_master_id = a.committee_master_id
		left join db_employee_name(p_lin_id) de2 on de2.emp_id = b.committee_id
left join db_list_value_lang dlvl on dlvl.group_code = 'CommitteeDetailPosi'
	and lower(dlvl.language_code) = lower(p_lin_id)
	and dlvl.value = b.committee_posi 
where a.pr_master_id = p_pr_master_id
and coalesce(pct.procurement_committee,false) = true
order by a.committee_type_id,b.ord_seq;
    
END;
$function$
;
