drop function report_porp05;

CREATE OR REPLACE FUNCTION erp.report_porp05(p_lin_id character varying, p_company_code character varying, p_doc_type character varying, p_s_div character varying, p_e_div character varying, p_s_po_date character varying, p_e_po_date character varying, p_product_type character varying, p_user_id integer)
 RETURNS TABLE(company_code character varying, pr_date date, doc_date character varying, sub_product_type character varying, sub_product_name character varying, master_div_code character varying, div_code character varying, div_name character varying, product_code character varying, product_name character varying, qty numeric, ums_code character varying, ums_name character varying, unit_price numeric, amt numeric, p_product_type_dse character varying, p_s_date character varying, p_e_date character varying, p_s_div_dis character varying, p_e_div_dis character varying)
 LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN QUERY
select a.company_code::character varying AS company_code
	,a.pr_date::date AS PR_DATE
	,case when a.pr_date is not null then 
					case p_lin_id when 'TH' then 
							concat(to_char(extract(day from a.pr_date) ,'FM09') ,'/' ,
							to_char(extract(month from a.pr_date) ,'FM09') ,'/' ,
							to_char(extract(year from a.pr_date) +543 ,'FM9999'))
						else
							concat(to_char(extract(day from a.pr_date) ,'FM09') ,'/' ,
							to_char(extract(month from a.pr_date) ,'FM09') ,'/' ,
							to_char(extract(year from a.pr_date) ,'FM9999'))
						end
					end::character varying as doc_date
	,a.sub_product_type::character varying AS sub_product_type
	,CONCAT(a.sub_product_type, ' ', psptl.sub_product_name)::character varying AS sub_product_name
	,a.div_code::character varying AS master_div_code
	,o.organization_code_display::character varying AS div_code
	,ol.organization_name::character varying AS div_name
	,get_product_code(p_lin_id, b.product_type, b.product_id::integer, b.fa_type_id::integer, b.fa_mkind_id::integer)::character varying AS product_code
    ,get_product_name(p_lin_id, b.product_type, b.product_id::integer, b.fa_type_id::integer, b.fa_mkind_id::integer)::character varying AS product_name
	,COALESCE(B.QTY,0)::numeric as QTY
	,get_ums_code(p_lin_id, b.product_type, b.ums_id::integer)::character varying AS ums_code
    ,get_ums_name(p_lin_id, b.product_type, b.ums_id::integer)::character varying AS ums_name
	,COALESCE(b.unit_price, 0)::numeric AS unit_price
	,COALESCE(b.amt, 0)::numeric AS amt
	,p_List_Value_Product_Type.value_text::character varying  as P_Product_Type_dse
	,case when p_s_po_date is not null then 
					case p_lin_id when 'TH' then 
							concat(to_char(extract(day from to_date(p_s_po_date ,'DD/MM/YYYY')) ,'FM09') ,'/' ,
							to_char(extract(month from to_date(p_s_po_date ,'DD/MM/YYYY')) ,'FM09') ,'/' ,
							to_char(extract(year from to_date(p_s_po_date ,'DD/MM/YYYY')) +543 ,'FM9999'))
						else
							concat(to_char(extract(day from to_date(p_s_po_date ,'DD/MM/YYYY')) ,'FM09') ,'/' ,
							to_char(extract(month from to_date(p_s_po_date ,'DD/MM/YYYY')) ,'FM09') ,'/' ,
							to_char(extract(year from to_date(p_s_po_date ,'DD/MM/YYYY')) ,'FM9999'))
						end
		else null end::character varying as p_s_date
	,case when p_e_po_date is not null then 
					case p_lin_id when 'TH' then 
							concat(to_char(extract(day from to_date(p_e_po_date ,'DD/MM/YYYY')) ,'FM09') ,'/' ,
							to_char(extract(month from to_date(p_e_po_date ,'DD/MM/YYYY')) ,'FM09') ,'/' ,
							to_char(extract(year from to_date(p_e_po_date ,'DD/MM/YYYY')) +543 ,'FM9999'))
						else
							concat(to_char(extract(day from to_date(p_e_po_date ,'DD/MM/YYYY')) ,'FM09') ,'/' ,
							to_char(extract(month from to_date(p_e_po_date ,'DD/MM/YYYY')) ,'FM09') ,'/' ,
							to_char(extract(year from to_date(p_e_po_date ,'DD/MM/YYYY')) ,'FM9999'))
						end
		else null end::character varying as p_s_date
	,do2Ps.organization_code_display::character varying  as p_s_div_Dis
	,do2Pe.organization_code_display::character varying  as p_e_div_Dis
from po_pr_master a
	left join db_organization o on o.company_code = a.company_code 
			and o.organization_code = a.div_code
			left join db_organization_lang ol on ol.company_code = o.company_code 
	            and ol.organization_code = o.organization_code 
	            and lower(ol.language_code) = lower(p_lin_id)
	left join po_sub_product_type pspt ON pspt.sub_product_type_code  = a.sub_product_type
			left join po_sub_product_type_lang psptl on psptl.sub_product_type_id = pspt.sub_product_type_id 
				and lower(psptl.language_code) = lower(p_lin_id)
left join po_pr_detail b on b.pr_master_id = a.pr_master_id 
	left join db_list_value_lang p_List_Value_Product_Type  on p_List_Value_Product_Type.group_code = 'PoProductType' 
		and p_List_Value_Product_Type.value = p_product_type 
		and lower(p_List_Value_Product_Type.language_code) = lower(p_lin_id)
	left join db_organization do2Ps on do2Ps.company_code = p_company_code
		and do2Ps.organization_code = p_s_div
	left join db_organization do2Pe on do2Pe.company_code = p_company_code
		and do2Pe.organization_code = p_e_div
where a.company_code = p_company_code
	and a.doc_type = p_doc_type
	and o.organization_code_display between  COALESCE(do2Ps.organization_code_display ,o.organization_code_display)
					and COALESCE(do2Pe.organization_code_display ,o.organization_code_display)  
	and date(a.pr_date) BETWEEN to_date(COALESCE(p_s_po_date, '01/01/1000'),'DD/MM/YYYY') 
						AND to_date(COALESCE(p_e_po_date,'31/12/9999' ), 'DD/MM/YYYY')
	and a.product_type  = COALESCE(p_product_type,a.product_type)
	and exists (select 'X' from su_user_organization su
                        where su.user_id = p_User_Id
                        and su.company_code = p_company_code
                        and su.organization_code = a.div_code
                        and coalesce(cast(su.start_effective_date as date), current_date) <= current_date
                        and coalesce(cast(su.end_effective_date as date), current_date) >= current_date)
GROUP BY 
    a.company_code, 
    a.pr_date, 
    a.sub_product_type, 
    psptl.sub_product_name, 
    a.div_code, 
    o.organization_code_display, 
    ol.organization_name, 
    get_product_code(p_lin_id, b.product_type, b.product_id::integer, b.fa_type_id::integer, b.fa_mkind_id::integer), 
    get_product_name(p_lin_id, b.product_type, b.product_id::integer, b.fa_type_id::integer, b.fa_mkind_id::integer), 
    b.qty, 
    get_ums_code(p_lin_id, b.product_type, b.ums_id::integer), 
    get_ums_name(p_lin_id, b.product_type, b.ums_id::integer), 
    b.unit_price, 
    b.amt, 
    p_List_Value_Product_Type.value_text, 
    do2Ps.organization_code_display, 
    do2Pe.organization_code_display
order by date(a.pr_date),a.SUB_PRODUCT_TYPE,
			get_product_code(p_lin_id, b.product_type, b.product_id::integer, b.fa_type_id::integer, b.fa_mkind_id::integer);

    
END;
$function$
;
