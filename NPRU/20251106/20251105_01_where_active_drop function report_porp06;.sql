drop function report_porp06;

CREATE OR REPLACE FUNCTION erp.report_porp06(p_lin_id character varying, p_company_code character varying, p_budget_year integer, p_s_div character varying, p_e_div character varying, p_s_po_plan_no character varying, p_e_po_plan_no character varying, p_user_id integer)
 RETURNS TABLE(company_code character varying, po_plan_master_id integer, budget_year integer, ref_div_name character varying, doc_date_master character varying, sub_section_name character varying, allocation_amt numeric, po_plan_detail_id integer, value character varying, value_text character varying, doc_date character varying, processing_time integer, contract_no character varying, contract_amt numeric, problems_desc character varying, sequence integer, running_no integer)
 LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN QUERY
SELECT var.*,
    DENSE_RANK() OVER (ORDER BY var.po_plan_master_id)::integer AS running_no
FROM ( 
	select ppm.company_code::character varying as company_code
			,ppd.po_plan_master_id::integer as po_plan_master_id
			,ppm.budget_year::integer as budget_year
			,get_organization_hierarchy(p_lin_id, ppm.company_code, ppm.bg_div_code)::character varying AS ref_div_name
			,case when current_date is not null then 
						case p_lin_id when 'TH' then 
								concat(to_char(extract(day from current_date  ) ,'FM09') 
								,'/' ,to_char(extract(month from current_date  ) ,'FM09') 
								,'/' ,to_char(extract(year from current_date  ) +543 ,'FM9999'))
							else
								concat(to_char(extract(day from current_date  ) ,'FM09') 
								,'/' ,to_char(extract(month from current_date  ) ,'FM09') 
								,'/' ,to_char(extract(year from current_date  ) ,'FM9999'))
							end
						end::character varying as doc_date_master
			,ppm.proj_name::character varying as sub_section_name
			,coalesce (ppm.allocation_amt,0)::numeric as allocation_amt
			--
			,ppd.po_plan_detail_id::integer as po_plan_detail_id
			,dlv.value::character varying as value
			,dlvl.value_text::character varying as value_text
			,case when ppd.value_data is not null then 
				case p_lin_id when 'TH' then 
						concat(to_char(extract(day from ppd.value_data::Date ) ,'FM09') 
						,'/' ,to_char(extract(month from ppd.value_data::Date ) ,'FM09') 
						,'/' ,to_char(extract(year from ppd.value_data::Date ) +543 ,'FM9999'))
					else
						concat(to_char(extract(day from ppd.value_data::Date ) ,'FM09') 
						,'/' ,to_char(extract(month from ppd.value_data::Date ) ,'FM09') 
						,'/' ,to_char(extract(year from ppd.value_data::Date ) ,'FM9999'))
					end
				end::character varying as doc_date
			--
			,ppm.processing_time::integer as processing_time
			,ppm.contract_no::character varying as contract_no
			,coalesce (ppm.contract_amt,0)::numeric as contract_amt
			,ppm.problems_desc::character varying as problems_desc
			,dlv."sequence"::integer as sequence
	from po_plan_detail ppd 
	join db_list_value dlv on dlv.group_code = 'VariablePODT12'
			and dlv.value = ppd.list_value 
			and coalesce(dlv.active,false) = true
	left join db_list_value_lang dlvl on dlvl.value = dlv.value 
			and dlvl.group_code = dlv.group_code
			and lower(dlvl.language_code) = lower(p_lin_id)
	left join po_plan_master ppm on ppm.po_plan_id = ppd.po_plan_master_id 
--			left join pl_sub_section_lang pssl on pssl.sub_section_id = ppm.sub_section_id 
--					and lower(pssl.language_code) = lower(p_lin_id)
	where ppm.budget_year = p_budget_year
	and ppm.bg_div_code between  COALESCE(p_s_div ,ppm.bg_div_code)
						and COALESCE(p_e_div ,ppm.bg_div_code)  
	and ppm.po_plan_no between  COALESCE(p_s_po_plan_no ,ppm.po_plan_no)
						and COALESCE(p_e_po_plan_no ,ppm.po_plan_no)  
	and ppm.status <> 'C'
	and exists (select 'X' from su_user_organization su
	                        where su.user_id = p_user_id
	                        and su.company_code = p_company_code
	                        and su.organization_code = ppm.div_code 
	                        and coalesce(cast(su.start_effective_date as date), current_date) <= current_date
	                        and coalesce(cast(su.end_effective_date as date), current_date) >= current_date)
union
select ppm.company_code::character varying as company_code
			,ppd.po_plan_master_id::integer as po_plan_master_id
			,ppm.budget_year::integer as budget_year
			,get_organization_hierarchy(p_lin_id, ppm.company_code, ppm.bg_div_code)::character varying AS ref_div_name
			,case when current_date is not null then 
						case p_lin_id when 'TH' then 
								concat(to_char(extract(day from current_date  ) ,'FM09') 
								,'/' ,to_char(extract(month from current_date  ) ,'FM09') 
								,'/' ,to_char(extract(year from current_date  ) +543 ,'FM9999'))
							else
								concat(to_char(extract(day from current_date  ) ,'FM09') 
								,'/' ,to_char(extract(month from current_date  ) ,'FM09') 
								,'/' ,to_char(extract(year from current_date  ) ,'FM9999'))
							end
						end::character varying as doc_date_master
			,ppm.proj_name::character varying as sub_section_name
			,coalesce (ppm.allocation_amt,0)::numeric as allocation_amt
			--
			,ppd.po_plan_detail_id::integer as po_plan_detail_id
			,dlv.value::character varying as value
			,dlvl.value_text::character varying as value_text
			,case when ppd.value_data is not null then 
				case p_lin_id when 'TH' then 
						concat(to_char(extract(day from ppd.value_data::Date ) ,'FM09') 
						,'/' ,to_char(extract(month from ppd.value_data::Date ) ,'FM09') 
						,'/' ,to_char(extract(year from ppd.value_data::Date ) +543 ,'FM9999'))
					else
						concat(to_char(extract(day from ppd.value_data::Date ) ,'FM09') 
						,'/' ,to_char(extract(month from ppd.value_data::Date ) ,'FM09') 
						,'/' ,to_char(extract(year from ppd.value_data::Date ) ,'FM9999'))
					end
				end::character varying as doc_date
			--
			,ppm.processing_time::integer as processing_time
			,ppm.contract_no::character varying as contract_no
			,coalesce (ppm.contract_amt,0)::numeric as contract_amt
			,ppm.problems_desc::character varying as problems_desc
			,dlv."sequence"::integer as sequence
	from db_list_value dlv 
	left join db_list_value_lang dlvl on dlvl.value = dlv.value 
			and dlvl.group_code = dlv.group_code
			and lower(dlvl.language_code) = lower(p_lin_id)
	left join po_plan_detail ppd on ppd.list_value = dlvl.value 
	left join po_plan_master ppm on ppm.po_plan_id = ppd.po_plan_master_id 
--			left join pl_sub_section_lang pssl on pssl.sub_section_id = ppm.sub_section_id 
--					and lower(pssl.language_code) = lower(p_lin_id)
	where dlv.group_code = 'VariablePODT12'
	and coalesce(dlv.active,false) = true
	and ppm.budget_year = p_budget_year
	and COALESCE(ppm.bg_div_code ,'n') between  COALESCE(p_s_div ,COALESCE(ppm.bg_div_code ,'n'))
						and COALESCE(p_e_div ,COALESCE(ppm.bg_div_code ,'n'))  
	and COALESCE(ppm.po_plan_no ,'n') between  COALESCE(p_s_po_plan_no ,COALESCE(ppm.po_plan_no ,'n'))
						and COALESCE(p_e_po_plan_no ,COALESCE(ppm.po_plan_no ,'n'))  
	and COALESCE(ppm.status ,'n') <> 'C'
	and exists (select 'X' from su_user_organization su
	                        where su.user_id = p_user_id
	                        and su.company_code = p_company_code
	                        and su.organization_code = ppm.div_code 
	                        and coalesce(cast(su.start_effective_date as date), current_date) <= current_date
	                        and coalesce(cast(su.end_effective_date as date), current_date) >= current_date)
	order by 2,15
	) as var;
END;
$function$
;
