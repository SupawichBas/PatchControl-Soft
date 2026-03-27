DROP FUNCTION erp.report_pood16(varchar, int4);

CREATE OR REPLACE FUNCTION erp.report_pood16(p_lin_id character varying, p_receive_master_id integer)
 RETURNS TABLE(receive_master_id integer, parameter1 character varying, parameter2 character varying, parameter3 character varying, parameter4 character varying, parameter5 character varying, parameter6 character varying, parameter7 character varying, parameter8 character varying, parameter9 character varying, parameter10 character varying)
 LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN QUERY
SELECT 
    a.receive_master_id::integer AS receive_master_id,
    concat(ppm.attn_to)::character varying AS parameter1,--ส่วนราชการ
    concat('')::character varying AS parameter2,--โทร
    concat('')::character varying AS parameter3,--ที่
    concat(erp.po_format_date_thai(null::varchar,null::varchar,null::varchar,a.receive_date::date,p_lin_id::varchar))::character varying AS parameter4,--วันที่
    concat(ppm.subject)::character varying AS parameter5,--เรื่อง
    concat(a.attn_to)::character varying AS parameter6,--เรียน
    concat(
            'ตามที่ ',(select concat(l.company_name,'ประจำจังหวัด',dpl.province_name ) from db_company_lang l
            												left join db_province_lang dpl on dpl.province_id = l.province_id
            														and lower(l.language_code) = lower(dpl.language_code)
            												where l.company_code = a.company_code
            												and lower(l.language_code) = lower(p_lin_id)),
            'ได้ ',ppm.subject,' โดยวิธี',pml.method_name,' เป็นจำนวนเงินทั้งสิ้น ',
            TO_CHAR(COALESCE(a.total_amt, 0)::numeric, 'FM99,999,999.00'), ' บาท', ' (', erp.po_baht_text(a.total_amt), ') ',
            'จาก', concat(aml2.prefix_abbreviation, ' ',aml.first_name,' ',aml.last_name),' ',
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
				where prm.receive_master_id = a.receive_master_id),
            ' โดยแต่งตั้งให้ ', coalesce((SELECT concat(de2.emp_name,' ตำแหน่ง ',dlvl.value_text)
					    from po_receive_committee_master pcm 
						join po_receive_committee_detail b on b.receive_committee_master_id = pcm.receive_committee_master_id
					    LEFT JOIN db_employee_name(p_lin_id) de2 ON de2.emp_id = b.committee_id
					    JOIN po_committee_type pct ON pct.committee_type_id = pcm.committee_type_id 
					    LEFT JOIN po_committee_type_lang pctl ON pctl.committee_type_id = pct.committee_type_id 
					        AND lower(pctl.language_code) = lower(p_lin_id)
					    JOIN db_list_value_lang dlvl ON dlvl.group_code = 'CommitteeDetailPosi'
					        AND lower(dlvl.language_code) = lower(p_lin_id)
					        AND dlvl.value = b.committee_posi 
					    WHERE pcm.company_code = a.company_code
					    AND pcm.doc_type = a.doc_type  
					    AND pcm.doc_no = a.receive_no 
					    AND coalesce(pct.goods_receipt_committee,false) = true
					    ORDER BY b.ord_seq
					    limit 1),'-'),
            ' เป็นผู้ตรวจรับพัสดุ นั้น')::character varying AS parameter7,--เรื่องเดิม
        concat(
            'บัดนี้ ', concat(aml2.prefix_abbreviation, ' ',aml.first_name,' ',aml.last_name),
            ' ได้ส่งมอบ', ppm.subject,' ',concat('ตาม ใบแจ้งหนี้/ใบกำกับภาษี / ใบส่งสินค้า / บิลเงินสด / ใบส่งงาน เลขที่ ',coalesce(a.receipt_no,'-'),' ',
					erp.po_format_date_thai('ลงวันที่', null, null, a.receipt_date::date, p_lin_id)),
            ' ซึ่งผู้ตรวจรับพัสดุ ได้ทำการตรวจรับเป็นการถูกต้อง ครบถ้วนตามรายการสั่งซื้อแล้ว จึงได้ลงลายมือชื่อไว้เป็นหลักฐาน เมื่อวันที่ ',
            erp.po_format_date_thai(null::varchar,null::varchar,null::varchar,a.receive_date::date,p_lin_id::varchar),' ',
            'และเลขทธิการคณะกรรมการการเลือกตั้ง ได้รับทราบรายงานผลการตรวจรับแล้ว ตามเอกสารที่แนบมาพร้อมนี้'
        )::character varying AS parameter8,--ข้อเท็จจริง
    concat('เจ้าหน้าที่ได้ตรวจสอบแล้ว เห็นควรอนุมัตให้เบิกจ่ายเงินค่า', ppm.subject,' เป็นจำนวนเงินทั้งสิ้น ',
            TO_CHAR(COALESCE(a.total_amt, 0)::numeric, 'FM99,999,999.00'), ' บาท', ' (', erp.po_baht_text(a.total_amt), ') ',
            'ให้แก่ ',concat(aml2.prefix_abbreviation, ' ',aml.first_name,' ',aml.last_name)
        )::character varying AS parameter9,--ข้อพิจารณา
    concat('จึงเรียนมาเพื่อฌปรดอนุมัติ')::character varying AS parameter10--ข้อเสนอ
FROM po_receive_master a
left join po_pr_master ppm on ppm.company_code = a.company_code
	and ppm.doc_type = a.pr_type
	and ppm.pr_no = a.pr_no
LEFT JOIN po_method_lang pml ON ppm.pr_method_id = pml.method_id
    AND lower(pml.language_code) = lower(p_lin_id)
left join ap_member_lang aml on aml.ap_member_id = a.ap_member_id
	and lower(aml.language_code) = lower(p_lin_id)
left join db_prefix_lang aml2 on aml2.prefix_id = aml.prefix_id 
	and lower(aml2.language_code) = lower(p_lin_id)
WHERE a.receive_master_id = p_receive_master_id;
END;
$function$
;
