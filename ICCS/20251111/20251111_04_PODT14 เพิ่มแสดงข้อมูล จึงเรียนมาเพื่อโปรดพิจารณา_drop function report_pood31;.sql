drop function report_pood31;

CREATE OR REPLACE FUNCTION erp.report_pood31(p_lin_id character varying, p_pr_master_id integer)
 RETURNS TABLE(header_1 character varying, header_2 character varying, subject_1 character varying, ref_no character varying, date character varying, subject_2 character varying, dear character varying, report_name character varying, section_1 character varying, detail_section_1 character varying, section_2 character varying, detail_section_2 character varying, section_3 character varying, detail_section_3 character varying, section_4 character varying, detail_section_4 character varying, section_5 character varying, detail_section_5 character varying, section_6 character varying, detail_section_6 character varying, section_7 character varying, detail_section_7 character varying, section_8 character varying, detail_section_8 character varying, therefore character varying, therefore_1 character varying, recipient_sign_image_1 character varying, status_show_sign_image_1 boolean, approve_name_1 character varying, position_1 character varying, approve_date_1 character varying, recipient_sign_image_2 character varying, status_show_sign_image_2 boolean, approve_name_2 character varying, position_2 character varying, approve_date_2 character varying)
 LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN QUERY
    SELECT 
        concat('รายงานขออนุมัติดำเนินการ<br>ขั้นตอนที่ ๔ (ซื้อจ้างทั่วไป)')::character varying AS header_1,
        concat('บันทึกข้อความ')::character varying AS header_2,
        concat('<b>ส่วนราชการ</b> กองอำนวยการ  กลุ่มพัสดุ  โทร. ๐ ๒๒๘๐ ๐๐๙๑ - ๖ ต่อ ๔๐๒๑,๔๐๕๘,๔๐๕๙')::character varying AS subject_1,
        concat('<b>ที่</b> ', a.ref_no)::character varying AS ref_no,
        concat('<b>วันที่</b> ',
	        erp.po_format_date_thai(
	            null::varchar,
	            null::varchar,
	            null::varchar,
	            a.pr_date::date,
	            p_lin_id::varchar
	        )
	    )::character varying AS date,
        concat('<b>', 'เรื่อง ', '</b>', ' ขออนุมัติให้ดำเนินการ',  a.subject, ' โดย', pml.method_name)::character varying AS subject_2,
        concat('เรียน ', a.attn_to )::character varying AS dear,
        concat('ด้วย', 
				(SELECT l.company_name 
                FROM db_company_lang l 
                WHERE l.company_code = a.company_code 
                AND lower(l.language_code) = lower(p_lin_id)),
                'ได้เห็นชอบให้ดำเนินการ',
                a.subject,
                ' ประกอบกับคณะกรรมการฯ ได้รายงานผลการพิจารณาจัดทำขอบเขตของงานและกำหนดราคากลางงานฯ ดังกล่าวเรียบร้อยแล้ว',
                ' <b>','ดังเอกสารแนบ 1','</b> ',
                'ทั้งนี้ กลุ่มพัสดุ กองอำนวยการ จึงรายงานขอดำเนินการ',
                a.subject,
                ' โดย',
                pml.method_name,
                ' โดยมีรายละเอียดดังต่อไปนี้'
        )::character varying AS report_name,
        concat('๑. เหตุผลและความจำเป็น')::character varying AS section_1,
        a.content1::character varying AS detail_section_1,
        concat('๒. ขอบเขตของงาน')::character varying AS section_2,
        a.content2::character varying AS detail_section_2,
        concat('๓. ราคากลางของพัสดุ')::character varying AS section_3,
        a.content3::character varying AS detail_section_3,
        concat('๔. วงเงินงบประมาณ')::character varying AS section_4,
        a.content4::character varying AS detail_section_4,
        concat('๕. กำหนดระยะเวลาดำเนินงาน/ส่งมอบงาน')::character varying AS section_5,
        a.content5::character varying AS detail_section_5,
        concat('๖. วิธีที่จะจ้างและเหตุผลที่ต้องจ้างโดยวิธีนั้น')::character varying AS section_6,
        a.content6::character varying AS detail_section_6,
        concat('๗. หลักเกณฑ์การพิจารณา')::character varying AS section_7,
        a.content7::character varying AS detail_section_7,
		concat('8. ข้อเสนออื่น ๆ')::character varying AS section_8,
		a.content8::character varying AS detail_section_8,
        concat('จึงเรียนมาเพื่อโปรดพิจารณา')::character varying AS therefore,
        concat(a.content9)::character varying AS therefore_1,
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
        END::character varying AS recipient_sign_image_1,
		case when po_get_show_image(a.company_code,a.doc_type,a.pr_no,a.head_emp_id) = 'Y' then true
		else false end::bool as status_show_sign_image_1,
        concat('(', deapprove.emp_name, ')')::character varying AS approve_name_1,
        a.head_posi::character varying AS position_1,
        concat('')::character varying AS approve_date_1,
		CASE 
            WHEN approve.personal_id IS NOT NULL AND approve.signature_image_id IS NOT NULL THEN
                concat(
                    (SELECT sp.parameter_value  
                     FROM su_parameter sp 
                     WHERE sp.parameter_group_code = 'ContentPath'
                       AND sp.parameter_code = 'SignatureURL'),
                     '?PersonalId=', approve.personal_id,
                     '&ContentId=', approve.signature_image_id
                )
            ELSE NULL 
        END::character varying AS recipient_sign_image_2,
		case when po_get_show_image(a.company_code,a.doc_type,a.pr_no,a.sign_id) = 'Y' then true
		else false end::bool as status_show_sign_image_2,
        concat('(', approve.emp_name, ')')::character varying AS approve_name_2,
        a.sign_posi::character varying AS position_2,
        concat('')::character varying AS approve_date_2
    FROM po_pr_master a
    LEFT JOIN po_method_lang pml
	    ON a.pr_method_id = pml.method_id
	    AND lower(pml.language_code) = lower(p_lin_id)
	LEFT JOIN db_employee_name(p_lin_id) deapprove 
        ON deapprove.emp_id = a.head_emp_id
    LEFT JOIN db_employee_name(p_lin_id) approve 
        ON approve.emp_id = a.sign_id
	WHERE a.pr_master_id = p_pr_master_id;
END;
$function$
;
