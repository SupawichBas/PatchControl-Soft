drop function report_pood10;

CREATE OR REPLACE FUNCTION erp.report_pood10(p_lin_id character varying, p_receive_master_id integer)
 RETURNS TABLE(receive_master_id integer, product_type character varying, company_code character varying, receive_no character varying, rec_place character varying, deliver_date character varying, ap_member_id integer, ap_member_name character varying, main_sub_div character varying, sub_div character varying, vat_rate character varying, tot_amt numeric, tot_vat numeric, receive_detail_id integer, seq integer, premium_flag boolean, product_name character varying, bill_det character varying, ap_det character varying, qty numeric, ums_code character varying, ums_name character varying, qty_ums_name character varying, unit_price numeric, amt numeric, detail_remark character varying, receive_set_id integer, set_seq integer, set_product_name character varying, set_remark character varying, set_brand_code character varying, set_model character varying, set_country_code character varying, set_product_size character varying, set_qty numeric, set_ums character varying, set_ums_name character varying, set_qty_ums_name character varying, set_unit_price numeric, baht_text character varying, remark_mas character varying, sign_image character varying, sign_name character varying, sign_posi character varying, approve_posi character varying, pr_no character varying, pr_type character varying, status_show_image boolean, pr_set_running_no integer,
 footer_header character varying, footer_detail character varying, pr_detail_running_no integer, count_detail integer)
 LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN QUERY
WITH CTE AS (select a.receive_master_id::integer as receive_master_id,
			a.product_type::character varying as product_type,
			a.company_code::character varying as company_code,
			a.receive_no::character varying as receive_no,
			a.rec_place::character varying as rec_place,
			concat(concat(to_char(extract(day from a.deliver_date) ,'FM09'))
				,' ',Monthdeliver_date.value_text
				,' ',case when a.deliver_date is not null then 
					case p_lin_id when 'TH' then 
							to_char(extract(year from a.deliver_date) +543 ,'FM9999')
						else
							to_char(extract(year from a.deliver_date) ,'FM9999')
						end
					end)::character varying as deliver_date,
--			concat(TO_CHAR(a.deliver_date + INTERVAL '543 years', 'fmDD')
--							,' ',Monthdeliver_date.value_text
--							,' ',TO_CHAR(a.deliver_date + INTERVAL '543 years', 'yyyy'))::character varying as deliver_date,
			a.ap_member_id::integer as ap_member_id,
			aml.full_name::character varying as ap_member_name,
			a.main_sub_div::character varying as main_sub_div,
			a.sub_div::character varying as sub_div,
			TO_CHAR(COALESCE(a.vat_rate,0),'fm990.00')::character varying as VAT_RATE,
		    COALESCE(a.total_amt,0)::numeric as TOT_AMT,
		    COALESCE(a.total_vat_amt,0)::numeric as TOT_VAT,
			--DETAIL
			b.receive_detail_id::integer as receive_detail_id,
			b.seq::integer as seq,
			b.premium_flag::boolean as  premium_flag,
			get_product_name(p_lin_id, b.product_type, b.product_id::integer, b.fa_type_id::integer, b.fa_mkind_id::integer)::character varying AS product_name,
			CASE 
				   	WHEN a.many_ap_flag = true THEN a.receipt_no
				    else b.bill_no
				END::character varying AS BILL_DET,
			CASE 
				   	WHEN a.many_ap_flag = true THEN aml.full_name
				    else b.ap_name
				END::character varying AS AP_DET,
			COALESCE(b.qty,0)::numeric as QTY,
			get_ums_code(p_lin_id, b.product_type, b.ums_id::integer)::character varying AS ums_code,
        	get_ums_name(p_lin_id, b.product_type, b.ums_id::integer)::character varying AS ums_name,
			concat(COALESCE(b.qty,0)::numeric,' ', get_ums_name(p_lin_id, b.product_type, b.ums_id::integer)::character varying)::character varying AS qty_ums_name,
			COALESCE(b.unit_price, 0)::numeric AS unit_price,
			COALESCE(b.gs_bef_disc, 0)::numeric AS amt,
			b.remark::character varying AS detail_remark,
			--set
			c.receive_set_id ::integer AS receive_set_id,
			c.set_seq::integer AS set_seq,
			get_product_name(p_lin_id, c.product_type, c.product_id::integer, c.fa_type_id::integer, c.fa_mkind_id::integer)::character varying AS set_product_name,
			c.remark::character varying as set_remark,
			c.brand_code::character varying as set_brand_code,
			c.model::character varying as set_model,
			c.country_code::character varying as set_country_code,
			c.product_size::character varying as set_product_size,
			COALESCE(c.qty,0)::numeric AS set_qty,
			get_ums_code(p_lin_id, c.product_type, c.ums_id::integer)::character varying AS set_ums,
        	get_ums_name(p_lin_id, c.product_type, c.ums_id::integer)::character varying AS set_ums_name,
			concat(COALESCE(c.qty,0)::numeric,' ', get_ums_name(p_lin_id, c.product_type, c.ums_id::integer)::character varying)::character varying AS set_qty_ums_name,
			COALESCE(c.unit_price, 0)::numeric AS set_unit_price,
			--footer
			erp.fn_baht_text(coalesce(a.total_amt,0))::character varying AS baht_text,
			a.remark::character varying as remark_mas,
			case when design.personal_id is not null and design.signature_image_id is not null
				then concat((select sp.parameter_value  from su_parameter sp 
								where sp.parameter_group_code = 'ContentPath'
								and sp.parameter_code = 'SignatureURL')
								,'?PersonalId=',design.personal_id,'&ContentId=',design.signature_image_id)
				else null end::character varying as sign_image,
	        design.emp_name::character varying AS  sign_name,
	    	a.sign_posi::character varying as sign_posi,
			a.approve_posi::character varying AS approve_posi,
		    a.pr_no ::character varying AS pr_no,
		    a.pr_type  ::character varying AS pr_type,
			case when a.status in ('A','E') then true
				else false end::bool as status_show_image,
        	ROW_NUMBER() OVER (PARTITION BY a.receive_master_id, b.receive_detail_id ORDER BY c.receive_set_id)::integer AS pr_set_running_no,
        	concat('สำหรับ',(select pctl.committee_type_name 
							from po_committee_master pcm 
							left join po_committee_type pct on pcm.committee_type_id = pct.committee_type_id 
							left join po_committee_type_lang pctl on pct.committee_type_id = pctl.committee_type_id 
									and lower(pctl.language_code) = lower(p_lin_id)
							where pcm.company_code = a.company_code 
							and pcm.doc_no = a.ref_doc_no 
							and pcm.doc_type = a.ref_doc_type 
							and coalesce(pct.goods_receipt_committee,false) = true
							limit 1))::character varying AS footer_header,
            concat((select pctl.committee_type_name 
							from po_committee_master pcm 
							left join po_committee_type pct on pcm.committee_type_id = pct.committee_type_id 
							left join po_committee_type_lang pctl on pct.committee_type_id = pctl.committee_type_id 
									and lower(pctl.language_code) = lower(p_lin_id)
							where pcm.company_code = a.company_code 
							and pcm.doc_no = a.ref_doc_no 
							and pcm.doc_type = a.ref_doc_type 
							and coalesce(pct.goods_receipt_committee,false) = true
							limit 1)
            ,'มีมติเป็นเอกฉันท์ให้รับพัสดุตามรายการข้างต้นนี้ซึ่งครบถ้วนถูกต้องตามรายการ/แบบรูปและรายละเอียดที่กำหนด',E'\n'
            ,'จึงเรียนเสนอผู้อำนวยการสถาบันวิทยาลัยชุมชนเพื่อทราบตามระเบียบกระทรวงการคลังว่าด้วยการจัดซื้อจัดจ้างและการบริหารพัสดุภาครัฐ ข้อ 175 (4)')::character varying AS footer_detail
	from po_receive_master a
			left join db_list_value_lang Monthdeliver_date  on Monthdeliver_date.group_code = 'Month' 
					and Monthdeliver_date.value = TO_CHAR(a.deliver_date , 'FMMM')
					and lower(Monthdeliver_date.language_code) = lower(p_lin_id)
			left join ap_member am on am.ap_member_id = a.ap_member_id 
					left join ap_member_lang aml on aml.ap_member_id = am.ap_member_id
							and lower(aml.language_code) = lower(p_lin_id)
			left join db_employee_name(p_lin_id) design on design.emp_id = a.sign_id
							
					AND current_date BETWEEN COALESCE(po_convert_thai_to_gregorian(design.work_date::Date), current_date)
							AND COALESCE(po_convert_thai_to_gregorian(design.turnover_date::Date), current_date)

            			
	left join po_receive_detail b on b.receive_master_id = a.receive_master_id 
	left join po_receive_set c on c.receive_detail_id = b.receive_detail_id 
	where a.receive_master_id = p_receive_master_id
	ORDER BY b.premium_flag,b.seq,get_product_code(p_lin_id,
												b.product_type, 
												b.product_id::integer,
												b.fa_type_id::integer,
												b.fa_mkind_id::integer),c.set_seq
) SELECT 
    CTE.*,
    DENSE_RANK() OVER (ORDER BY CTE.receive_detail_id)::integer AS pr_detail_running_no,
    (SELECT COUNT(DISTINCT CTE.receive_detail_id) FROM CTE)::integer as count_detail
FROM 
    CTE;
    
END;
$function$
;
