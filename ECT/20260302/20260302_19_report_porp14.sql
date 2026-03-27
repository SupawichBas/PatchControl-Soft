-- DROP FUNCTION erp.report_porp14;

CREATE OR REPLACE FUNCTION erp.report_porp14(p_lin_id character varying, p_company_code character varying, p_start_div character varying, p_end_div character varying, p_start_no character varying, p_end_no character varying, p_start_date character varying, p_end_date character varying, p_sub_product_type character varying, p_status character varying, p_user_id integer)
 RETURNS TABLE(company_code character varying, procurement_master_id integer, start_div character varying, end_div character varying, sub_product_type_code character varying, status_name character varying, group_date date, procurement_no character varying, ref_div_code_name character varying, procurement_date_format character varying, subject character varying, ref_doc_no character varying, sub_product_name character varying, procurement_detail_id integer, product_code character varying, product_name character varying, remark character varying, qty numeric, ums_name character varying, unit_price numeric, amt numeric)
 LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN QUERY
select a.company_code::character varying as company_code
	,a.procurement_master_id::integer as procurement_master_id
	,(select t.organization_code_display
		from db_organization t
		where t.company_code = a.company_code
		and t.organization_code = p_start_div)::character varying as start_div
	,(select t.organization_code_display
		from db_organization t
		where t.company_code = a.company_code
		and t.organization_code = p_end_div)::character varying as end_div
	,a.sub_product_type::character varying AS sub_product_type_code
	,statusPC.value_text::character varying as status_name--สถานะ
	,a.procurement_date::date as group_date--group-date
	,a.procurement_no::character varying as procurement_no--group-no
	,(select concat(t.organization_code_display,' ',tl.organization_name)
		from db_organization t
		left join db_organization_lang tl on t.company_code = tl.company_code
				and t.organization_code = tl.organization_code
				and lower(tl.language_code) = lower(p_lin_id)
		where t.company_code = a.company_code
		and t.organization_code = a.ref_div_code)::character varying as ref_div_code_name--หน่วยงานจัดซื้อ/จัดจ้าง
	,po_format_date_for_report(a.procurement_date::date, p_lin_id)::character varying as procurement_date_format--วันที่เอกสาร
	,a.subject::character varying as subject--เรื่อง
	,a.ref_doc_no::character varying as ref_doc_no--เลขที่การแต่งตั้งผู้รับผิดชอบในการจัดทำ TOR
	,psptl.sub_product_name::character varying AS sub_product_name--ประเภทรายการขอซื้อ/จ้าง
	--detail
	,b.procurement_detail_id::integer as procurement_detail_id
    ,get_product_code(p_lin_id, b.product_type, b.product_id::integer, b.fa_type_id::integer, b.fa_mkind_id::integer)::character varying AS product_code--รหัสสินค้า
    ,get_product_name(p_lin_id, b.product_type, b.product_id::integer, b.fa_type_id::integer, b.fa_mkind_id::integer)::character varying AS product_name--ชื่อสินค้า
	,b.remark::character varying AS remark--รายละเอียด
	,COALESCE(b.qty,0)::numeric as QTY--จำนวน
    ,get_ums_name(p_lin_id, b.product_type, b.ums_id::integer)::character varying AS ums_name--หน่วยนับ
	,COALESCE(b.unit_price,0)::numeric as unit_price--ราคาต่อหน่วย
	,COALESCE(b.amt,0)::numeric as amt--จำนวนเงิน
from po_procurement_master a
left join po_procurement_detail b on a.procurement_master_id = b.procurement_master_id
left join po_sub_product_type pspt on pspt.sub_product_type_code = a.sub_product_type 
		left join po_sub_product_type_lang psptl on pspt.sub_product_type_id = psptl.sub_product_type_id 
				and lower(psptl.language_code) = lower(p_lin_id)
left join db_list_value_lang statusPC on statusPC.group_code = 'PoStatusPC' 
		and statusPC.value = a.status
		and lower(statusPC.language_code) = lower(p_lin_id)
where a.company_code = p_company_code
and a.ref_div_code between  COALESCE(p_start_div ,a.ref_div_code)
				and COALESCE(p_end_div ,a.ref_div_code)
and a.procurement_no between  COALESCE(p_start_no ,a.procurement_no)
				and COALESCE(p_end_no ,a.procurement_no)
and date(a.procurement_date) BETWEEN to_date(COALESCE(p_start_date, '01/01/1000'),'DD/MM/YYYY') 
				AND to_date(COALESCE(p_end_date,'31/12/9999' ), 'DD/MM/YYYY')
and a.sub_product_type = COALESCE(p_sub_product_type,a.sub_product_type)
and a.status = COALESCE(p_status,a.status)
and exists (select 'X' from su_user_organization su
                    where concat(su.user_id)= concat(p_user_id)
                    and su.company_code = p_company_code
                    and su.organization_code = a.div_code
                    and coalesce(cast(su.start_effective_date as date), current_date) <= current_date
                    and coalesce(cast(su.end_effective_date as date), current_date) >= current_date)
order by date(a.procurement_date),
		a.procurement_no,
		b.procurement_detail_id;
END;
$function$
;
