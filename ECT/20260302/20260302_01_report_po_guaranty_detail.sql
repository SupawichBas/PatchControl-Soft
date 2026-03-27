-- DROP FUNCTION erp.report_po_guaranty_detail(varchar, int4);

CREATE OR REPLACE FUNCTION erp.report_po_guaranty_detail(p_lin_id character varying, p_guaranty_master_id integer)
 RETURNS TABLE(running_number character varying, guaranty_name character varying, collateral_detail character varying, guaranty_amt character varying)
 LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN QUERY
    SELECT 
        to_char(ROW_NUMBER() OVER(ORDER BY b.seq ASC), 'FM999,999,999')::character varying AS running_number,
        pgtl.guaranty_type_name::character varying AS guaranty_name,
        CASE 
            WHEN frt.rec_flag = 'C' THEN 
                concat(
                    'เลขที่ ', coalesce(b.collateral_no, '-'), E'\n',
                    'วันที่ ',
                    CASE 
                        WHEN b.collateral_date IS NOT NULL THEN 
                            CASE 
                                WHEN p_lin_id = 'TH' THEN 
                                    concat(
                                        to_char(extract(day from b.collateral_date), 'FM09'), '/',
                                        to_char(extract(month from b.collateral_date), 'FM09'), '/',
                                        to_char(extract(year from b.collateral_date) + 543, 'FM9999')
                                    )
                                ELSE
                                    concat(
                                        to_char(extract(day from b.collateral_date), 'FM09'), '/',
                                        to_char(extract(month from b.collateral_date), 'FM09'), '/',
                                        to_char(extract(year from b.collateral_date), 'FM9999')
                                    )
                            END
                    END, E'\n',
                    'ธนาคาร ', coalesce(dbl.bank_name, '-'), E'\n',
                    'สาขาธนาคาร ', coalesce(dbbl.bank_branch_name, '-'), E'\n',
                    'หมายเหตุ : ',coalesce(b.remark,'-')
                )
            ELSE 
                concat('หมายเหตุ : ', coalesce(b.remark,'-'))
        END::character varying AS collateral_detail,
        to_char(coalesce(b.guaranty_amt, 0), 'FM999,999,999.00')::character varying AS guaranty_amt
    FROM po_guaranty_master ago
		left join po_guaranty_master a
			ON a.guaranty_master_id = (CASE 
		                                 WHEN ago.doc_type = 'GO' THEN ago.ref_doc_id 
		                                 ELSE ago.guaranty_master_id 
		                              END)
        LEFT JOIN po_guaranty_detail b 
            ON b.guaranty_master_id = a.guaranty_master_id
        LEFT JOIN po_guaranty_type pgt 
            ON pgt.guaranty_type_code = b.guaranty_type
        LEFT JOIN po_guaranty_type_lang pgtl 
            ON pgtl.guaranty_type_id = pgt.guaranty_type_id 
            AND lower(pgtl.language_code) = lower(p_lin_id)
        LEFT JOIN db_bank_lang dbl 
            ON dbl.bank_code = b.bank
            AND lower(dbl.language_code) = lower(p_lin_id)
        LEFT JOIN db_bank_branch dbb 
            ON dbb.branch_code = b.bank_branch
            AND dbb.bank_code = b.bank
        LEFT JOIN db_bank_branch_lang dbbl 
            ON dbbl.bank_branch_id = dbb.bank_branch_id 
            AND lower(dbbl.language_code) = lower(p_lin_id)
        LEFT JOIN fn_receipt_type frt 
            ON frt.receipt_type_id = pgt.receipt_type_id
    WHERE ago.guaranty_master_id = p_guaranty_master_id
    ORDER BY date(ago.guaranty_date), ago.ref_doc_no, ago.ap_member_id, b.seq;
END;
$function$
;
