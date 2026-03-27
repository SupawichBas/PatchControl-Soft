-- DROP FUNCTION erp.report_porp11;

CREATE OR REPLACE FUNCTION erp.report_porp11(p_lin_id character varying, p_company_code character varying, p_doc_type character varying, p_s_div character varying, p_e_div character varying, p_s_date character varying, p_e_date character varying, p_product_type character varying, p_status character varying, p_user_id integer)
 RETURNS TABLE(pr_master_id integer, company_code character varying, doc_type character varying, pr_no character varying, div_code character varying, div_name character varying, subject character varying, sum_budget_amt numeric, fsource_gov_name character varying, status_name character varying, status character varying, method_name character varying, sum_std_price numeric, total_amt numeric, project_no character varying, p_status_des character varying, p_product_type_dse character varying, p_s_date_dis character varying, p_e_date_dis character varying, p_s_div_dis character varying, p_e_div_dis character varying)
 LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN QUERY
select a.pr_master_id::integer as pr_master_id
	,a.company_code::character varying as company_code
	,a.doc_type::character varying as doc_type
	,a.pr_no::character varying as pr_no
	,a.div_code::character varying as div_code
	,(select dol3.organization_name 
		from db_organization do2
		inner join db_organization do3 on do3.organization_code = do2.main_organization_code and do3.organization_type = 'A'
			left join db_organization_lang dol3 on do3.organization_code = dol3.organization_code 
					and lower(dol3.language_code) = lower(p_lin_id)  
		where do2.organization_code = a.ref_div_code)::character varying as div_name
	,a.subject::character varying as subject
	,(select coalesce(sum(sum_budget_amt_inner),0)
		from (
		    select ppb.sub_section_id, sum(bpery.budget_amt) as sum_budget_amt_inner
		    from po_pr_budget ppb
		    inner join bg_proj_exp_rev_yearly bpery 
		        on bpery.company_code = ppb.company_code
		        and bpery.budget_year_control = ppb.budget_year_control
		        and bpery.budget_year = ppb.budget_year
		        and bpery.budget_id = ppb.budget_id
		        and bpery.fsource_id = ppb.fsource_id
		        and bpery.fund_id = ppb.fund_id
		        and bpery.prod_id = ppb.prod_id
		        and bpery.proj_id = ppb.proj_id
		        and bpery.atv_id = ppb.atv_id
		    where ppb.company_code = a.company_code 
		        and ppb.doc_type = a.doc_type 
		        and ppb.pr_no = a.pr_no
		    group by ppb.sub_section_id
		) subquery)::numeric as sum_budget_amt
	,(select dlvl.value_text
		from db_list_value_lang dlvl
		where dlvl.group_code = 'PoFsourceGov'
		and dlvl.value = case when coalesce(a.fsource_gov, false) then 'true' else 'false' end
		and lower(dlvl.language_code) = lower(p_lin_id))::character varying as fsource_gov_name
	,case 
		when a.status in ('N','W','A','B') then 'ยังไม่ลงนามในสัญญา'
		when a.status = 'C' then 'ยกเลิกการดำเนินการ'
		when a.status = 'R' -- ถูกอ้างอิง
			then (select case
							when ppom.status in ('N','W','B') then 'ยังไม่ลงนามในสัญญา'
							when ppom.status = 'A' then 'อยู่ระหว่างระยะสัญญา'
							else ppom.status
						end
					from po_pur_ord_master ppom
					where ppom.company_code = a.company_code
					and ppom.ref_doc_type = a.doc_type
					and ppom.ref_doc_no = a.pr_no)
		when a.status = 'E' -- ปิด
	        then (case 
	                when not exists (
	                    select 1
	                    from po_receive_master prm
	                    where prm.company_code = a.company_code
	                        and prm.pr_type = a.doc_type
	                        and prm.pr_no = a.pr_no
	                        and prm.status not in ('C', 'A') --status <> A 
	                ) --เช็ค ว่าเป็น A ทุกใบไหม 1 ยังมีสถานะอื่นอยู่ null เป็น A ทุกใบ
	                then 'สิ้นสุดสัญญา' -- A ทุกใบ
	                else 'อยู่ระหว่างระยะสัญญา' -- <> A ทุกใบ
	              end)
		else a.status
	end::character varying as status_name
	,a.status ::character varying as status
	,pml.method_name::character varying as pr_method_name
	,(select coalesce(sum(ppd.std_price),0) from po_pr_detail ppd where ppd.pr_master_id = a.pr_master_id)::numeric as sum_std_price
	,coalesce(a.total_amt,0)::numeric as total_amt
	--po_pr_supplier
	,(select ppm.project_no
		from po_pr_ref ppr
		inner join po_pr_master ppm on ppm.company_code = ppr.company_code 
				and ppm.doc_type = ppr.ref_doc_type  
				and ppm.pr_no = ppr.ref_doc_no  
		where ppr.pr_master_id = a.pr_master_id)::character varying as project_no
	--
	,p_List_Value_Status.value_text::character varying  as p_status_des
	,p_List_Value_Product_Type.value_text::character varying  as p_product_type_dse
	,case when p_s_date is not null then 
					case p_lin_id when 'TH' then 
							concat(to_char(extract(day from to_date(p_s_date ,'DD/MM/YYYY')) ,'FM09') ,'/' ,
							to_char(extract(month from to_date(p_s_date ,'DD/MM/YYYY')) ,'FM09') ,'/' ,
							to_char(extract(year from to_date(p_s_date ,'DD/MM/YYYY')) +543 ,'FM9999'))
						else
							concat(to_char(extract(day from to_date(p_s_date ,'DD/MM/YYYY')) ,'FM09') ,'/' ,
							to_char(extract(month from to_date(p_s_date ,'DD/MM/YYYY')) ,'FM09') ,'/' ,
							to_char(extract(year from to_date(p_s_date ,'DD/MM/YYYY')) ,'FM9999'))
						end
		else 
			null
		end::character varying as p_s_date_dis
	,case when p_e_date is not null then 
					case p_lin_id when 'TH' then 
							concat(to_char(extract(day from to_date(p_e_date ,'DD/MM/YYYY')) ,'FM09') ,'/' ,
							to_char(extract(month from to_date(p_e_date ,'DD/MM/YYYY')) ,'FM09') ,'/' ,
							to_char(extract(year from to_date(p_e_date ,'DD/MM/YYYY')) +543 ,'FM9999'))
						else
							concat(to_char(extract(day from to_date(p_e_date ,'DD/MM/YYYY')) ,'FM09') ,'/' ,
							to_char(extract(month from to_date(p_e_date ,'DD/MM/YYYY')) ,'FM09') ,'/' ,
							to_char(extract(year from to_date(p_e_date ,'DD/MM/YYYY')) ,'FM9999'))
						end
		else 
			null
		end::character varying as p_e_date_dis
	,do2Ps.organization_code_display::character varying  as p_s_div_Dis
	,do2Pe.organization_code_display::character varying  as p_e_div_Dis
from po_pr_master a 
left join po_method_lang pml on pml.method_id = a.pr_method_id 
	and lower(pml.language_code) = lower(p_lin_id)
--
left join db_list_value_lang p_List_Value_Status on p_List_Value_Status.group_code = 'PoStatusPR' 
	and p_List_Value_Status.value = p_status
	and lower(p_List_Value_Status.language_code) = lower(p_lin_id)
left join db_list_value_lang p_List_Value_Product_Type  on p_List_Value_Product_Type.group_code = 'PoProductType' 
	and p_List_Value_Product_Type.value = p_product_type 
	and lower(p_List_Value_Product_Type.language_code) = lower(p_lin_id)
left join db_organization do2Ps on do2Ps.company_code = p_company_code
	and do2Ps.organization_code = p_s_div
left join db_organization do2Pe on do2Pe.company_code = p_company_code
	and do2Pe.organization_code = p_e_div
where a.company_code = p_company_code
and a.doc_type = p_doc_type
and a.div_code between  COALESCE(p_s_div ,a.div_code)
				and COALESCE(p_e_div ,a.div_code)
and date(a.pr_date) BETWEEN to_date(COALESCE(p_s_date, '01/01/1000'),'DD/MM/YYYY') 
					AND to_date(COALESCE(p_e_date,'31/12/9999' ), 'DD/MM/YYYY')
and a.product_type  = COALESCE(p_product_type,a.product_type)
and a.status  = COALESCE(p_status,a.status)
and exists (select 'X' from su_user_organization su
                    where su.user_id = p_user_id
                    and su.company_code = p_company_code
                    and su.organization_code = a.div_code
                    and coalesce(cast(su.start_effective_date as date), current_date) <= current_date
                    and coalesce(cast(su.end_effective_date as date), current_date) >= current_date)
;   
END;
$function$
;
