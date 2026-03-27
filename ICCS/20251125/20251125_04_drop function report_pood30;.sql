drop function report_pood30;

CREATE OR REPLACE FUNCTION erp.report_pood30(p_lin_id character varying, p_pr_master_id integer)
 RETURNS TABLE(pr_master_id integer, pr_supplier_id integer, company_name character varying, report_name character varying, subject_header character varying, budget_year_header character varying, announce_date character varying, recipient_sign_image character varying, status_show_sign_image boolean, approve_name character varying, approve_posi character varying, approve_date character varying)
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
        )::character varying AS company_name,
        concat('เรื่อง ','ประกาศผู้ชนะการเสนอราคา', 
				a.subject,E'\n',
               ' โดย',pml.method_name)::character varying AS report_name,
        concat('ตามที่ ',
               (SELECT l.company_name 
                FROM db_company_lang l 
                WHERE l.company_code = a.company_code 
                AND lower(l.language_code) = lower(p_lin_id)),
               ' ได้มีโครงการ',
               a.subject,
               ' โดย', pml.method_name, ' นั้น'
        )::character varying AS subject_header,
        concat('การ',
               a.subject,
               ' ผู้ได้รับการคัดเลือก ได้แก่ ',
				aml.full_name,
			   ' โดยเสนอราคาเป็นจำนวนเงินทั้งสิ้น',
               '  ',
               to_char(a.total_amt, 'FM999,999,999.00'),
               ' บาท ',
               '(', erp.po_baht_text(a.total_amt), ')',
               ' รวมภาษีมูลค่าเพิ่มและภาษีอื่น ค่าขนส่ง ค่าจดทะเบียนและค่าใช้จ่ายอื่นๆ ทั้งปวง'
        )::character varying AS budget_year_header,
        concat('ประกาศ ณ วันที่ ',
               erp.po_format_date_thai(
	            null::varchar,
	            null::varchar,
	            null::varchar,
	            (case 
	            	when a.status = 'A'
	            		then (SELECT pwf.approve_date::date FROM po_work_flow pwf WHERE pwf.doc_no = a.pr_no and pwf.doc_type = a.doc_type ORDER BY pwf.seq desc LIMIT 1)
	            	else null
	            end),
	            p_lin_id::varchar
	           )
        )::character varying AS announce_date,
        CASE 
            WHEN deapprove.personal_id IS NOT NULL AND deapprove.signature_image_id IS NOT NULL THEN
                concat(
                    (SELECT sp.parameter_value  
                     FROM su_parameter sp 
                     WHERE sp.parameter_group_code = 'ContentPath'
                       AND sp.parameter_code = 'SignatureURL'),
                     '?PersonalId=', deapprove.personal_id,
                     '&ContentId=', deapprove.signature_image_id
                )
            ELSE NULL 
        END::character varying AS recipient_sign_image,
		case when a.status in ('A','E','R') then true
		else false end::bool as status_show_sign_image,
        concat('(', deapprove.emp_name, ')')::character varying AS approve_name,
        a.approve_posi::character varying AS approve_posi,
        concat((select erp.po_format_date_thai(
	            null::varchar,
	            null::varchar,
	            null::varchar,
	            pwf.approve_date ::date,
	            p_lin_id::varchar)
				from po_work_flow pwf
				where pwf.company_code = a.company_code 
				and pwf.doc_type = a.doc_type 
				and pwf.doc_no = a.pr_no
				order by pwf.seq desc  limit 1)
		)::character varying AS approve_date
    FROM po_pr_master a 
    LEFT JOIN db_list_value_lang Monthlang  
        ON Monthlang.group_code = 'Month' 
       AND Monthlang.value = TO_CHAR(A.PR_DATE, 'FMMM')
       AND lower(Monthlang.language_code) = lower(p_lin_id)
    LEFT JOIN db_employee_name(p_lin_id) deapprove 
        ON deapprove.emp_id = (select su.emp_id from su_user su 
								where su.user_id = (select pwf.approve_by_id 
													from po_work_flow pwf
													where pwf.company_code = a.company_code 
													and pwf.doc_type = a.doc_type 
													and pwf.doc_no = a.pr_no
													order by pwf.seq desc  limit 1
													)
								limit 1)
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
