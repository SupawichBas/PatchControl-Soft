-- DROP FUNCTION erp.report_porp12;

CREATE OR REPLACE FUNCTION erp.report_porp12(p_lin_id character varying, p_company_code character varying, p_start_div character varying, p_end_div character varying, p_start_no character varying, p_end_no character varying, p_start_date character varying, p_end_date character varying, p_work_type character varying, p_status character varying, p_estimated_year integer, p_estimated_month character varying, p_user_id integer)
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
