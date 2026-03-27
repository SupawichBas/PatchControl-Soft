DROP FUNCTION erp.report_pood16_sub(varchar, int4);

CREATE OR REPLACE FUNCTION erp.report_pood16_sub(p_lin_id character varying, p_receive_master_id integer)
 RETURNS TABLE(sign1 character varying, committee_name character varying, committee_type_name character varying, committee_position character varying, url character varying)
 LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN QUERY
    SELECT 
        concat('( ลงชื่อ )')::character varying AS sign1,
        de2.emp_name::character varying AS committee_name,
        bpl.pos_name::character varying AS committee_type_name,
        de2.position_name::character varying AS committee_position,
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
    left join bg_usage_master bum on prm.company_code = bum.company_code 
    	and prm.doc_type = bum.po_doc_type
    	and prm.receive_no = bum.po_receive_no
    left join bg_approve_log bal on bum.company_code = bal.company_code
    	and bum.bg_type = bal.bg_type
    	and bum.usage_id = bal.doc_no
    	and bal.log_seq <> 0
	join bg_position bp on bal.pos_id = bp.pos_id
		join bg_position_lang bpl on bpl.pos_id = bp.pos_id
			and lower(bpl.language_code) = lower(p_lin_id)
    LEFT JOIN db_employee_name(p_lin_id) de2 
        ON de2.emp_id = (select su.emp_id from su_user su where su.user_id = bal.user_id limit 1)
    WHERE prm.receive_master_id = p_receive_master_id
    ORDER BY bal.log_seq;
END;
$function$
;
