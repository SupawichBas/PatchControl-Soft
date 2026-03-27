DROP FUNCTION erp.report_pood04(varchar, int4);

CREATE OR REPLACE FUNCTION erp.report_pood04(p_lin_id character varying, p_pr_master_id integer)
 RETURNS TABLE(pr_master_id integer, pr_supplier_id integer, parameter1 character varying, parameter2 character varying, parameter3 character varying, parameter4 character varying, parameter5 character varying, approve_date character varying)
 LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN QUERY
    SELECT 
        a.pr_master_id::integer AS pr_master_id,
		pps.pr_supplier_id::integer AS pr_supplier_id,
        concat('ประกาศ',
               (SELECT l.company_name 
                FROM db_company_lang l 
                WHERE l.company_code = a.company_code 
                AND lower(l.language_code) = lower(p_lin_id))
        )::character varying AS parameter1,
        concat(a.subject,' โดย',pml.method_name)::character varying AS parameter2,
        concat((SELECT l.company_name 
                FROM db_company_lang l 
                WHERE l.company_code = a.company_code 
                AND lower(l.language_code) = lower(p_lin_id)),
               ' ได้',
               a.subject,
               ' โดย', pml.method_name, ' นั้น'
        )::character varying AS parameter3,
        concat('การ',
               a.subject,
               ' ผู้ได้รับการคัดเลือก ได้แก่ ',
				aml.full_name,
			   ' โดยเสนอราคา',
               ' เป็นจำนวนเงินทั้งสิ้น ',
               to_char(a.total_amt, 'FM999,999,999.00'),
               ' บาท ',
               '(', erp.po_baht_text(a.total_amt), ')',
               ' ซึ่งรวมภาษีมูลค่าเพิ่ม ภาษีอื่น ค่าขนส่ง ค่าจดทะเบียน และค่าใช้จ่ายอื่นๆ ทั้งปวง'
        )::character varying AS parameter4,
        concat(erp.po_format_date_thai(
	            null::varchar,
	            null::varchar,
	            null::varchar,
	            a.pr_date::date,
	            p_lin_id::varchar
	           )
        )::character varying AS parameter5,
        concat(
			erp.po_format_date_thai(
	            null::varchar,
	            null::varchar,
	            null::varchar,
	            a.approve_date::date,
	            p_lin_id::varchar
	        )
		)::character varying AS approve_date
    FROM po_pr_master a 
    LEFT JOIN db_list_value_lang Monthlang  
        ON Monthlang.group_code = 'Month' 
       AND Monthlang.value = TO_CHAR(A.PR_DATE, 'FMMM')
       AND lower(Monthlang.language_code) = lower(p_lin_id)
    LEFT JOIN db_employee_name(p_lin_id) deapprove 
        ON deapprove.emp_id = a.approve_id
    LEFT JOIN po_pr_supplier pps 
    	ON a.pr_master_id = pps.pr_master_id
    LEFT JOIN ap_member_lang aml ON pps.ap_member_id = aml.ap_member_id
        AND lower(aml.language_code) = lower(p_lin_id)
	LEFT JOIN po_method_lang pml
	    ON a.pr_method_id = pml.method_id
	    AND lower(pml.language_code) = lower(p_lin_id)
    WHERE a.pr_master_id = p_pr_master_id;
END;
$function$
;
