-- DROP FUNCTION erp.report_pood31_sub(varchar, int4);

CREATE OR REPLACE FUNCTION erp.report_pood31_sub(p_lin_id character varying, p_pr_master_id integer)
 RETURNS TABLE(pr_master_id integer, company_code character varying, doc_type character varying, doc_no character varying, ord_seq integer, committee_type character varying, committee_type_name_master character varying, com_code_mas integer, com_name_mas character varying, committee_id integer, com_name_det character varying, l_com_name_det character varying)
 LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN QUERY
	select a.pr_master_id::integer as pr_master_id
			,a.company_code::character varying as company_code
			,a.doc_type::character varying as doc_type
			,a.doc_no::character varying as doc_no
			,a.ord_seq::integer as ord_seq
			,pct.committee_type_code ::character varying as committee_type
			,pctl.committee_type_name::character varying as committee_type_name_master
			,a.personal_id::integer as com_code_mas
			,de.emp_name::character varying as com_name_mas
			,b.committee_id::integer as committee_id
			,coalesce(de2.emp_name,b.external_committee_name)::character varying as com_name_det
			,dlvl.value_text::character varying as L_com_name_det
			--,* 
	from po_committee_master a
		left join db_employee_name(p_lin_id) de on de.emp_id = a.personal_id 
					
					-- AND current_date BETWEEN COALESCE(po_convert_thai_to_gregorian(de.work_date::Date), current_date)
					-- 		AND COALESCE(po_convert_thai_to_gregorian(de.turnover_date::Date), current_date)
											
						left join po_committee_type pct on pct.committee_type_id = a.committee_type_id 
								left join po_committee_type_lang pctl on pctl.committee_type_id = a.committee_type_id 
										and lower(pctl.language_code) = lower(p_lin_id)
	left join po_committee_detail b on b.committee_master_id = a.committee_master_id 
		left join db_employee_name(p_lin_id) de2 on de2.emp_id = b.committee_id
					
					-- AND current_date BETWEEN COALESCE(po_convert_thai_to_gregorian(de2.work_date::Date), current_date)
					-- 		AND COALESCE(po_convert_thai_to_gregorian(de2.turnover_date::Date), current_date)
		left join db_list_value_lang dlvl on dlvl.group_code = 'CommitteeDetailPosi'
				and lower(dlvl.language_code) = lower(p_lin_id)
				and dlvl.value = b.committee_posi 
	where a.pr_master_id = p_pr_master_id
	and coalesce(pct.tor_draft_committee,false) = false --ยกเว้นคณะกรรมการกำหนดขอบเขตงานและกำหนดราคากลาง 2026-02-06
	order by a.ord_seq,b.ord_seq;
    
END;
$function$
;
