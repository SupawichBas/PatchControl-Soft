-- DROP FUNCTION erp.report_pood08(varchar, int4);

CREATE OR REPLACE FUNCTION erp.report_pood08(p_lin_id character varying, p_receive_master_id integer)
 RETURNS TABLE(receive_master_id integer, receive_no character varying, rec_place character varying, deliver_date character varying, ap_member_name character varying, main_sub_div character varying, sub_div character varying, baht_text character varying, remark_mas character varying, header1 character varying, header2 character varying)
 LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN QUERY
    WITH CTE AS (
        SELECT 
            a.receive_master_id::integer AS receive_master_id,
            a.receive_no::character varying AS receive_no,
            a.rec_place::character varying AS rec_place,
            concat(
                concat(to_char(extract(day from a.deliver_date),'FM09')), 
                ' ',
                Monthdeliver_date.value_text,
                ' ',
                CASE 
                    WHEN a.deliver_date IS NOT NULL THEN 
                        CASE p_lin_id 
                            WHEN 'TH' THEN to_char(extract(year from a.deliver_date) + 543,'FM9999')
                            ELSE to_char(extract(year from a.deliver_date),'FM9999')
                        END
                END
            )::character varying AS deliver_date,
            aml.full_name::character varying AS ap_member_name,
            a.main_sub_div::character varying AS main_sub_div,
            a.sub_div::character varying AS sub_div,
			erp.fn_baht_text(coalesce(COALESCE(a.gs_bef_disc,0)-COALESCE(coalesce(a.gs_bef_disc,0)
							- coalesce(a.gs_aft_disc,0),0)-COALESCE(a.total_fine_amt,0),0))::character varying AS baht_text,
			a.remark::character varying as remark_mas,
        	(select concat((case when a.ref_doc_type = 'PO' then (select concat('ตามใบ',dlvl.value_text )
																		from po_pur_ord_master ppom 
																		join po_sub_doc_type psdt on ppom.sub_doc_type = psdt.sub_doc_type 
																		join db_list_value_lang dlvl on psdt.order_type = dlvl.value 
																			and dlvl.group_code = 'OrderTypePORT05'
																			and lower(dlvl.language_code) = lower(p_lin_id)
																		where ppom.company_code = a.company_code 
																		and ppom.doc_type = a.ref_doc_type 
																		and ppom.po_no = a.ref_doc_no)
									when a.ref_doc_type = 'CO' then 'ตามสัญญา'
									else 'ตามใบสั่งซื้อ'
									end
								),'ที่ ',COALESCE(ppom.contract_code_egp,'-'),' ลงวันที่ ',
        		coalesce((erp.po_format_date_thai(null, null, null, (select ppom.po_date::date
																	from po_pur_ord_master ppom 
																	where ppom.company_code = a.company_code 
																	and ppom.doc_type = a.ref_doc_type 
																	and ppom.po_no = a.ref_doc_no ), p_lin_id)),'-')
				, ' ครบกำหนดส่งมอบ ภายในวันที่ ',
				coalesce((select erp.po_format_date_thai(null, null, null, MAX(end_due_date)::date, p_lin_id) AS max_end_due_date
							from po_pur_ord_period_master ppopm
							where ppopm.pur_ord_master_id = ppom.pur_ord_master_id
							and ppopm."period" in (select prd."period" from po_receive_detail prd where prd.receive_master_id = prm.receive_master_id )),'-'))
				from po_receive_master prm
				left join po_pur_ord_master ppom on ppom.company_code = prm.company_code 
						and ppom.doc_type = prm.ref_doc_type 
						and ppom.po_no = prm.ref_doc_no 
				where prm.receive_master_id = a.receive_master_id)::character varying AS header1,
			concat('ตาม ',(select dlvl.value_text 
									from db_list_value_lang dlvl
									where dlvl.group_code = 'PoReceiptType'
									and lower(dlvl.language_code) = lower(p_lin_id)
									and dlvl.value = coalesce(a.receipt_type,'3') ),' เลขที่ ',coalesce(a.receipt_no,'-'),' ',
					(select erp.po_format_date_thai('ลงวันที่', null, null, a.receipt_date::date, p_lin_id)))::character varying AS header2
        FROM po_receive_master a
        LEFT JOIN db_list_value_lang Monthdeliver_date  
            ON Monthdeliver_date.group_code = 'Month' 
            AND Monthdeliver_date.value = TO_CHAR(a.deliver_date , 'FMMM')
            AND lower(Monthdeliver_date.language_code) = lower(p_lin_id)
        LEFT JOIN ap_member am 
            ON am.ap_member_id = a.ap_member_id 
        LEFT JOIN ap_member_lang aml 
            ON aml.ap_member_id = am.ap_member_id
            AND lower(aml.language_code) = lower(p_lin_id)
        LEFT JOIN db_employee_name(p_lin_id) design 
            ON design.emp_id = a.sign_id
            AND current_date BETWEEN 
                COALESCE(po_convert_thai_to_gregorian(design.work_date::Date), current_date)
                AND COALESCE(po_convert_thai_to_gregorian(design.turnover_date::Date), current_date)
        WHERE a.receive_master_id = p_receive_master_id
    )
    SELECT * FROM CTE;
END;
$function$
;
