drop function report_pood13;

CREATE OR REPLACE FUNCTION erp.report_pood13(p_lin_id character varying, p_pr_master_id integer)
 RETURNS TABLE(pr_master_id integer, company_name character varying, ref_no character varying, report_name character varying, subject_header character varying, budget_year_header character varying, field_detail character varying, f0 character varying, f1 character varying, f2 character varying, f3 character varying, f4 character varying, pr_req_date character varying, recipient_sign_image character varying, sign_name character varying, status_show_image boolean, label_sign_approve character varying)
 LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN QUERY
select a.pr_master_id::integer AS pr_master_id,
        concat('คำสั่ง ', (select l.company_name from db_company_lang l where l.company_code = a.company_code and lower(l.language_code) = lower(p_lin_id)))::character varying AS company_name,
        concat('ที่ ',a.ref_no)::character varying AS ref_no,
        concat('เรื่อง ','แต่งตั้ง',(select TRIM(SPLIT_PART(pctl.committee_type_name, '(', 1)) AS committee_type_name
								from po_committee_master pcm 
								join po_committee_type pct on pcm.committee_type_id = pct.committee_type_id 
								left join po_committee_type_lang pctl on pct.committee_type_id = pctl.committee_type_id 
									and lower(pctl.language_code) = lower(p_lin_id)
								where pcm.pr_master_id = a.pr_master_id
								and coalesce(pct.tor_draft_committee,false) = true
								limit 1))::character varying AS report_name,
        concat((select pcm.usage_for
						from po_committee_master pcm 
						join po_committee_type pct on pcm.committee_type_id = pct.committee_type_id 
						where pcm.pr_master_id = a.pr_master_id
						and coalesce(pct.tor_draft_committee,false) = true
						limit 1)
				)::character varying AS subject_header,
        concat('...........................................................')::character varying AS budget_year_header,
        concat(
		    'ด้วย',
		    (select l.company_name from db_company_lang l where l.company_code = a.company_code and lower(l.language_code) = lower(p_lin_id)),
		    ' มีความประสงค์จะดำเนินการ',
		    a.subject,
		    -- ' ',
		    -- a.purpose,
		    ' ประจำปีงบประมาณ พ.ศ. ',
		    a.budget_year::varchar,
		    ' เพื่อให้เป็นไปตามพระราขบัญญัติการจัดซื้อจัดจ้างและการบริหารพัสดุภาครัฐ พ.ศ. 2560 และระเบียบกระทรวงการคลัง ว่าด้วยการจัดซื้อจัดจ้างและการบริหารพัสดุภาครัฐ พ.ศ. 2560 นั้น จึงขอแต่งตั้ง',
		    (select TRIM(SPLIT_PART(pctl.committee_type_name, '(', 1)) AS committee_type_name
				from po_committee_master pcm 
				join po_committee_type pct on pcm.committee_type_id = pct.committee_type_id 
				left join po_committee_type_lang pctl on pct.committee_type_id = pctl.committee_type_id 
					and lower(pctl.language_code) = lower(p_lin_id)
				where pcm.pr_master_id = a.pr_master_id
				and coalesce(pct.tor_draft_committee,false) = true
				limit 1),
		    ' ดังรายชื่อต่อไปนี้'
			)::character varying as field_detail,
		concat('โดยมีอำนาจและหน้าที่
(1) จัดทำขอบเขตของงานที่จะจ้างให้มีมาตรฐานและเป็นประโยชน์ต่อทางราชการ
(2) กำหนดหลักเกณฑ์การพิจารณาคัดเลือกข้อเสนอ
(3) กำหนดราคากลางของพัสดุที่จะจ้าง
(4) ให้คณะกรรมการฯ ดำเนินการตามข้อ 1 ข้อ 2 และข้อ 3 ให้แล้วเสร็จภายใน 15 วัน นับถัดจากวันที่มีคำสั่งแต่งตั้ง')::character varying as f0,
		concat('')::character varying as f1,
		concat('')::character varying as f2,
		concat('')::character varying as f3,
		concat('')::character varying as f4,
        concat('สั่ง ณ วันที่ ',concat(to_char(a.pr_date, 'FMDD') ,' ' ,
							Monthlang.value_text ,' พ.ศ. ' ,
							to_char(extract(year from a.pr_date) +543 ,'FM9999')))::character varying as pr_req_date,
        case when deapprove.personal_id is not null and deapprove.signature_image_id is not null
			then concat((select sp.parameter_value  from su_parameter sp 
							where sp.parameter_group_code = 'ContentPath'
							and sp.parameter_code = 'SignatureURL')
							,'?PersonalId=',deapprove.personal_id,'&ContentId=',deapprove.signature_image_id)
			else null end::character varying as recipient_sign_image,
        concat('(',deapprove.emp_name,')')::character varying AS sign_name,
        case when a.status in ('A') then true
		else false end::bool as status_show_image,
        concat(a.sign_posi)::character varying as Label_sign_approve
        --
from po_pr_master a 
left join db_list_value_lang Monthlang  on Monthlang.group_code = 'Month' 
		and Monthlang.value = TO_CHAR(A.PR_DATE, 'FMMM')
		and lower(Monthlang.language_code) = lower(p_lin_id)
left join db_employee_name(p_lin_id) deapprove on deapprove.emp_id = a.sign_id
where a.pr_master_id = p_pr_master_id
and exists (select 'X'
			from po_committee_master pcm 
			join po_committee_type pct on pcm.committee_type_id = pct.committee_type_id 
			where pcm.pr_master_id = a.pr_master_id
			and coalesce(pct.tor_draft_committee,false) = true);
    END;
$function$
;
