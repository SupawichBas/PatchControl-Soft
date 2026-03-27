DROP FUNCTION erp.report_pood02;

CREATE OR REPLACE FUNCTION erp.report_pood02(p_lin_id character varying, p_procurement_master_id integer)
 RETURNS TABLE(procurement_master_id integer, parameter1 character varying, parameter2 character varying, parameter3 character varying, parameter4 character varying, parameter5 character varying, parameter6 character varying, parameterdetail0 character varying, parameterdetail1 character varying, parameterdetail2 character varying, parameterdetail3 character varying, parameterdetail4 character varying, parameterdetail5 character varying, parameterdetail6 character varying, parameterdetail7 character varying, parameterdetail8s1 character varying, parameterdetail8s2 character varying, parameterdetailfooter character varying, parameterfooter1 character varying, parameterfooter2 character varying, parameterfooter3 character varying, parameterfooter4 character varying, parameterfooter5 character varying, parameterfooter6 character varying)
 LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN QUERY
	SELECT 
        a.procurement_master_id::integer AS procurement_master_id,
        concat(a.government_agency)::character varying AS parameter1,
        concat(a.ref_no)::character varying AS parameter2,
        concat(erp.po_format_date_thai(
	            null::varchar,
	            null::varchar,
	            null::varchar,
	            a.procurement_date::date,
	            p_lin_id::varchar)
	    )::character varying AS parameter3,
	    concat('ายงานขอซื้อขอจ้าง ',a.subject)::character varying AS parameter4,
	    concat(a.attn_to)::character varying AS parameter5,
	    concat(a.phone_number)::character varying AS parameter6,
	    concat('ด้วยกลุ่มงานจัดการเลือกตั้งและการมีส่วนร่วม มีความประสงค์',a.subject,
				' จำนวน ',(select to_char(count(d.procurement_detail_id), 'FM999,999,999') from po_procurement_detail d where d.procurement_master_id = a.procurement_master_id),
				' รายการ เพื่อใช้ในการปฏิบัติงาน โดยวิธีเฉพาะเจาะจง ตามมาตรา 56 (2) (ข) แห่งพระราชบัญญัติ การจัดซื้อจัดจ้างและการบริหารพัสดุภาครัฐ พ.ศ. 2560')::character varying AS parameterdetail0,
	    concat(a.content2)::character varying AS parameterdetail1,
	    concat(a.content3)::character varying AS parameterdetail2,
	    concat(a.content4)::character varying AS parameterdetail3,
	    concat((SELECT STRING_AGG(
					    	'เงินงบประมาณรายจ่ายประจำปี '|| ppby.budget_year || ' ' || pbsl.bg_sec_name || ' ' || pssl.sub_section_name || ' เป็นจำนวนเงิน ' ||
					        to_char(ppby.fwd_amt, 'FM999,999,999.00') || ' บาท' || concat(' (', erp.po_baht_text(ppby.fwd_amt), ') '),
					        ' ,'
					    ) AS display_text
					FROM po_procurement_budget_year ppby
					inner join pl_budget_section pbs on pbs.bg_sec_id  = ppby.bg_sec_id 
					left join pl_budget_section_lang pbsl  on pbsl.bg_sec_id = pbs.bg_sec_id and pbsl.language_code  = p_lin_id
					inner join pl_sub_section pss on ppby.sub_section_id = pss.sub_section_id              
					left join pl_sub_section_lang pssl on pss.sub_section_id = pssl.sub_section_id and pssl.language_code = p_lin_id
					WHERE ppby.procurement_master_id = a.procurement_master_id))::character varying AS parameterdetail4,
	    concat('กำหนดเวลาส่งมอบพัสดุ ภายใน ',a.complete_day,' วัน นับถัดจากวันที่สั่งซื้อ')::character varying AS parameterdetail5,
	    concat(a.content5)::character varying AS parameterdetail6,
	    concat('การพิจารณาคัดเลือกข้อเสนอโดยใช้เกณฑ์ราคา')::character varying AS parameterdetail7,
	    concat('เห็นชอบรายละเอียดคุณลักษณะเฉพาะของวัสดุสำนักงาน จำนวน ',(select to_char(count(d.procurement_detail_id), 'FM999,999,999') from po_procurement_detail d where d.procurement_master_id = a.procurement_master_id),
				' รายการ และราคากลางตามที่ผู้รับผิดชอบเสนอรายละเอียดตามเอกสารแนบ')::character varying AS parameterdetail8s1,
	    concat('แต่งตั้งคณะกรรการตรวจรับพัสดุหรือผู้ตรวจรับพัสดุ ดังต่อไปนี้',E'\n',
				(select STRING_AGG(var.committee_name,E'\n') AS display
					from(select ppcd.committee_detail_id,
							CONCAT('   ',' (', ROW_NUMBER() OVER (ORDER BY ppcd.committee_detail_id), ') ', 
			                de2.emp_name, ' ตำแหน่ง ', COALESCE(de2.position_name, '-'), 
			               ' เป็น ', COALESCE(dlvl.value_text, '-'))::character varying AS committee_name
							from po_procurement_committee_master ppcm 
						    JOIN po_committee_type pct 
						        ON pct.committee_type_id = ppcm.committee_type_id 
							JOIN po_procurement_committee_detail ppcd
							        ON ppcd.committee_master_id = ppcm.committee_master_id
						    LEFT JOIN db_employee_name(p_lin_id) de2 
						        ON de2.emp_id = ppcd.committee_id
						    left JOIN db_list_value_lang dlvl 
						        ON dlvl.group_code = 'CommitteeDetailPosi'
						        AND lower(dlvl.language_code) = lower(p_lin_id)
						        AND dlvl.value = ppcd.committee_posi 
							where ppcm.company_code = a.company_code
							and ppcm.doc_no = a.procurement_no
							and ppcm.doc_type = a.doc_type
							and coalesce(pct.goods_receipt_committee,false) = true
							order by 1 ) as var
				),E'\n','โดยขอใช้บันทึกนี้แทนคำสั่งแต่งตั้ง')::character varying AS parameterdetail8s2,
	    concat('อนุมัติให้ดำเนินการ ',a.subject,
				' จำนวน ',(select to_char(count(d.procurement_detail_id), 'FM999,999,999') from po_procurement_detail d where d.procurement_master_id = a.procurement_master_id),
				' รายการ ในวงเงินงบประมาณ ', to_char(a.total_amt, 'FM999,999,999.00'),' บาท', ' (', erp.po_baht_text(a.total_amt), ') ','โดย',pml.method_name)::character varying AS parameterdetailfooter,
	    concat('เจ้าหน้าที่')::character varying AS parameterfooter1,
	    concat(a.attn_to)::character varying AS parameterfooter2,
	    concat('ได้พิจารณาแล้วเห็นว่า เป็นไปตามระเบียบกระทรวงการคลังว่าด้วยการจัดซื้อจัดจ้างและการบริหารพัสดุภาครัฐ พ.ศ. 2560 และตามที่กำหนดในกฎกระทรวงแล้ว')::character varying AS parameterfooter3,
	    concat('เจ้าหน้าที่')::character varying AS parameterfooter4,
	    concat('ผู้อำนวยการสำนักงานคณะกรรมการการเลือกตั้งประจำจังหวัด... ปฏิบัติหน้าที่แทน')::character varying AS parameterfooter5,
	    concat('เลขาธิการคณะกรรมการการเลือกตั้ง')::character varying AS parameterfooter6
    FROM po_procurement_master a 
    LEFT JOIN db_list_value_lang Monthlang  
        ON Monthlang.group_code = 'Month' 
       AND Monthlang.value = TO_CHAR(a.procurement_date, 'FMMM')
       AND lower(Monthlang.language_code) = lower(p_lin_id)
	LEFT JOIN po_method_lang pml
	    ON a.procurement_method_id = pml.method_id
	    AND lower(pml.language_code) = lower(p_lin_id)
    WHERE a.procurement_master_id = p_procurement_master_id;
END;
$function$
;
