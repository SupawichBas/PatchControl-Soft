drop function report_pood02_sub_detail;

CREATE OR REPLACE FUNCTION erp.report_pood02_sub_detail(p_lin_id character varying, p_pr_master_id integer, p_atv_id integer)
 RETURNS TABLE(pr_master_id integer, company_code character varying, pr_no character varying, total_vat_amt numeric, total_amt numeric, total_non_vat numeric, bg_bf_amt numeric, bg_bal_amt numeric, vat_rate character varying, pr_detail_id integer, seq numeric, product_code character varying, product_name character varying, qty numeric, ums_code character varying, ums_name character varying, unit_price numeric, amt numeric, detail_remark character varying, pr_set_id integer, set_seq numeric, set_product_code character varying, set_product_name character varying, set_qty numeric, set_ums character varying, set_ums_name character varying, set_unit_price numeric, set_amt numeric, set_remark character varying, baht_text character varying, forward_id character varying, bf_amt numeric, bel_amt numeric, pr_set_running_no integer, atv_id integer, pr_budget_id integer, non_vat_amt numeric, vat_amt numeric, total_amt_detail numeric, pr_detail_running_no integer, group_atv_id integer, sum_amt_pr_detail numeric, sum_amt_pr_detail_baht_text character varying)
 LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN QUERY
WITH var AS (
    SELECT
		a.pr_master_id::integer as pr_master_id,
		a.company_code::character varying AS company_code,
		a.pr_no::character varying AS pr_no,
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
		COALESCE(b.gs_aft_disc, 0)::numeric AS amt,
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
        ROW_NUMBER() OVER (PARTITION BY va.atv_id, b.pr_detail_id ORDER BY COALESCE(c.set_seq, c.pr_set_id))::integer AS pr_set_running_no,
        va.atv_id::integer AS atv_id,
		ppb.pr_budget_id::integer AS pr_budget_id,
		coalesce(coalesce(b.amt,0) - coalesce(b.vat_amt,0),0)::numeric AS non_vat_amt,
		coalesce(b.vat_amt,0)::numeric AS vat_amt,
		coalesce(b.amt,0)::numeric AS total_amt_detail
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
			left join db_employee_name(p_lin_id) deh on deh.emp_id = a.head_emp_id 
			left join db_list_value_lang dlvl  on dlvl.group_code = 'PoProductType' 
					and dlvl.value = a.product_type  
					and lower(dlvl.language_code) = lower(p_lin_id)
			left join po_method pm on pm.method_id = a.pr_method_id 
					left join po_method_lang pml on pml.method_id = pm.method_id
							and lower(pml.language_code) = lower(p_lin_id)
			left join db_employee_name(p_lin_id) deapprove on deapprove.emp_id = a.approve_id 
			left join db_employee_name(p_lin_id) surveyor on surveyor.emp_id = a.surveyor_emp_id 
            left join db_employee_name(p_lin_id) deapprovelevel1 on deapprovelevel1.emp_id = a.pre_approve_id_level1 
	left join po_pr_detail b on b.pr_master_id = a.pr_master_id 
			left join po_pr_budget ppb on ppb.pr_detail_id = b.pr_detail_id 
					-- and ppb.seq = 1
					-- and ppb.bg_seq = 1
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
	and coalesce(va.atv_id,0) = coalesce(p_atv_id,0)
),
sum_amt AS (
    SELECT t.atv_id, SUM(t.total_amt_detail)::numeric AS sum_amt_pr_detail
    FROM (
        SELECT DISTINCT var.atv_id, var.pr_detail_id, var.total_amt_detail
        FROM var
    ) t
    GROUP BY t.atv_id
)
SELECT
    v.*,
    DENSE_RANK() OVER (ORDER BY v.atv_id, v.pr_detail_id)::integer AS pr_detail_running_no,
    DENSE_RANK() OVER (ORDER BY v.atv_id)::integer AS group_atv_id,
    coalesce(s.sum_amt_pr_detail,0)::numeric AS sum_amt_pr_detail,
    po_baht_text(coalesce(s.sum_amt_pr_detail,0))::character varying AS sum_amt_pr_detail_baht_text
FROM var v
LEFT JOIN sum_amt s ON coalesce(v.atv_id,0) = coalesce(s.atv_id,0)
ORDER BY v.pr_no, v.atv_id, v.pr_detail_id, v.pr_set_running_no;
END;
$function$
;
