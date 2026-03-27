-- DROP FUNCTION erp.report_pood11(varchar, int4);

CREATE OR REPLACE FUNCTION erp.report_pood11(p_lin_id character varying, p_guaranty_master_id integer)
 RETURNS TABLE(guaranty_master_id integer, guaranty_no character varying, guaranty_date character varying, ref_doc_no character varying, cp_date character varying, po_no character varying, start_end_gua character varying, receipt_code character varying, method_name character varying, ref_no character varying, cp_subject character varying, ap_code_name character varying, recieve_emp character varying, collateral_holder character varying, company_name character varying)
 LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN QUERY
	select 		
		a.guaranty_master_id::integer as guaranty_master_id,
		a.GUARANTY_NO::character varying as guaranty_no,
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
		a.ref_doc_no::character varying as ref_doc_no,
		(select case when ppm.procurement_date is not null then 
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
			and ppm.procurement_no = a.ref_doc_no)::character varying as cp_date,
		a.ref_no::character varying as po_no,
		concat(
			case when a.start_gua_date is not null then 
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
			end
		)::character varying as start_end_gua,
		a.receipt_code::character varying as receipt_code,
		(select pml.method_name
			from po_procurement_master ppm
			left join po_method_lang pml on pml.method_id = ppm.procurement_method_id 
				and lower(pml.language_code) = lower(p_lin_id)
			where ppm.company_code = a.company_code
			and ppm.doc_type = a.ref_doc_type
			and ppm.procurement_no = a.ref_doc_no)::character varying as method_name,
		a.ref_no::character varying as ref_no,
		a.subject::character varying as cp_subject,
		concat(aml2.prefix_abbreviation, ' ',aml.first_name,' ',aml.last_name)::character varying as ap_code_name,
		coalesce(concat('(', recieve.emp_name, ')'), '')::character varying as recieve_emp,
		coalesce(concat('(', a.collateral_holder, ')'), '')::character varying as collateral_holder,
		concat((select l.company_name from db_company_lang l where l.company_code = a.company_code and lower(l.language_code) = lower(p_lin_id)))::character varying AS company_name
	from po_guaranty_master a 
		left join db_employee_name(p_lin_id) recieve on recieve.emp_id  = a.recieve_emp_id
		left join db_employee_name(p_lin_id) returnemp on returnemp.emp_id  = a.return_emp_id
		left join ap_member_lang aml on aml.ap_member_id = a.ap_member_id
			and lower(aml.language_code) = lower(p_lin_id)
		left join db_prefix_lang aml2 on aml2.prefix_id = aml.prefix_id 
			and lower(aml2.language_code) = lower(p_lin_id)
	where a.guaranty_master_id = p_guaranty_master_id
	ORDER BY date(a.guaranty_date),a.ref_doc_no,a.ap_member_id;
END;
$function$
;
