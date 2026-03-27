drop function report_porp07;

CREATE OR REPLACE FUNCTION erp.report_porp07(p_company_code character varying, p_lin_id character varying, p_s_po_date character varying, p_e_po_date character varying, p_s_div character varying, p_e_div character varying, p_budget_year character varying, p_user_id character varying)
 RETURNS TABLE(running_no integer, company_code character varying, receive_master_id integer, pquarter character varying, year_receive_date character varying, month_receive_date character varying, ref_div_code character varying, ref_div_name character varying, div_code character varying, ap_member_id integer, ap_member character varying, sub_product_name character varying, total_amt numeric, receipt_date date, po_date date, format_po_date character varying, ref_no character varying, method_name character varying)
 LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN QUERY
select  
        ROW_NUMBER() OVER (PARTITION BY var.ref_div_code ORDER BY var.ref_div_code, LENGTH(var.ref_no), var.ref_no, var.po_date)::integer AS running_no,
		var.*
from(
	select ppom.company_code::character varying as company_code
			,ppom.pur_ord_master_id::integer as receive_master_id
			,concat(
			    (CASE 
			        WHEN p_s_po_date IS NOT NULL THEN
			            po_format_date_thai(
			                get_report_label_name('PORP07', 'DateFrom', p_lin_id), 
			                get_report_label_name('PORP07', 'DateMonth', p_lin_id), 
			                get_report_label_name('PORP07', 'DateYear', p_lin_id), 
			                to_date(COALESCE(p_s_po_date, '01/01/1000'),'DD/MM/YYYY')::date, 
			                p_lin_id
			            )
			        ELSE
			            concat(get_report_label_name('PORP07', 'DateFrom', p_lin_id), get_report_label_name('PORP07', 'All', p_lin_id))
			    END)
			    ,' ',
			    (CASE 
			        WHEN p_e_po_date IS NOT NULL THEN
			            po_format_date_thai(
			                get_report_label_name('PORP07', 'DateTo', p_lin_id), 
			                get_report_label_name('PORP07', 'DateMonth', p_lin_id), 
			                get_report_label_name('PORP07', 'DateYear', p_lin_id), 
			                to_date(COALESCE(p_e_po_date, '31/12/9999'), 'DD/MM/YYYY')::date, 
			                p_lin_id
			            )
			        ELSE
			            concat(get_report_label_name('PORP07', 'DateTo', p_lin_id), get_report_label_name('PORP07', 'All', p_lin_id))
			    END)
			)::character varying AS PQuarter
			,to_char(extract(year from ppom.po_date) +543 ,'FM9999')::character varying as Year_receive_date
			,TO_CHAR(EXTRACT(MONTH FROM ppom.po_date), 'FM9')::character varying as Month_receive_date
			,do2.organization_code::character varying as ref_div_code
			,get_organization_hierarchy(p_lin_id, ppom.company_code, ppom.div_code)::character varying as ref_div_name
			,ppom.div_code::character varying as div_code
			--detail
			,ppom.ap_member_id::integer as ap_member_id
			,concat(dpl.prefix_name,' ',aml.first_name,' ',aml.last_name)::character varying as ap_member
			,concat(psptl.sub_product_name,' ',get_report_label_name('PORP07', 'countproduct', p_lin_id),' ',
					(select count(ppod.pur_ord_detail_id)
					from po_pur_ord_detail ppod 
					where ppod.pur_ord_master_id = ppom.pur_ord_master_id)
					,' ',get_report_label_name('PORP07', 'list', p_lin_id))::character varying as sub_product_name
			,ppom.total_amt::numeric as total_amt
			,null::Date as receipt_date
			,ppom.po_date::Date as po_date
			,case p_lin_id when 'TH' then 
					format_date_thai(ppom.po_date::Date)
				else
					TO_CHAR(ppom.po_date, 'DD FMMon YY')
				end::character varying as format_po_date
			,ppom.ref_no::character varying as ref_no
			,(select md.method_name from po_pr_master ppm
				left join po_method_lang md on ppm.pr_method_id = md.method_id and lower(md.language_code) = lower(p_lin_id)
				where ppm.doc_type = ppom.ref_doc_type
				and ppm.pr_no = ppom.ref_doc_no )::character varying as method_name
	from po_pur_ord_master ppom 
	left join ap_member_lang aml on aml.ap_member_id = ppom.ap_member_id 
			and lower(aml.language_code) = lower(p_lin_id)
			left join db_prefix_lang dpl on dpl.prefix_id = aml.prefix_id 
				and lower(dpl.language_code) = lower(p_lin_id)
	left join po_sub_product_type pspt on pspt.sub_product_type_code = ppom.sub_product_type 
			left join po_sub_product_type_lang psptl on psptl.sub_product_type_id = pspt.sub_product_type_id 
					and lower(psptl.language_code) = lower(p_lin_id)
	left join db_organization do2 on do2.organization_code = ppom.div_code
	where 1=1
	and ppom.status in ('A','E')
	and date(ppom.po_date) BETWEEN to_date(COALESCE(p_s_po_date, '01/01/1000'),'DD/MM/YYYY') 
					AND to_date(COALESCE(p_e_po_date,'31/12/9999' ), 'DD/MM/YYYY')
--	AND prm.total_amt <= (db_get_parameter_value('PO', 'ParameterWhereAmtReportPorp07')::numeric)
	and do2.organization_code between  COALESCE(p_s_div,do2.organization_code)
						and COALESCE(p_e_div,do2.organization_code)
--	and to_char(extract(year from ppom.po_date) +543 ,'FM9999') = concat(p_budget_year)
	AND EXISTS (
			    SELECT 'x'
			    FROM db_period_control dpc
			    WHERE dpc.company_code = ppom.company_code
			      AND concat(dpc.budget_year) = concat(p_budget_year)
			    GROUP BY dpc.company_code, dpc.budget_year 
			    HAVING date(ppom.po_date) BETWEEN date(min(dpc.start_date))
	                                  AND date(max(dpc.end_date))
				)
	and exists (select 'X' from su_user_organization su
	                        where concat(su.user_id) = concat(p_user_id)
	                        and su.company_code = p_company_code
	                        and su.organization_code = ppom.div_code 
	                        and coalesce(cast(su.start_effective_date as date), current_date) <= current_date
	                        and coalesce(cast(su.end_effective_date as date), current_date) >= current_date)
	ORDER BY ppom.div_code, LENGTH(ppom.ref_no), ppom.ref_no, ppom.po_date
) as var;
END;
$function$
;