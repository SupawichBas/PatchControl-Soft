drop function report_pood09;--get full_name ap_member report_pood09

CREATE OR REPLACE FUNCTION erp.report_pood09(p_lin_id character varying, p_receive_master_id integer)
 RETURNS TABLE(receive_master_id integer, doc_type character varying, receive_date date, doc_receive_date character varying, pr_no character varying, pr_date date, pr_doc_date character varying, ref_div_code character varying, ref_div_name character varying, ap_member_id integer, ap_member_name character varying, pr_method_id integer, method_name character varying, subject character varying, total_amt numeric, baht_text character varying, total_fine_amt numeric, recipient_head_image character varying, head_emp_name character varying, ref_doc_no character varying, period_receive_detail character varying)
 LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN QUERY
	select a.receive_master_id::integer as receive_master_id
			,a.doc_type::character varying as doc_type
			,a.receive_date::date as receive_date
			,concat(concat(to_char(extract(day from a.receive_date) ,'FM09'))
				,' ',receivedate.value_text
				,' ',case when a.receive_date is not null then 
					case p_lin_id when 'TH' then 
							to_char(extract(year from a.receive_date) +543 ,'FM9999')
						else
							to_char(extract(year from a.receive_date) ,'FM9999')
						end
					end)::character varying as doc_receive_date
--			,concat(TO_CHAR(a.receive_date + INTERVAL '543 years', 'fmDD')
--							,' ',receivedate.value_text
--							,' ',TO_CHAR(a.receive_date + INTERVAL '543 years', 'yyyy'))::character varying as doc_receive_date
			,a.pr_no::character varying as pr_no
			,b.pr_date::date as pr_date
			,concat(concat(to_char(extract(day from b.pr_date) ,'FM09'))
				,' ',prdate.value_text
				,' ',case when b.pr_date is not null then 
					case p_lin_id when 'TH' then 
							to_char(extract(year from b.pr_date) +543 ,'FM9999')
						else
							to_char(extract(year from b.pr_date) ,'FM9999')
						end
					end)::character varying as pr_doc_date
--			,concat(TO_CHAR(b.pr_date + INTERVAL '543 years', 'fmDD')
--							,' ',prdate.value_text
--							,' ',TO_CHAR(b.pr_date + INTERVAL '543 years', 'yyyy'))::character varying as pr_doc_date
			,a.ref_div_code::character varying as ref_div_code
--			,dol.organization_name::character varying as ref_div_name
			,get_organization_hierarchy(p_lin_id, a.company_code, a.ref_div_code)::character varying as ref_div_name
			,a.ap_member_id::integer as ap_member_id
			,coalesce(aml.full_name, coalesce(aml2.prefix_abbreviation, aml2.prefix_name), ' ', aml.first_name, ' ', aml.last_name)::character varying as ap_member_name
			,b.pr_method_id::integer as pr_method_id
			,pml.method_name::character varying AS method_name
			,b.subject ::character varying AS subject
			,coalesce(a.total_amt,0) - coalesce (a.total_fine_amt,0)::numeric as total_amt
			,erp.fn_baht_text(coalesce(a.total_amt,0))::character varying AS baht_text
			,coalesce (a.total_fine_amt,0)::numeric as total_fine_amt
			,case when de.personal_id is not null and de.signature_image_id is not null
				then concat((select sp.parameter_value  from su_parameter sp 
								where sp.parameter_group_code = 'ContentPath'
								and sp.parameter_code = 'SignatureURL')
								,'?PersonalId=',de.personal_id,'&ContentId=',de.signature_image_id)
				else null end::character varying as recipient_head_image
			,de.emp_name::character varying AS  head_emp_name
			,case when a.ref_doc_type = 'CO' 
				then a.ref_doc_no
				else null end::character varying AS  ref_doc_no
			,case when (select count(ppopm.pur_ord_period_master_id) > 1 as period_co
						from po_pur_ord_master ppom 
						left join po_pur_ord_period_master ppopm on ppom.pur_ord_master_id = ppopm.pur_ord_master_id 
						where ppom.company_code = a.company_code 
						and ppom.po_no = a.ref_doc_no 
						and ppom.doc_type = a.ref_doc_type)
				then concat(get_report_label_name('POOD09', 'sum_detailF1', p_lin_id),' ',
							(select STRING_AGG(distinct prd."period"::text, ',') as period_receive_detail
								from po_receive_detail prd 
								where prd.receive_master_id = a.receive_master_id),' ',
							get_report_label_name('POOD09', 'sum_detailF2', p_lin_id))
				else get_report_label_name('POOD09', 'sum_detail', p_lin_id) end::character varying AS  period_receive_detail
	from po_receive_master a 
	left join db_list_value_lang receivedate  on receivedate.group_code = 'Month' 
			and receivedate.value = TO_CHAR(a.receive_date , 'FMMM')
			and lower(receivedate.language_code) = lower(p_lin_id)
	left join po_pr_master b on b.company_code = a.company_code 
			and b.pr_no = a.pr_no
			left join db_list_value_lang prdate  on prdate.group_code = 'Month' 
					and prdate.value = TO_CHAR(b.pr_date , 'FMMM')
					and lower(prdate.language_code) = lower(p_lin_id)
--			left join db_organization_lang dol on dol.company_code = b.company_code 
--					and dol.organization_code = a.ref_div_code
--					and lower(dol.language_code) = lower(p_lin_id)
			left join ap_member am on am.ap_member_id = a.ap_member_id 
						left join ap_member_lang aml on aml.ap_member_id = am.ap_member_id
								and lower(aml.language_code) = lower(p_lin_id)
					left join db_prefix_lang aml2 on aml2.prefix_id = aml.prefix_id 
							and lower(aml2.language_code) = lower(p_lin_id)
			left join po_method pm on pm.method_id = b.pr_method_id 
						left join po_method_lang pml on pml.method_id = pm.method_id
								and lower(pml.language_code) = lower(p_lin_id)
			left join po_committee_master pcm on pcm.company_code = a.company_code 
					and pcm.pr_master_id = b.pr_master_id 
			left join po_committee_type pct on pct.committee_type_id = pcm.committee_type_id 
					left join db_employee_name(p_lin_id) de on de.company_code = a.company_code 
							and de.emp_id = pcm.personal_id
--					
--							AND current_date BETWEEN COALESCE(po_convert_thai_to_gregorian(de.work_date::Date), current_date)
--									AND COALESCE(po_convert_thai_to_gregorian(de.turnover_date::Date), current_date)
--            			
	where a.receive_master_id = p_receive_master_id;
    
END;
$function$
;
