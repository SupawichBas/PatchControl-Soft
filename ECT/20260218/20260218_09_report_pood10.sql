-- DROP FUNCTION erp.report_pood10(varchar, int4);

CREATE OR REPLACE FUNCTION erp.report_pood10(p_lin_id character varying, p_receive_master_id integer)
 RETURNS TABLE(receive_master_id integer, parameter1 character varying, parameter2 character varying, parameter3 character varying, parameter4 character varying, parameter5 character varying, parameter6 character varying, parameterdetail1 character varying, parameterdetail2 character varying, parameterdetail3 character varying, parameterdetail4 character varying, parameterdetail5 character varying, parameterdetail6 character varying, parameterdetail7 character varying, parameterdetail8 character varying, parameter7 character varying, parameter8 character varying)
 LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN QUERY
    SELECT 
	    a.receive_master_id::integer AS receive_master_id,
	    concat(a.government_agency)::character varying AS parameter1,
	    concat(a.contract_code_egp)::character varying AS parameter2,
	    concat(erp.po_format_date_thai(
	            null::varchar,
	            null::varchar,
	            null::varchar,
	            ppm.pr_date::date,
	            p_lin_id::varchar)
	    		)::character varying AS parameter3,
	    concat('รายงานผลพิจารณา รายละเอียด วิธีการและขั้นตอนการจัดซื้อจัดจ้าง')::character varying AS parameter4,
	    concat(a.attn_to)::character varying AS parameter5,
	    concat('ตามที่ ',a.attn_to,
	    		'ได้ซื้อวัสดุสำนักงาน ',(select concat((case when a.ref_doc_type = 'PO' then (select concat('ตามใบ',dlvl.value_text )
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
								),'ที่ ',COALESCE(a.contract_code_egp,'-'),' ลงวันที่ ',
        		coalesce((erp.po_format_date_thai(null, null, null, a.ref_doc_date::date, p_lin_id)),'-'))
				from po_receive_master prm
				left join po_pur_ord_master ppom on ppom.company_code = prm.company_code 
						and ppom.doc_type = prm.ref_doc_type 
						and ppom.po_no = prm.ref_doc_no 
				where prm.receive_master_id = a.receive_master_id),
	            ' ซึ่งมี ',concat(aml2.prefix_abbreviation, ' ',aml.first_name,' ',aml.last_name),
	            ' เป็นผู้ขายในราคาทั้งสิ้น ',TO_CHAR(COALESCE(ppm.total_amt, 0)::numeric, 'FM99,999,999.00'), ' บาท', ' (', erp.fn_baht_text(ppm.total_amt), ') ',
	            'ซึ่งผู้ขาย ได้ดำเนินการแล้วเสร็จตามใบสั่งซื้อแล้วได้ส่งมอบ เมื่อวันที่ ',
	            coalesce((erp.po_format_date_thai(null, null, null, a.receipt_date::date, p_lin_id)),'-'),
	            ' และผู้ตรวจรับพัสดุ ได้ตรวจรับพัสดุเรียบร้อยแล้ว เมื่อวันที่ ',
	            erp.po_format_date_thai(null::varchar,null::varchar,null::varchar,a.deliver_date::date,p_lin_id::varchar),
	            ' นั้น เพื่อให้ การดำเนินการเป็นไปตามระเบียบกระทรวงการคลังว่าด้วยการจัดซื้อจัดจ้างและการบริหารพัสดุภาครัฐ พ.ศ. 2560 ข้อ 16 จึงขอรายงานผลการพิจารณารายละเอียด วิธีการและขั้นตอนการจัดซื้อจัดจ้างพร้อม ทั้งหลักฐานประกอบ ตามรายการดังต่อไปนี้'
	    		)::character varying AS parameter6,
    		concat('รายงานขอซื้อหรือขอจ้างตามความในหมวด 2 ส่วนที่ 2 หมวด 3 ส่วนที่ 2 และหมวด 4 ส่วนที่ 2 แล้วแต่กรณี')::character varying AS parameterdetail1,
    		concat('เอกสารเกี่ยวกับการรับฟังความคิดเห็นร่างขอบเขตของงานหรือรายงานคุณลักษณะเฉพาะของพัสดุที่จะซื้อหรือจ้าง และผลการพิจารณาในครั้งนั้น (ถ้ามี)')::character varying AS parameterdetail2,
    		concat('ประกาศและเอกสารเชิญชวน หรือหนังสือเชิญชวน และเอกสารอื่นที่เกี่ยวข้อง')::character varying AS parameterdetail3,
    		concat('ข้อเสนอของผู้ยื่นข้อเสนอทุกราย')::character varying AS parameterdetail4,
    		concat('บันทึกรายงานการพิจารณาคัดเลือกข้อเสนอ')::character varying AS parameterdetail5,
    		concat('ประกาศผลการพิจารณาคัดเลือกผู้ชนะการจัดซื้อจัดจ้างหรือผู้ได้รับการคัดเลือก')::character varying AS parameterdetail6,
    		concat('สัญญาหรือข้อตกลงเป็นหนังสือรวมทั้งการแก้ไขสัญญาหรือข้อตกลงเป็นหนังสือ (ถ้ามี)')::character varying AS parameterdetail7,
    		concat('บันทึกรายงานผลการตรวจรับพัสดุ')::character varying AS parameterdetail8,
	    	concat('ผู้อำนวยการสำนักงานคณะกรรมการการเลือกตั้งประจำจังหวัด... ปฏิบัติหน้าที่แทน')::character varying AS parameter7,
	    	concat(pml.method_name)::character varying AS parameter8
	FROM po_receive_master a
	join po_pr_master ppm on ppm.company_code = a.company_code
		and ppm.doc_type = a.pr_type
		and ppm.pr_no = a.pr_no
	LEFT JOIN db_list_value_lang Monthlang ON Monthlang.group_code = 'Month' 
	   AND Monthlang.value = TO_CHAR(ppm.PR_DATE, 'FMMM')
	   AND lower(Monthlang.language_code) = lower(p_lin_id)
	LEFT JOIN db_employee_name(p_lin_id) deapprove ON deapprove.emp_id = ppm.approve_id
	LEFT JOIN po_pr_supplier pps ON ppm.pr_master_id = pps.pr_master_id
	LEFT JOIN ap_member_lang aml ON pps.ap_member_id = aml.ap_member_id
	    AND lower(aml.language_code) = lower(p_lin_id)
		left join db_prefix_lang aml2 on aml2.prefix_id = aml.prefix_id 
			and lower(aml2.language_code) = lower(p_lin_id)
	LEFT JOIN po_method_lang pml ON ppm.pr_method_id = pml.method_id
	    AND lower(pml.language_code) = lower(p_lin_id)
	WHERE a.receive_master_id = p_receive_master_id;
END;
$function$
;
