drop function report_porp04;

CREATE OR REPLACE FUNCTION erp.report_porp04(p_lin_id character varying, p_company_code character varying, p_doc_type character varying, p_s_div character varying, p_e_div character varying, p_s_po_no character varying, p_e_po_no character varying, p_s_po_date character varying, p_e_po_date character varying, p_product_type character varying, p_status character varying, p_user_id integer)
 RETURNS TABLE(company_code character varying, div_code character varying, div_name character varying, product_type_name character varying, receive_date date, doc_date character varying, receive_no character varying, ref_doc_no character varying, vat_type_txt character varying, product_type character varying, method_name character varying, status_name character varying, ap_name character varying, seq integer, product_code character varying, product_name character varying, qty numeric, ums_code character varying, ums_name character varying, unit_price numeric, vat_amt numeric, amt numeric, receive_detail_id integer, set_seq integer, set_product_code character varying, set_product_name character varying, set_qty numeric, set_ums character varying, set_ums_name character varying, set_unit_price numeric, set_vat_amt numeric, set_amt numeric, p_status_des character varying, p_product_type_dse character varying, p_s_date character varying, p_e_date character varying, p_s_div_dis character varying, p_e_div_dis character varying, gs_aft_disc numeric)
 LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN QUERY
	select b.company_code::character varying AS company_code,
			o.organization_code_display ::character varying AS div_code,
	        ol.organization_name::character varying AS div_name,
	        dlvl.value_text::character varying AS product_type_name,
			b.receive_date::date AS receive_date,
			case when b.receive_date is not null then 
					case p_lin_id when 'TH' then 
							concat(to_char(extract(day from b.receive_date) ,'FM09') ,'/' ,
							to_char(extract(month from b.receive_date) ,'FM09') ,'/' ,
							to_char(extract(year from b.receive_date) +543 ,'FM9999'))
						else
							concat(to_char(extract(day from b.receive_date) ,'FM09') ,'/' ,
							to_char(extract(month from b.receive_date) ,'FM09') ,'/' ,
							to_char(extract(year from b.receive_date) ,'FM9999'))
						end
					end::character varying as doc_date,
			b.receive_no::character varying AS receive_no,
			b.ref_doc_no::character varying AS ref_doc_no,
			(
	            CASE 
	                WHEN b.vat_type = 'I' THEN get_report_label_name('PORP02', 'VAT_I', p_lin_id)
	                WHEN b.vat_type = 'E' THEN get_report_label_name('PORP02', 'VAT_E', p_lin_id)
	                WHEN b.vat_type = 'N' THEN get_report_label_name('PORP02', 'VAT_N', p_lin_id)
	                ELSE NULL
	            END ||
	            CASE 
	                WHEN COALESCE(b.vat_type, 'N') = 'N' THEN NULL
	                ELSE TO_CHAR(b.vat_rate, 'fm990.00') || ' %'
	            END
	        )::character varying AS vat_type_txt,
	        b.product_type::character varying AS product_type,
	        pml.method_name::character varying AS method_name,
	        dlvl2.value_text::character varying AS status_name,
	        CONCAT(am.ap_code, ' ', aml.full_name)::character varying AS ap_name,
	        c.seq::integer AS seq,
	        get_product_code(p_lin_id, c.product_type, c.product_id::integer, c.fa_type_id::integer, c.fa_mkind_id::integer)::character varying AS product_code,
	        get_product_name(p_lin_id, c.product_type, c.product_id::integer, c.fa_type_id::integer, c.fa_mkind_id::integer)::character varying AS product_name,
	        c.qty::numeric AS qty,
	        get_ums_code(p_lin_id, c.product_type, c.ums_id::integer)::character varying AS ums_code,
	        get_ums_name(p_lin_id, c.product_type, c.ums_id::integer)::character varying AS ums_name,
	        COALESCE(c.unit_price, 0)::numeric AS unit_price,
	        COALESCE(c.vat_amt, 0)::numeric AS vat_amt,
	        COALESCE(c.gs_aft_disc, 0)::numeric AS amt,
	        c.receive_detail_id ::integer AS receive_detail_id,
	        e.set_seq::integer AS set_seq,
	        get_product_code(p_lin_id, e.product_type, e.product_id::integer, e.fa_type_id::integer, e.fa_mkind_id::integer)::character varying AS set_product_code,
	        get_product_name(p_lin_id, e.product_type, e.product_id::integer, e.fa_type_id::integer, e.fa_mkind_id::integer)::character varying AS set_product_name,
	        e.qty::numeric AS set_qty,
	        get_ums_code(p_lin_id, e.product_type, e.ums_id::integer)::character varying AS set_ums,
	        get_ums_name(p_lin_id, e.product_type, e.ums_id::integer)::character varying AS set_ums_name,
	        COALESCE(e.unit_price, 0)::numeric AS set_unit_price,
	        COALESCE(e.vat_amt, 0)::numeric AS set_vat_amt,
	        COALESCE(e.amt, 0)::numeric AS set_amt,
	        p_List_Value_Status.value_text::character varying  as P_Status_des,
			psptl.sub_product_name::character varying  as P_Product_Type_dse,
			case when p_s_po_date is not null then 
					case p_lin_id when 'TH' then 
							concat(to_char(extract(day from to_date(p_s_po_date ,'DD/MM/YYYY')) ,'FM09') ,'/' ,
							to_char(extract(month from to_date(p_s_po_date ,'DD/MM/YYYY')) ,'FM09') ,'/' ,
							to_char(extract(year from to_date(p_s_po_date ,'DD/MM/YYYY')) +543 ,'FM9999'))
						else
							concat(to_char(extract(day from to_date(p_s_po_date ,'DD/MM/YYYY')) ,'FM09') ,'/' ,
							to_char(extract(month from to_date(p_s_po_date ,'DD/MM/YYYY')) ,'FM09') ,'/' ,
							to_char(extract(year from to_date(p_s_po_date ,'DD/MM/YYYY')) ,'FM9999'))
						end
		else null end::character varying as p_s_date,
		case when p_e_po_date is not null then 
					case p_lin_id when 'TH' then 
							concat(to_char(extract(day from to_date(p_e_po_date ,'DD/MM/YYYY')) ,'FM09') ,'/' ,
							to_char(extract(month from to_date(p_e_po_date ,'DD/MM/YYYY')) ,'FM09') ,'/' ,
							to_char(extract(year from to_date(p_e_po_date ,'DD/MM/YYYY')) +543 ,'FM9999'))
						else
							concat(to_char(extract(day from to_date(p_e_po_date ,'DD/MM/YYYY')) ,'FM09') ,'/' ,
							to_char(extract(month from to_date(p_e_po_date ,'DD/MM/YYYY')) ,'FM09') ,'/' ,
							to_char(extract(year from to_date(p_e_po_date ,'DD/MM/YYYY')) ,'FM9999'))
						end
		else null end::character varying as p_s_date,
			do2Ps.organization_code_display::character varying  as p_s_div_Dis,
			do2Pe.organization_code_display::character varying  as p_e_div_Dis,
			COALESCE(b.gs_aft_disc, 0)::numeric AS gs_aft_disc
	from po_receive_master b
		left join db_list_value_lang dlvl  on dlvl.group_code = 'PoProductType' 
					and dlvl.value = b.product_type  
					and lower(dlvl.language_code) = lower(p_lin_id)
		left join db_organization o on b.company_code = o.company_code 
			  		and b.div_code = o.organization_code
					left join db_organization_lang ol on ol.company_code = o.company_code 
				            and ol.organization_code = o.organization_code 
				            and lower(ol.language_code) = lower(p_lin_id)
		left join db_list_value_lang dlvl2 on dlvl2.group_code = 'PoStatusRE' 
					and dlvl2.value = b.status  
					and lower(dlvl2.language_code) = lower(p_lin_id)
		left join ap_member am on am.ap_member_id = b.ap_member_id 
		    	left join ap_member_lang aml on aml.ap_member_id = am.ap_member_id
		    			and lower(aml.language_code) = lower(p_lin_id)
	left join po_receive_detail c on c.receive_master_id = b.receive_master_id 
	left join po_pr_master d on d.company_code = b.company_code 
		and d.doc_type = b.ref_doc_type 
		and d.pr_no = b.ref_doc_no 
		left join po_method_lang pml on d.pr_method_id  = pml.method_id  
				and lower(pml.language_code) = lower(p_lin_id)
	left join po_receive_set e on e.receive_detail_id = c.receive_detail_id 
	left join db_list_value_lang p_List_Value_Status on p_List_Value_Status.group_code = 'PoStatusRE' 
		and p_List_Value_Status.value = p_status
		and lower(p_List_Value_Status.language_code) = lower(p_lin_id)
	left join po_sub_product_type pspt on pspt.sub_product_type_code = p_product_type
			left join po_sub_product_type_lang psptl on pspt.sub_product_type_id = psptl.sub_product_type_id 
					and lower(psptl.language_code) = lower(p_lin_id)
	left join db_organization do2Ps on do2Ps.company_code = p_company_code
		and do2Ps.organization_code = p_s_div
	left join db_organization do2Pe on do2Pe.company_code = p_company_code
		and do2Pe.organization_code = p_e_div
	where b.company_code = p_company_code
		and b.doc_type = p_doc_type
		and o.organization_code_display between  COALESCE(do2Ps.organization_code_display ,o.organization_code_display)
						and COALESCE(do2Pe.organization_code_display ,o.organization_code_display)
		and b.receive_no  between  COALESCE(p_s_po_no,b.receive_no)
		                    and   COALESCE(p_e_po_no,b.receive_no)
		and date(b.receive_date) BETWEEN to_date(COALESCE(p_s_po_date, '01/01/1000'),'DD/MM/YYYY')
							AND to_date(COALESCE(p_e_po_date,'31/12/9999' ), 'DD/MM/YYYY')
		and b.sub_product_type  = COALESCE(p_product_type,b.sub_product_type)
		and b.status  = COALESCE(p_status,b.status)
		and exists (select 'X' from su_user_organization su
                        where su.user_id = p_User_Id
                        and su.company_code = p_company_code
                        and su.organization_code = b.div_code
                        and coalesce(cast(su.start_effective_date as date), current_date) <= current_date
                        and coalesce(cast(su.end_effective_date as date), current_date) >= current_date)
	order by b.receive_no,c.seq,e.set_seq;
    
END;
$function$
;
