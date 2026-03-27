DROP FUNCTION erp.report_pood03(varchar, int4);

CREATE OR REPLACE FUNCTION erp.report_pood03(p_lin_id character varying, p_pr_master_id integer)
 RETURNS TABLE(pr_master_id integer, parameter1 character varying, parameter2 character varying, parameter3 character varying, parameter4 character varying, parameter5 character varying, parameter6 character varying, parameterdetail1 character varying, parameterdetail2 character varying, parameterdetail3 character varying, parameterfooter1 character varying, parameterfooter2 character varying, parameterfooter3 character varying, parameterfooter4 character varying, parameterfooter5 character varying, parameterfooter6 character varying, parameterfooter7 character varying)
 LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN QUERY
	SELECT 
        a.pr_master_id::integer AS pr_master_id,
        concat('กลุ่มอำนวยการ')::character varying AS parameter1,
	    concat('012-3456789')::character varying AS parameter2,
        concat(a.ref_no)::character varying AS parameter3,
        concat(erp.po_format_date_thai(
	            null::varchar,
	            null::varchar,
	            null::varchar,
	            a.pr_date::date,
	            p_lin_id::varchar)
	    )::character varying AS parameter4,
	    concat(a.subject)::character varying AS parameter5,
	    concat(pml.method_name)::character varying AS parameter6,
	    concat('ตามที่ เลขาธิการคณะกรรมการเลือกตั้ง ได้อนุมัติให้',a.subject,' เพื่อใช้ในการ',a.purpose,' และการมีส่วนร่วม โดย',pml.method_name,' ภายในวงเงินงบประมาณ ',
               to_char(a.total_amt, 'FM999,999,999.00'),
               ' บาท ',
               '(', erp.po_baht_text(a.total_amt), ')',
	    		' จึงขอรายงานผลการพิจารณาการจัดซื้อ ดังนี้')::character varying AS parameterdetail1,
	    concat('รายงานผลการพิจารณางาน',a.subject,' ผู้เสนอราคาที่ได้รับ การคัดเลือก ได้แก่ ',concat(aml2.prefix_abbreviation, ' ',aml.first_name,' ',aml.last_name),
	    		'ราคาที่เสนอเป็นจำนวนเงิน ',
               to_char(a.total_amt, 'FM999,999,999.00'),
               ' บาท ',
               '(', erp.po_baht_text(a.total_amt), ')',
	    		' และเจ้าหน้าที่ ได้ต่อรองราคากับ ',concat(aml2.prefix_abbreviation, ' ',aml.first_name,' ',aml.last_name),
	    		' แล้ว ได้รับแจ้งว่าเป็นราคาต่ำสุดไม่สามารถลดราคาลงได้ (หรือทาง',concat(aml2.prefix_abbreviation, ' ',aml.first_name,' ',aml.last_name),
				' ยินดีลดราคาเหลือเพียง ',
				to_char(a.total_amt, 'FM999,999,999.00'),
               ' บาท ',
               '(', erp.po_baht_text(a.total_amt), ')',
				' ) จึงได้ตกลงซื้อกับ ',concat(aml2.prefix_abbreviation, ' ',aml.first_name,' ',aml.last_name),
	    		'เป็นจำนวนเงิน ',
				to_char(a.total_amt, 'FM999,999,999.00'),
               ' บาท ',
               '(', erp.po_baht_text(a.total_amt), ')')::character varying AS parameterdetail2,
	    concat('จึงเรียนมาเพื่อโปรดพิจารณา หากเห็นชอบขอได้โปรดอนุมัติให้สั่งซื้อจากผู้เสนอราคาที่ได้รับการคัดเลือกและลงนามประกาศผลผู้ได้รับการคัดเลือกตามมาตรา ๖๖ แห่งพระราชบัญญัติการจัดซื้อจัดจ้างและการบริหารพัสดุภาครัฐ พ.ศ. ๒๕๖๐ ด้วย')::character varying AS parameterdetail3,
	    concat('เจ้าหน้าที่')::character varying AS parameterfooter1,
	    concat(pml.method_name)::character varying AS parameterfooter2,
	    concat('ได้พิจารณาแล้วเห็นว่า เป็นไปตามระเบียบกระทรวงการคลังว่าด้วยการจัดซื้อจัดจ้างและการบริหารพัสดุภาครัฐ พ.ศ. 2560 และตามที่กำหนดในกฎกระทรวงแล้ว')::character varying AS parameterfooter3,
	    concat('จึงเรียนมาเพื่อโปรดพิจารณาอนุมัติตามที่เจ้าหน้าที่เสนอและลงนามในประกาศผู้ได้รับการคัดเลือก')::character varying AS parameterfooter4,
	    concat('หัวหน้าเจ้าหน้าที่')::character varying AS parameterfooter5,
	    concat('ผู้อำนวยการสำนักงานคณะกรรมการการเลือกตั้งประจำจังหวัด... ปฏิบัติหน้าที่แทน')::character varying AS parameterfooter6,
		concat(pml.method_name)::character varying AS parameterfooter7
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
		left join db_prefix_lang aml2 on aml2.prefix_id = aml.prefix_id 
			and lower(aml2.language_code) = lower(p_lin_id)
	LEFT JOIN po_method_lang pml
	    ON a.pr_method_id = pml.method_id
	    AND lower(pml.language_code) = lower(p_lin_id)
    WHERE a.pr_master_id = p_pr_master_id;
END;
$function$
;
