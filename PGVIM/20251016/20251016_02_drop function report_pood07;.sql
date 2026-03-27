drop function report_pood07;

CREATE OR REPLACE FUNCTION erp.report_pood07(p_lin_id character varying, p_guaranty_master_id integer)
 RETURNS TABLE(guaranty_master_id integer, company_code character varying, guaranty_no character varying, receipt_code character varying, guaranty_date character varying, ref_doc_no character varying, po_no character varying, p_member_id integer, ap_code_name character varying, start_end_gua character varying, ref_doc_type character varying, cp_period text, method_name character varying, cp_date character varying, cp_subject character varying, i text, guaranty_name character varying, remark character varying, collateral_no character varying, collateral_date character varying, bond_due_date character varying, bank character varying, bank_branch character varying, guaranty_amt numeric, collateral_holder character varying, collateral_holder_name character varying, collateral_returnee character varying, collateral_holder_image character varying, return_emp character varying, return_emp_image character varying, cash_flag boolean, status_show_image boolean, ref_no character varying, fromat_approve_date character varying)
 LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN QUERY
	select a.guaranty_master_id::integer as guaranty_master_id,
			a.company_code::character varying company_code,
			a.GUARANTY_NO::character varying guaranty_no,
			a.receipt_code::character varying receipt_code,
			case when a.guaranty_date is not null then 
					case p_lin_id when 'TH' then 
							concat(to_char(extract(day from a.guaranty_date) ,'FM09') ,'/' ,
							to_char(extract(month from a.guaranty_date) ,'FM09') ,'/' ,
							to_char(extract(year from a.guaranty_date) +543 ,'FM9999'))
						else
							concat(to_char(extract(day from a.guaranty_date) ,'FM09') ,'/' ,
							to_char(extract(month from a.guaranty_date) ,'FM09') ,'/' ,
							to_char(extract(year from a.guaranty_date) ,'FM9999'))
						end
					end::character varying as guaranty_date,
			a.ref_doc_no::character varying ref_doc_no,
			case 
				when a.ref_doc_type = 'PR' then (
												select null 
												from po_pr_master ppm
												where ppm.company_code = a.company_code
												and ppm.doc_type = a.ref_doc_type 
												and ppm.pr_no = a.ref_doc_no
												)
											else (
												select az.po_no  
												from po_pur_ord_master az
												left join po_pr_master bz on bz.company_code = az.company_code 
														and bz.doc_type = az.ref_doc_type 
														and bz.pr_no = az.ref_doc_no 
												left join po_pur_ord_period_master dz on dz.pur_ord_master_id = az.pur_ord_master_id 
												where az.company_code = a.company_code
												and az.doc_type = a.ref_doc_type 
												and az.po_no = a.ref_doc_no
												group by az.po_no
														,az.po_date
											  			,to_char(az.start_con_date,'DD/MM/RRRR')||' - '||to_char(az.end_con_date,'DD/MM/RRRR')
											  			,bz.pr_method_id 
												) 
			end::character varying as po_no,
			a.ap_member_id::integer as ap_member_id,
			coalesce(aml.full_name, coalesce(aml2.prefix_abbreviation, aml2.prefix_name), ' ', aml.first_name, ' ', aml.last_name)::character varying as ap_code_name,
			concat(case when a.start_gua_date is not null then 
					case p_lin_id when 'TH' then 
							concat(to_char(extract(day from a.start_gua_date) ,'FM09') ,'/' ,
							to_char(extract(month from a.start_gua_date) ,'FM09') ,'/' ,
							to_char(extract(year from a.start_gua_date) +543 ,'FM9999'))
						else
							concat(to_char(extract(day from a.start_gua_date) ,'FM09') ,'/' ,
							to_char(extract(month from a.start_gua_date) ,'FM09') ,'/' ,
							to_char(extract(year from a.start_gua_date) ,'FM9999'))
						end
					end,' - ',
					case when a.end_gua_date is not null then 
					case p_lin_id when 'TH' then 
							concat(to_char(extract(day from a.end_gua_date) ,'FM09') ,'/' ,
							to_char(extract(month from a.end_gua_date) ,'FM09') ,'/' ,
							to_char(extract(year from a.end_gua_date) +543 ,'FM9999'))
						else
							concat(to_char(extract(day from a.end_gua_date) ,'FM09') ,'/' ,
							to_char(extract(month from a.end_gua_date) ,'FM09') ,'/' ,
							to_char(extract(year from a.end_gua_date) ,'FM9999'))
						end
					end)::character varying as START_END_GUA,
			a.ref_doc_type::character varying as ref_doc_type,
			case 
				when a.ref_doc_type = 'PR' then (
												select null
												from po_pr_master ppm
												where ppm.company_code = a.company_code
												and ppm.doc_type = a.ref_doc_type 
												and ppm.pr_no = a.ref_doc_no
												)
											else (
												select count(bz.po_no)::character varying as period_count
												from po_pur_ord_master az
												left join po_pur_ord_period_master bz on bz.pur_ord_master_id = az.pur_ord_master_id
												where az.company_code = a.company_code
												and az.doc_type = a.ref_doc_type 
												and az.po_no = a.ref_doc_no
												group by bz.po_no
												) 
			end::Text as cp_period,
			case 
				when a.ref_doc_type = 'PR' then (
												select pml.method_name 
												from po_pr_master ppm 
														left join po_method_lang pml on pml.method_id = ppm.pr_method_id 
																and lower(pml.language_code) = lower(p_lin_id)
												where ppm.company_code = a.company_code
												and ppm.doc_type = a.ref_doc_type 
												and ppm.pr_no = a.ref_doc_no
												)
											else (
												select pml.method_name 
												from po_pur_ord_master az
												left join po_pr_master bz on bz.company_code = az.company_code 
														and bz.doc_type = az.ref_doc_type 
														and bz.pr_no = az.ref_doc_no 
														left join po_method_lang pml on pml.method_id = bz.pr_method_id 
																and lower(pml.language_code) = lower(p_lin_id)
												left join po_pur_ord_period_master dz on dz.pur_ord_master_id = az.pur_ord_master_id 
												where az.company_code = a.company_code
												and az.doc_type = a.ref_doc_type 
												and az.po_no = a.ref_doc_no
												group by pml.method_name
														,az.po_date
											  			,to_char(az.start_con_date,'DD/MM/RRRR')||' - '||to_char(az.end_con_date,'DD/MM/RRRR')
											  			,bz.pr_method_id 
												) 
			end::character varying as method_name,
			--
			case 
				when a.ref_doc_type = 'PR' then (
												select case when ppm.pr_date is not null then 
															case p_lin_id when 'TH' then 
																	concat(to_char(extract(day from ppm.pr_date) ,'FM09') ,'/' ,
																	to_char(extract(month from ppm.pr_date) ,'FM09') ,'/' ,
																	to_char(extract(year from ppm.pr_date) +543 ,'FM9999'))
																else
																	concat(to_char(extract(day from ppm.pr_date) ,'FM09') ,'/' ,
																	to_char(extract(month from ppm.pr_date) ,'FM09') ,'/' ,
																	to_char(extract(year from ppm.pr_date) ,'FM9999'))
																end
															end::character varying as pr_date
												from po_pr_master ppm
												where ppm.company_code = a.company_code
												and ppm.doc_type = a.ref_doc_type 
												and ppm.pr_no = a.ref_doc_no
												)
											else (
												select case when a.guaranty_date is not null then 
															case p_lin_id when 'TH' then 
																	concat(to_char(extract(day from az.po_date) ,'FM09') ,'/' ,
																	to_char(extract(month from az.po_date) ,'FM09') ,'/' ,
																	to_char(extract(year from az.po_date) +543 ,'FM9999'))
																else
																	concat(to_char(extract(day from az.po_date) ,'FM09') ,'/' ,
																	to_char(extract(month from az.po_date) ,'FM09') ,'/' ,
																	to_char(extract(year from az.po_date) ,'FM9999'))
																end
															end::character varying as po_date
												from po_pur_ord_master az
												left join po_pr_master bz on bz.company_code = az.company_code 
														and bz.doc_type = az.ref_doc_type 
														and bz.pr_no = az.ref_doc_no 
												left join po_pur_ord_period_master dz on dz.pur_ord_master_id = az.pur_ord_master_id 
												where az.company_code = a.company_code
												and az.doc_type = a.ref_doc_type 
												and az.po_no = a.ref_doc_no
												group by az.po_date
											  			,to_char(az.start_con_date,'DD/MM/RRRR')||' - '||to_char(az.end_con_date,'DD/MM/RRRR')
											  			,bz.pr_method_id 
												) 
			end::character varying as cp_date,
			--
			a.subject::character varying as cp_subject,
			--
			ROW_NUMBER() OVER(ORDER BY B.SEQ ASC) || ' '::Text as i,
			pgtl.guaranty_type_name::character varying as guaranty_name,
			B.REMARK::character varying as remark,
			B.COLLATERAL_NO::character varying as collateral_no,
			case when B.COLLATERAL_DATE is not null then 
				case p_lin_id when 'TH' then 
						concat(to_char(extract(day from B.COLLATERAL_DATE) ,'FM09') ,'/' ,
						to_char(extract(month from B.COLLATERAL_DATE) ,'FM09') ,'/' ,
						to_char(extract(year from B.COLLATERAL_DATE) +543 ,'FM9999'))
					else
						concat(to_char(extract(day from B.COLLATERAL_DATE) ,'FM09') ,'/' ,
						to_char(extract(month from B.COLLATERAL_DATE) ,'FM09') ,'/' ,
						to_char(extract(year from B.COLLATERAL_DATE) ,'FM9999'))
					end
				end::character varying as collateral_date,
			case when b.bond_due_date is not null then 
				case p_lin_id when 'TH' then 
						concat(to_char(extract(day from b.bond_due_date) ,'FM09') ,'/' ,
						to_char(extract(month from b.bond_due_date) ,'FM09') ,'/' ,
						to_char(extract(year from b.bond_due_date) +543 ,'FM9999'))
					else
						concat(to_char(extract(day from b.bond_due_date) ,'FM09') ,'/' ,
						to_char(extract(month from b.bond_due_date) ,'FM09') ,'/' ,
						to_char(extract(year from b.bond_due_date) ,'FM9999'))
					end
				end::character varying as bond_due_date,
			dbl.bank_name::character varying as bank,
			dbbl.bank_branch_name::character varying as bank_branch,
			coalesce(B.GUARANTY_AMT,0)::numeric as guaranty_amt,
			--recieve_emp_id
			recieve.emp_name::character varying as collateral_holder,
			a.collateral_holder::character varying as collateral_holder_name,
			a.collateral_returnee::character varying as collateral_returnee,
			case when recieve.personal_id is not null and recieve.signature_image_id is not null
				then concat((select sp.parameter_value  from su_parameter sp 
								where sp.parameter_group_code = 'ContentPath'
								and sp.parameter_code = 'SignatureURL')
								,'?PersonalId=',recieve.personal_id,'&ContentId=',recieve.signature_image_id)
				else null end::character varying as collateral_holder_image,
			--* 
			--return_emp_id
			returnemp.emp_name::character varying as return_emp,
			case when returnemp.personal_id is not null and returnemp.signature_image_id is not null
				then concat((select sp.parameter_value  from su_parameter sp 
								where sp.parameter_group_code = 'ContentPath'
								and sp.parameter_code = 'SignatureURL')
								,'?PersonalId=',returnemp.personal_id,'&ContentId=',returnemp.signature_image_id)
				else null end::character varying as return_emp_image,
			--* 
			case when frt.rec_flag = 'C' 
				then false
				else true end::boolean as cash_flag,
			case when a.status in ('G','R','W') then true
				else false end::bool as status_show_image,
			a.ref_no::character varying as ref_no,
			erp.po_get_fromat_approve_date(a.recieve_gua_date::date)::character varying AS fromat_approve_date
	from po_guaranty_master a 
			left join db_employee_name(p_lin_id) recieve on recieve.emp_id  = a.recieve_emp_id  --เจ้าหน้าที่ผู้รับหลักประกัน
--					
--					AND current_date BETWEEN COALESCE(po_convert_thai_to_gregorian(recieve.work_date), current_date)
--							AND COALESCE(po_convert_thai_to_gregorian(recieve.turnover_date), current_date)
--			
			left join db_employee_name(p_lin_id) returnemp on returnemp.emp_id  = a.return_emp_id --เจ้าหน้าที่ผู้คืนหลักประกัน
--					
--					AND current_date BETWEEN COALESCE(po_convert_thai_to_gregorian(returnemp.work_date), current_date)
--							AND COALESCE(po_convert_thai_to_gregorian(returnemp.turnover_date), current_date)
--            			
			left join ap_member_lang aml on aml.ap_member_id = a.ap_member_id
							and lower(aml.language_code) = lower(p_lin_id)
			left join db_prefix_lang aml2 on aml2.prefix_id = aml.prefix_id 
					and lower(aml2.language_code) = lower(p_lin_id)
	left join PO_GUARANTY_DETAIL b on b.guaranty_master_id = a.guaranty_master_id
			left join po_guaranty_type pgt on pgt.guaranty_type_code = b.guaranty_type
					left join po_guaranty_type_lang pgtl on pgtl.guaranty_type_id = pgt.guaranty_type_id 
							and lower(pgtl.language_code) = lower(p_lin_id)
			left join db_bank_lang dbl on dbl.bank_code = B.BANK
				and lower(dbl.language_code) = lower(p_lin_id)
			left join db_bank_branch dbb on dbb.branch_code = B.BANK_BRANCH
					and dbb.bank_code  = B.BANK
					left join db_bank_branch_lang dbbl on dbbl.bank_branch_id = dbb.bank_branch_id 
							and lower(dbbl.language_code) = lower(p_lin_id)
					left join fn_receipt_type frt on frt.receipt_type_id = pgt.receipt_type_id
	where a.guaranty_master_id = p_guaranty_master_id
	ORDER BY date(a.guaranty_date),a.ref_doc_no,a.ap_member_id,b.seq;
    
END;
$function$
;
