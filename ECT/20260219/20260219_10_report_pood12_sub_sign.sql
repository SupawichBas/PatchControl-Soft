-- DROP FUNCTION erp.report_pood13(varchar, int4);

CREATE OR REPLACE FUNCTION erp.report_pood13(p_lin_id character varying, p_guaranty_master_id integer)
 RETURNS TABLE(guaranty_master_id integer, guaranty_no character varying, guaranty_date character varying, ref_doc_no character varying, cp_date character varying, po_no character varying, start_end_gua character varying, receipt_code character varying, method_name character varying, ref_no character varying, cp_subject character varying, ap_code_name character varying, cp_period text, return_emp character varying, company_name character varying)
 LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN QUERY
	select 		
		ago.guaranty_master_id::integer as guaranty_master_id,
		ago.GUARANTY_NO::character varying as guaranty_no,
		case when ago.guaranty_date is not null then 
				case p_lin_id when 'TH' then 
						concat(to_char(extract(day from ago.guaranty_date) ,'FM09') ,'/' ,
						to_char(extract(month from ago.guaranty_date) ,'FM09') ,'/' ,
						to_char(extract(year from ago.guaranty_date) +543 ,'FM9999'))
					else
						concat(to_char(extract(day from ago.guaranty_date) ,'FM09') ,'/' ,
						to_char(extract(month from ago.guaranty_date) ,'FM09') ,'/' ,
						to_char(extract(year from ago.guaranty_date) ,'FM9999'))
					end
				end::character varying as guaranty_date,
		a.ref_doc_no::character varying as ref_doc_no,
		case 
			when a.ref_doc_type = 'PC' then (
				select case when ppm.procurement_date is not null then 
								case p_lin_id when 'TH' then 
									concat(to_char(extract(day from ppm.procurement_date) ,'FM09') ,'/' ,
									to_char(extract(month from ppm.procurement_date) ,'FM09') ,'/' ,
									to_char(extract(year from ppm.procurement_date) +543 ,'FM9999'))
								else
									concat(to_char(extract(day from ppm.procurement_date) ,'FM09') ,'/' ,
									to_char(extract(month from ppm.procurement_date) ,'FM09') ,'/' ,
									to_char(extract(year from ppm.procurement_date) ,'FM9999'))
								end
							end::character varying
			from po_procurement_master ppm
			where ppm.company_code = a.company_code
			and ppm.doc_type = a.ref_doc_type
			and ppm.procurement_no = a.ref_doc_no
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
				end::character varying
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
		null::character varying as po_no,
		concat(
			case when ago.start_gua_date is not null then 
				case p_lin_id when 'TH' then 
					concat(to_char(extract(day from ago.start_gua_date) ,'FM09') ,'/' ,
					to_char(extract(month from ago.start_gua_date) ,'FM09') ,'/' ,
					to_char(extract(year from ago.start_gua_date) +543 ,'FM9999'))
				else
					concat(to_char(extract(day from ago.start_gua_date) ,'FM09') ,'/' ,
					to_char(extract(month from ago.start_gua_date) ,'FM09') ,'/' ,
					to_char(extract(year from ago.start_gua_date) ,'FM9999'))
				end
			end,' - ',
			case when ago.end_gua_date is not null then 
				case p_lin_id when 'TH' then 
					concat(to_char(extract(day from ago.end_gua_date) ,'FM09') ,'/' ,
					to_char(extract(month from ago.end_gua_date) ,'FM09') ,'/' ,
					to_char(extract(year from ago.end_gua_date) +543 ,'FM9999'))
				else
					concat(to_char(extract(day from ago.end_gua_date) ,'FM09') ,'/' ,
					to_char(extract(month from ago.end_gua_date) ,'FM09') ,'/' ,
					to_char(extract(year from ago.end_gua_date) ,'FM9999'))
				end
			end
		)::character varying as start_end_gua,
		ago.receipt_code::character varying as receipt_code,

		case 
			when a.ref_doc_type = 'PC' then (
				select pml.method_name
				from po_procurement_master ppm
				left join po_method_lang pml on pml.method_id = ppm.procurement_method_id 
					and lower(pml.language_code) = lower(p_lin_id)
				where ppm.company_code = a.company_code
				and ppm.doc_type = a.ref_doc_type
				and ppm.procurement_no = a.ref_doc_no
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
		ago.ref_no::character varying as ref_no,
		ago.subject::character varying as cp_subject,
		concat(aml2.prefix_abbreviation, ' ',aml.first_name,' ',aml.last_name)::character varying as ap_code_name,
		case 
			when a.ref_doc_type = 'PC' 
				then null
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
		coalesce(concat('(', returnemp.emp_name, ')'), '')::character varying as return_emp,
		concat((select l.company_name from db_company_lang l where l.company_code = ago.company_code and lower(l.language_code) = lower(p_lin_id)))::character varying AS company_name
	from po_guaranty_master ago
		left join po_guaranty_master a on a.guaranty_master_id = ago.ref_doc_id
		left join db_employee_name(p_lin_id) recieve on recieve.emp_id  = a.recieve_emp_id
		left join db_employee_name(p_lin_id) returnemp on returnemp.emp_id  = a.return_emp_id
		left join ap_member_lang aml on aml.ap_member_id = a.ap_member_id
			and lower(aml.language_code) = lower(p_lin_id)
		left join db_prefix_lang aml2 on aml2.prefix_id = aml.prefix_id 
			and lower(aml2.language_code) = lower(p_lin_id)
	where ago.guaranty_master_id = p_guaranty_master_id
	ORDER BY date(a.guaranty_date),a.ref_doc_no,a.ap_member_id;
END;
$function$
;
