-- DROP FUNCTION erp.report_pood10(varchar, int4);

CREATE OR REPLACE FUNCTION erp.report_pood10(p_lin_id character varying, p_receive_master_id integer)
 RETURNS TABLE(receive_master_id integer, product_type character varying, company_code character varying, receive_no character varying, rec_place character varying, deliver_date character varying, ap_member_id integer, ap_member_name character varying, main_sub_div character varying, sub_div character varying, vat_rate character varying, tot_amt numeric, tot_vat numeric, receive_detail_id integer, seq integer, premium_flag boolean, product_name character varying, bill_det character varying, ap_det character varying, qty numeric, ums_code character varying, ums_name character varying, qty_ums_name character varying, unit_price numeric, amt numeric, detail_remark character varying, receive_set_id integer, set_seq integer, set_product_name character varying, set_remark character varying, set_brand_code character varying, set_model character varying, set_country_code character varying, set_product_size character varying, set_qty numeric, set_ums character varying, set_ums_name character varying, set_qty_ums_name character varying, set_unit_price numeric, baht_text character varying, remark_mas character varying, sign_image character varying, sign_name character varying, sign_posi character varying, approve_posi character varying, pr_no character varying, pr_type character varying, status_show_image boolean, pr_set_running_no integer, header1 character varying, header2 character varying, footer2_1 character varying, footer2_2 character varying, footer2_3 character varying, footer2_4 character varying, footer2_5 character varying, footer2_6 character varying, total_disc_amt numeric, total_fine_amt numeric, sum_tot_amt numeric, gs_bef_disc_master numeric, non_vat_amt numeric, sum_fine_disc numeric, show_gs_bef_disc_master boolean, show_total_disc_amt boolean, show_total_fine_amt boolean, show_sum_fine_disc boolean, recipient_owner_image character varying, owner_name character varying, recipient_head_image character varying, head_posi character varying, head_emp_name character varying, recipient_approve_image character varying, approve_name character varying, approve_posi2 character varying, status_show_image_footer boolean, pr_detail_running_no integer, count_detail integer)
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
			coalesce(aml.full_name, coalesce(aml2.prefix_abbreviation, aml2.prefix_name), ' ', aml.first_name, ' ', aml.last_name)::character varying as ap_member_name,
			a.main_sub_div::character varying as main_sub_div,
			a.sub_div::character varying as sub_div,
			TO_CHAR(COALESCE(a.vat_rate,0),'fm990.00')::character varying as VAT_RATE,
		    COALESCE(a.total_amt,0)::numeric as TOT_AMT,
		    COALESCE(a.total_vat_amt,0)::numeric as TOT_VAT,
			--DETAIL
			b.receive_detail_id::integer as receive_detail_id,
			b.seq::integer as seq,
			b.premium_flag::boolean as  premium_flag,
			case 
				when a.product_type = '2' then case
													when b.remark is not null then b.remark
													else get_product_name(p_lin_id, b.product_type, b.product_id::integer, b.fa_type_id::integer, b.fa_mkind_id::integer)
												end
				else get_product_name(p_lin_id, b.product_type, b.product_id::integer, b.fa_type_id::integer, b.fa_mkind_id::integer)
			end::character varying AS product_name,
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
			case 
				when a.product_type = '2' then null
				else b.remark
			end::character varying AS detail_remark,
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
			erp.fn_baht_text(COALESCE(a.total_amt,0)-COALESCE(a.total_fine_amt,0))::character varying AS baht_text,
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
								),'ที่ ',COALESCE(ppom.ref_no,'-'),' ลงวันที่ ',
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
				where prm.receive_master_id = a.receive_master_id)::character varying AS header1,
			concat('ตาม ใบแจ้งหนี้/ใบกำกับภาษี / ใบส่งสินค้า / บิลเงินสด / ใบส่งงาน เลขที่ ',coalesce(a.receipt_no,'-'),' ',
					(select erp.po_format_date_thai('ลงวันที่', null, null, a.receipt_date::date, p_lin_id)),' ',
					(select concat ('(งวดที่ ',STRING_AGG(prd.period::text, ', ' ORDER BY prd.period),')')
						from po_receive_detail prd
						where prd.receive_master_id = a.receive_master_id
						and exists (select 1 from po_pur_ord_period_master ppopm
									where ppopm.company_code = a.company_code
									and ppopm.doc_type = a.ref_doc_type
									and ppopm.po_no = a.ref_doc_no
									HAVING COUNT(ppopm.pur_ord_period_master_id) > 1)
						GROUP BY prd.receive_master_id ))::character varying AS header2,
		    concat('เรียน อธิการบดี') ::character varying AS footer2_1,
		    concat('- ผู้ตรวจรับฯ ได้ตรวจรับแล้วปรากฏว่าได้รับพัสดุครบถ้วน ถูกต้องเป็นไปตามระเบียบกระทรวงการคลังว่าด้วยการจัดซื้อจัดจ้าง และการบริหารพัสดุภาครัฐ พ.ศ. 2560') ::character varying AS footer2_2,
		    concat('- เห็นควรส่งหลักฐานเพื่อเบิกจ่ายเงินให้แก่ผู้ขาย/ผู้รับจ้างต่อไป') ::character varying AS footer2_3,
		    concat('- เพื่อโปรดทราบและพิจารณา') ::character varying AS footer2_4,
		    concat('- ทราบ / ดำเนินการ') ::character varying AS footer2_5,
		    concat('นักพัสดุ') ::character varying AS footer2_6,
		    case when NULLIF(a.disc_baht, 0) is not null
		    		OR NULLIF(a.disc_perc, 0)is not null
		    	then coalesce(a.gs_bef_disc,0) - coalesce(a.gs_aft_disc,0)
		    	else null
		    end::numeric AS total_disc_amt,
		    NULLIF(a.total_fine_amt, 0)::numeric AS total_fine_amt,
		    COALESCE(a.total_amt,0)-COALESCE(a.total_fine_amt,0)::numeric as SUM_TOT_AMT,
		    NULLIF(a.gs_bef_disc, 0)::numeric AS gs_bef_disc_master,
		    NULLIF(COALESCE(a.gs_aft_disc,0)-coalesce(a.total_vat_amt,0), 0)::numeric AS non_vat_amt,
		    NULLIF(COALESCE(a.total_fine_amt,0)+coalesce(case when NULLIF(a.disc_baht, 0) is not null
														    		OR NULLIF(a.disc_perc, 0)is not null
														    	then coalesce(a.gs_bef_disc,0) - coalesce(a.gs_aft_disc,0)
														    	else null
														    end,0), 0)::numeric AS sum_fine_disc,
		    (case when NULLIF(a.disc_baht, 0) is not null
		    		OR NULLIF(a.disc_perc, 0)is not null
					OR NULLIF(a.total_fine_amt, 0) is not null
		    	then true
		    	else false
		    end)::bool AS show_gs_bef_disc_master,
		    (case when NULLIF(a.disc_baht, 0) is not null
		    		OR NULLIF(a.disc_perc, 0)is not null
		    	then false
		    	else false
		    end)::bool AS show_total_disc_amt,
		    (case when NULLIF(a.total_fine_amt, 0) is not null
		    	then false
		    	else false
		    end)::bool AS show_total_fine_amt,
		    (case when NULLIF(a.disc_baht, 0) is not null
		    		OR NULLIF(a.disc_perc, 0)is not null
					OR NULLIF(a.total_fine_amt, 0) is not null
		    	then true
		    	else false
		    end)::bool AS show_sum_fine_disc,
		case when deowner.personal_id is not null and deowner.signature_image_id is not null
				then concat((select sp.parameter_value  from su_parameter sp 
								where sp.parameter_group_code = 'ContentPath'
								and sp.parameter_code = 'SignatureURL')
								,'?PersonalId=',deowner.personal_id,'&ContentId=',deowner.signature_image_id)
				else null end::character varying as recipient_owner_image,
		deowner.emp_name::character varying AS owner_name,
		case when deh.personal_id is not null and deh.signature_image_id is not null
				then concat((select sp.parameter_value  from su_parameter sp 
								where sp.parameter_group_code = 'ContentPath'
								and sp.parameter_code = 'SignatureURL')
								,'?PersonalId=',deh.personal_id,'&ContentId=',deh.signature_image_id)
				else null end::character varying as recipient_head_image,
		a.head_posi::character varying AS head_posi,
		deh.emp_name::character varying AS  head_emp_name,
		case when deapprove.personal_id is not null and deapprove.signature_image_id is not null
				then concat((select sp.parameter_value  from su_parameter sp 
								where sp.parameter_group_code = 'ContentPath'
								and sp.parameter_code = 'SignatureURL')
								,'?PersonalId=',deapprove.personal_id,'&ContentId=',deapprove.signature_image_id)
				else null end::character varying as recipient_approve_image,
		deapprove.emp_name::character varying AS approve_name,
		a.approve_posi ::character varying AS approve_posi,
		case when a.status in ('A','E') then true
		else false end::bool as status_show_image_footer
	from po_receive_master a
			left join db_list_value_lang Monthdeliver_date  on Monthdeliver_date.group_code = 'Month' 
					and Monthdeliver_date.value = TO_CHAR(a.deliver_date , 'FMMM')
					and lower(Monthdeliver_date.language_code) = lower(p_lin_id)
			left join ap_member am on am.ap_member_id = a.ap_member_id 
					left join ap_member_lang aml on aml.ap_member_id = am.ap_member_id
							and lower(aml.language_code) = lower(p_lin_id)
					left join db_prefix_lang aml2 on aml2.prefix_id = aml.prefix_id 
							and lower(aml2.language_code) = lower(p_lin_id)
			left join db_employee_name(p_lin_id) design on design.emp_id = a.sign_id
			left join db_employee_name(p_lin_id) deowner on deowner.emp_id = a.owner
			left join db_employee_name(p_lin_id) deh on deh.emp_id = a.head_emp_id 
			left join db_employee_name(p_lin_id) deapprove on deapprove.emp_id = a.approve_id 
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
