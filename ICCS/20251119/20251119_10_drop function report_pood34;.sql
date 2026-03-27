drop function report_pood34;

CREATE OR REPLACE FUNCTION erp.report_pood34(p_lin_id character varying, p_pur_ord_master_id integer)
 RETURNS TABLE(pur_ord_master_id integer, header1 character varying, header2 character varying, detail1 character varying, detail2 character varying, detail3 character varying, detail4 character varying, detail5 character varying, detail6 character varying, summary1 character varying, summary2 character varying, summary3 character varying, summary4 character varying, footer1 character varying, footer2 character varying, footer3 character varying, footer4 character varying)
 LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN QUERY

select a.pur_ord_master_id::integer as pur_ord_master_id,
	concat('ที่')::character varying as header1,
	(select dcl.address from db_company_lang dcl where dcl.company_code = a.company_code and lower(dcl.language_code) = lower(p_lin_id))::character varying as header2,
	concat(po_format_date_thai(null,null,null,a.po_date::date,p_lin_id))::character varying as detail1,
	concat('เรื่อง ',a.subject)::character varying as detail2,
	concat('เรียน ',a.attn_to)::character varying as detail3,
	concat('อ้างถึง ')::character varying as detail4,
	concat('ตามใบเสนอราคาที่อ้างถึง ',
		(select dcl.company_name from db_company_lang dcl where dcl.company_code = a.company_code and lower(dcl.language_code) = lower(p_lin_id)),
		' ได้เสนอราคา ',a.subject,' เป็นเงินทั้งสิ้น ',TO_CHAR(a.total_amt, 'FM999,999,999,990.00'),' บาท (',fn_baht_text(a.total_amt),') ',
		'ซึ่งเป็นราคาที่รวมภาษีมูลค่าเพิ่ม และค่าใช้จ่ายทั้งปวงไว้ด้วยแล้ว ความละเอียดแจ้งแล้วนั้น')::character varying as detail5,
	concat((select dcl.company_name from db_company_lang dcl where dcl.company_code = a.company_code and lower(dcl.language_code) = lower(p_lin_id)),
		'พิจารณาแล้ว ตกลง',a.subject,' ตามรายละเอียดที่ได้เสนอไว้ข้างต้น เป็นเงินทั้งสิ้น ',TO_CHAR(a.total_amt, 'FM999,999,999,990.00'),' บาท (',fn_baht_text(a.total_amt),') ',
		'โดยมีระยะเวลารับประกัน ',coalesce(a.gua_year::character varying,'-'),' ปี ',coalesce(a.gua_month::character varying,'-') ,' เดือน ',coalesce(a.complete_day::character varying,'-'),' วัน',' นับถัดจากวันที่',
		(select dcl.company_name from db_company_lang dcl where dcl.company_code = a.company_code and lower(dcl.language_code) = lower(p_lin_id)),
		'รับมอบ และขอให้ดําเนินการให้แล้วเสร็จภายใน ',(select coalesce(ppm.complete_day::character varying,'-') from po_pr_master ppm where ppm.doc_type = a.ref_doc_type and ppm.pr_no = a.ref_doc_no),
		' วัน','นับถัดจากวันที่ได้รับหนังสือสั่งจ้างฉบับนี้ หากไม้สามารถดําเนินการให้แล้วเสร็จภายในกําหนด จะต้องชําระค่าปรับเป็น รายวันในอัตราวันละ ',
		TO_CHAR(a.fine_rate * a.total_amt / 100, 'FM999,999,999,990.00'),' บาท (',fn_baht_text((a.fine_rate * a.total_amt / 100)),') ','นับถัดจากครบกําหนดจนถึงวันที่ดําเนินการแล้วเสร็จ และส่งมอบงานให้ ',
		(select dcl.company_name from db_company_lang dcl where dcl.company_code = a.company_code and lower(dcl.language_code) = lower(p_lin_id)),
		' แล้วเท่านั้น')::character varying as detail6,
	concat('ขอแสดงความนับถือ')::character varying as summary1,
	concat('ลงชื่อ .............................................................')::character varying as summary2,
	concat('(',deapprove.emp_name,')')::character varying as summary3,
	concat(a.sign_posi)::character varying as summary4,
	concat((select dcl.company_name from db_company_lang dcl where dcl.company_code = a.company_code and lower(dcl.language_code) = lower(p_lin_id)))::character varying as footer1,
	concat('โทรศัพท์ ',(select dcl.telephone from db_company_lang dcl where dcl.company_code = a.company_code and lower(dcl.language_code) = lower(p_lin_id)))::character varying as footer2,
	concat('เลขที่โครงการ',' ')::character varying as footer3,
	concat('เลขคุมสัญญา ',a.ref_no)::character varying as footer4
from po_pur_ord_master a
left join db_employee_name(p_lin_id) deapprove on deapprove.emp_id = a.sign_id
where a.pur_ord_master_id = p_pur_ord_master_id
;
END;
$function$
;
