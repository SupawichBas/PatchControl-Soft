-- DROP FUNCTION erp.report_pood14(varchar, int4);

CREATE OR REPLACE FUNCTION erp.report_pood14(p_lin_id character varying, p_pur_ord_master_id integer)
 RETURNS TABLE(pur_ord_master_id integer, parameter1 character varying, parameter2 character varying, parameter3 character varying, parameter4 character varying, parameter5 character varying, parameter6 character varying, parameter7 character varying, parameter8 character varying, parameter9 character varying, parameter10 character varying)
 LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN QUERY
select a.pur_ord_master_id::integer AS pur_ord_master_id,
		concat(a.government_agency)::character varying AS parameter1,--ส่วนราชการ
		concat(a.phone_number)::character varying AS parameter2,--โทร
		concat(a.project_code_egp)::character varying AS parameter3,--ที่
		concat(erp.po_format_date_thai(
	            null::varchar,
	            null::varchar,
	            null::varchar,
	            a.po_date::date,
	            p_lin_id::varchar))::character varying AS parameter4,--วันที่
	    concat('ขอให้ลงนามในใบสั่งซื้อและ',a.subject)::character varying AS parameter5,--เรื่อง
	    concat(a.attn_to)::character varying AS parameter6,--เรียน
	    concat('ตามหนังสือ ที่ ',a.project_code_egp,' ลงวันที่ ',erp.po_format_date_thai(null::varchar,null::varchar,null::varchar,a.po_date::date,p_lin_id::varchar),
	    		' ลธ. กกต.ได้อนุมัติให้ ฝ่ายพัสดุ ',a.subject,' ',(select pml.method_name
													from po_pr_master ppm
													LEFT JOIN po_method_lang pml
														    ON ppm.pr_method_id = pml.method_id
														    AND lower(pml.language_code) = lower(p_lin_id)
													where ppm.company_code = a.company_code
													and ppm.doc_type = a.ref_doc_type
													and ppm.pr_no = a.ref_doc_no),
				' เป็นจำนวนเงินทั้งสิ้น ',TO_CHAR(coalesce(a.total_amt, 0)::numeric, 'FM99,999,999.00'),' บาท (',
				pkg_cvt_bath_thai_bath(coalesce(a.total_amt, 0)::numeric),') นั้น')::character varying AS parameter7,--เรื่องเดิม
	    concat('บัดนี้ ',concat(aml2.prefix_abbreviation, ' ',aml.first_name,' ',aml.last_name),' ได้เข้ามาลงนามในใบสั่ง',a.subject,' เรียบร้อยแล้ว'
			)::character varying AS parameter8,--ข้อเท็จจรง
	    concat('ฝ่ายพัสดุ พิจารณาเห็นว่า ผู้ขายได้ลงนามในใบสั่งซื้อเรียบร้อยแล้ว ดังนั้นเพื่อให้',a.subject,' เป็นไปด้วยความเรียบร้อย จึงเห็นควรลงนามในใบสั่งซื้อดังกล่าว')::character varying AS parameter9,--ข้อพิจารณา
	    concat('จึงเรียนมาเพื่อโปรดพิจารณา หากเห็นชอบโปรดลงนามในใบสั่งซื้อที่เสนอมาพร้อมนี้')::character varying AS parameter10--ข้อเสนอ
from po_pur_ord_master a 
left join ap_member_lang aml on aml.ap_member_id = a.ap_member_id
	and lower(aml.language_code) = lower(p_lin_id)
left join db_prefix_lang aml2 on aml2.prefix_id = aml.prefix_id 
	and lower(aml2.language_code) = lower(p_lin_id)
where a.pur_ord_master_id = p_pur_ord_master_id;
END;
$function$
;
