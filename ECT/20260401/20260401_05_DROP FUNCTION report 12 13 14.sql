DROP FUNCTION erp.report_porp12;
DROP FUNCTION erp.report_porp13;
DROP FUNCTION erp.report_porp14;

--old porp12 is new porp13
CREATE OR REPLACE FUNCTION erp.report_porp13(p_lin_id character varying, p_company_code character varying, p_start_div character varying, p_end_div character varying, p_start_no character varying, p_end_no character varying, p_start_date character varying, p_end_date character varying, p_work_type character varying, p_status character varying, p_estimated_year integer, p_estimated_month character varying, p_user_id integer)
 RETURNS TABLE(company_code character varying, po_plan_id integer, start_div character varying, end_div character varying, status_name character varying, estimated_year character varying, estimated_month character varying, estimated_format_month character varying, po_plan_date character varying, subject character varying, work_type_value character varying, work_type_name character varying, budget_amount numeric, estimated_date character varying, budget_year integer, carry_over character varying, carry_over_name character varying, ref_div_name character varying)
 LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN QUERY
select a.company_code::character varying as company_code
	,a.po_plan_id::integer as po_plan_id
	,(select t.organization_code_display
		from db_organization t
		where t.company_code = a.company_code
		and t.organization_code = p_start_div)::character varying as start_div
	,(select t.organization_code_display
		from db_organization t
		where t.company_code = a.company_code
		and t.organization_code = p_end_div)::character varying as end_div
	,statusPP.value_text::character varying as status_name--สถานะ
	,to_char(extract(year from a.estimated_date) +543 ,'FM9999')::character varying as estimated_year--group ปี (ปีที่คาดว่าจะจัดซื้อจัดจ้าง)
	,TO_CHAR(a.estimated_date, 'FMMM')::character varying as estimated_month--group เดือน
	,po_format_month_date_thai(a.estimated_date::date,p_lin_id)::character varying as estimated_format_month--เดือนที่คาดว่าจะจัดซื้อจัดจ้าง
	,po_format_date_for_report(a.po_plan_date::date,p_lin_id)::character varying as po_plan_date--วันที่เอกสาร
	,a.subject::character varying as subject--เรื่อง
	,a.work_type::character varying as work_type_value
	,docTypePP.value_text::character varying as work_type_name--ประเภทงาน
	,a.budget_amount::numeric as budget_amount--วงเงินงบประมาณ
	,concat(to_char(extract(month from a.estimated_date) ,'FM09'),'/',to_char(extract(year from a.estimated_date) +543 ,'FM9999'))::character varying as estimated_date--เดือน/ปีที่คาดว่าจะจัดซื้อจัดจ้าง
	,to_char(a.budget_year +543 ,'FM9999')::integer as budget_year--ปีงบประมาณที่จะเบิกจ่าย
	,a.carry_over::character varying as carry_over
	,carryOver.value_text::character varying as carry_over_name--งานต่อเนื่องจากปีก่อนหน้า
	,(select dol.organization_name
		from db_organization_lang dol
		where dol.company_code = a.company_code
		and dol.organization_code = a.ref_div_code
		and lower(dol.language_code) = lower(p_lin_id))::character varying as ref_div_name
from po_plan_master a
left join db_list_value_lang docTypePP on docTypePP.group_code = 'PoDocTypePP' 
		and docTypePP.value = a.work_type
		and lower(docTypePP.language_code) = lower(p_lin_id)
left join db_list_value_lang carryOver on carryOver.group_code = 'PoCarryOver' 
		and carryOver.value = a.carry_over
		and lower(carryOver.language_code) = lower(p_lin_id)
left join db_list_value_lang statusPP on statusPP.group_code = 'PoStatusPP' 
		and statusPP.value = a.status
		and lower(statusPP.language_code) = lower(p_lin_id)
where a.company_code = p_company_code
and a.ref_div_code between  COALESCE(p_start_div ,a.ref_div_code)
				and COALESCE(p_end_div ,a.ref_div_code)
and a.po_plan_no between  COALESCE(p_start_no ,a.po_plan_no)
				and COALESCE(p_end_no ,a.po_plan_no)
and date(a.po_plan_date) BETWEEN to_date(COALESCE(p_start_date, '01/01/1000'),'DD/MM/YYYY') 
				AND to_date(COALESCE(p_end_date,'31/12/9999' ), 'DD/MM/YYYY')
and a.work_type = COALESCE(p_work_type,a.work_type)
and a.status = COALESCE(p_status,a.status)
and extract(year from a.estimated_date) = COALESCE(p_estimated_year ,extract(year from a.estimated_date))
and to_char(extract(month from a.estimated_date),'FM09') = COALESCE(p_estimated_month ,to_char(extract(month from a.estimated_date),'FM09'))
and exists (select 'X' from su_user_organization su
                    where concat(su.user_id)= concat(p_user_id)
                    and su.company_code = p_company_code
                    and su.organization_code = a.div_code
                    and coalesce(cast(su.start_effective_date as date), current_date) <= current_date
                    and coalesce(cast(su.end_effective_date as date), current_date) >= current_date)
order by to_char(extract(year from a.estimated_date) +543 ,'FM9999'),TO_CHAR(a.estimated_date, 'FMMM');
END;
$function$
;

--old porp13 is new porp14
CREATE OR REPLACE FUNCTION erp.report_porp14(p_lin_id character varying, p_company_code character varying, p_start_div character varying, p_end_div character varying, p_start_no character varying, p_end_no character varying, p_start_date character varying, p_end_date character varying, p_sub_product_type character varying, p_status character varying, p_user_id integer)
 RETURNS TABLE(company_code character varying, tor_master_id integer, start_div character varying, end_div character varying, sub_product_type_code character varying, status_name character varying, group_tor_date date, tor_no character varying, ref_div_code_name character varying, tor_date_format character varying, subject character varying, ref_plan_no character varying, sub_product_name character varying, tor_detail_id integer, product_code character varying, product_name character varying, remark character varying, qty numeric, ums_name character varying, unit_price numeric, amt numeric)
 LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN QUERY
select a.company_code::character varying as company_code
	,a.tor_master_id::integer as tor_master_id
	,(select t.organization_code_display
		from db_organization t
		where t.company_code = a.company_code
		and t.organization_code = p_start_div)::character varying as start_div
	,(select t.organization_code_display
		from db_organization t
		where t.company_code = a.company_code
		and t.organization_code = p_end_div)::character varying as end_div
	,a.sub_product_type::character varying AS sub_product_type_code
	,statusTR.value_text::character varying as status_name--สถานะ
	,a.tor_date::date as group_tor_date--group-date
	,a.tor_no::character varying as tor_no--group-no
	,(select concat(t.organization_code_display,' ',tl.organization_name)
		from db_organization t
		left join db_organization_lang tl on t.company_code = tl.company_code
				and t.organization_code = tl.organization_code
				and lower(tl.language_code) = lower(p_lin_id)
		where t.company_code = a.company_code
		and t.organization_code = a.ref_div_code)::character varying as ref_div_code_name--หน่วยงานจัดซื้อ/จัดจ้าง
	,po_format_date_for_report(a.tor_date::date, p_lin_id)::character varying as tor_date_format--วันที่เอกสาร
	,a.subject::character varying as subject--เรื่อง
	,a.ref_plan_no::character varying as ref_plan_no--เลขที่แผนการจัดซื้อจัดจ้าง
	,psptl.sub_product_name::character varying AS sub_product_name--ประเภทรายการขอซื้อ/จ้าง
	--detail
	,b.tor_detail_id::integer as tor_detail_id
    ,get_product_code(p_lin_id, b.product_type, b.product_id::integer, b.fa_type_id::integer, b.fa_mkind_id::integer)::character varying AS product_code--รหัสสินค้า
    ,get_product_name(p_lin_id, b.product_type, b.product_id::integer, b.fa_type_id::integer, b.fa_mkind_id::integer)::character varying AS product_name--ชื่อสินค้า
	,b.remark::character varying AS remark--รายละเอียด
	,COALESCE(b.qty,0)::numeric as QTY--จำนวน
    ,get_ums_name(p_lin_id, b.product_type, b.ums_id::integer)::character varying AS ums_name--หน่วยนับ
	,COALESCE(b.unit_price,0)::numeric as unit_price--ราคาต่อหน่วย
	,COALESCE(b.amt,0)::numeric as amt--จำนวนเงิน
from po_tor_master a
left join po_tor_detail b on a.tor_master_id = b.tor_master_id
left join po_sub_product_type pspt on pspt.sub_product_type_code = a.sub_product_type 
		left join po_sub_product_type_lang psptl on pspt.sub_product_type_id = psptl.sub_product_type_id 
				and lower(psptl.language_code) = lower(p_lin_id)
left join db_list_value_lang statusTR on statusTR.group_code = 'PoStatusTR' 
		and statusTR.value = a.status
		and lower(statusTR.language_code) = lower(p_lin_id)
where a.company_code = p_company_code
and a.ref_div_code between  COALESCE(p_start_div ,a.ref_div_code)
				and COALESCE(p_end_div ,a.ref_div_code)
and a.tor_no between  COALESCE(p_start_no ,a.tor_no)
				and COALESCE(p_end_no ,a.tor_no)
and date(a.tor_date) BETWEEN to_date(COALESCE(p_start_date, '01/01/1000'),'DD/MM/YYYY') 
				AND to_date(COALESCE(p_end_date,'31/12/9999' ), 'DD/MM/YYYY')
and a.sub_product_type = COALESCE(p_sub_product_type,a.sub_product_type)
and a.status = COALESCE(p_status,a.status)
and exists (select 'X' from su_user_organization su
                    where concat(su.user_id)= concat(p_user_id)
                    and su.company_code = p_company_code
                    and su.organization_code = a.div_code
                    and coalesce(cast(su.start_effective_date as date), current_date) <= current_date
                    and coalesce(cast(su.end_effective_date as date), current_date) >= current_date)
order by date(a.tor_date),
		a.tor_no,
		b.tor_detail_id;
END;
$function$
;

--old porp14 is new porp15
CREATE OR REPLACE FUNCTION erp.report_porp15(p_lin_id character varying, p_company_code character varying, p_start_div character varying, p_end_div character varying, p_start_no character varying, p_end_no character varying, p_start_date character varying, p_end_date character varying, p_sub_product_type character varying, p_status character varying, p_user_id integer)
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
