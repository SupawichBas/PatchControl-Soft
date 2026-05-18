drop function report_porp12;

CREATE OR REPLACE FUNCTION erp.report_porp12(
	p_lin_id character varying,
	p_company_code character varying,
	p_pr_ref_no character varying,
	p_contract_code_egp character varying,
	p_ap_member_id integer,
	p_start_div character varying,
	p_end_div character varying,
	p_start_date character varying,
	p_end_date character varying,
	p_user_id integer)
RETURNS TABLE (
    tor_master_id integer,
    company_code character varying,
    start_div character varying,         -- หน่วยงานจัดซื้อจัดจ้าง
    end_div character varying,           -- หน่วยงานจัดซื้อจัดจ้าง ถึง
    ref_div_code character varying,
    ref_div_name character varying,      -- หน่วยงานจัดซื้อจัดจ้าง
    tor_no character varying,            -- การจัดทำรายละเอียดคุณลักษณะของพัสดุและกำหนดราคากลาง
    pc_no character varying,             -- การจัดทำรายงานขอซื้อขอจ้าง
    pr_no character varying,             -- การจัดทำรายงานผลพิจารณาและขออนุมัติจัดซื้อจัดจ้าง
    pr_ref_no character varying,         -- เลขที่หนังสือ (ตัวกรอง เลขที่หนังสือ)
    po_no character varying,             -- การบริหารสัญญา/ใบสั่งซื้อสั่งจ้าง
    contract_code_egp character varying, -- เลขที่คุมสัญญา (ตัวกรอง เลขที่คุมสัญญา)
    ap_member_id integer,                -- Id ผู้ขายผู้รับจ้าง
    member_name character varying,       -- ผู้ขายผู้รับจ้าง (ตัวกรอง ผู้ขายผู้รับจ้าง)
    po_co_subject character varying,     -- เรื่อง
    po_co_total_amt numeric,             -- มูลค่า
    po_co_period integer,                -- งวดงาน
    re_total_amt numeric,                -- จำนวนเงิน
    po_co_end_due_date character varying,-- วันที่ครบกำหนดส่งมอบ
    deliver_date character varying,      -- วันที่ตรวจรับ
    receive_no character varying,        -- เลขที่ตรวจรับ
    election_type_id character varying,  -- แหล่งเงิน
    atv_name character varying,          -- รหัสกิจกรรม
    usage_id character varying           -- เลขที่เบิกจ่าย
)
 LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN QUERY
select  tor.tor_master_id::integer as tor_master_id,
		tor.company_code::character varying as company_code,
		(select t.organization_code_display
			from db_organization t
			where t.company_code = tor.company_code
			and t.organization_code = p_start_div)::character varying as start_div,--หน่วยงานจัดซื้อจัดจ้าง
		(select t.organization_code_display
			from db_organization t
			where t.company_code = tor.company_code
			and t.organization_code = p_end_div)::character varying as end_div,--หน่วยงานจัดซื้อจัดจ้าง ถึง
		tor.ref_div_code::character varying as ref_div_code,
		dol.organization_name::character varying as ref_div_name,--หน่วยงานจัดซื้อจัดจ้าง
		tor.tor_no::character varying as tor_no  , --การจัดทำรายละเอียดคุณลักษณะของพัสดุและกำหนดราคากลาง
        pc.procurement_no::character varying as pc_no , --การจัดทำรายงานขอซื้อขอจ้าง
        pr.pr_no::character varying as pr_no ,--การจัดทำรายงานผลพิจารณาและขออนุมัติจัดซื้อจัดจ้าง
        pr.ref_no::character varying as pr_ref_no,--เลขที่หนังสือ (ตัวกรอง เลขที่หนังสือ)
        po_co.po_no::character varying as po_no ,--การบริหารสัญญา/ใบสั่งซื้อสั่งจ้าง
        po_co.contract_code_egp::character varying as contract_code_egp,--เลขที่คุมสัญญา (ตัวกรอง เลขที่คุมสัญญา)
        po_co.ap_member_id::integer as ap_member_id,--Id ผู้ขายผู้รับจ้าง
        aml.full_name::character varying as member_name,--ผู้ขายผู้รับจ้าง (ตัวกรอง ผู้ขายผู้รับจ้าง)
        po_co.subject::character varying as po_co_subject,--เรื่อง
        po_co.total_amt::numeric as po_co_total_amt,--มูลค่า
        ppopm."period"::integer as po_co_period,--งวดงาน
        re.total_amt::numeric as re_total_amt,--จำนวนเงิน
        po_format_date_for_report(ppopm.end_due_date::date,p_lin_id)::character varying as po_co_end_due_date , --วันที่ครบกำหนดส่งมอบ
        po_format_date_for_report(re.deliver_date::date,p_lin_id)::character varying as deliver_date , --วันที่ตรวจรับ
        re.receive_no::character varying as receive_no ,--เลขที่ตรวจรับ
        (select pfsl.fsource_name from po_receive_detail prd
        		left join po_receive_budget prb on prd.receive_detail_id = prb.receive_detail_id
        		left join pl_fund_sources pfs on prb.fsource_id = pfs.fsource_id 
				left join pl_fund_sources_lang pfsl on pfs.fsource_id = pfsl.fsource_id
				and lower(pfsl.language_code) = lower(p_lin_id)
        		where prd.receive_master_id = re.receive_master_id 
        		limit 1)::character varying as election_type_id,--แหล่งเงิน
        (select vmpa.atv_name from po_receive_detail prd
        		left join po_receive_budget prb on prd.receive_detail_id = prb.receive_detail_id
        		left join vwpl_activity vmpa on prb.atv_id = vmpa.atv_id
        				and lower(vmpa.language_code) = lower(p_lin_id)
        		where prd.receive_master_id = re.receive_master_id 
        		limit 1)::character varying as atv_name,--รหัสกิจกรรม
        bum.usage_id::character varying  as usage_id --เลขที่เบิกจ่าย
from  po_tor_master tor
left join db_organization_lang dol on dol.company_code = tor.company_code 
		and dol.organization_code = tor.ref_div_code
		and lower(dol.language_code) = lower(p_lin_id)
--PC
left join po_procurement_master pc on tor.tor_no  = pc.ref_doc_no
		and pc.status not in ('C','D','PC')
--PR
left join po_pr_master pr on pr.ref_doc_no = pc.procurement_no
		and pr.status not in ('C','D','PC')
--PO CO
left join po_pur_ord_master po_co on po_co.ref_doc_no  = pr.pr_no
		and po_co.status not in ('C','D','PC')
left join po_pur_ord_period_master ppopm on po_co.pur_ord_master_id = ppopm.pur_ord_master_id 
left join ap_member_lang aml on aml.ap_member_id = po_co.ap_member_id 
		and lower(aml.language_code) = lower(p_lin_id)
--RE
left join po_receive_master re on re.pr_no  = pr.pr_no
		and re.status not in ('C','PC')
--BG
left join bg_usage_master bum on bum.pr_no  = pr.pr_no
where tor.company_code = p_company_code
and concat(pr.ref_no,'') ilike concat('%',p_pr_ref_no,'%')
and concat(po_co.contract_code_egp,'') ilike concat('%',p_contract_code_egp,'%')
and coalesce(po_co.ap_member_id,1) = coalesce(p_ap_member_id,po_co.ap_member_id,1)
and tor.ref_div_code between  COALESCE(p_start_div ,tor.ref_div_code)
				and COALESCE(p_end_div ,tor.ref_div_code)
and (
    po_co.po_date IS NULL 
    OR 
    date(po_co.po_date) BETWEEN to_date(COALESCE(p_start_date, '01/01/1000'), 'DD/MM/YYYY') 
                           AND to_date(COALESCE(p_end_date, '31/12/9999'), 'DD/MM/YYYY')
	)
and tor.status not in ('C','D','PC')
and exists (select 'X' from su_user_organization su
                    where concat(su.user_id)= concat(p_user_id)
                    and su.company_code = p_company_code
                    and su.organization_code = tor.div_code
                    and coalesce(cast(su.start_effective_date as date), current_date) <= current_date
                    and coalesce(cast(su.end_effective_date as date), current_date) >= current_date)
order by tor.ref_div_code, pr.pr_no, po_co.po_no, re.receive_no,ppopm."period";
END;
$function$
;





