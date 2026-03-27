-- drop function report_porp11_sub;

CREATE OR REPLACE FUNCTION erp.report_porp11_sub(p_lin_id character varying, p_pr_master_id integer)
 RETURNS TABLE(pr_master_id integer, ap_member_name character varying)
 LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN QUERY
select pps.pr_master_id::integer as pr_master_id
	,concat(coalesce(aml.full_name, coalesce(aml2.prefix_abbreviation, aml2.prefix_name), ' ', aml.first_name, ' ', aml.last_name))::character varying as ap_member_name
from po_pr_supplier pps 
left join ap_member am on pps.ap_member_id = am.ap_member_id
		left join ap_member_lang aml on am.ap_member_id = aml.ap_member_id 
				and lower(aml.language_code) = lower(p_lin_id)
		left join db_prefix_lang aml2 on aml2.prefix_id = aml.prefix_id 
				and lower(aml2.language_code) = lower(p_lin_id)
where pps.pr_master_id = p_pr_master_id
order by pps.pr_supplier_id ;
    
END;
$function$
;