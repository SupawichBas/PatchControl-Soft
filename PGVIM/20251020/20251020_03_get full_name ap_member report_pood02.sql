--get full_name ap_member report_pood02
drop function report_pood02;

CREATE OR REPLACE FUNCTION erp.report_pood02(p_lin_id character varying, p_pr_master_id integer)
 RETURNS TABLE(pr_master_id integer, company_code character varying, div_code character varying, div_code_display character varying, div_name character varying, div_code_name character varying, ref_no character varying, pr_no character varying, product_type character varying, product_type_name character varying, pr_date date, pr_date_day character varying, pr_date_month character varying, pr_date_year character varying, attn_to character varying, owner_id integer, recipient_owner_image character varying, owner_name character varying, ref_div_code character varying, ref_div_code_display character varying, ref_div_name character varying, ref_div_code_name character varying, cf_ref_div_code character varying, cf_ref_div_code_display character varying, cf_ref_div_name character varying, cf_ref_div_code_name character varying, main_div character varying, main_div_code_display character varying, main_div_name character varying, main_div_code_name character varying, budget_year integer, fund_code_name character varying, fsource_code_name character varying, prod_code_name character varying, bg_sec_code_name character varying, atv_code_name character varying, maingfmis character varying, gfmis character varying, pr_method_id integer, method_name character varying, purpose character varying, remark character varying, total_vat_amt numeric, total_amt numeric, total_non_vat numeric, bg_bf_amt numeric, bg_bal_amt numeric, vat_rate character varying, pr_detail_id integer, seq numeric, product_code character varying, product_name character varying, qty numeric, ums_code character varying, ums_name character varying, unit_price numeric, amt numeric, detail_remark character varying, pr_set_id integer, set_seq numeric, set_product_code character varying, set_product_name character varying, set_qty numeric, set_ums character varying, set_ums_name character varying, set_unit_price numeric, set_amt numeric, set_remark character varying, baht_text character varying, forward_id character varying, bf_amt numeric, bel_amt numeric, recipient_head_image character varying, head_emp_name character varying, head_posi character varying, pre_approve_level1_head_image character varying, pre_approve_level1_emp_name character varying, pre_approve_posi_level1 character varying, recipient_approve_image character varying, approve_name character varying, approve_posi character varying, pr_set_running_no integer, surveyor_name character varying, surveyor_image character varying, ap_name character varying, status_show_image boolean, is_show_purchase boolean, is_show_hire boolean, status_show_recipient_head_image boolean, status_show_pre_approve_level1_head_image boolean, status_show_recipient_approve_image boolean, approve_date_head_emp_id character varying, approve_date_pre_approve_id_level1 character varying, approve_date_approve_id character varying, ref_doc_no character varying, pr_detail_running_no integer)
 LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN QUERY
SELECT var.*,
        DENSE_RANK() OVER (ORDER BY var.pr_detail_id)::integer AS pr_detail_running_no
FROM ( SELECT
		a.pr_master_id::integer as pr_master_id,
		a.company_code::character varying AS company_code,
		a.div_code::character varying AS div_code,
		o.organization_code_display::character varying AS div_code_display,
		ol.organization_name::character varying AS div_name,
		concat(o.organization_code_display,' ',ol.organization_name)::character varying AS div_code_name,
		a.ref_no::character varying AS ref_no,
		a.pr_no::character varying AS pr_no,
		a.product_type::character varying AS product_type,
		dlvl.value_text::character varying AS product_type_name,
		a.pr_date::date as pr_date,
		concat(to_char(a.pr_date, 'FMDD'))::character varying AS pr_date_day,
		Monthlang.value_text ::character varying AS pr_date_month,
		case when a.pr_date is not null then 
					case p_lin_id when 'TH' then 
							to_char(extract(year from a.pr_date) +543 ,'FM9999')
						else
							to_char(extract(year from a.pr_date) ,'FM9999')
						end
					end::character varying as pr_date_year,
		a.attn_to::character varying AS attn_to,
		a."owner"::integer as owner_id,
		case when deowner.personal_id is not null and deowner.signature_image_id is not null
				then concat((select sp.parameter_value  from su_parameter sp 
								where sp.parameter_group_code = 'ContentPath'
								and sp.parameter_code = 'SignatureURL')
								,'?PersonalId=',deowner.personal_id,'&ContentId=',deowner.signature_image_id)
				else null end::character varying as recipient_owner_image,
		deowner.emp_name::character varying AS owner_name,
		a.ref_div_code::character varying AS ref_div_code,
		oref.organization_code_display::character varying AS ref_div_code_display,
--		olref.organization_name::character varying AS ref_div_name,
		get_organization_hierarchy(p_lin_id, a.company_code, oref.organization_code)::character varying AS ref_div_name,
		concat(oref.organization_code_display,' ',olref.organization_name)::character varying AS ref_div_code_name,
		orefcf.organization_code ::character varying AS cf_ref_div_code,
		orefcf.organization_code_display::character varying AS cf_ref_div_code_display,
		olrefcf.organization_name::character varying AS cf_ref_div_name,
		concat(orefcf.organization_code_display,' ',olrefcf.organization_name)::character varying AS cf_ref_div_code_name,
		omain.organization_code ::character varying AS main_div,
		omain.organization_code_display::character varying AS main_div_code_display,
		omainl.organization_name::character varying AS main_div_name,
		concat(orefcf.organization_code_display,' ',omainl.organization_name)::character varying AS main_div_code_name,
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
		a.pr_method_id::integer AS pr_method_id,
		pml.method_name::character varying AS method_name,
		a.purpose::character varying AS PURPOSE,
		a.remark ::character varying AS remark,
		coalesce(a.total_vat_amt,0)::numeric as total_vat_amt,
		coalesce(a.total_amt,0)::numeric as total_amt,
		coalesce(coalesce(a.total_amt,0) - coalesce(a.total_vat_amt,0),0)::numeric as total_non_vat,
        coalesce(coalesce(a.bg_bf_amt,0) + coalesce(a.total_amt,0),0)::numeric as bg_bf_amt,
		coalesce(a.bg_bf_amt,0)::numeric as bg_bal_amt,
		TO_CHAR(coalesce(a.vat_rate,0),'fm990.00')::character varying as  VAT_RATE,
		b.pr_detail_id::integer as pr_detail_id,
		COALESCE(b.seq, 0)::numeric as seq,
		get_product_code(p_lin_id, b.product_type, b.product_id::integer, b.fa_type_id::integer, b.fa_mkind_id::integer)::character varying AS product_code,
        get_product_name(p_lin_id, b.product_type, b.product_id::integer, b.fa_type_id::integer, b.fa_mkind_id::integer)::character varying AS product_name,
		COALESCE(b.qty,0)::numeric as QTY,
		get_ums_code(p_lin_id, b.product_type, b.ums_id::integer)::character varying AS ums_code,
        get_ums_name(p_lin_id, b.product_type, b.ums_id::integer)::character varying AS ums_name,
		COALESCE(b.unit_price, 0)::numeric AS unit_price,
		COALESCE(b.amt, 0)::numeric AS amt,
		b.remark::character varying AS detail_remark,
		c.pr_set_id::integer AS pr_set_id,
		coalesce(c.set_seq)::numeric AS set_seq,
		get_product_code(p_lin_id, c.product_type, c.product_id::integer, c.fa_type_id::integer, c.fa_mkind_id::integer)::character varying AS set_product_code,
        get_product_name(p_lin_id, c.product_type, c.product_id::integer, c.fa_type_id::integer, c.fa_mkind_id::integer)::character varying AS set_product_name,
        c.qty::numeric AS set_qty,
		get_ums_code(p_lin_id, c.product_type, c.ums_id::integer)::character varying AS set_ums,
        get_ums_name(p_lin_id, c.product_type, c.ums_id::integer)::character varying AS set_ums_name,
        COALESCE(c.unit_price, 0)::numeric AS set_unit_price,
		COALESCE(c.amt, 0)::numeric AS set_amt,
		c.remark::character varying AS set_remark,
		erp.fn_baht_text(coalesce(a.total_amt,0))::character varying AS baht_text,
		a.forward_id::character varying AS FORWARD_ID,
		COALESCE(bfb.bf_amt , 0)::numeric AS BF_AMT,
		COALESCE(bfb.bal_amt  , 0)::numeric AS BEL_AMT,
		case when deh.personal_id is not null and deh.signature_image_id is not null
				then concat((select sp.parameter_value  from su_parameter sp 
								where sp.parameter_group_code = 'ContentPath'
								and sp.parameter_code = 'SignatureURL')
								,'?PersonalId=',deh.personal_id,'&ContentId=',deh.signature_image_id)
				else null end::character varying as recipient_head_image,
		deh.emp_name::character varying AS  head_emp_name,
		a.head_posi::character varying AS head_posi,
		--pre_approve_posi_level1
		case when deapprovelevel1.personal_id is not null and deapprovelevel1.signature_image_id is not null
			then concat((select sp.parameter_value  from su_parameter sp 
							where sp.parameter_group_code = 'ContentPath'
							and sp.parameter_code = 'SignatureURL')
							,'?PersonalId=',deapprovelevel1.personal_id,'&ContentId=',deapprovelevel1.signature_image_id)
			else null end::character varying as pre_approve_level1_head_image,
        deapprovelevel1.emp_name::character varying AS pre_approve_level1_emp_name,
        a.pre_approve_posi_level1::character varying AS pre_approve_posi_level1,
		--
		case when deapprove.personal_id is not null and deapprove.signature_image_id is not null
				then concat((select sp.parameter_value  from su_parameter sp 
								where sp.parameter_group_code = 'ContentPath'
								and sp.parameter_code = 'SignatureURL')
								,'?PersonalId=',deapprove.personal_id,'&ContentId=',deapprove.signature_image_id)
				else null end::character varying as recipient_approve_image,
		deapprove.emp_name::character varying AS approve_name,
		a.approve_posi ::character varying AS approve_posi,
        ROW_NUMBER() OVER (PARTITION BY a.pr_master_id, b.pr_detail_id ORDER BY c.pr_set_id)::integer AS pr_set_running_no,
        surveyor.emp_name::character varying AS surveyor_name,
        case when surveyor.personal_id is not null and surveyor.signature_image_id is not null
				then concat((select sp.parameter_value  from su_parameter sp 
								where sp.parameter_group_code = 'ContentPath'
								and sp.parameter_code = 'SignatureURL')
								,'?PersonalId=',surveyor.personal_id,'&ContentId=',surveyor.signature_image_id)
				else null end::character varying as surveyor_image,
		(select concat(am.ap_code,' ',coalesce(aml.full_name, coalesce(aml2.prefix_abbreviation, aml2.prefix_name), ' ', aml.first_name, ' ', aml.last_name))
			from po_pr_supplier pps 
			left join ap_member am on pps.ap_member_id = am.ap_member_id
					left join ap_member_lang aml on am.ap_member_id = aml.ap_member_id 
							and lower(aml.language_code) = lower(p_lin_id)
					left join db_prefix_lang aml2 on aml2.prefix_id = aml.prefix_id 
							and lower(aml2.language_code) = lower(p_lin_id)
			where pps.pr_master_id = a.pr_master_id limit 1)::character varying as ap_name,
		case when a.status in ('W','A','R','E') then true
		else false end::bool as status_show_image,
		(select case when psdt.order_type = 'PO' then true
					else false end 
			from po_sub_doc_type psdt 
			where psdt.sub_doc_type = a.sub_doc_type)::bool as is_show_purchase,
		(select case when psdt.order_type in ('JO','RO') then true
					else false end
			from po_sub_doc_type psdt 
			where psdt.sub_doc_type = a.sub_doc_type)::bool as is_show_hire,
		case when po_get_show_image(a.company_code,a.doc_type,a.pr_no,a.head_emp_id) = 'Y' then true
		else false end::bool as status_show_recipient_head_image,
		case when po_get_show_image(a.company_code,a.doc_type,a.pr_no,a.pre_approve_id_level1) = 'Y' then true
		else false end::bool as status_show_pre_approve_level1_head_image,
		case when po_get_show_image(a.company_code,a.doc_type,a.pr_no,a.approve_id) = 'Y' then true
		else false end::bool as status_show_recipient_approve_image,
		erp.po_get_fromat_approve_date((select pwf.approve_date from po_work_flow pwf 
											where pwf.company_code = a.company_code 
											and pwf.doc_type = a.doc_type 
											and pwf.doc_no = a.pr_no 
											and pwf.approve_by_id = a.head_emp_id)::date)::character varying AS approve_date_head_emp_id,
		erp.po_get_fromat_approve_date((select pwf.approve_date from po_work_flow pwf 
											where pwf.company_code = a.company_code 
											and pwf.doc_type = a.doc_type 
											and pwf.doc_no = a.pr_no 
											and pwf.approve_by_id = a.pre_approve_id_level1)::date)::character varying AS approve_date_pre_approve_id_level1,
		erp.po_get_fromat_approve_date((select pwf.approve_date from po_work_flow pwf 
											where pwf.company_code = a.company_code 
											and pwf.doc_type = a.doc_type 
											and pwf.doc_no = a.pr_no 
											and pwf.approve_by_id = a.approve_id)::date)::character varying AS approve_date_approve_id,
		(select string_agg(ppr.ref_doc_no, ', ')  from po_pr_ref ppr where ppr.pr_master_id = a.pr_master_id)::character varying AS ref_doc_no
	from po_pr_master a
			left join db_organization o on a.company_code = o.company_code 
			  		and a.div_code = o.organization_code
					left join db_organization_lang ol on ol.company_code = o.company_code 
				            and ol.organization_code = o.organization_code 
				            and lower(ol.language_code) = lower(p_lin_id)
			left join db_list_value_lang Monthlang  on Monthlang.group_code = 'Month' 
					and Monthlang.value = TO_CHAR(A.PR_DATE, 'FMMM')
					and lower(Monthlang.language_code) = lower(p_lin_id)
			left join db_organization oref on a.company_code = oref.company_code 
			  		and a.div_code = oref.organization_code
					left join db_organization_lang olref on olref.company_code = oref.company_code 
				            and olref.organization_code = oref.organization_code
				            and lower(olref.language_code) = lower(p_lin_id)
			left join db_organization orefcf on orefcf.company_code = oref.company_code 
			  		and orefcf.organization_code = oref.parent_organization_code 
					left join db_organization_lang olrefcf on olrefcf.company_code = orefcf.company_code 
				            and olrefcf.organization_code = orefcf.organization_code
				            and lower(olrefcf.language_code) = lower(p_lin_id)
			left join db_organization omain on a.company_code = omain.company_code 
			  		and omain.organization_code = a.main_div
					left join db_organization_lang omainl on omainl.company_code = omain.company_code 
				            and omainl.organization_code = omain.organization_code 
				            and lower(omainl.language_code) = lower(p_lin_id)
			left join db_employee_name(p_lin_id) deowner on deowner.emp_id = a.owner
					
					-- AND current_date BETWEEN COALESCE(po_convert_thai_to_gregorian(deowner.work_date::Date), current_date)
					-- 		AND COALESCE(po_convert_thai_to_gregorian(deowner.turnover_date::Date), current_date)

			left join db_employee_name(p_lin_id) deh on deh.emp_id = a.head_emp_id 
					
					-- AND current_date BETWEEN COALESCE(po_convert_thai_to_gregorian(deh.work_date::Date), current_date)
					-- 		AND COALESCE(po_convert_thai_to_gregorian(deh.turnover_date::Date), current_date)

			left join db_list_value_lang dlvl  on dlvl.group_code = 'PoProductType' 
					and dlvl.value = a.product_type  
					and lower(dlvl.language_code) = lower(p_lin_id)
			left join po_method pm on pm.method_id = a.pr_method_id 
					left join po_method_lang pml on pml.method_id = pm.method_id
							and lower(pml.language_code) = lower(p_lin_id)
			left join db_employee_name(p_lin_id) deapprove on deapprove.emp_id = a.approve_id 
					
					-- AND current_date BETWEEN COALESCE(po_convert_thai_to_gregorian(deapprove.work_date::Date), current_date)
					-- 		AND COALESCE(po_convert_thai_to_gregorian(deapprove.turnover_date::Date), current_date)
                                            
			left join db_employee_name(p_lin_id) surveyor on surveyor.emp_id = a.surveyor_emp_id 
					
					-- AND current_date BETWEEN COALESCE(po_convert_thai_to_gregorian(surveyor.work_date::Date), current_date)
					-- 		AND COALESCE(po_convert_thai_to_gregorian(surveyor.turnover_date::Date), current_date)
            left join db_employee_name(p_lin_id) deapprovelevel1 on deapprovelevel1.emp_id = a.pre_approve_id_level1 

	left join po_pr_detail b on b.pr_master_id = a.pr_master_id 
			left join po_pr_budget ppb on ppb.pr_detail_id = b.pr_detail_id 
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
	left join po_pr_set c on c.pr_detail_id = b.pr_detail_id 
	where a.pr_master_id = p_pr_master_id
	order by a.pr_no ,b.seq ,c.set_seq
) as var;
    
END;
$function$
;
