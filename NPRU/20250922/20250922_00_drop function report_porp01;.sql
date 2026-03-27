drop function report_porp01;

CREATE OR REPLACE FUNCTION erp.report_porp01(lin_id character varying, p_company_code character varying, p_doc_type character varying, p_s_div character varying, p_e_div character varying, p_s_po_no character varying, p_e_po_no character varying, p_s_po_date character varying, p_e_po_date character varying, p_product_type character varying, p_status character varying, p_user_id integer)
 RETURNS TABLE(company_code character varying, pr_date date, doc_date character varying, sub_product_type character varying, sub_product_name character varying, product_type character varying, pr_no character varying, div_code character varying, div_name character varying, vat_type_txt character varying, subject character varying, pr_method_name character varying, status_name character varying, total_amt numeric, disc_perc numeric, disc_baht numeric, total_vat_amt numeric, remark character varying, seq integer, product_code character varying, product_name character varying, qty numeric, ums_code character varying, ums_name character varying, unit_price numeric, vat_amt numeric, amt numeric, p_status_des character varying, p_product_type_dse character varying, p_s_date character varying, p_e_date character varying, p_s_div_dis character varying, p_e_div_dis character varying)
 LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN QUERY
	select a.company_code::character varying AS company_code
	, A.PR_DATE::date AS PR_DATE
	, case when a.pr_date is not null then 
					case lin_id when 'TH' then 
							concat(to_char(extract(day from a.pr_date) ,'FM09') ,'/' ,to_char(extract(month from a.pr_date) ,'FM09') ,'/' ,to_char(extract(year from a.pr_date) +543 ,'FM9999'))
						else
							concat(to_char(extract(day from a.pr_date) ,'FM09') ,'/' ,to_char(extract(month from a.pr_date) ,'FM09') ,'/' ,to_char(extract(year from a.pr_date) ,'FM9999'))
						end
					end::character varying as doc_date
	, A.SUB_PRODUCT_TYPE::character varying AS SUB_PRODUCT_TYPE
	, psptl.sub_product_name::character varying AS sub_product_name
	, A.PRODUCT_TYPE::character varying AS PRODUCT_TYPE 
	, A.PR_NO::character varying AS PR_NO
	, o.organization_code_display::character varying AS div_code
	, ol.organization_name::character varying AS div_name
	,(CASE 
	            WHEN a.vat_type = 'I' THEN get_report_label_name('PORP01', 'VAT_I', lin_id)
                WHEN a.vat_type = 'E' THEN get_report_label_name('PORP01', 'VAT_E', lin_id)
                WHEN a.vat_type = 'N' THEN get_report_label_name('PORP01', 'VAT_N', lin_id)
	            ELSE NULL
	        END ||
	        CASE 
	            WHEN COALESCE(a.vat_type, 'N') = 'N' THEN NULL
	            ELSE TO_CHAR(a.vat_rate, 'fm990.00') || ' %'
	        END
	    )::character varying AS vat_type_txt
	, A.SUBJECT::character varying AS SUBJECT
	, pml.method_name::character varying AS PR_METHOD_NAME
	, dlvl2.value_text::character varying AS status_name
	, COALESCE(A.TOTAL_AMT,0)::numeric as TOTAL_AMT
	, COALESCE(A.DISC_PERC,0)::numeric as DISC_PERC
	, COALESCE(A.DISC_BAHT,0)::numeric as DISC_BAHT
	, COALESCE(A.TOTAL_VAT_AMT,0)::numeric as TOTAL_VAT_AMT
	, A.REMARK::character varying as REMARK
	, B.SEQ::integer as SEQ
    , get_product_code(lin_id, b.product_type, b.product_id::integer, b.fa_type_id::integer, b.fa_mkind_id::integer)::character varying AS product_code
    , get_product_name(lin_id, b.product_type, b.product_id::integer, b.fa_type_id::integer, b.fa_mkind_id::integer)::character varying AS product_name
	, COALESCE(B.QTY,0)::numeric as QTY
	, get_ums_code(lin_id, b.product_type, b.ums_id::integer)::character varying AS ums_code
    , get_ums_name(lin_id, b.product_type, b.ums_id::integer)::character varying AS ums_name
	, COALESCE(B.UNIT_PRICE,0)::numeric as UNIT_PRICE 
	, COALESCE(B.VAT_AMT,0)::numeric as VAT_AMT
	, COALESCE(B.AMT,0)::numeric as AMT 
	,p_List_Value_Status.value_text::character varying  as p_status_des
	,psptl.sub_product_name::character varying  as p_product_type_dse
	,case when p_s_po_date is not null then 
					case lin_id when 'TH' then 
							concat(to_char(extract(day from to_date(p_s_po_date ,'DD/MM/YYYY')) ,'FM09') ,'/' ,
							to_char(extract(month from to_date(p_s_po_date ,'DD/MM/YYYY')) ,'FM09') ,'/' ,
							to_char(extract(year from to_date(p_s_po_date ,'DD/MM/YYYY')) +543 ,'FM9999'))
						else
							concat(to_char(extract(day from to_date(p_s_po_date ,'DD/MM/YYYY')) ,'FM09') ,'/' ,
							to_char(extract(month from to_date(p_s_po_date ,'DD/MM/YYYY')) ,'FM09') ,'/' ,
							to_char(extract(year from to_date(p_s_po_date ,'DD/MM/YYYY')) ,'FM9999'))
						end
		else 
			null
		end::character varying as p_s_date
	,case when p_e_po_date is not null then 
					case lin_id when 'TH' then 
							concat(to_char(extract(day from to_date(p_e_po_date ,'DD/MM/YYYY')) ,'FM09') ,'/' ,
							to_char(extract(month from to_date(p_e_po_date ,'DD/MM/YYYY')) ,'FM09') ,'/' ,
							to_char(extract(year from to_date(p_e_po_date ,'DD/MM/YYYY')) +543 ,'FM9999'))
						else
							concat(to_char(extract(day from to_date(p_e_po_date ,'DD/MM/YYYY')) ,'FM09') ,'/' ,
							to_char(extract(month from to_date(p_e_po_date ,'DD/MM/YYYY')) ,'FM09') ,'/' ,
							to_char(extract(year from to_date(p_e_po_date ,'DD/MM/YYYY')) ,'FM9999'))
						end
		else 
			null
		end::character varying as p_s_date
	,do2Ps.organization_code_display::character varying  as p_s_div_Dis
	,do2Pe.organization_code_display::character varying  as p_e_div_Dis
	from po_pr_master a 
		left join po_method_lang pml on a.pr_method_id  = pml.method_id  
				and lower(pml.language_code) = lower(lin_id)
		left join db_list_value_lang dlvl2 on dlvl2.group_code = 'PoStatusPR' 
				and dlvl2.value = a.status  
				and lower(dlvl2.language_code) = lower(lin_id)
		left join db_organization o on a.company_code = o.company_code 
		  		and a.div_code = o.organization_code
				left join db_organization_lang ol on ol.company_code = o.company_code 
			            and ol.organization_code = o.organization_code 
			            and lower(ol.language_code) = lower(lin_id)
		left join po_sub_product_type pspt on pspt.sub_product_type_code = a.sub_product_type 
				left join po_sub_product_type_lang psptl on pspt.sub_product_type_id = psptl.sub_product_type_id 
						and lower(psptl.language_code) = lower(lin_id)
	left join po_pr_detail b on b.pr_master_id = a.pr_master_id 
	left join db_list_value_lang p_List_Value_Status on p_List_Value_Status.group_code = 'PoStatusPR' 
		and p_List_Value_Status.value = p_status
		and lower(p_List_Value_Status.language_code) = lower(lin_id)
	left join db_organization do2Ps on do2Ps.company_code = p_company_code
		and do2Ps.organization_code = p_s_div
	left join db_organization do2Pe on do2Pe.company_code = p_company_code
		and do2Pe.organization_code = p_e_div
	where a.company_code = p_company_code
	and a.doc_type = p_doc_type
	and o.organization_code_display between  COALESCE(do2Ps.organization_code_display ,o.organization_code_display)
					and COALESCE(do2Pe.organization_code_display ,o.organization_code_display)  
	and a.pr_no between  COALESCE(p_s_po_no,a.pr_no)
	                    and   COALESCE(p_e_po_no,a.pr_no)  
	and date(a.pr_date) BETWEEN to_date(COALESCE(p_s_po_date, '01/01/1000'),'DD/MM/YYYY') 
						AND to_date(COALESCE(p_e_po_date,'31/12/9999' ), 'DD/MM/YYYY')
	and a.sub_product_type  = COALESCE(p_product_type,a.sub_product_type)
	and a.status  = COALESCE(p_status,a.status)
	and exists (select 'X' from su_user_organization su
                        where su.user_id = p_User_Id
                        and su.company_code = p_company_code
                        and su.organization_code = a.div_code
                        and coalesce(cast(su.start_effective_date as date), current_date) <= current_date
                        and coalesce(cast(su.end_effective_date as date), current_date) >= current_date)
	order by a.pr_date,a.pr_no,a.product_type,b.seq;
    
END;
$function$
;
