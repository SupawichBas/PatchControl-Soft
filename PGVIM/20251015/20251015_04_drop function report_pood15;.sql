drop function report_pood15;

CREATE OR REPLACE FUNCTION erp.report_pood15(p_lin_id character varying, p_pr_master_id integer)
 RETURNS TABLE(pr_master_id integer, company_name character varying, ref_no character varying, report_name character varying, field_detail character varying, f0 character varying, f1 character varying, f2 character varying, pr_req_date character varying, recipient_sign_image character varying, sign_name character varying, status_show_image boolean, label_sign_approve character varying)
 LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN QUERY
select a.pr_master_id::integer AS pr_master_id,
        concat('คำสั่ง ', (select l.company_name from db_company_lang l where l.company_code = a.company_code and lower(l.language_code) = lower(p_lin_id)))::character varying AS company_name,
        concat('ที่ ',(select pcm.committee_document_no
					from po_committee_master pcm 
					join po_committee_type pct on pcm.committee_type_id = pct.committee_type_id 
					where pcm.pr_master_id = a.pr_master_id 
					and coalesce(pct.evaluation_committee,false) = true))::character varying AS ref_no,
        concat('เรื่อง ',' การแต่งตั้ง คณะกรรมการพิจารณาผลการประกวดราคาอิเล็กทรอนิกส์ สำหรับ',
						(select pcm.usage_for
						from po_committee_master pcm 
						join po_committee_type pct on pcm.committee_type_id = pct.committee_type_id 
						where pcm.pr_master_id = a.pr_master_id
						and coalesce(pct.evaluation_committee,false) = true
						limit 1)
				)::character varying AS report_name,
        concat(
		    'ด้วย',
		    (select l.company_name from db_company_lang l where l.company_code = a.company_code and lower(l.language_code) = lower(p_lin_id)),
		    ' มีความประสงค์จะ ',
		    a.subject,
			' ด้วยวิธีประกวดราคาอิเล็กทรอนิกส์ (e-bidding) ',
		    a.purpose,
		    ' พ.ศ. 2560 และระเบียบกระทรวงการคลังว่าด้วยการจัดซื้อจัดจ้างและการบริหารพัสดุภาครัฐ พ.ศ. 2560 นั้น จึงขอแต่งตั้ง คณะกรรมการพิจารณาผลการประกวดราคาอิเล็กทรอนิกส์ สำหรับประกวดราคาซื้อชุดอุปกรณ์โสตทัศนูปกรณ์สำหรับห้องประชุม ด้วยวิธีประกวดราคาอิเล็กทรอนิกส์  (e-bidding) ดังรายชื่อต่อไปนี้ ')::character varying as field_detail,
		concat('โดยมีอำนาจและหน้าที่')::character varying as f0,
		concat('(1) ดำเนินการตามระเบียบกระทรวงการคลังว่าด้วยการจัดซื้อจัดจ้างและการบริหารพัสดุภาครัฐ พ.ศ. 2560 ข้อ 55 ข้อ 56 ข้อ 57 และข้อ 58')::character varying as f1,
		concat('(2) ให้คณะกรรมการฯ ดำเนินการตามข้อ 1 ให้แล้วเสร็จภายใน 7 วัน นับถัดจากวันเสนอราคา')::character varying as f2,
        concat('สั่ง ณ วันที่ ',concat(to_char((select pwf.approve_date from po_work_flow pwf 
											where pwf.company_code = a.company_code 
											and pwf.doc_type = a.doc_type 
											and pwf.doc_no = a.pr_no 
											and pwf.approve_by_id = a.sign_id), 'FMDD') ,' ' ,
							Monthlang.value_text ,(case when Monthlang.value_text is not null then ' พ.ศ. ' else'' end),
							to_char(extract(year from (select pwf.approve_date from po_work_flow pwf 
											where pwf.company_code = a.company_code 
											and pwf.doc_type = a.doc_type 
											and pwf.doc_no = a.pr_no 
											and pwf.approve_by_id = a.sign_id)) +543 ,'FM9999')))::character varying as pr_req_date,
        case when deapprove.personal_id is not null and deapprove.signature_image_id is not null
			then concat((select sp.parameter_value  from su_parameter sp 
							where sp.parameter_group_code = 'ContentPath'
							and sp.parameter_code = 'SignatureURL')
							,'?PersonalId=',deapprove.personal_id,'&ContentId=',deapprove.signature_image_id)
			else null end::character varying as recipient_sign_image,
        concat('(',deapprove.emp_name,')')::character varying AS sign_name,
        case when a.status in ('A','R') then true
		else false end::bool as status_show_image,
        concat(a.sign_posi)::character varying as Label_sign_approve
        --
from po_pr_master a 
left join db_list_value_lang Monthlang  on Monthlang.group_code = 'Month' 
		and Monthlang.value = TO_CHAR((select pwf.approve_date from po_work_flow pwf 
											where pwf.company_code = a.company_code 
											and pwf.doc_type = a.doc_type 
											and pwf.doc_no = a.pr_no 
											and pwf.approve_by_id = a.sign_id), 'FMMM')
		and lower(Monthlang.language_code) = lower(p_lin_id)
left join db_employee_name(p_lin_id) deapprove on deapprove.emp_id = a.sign_id
where a.pr_master_id = p_pr_master_id
and exists (select 'X'
			from po_committee_master pcm 
			join po_committee_type pct on pcm.committee_type_id = pct.committee_type_id 
			where pcm.pr_master_id = a.pr_master_id
			and coalesce(pct.evaluation_committee ,false) = true);
    END;
$function$
;
