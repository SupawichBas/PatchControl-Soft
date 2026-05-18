-- DROP FUNCTION erp.report_pood08_sub2(varchar, int4);

CREATE OR REPLACE FUNCTION erp.report_pood08_sub2(p_lin_id character varying, p_receive_master_id integer)
 RETURNS TABLE(goods_receipt_committee boolean, sign1 character varying, committee_name character varying, committee_type_name character varying, url character varying)
 LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN QUERY
    SELECT 
        pct.goods_receipt_committee::boolean AS goods_receipt_committee,
        concat('( ลงชื่อ )')::character varying AS sign1,
        de2.emp_name::character varying AS committee_name,
        dlvl.value_text::character varying AS committee_type_name,
        CASE 
            WHEN de2.personal_id IS NOT NULL AND de2.signature_image_id IS NOT NULL and prm.status IN ('A','E')
            THEN concat(
                (SELECT sp.parameter_value  
                 FROM su_parameter sp 
                 WHERE sp.parameter_group_code = 'ContentPath'
                 AND sp.parameter_code = 'SignatureURL'),
                '?PersonalId=',de2.personal_id,'&ContentId=',de2.signature_image_id
            )
            ELSE NULL 
        END::character varying AS url
    FROM po_receive_master prm 
    JOIN po_receive_committee_master a ON a.company_code = prm.company_code
        and a.receive_master_id = prm.receive_master_id
    JOIN po_receive_committee_detail b ON b.receive_committee_master_id = a.receive_committee_master_id
    LEFT JOIN db_employee_name(p_lin_id) de2 ON de2.emp_id = b.committee_id
    JOIN po_committee_type pct ON pct.committee_type_id = a.committee_type_id 
    LEFT JOIN db_list_value_lang dlvl 
        ON dlvl.group_code = 'CommitteeDetailPosi'
        AND lower(dlvl.language_code) = lower(p_lin_id)
        AND dlvl.value = b.committee_posi
    WHERE prm.receive_master_id = p_receive_master_id
      AND coalesce(pct.goods_receipt_committee,false) = TRUE
    ORDER BY b.ord_seq;
END;
$function$
;
