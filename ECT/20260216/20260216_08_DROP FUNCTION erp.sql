DROP FUNCTION erp.report_pood15(varchar, int4);

CREATE OR REPLACE FUNCTION erp.report_pood15(p_lin_id character varying, p_receive_master_id integer)
 RETURNS TABLE(receive_master_id integer, pr_no character varying, parameter1 character varying, totalamt character varying, bahttext character varying, totalfineamt character varying, refdocno character varying, detail1 character varying, lsumdetail character varying, iscompliant character varying, isnotcompliant character varying, isfineamt character varying, isnotfineamt character varying)
 LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN QUERY
	select a.receive_master_id::integer as receive_master_id
			,a.pr_no::character varying as pr_no
			,concat(concat(to_char(extract(day from a.receive_date) ,'FM09'))
				,' ',receivedate.value_text
				,' ',case when a.receive_date is not null then 
					case p_lin_id when 'TH' then 
							concat('พ.ศ. ',to_char(extract(year from a.receive_date) +543 ,'FM9999'))
						else
							concat('ค.ศ. ',to_char(extract(year from a.receive_date) ,'FM9999'))
						end
					end)::character varying as parameter1
			,TO_CHAR(coalesce(coalesce(a.total_amt,0) - coalesce (a.total_fine_amt,0), 0)::numeric, 'FM99,999,999.00')::character varying as totalamt
			,concat('(',erp.fn_baht_text(coalesce(coalesce(a.total_amt,0) - coalesce (a.total_fine_amt,0),0)),')')::character varying AS bahttext
			,case when coalesce(a.total_fine_amt,0) <> 0 then concat( TO_CHAR(coalesce(a.total_fine_amt,0)::numeric, 'FM99,999,999.00'),' บาท') else '' end::character varying as totalfineamt
			,case when a.ref_doc_type = 'CO' 
				then a.ref_doc_no
				else null end::character varying AS  refdocno
			,concat((case 
						when a.ref_doc_type = 'PR' then concat(erp.get_report_label_name('POOD15', 'detail1', p_lin_id),' ',a.pr_no) 
						when a.ref_doc_type = 'PO' then concat(erp.get_report_label_name('POOD15', 'detail1_PO', p_lin_id),' ',(select ppom.contract_code_egp
																																from po_pur_ord_master ppom 
																																where ppom.company_code = a.company_code 
																																and ppom.doc_type = a.ref_doc_type 
																																and ppom.po_no = a.ref_doc_no )) 
						when a.ref_doc_type = 'CO' then concat(erp.get_report_label_name('POOD15', 'detail1_CO', p_lin_id),' ',(select ppom.contract_code_egp
																																from po_pur_ord_master ppom 
																																where ppom.company_code = a.company_code 
																																and ppom.doc_type = a.ref_doc_type 
																																and ppom.po_no = a.ref_doc_no )) 
					end),' ',erp.get_report_label_name('POOD15', 'detail2', p_lin_id),' ',(case 
						when a.ref_doc_type = 'PR' then concat(erp.po_format_date_thai(null,null,null, b.pr_date::date, p_lin_id)) 
						when a.ref_doc_type = 'PO' then concat(erp.po_format_date_thai(null,null,null, (select ppom.po_date::date
																										from po_pur_ord_master ppom 
																										where ppom.company_code = a.company_code 
																										and ppom.doc_type = a.ref_doc_type 
																										and ppom.po_no = a.ref_doc_no ), p_lin_id)) 
						when a.ref_doc_type = 'CO' then concat(erp.po_format_date_thai(null,null,null, (select ppom.po_date::date
																										from po_pur_ord_master ppom 
																										where ppom.company_code = a.company_code 
																										and ppom.doc_type = a.ref_doc_type 
																										and ppom.po_no = a.ref_doc_no ), p_lin_id)) 
					end),' ',get_organization_hierarchy(p_lin_id, a.company_code, a.ref_div_code),' ',
					erp.get_report_label_name('POOD15', 'detail3', p_lin_id),' ',
					coalesce(aml.full_name, coalesce(aml2.prefix_abbreviation, aml2.prefix_name), ' ', aml.first_name, ' ', aml.last_name),' ',
					erp.get_report_label_name('POOD15', 'detail4', p_lin_id),' ',b.subject,' ',erp.get_report_label_name('POOD15', 'detail5', p_lin_id),' ',
					pml.method_name,' ',erp.get_report_label_name('POOD15', 'detail6', p_lin_id),' ',
					TO_CHAR((case 
						when a.ref_doc_type = 'PR' then (select ppm.total_amt
														from po_pr_master ppm
														where ppm.company_code = a.company_code
														and ppm.doc_type = a.ref_doc_type
														and ppm.pr_no = a.ref_doc_no)
						when a.ref_doc_type in ('PO','CO') then (select ppom.total_amt
																from po_pur_ord_master ppom 
																where ppom.company_code = a.company_code 
																and ppom.doc_type = a.ref_doc_type 
																and ppom.po_no = a.ref_doc_no )
						else 0
					end)::numeric, 'FM9,999,999.00'),' ',
					erp.get_report_label_name('POOD15', 'THB', p_lin_id)
					,' (',erp.fn_baht_text((case 
						when a.ref_doc_type = 'PR' then (select ppm.total_amt
														from po_pr_master ppm
														where ppm.company_code = a.company_code
														and ppm.doc_type = a.ref_doc_type
														and ppm.pr_no = a.ref_doc_no)
						when a.ref_doc_type in ('PO','CO') then (select ppom.total_amt
																from po_pur_ord_master ppom 
																where ppom.company_code = a.company_code 
																and ppom.doc_type = a.ref_doc_type 
																and ppom.po_no = a.ref_doc_no )
						else 0
			end)::numeric),')')::character varying AS detail1
			,concat(erp.get_report_label_name('POOD15', 'sum_detail', p_lin_id),' ',a.remark)::character varying AS lsumdetail,
			case when a.contract_compliant = 'Compliant' then 'R' else '*' end::character varying as iscompliant,--ครบถ้านตามสัญญา
			case when a.contract_compliant <> 'Compliant' then 'R' else '*' end::character varying as isnotcompliant,--ไม่ครบถ้วนตามสัญญา
			case when coalesce(a.total_fine_amt,0) <> 0 then 'R' else '*' end::character varying as isfineamt, -- มีค่าปรับ
			case when coalesce(a.total_fine_amt,0) = 0 then 'R' else '*' end::character varying as isnotfineamt -- ไม่มีค่าปรับ
	from po_receive_master a 
	left join db_list_value_lang receivedate  on receivedate.group_code = 'Month' 
			and receivedate.value = TO_CHAR(a.receive_date , 'FMMM')
			and lower(receivedate.language_code) = lower(p_lin_id)
	left join po_pr_master b on b.company_code = a.company_code 
			and b.pr_no = a.pr_no
			left join db_list_value_lang prdate  on prdate.group_code = 'Month' 
					and prdate.value = TO_CHAR(b.pr_date , 'FMMM')
					and lower(prdate.language_code) = lower(p_lin_id)
			left join ap_member am on am.ap_member_id = a.ap_member_id 
						left join ap_member_lang aml on aml.ap_member_id = am.ap_member_id
								and lower(aml.language_code) = lower(p_lin_id)
					left join db_prefix_lang aml2 on aml2.prefix_id = aml.prefix_id 
							and lower(aml2.language_code) = lower(p_lin_id)
			left join po_method pm on pm.method_id = b.pr_method_id 
						left join po_method_lang pml on pml.method_id = pm.method_id
								and lower(pml.language_code) = lower(p_lin_id)
	where a.receive_master_id = p_receive_master_id;
    
END;
$function$
;
