-- DROP FUNCTION erp.report_porp10(varchar, varchar, varchar, varchar, varchar, int4);

CREATE OR REPLACE FUNCTION erp.report_porp10(p_company_code character varying, p_lin_id character varying, p_s_div character varying, p_e_div character varying, p_budget_year character varying, p_user_id integer)
 RETURNS TABLE(company_code character varying, pr_no character varying, forward_req_date character varying, bg_div_code character varying, bg_div_name character varying, project character varying, product_name character varying, ums_name character varying, qty character varying, budget_next_year character varying, budget_year character varying, is_purchase character varying, is_hire character varying, pr_method_id integer, is_general_method character varying, is_specific_method character varying, is_design character varying, is_not_design character varying, general_invitation character varying, co_date character varying, delivery_date character varying, fsource_gov boolean, fwd_amt numeric, remark_detail character varying, pr_detail_id integer)
 LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN QUERY
select pr.company_code::character varying as company_code
		,pr.pr_no::character varying as pr_no
		,concat('ปีงบประมาณ พ.ศ. ',to_char(extract(year from a.po_plan_date) + 543, 'FM9999'))::character varying as forward_req_date
	    ,a.div_code::character varying AS bg_div_code
	    ,concat('หน่วยงาน',(select dol.organization_name
	    				from db_organization_lang dol
						where dol.company_code = pr.company_code
						and dol.organization_code = a.div_code
						and dol.language_code = p_lin_id)
				)::character varying AS bg_div_name
	    ,concat(pr.subject)::character varying AS project
	    ,get_product_name(p_lin_id, prd.product_type, prd.product_id::integer, prd.fa_type_id::integer, prd.fa_mkind_id::integer)::character varying AS product_name--รายการ
	    ,get_ums_name(p_lin_id, prd.product_type, prd.ums_id::integer)::character varying as ums_name--หน่วยนับ
		,concat(TO_CHAR(COALESCE(prd.qty,0)::numeric, 'FM99,999,999'))::character varying as qty--จำนวน
	    ,case when lower(a.carry_over) = lower('y') then '/' else ''end::character varying as budget_next_year--งานต่อเนื่องที่ผูกพันงบประมาณปีต่อไป
	    ,case when a.budget_year is not null then concat(a.budget_year + 543) else ''end::character varying as budget_year--งานที่เสร็จภายในปี
	    ,case when lower(a.work_type) = lower('01') then '/' else ''end::character varying as is_purchase--จัดซื้อ
	    ,case when lower(a.work_type) = lower('02') then '/' else ''end::character varying as is_hire--จัดจ้าง
	    ,pr.pr_method_id::integer as pr_method_id--วิธีซื้อจ้าง
	    ,case when pr.pr_method_id <> 4 then '/' else ''end::character varying as is_general_method--วิธีประกาศเชินชวนทั้วไป
	    ,case when pr.pr_method_id = 4 then '/' else ''end::character varying as is_specific_method--วิธีเฉพาะเจาะจง
	    ,concat('/')::character varying as is_design--มี
	    ,concat('')::character varying as is_not_design--ไม่มี
	    ,concat(format_month_year_thai(a.expected_invitation_date::date))::character varying as general_invitation --ประกาศเชิญชวนทั่วไป
	    ,concat(format_month_year_thai(a.expected_contract_sign_date::date))::character varying as co_date --สัญญา
	    ,concat(format_month_year_thai(a.expected_delivery_date::date))::character varying as delivery_date --ส่งมอบ
--		,prd.gs_aft_disc::numeric as gs_aft_disc--งบประมาณที่ได้อนุมัติ
		,pr.fsource_gov::bool as fsource_gov--เงินงบประมาณ
		,a.budget_amount::numeric as fwd_amt--เงินนอกงบประมานหรือเงินสมทบ/งบประมาณที่ได้อนุมัติ/แผนการจ่ายเงิน
		,concat(prd.remark)::character varying as remark_detail--หมายเหตุ
		--
		,prd.pr_detail_id::integer as pr_detail_id
from po_plan_master a
join po_tor_master tpr on tpr.company_code = a.company_code
		and tpr.ref_plan_no = a.po_plan_no
join po_procurement_master pc on pc.company_code = tpr.company_code
		and pc.ref_doc_no = tpr.tor_no
join po_pr_master pr on pr.company_code = pc.company_code
	and pr.ref_doc_no = pc.procurement_no
	left join po_pr_detail prd on pr.pr_master_id = prd.pr_master_id
where 1=1
and a.company_code = p_company_code
and a.div_code between  COALESCE(p_s_div ,a.div_code)
				and COALESCE(p_e_div ,a.div_code)
AND EXISTS (
		    SELECT 'x'
		    FROM db_period_control dpc
		    WHERE dpc.company_code = a.company_code
		      AND concat(dpc.budget_year) = concat(p_budget_year)
		    GROUP BY dpc.company_code, dpc.budget_year
		    HAVING date(a.po_plan_date) BETWEEN date(min(dpc.start_date))
                                  AND date(max(dpc.end_date))
			)
order by a.div_code;
END;
$function$
;
