drop function report_pood32;

CREATE OR REPLACE FUNCTION erp.report_pood32(p_lin_id character varying, p_pr_master_id integer)
 RETURNS TABLE(pr_master_id integer, company_name character varying, report_name character varying, ref_no character varying, pr_date_year_th character varying, field_detail character varying, subject character varying, budget_year integer, purpose character varying, pr_req_date character varying, recipient_sign_image character varying, sign_name character varying, status_show_image boolean, label_sign_approve character varying)
 LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN QUERY

select a.pr_master_id::integer AS pr_master_id,
        concat('คำสั่ง ', (select l.company_name from db_company_lang l where l.company_code = a.company_code and lower(l.language_code) = lower(p_lin_id)))::character varying AS company_name,
        concat('เรื่อง ','แต่งตั้ง',(SELECT 
							    CASE 
							        WHEN array_length(sub.names, 1) > 1 THEN
							            array_to_string(sub.names[1:array_length(sub.names, 1)-1], ', ') 
							            || ' และ ' || sub.names[array_length(sub.names, 1)]
							        ELSE
							            sub.names[1]
							    END AS committee_type_name
							FROM (
							    SELECT 
							        ARRAY_AGG(TRIM(SPLIT_PART(pctl.committee_type_name, '(', 1)) ORDER BY pctl.committee_type_name) AS names
							    FROM po_committee_master pcm 
							    JOIN po_committee_type pct 
							        ON pcm.committee_type_id = pct.committee_type_id 
							    LEFT JOIN po_committee_type_lang pctl 
							        ON pct.committee_type_id = pctl.committee_type_id 
							       AND lower(pctl.language_code) = lower(p_lin_id)
							    WHERE pcm.pr_master_id = a.pr_master_id
								) sub
							),E'\n',a.subject)::character varying AS report_name,
        concat('ที่ ',a.ref_no)::character varying AS ref_no,
        to_char(extract(year from a.pr_date) +543 ,'FM9999')::character varying as pr_date_year_th,
        concat(
		    'ด้วย',
		    (select l.company_name from db_company_lang l where l.company_code = a.company_code and lower(l.language_code) = lower(p_lin_id)),
		    'มีความประสงค์จะดำเนินการ',
		    a.subject,
			-- ' ',
		    -- a.purpose,
		    ' ประจำปีงบประมาณ พ.ศ. ',
		    a.budget_year::varchar,
		    ' เพื่อให้เป็นไปตามพระราขบัญญัติการจัดซื้อจัดจ้างและการบริหารพัสดุภาครัฐ พ.ศ. 2560 และระเบียบกระทรวงการคลัง ว่าด้วยการจัดซื้อจัดจ้างและการบริหารพัสดุภาครัฐ พ.ศ. 2560 นั้น จึงขอแต่งตั้ง',
		    (SELECT 
			    CASE 
			        WHEN array_length(sub.names, 1) > 1 THEN
			            array_to_string(sub.names[1:array_length(sub.names, 1)-1], ', ') 
			            || ' และ ' || sub.names[array_length(sub.names, 1)]
			        ELSE
			            sub.names[1]
			    END AS committee_type_name
			FROM (
			    SELECT 
			        ARRAY_AGG(TRIM(SPLIT_PART(pctl.committee_type_name, '(', 1)) ORDER BY pctl.committee_type_name) AS names
			    FROM po_committee_master pcm 
			    JOIN po_committee_type pct 
			        ON pcm.committee_type_id = pct.committee_type_id 
			    LEFT JOIN po_committee_type_lang pctl 
			        ON pct.committee_type_id = pctl.committee_type_id 
			       AND lower(pctl.language_code) = lower(p_lin_id)
			    WHERE pcm.pr_master_id = a.pr_master_id
				) sub
			),' ดังรายชื่อต่อไปนี้')::character varying as field_detail,
        a.subject::character varying AS subject,
        a.budget_year::integer AS budget_year,
        a.purpose::character varying AS purpose,
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
where a.pr_master_id = p_pr_master_id;
-- and exists (select 'X'
-- 			from po_committee_master pcm 
-- 			join po_committee_type pct on pcm.committee_type_id = pct.committee_type_id 
-- 			where pcm.pr_master_id = a.pr_master_id
-- 			and coalesce(pct.goods_receipt_committee,false) = true);
END;
$function$
;
