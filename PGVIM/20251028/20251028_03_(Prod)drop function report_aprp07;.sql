drop function report_aprp07;

CREATE OR REPLACE FUNCTION erp.report_aprp07(p_lin_id character varying, p_company_code character varying, p_div_code character varying, p_fsource_id character varying, p_ap_type_id bigint, p_ap_member_id bigint, p_start_date character varying, p_end_date character varying)
 RETURNS TABLE(doc_date date, reference_no character varying, receipt_code character varying, ap_name character varying, remark character varying, co_doc_no character varying, tot_amt numeric, due_date date, guaranty_detail_id bigint, ap_trans_mas_id bigint, cf_bal numeric)
 LANGUAGE plpgsql
AS $function$

BEGIN
	
	RETURN query
	select det.doc_date::date
,	det.reference_no::varchar
,	det.receipt_code::varchar
,	det.ap_name::varchar
,	det.remark::varchar
,	det.co_doc_no::varchar
,	det.tot_amt::numeric
,	det.due_date::date
,	det.guaranty_detail_id::bigint
,	det.ap_trans_mas_id::bigint
,	det.cf_bal::numeric
from (
				select atm.doc_date as doc_date
				, pgm.guaranty_no AS reference_no
				, atm.doc_no AS receipt_code
				, concat(am.ap_code,' ',aml.full_name)::character varying as ap_name 
				, trim(concat(' ',atm.remark,' ',pl.fsource_desc))::varchar AS remark
				, pgm.ref_doc_no as co_doc_no 
				, atm.tot_amt AS tot_amt
				, atm.due_date as due_date
				, null as guaranty_detail_id  
				, atm.ap_trans_mas_id as ap_trans_mas_id
				, coalesce(report_aprp07_cf_bal_pv(p_lin_id
								                , p_company_code
								                , p_div_code
								                , p_fsource_id
								                , p_ap_type_id
								                , p_ap_member_id
								                , p_start_date
								                , p_end_date
										        , apa.ref_div_code
										        , apa.ref_main_type_id
										        , apa.ref_sub_type_id
										        , apa.ref_doc_id
										        , COALESCE(atm.tot_amt,0)),  COALESCE(atm.tot_amt,0)) as cf_bal
				from ap_trans_master atm 
				INNER JOIN ap_type apt ON atm.ap_type_id = apt.ap_type_id
				INNER JOIN po_guaranty_master pgm ON atm.guaranty_mas_id = pgm.guaranty_master_id
				inner join ap_member am on am.ap_member_id = atm.ap_member_id 
				inner join ap_member_lang aml on aml.ap_member_id = am.ap_member_id and aml.language_code = p_lin_id
				inner join lateral ( select array_to_string(array_agg(distinct pfsl.fsource_name),',') fsource_desc
									,	atd.fsource_id
								      from ap_trans_detail atd
								      inner join pl_fund_sources pfs on pfs.fsource_id = atd.fsource_id
								      INNER JOIN pl_fund_sources_lang pfsl ON pfs.fsource_id = pfsl.fsource_id AND pfsl.language_code = p_lin_id
								      where atd.ap_trans_mas_id = atm.ap_trans_mas_id
								      group by atd.fsource_id
								        ) pl on true
				left join lateral (SELECT apa.company_code
						, apa.ref_div_code
						, apa.ref_main_type_id
						, apa.ref_sub_type_id
						, apa.ref_doc_id
						from ap_pv_apply apa
						where atm.company_code = apa.company_code
						and atm.div_code = apa.ref_div_code
						and atm.main_type_id = apa.ref_main_type_id
						and atm.sub_type_id = apa.ref_sub_type_id
						and atm.ap_trans_mas_id = apa.ref_doc_id
						group by apa.company_code
						, apa.ref_div_code
						, apa.ref_main_type_id
						, apa.ref_sub_type_id
						, apa.ref_doc_id
						order by apa.ref_doc_id) apa on true
				where atm.status_code <> 'C'
				and atm.company_code = p_company_code
				--AND CASE WHEN p_div_code IS NOT NULL THEN atm.div_code = p_div_code ELSE TRUE END
				AND CASE WHEN p_div_code IS NOT NULL THEN pgm.div_code = p_div_code ELSE TRUE END
				AND (CASE WHEN p_fsource_id IS NOT NULL THEN pl.fsource_id = ANY(string_to_array(p_fsource_id, ',')::bigint[]) ELSE TRUE END)
				AND CASE WHEN p_ap_type_id IS NOT NULL THEN atm.ap_type_id = p_ap_type_id ELSE TRUE END
				AND CASE WHEN p_ap_member_id IS NOT NULL THEN atm.ap_member_id = p_ap_member_id ELSE TRUE END
				AND atm.doc_date::date BETWEEN to_date(COALESCE(p_start_date, '01/01/1000'),'dd/MM/yyyy') 
									   AND to_date(COALESCE(p_end_date,'31/12/9999' ), 'dd/MM/yyyy')
				union all
				 SELECT CAST(PGM.GUARANTY_DATE AS DATE)   as doc_date
				 , PGM.GUARANTY_NO  as reference_no 
				 , null as receipt_code 
				 , concat(am.ap_code,' ',aml.full_name)::character varying as ap_name 
				 , PGD.remark AS remark
				 , PGM.REF_DOC_NO as co_doc_no 
				 , PGD.guaranty_amt  AS tot_amt
				 , CAST(pgd.bond_due_date AS DATE)   as due_date 
				 , pgd.guaranty_detail_id as guaranty_detail_id
				 , null as ap_trans_mas_id
				 , case when pgm.STATUS  = 'R' then 0 else pgm.COLLATERAL_AMT end AS cf_bal 
				 from PO_GUARANTY_MASTER PGM 
				 inner join PO_GUARANTY_DETAIL PGD on PGM.GUARANTY_MASTER_ID  = PGD.GUARANTY_MASTER_ID 
				 inner join PO_GUARANTY_TYPE PGT on PGD.GUARANTY_TYPE  = PGT.GUARANTY_TYPE_CODE
				 inner join ap_member am on am.ap_member_id = PGM.ap_member_id 
				 inner join ap_member_lang aml on aml.ap_member_id = am.ap_member_id and aml.language_code = p_lin_id
				 LEFT JOIN PO_PR_MASTER PPM on PGM.REF_DOC_TYPE  = PPM.DOC_TYPE 
												and PGM.REF_DOC_NO  = ppm.PR_NO 
				 LEFT JOIN PO_PR_SUPPLIER PPS on PPM.PR_MASTER_ID  = PPS.PR_MASTER_ID 
				 WHERE ( coalesce(PGT.PO_RECEIVE,false) = true  or 
				       ( coalesce(PGT.PO_RECEIVE,false) = false and  PGM.guaranty_master_id not in (select atm.guaranty_mas_id 
				                                                                                from ap_trans_master atm 
				                                                                                where atm.status_code <> 'C'
				                                                                                and atm.guaranty_mas_id is not null
				                                                                                )))	
				 AND PGM.STATUS != 'C'
				 AND PGM.COMPANY_CODE  = p_company_code
				 AND CASE WHEN p_div_code IS NOT NULL THEN PGM.div_code = p_div_code ELSE TRUE end
				 AND PGM.GUARANTY_DATE::date BETWEEN to_date(COALESCE(p_start_date, '01/01/1000'),'dd/MM/yyyy') 
				        AND to_date(COALESCE(p_end_date,'31/12/9999' ), 'dd/MM/yyyy')
				 AND (CASE WHEN p_fsource_id IS NOT NULL THEN PPM.fsource_id = ANY(string_to_array(p_fsource_id, ',')::bigint[]) ELSE TRUE END)
				 AND CASE WHEN p_ap_member_id IS NOT NULL THEN am.ap_member_id = p_ap_member_id ELSE TRUE end
				 AND CASE WHEN p_ap_type_id IS NOT NULL THEN PPS.ap_type_id = p_ap_type_id ELSE TRUE end
) det
ORDER BY det.doc_date 
		, det.reference_no 
		, det.receipt_code;

END;
$function$
;
