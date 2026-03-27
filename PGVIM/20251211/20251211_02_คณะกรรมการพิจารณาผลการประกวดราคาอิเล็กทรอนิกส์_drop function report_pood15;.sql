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
					and coalesce(pct.evaluation_committee,false) = true
                    and coalesce(pcm.appointed_flag,false) = false))::character varying AS ref_no,
        concat('เรื่อง ',' การแต่งตั้ง คณะกรรมการพิจารณาผลการประกวดราคาอิเล็กทรอนิกส์ สำหรับ',
						(select pcm.usage_for
						from po_committee_master pcm 
						join po_committee_type pct on pcm.committee_type_id = pct.committee_type_id 
						where pcm.pr_master_id = a.pr_master_id
						and coalesce(pct.evaluation_committee,false) = true
                        and coalesce(pcm.appointed_flag,false) = false
						limit 1)
				)::character varying AS report_name,
        concat(
		    'ด้วย',
		    (select l.company_name from db_company_lang l where l.company_code = a.company_code and lower(l.language_code) = lower(p_lin_id)),
		    ' มีความประสงค์จะ ',
		    (select pcm.usage_for
						from po_committee_master pcm 
						join po_committee_type pct on pcm.committee_type_id = pct.committee_type_id 
						where pcm.pr_master_id = a.pr_master_id
						and coalesce(pct.evaluation_committee,false) = true
                        and coalesce(pcm.appointed_flag,false) = false
						limit 1),
			' ด้วยวิธีประกวดราคาอิเล็กทรอนิกส์ (e-bidding)',
--		    a.purpose,
		    ' พ.ศ. 2560 และระเบียบกระทรวงการคลังว่าด้วยการจัดซื้อจัดจ้างและการบริหารพัสดุภาครัฐ พ.ศ. 2560 นั้น จึงขอแต่งตั้ง คณะกรรมการพิจารณาผลการประกวดราคาอิเล็กทรอนิกส์ สำหรับประกวดราคาซื้อชุดอุปกรณ์โสตทัศนูปกรณ์สำหรับห้องประชุม ด้วยวิธีประกวดราคาอิเล็กทรอนิกส์  (e-bidding) ดังรายชื่อต่อไปนี้ ')::character varying as field_detail,
		concat('โดยมีอำนาจและหน้าที่')::character varying as f0,
		concat('(1) ดำเนินการตามระเบียบกระทรวงการคลังว่าด้วยการจัดซื้อจัดจ้างและการบริหารพัสดุภาครัฐ พ.ศ. 2560 ข้อ 55 ข้อ 56 ข้อ 57 และข้อ 58')::character varying as f1,
		concat('(2) ให้คณะกรรมการฯ ดำเนินการตามข้อ 1 ให้แล้วเสร็จภายใน 7 วัน นับถัดจากวันเสนอราคา')::character varying as f2,
        concat('สั่ง ณ วันที่ ',concat(to_char((select case when exists (select 1 from po_committee_master pcm
																join po_committee_type pct on pcm.committee_type_id = pct.committee_type_id 
																where pcm.pr_master_id = a.pr_master_id 
																and coalesce(pct.evaluation_committee,false) = true
																and coalesce(pcm.appointed_flag,false) = false
																and pcm.created_program = 'PODT03') --มาจากการประมวลผล
													then (select pwf.approve_date from po_pr_ref ppr
															join po_pr_master ppm on ppr.company_code = ppm.company_code
																and ppr.ref_doc_type = ppm.doc_type
																and ppr.ref_doc_no = ppm.pr_no 
															join po_work_flow pwf on pwf.company_code = ppm.company_code 
																and pwf.doc_type = ppm.doc_type 
																and pwf.doc_no = ppm.pr_no 
																and pwf.approve_by_id = ppm.sign_id
															where ppr.pr_master_id = a.pr_master_id
                                                            order by pwf.seq desc
                                                            limit 1) --ดึง approve_date ของใบ PQ
													else (select pwf.approve_date from po_work_flow pwf 
															where pwf.company_code = a.company_code 
															and pwf.doc_type = a.doc_type 
															and pwf.doc_no = a.pr_no 
															and pwf.approve_by_id = (case when a.doc_type = 'PQ' then a.sign_id --ดึง sign_id ของใบ PQ
																								else a.approve_id --ดึง approve_id ของใบ PR
																							end)
															and a.status in ('A','R')
                                                            order by pwf.seq desc
                                                            limit 1) --ดึง approve_date ของใบ PR แสดงตอนสถานะ A หรือ R
												end), 'FMDD') ,' ' ,
							Monthlang.value_text ,(case when Monthlang.value_text is not null then ' พ.ศ. ' else'' end),
							to_char(extract(year from (select case when exists (select 1 from po_committee_master pcm
																join po_committee_type pct on pcm.committee_type_id = pct.committee_type_id 
																where pcm.pr_master_id = a.pr_master_id 
																and coalesce(pct.evaluation_committee,false) = true
																and coalesce(pcm.appointed_flag,false) = false
																and pcm.created_program = 'PODT03') --มาจากการประมวลผล
													then (select pwf.approve_date from po_pr_ref ppr
															join po_pr_master ppm on ppr.company_code = ppm.company_code
																and ppr.ref_doc_type = ppm.doc_type
																and ppr.ref_doc_no = ppm.pr_no 
															join po_work_flow pwf on pwf.company_code = ppm.company_code 
																and pwf.doc_type = ppm.doc_type 
																and pwf.doc_no = ppm.pr_no 
																and pwf.approve_by_id = ppm.sign_id
															where ppr.pr_master_id = a.pr_master_id
                                                            order by pwf.seq desc
                                                            limit 1) --ดึง approve_date ของใบ PQ
													else (select pwf.approve_date from po_work_flow pwf 
															where pwf.company_code = a.company_code 
															and pwf.doc_type = a.doc_type 
															and pwf.doc_no = a.pr_no 
															and pwf.approve_by_id = (case when a.doc_type = 'PQ' then a.sign_id --ดึง sign_id ของใบ PQ
																								else a.approve_id --ดึง approve_id ของใบ PR
																							end)
															and a.status in ('A','R')
                                                            order by pwf.seq desc
                                                            limit 1) --ดึง approve_date ของใบ PR แสดงตอนสถานะ A หรือ R
												end)) +543 ,'FM9999')))::character varying as pr_req_date,
        case when deapprove.personal_id is not null and deapprove.signature_image_id is not null
			then concat((select sp.parameter_value  from su_parameter sp 
							where sp.parameter_group_code = 'ContentPath'
							and sp.parameter_code = 'SignatureURL')
							,'?PersonalId=',deapprove.personal_id,'&ContentId=',deapprove.signature_image_id)
			else null end::character varying as recipient_sign_image,
        concat('(',deapprove.emp_name,')')::character varying AS sign_name,
        (select case 
	        		when exists (select 1 from po_committee_master pcm
								join po_committee_type pct on pcm.committee_type_id = pct.committee_type_id 
								where pcm.pr_master_id = a.pr_master_id 
								and coalesce(pct.evaluation_committee,false) = true
								and coalesce(pcm.appointed_flag,false) = false
								and pcm.created_program = 'PODT03') --มาจากการประมวลผล
					then true --มาจากการประมวลผล แสดงลายเซ็นเลย
					else a.status in ('A','R') --แสดงลายเซ็นตามเงื่อนไข PR
				end)::bool as status_show_image,
		(select case 
    		when exists (select 1 from po_committee_master pcm
						join po_committee_type pct on pcm.committee_type_id = pct.committee_type_id 
						where pcm.pr_master_id = a.pr_master_id 
						and coalesce(pct.evaluation_committee,false) = true
						and coalesce(pcm.appointed_flag,false) = false
						and pcm.created_program = 'PODT03') --มาจากการประมวลผล
			then (select concat(ppm.sign_posi) from po_pr_ref ppr
					join po_pr_master ppm on ppr.company_code = ppm.company_code
						and ppr.ref_doc_type = ppm.doc_type
						and ppr.ref_doc_no = ppm.pr_no
					where ppr.pr_master_id = a.pr_master_id)--แสดง sign_posi ของ PQ
			else (case when a.doc_type = 'PQ' then concat(a.sign_posi) --แสดง sign_posi ของ PQ
					else concat(a.approve_posi) --แสดง approve_posi ของ PR
				end)
		end)::character varying as Label_sign_approve
        --
from po_pr_master a 
left join db_list_value_lang Monthlang  on Monthlang.group_code = 'Month' 
		and Monthlang.value = TO_CHAR((select case when exists (select 1 from po_committee_master pcm
																join po_committee_type pct on pcm.committee_type_id = pct.committee_type_id 
																where pcm.pr_master_id = a.pr_master_id 
																and coalesce(pct.evaluation_committee,false) = true
																and coalesce(pcm.appointed_flag,false) = false
																and pcm.created_program = 'PODT03') --มาจากการประมวลผล
													then (select pwf.approve_date from po_pr_ref ppr
															join po_pr_master ppm on ppr.company_code = ppm.company_code
																and ppr.ref_doc_type = ppm.doc_type
																and ppr.ref_doc_no = ppm.pr_no 
															join po_work_flow pwf on pwf.company_code = ppm.company_code 
																and pwf.doc_type = ppm.doc_type 
																and pwf.doc_no = ppm.pr_no 
																and pwf.approve_by_id = ppm.sign_id
															where ppr.pr_master_id = a.pr_master_id
                                                            order by pwf.seq desc
                                                            limit 1) --ดึง approve_date ของใบ PQ
													else (select pwf.approve_date from po_work_flow pwf 
															where pwf.company_code = a.company_code 
															and pwf.doc_type = a.doc_type 
															and pwf.doc_no = a.pr_no 
															and pwf.approve_by_id = (case when a.doc_type = 'PQ' then a.sign_id --ดึง sign_id ของใบ PQ
																								else a.approve_id --ดึง approve_id ของใบ PR
																							end)
															and a.status in ('A','R')
                                                            order by pwf.seq desc
                                                            limit 1) --ดึง approve_date ของใบ PR แสดงตอนสถานะ A หรือ R
												end), 'FMMM')
		and lower(Monthlang.language_code) = lower(p_lin_id)
left join db_employee_name(p_lin_id) deapprove on deapprove.emp_id = (select case when exists (select 1 from po_committee_master pcm
																								join po_committee_type pct on pcm.committee_type_id = pct.committee_type_id 
																								where pcm.pr_master_id = a.pr_master_id 
																								and coalesce(pct.evaluation_committee,false) = true
																								and coalesce(pcm.appointed_flag,false) = false
																								and pcm.created_program = 'PODT03')--มาจากการประมวลผล
																					then (select ppm.sign_id from po_pr_ref ppr
																							join po_pr_master ppm
																							on ppr.company_code = ppm.company_code
																							and ppr.ref_doc_type = ppm.doc_type
																							and ppr.ref_doc_no = ppm.pr_no 
																							where ppr.pr_master_id = a.pr_master_id)--ดึง sign_id ของใบ PQ
																					else (case when a.doc_type = 'PQ' then a.sign_id --ดึง sign_id ของใบ PQ
																								else a.approve_id --ดึง approve_id ของใบ PR
																							end)
																				end)
where a.pr_master_id = p_pr_master_id
and exists (select 'X'
			from po_committee_master pcm 
			join po_committee_type pct on pcm.committee_type_id = pct.committee_type_id 
			where pcm.pr_master_id = a.pr_master_id
			and coalesce(pct.evaluation_committee ,false) = true
			and coalesce(pcm.appointed_flag,false) = false);
    END;
$function$
;
