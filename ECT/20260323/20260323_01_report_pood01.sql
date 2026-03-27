DROP FUNCTION erp.report_pood01;

CREATE OR REPLACE FUNCTION erp.report_pood01(p_lin_id character varying, p_tor_master_id integer)
 RETURNS TABLE(parameter1 character varying, parameter2 character varying, parameter3 character varying, parameter4 character varying, parameterdetail1 character varying, parameterdetail2 character varying, parameterdetail3 character varying, parameterdetail4 character varying, parameter5 character varying, parameter6 character varying, parameter7 character varying, parameter8 character varying, parameter9 character varying, parameter10 character varying, parameter11 character varying, parameter12 character varying)
 LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN QUERY
SELECT concat(a.government_agency)::character varying as parameter1
		,concat(erp.po_format_date_thai(null::varchar,null::varchar,null::varchar,a.tor_date::date,p_lin_id::varchar))::character varying as parameter2
		,concat('การแต่งตั้งผู้รับผิดชอบในการจัดทำรายละเอียดคุณลักษณะเฉพาะของพัสดุและกำหนดราคากลาง ',a.subject)::character varying as parameter3
		,concat(a.attn_to)::character varying as parameter4
		,concat(a.content1)::character varying as parameterDetail1
		,concat(a.content2)::character varying as parameterDetail2
		,concat(a.content3,' เป็นไปด้วยความเรียบร้อย ตามข้อ 21 แห่งระเบียบกระทรวงการคลังว่าด้วยการจัดซื้อจัดจ้างและบริหารพัสดุภาครัฐ พ.ศ. 2560 เห็นควรแต่งตั้งบุคคลดังต่อไปนี้เป็น ',
				(select pctl.committee_type_name as committee_name
				from po_tor_committee_master ppcm
			    JOIN po_committee_type pct 
			        ON pct.committee_type_id = ppcm.committee_type_id 
			    LEFT JOIN po_committee_type_lang pctl 
			        ON pctl.committee_type_id = pct.committee_type_id 
		        	AND lower(pctl.language_code) = lower(p_lin_id)
				where ppcm.company_code = a.company_code
				and ppcm.doc_no = a.tor_no
				and ppcm.doc_type = a.doc_type 
				and coalesce(pct.goods_tor_committee,false) = true
				order by 1 limit 1),'ดังนี้',E'\n',
				(select STRING_AGG(var.committee_name,E'\n') AS display
					from(	select ppcm.tor_committee_master_id ,
									CONCAT('   ',' (', ROW_NUMBER() OVER (ORDER BY ppcd.tor_committee_detail_id), ') ', 
					                de2.emp_name, ' ตำแหน่ง ', COALESCE(de2.position_name, '-'), 
					               ' เป็น ', COALESCE(dlvl.value_text, '-'))::character varying AS committee_name
							from po_tor_committee_master ppcm 
							JOIN po_tor_committee_detail ppcd
							        ON ppcd.tor_committee_master_id = ppcm.tor_committee_master_id
						    LEFT JOIN db_employee_name(p_lin_id) de2 
						        ON de2.emp_id = ppcd.committee_id
						    left JOIN db_list_value_lang dlvl 
						        ON dlvl.group_code = 'CommitteeDetailPosi'
						        AND lower(dlvl.language_code) = lower(p_lin_id)
						        AND dlvl.value = ppcd.committee_posi 
						    JOIN po_committee_type pct 
						        ON pct.committee_type_id = ppcm.committee_type_id 
							where ppcm.company_code = a.company_code
							and ppcm.doc_no = a.tor_no
							and ppcm.doc_type = a.doc_type
							and coalesce(pct.goods_tor_committee,false) = true
							order by 1
					) as var)
				)::character varying as parameterDetail3
		,concat(a.content4)::character varying as parameterDetail4
		,concat('หัวหน้ากลุ่มงานจัดการเลือกตั้งฯ')::character varying as parameter5
		,concat(a.attn_to)::character varying as parameter6
		,concat('พิจารณาแล้ว เพื่อให้การจัดหาพัสดุเป็นไปตามระเบียบกระทรวงการคลังว่าด้วยการจัดซื้อจัดจ้างและการบริหารพัสดุภาครัฐ พ.ศ.2560 ข้อ 21 จึงเห็นควรมอบหมายให้ ',E'\n',
				(select STRING_AGG(var.committee_name,E'\n') AS display
					from(	select ppcm.tor_committee_master_id ,
									CONCAT('   ',' (', ROW_NUMBER() OVER (ORDER BY ppcd.tor_committee_detail_id), ') ', 
					                de2.emp_name, ' ตำแหน่ง ', COALESCE(de2.position_name, '-'), 
					               ' เป็น ', COALESCE(dlvl.value_text, '-'))::character varying AS committee_name
							from po_tor_committee_master ppcm 
							JOIN po_tor_committee_detail ppcd
							        ON ppcd.tor_committee_master_id = ppcm.tor_committee_master_id
						    LEFT JOIN db_employee_name(p_lin_id) de2 
						        ON de2.emp_id = ppcd.committee_id
						    left JOIN db_list_value_lang dlvl 
						        ON dlvl.group_code = 'CommitteeDetailPosi'
						        AND lower(dlvl.language_code) = lower(p_lin_id)
						        AND dlvl.value = ppcd.committee_posi 
						    JOIN po_committee_type pct 
						        ON pct.committee_type_id = ppcm.committee_type_id 
							where ppcm.company_code = a.company_code
							and ppcm.doc_no = a.tor_no
							and ppcm.doc_type = a.doc_type
							and coalesce(pct.goods_tor_committee,false) = true
							order by 1
					) as var),E'\n',
				'เป็นผู้รับผิดชอบในการจัดทำร่างขอบเขตของงานหรือ รายละเอียดคุณลักษณะเฉพาะของพัสดุและกำหนดหลักเกณฑ์การพิจารณาคัดเลือกข้อเสนอและกำหนดราคากลาง โดยใช้บันทึกนี้แทนคำสั่ง')::character varying as parameter7
		,concat('หัวหน้ากลุ่มงานจัดการเลือกตั้งฯ')::character varying as parameter8
		,concat('ผู้อำนวยการสำนักงานคณะกรรมการการเลือกตั้งประจำจังหวัด... ปฏิบัติหน้าที่แทน')::character varying as parameter9
		,concat('เลขาธิการคณะกรรมการการเลือกตั้ง')::character varying as parameter10
		,concat(a.phone_number)::character varying as parameter11
		,concat(a.ref_no)::character varying as parameter12
	from po_tor_master a
	where a.tor_master_id = p_tor_master_id;
	END;
$function$
;
