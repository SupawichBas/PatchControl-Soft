drop function report_porp09;

CREATE OR REPLACE FUNCTION erp.report_porp09(p_quarter character varying, p_company_code character varying, p_lin_id character varying, p_quarter1 character varying, p_quarter2 character varying, p_s_div character varying, p_e_div character varying, p_budget_year character varying, p_user_id character varying)
 RETURNS TABLE(running_no integer, company_code character varying, pr_master_id integer,
 pquarter character varying, year_pr_date character varying, month_pr_date character varying,
 ref_div_code character varying, ref_div_name character varying,
 div_code character varying, ap_member_id integer, ap_member character varying, sub_product_name character varying,
 total_amt numeric, pr_date date, format_pr_date character varying, ref_no character varying)
 LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN QUERY
select DENSE_RANK() OVER (PARTITION BY var.ref_div_code ORDER BY var.pr_master_id)::integer AS running_no
		,var.*
from(
	select ppm.company_code::character varying as company_code
			,ppm.pr_master_id::integer as pr_master_id
			,CASE 
		        WHEN p_quarter = '10-12' THEN 
		            get_report_label_name('PORP09', 'Quarter1From', p_lin_id) || ' ' || to_char(extract(year from ppm.pr_date) + 543, 'FM9999') || ' ' || get_report_label_name('PORP09', 'Quarter1To', p_lin_id) || ' ' || to_char(extract(year from ppm.pr_date) + 543, 'FM9999') || ')'
		        WHEN p_quarter = '1-3' THEN 
		            get_report_label_name('PORP09', 'Quarter2From', p_lin_id) || ' ' || to_char(extract(year from ppm.pr_date) + 543, 'FM9999') || ' ' || get_report_label_name('PORP09', 'Quarter2To', p_lin_id) || ' ' || to_char(extract(year from ppm.pr_date) + 543, 'FM9999') || ')'
		        WHEN p_quarter = '4-6' THEN 
		            get_report_label_name('PORP09', 'Quarter3From', p_lin_id) || ' ' || to_char(extract(year from ppm.pr_date) + 543, 'FM9999') || ' ' || get_report_label_name('PORP09', 'Quarter3To', p_lin_id) || ' ' || to_char(extract(year from ppm.pr_date) + 543, 'FM9999') || ')'
		        WHEN p_quarter = '7-9' THEN 
		            get_report_label_name('PORP09', 'Quarter4From', p_lin_id) || ' ' || to_char(extract(year from ppm.pr_date) + 543, 'FM9999') || ' ' || get_report_label_name('PORP09', 'Quarter4To', p_lin_id) || ' ' || to_char(extract(year from ppm.pr_date) + 543, 'FM9999') || ')'
		        ELSE
		            'Error'
		    end::character varying AS PQuarter
			,to_char(extract(year from ppm.pr_date) +543 ,'FM9999')::character varying as Year_pr_date
			,TO_CHAR(EXTRACT(MONTH FROM ppm.pr_date), 'FM9')::character varying as Month_pr_date
			,do2.organization_code::character varying as ref_div_code
			,get_organization_hierarchy(p_lin_id, ppm.company_code, ppm.ref_div_code)::character varying as ref_div_name
			,ppm.div_code::character varying as div_code
			--detail
			,ppm.ap_member_id::integer as ap_member_id
			,concat(dpl.prefix_name,' ',aml.first_name,' ',aml.last_name)::character varying as ap_member
			,concat(psptl.sub_product_name,' ',get_report_label_name('PORP09', 'countproduct', p_lin_id),' ',
					(select TO_CHAR(coalesce(count(ppsd.pr_supplier_detail_id), 0)::numeric, 'FM99,999,999')
					from po_pr_supplier_detail ppsd
					where ppsd.pr_supplier_id = pps.pr_supplier_id)
					,' ',get_report_label_name('PORP09', 'list', p_lin_id))::character varying as sub_product_name
			,(select sum(ppd2.gs_aft_disc)
				from po_pr_supplier_detail ppsd2
				join po_pr_detail ppd2 on ppsd2.detail_seq = ppd2.seq
					and ppsd2.company_code = ppd2.company_code
					and ppsd2.doc_type  = ppd2.doc_type
					and ppsd2.pr_no = ppd2.pr_no
				where ppsd2.pr_supplier_id = pps.pr_supplier_id)::numeric as total_amt
			,ppom.po_date::Date as pr_date
			,case p_lin_id when 'TH' then 
					format_date_thai(ppom.po_date::Date)
				else
					TO_CHAR(ppom.po_date, 'DD FMMon YY')
				end::character varying as format_pr_date
			,ppom.contract_code_egp::character varying as ref_no
	from po_pr_master ppm
	join po_pr_supplier pps on pps.pr_master_id = ppm.pr_master_id
	left join po_pur_ord_master ppom on ppom.company_code = pps.company_code
			and ppom.doc_type = pps.ref_doc_type
			and ppom.po_no = pps.ref_doc_no
	left join ap_member_lang aml on aml.ap_member_id = pps.ap_member_id 
			and lower(aml.language_code) = lower(p_lin_id)
			left join db_prefix_lang dpl on dpl.prefix_id = aml.prefix_id 
				and lower(dpl.language_code) = lower(p_lin_id)
	left join po_sub_product_type pspt on pspt.sub_product_type_code = ppm.sub_product_type 
			left join po_sub_product_type_lang psptl on psptl.sub_product_type_id = pspt.sub_product_type_id 
					and lower(psptl.language_code) = lower(p_lin_id)
	left join db_organization do2 on do2.organization_code = ppm.ref_div_code
	where 1=1
	and ppm.status = 'A'
	AND TO_CHAR(EXTRACT(MONTH FROM ppm.pr_date), 'FM9') BETWEEN p_quarter1 AND p_quarter2
	AND ppm.total_amt <= (db_get_parameter_value('PO', 'ParameterWhereAmtReportPorp07')::numeric)
	and do2.organization_code between  COALESCE(p_s_div,do2.organization_code)
						and COALESCE(p_e_div,do2.organization_code)
--	and to_char(extract(year from ppm.pr_date) +543 ,'FM9999') = p_budget_year
	and exists (select 'X' from su_user_organization su
	                        where concat(su.user_id) = p_user_id
	                        and su.company_code = p_company_code
	                        and su.organization_code = ppm.div_code 
	                        and coalesce(cast(su.start_effective_date as date), current_date) <= current_date
	                        and coalesce(cast(su.end_effective_date as date), current_date) >= current_date)
	AND (
		    ( coalesce(ppm.is_special_procurement,false) is false AND ppom.pur_ord_master_id IS NOT null and ppom.status = 'A')--เป็นการจัดซื้อปกติ
		    OR 
		    ( coalesce(ppm.is_special_procurement,false) is true AND ppm.status = 'A')--เป็นการจัดซื้้อแบบ ว.119
		)
	ORDER BY ppm.pr_master_id
) as var
ORDER BY var.ref_div_code, running_no;
END;
$function$
;