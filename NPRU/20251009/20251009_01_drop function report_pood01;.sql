drop function report_pood01;

CREATE OR REPLACE FUNCTION erp.report_pood01(p_lin_id character varying, p_pr_master_id integer)
 RETURNS TABLE(pr_master_id integer, company_code character varying, pr_no character varying, div_code character varying, div_code_display character varying, div_name character varying, ref_no character varying, pr_date date, pr_req_date character varying, subject character varying, attn_to character varying, purpose character varying, bg_div_code character varying, bg_div character varying, budget_year integer, fund_code_name character varying, fsource_code_name character varying, prod_code_name character varying, bg_sec_code_name character varying, atv_code_name character varying, maingfmis character varying, gfmis character varying, product_type_name character varying, complete_day integer, master_remark character varying, seq integer, product_code character varying, product_name character varying, qty numeric, ums_code character varying, ums_name character varying, unit_price numeric, amt numeric, detail_remark character varying, pr_detail_id integer, pr_set_id integer, set_seq integer, set_product_code character varying, set_product_name character varying, set_qty integer, set_ums character varying, set_ums_name character varying, set_unit_price numeric, set_amt numeric, set_remark character varying, forward_id character varying, bf_amt numeric, total_amt numeric, bel_amt numeric, recipient_head_image character varying, head_emp_name character varying, head_posi character varying, recipient_sign_image character varying, sign_name character varying, sign_posi character varying, pr_set_running_no integer, status_show_image boolean, status_show_recipient_sign_image boolean, pr_detail_running_no integer)
 LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN QUERY
SELECT var.*,
        DENSE_RANK() OVER (ORDER BY var.pr_detail_id)::integer AS pr_detail_running_no
FROM ( select a.pr_master_id::integer AS pr_master_id,
        a.company_code::character varying AS company_code,
        a.pr_no::character varying AS pr_no,
        a.div_code::character varying AS div_code,
        o.organization_code_display::character varying AS div_code_display,
        ol.organization_name::character varying AS div_name,
        a.ref_no::character varying AS ref_no,
        a.pr_date::date AS pr_date,
        case when a.pr_date is not null then 
					case p_lin_id when 'TH' then 
							concat(to_char(a.pr_date, 'FMDD') ,' ' ,
							Monthlang.value_text ,' ' ,
							to_char(extract(year from a.pr_date) +543 ,'FM9999'))
						else
							concat(to_char(a.pr_date, 'FMDD') ,' ' ,
							Monthlang.value_text ,' ' ,
							to_char(extract(year from a.pr_date) ,'FM9999'))
						end
					end::character varying as pr_req_date,
        a.subject::character varying AS subject,
        a.ATTN_TO::character varying AS ATTN_TO,
        a.purpose::character varying AS purpose,
        a.bg_div_code::character varying AS bg_div_code,
        CONCAT(obg.organization_code_display, ' ', obgl.organization_name)::character varying AS bg_div,
        a.budget_year::integer AS budget_year,
        CONCAT(pfg.fund_code, ' ', pfgl.fund_name)::character varying AS fund_code_name,
        CONCAT(pfs.fsource_code, ' ', pfsl.fsource_name)::character varying AS fsource_code_name,
        CONCAT(vp.prod_code, ' ', vp.prod_name)::character varying AS prod_code_name,
        CONCAT(pbs.bg_sec_code, ' ', pbsl.bg_sec_name)::character varying AS bg_sec_code_name,
        CONCAT(va.atv_code, ' ', va.atv_name)::character varying AS atv_code_name,
        bgst_find_prod_proj_plan_gf_2(ppb.company_code,
        								ppb.budget_year_control,
        								ppb.budget_id,
        								'GF_ATV' )::character varying as maingfmis,
        bgst_find_bg_code_gf_2(ppb.company_code,
        						ppb.budget_year_control,
        						ppb.budget_id,
        						ppb.sub_section_id,
        						ppb.seq_ord)::character varying AS gfmis,
        dlvl.value_text::character varying AS product_type_name,
        a.complete_day::integer AS complete_day,
        a.remark::character varying AS master_remark,
        b.seq::integer AS seq,
        get_product_code(p_lin_id, b.product_type, b.product_id::integer, b.fa_type_id::integer, b.fa_mkind_id::integer)::character varying AS product_code,
        get_product_name(p_lin_id, b.product_type, b.product_id::integer, b.fa_type_id::integer, b.fa_mkind_id::integer)::character varying AS product_name,
        COALESCE(b.qty, 0)::numeric AS qty,
        get_ums_code(p_lin_id, b.product_type, b.ums_id::integer)::character varying AS ums_code,
        get_ums_name(p_lin_id, b.product_type, b.ums_id::integer)::character varying AS ums_name,
        COALESCE(b.unit_price, 0)::numeric AS unit_price,
        COALESCE(b.amt, 0)::numeric AS amt,
        b.remark::character varying AS detail_remark,
        b.pr_detail_id::integer AS pr_detail_id,
        c.pr_set_id::integer AS pr_set_id,
        c.set_seq::integer AS set_seq,
        get_product_code(p_lin_id, c.product_type, c.product_id::integer, c.fa_type_id::integer, c.fa_mkind_id::integer)::character varying AS set_product_code,
        get_product_name(p_lin_id, c.product_type, c.product_id::integer, c.fa_type_id::integer, c.fa_mkind_id::integer)::character varying AS set_product_name,
        c.qty::integer AS set_qty,
        get_ums_code(p_lin_id, c.product_type, c.ums_id::integer)::character varying AS set_ums,
        get_ums_name(p_lin_id, c.product_type, c.ums_id::integer)::character varying AS set_ums_name,
        COALESCE(c.unit_price, 0)::numeric AS set_unit_price,
        COALESCE(c.amt, 0)::numeric AS set_amt,
        c.remark::character varying AS set_remark,
        a.FORWARD_ID::character varying AS FORWARD_ID,
        COALESCE(bfb.bf_amt, 0)::numeric AS bf_amt,
        COALESCE(a.total_amt, 0)::numeric AS total_amt,
        COALESCE(bfb.bal_amt, 0)::numeric AS bel_amt,
        case when deh.personal_id is not null and deh.signature_image_id is not null
			then concat((select sp.parameter_value  from su_parameter sp 
							where sp.parameter_group_code = 'ContentPath'
							and sp.parameter_code = 'SignatureURL')
							,'?PersonalId=',deh.personal_id,'&ContentId=',deh.signature_image_id)
			else null end::character varying as recipient_head_image,
        deh.emp_name::character varying AS head_emp_name,
        a.head_posi::character varying AS head_posi,
        case when deapprove.personal_id is not null and deapprove.signature_image_id is not null
			then concat((select sp.parameter_value  from su_parameter sp 
							where sp.parameter_group_code = 'ContentPath'
							and sp.parameter_code = 'SignatureURL')
							,'?PersonalId=',deapprove.personal_id,'&ContentId=',deapprove.signature_image_id)
			else null end::character varying as recipient_sign_image,
        deapprove.emp_name::character varying AS  sign_name,
        a.sign_posi::character varying AS sign_posi,
        ROW_NUMBER() OVER (PARTITION BY a.pr_master_id, b.pr_detail_id ORDER BY c.pr_set_id)::integer AS pr_set_running_no,
        case when a.status in ('W','A','R','E') then true
		else false end::bool as status_show_image,
        case when po_get_show_image(a.company_code,a.doc_type,a.pr_no,a.sign_id) = 'Y' then true
		else false end::bool as status_show_recipient_sign_image
	from po_pr_master a
		left join db_list_value_lang Monthlang  on Monthlang.group_code = 'Month' 
				and Monthlang.value = TO_CHAR(A.PR_DATE, 'FMMM')
				and lower(Monthlang.language_code) = lower(p_lin_id)
		left join db_organization o on a.company_code = o.company_code 
		  		and a.div_code = o.organization_code
				left join db_organization_lang ol on ol.company_code = o.company_code 
			            and ol.organization_code = o.organization_code 
			            and lower(ol.language_code) = lower(p_lin_id)
		left join db_organization obg on a.company_code = obg.company_code 
		  		and a.bg_div_code = obg.organization_code
				left join db_organization_lang obgl on obgl.company_code = obg.company_code 
			            and obgl.organization_code = obg.organization_code 
			            and lower(obgl.language_code) = lower(p_lin_id)
		left join db_employee_name(p_lin_id) deapprove on deapprove.emp_id = a.sign_id
--					
--					AND current_date BETWEEN COALESCE(po_convert_thai_to_gregorian(deapprove.work_date::Date), current_date)
--							AND COALESCE(po_convert_thai_to_gregorian(deapprove.turnover_date::Date), current_date)
--											
		left join db_list_value_lang dlvl  on dlvl.group_code = 'PoProductType' 
				and dlvl.value = a.product_type  
				and lower(dlvl.language_code) = lower(p_lin_id)
	left join po_pr_detail b on b.pr_master_id = a.pr_master_id 
		left join po_pr_budget ppb on ppb.pr_detail_id  = b.pr_detail_id 
				and ppb.seq = 1
				and ppb.bg_seq = 1
				left join bg_forward_budget bfb on bfb.budget_type = ppb.forward_type 
						and bfb.fwd_ref_id = ppb.forward_id 
						and bfb.fwd_ref_seq = ppb.forward_seq 
				left join pl_funding  pfg on pfg.fund_id  = ppb.fund_id
				left join pl_funding_lang pfgl on pfgl.fund_id  = ppb.fund_id
						and lower(pfgl.language_code) = lower(p_lin_id)
				left join pl_fund_sources pfs on pfs.fsource_id = ppb.fsource_id 
						left join pl_fund_sources_lang pfsl on pfsl.fsource_id = pfs.fsource_id
								and lower(pfsl.language_code) = lower(p_lin_id)
				left join pl_budget_section pbs on pbs.bg_sec_id = ppb.bg_sec_id
						left join pl_budget_section_lang pbsl on pbsl.bg_sec_id = pbs.bg_sec_id 
								and lower(pbsl.language_code) = lower(p_lin_id)
				left join vwpl_product vp on vp.prod_id = ppb.prod_id 
						and lower(vp.language_code) = lower(p_lin_id)
				left join vwpl_activity va on va.atv_id = ppb.atv_id 
						and lower(va.language_code) = lower(p_lin_id) 
				left join db_employee_name(p_lin_id) deh on deh.emp_id = a.head_emp_id 
--				
--					AND current_date BETWEEN COALESCE(po_convert_thai_to_gregorian(deh.work_date::Date), current_date)
--							AND COALESCE(po_convert_thai_to_gregorian(deh.turnover_date::Date), current_date)
--											
	left join po_pr_set c on c.pr_detail_id = b.pr_detail_id 
	where a.pr_master_id = p_pr_master_id
	order by a.pr_no ,b.seq ,c.set_seq
	) as var;
END;
$function$
;
