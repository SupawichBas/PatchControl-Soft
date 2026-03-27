DROP FUNCTION erp.report_pood03(varchar, int4);

CREATE OR REPLACE FUNCTION erp.report_pood03(p_lin_id character varying, p_pur_ord_master_id integer)
 RETURNS TABLE(pur_ord_master_id integer, company_code character varying, doc_type character varying, po_no character varying, ap_member_id integer, ap_name character varying, ap_addr character varying, ap_tel character varying, ap_fax character varying, account_number character varying, ap_bank_name character varying, bank_name character varying, bank_branch_name character varying, ref_no character varying, po_date character varying, div_name_rep character varying, div_addr_rep character varying, tel_rep character varying, fax_rep character varying, pur_ord_detail_id integer, seq integer, product_code character varying, product_name character varying, qty numeric, ums_code character varying, ums_name character varying, unit_price numeric, gs_aft_disc numeric, total_gs_aft_disc numeric, total_amt numeric, total_vat_amt numeric, baht_text character varying, lead_time integer, end_due_date_day character varying, end_due_date_month character varying, end_due_date_year character varying, rec_place character varying, gua_year integer, gua_month integer, fine_rate numeric, fine_ums character varying, fine_type character varying, ref_qo_no character varying, recipient_personal_image character varying, personal_name character varying, position_type character varying, sign_image character varying, sign_name character varying, sign_posi character varying, approve_posi character varying, status_show_image boolean, fh character varying, f0 character varying, f1 character varying, f2 character varying, f3 character varying, f4 character varying, f5 character varying, remark character varying)
 LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN QUERY
	select a.pur_ord_master_id::integer as pur_ord_master_id,
			a.company_code::character varying as company_code,
			a.doc_type ::character varying as doc_type,
			a.po_no::character varying as po_no,
			a.ap_member_id::integer as ap_member_id,
			aml.full_name::character varying as ap_name,
			po_get_full_address(am.house_no, am.village, am.building, am.moo, am.soi, am.road, am.sub_district_id, am.district_id, am.province_id, am.postal_code_id, 'PODT06', upper(p_lin_id))::character varying as ap_addr,
			am.telephone::character varying as ap_tel,
			am.tax_id::character varying as ap_fax,
			amp.account_number::character varying as account_number,
			ambankl.full_name::character varying as ap_bank_name,
			dbl.bank_name::character varying as bank_name,
			dbbl.bank_branch_name::character varying as bank_branch_name,
			a.ref_no::character varying as ref_no,
			concat(concat(to_char(a.po_date, 'FMDD'))
				,' ',Monthlangpodate.value_text
				,' ',case when a.po_date is not null then 
					case p_lin_id when 'TH' then 
							to_char(extract(year from a.po_date) +543 ,'FM9999')
						else
							to_char(extract(year from a.po_date) ,'FM9999')
						end
					end)::character varying as po_date,
			a.div_name_rep::character varying as div_name_rep,
			a.div_addr_rep::character varying as div_addr_rep,
			a.tel_rep::character varying as tel_rep,
			a.fax_rep::character varying as fax_rep,
			b.pur_ord_detail_id::integer as pur_ord_detail_id,
			b.seq::integer as seq,
			get_product_code(p_lin_id, b.product_type, b.product_id::integer, b.fa_type_id::integer, b.fa_mkind_id::integer)::character varying AS product_code,
        	get_product_name(p_lin_id, b.product_type, b.product_id::integer, b.fa_type_id::integer, b.fa_mkind_id::integer)::character varying AS product_name,
			COALESCE(b.qty,0)::numeric as QTY,
			get_ums_code(p_lin_id, b.product_type, b.ums_id::integer)::character varying AS ums_code,
		    get_ums_name(p_lin_id, b.product_type, b.ums_id::integer)::character varying AS ums_name,
			COALESCE(b.unit_price, 0)::numeric AS unit_price,
			COALESCE(b.gs_aft_disc, 0)::numeric AS gs_aft_disc,
			COALESCE(a.gs_aft_disc, 0)::numeric AS total_gs_aft_disc,
			coalesce(a.total_amt)::numeric as total_amt,
			coalesce(a.total_vat_amt)::numeric as total_vat_amt,
			erp.fn_baht_text(coalesce(a.total_amt,0))::character varying AS baht_text,
			a.lead_time::integer as lead_time,
			TO_CHAR(a.end_due_date  + INTERVAL '543 years', 'fmDD')::character varying AS end_due_date_day,
			Monthlang.value_text ::character varying AS end_due_date_month,
			TO_CHAR(a.end_due_date + INTERVAL '543 years', 'yyyy')::character varying AS end_due_date_year,
			a.rec_place::character varying as rec_place,
			a.gua_year::integer as gua_year,
			a.gua_month::integer as gua_month,
			coalesce(a.fine_rate,0)::numeric as fine_rate,
			a.fine_ums::character varying  as fine_ums,
			a.fine_type::character varying as fine_type,
			a.ref_qo_no::character varying as ref_qo_no,
			case when depersonal.personal_id is not null and depersonal.signature_image_id is not null
					then concat((select sp.parameter_value  from su_parameter sp 
									where sp.parameter_group_code = 'ContentPath'
									and sp.parameter_code = 'SignatureURL')
									,'?PersonalId=',depersonal.personal_id,'&ContentId=',depersonal.signature_image_id)
					else null end::character varying as recipient_personal_image,
			depersonal.emp_name::character varying AS personal_name,
			a."position"::character varying as position_type ,
			case when design.personal_id is not null and design.signature_image_id is not null
				then concat((select sp.parameter_value  from su_parameter sp 
								where sp.parameter_group_code = 'ContentPath'
								and sp.parameter_code = 'SignatureURL')
								,'?PersonalId=',design.personal_id,'&ContentId=',design.signature_image_id)
				else null end::character varying as sign_image,
	        design.emp_name::character varying AS  sign_name,
			a.sign_posi::character varying as sign_posi,
			a.approve_posi::character varying as approve_posi,
			case when a.status in ('A','E') then true
				else false end::bool as status_show_image,
			concat('(ด้านหลังใบสั่งซื้อ)')::character varying as fh,
			concat('เงื่อนไขใบสั่งซื้อ')::character varying as f0,
			concat('1. ถ้าปรากฏว่าสิ่งของที่ผู้ขายส่งมอบไม่ตรงตามรายการข้างต้นผู้ซื้อทรงไว้ซึ่งสิทธิ์ที่จะไม่รับของนั้นในกรณีเช่นว่านี้ผู้ขายต้อง รีบนำสิ่งของนั้นกลับคืนโดยเร็วที่สุดเท่าที่จะทำได้หรือต้องทำการแก้ไขให้ถูกต้องตามใบสั่งซื้อนี้โดยผู้ซื้อไม่ต้องใช้ค่าเสียหายหรือค่าใช้จ่ายให้แต่ประการใด และระยะเวลาที่เสียไปเพราะเหตุดังกล่าว ผู้ขายจะนำมาเป็นเหตุขอต่ออายุสัญญาไม่ได')::character varying as footer1,
			concat('2. ผู้ขายยอมรับประกันความชำรุดบกพร่องหรือการขัดข้องของสิ่งของตามใบสั่งซื้อนี้ เป็นเวลา – วัน นับแต่วันที่ผู้ซื้อได้รับมอบสิ่งของจากผู้ขายและภายในกำหนดเวลาดังกล่าวหากสิ่งของตามใบสั่งซื้อนี้เกิดชำรุดบกพร่องหรือขัดข้องอันเนื่องมาจากการใช้งานตามปกติ ผู้ขายจะต้องจัดการซ่อมแซม หรือแก้ไขให้อยู่ในสภาพที่ใช้การได้ดีกังเดิมภายใน - วัน นับแต่วันที่ได้รับแจ้งจากผู้ซื้อ โดยไม่คิดค่าใช้จ่ายๆ ทั้งสิ้น')::character varying as footer2,
			concat('3. เมื่อครบกำหนดส่งมอบสิ่งของตามใบสั่งนี้แล้วถ้าผู้ขายไม่ส่งมอบสิ่งของที่ตกลงขายให้แก่ผู้ซื้อ หรือส่งมอบสิ่งของทั้งหมดไม่ถูกต้องหรือส่งมอบสิ่งของไม่ครบจำนวน ผู้ซื้อมีสิทธิ์บอกเลิกใบสั่งซื้อนี้ได้และหากไม่มีเหตุผลอันสมควรผู้ซื้อจะถือว่าผู้ขายเป็นผู้ละทิ้งงานขายของทางราชการด้วยในกรณีที่ผู้ซื้อใช้สิทธิ์บอกเลิกใบสั่งซื้อละถ้าผู้ซื้อจัดซื้อสิ่งของดังกล่าวจากบุคคลอื่นเต็มจำนวนหรือเฉพาะจำนวนที่ขาดส่งแล้วแต่กรณี ภายในกำหนด 2 เดือนนับแต่วันที่บอกเลิกใบสั่งซื้อโดยนับวันที่บอกเลิกใบสั่งซื้อเป็นวันเริ่มต้นผู้ขายต้องยอมรับผิดชดใช้ราคาที่เพิ่มขึ้นจากราคาที่กำหนดไว้ในใบสั่งซื้อนี้ด้วย')::character varying as footer3,
			concat('4. ในกรณีที่ผู้ซื้อไม่ใช้สิทธิ์บอกเลิกใบสั่งซื้อตามข้อ3ผู้ขายยอมให้ผู้ซื้อปรับเป็นรายวัน ในอัตราร้อยละ ',po_baht_text(coalesce(a.fine_rate,0)::numeric),' ','(',coalesce(a.fine_rate,0),')',' ของราคาสิ่งของที่ผู้ซื้อยังไม่ได้รับมอบหรือผู้ขายยังส่งมอบไม่ถูกต้อง นับถัดจากวันครบกำหนดตามใบสั่งซื้อ จนถึงวันที่ผู้ขายได้นำสิ่งของนั้นมาส่งให้ผู้ซื้อจนถูกต้องและครบถ้วนแล้ว')::character varying as footer4,
			concat('5. ถ้าผู้ขายไม่ปฏิบัติตามข้อตกลงในใบสั่งซื้อนี้ข้อหนึ่งข้อใดด้วยเหตุผลใด ๆ ก็ตามจนเป็นเหตุให้เกิดความเสียหายแก่ผู้ซื้อแล้ว ผู้ขายยอมรับผิด และยินยอมชดใช้ค่าเสียหายอันเกิดจากาการที่ ผู้ขายไม่ปฏิบัติตามใบสั่งซื้อนี้ให้แก่ผู้ซื้อโดยสิ้นเชิง ภายในกำหนด 30 วัน  นับแต่วันที่ได้รับแจ้งจากผู้ซื้อผู้ขายได้ทราบและยินยอมปฏิบัติตามข้อตกลงข้างต้นทุกประการ และได้รับใบสั่งซื้อไปในวันที่ออกใบสั่งซื้อนี้เรียบร้อยแล้ว ถึงลงชื่อพร้อมประทับตรากิจการ (ถ้ามี) ไว้เป็นสำคัญ')::character varying as footer5,
			a.remark::character varying as remark
	from po_pur_ord_master a
			left join db_list_value_lang Monthlang  on Monthlang.group_code = 'Month' 
					and Monthlang.value = TO_CHAR(a.end_due_date, 'FMMM')
					and lower(Monthlang.language_code) = lower(p_lin_id)
			left join db_list_value_lang Monthlangpodate  on Monthlangpodate.group_code = 'Month' 
					and Monthlangpodate.value = TO_CHAR(a.po_date , 'FMMM')
					and lower(Monthlangpodate.language_code) = lower(p_lin_id)
			left join db_employee_name(p_lin_id) depersonal on depersonal.emp_id = a.personal_id
					
					-- AND current_date BETWEEN COALESCE(po_convert_thai_to_gregorian(depersonal.work_date::Date), current_date)
					-- 		AND COALESCE(po_convert_thai_to_gregorian(depersonal.turnover_date::Date), current_date)
												
			left join db_employee_name(p_lin_id) design on design.emp_id = a.sign_id
					
					-- AND current_date BETWEEN COALESCE(po_convert_thai_to_gregorian(design.work_date::Date), current_date)
					-- 		AND COALESCE(po_convert_thai_to_gregorian(design.turnover_date::Date), current_date)
												
			left join ap_member am on am.ap_member_id = a.ap_member_id 
					left join ap_member_lang aml on aml.ap_member_id = am.ap_member_id
							and lower(aml.language_code) = lower(p_lin_id)
			left join po_pr_master ppm on ppm.company_code = a.company_code 
					and ppm.doc_type = a.ref_doc_type 
					and ppm.pr_no = a.ref_doc_no 
					left join ap_member_payment amp on amp.ap_member_id = a.ap_member_id
							and (amp.fsource_gov = 'A' 
									or ( amp.fsource_gov = (case 
																when ppm.fsource_gov = true then 'Y'
																else 'N'
															end)
										)
								)
					left join db_bank bank on bank.bank_code = amp.bank_code 
					left join db_bank_lang dbl on dbl.bank_code = bank.bank_code 
							and lower(dbl.language_code) = lower(p_lin_id)
					left join db_bank_branch dbb on dbb.bank_code = bank.bank_code 
							and dbb.branch_code = amp.branch_code 
							left join db_bank_branch_lang dbbl on dbbl.bank_branch_id = dbb.bank_branch_id 
									and lower(dbbl.language_code) = lower(p_lin_id)
					left join ap_member_lang ambankl on ambankl.ap_member_id = amp.ap_member_id
							and lower(ambankl.language_code) = lower(p_lin_id)
	left join po_pur_ord_detail b on b.pur_ord_master_id = a.pur_ord_master_id 
	where a.pur_ord_master_id = p_pur_ord_master_id
	ORDER BY B.SEQ, get_product_code(p_lin_id,
									b.product_type,
									b.product_id::integer,
									b.fa_type_id::integer,
									b.fa_mkind_id::integer);
    
END;
$function$
;
