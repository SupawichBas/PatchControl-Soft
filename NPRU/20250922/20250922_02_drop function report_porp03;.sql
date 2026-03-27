drop function report_porp03;

CREATE OR REPLACE FUNCTION erp.report_porp03(p_lin_id character varying, p_company_code character varying, p_doc_type character varying, p_s_div character varying, p_e_div character varying, p_s_po_no character varying, p_e_po_no character varying, p_s_po_date character varying, p_e_po_date character varying, p_product_type character varying, p_status character varying, p_user_id integer)
 RETURNS TABLE(company_code character varying, div_code character varying, div_name character varying, product_type_name character varying, po_date date, doc_date character varying, po_no character varying, ref_doc_no character varying, vat_type_txt character varying, product_type character varying, method_name character varying, status_name character varying, ap_name character varying, seq integer, product_code character varying, product_name character varying, qty numeric, ums_code character varying, ums_name character varying, unit_price numeric, vat_amt numeric, amt numeric, pur_ord_detail_id integer, set_seq integer, set_product_code character varying, set_product_name character varying, set_qty numeric, set_ums character varying, set_ums_name character varying, set_unit_price numeric, set_vat_amt numeric, set_amt numeric, p_status_des character varying, p_product_type_dse character varying, p_s_date character varying, p_e_date character varying, p_s_div_dis character varying, p_e_div_dis character varying)
 LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN QUERY
	SELECT
        a.company_code::character varying AS company_code,
        o.organization_code_display::character varying AS div_code,
        ol.organization_name::character varying AS div_name,
        psptla.sub_product_name::character varying AS product_type_name,
        a.po_date::date AS po_date,
        case when a.po_date is not null then 
					case p_lin_id when 'TH' then 
							concat(to_char(extract(day from a.po_date) ,'FM09') ,'/' ,to_char(extract(month from a.po_date) ,'FM09') ,'/' ,to_char(extract(year from a.po_date) +543 ,'FM9999'))
						else
							concat(to_char(extract(day from a.po_date) ,'FM09') ,'/' ,to_char(extract(month from a.po_date) ,'FM09') ,'/' ,to_char(extract(year from a.po_date) ,'FM9999'))
						end
					end::character varying as doc_date,
        a.po_no::character varying AS po_no,
        a.ref_doc_no::character varying AS ref_doc_no,
        (
            CASE 
                WHEN a.vat_type = 'I' THEN get_report_label_name('PORP02', 'VAT_I', p_lin_id)
                WHEN a.vat_type = 'E' THEN get_report_label_name('PORP02', 'VAT_E', p_lin_id)
                WHEN a.vat_type = 'N' THEN get_report_label_name('PORP02', 'VAT_N', p_lin_id)
                ELSE NULL
            END ||
            CASE 
                WHEN COALESCE(a.vat_type, 'N') = 'N' THEN NULL
                ELSE TO_CHAR(a.vat_rate, 'fm990.00') || ' %'
            END
        )::character varying AS vat_type_txt,
        a.product_type::character varying AS product_type,
        pml.method_name::character varying AS method_name,
        dlvl2.value_text::character varying AS status_name,
        CONCAT(am.ap_code, ' ', aml.full_name)::character varying AS ap_name,
        b.seq::integer AS seq,
        get_product_code(p_lin_id, b.product_type, b.product_id::integer, b.fa_type_id::integer, b.fa_mkind_id::integer)::character varying AS product_code,
        get_product_name(p_lin_id, b.product_type, b.product_id::integer, b.fa_type_id::integer, b.fa_mkind_id::integer)::character varying AS product_name,
        b.qty::numeric AS qty,
        get_ums_code(p_lin_id, b.product_type, b.ums_id::integer)::character varying AS ums_code,
        get_ums_name(p_lin_id, b.product_type, b.ums_id::integer)::character varying AS ums_name,
        COALESCE(b.unit_price, 0)::numeric AS unit_price,
        COALESCE(b.vat_amt, 0)::numeric AS vat_amt,
        COALESCE(b.amt, 0)::numeric AS amt,
        b.pur_ord_detail_id::integer AS pur_ord_detail_id,
        d.set_seq::integer AS set_seq,
        get_product_code(p_lin_id, d.product_type, d.product_id::integer, d.fa_type_id::integer, d.fa_mkind_id::integer)::character varying AS set_product_code,
        get_product_name(p_lin_id, d.product_type, d.product_id::integer, d.fa_type_id::integer, d.fa_mkind_id::integer)::character varying AS set_product_name,
        d.qty::numeric AS set_qty,
        get_ums_code(p_lin_id, d.product_type, d.ums_id::integer)::character varying AS set_ums,
        get_ums_name(p_lin_id, d.product_type, d.ums_id::integer)::character varying AS set_ums_name,
        COALESCE(d.unit_price, 0)::numeric AS set_unit_price,
        COALESCE(d.vat_amt, 0)::numeric AS set_vat_amt,
        COALESCE(d.amt, 0)::numeric AS set_amt,
        p_List_Value_Status.value_text::character varying  as p_status_des,
		psptl.sub_product_name::character varying  as p_product_type_dse,
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
		do2Pe.organization_code_display::character varying  as p_e_div_Dis
	from PO_PUR_ORD_MASTER a
		left join db_organization o on a.company_code = o.company_code 
	  		and a.div_code = o.organization_code
			left join db_organization_lang ol on ol.company_code = o.company_code 
		            and ol.organization_code = o.organization_code 
		            and lower(ol.language_code) = lower(p_lin_id)
	    left join ap_member am on am.ap_member_id = a.ap_member_id 
	    	left join ap_member_lang aml on aml.ap_member_id = am.ap_member_id
	    			and lower(aml.language_code) = lower(p_lin_id)
		left join po_sub_product_type pspta on pspta.sub_product_type_code = a.sub_product_type
				left join po_sub_product_type_lang psptla on pspta.sub_product_type_id = psptla.sub_product_type_id 
						and lower(psptla.language_code) = lower(p_lin_id)
		left join db_list_value_lang dlvl2 on dlvl2.group_code = 'PoStatusCO' 
			and dlvl2.value = a.status  
			and lower(dlvl2.language_code) = lower(p_lin_id)
	left join PO_PUR_ORD_DETAIL b on b.pur_ord_master_id = a.pur_ord_master_id 
	left join PO_PR_MASTER c on c.company_code = a.company_code 
		and c.doc_type = a.ref_doc_type 
		and c.pr_no = a.ref_doc_no
		left join po_method_lang pml on c.pr_method_id  = pml.method_id  
				and lower(pml.language_code) = lower(p_lin_id)
	left join po_pur_ord_set d on d.pur_ord_detail_id = b.pur_ord_detail_id 
	left join db_list_value_lang p_List_Value_Status on p_List_Value_Status.group_code = 'PoStatusCO' 
		and p_List_Value_Status.value = p_status
		and lower(p_List_Value_Status.language_code) = lower(p_lin_id)
	left join po_sub_product_type pspt on pspt.sub_product_type_code = p_product_type
			left join po_sub_product_type_lang psptl on pspt.sub_product_type_id = psptl.sub_product_type_id 
					and lower(psptl.language_code) = lower(p_lin_id)
	left join db_organization do2Ps on do2Ps.company_code = p_company_code
		and do2Ps.organization_code = p_s_div
	left join db_organization do2Pe on do2Pe.company_code = p_company_code
		and do2Pe.organization_code = p_e_div
	where a.company_code = p_company_code
	and a.doc_type = p_doc_type
	and o.organization_code_display between  COALESCE(do2Ps.organization_code_display ,o.organization_code_display)
					and COALESCE(do2Pe.organization_code_display ,o.organization_code_display)  
	and a.po_no  between  COALESCE(p_s_po_no,a.po_no)
	                    and   COALESCE(p_e_po_no,a.po_no)  
	and date(a.po_date) BETWEEN to_date(COALESCE(p_s_po_date, '01/01/1000'),'DD/MM/YYYY') 
						AND to_date(COALESCE(p_e_po_date,'31/12/9999' ), 'DD/MM/YYYY')
	and a.sub_product_type  = COALESCE(p_product_type,a.sub_product_type)
	and a.status  = COALESCE(p_status,a.status)
	and exists (select 'X' from su_user_organization su
                        where su.user_id = p_User_Id
                        and su.company_code = p_company_code
                        and su.organization_code = a.div_code
                        and coalesce(cast(su.start_effective_date as date), current_date) <= current_date
                        and coalesce(cast(su.end_effective_date as date), current_date) >= current_date)
	order by a.po_no,b.seq,d.set_seq;
    
END;
$function$
;
