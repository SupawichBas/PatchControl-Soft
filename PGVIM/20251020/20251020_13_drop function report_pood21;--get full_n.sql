drop function report_pood21;--get full_name ap_member report_pood21

CREATE OR REPLACE FUNCTION erp.report_pood21(p_lin_id character varying, p_pur_ord_master_id integer)
 RETURNS TABLE(pur_ord_master_id integer, field_detail_h character varying, field_detail_h1 character varying, field_detail_h2 character varying, field_detail_1 character varying, field_detail_1_1 character varying, field_detail_2 character varying, field_detail_2_1 character varying, field_detail_3 character varying, field_detail_3_1 character varying, field_detail_3_2 character varying, field_detail_3_3 character varying, field_detail_3_4 character varying, field_detail_3_5 character varying, field_detail_3_6 character varying, field_detail_3_7 character varying, field_detail_4 character varying, field_detail_4_1 character varying, field_detail_5 character varying, field_detail_5_1 character varying, field_detail_5_2 character varying, field_detail_5_3 character varying, field_detail_6 character varying, field_detail_6_1 character varying, field_detail_6_2 character varying, field_detail_6_3 character varying, field_detail_6_4 character varying, field_detail_6_5 character varying, field_detail_6_6 character varying, field_detail_6_7 character varying, field_detail_7 character varying, field_detail_7_1 character varying, field_detail_7_2 character varying, field_detail_7_3 character varying, field_detail_8 character varying, field_detail_8_1 character varying, field_detail_8_2 character varying, field_detail_8_3 character varying, field_detail_8_4 character varying, field_detail_9 character varying, field_detail_9_1 character varying, field_detail_9_2 character varying, field_detail_10 character varying, field_detail_10_1 character varying, field_detail_10_2 character varying, field_detail_10_3 character varying, field_detail_11 character varying, field_detail_11_1 character varying, field_detail_11_2 character varying, field_detail_11_3 character varying, field_detail_12 character varying, field_detail_12_1 character varying, field_detail_12_2 character varying, field_detail_12_3 character varying, field_detail_13 character varying, field_detail_13_1 character varying, field_detail_13_2 character varying, field_detail_13_3 character varying, field_detail_13_4 character varying, field_detail_13_5 character varying, field_detail_14 character varying, field_detail_15 character varying, field_f character varying, field_f1 character varying, field_f2 character varying, field_f3 character varying, field_f4 character varying, field_f4_1 character varying, field_f4_2 character varying, field_f5 character varying, field_f6 character varying, field_f7 character varying, field_f8 character varying, field_f9 character varying, field_f10 character varying, field_f11 character varying, field_f11_1 character varying, field_f12 character varying, field_f13 character varying, field_f14 character varying, field_f15 character varying, field_f16 character varying, field_f16_1 character varying, field_f16_2 character varying, field_f16_3 character varying, field_f16_4 character varying, field_f16_5 character varying, field_f17 character varying, field_f18 character varying, field_f19 character varying, field_f20 character varying, field_f21 character varying, field_f22 character varying, recipient_sign_image character varying, sign_name character varying)
 LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN QUERY
	select a.pur_ord_master_id::integer as pur_ord_master_id,
			concat('สัญญาเลขที่ ', a.ref_no)::character varying as field_detail_h,
			concat(
				'สัญญาฉบับนี้ทำขึ้น ณ ',
				(select l.company_name from db_company_lang l where l.company_code = a.company_code and lower(l.language_code) = lower(p_lin_id)),
				' ตำบล/แขวง ',
				(select get_sub_district_name(dcl.language_code,dcl.sub_district_id) from db_company_lang dcl
				where dcl.company_code = a.company_code and lower(dcl.language_code) = lower(p_lin_id)),
				' อำเภอ/เขต ',
				(select get_district_name(dcl.language_code,dcl.district_id) from db_company_lang dcl 
				where dcl.company_code = a.company_code and lower(dcl.language_code) = lower(p_lin_id)),
				' จังหวัด ',
				(select get_province_name(dcl.language_code,dcl.province_id) from db_company_lang dcl
				where dcl.company_code = a.company_code and lower(dcl.language_code) = lower(p_lin_id)),
				' ',
				(select po_format_date_thai('เมื่อวันที่','เดือน','พ.ศ.',a.po_date::date,p_lin_id )),
				' ระหว่าง ',
				(select l.company_name from db_company_lang l where l.company_code = a.company_code and lower(l.language_code) = lower(p_lin_id)),
				' โดย ',
				(select signde.emp_name from db_employee_name(p_lin_id) signde where signde.emp_id = a.sign_id),
				' ',
				a.sign_posi,
				' ',
				a.approve_posi,
				' ซึ่งต่อไปในสัญญานี้เรียกว่า “ผู้ซื้อ” ฝ่ายหนึ่ง กับ ',
				case 
					when am.juristic_type = 'Y' -- นิติบุคคล
						then (select concat(coalesce(aml.full_name, coalesce(aml2.prefix_abbreviation, aml2.prefix_name), ' ', aml.first_name, ' ', aml.last_name),
											' อยู่บ้านเลขที่ ',am.house_no,' ถนน ',am.road ,
											' ตำบล/แขวง ',get_sub_district_name(p_lin_id,am.sub_district_id),
											' อำเภอ/เขต ',get_district_name(p_lin_id,am.district_id),
											' จังหวัด ',get_province_name(p_lin_id,am.province_id),
											' ผู้ถือบัตรประจำตัวประชาชนเลขที่ ',
											am.tax_id,
											' ดังปรากฏตามสำเนาบัตรประจำตัวประชาชนแนบท้ายสัญญานี้ ซึ่งต่อไปในสัญญานี้เรียกว่า “ผู้ขาย” อีกฝ่ายหนึ่ง'
											))
					else (select concat(coalesce(aml.full_name, coalesce(aml2.prefix_abbreviation, aml2.prefix_name), ' ', aml.first_name, ' ', aml.last_name),' ซึ่งจดทะเบียนเป็นนิติบุคคล ณ …………………………………………………………………………………… ',
											'มีสำนักงานใหญ่อยู่เลขที่ ',am.house_no,' ถนน ',am.road ,
											' ตำบล/แขวง ',get_sub_district_name(p_lin_id,am.sub_district_id),
											' อำเภอ/เขต ',get_district_name(p_lin_id,am.district_id),
											' จังหวัด ',get_province_name(p_lin_id,am.province_id),
											' โดย ………………………………………………… ผู้มีอำนาจลงนามผูกพันนิติบุคคลปรากฏตามหนังสือรับรองของสำนักงานทะเบียนหุ้นส่วนบริษัท ………… ลงวันที่ ………………………… (5) (และหนังสือมอบอำนาจลงวันที่ ………………………… ) แนบท้ายสัญญานี้ (6) ซึ่งต่อไปในสัญญานี้เรียกว่า “ผู้ขาย” อีกฝ่ายหนึ่ง'
											))
				end
			)::character varying as field_detail_h1,
			concat('คู่สัญญาได้ตกลงกันมีข้อความดังต่อไปนี้')::character varying as field_detail_h2,
			concat('ข้อ 1 ข้อตกลงซื้อขาย')::character varying as field_detail_1,
			concat('ผู้ซื้อตกลงซื้อและผู้ขายตกลงขาย ', (select string_agg(
											CONCAT(
											get_product_name(p_lin_id, ppod.product_type::varchar, ppod.product_id::integer, ppod.fa_type_id::integer, ppod.fa_mkind_id::integer),
											' จำนวน ',
											TO_CHAR(ppod.qty, 'FM999G999G999D00') ,
											' ',
											get_ums_name(p_lin_id, ppod.product_type::varchar, ppod.ums_id::integer),
											' (',
											po_qty_text(ppod.qty::numeric),
											' ',
											get_ums_name(p_lin_id, ppod.product_type::varchar, ppod.ums_id::integer),
											') '
											),
											', '
										) from po_pur_ord_detail ppod where ppod.pur_ord_master_id = a.pur_ord_master_id),
				'เป็นราคาทั้งสิ้น ',TO_CHAR(a.gs_aft_disc, 'FM999G999G999D00'),' บาท ',' ( ',po_baht_text(a.gs_aft_disc::numeric),' ) ',
				'ซึ่งได้รวมภาษีมูลค่าเพิ่มจำนวน ',TO_CHAR(a.total_vat_amt, 'FM999G999G999D00'),' บาท ',' ( ',po_baht_text(a.total_vat_amt::numeric),' ) ',
				'ตลอดจนภาษีอากรอื่น ๆ และค่าใช้จ่ายทั้งปวงด้วยแล้ว'
				)::character varying as field_detail_1_1,
			concat('ข้อ 2 การรับรองคุณภาพ')::character varying as field_detail_2,
			concat('ผู้ขายรับรองว่าสิ่งของที่ขายให้ตามสัญญานี้เป็นของแท้ ของใหม่ ไม่เคยใช้งานมาก่อน ไม่เป็นของเก่าเก็บ และมีคุณภาพและคุณสมบัติไม่ต่ำกว่าที่กำหนดไว้ในเอกสารแนบท้ายสัญญาผนวก……… ในกรณีที่เป็นการซื้อสิ่งของซึ่งจะต้องมี การตรวจทดสอบ ผู้ขายรับรองว่า เมื่อตรวจทดสอบแล้วต้องมีคุณภาพและคุณสมบัติไม่ต่ำกว่าที่กำหนดไว้ตามสัญญานี้ด้วย')::character varying as field_detail_2_1,
			concat('ข้อ 3 เอกสารอันเป็นส่วนหนึ่งของสัญญา')::character varying as field_detail_3,
			concat('3.1 ผนวก 1 ……(รายการคุณลักษณะเฉพาะ)…….')::character varying as field_detail_3_1,
			concat('3.2 ผนวก 2 …….…..(แค็ตตาล็อก)(9)……….')::character varying as field_detail_3_2,
			concat('3.3 ผนวก 3 ………...….(แบบรูป)(10)………........')::character varying as field_detail_3_3,
			concat('3.4 ผนวก 4 ……………..(ใบเสนอราคา)…….…..…..')::character varying as field_detail_3_4,
			concat('…….…………………………..ฯลฯ.…….…………………………..')::character varying as field_detail_3_5,
			concat('ความใดในเอกสารแนบท้ายสัญญาที่ขัดหรือแย้งกับข้อความในสัญญานี้ให้ใช้ข้อความในสัญญานี้บังคับและในกรณีที่ เอกสารแนบท้ายสัญญาขัดแย้งกันเอง ผู้ขายจะต้องปฏิบัติตามคำวินิจฉัย ของผู้ซื้อ คำวินิจฉัยของผู้ซื้อให้ถือเป็นที่สุดและผู้ขายไม่มีสิทธิ เรียกร้องราคา ค่าเสียหาย หรือค่าใช้จ่ายใด ๆ เพิ่มเติมจากผู้ซื้อทั้งสิ้น')::character varying as field_detail_3_6,
			concat('จำนวน......(......) หน้า')::character varying as field_detail_3_7,
			concat('ข้อ 4 การส่งมอบ')::character varying as field_detail_4,
			concat('ผู้ขายจะส่งมอบสิ่งของที่ซื้อขายตามสัญญาให้แก่ผู้ซื้อ ณ ',a.rec_place,' ',
					(select po_format_date_thai('ภายในวันที่','เดือน','พ.ศ.',a.end_due_date::date,p_lin_id )),
					' ให้ถูกต้องและครบถ้วนตามที่กำหนดไว้ในข้อ 1 แห่งสัญญานี้พร้อมทั้งหีบห่อหรือเครื่องรัดพันผูก โดยเรียบร้อย การส่งมอบสิ่งของตามสัญญานี้ ไม่ว่าจะเป็นการส่งมอบเพียงครั้งเดียว หรือส่งมอบ หลายครั้ง ผู้ขายจะต้องแจ้งกำหนด เวลาส่งมอบแต่ละครั้งโดยทำเป็นหนังสือนำไปยื่นต่อผู้ซื้อ ณ ',a.rec_place,
					' ในวันและเวลาทำการของผู้ซื้อ ก่อนวันส่งมอบไม่น้อยกว่า ………(11)…....(………………….) วันทำการของผู้ซื้อ'
					)::character varying as field_detail_4_1,
			concat('ข้อ 5 การตรวจรับ')::character varying as field_detail_5,
			concat('เมื่อผู้ซื้อได้ตรวจรับสิ่งของที่ส่งมอบและเห็นว่าถูกต้องครบถ้วนตามสัญญาแล้ว ผู้ซื้อจะออกหลักฐานการรับมอบ เป็นหนังสือไว้ให้ เพื่อผู้ขายนำมาเป็นหลักฐานประกอบการขอรับเงิน ค่าสิ่งของนั้น')::character varying as field_detail_5_1,
			concat('ถ้าผลของการตรวจรับปรากฏว่า สิ่งของที่ผู้ขายส่งมอบไม่ตรงตามข้อ 1 ผู้ซื้อทรงไว้ ซึ่งสิทธิที่จะไม่รับสิ่งของนั้น ในกรณีเช่นว่านี้ ผู้ขายต้องรีบนำสิ่งของนั้นกลับคืนโดยเร็วที่สุดเท่าที่จะทำได้ และนำสิ่งของมาส่งมอบให้ใหม่ หรือต้องทำการแก้ไข ให้ถูกต้องตามสัญญาด้วยค่าใช้จ่ายของผู้ขายเอง และระยะเวลาที่เสียไปเพราะเหตุดังกล่าวผู้ขายจะนำมาอ้างเป็นเหตุขอขยายเวลาส่งมอบ ตามสัญญาหรือ  ของดหรือลดค่าปรับไม่ได้')::character varying as field_detail_5_2,
			concat('(12) ในกรณีที่ผู้ขายส่งมอบสิ่งของถูกต้องแต่ไม่ครบจำนวน หรือส่งมอบครบจำนวน แต่ไม่ถูกต้องทั้งหมดผู้ซื้อจะ ตรวจรับเฉพาะส่วนที่ถูกต้อง โดยออกหลักฐานการตรวจรับเฉพาะส่วนนั้นก็ได้ (ความในวรรคสามนี้ จะไม่กำหนดไว้ในกรณีที่ผู้ซื้อต้องการสิ่ง ของทั้งหมดในคราวเดียวกัน หรือการซื้อสิ่งของที่ประกอบเป็นชุดหรือหน่วย ถ้าขาดส่วนประกอบอย่างหนึ่งอย่างใดไปแล้วจะไม่สามารถ ใช้งานได้ โดยสมบูรณ์)')::character varying as field_detail_5_3,
			concat('ข้อ 6 การชำระเงิน')::character varying as field_detail_6,
			concat('(13 ก) ผู้ซื้อตกลงชำระเงินค่าสิ่งของตามข้อ 1 ให้แก่ผู้ขาย เมื่อผู้ซื้อได้รับมอบสิ่งของ ตามข้อ 5 ไว้โดยครบถ้วนแล้ว')::character varying as field_detail_6_1,
			concat('(13 ข) ผู้ซื้อตกลงชำระเงินค่าสิ่งของตามข้อ 1 ให้แก่ผู้ขาย ดังนี้')::character varying as field_detail_6_2,
			concat('6.1 เงินล่วงหน้า จำนวน ....................... บาท ( ...................................................... ) จะจ่ายให้ภายใน ..................... ( ............................ ) วัน นับถัดจากวันลงนามในสัญญา ทั้งนี้ โดยผู้ขายจะต้องนำหลักประกันการรับเงินล่วงหน้าเป็น ........................ (หนังสือค้ำประกันหรือหนังสือค้ำประกันอิเล็กทรอนิกส์ของธนาคารภายในประเทศหรือพันธบัตรรัฐบาลไทย) .............................. เต็มตามจำนวนเงินล่วงที่ได้รับมามอบให้แก่ผู้ซื้อเป็นหลักประกันการชำระคืนเงินล่วงหน้าก่อนการรับชำระเงินล่วงหน้านั้นและผู้ซื้อจะ คืนหลักประกัน การรับเงินล่วงหน้าให้แก่ผู้ขายเมื่อผู้ซื้อจ่ายเงินที่เหลือตามข้อ')::character varying as field_detail_6_3,
			concat('(1) กรณีผู้ขายได้วางหลักประกันการรับเงินล่วงหน้าไว้ฉบับเดียว หากผู้ซื้อได้หักเงินล่วงหน้าไปแล้วผู้ขายมีสิทธิ ขอคืนหลักประกันการรับเงินล่วงหน้าในส่วนที่ผู้ซื้อได้หักเงินล่วงหน้าไปแล้วนั้น โดยผู้ขายจะต้องนำหลักประกันการรับเงินล่วงหน้า ฉบับใหม่ที่มีมูลค่าเท่ากับเงินล่วงหน้าที่เหลืออยู่มาวางให้แก่ผู้ซื้อ')::character varying as field_detail_6_4,
			concat('(2) กรณีผู้ขายได้วางหลักประกันการรับเงินล่วงหน้าไว้หลายฉบับ ซึ่งแต่ละฉบับมีมูลค่าเท่ากับจำนวนเงินล่วงหน้า ที่ผู้ซื้อจะต้องหักไว้ในแต่ละงวด หากผู้ซื้อได้หักเงินล่วงหน้าในงวดใดแล้วผู้ขายมีสิทธิขอคืนหลักประกันการรับเงินล่วงหน้าในงวดนั้นได้')::character varying as field_detail_6_5,
			concat('6.2 เงินที่เหลือ จำนวน ………................. บาท ( ………......………………..………………….. ) จะจ่ายให้เมื่อผู้ซื้อได้รับมอบสิ่งของ ตามข้อ 5 ไว้โดยถูกต้องครบถ้วนแล้ว')::character varying as field_detail_6_6,
			concat('(14) การจ่ายเงินตามเงื่อนไขแห่งสัญญานี้ ผู้ซื้อจะโอนเงินเข้าบัญชีเงินฝากธนาคาร ของผู้ขาย ชื่อธนาคาร………….………..…..สาขา…........……….…ชื่อบัญชี…….............…………………………………… เลขที่บัญชี………………………… ทั้งนี้ ผู้ขายตกลงเป็นผู้รับภาระเงินค่าธรรมเนียม หรือค่าบริการอื่นใดเกี่ยวกับการโอน รวมทั้งค่าใช้จ่ายใด ๆ (ถ้ามี) ที่ธนาคารเรียกเก็บ และยินยอมให้มีการหักเงินดังกล่าวจากจำนวนเงินโอน ในงวดนั้น ๆ(ความในวรรคนี้ใช้สำหรับกรณีที่หน่วยงานของรัฐจะจ่ายเงินตรงให้แก่ ผู้ขาย (ระบบ Direct Payment) โดยการโอนเงินเข้าบัญชีเงินฝากธนาคารของผู้ขายตามแนวทางที่กระทรวงการคลังหรือหน่วยงานของรัฐ เจ้าของงบประมาณเป็นผู้กำหนด แล้วแต่กรณี)')::character varying as field_detail_6_7,
			concat('ข้อ 7 การรับประกันความชำรุดบกพร่อง')::character varying as field_detail_7,
			concat('ผู้ขายตกลงรับประกันความชำรุดบกพร่องหรือขัดข้องของสิ่งของตามสัญญานี้ เป็นเวลา...........(15)............ (……..…………….) ปี .…....….......…..(…….……..…….….) เดือน นับถัดจากวันที่ผู้ซื้อได้รับมอบสิ่งของทั้งหมด ไว้โดยถูกต้องครบถ้วนตามสัญญา โดยภายในกำหนดเวลาดังกล่าว หากสิ่งของ ตามสัญญานี้เกิดชำรุดบกพร่องหรือขัดข้องอันเนื่องมาจากการใช้งานตามปกติ ผู้ขายจะต้องจัดการ ซ่อมแซมหรือแก้ไขให้อยู่ในสภาพที่ใช้การได้ดีดังเดิม ภายใน ',
					a.complete_day,' '
					'( ',po_qty_text(a.complete_day::numeric),' )',
					' ',
					'วัน',
					' นับถัดจากวันที่ได้รับแจ้งจากผู้ซื้อ โดยไม่คิดค่าใช้จ่ายใด ๆ ทั้งสิ้น หากผู้ขายไม่จัดการซ่อมแซมหรือแก้ไขภายในกำหนดเวลาดังกล่าว ผู้ซื้อมีสิทธิ ที่จะทำการนั้นเองหรือจ้างผู้อื่น ให้ทำการนั้นแทนผู้ขาย โดยผู้ขายต้องเป็นผู้ออกค่าใช้จ่ายเองทั้งสิ้น'
					)::character varying as field_detail_7_1,
			concat('ในกรณีเร่งด่วนจำเป็นต้องรีบแก้ไขเหตุชำรุดบกพร่องหรือขัดข้องโดยเร็ว และไม่อาจรอคอยให้ผู้ขายแก้ไขในระยะเวลา ที่กำหนดไว้ตามวรรคหนึ่งได้ ผู้ซื้อมีสิทธิเข้าจัดการแก้ไขเหตุชำรุดบกพร่อง หรือขัดข้องนั้นเอง หรือให้ผู้อื่นแก้ไขความชำรุดบกพร่องหรือ ขัดข้อง โดยผู้ขายต้องรับผิดชอบชำระค่าใช้จ่ายทั้งหมด')::character varying as field_detail_7_2,
			concat('การที่ผู้ซื้อทำการนั้นเอง หรือให้ผู้อื่นทำการนั้นแทนผู้ขาย ไม่ทำให้ผู้ขายหลุดพ้น จากความรับผิดตามสัญญาหากผู้ขาย ไม่ชดใช้ค่าใช้จ่ายหรือค่าเสียหายตามที่ผู้ซื้อเรียกร้องผู้ซื้อมีสิทธิบังคับจากหลักประกันการปฏิบัติตามสัญญาได้')::character varying as field_detail_7_3,
			concat('ข้อ 8 หลักประกันการปฏิบัติตามสัญญา')::character varying as field_detail_8,
			concat('ในขณะทำสัญญานี้ผู้ขายได้นำหลักประกันเป็น ',(select string_agg(concat(pgtl.guaranty_type_name, ' เป็นจำนวนเงิน ' ,TO_CHAR(pgm.collateral_amt, 'FM999G999G999D00'), ' บาท ','( ', po_baht_text(pgm.collateral_amt::numeric), ' ) '),', ')
											from po_guaranty_master pgm 
											left join po_guaranty_detail pgd on pgm.guaranty_master_id = pgd.guaranty_master_id 
											left join po_guaranty_type pgt on pgd.guaranty_type = pgt.guaranty_type_code 
													left join po_guaranty_type_lang pgtl on pgt.guaranty_type_id = pgtl.guaranty_type_id 
															and lower(pgtl.language_code) = lower(p_lin_id)
											where pgm.status <> 'C' and pgm.ref_doc_type = a.doc_type and pgm.ref_doc_no = a.po_no),
				'ซึ่งเท่ากับร้อยละ …….…(17)……..…(…………..………...) ราคาทั้งหมดตามสัญญา มามอบให้แก่ผู้ซื้อเพื่อเป็นหลักประกัน การปฏิบัติตามสัญญานี้'
				)::character varying as field_detail_8_1,
			concat('(18) กรณีผู้ขายใช้หนังสือค้ำประกันมาเป็นหลักประกันการปฏิบัติตามสัญญา หนังสือค้ำประกันดังกล่าวจะต้องออก โดยธนาคารที่ประกอบกิจการในประเทศไทย หรือโดยบริษัทเงินทุนหรือบริษัทเงินทุนหลักทรัพย์ที่ได้รับอนุญาตให้ประกอบกิจการเงินทุน เพื่อการพาณิชย์และประกอบธุรกิจ ค้ำประกันตามประกาศของธนาคารแห่งประเทศไทย ตามรายชื่อบริษัทเงินทุนที่ธนาคารแห่งประเทศไทย แจ้งเวียนให้ทราบตามแบบที่คณะกรรมการนโยบายการจัดซื้อจัดจ้างและการบริหารพัสดุภาครัฐกำหนด หรืออาจเป็นหนังสือค้ำประกัน อิเล็กทรอนิกส์ตามวิธีการที่กรมบัญชีกลางกำหนดก็ได้ และจะต้องมีอายุ การค้ำประกันตลอดไปจนกว่าผู้ขายพ้นข้อผูกพันตามสัญญานี้')::character varying as field_detail_8_2,
			concat('หลักประกันที่ผู้ขายนำมามอบให้ตามวรรคหนึ่ง จะต้องมีอายุครอบคลุมความรับผิดทั้งปวงของผู้ขายตลอดอายุสัญญานี้ ถ้าหลักประกันที่ผู้ขายนำมามอบให้ดังกล่าวลดลงหรือเสื่อมค่าลง หรือมีอายุไม่ครอบคลุมถึงความรับผิดของผู้ขายตลอดอายุสัญญาไม่ว่าด้วย เหตุใดๆ ก็ตามรวมถึงกรณีผู้ขายส่งมอบสิ่งของล่าช้าเป็นเหตุให้ระยะเวลาส่งมอบหรือวันครบกำหนดความรับผิดในความชำรุดบกพร่อง ตามสัญญาเปลี่ยนแปลงไป ไม่ว่าจะเกิดขึ้นคราวใด ผู้ขายต้องหาหลักประกันใหม่หรือหลักประกันเพิ่มเติม ให้มีจำนวนครบถ้วนตามวรรคหนึ่ง มามอบให้แก่ผู้ซื้อภายใน .................... ( ……..……..…... ) วัน นับถัดจากวันที่ได้รับแจ้งเป็นหนังสือจากผู้ซื้อ')::character varying as field_detail_8_3,
			concat('หลักประกันที่ผู้ขายนำมามอบไว้ตามข้อนี้ ผู้ซื้อจะคืนให้แก่ผู้ขายโดยไม่มีดอกเบี้ย เมื่อผู้ขายพ้นจากข้อผูกพันและ ความรับผิดทั้งปวงตามสัญญานี้แล้ว')::character varying as field_detail_8_4,
			concat('ข้อ 9 การบอกเลิกสัญญา')::character varying as field_detail_9,
			concat('ถ้าผู้ขายไม่ปฏิบัติตามสัญญาข้อใดข้อหนึ่ง หรือเมื่อครบกำหนดส่งมอบสิ่งของ ตามสัญญานี้แล้ว หากผู้ขายไม่ส่งมอบ สิ่งของที่ตกลงขายให้แก่ผู้ซื้อหรือส่งมอบไม่ถูกต้อง หรือไม่ครบจำนวน ผู้ซื้อมีสิทธิบอกเลิกสัญญาทั้งหมดหรือแต่บางส่วนได้ การใช้สิทธิบอกเลิกสัญญานั้นไม่กระทบสิทธิ ของผู้ซื้อที่จะเรียกร้องค่าเสียหายจากผู้ขาย')::character varying as field_detail_9_1,
			concat('ในกรณีที่ผู้ซื้อใช้สิทธิบอกเลิกสัญญา ผู้ซื้อมีสิทธิริบหรือบังคับจากหลักประกันตาม (19) (ข้อ 6 และ) ข้อ 8 เป็นจำนวนเงินทั้งหมดหรือแต่บางส่วนก็ได้ แล้วแต่ผู้ซื้อจะเห็นสมควร และถ้าผู้ซื้อจัดซื้อสิ่งของจากบุคคลอื่นเต็มจำนวนหรือ เฉพาะจำนวนที่ขาดส่ง แล้วแต่กรณี ภายในกำหนด……(20)...... (……………..…..) เดือน นับถัดจากวันบอกเลิกสัญญา ผู้ขายจะต้องชดใช้ราคาที่เพิ่มขึ้นจากราคาที่กำหนดไว้ในสัญญานี้ด้วย')::character varying as field_detail_9_2,
			concat('ข้อ 10 ค่าปรับ')::character varying as field_detail_10,
			concat('ในกรณีที่ผู้ซื้อมิได้ใช้สิทธิบอกเลิกสัญญาตามข้อ 9 ผู้ขายจะต้องชำระค่าปรับให้ผู้ซื้อเป็นรายวันในอัตราร้อยละ ',
					TO_CHAR(a.fine_rate::numeric, 'FM999G999G999D00')::numeric,
					' ( ',po_read_number_digit_text(a.fine_rate),' )',
					' ของราคาสิ่งของที่ยังไม่ได้รับมอบนับถัดจากวันครบกำหนดตามสัญญาจนถึงวันที่ผู้ขายได้นำสิ่งของมาส่งมอบ ให้แก่ผู้ซื้อจนถูกต้องครบถ้วนตามสัญญา'
					)::character varying as field_detail_10_1,
			concat('การคิดค่าปรับในกรณีสิ่งของที่ตกลงซื้อขายประกอบกันเป็นชุด แต่ผู้ขายส่งมอบ เพียงบางส่วน หรือขาดส่วนประกอบ ส่วนหนึ่งส่วนใดไปทำให้ไม่สามารถใช้การได้โดยสมบูรณ์ ให้ถือว่า ยังไม่ได้ส่งมอบสิ่งของนั้นเลย และให้คิดค่าปรับจากราคาสิ่งของเต็มทั้งชุด')::character varying as field_detail_10_2,
			concat('ในระหว่างที่ผู้ซื้อยังมิได้ใช้สิทธิบอกเลิกสัญญานั้น หากผู้ซื้อเห็นว่าผู้ขายไม่อาจปฏิบัติตามสัญญาต่อไปได้ ผู้ซื้อจะใช้สิทธิ บอกเลิกสัญญาและริบหรือบังคับจากหลักประกันตาม (22) (ข้อ 6 และ) ข้อ 8 กับเรียกร้องให้ชดใช้ราคาที่เพิ่มขึ้นตามที่กำหนดไว้ในข้อ 9 วรรคสองก็ได้ และถ้าผู้ซื้อได้แจ้ง ข้อเรียกร้องให้ชำระค่าปรับไปยังผู้ขายเมื่อครบกำหนดส่งมอบแล้ว ผู้ซื้อมีสิทธิที่จะปรับผู้ขายจนถึงวัน บอกเลิกสัญญาได้อีกด้วย')::character varying as field_detail_10_3,
			concat('ข้อ 11 การบังคับค่าปรับ ค่าเสียหาย และค่าใช้จ่าย')::character varying as field_detail_11,
			concat('ในกรณีที่ผู้ขายไม่ปฏิบัติตามสัญญาข้อใดข้อหนึ่งด้วยเหตุใด ๆ ก็ตาม จนเป็นเหตุให้เกิดค่าปรับ ค่าเสียหาย หรือค่าใช้จ่าย แก่ผู้ซื้อ ผู้ขายต้องชดใช้ค่าปรับ ค่าเสียหาย หรือค่าใช้จ่ายดังกล่าวให้แก่ผู้ซื้อโดยสิ้นเชิงภายในกำหนด................(.................) วัน นับถัดจาก วันที่ได้รับแจ้งเป็นหนังสือจากผู้ซื้อ หากผู้ขายไม่ชดใช้ให้ถูกต้องครบถ้วนภายในระยะเวลาดังกล่าวให้ผู้ซื้อมีสิทธิที่จะหักเอาจากจำนวนเงิน ค่าสิ่งของที่ซื้อขายที่ต้องชำระ หรือบังคับจากหลักประกันการปฏิบัติตามสัญญาได้ทันที')::character varying as field_detail_11_1,
			concat('หากค่าปรับ ค่าเสียหาย หรือค่าใช้จ่ายที่บังคับจากเงินค่าสิ่งของที่ซื้อขายที่ต้องชำระหรือหลักประกันการปฏิบัติ ตามสัญญาแล้วยังไม่เพียงพอ ผู้ขายยินยอมชำระส่วนที่เหลือที่ยังขาดอยู่จนครบถ้วนตามจำนวนค่าปรับ ค่าเสียหาย หรือค่าใช้จ่ายนั้น ภายในกำหนด.................(..................) วัน นับถัดจากวันที่ได้รับแจ้งเป็นหนังสือจากผู้ซื้อ')::character varying as field_detail_11_2,
			concat('หากมีเงินค่าสิ่งของที่ซื้อขายตามสัญญาที่หักไว้จ่ายเป็นค่าปรับ ค่าเสียหาย หรือค่าใช้จ่ายแล้วยังเหลืออยู่อีกเท่าใด ผู้ซื้อจะคืนให้แก่ผู้ขายทั้งหมด')::character varying as field_detail_11_3,
			concat('ข้อ 12 การงดหรือลดค่าปรับ หรือขยายเวลาส่งมอบ')::character varying as field_detail_12,
			concat('ในกรณีที่มีเหตุเกิดจากความผิดหรือความบกพร่องของฝ่ายผู้ซื้อ หรือเหตุสุดวิสัย หรือเกิดจากพฤติการณ์อันหนึ่งอันใด ที่ผู้ขายไม่ต้องรับผิดตามกฎหมาย หรือเหตุอื่นตามที่กำหนด ในกฎกระทรวง ซึ่งออกตามความในกฎหมายว่าด้วยการจัดซื้อจัดจ้างและ การบริหารพัสดุภาครัฐ ทำให้ผู้ขายไม่สามารถส่งมอบสิ่งของตามเงื่อนไขและกำหนดเวลาแห่งสัญญานี้ได้ ผู้ขายมีสิทธิของดหรือลดค่าปรับ หรือขยายเวลาส่งมอบตามสัญญาได้ โดยจะต้องแจ้งเหตุหรือพฤติการณ์ดังกล่าวพร้อมหลักฐานเป็นหนังสือให้ผู้ซื้อทราบภายใน 15 (สิบห้า) วัน นับถัดจากวันที่เหตุนั้นสิ้นสุดลง หรือตามที่กำหนดในกฎกระทรวงดังกล่าว')::character varying as field_detail_12_1,
			concat('ถ้าผู้ขายไม่ปฏิบัติให้เป็นไปตามความในวรรคหนึ่ง ให้ถือว่าผู้ขายได้สละสิทธิเรียกร้องในการที่จะของดหรือลดค่าปรับ หรือขยายเวลาส่งมอบตามสัญญา โดยไม่มีเงื่อนไขใด ๆ ทั้งสิ้น เว้นแต่กรณีเหตุเกิดจากความผิดหรือความบกพร่องของฝ่ายผู้ซื้อซึ่งมีหลักฐาน ชัดแจ้งหรือผู้ซื้อทราบดีอยู่แล้วตั้งแต่ต้น')::character varying as field_detail_12_2,
			concat('การงดหรือลดค่าปรับหรือขยายเวลาส่งมอบตามสัญญาตามวรรคหนึ่งอยู่ในดุลพินิจของผู้ซื้อที่จะพิจารณา ตามที่เห็นสมควร')::character varying as field_detail_12_3,
			concat('ข้อ 13 การใช้เรือไทย')::character varying as field_detail_13,
			concat('ถ้าสิ่งของที่จะต้องส่งมอบให้แก่ผู้ซื้อตามสัญญานี้ เป็นสิ่งของที่ผู้ขายจะต้องสั่ง หรือนำเข้ามาจากต่างประเทศและ สิ่งของนั้นต้องนำเข้ามาโดยทางเรือในเส้นทางเดินเรือที่มีเรือไทยเดินอยู่และสามารถให้บริการรับขนได้ตามที่รัฐมนตรีว่าการกระทรวงคมนาคม ประกาศกำหนด ผู้ขายต้องจัดการ ให้สิ่งของดังกล่าวบรรทุกโดยเรือไทยหรือเรือที่มีสิทธิเช่นเดียวกับเรือไทยจากต่างประเทศมายังประเทศไทย เว้นแต่จะได้รับอนุญาตจากกรมเจ้าท่าก่อนบรรทุกของนั้นลงเรืออื่นที่มิใช่เรือไทยหรือเป็นของที่รัฐมนตรีว่าการกระทรวงคมนาคมประกาศ ยกเว้นให้บรรทุกโดยเรืออื่นได้ ทั้งนี้ ไม่ว่าการสั่งหรือนำเข้าสิ่งของดังกล่าวจากต่างประเทศจะเป็นแบบใด')::character varying as field_detail_13_1,
			concat('ในการส่งมอบสิ่งของตามสัญญาให้แก่ผู้ซื้อ ถ้าสิ่งของนั้นเป็นสิ่งของตามวรรคหนึ่ง ผู้ขายจะต้องส่งมอบใบตราส่ง (Bill of Lading) หรือสำเนาใบตราส่งสำหรับของนั้น ซึ่งแสดงว่าได้บรรทุกมาโดยเรือไทยหรือเรือที่มีสิทธิเช่นเดียวกับเรือไทยให้แก่ผู้ซื้อพร้อมกับ การส่งมอบสิ่งของด้วย')::character varying as field_detail_13_2,
			concat('ในกรณีที่สิ่งของดังกล่าวไม่ได้บรรทุกจากต่างประเทศมายังประเทศไทย โดยเรือไทยหรือเรือที่มีสิทธิเช่นเดียวกับเรือไทย ผู้ขายต้องส่งมอบหลักฐานซึ่งแสดงว่าได้รับอนุญาตจากกรมเจ้าท่าให้บรรทุกของโดยเรืออื่นได้หรือหลักฐานซึ่งแสดงว่าได้ชำระค่าธรรมเนียม พิเศษเนื่องจากการไม่บรรทุกของโดยเรือไทยตามกฎหมายว่าด้วยการส่งเสริมการพาณิชยนาวีแล้วอย่างใดอย่างหนึ่งแก่ผู้ซื้อด้วย')::character varying as field_detail_13_3,
			concat('ในกรณีที่ผู้ขายไม่ส่งมอบหลักฐานอย่างใดอย่างหนึ่งดังกล่าวในวรรคสองและวรรคสามให้แก่ผู้ซื้อ แต่จะขอส่งมอบสิ่งของดังกล่าวให้ผู้ซื้อก่อนโดยยังไม่รับชำระเงินค่าสิ่งของผู้ซื้อมีสิทธิรับสิ่งของดังกล่าวไว้ก่อนและชำระเงินค่าสิ่งของเมื่อผู้ขาย ได้ปฏิบัติถูกต้องครบถ้วนดังกล่าวแล้วได้')::character varying as field_detail_13_4,
			concat('สัญญานี้ทำขึ้นเป็นสองฉบับ มีข้อความถูกต้องตรงกัน คู่สัญญาได้อ่านและเข้าใจข้อความ โดยละเอียดตลอดแล้ว จึงได้ลงลายมือชื่อพร้อมทั้งประทับตรา (ถ้ามี) ไว้เป็นสำคัญต่อหน้าพยาน และคู่สัญญาต่างยึดถือไว้ฝ่ายละหนึ่งฉบับ')::character varying as field_detail_13_5,
			concat('(ลงชื่อ) ',deapprove.emp_name,' ผู้ซื้อ')::character varying as field_detail_14,
			concat('( ',a.sign_posi,' ',a.approve_posi,' )')::character varying as field_detail_15,
			concat('วิธีปฏิบัติเกี่ยวกับสัญญาซื้อขาย')::character varying as field_f,
			concat('(1) ให้ระบุเลขที่สัญญาในปีงบประมาณหนึ่ง ๆ ตามลำดับ')::character varying as field_f1,
			concat('(2) ให้ระบุชื่อของหน่วยงานของรัฐที่เป็นนิติบุคคล เช่น กรม ก. หรือรัฐวิสาหกิจ ข. เป็นต้น')::character varying as field_f2,
			concat('(3) ให้ระบุชื่อและตำแหน่งของหัวหน้าหน่วยงานของรัฐที่เป็นนิติบุคคลนั้น หรือผู้ที่ได้รับมอบอำนาจ เช่น นาย ก. อธิบดีกรม……………… หรือ นาย ข. ผู้ได้รับมอบอำนาจจากอธิบดีกรม………………..')::character varying as field_f3,
			concat('(4) ให้ระบุชื่อผู้ขาย')::character varying as field_f4,
			concat('ก. กรณีนิติบุคคล เช่น ห้างหุ้นส่วนสามัญจดทะเบียน ห้างหุ้นส่วนจำกัด บริษัทจำกัด')::character varying as field_f4_1,
			concat('ข. กรณีบุคคลธรรมดา ให้ระบุชื่อและที่อยู่')::character varying as field_f4_2,
			concat('(5) เป็นข้อความหรือเงื่อนไขเพิ่มเติม ซึ่งหน่วยงานของรัฐผู้ทำสัญญาอาจเลือกใช้หรือตัดออก ได้ตามข้อเท็จจริง')::character varying as field_f5,
			concat('(6) เป็นข้อความหรือเงื่อนไขเพิ่มเติม ซึ่งหน่วยงานของรัฐผู้ทำสัญญาอาจเลือกใช้หรือตัดออก ได้ตามข้อเท็จจริง')::character varying as field_f6,
			concat('(7) ให้ระบุว่าเป็นการซื้อสิ่งของตามตัวอย่าง หรือรายการละเอียด หรือแค็ตตาล็อก หรือแบบรูปรายการ หรืออื่น ๆ (ให้ระบุ) และปกติจะต้องกำหนดไว้ด้วยว่าสิ่งของที่จะซื้อนั้น เป็นของแท้ เป็นของใหม่ ไม่เคยใช้งานมาก่อน')::character varying as field_f7,
			concat('(8) ให้ระบุหน่วยที่ใช้ เช่น กิโลกรัม ชิ้น เมตร เป็นต้น')::character varying as field_f8,
			concat('(9) เป็นข้อความหรือเงื่อนไขเพิ่มเติม ซึ่งหน่วยงานของรัฐผู้ทำสัญญาอาจเลือกใช้หรือตัดออก ได้ตามข้อเท็จจริง')::character varying as field_f9,
			concat('(10) เป็นข้อความหรือเงื่อนไขเพิ่มเติม ซึ่งหน่วยงานของรัฐผู้ทำสัญญาอาจเลือกใช้หรือตัดออก ได้ตามข้อเท็จจริง')::character varying as field_f10,
			concat('(11) กำหนดเวลาส่งมอบจะต้องแจ้งล่วงหน้าไม่น้อยกว่ากี่วัน ให้อยู่ในดุลพินิจของผู้ซื้อโดยตกลงกับผู้ขาย โดยปกติควรจะกำหนดไว้ประมาณ 3 วันทำการ เพื่อที่ผู้ซื้อจะได้จัดเตรียมเจ้าหน้าที่ไว้ตรวจรับของนั้น')::character varying as field_f11,
			concat('ในกรณีที่มีการส่งมอบสิ่งของหลายครั้ง ให้ระบุวันเวลาที่ส่งมอบแต่ละครั้งไว้ด้วย และในกรณีที่มีการติดตั้งด้วย ให้แยกกำหนดเวลาส่งมอบ และกำหนดเวลาการติดตั้งออกจากกัน')::character varying as field_f11_1,
			concat('(12) เป็นข้อความหรือเงื่อนไขเพิ่มเติม ซึ่งหน่วยงานของรัฐผู้ทำสัญญาอาจเลือกใช้หรือตัดออก ได้ตามข้อเท็จจริง')::character varying as field_f12,
			concat('(13) ให้หน่วยงานของรัฐเลือกใช้ตามความเหมาะสม ข้อความในข้อ 6 กรณีไม่มีการจ่ายเงินล่วงหน้าให้ผู้ขาย ให้เลือกใช้ข้อความในข้อ (13 ก) ข้อความในข้อ 6 กรณีมีการจ่ายเงินล่วงหน้าให้ผู้ขาย ให้เลือกใช้ข้อความในข้อ (13 ข)')::character varying as field_f13,
			concat('(14) เป็นข้อความหรือเงื่อนไขเพิ่มเติม ซึ่งหน่วยงานของรัฐผู้ทำสัญญาอาจเลือกใช้หรือตัดออก ได้ตามข้อเท็จจริง')::character varying as field_f14,
			concat('(15) ระยะเวลารับประกันและระยะเวลาแก้ไขซ่อมแซมจะกำหนดเท่าใด แล้วแต่ลักษณะของสิ่งของที่ซื้อขายกัน โดยให้อยู่ในดุลพินิจของผู้ซื้อ เช่น เครื่องคำนวณไฟฟ้า กำหนดเวลารับประกัน 1 ปี กำหนดเวลาแก้ไขภายใน 7 วัน เป็นต้น ทั้งนี้ จะต้องประกาศให้ทราบในเอกสารเชิญชวนด้วย')::character varying as field_f15,
			concat('(16) “หลักประกัน” หมายถึง หลักประกันที่ผู้ขายนำมามอบไว้แก่หน่วยงานของรัฐ เมื่อลงนาม ในสัญญา เพื่อเป็นการประกันความเสียหายที่อาจจะเกิดขึ้นจากการปฏิบัติตามสัญญา ดังนี้')::character varying as field_f16,
			concat('(1) เงินสด')::character varying as field_f16_1,
			concat('(2) เช็คหรือดราฟท์ที่ธนาคารเซ็นสั่งจ่าย ซึ่งเป็นเช็คหรือดราฟท์ลงวันที่ที่ใช้เช็คหรือดราฟท์นั้นชำระต่อเจ้าหน้าที่ หรือก่อนวันนั้นไม่เกิน 3 วันทำการ')::character varying as field_f16_2,
			concat('(3) หนังสือค้ำประกันของธนาคารภายในประเทศตามตัวอย่างที่คณะกรรมการนโยบายกำหนด โดยอาจเป็นหนังสือค้ำประกันอิเล็กทรอนิกส์ตามวิธีการที่กรมบัญชีกลางกำหนดก็ได้')::character varying as field_f16_3,
			concat('(4) หนังสือค้ำประกันของบริษัทเงินทุนหรือบริษัทเงินทุนหลักทรัพย์ที่ได้รับอนุญาตให้ประกอบกิจการเงินทุน เพื่อการพาณิชย์และประกอบธุรกิจค้ำประกันตามประกาศของธนาคารแห่งประเทศไทยตามรายชื่อบริษัทเงินทุนที่ธนาคารแห่งประเทศไทย แจ้งเวียนให้ทราบ โดยอนุโลมให้ใช้ตามตัวอย่างหนังสือค้ำประกันของธนาคารที่คณะกรรมการนโยบายกำหนด')::character varying as field_f16_4,
			concat('(5) พันธบัตรรัฐบาลไทย')::character varying as field_f16_5,
			concat('(17) ให้กำหนดจำนวนเงินหลักประกันการปฏิบัติตามสัญญาตามระเบียบกระทรวงการคลังว่าด้วยการจัดซื้อจัดจ้างและ การบริหารพัสดุภาครัฐ พ.ศ. 2560 ข้อ 168')::character varying as field_f17,
			concat('(18) เป็นข้อความหรือเงื่อนไขเพิ่มเติม ซึ่งหน่วยงานของรัฐผู้ทำสัญญาอาจเลือกใช้หรือตัดออก ได้ตามข้อเท็จจริง')::character varying as field_f18,
			concat('(19) เป็นข้อความหรือเงื่อนไขเพิ่มเติม ซึ่งหน่วยงานของรัฐผู้ทำสัญญาอาจเลือกใช้หรือตัดออก ได้ตามข้อเท็จจริง')::character varying as field_f19,
			concat('(20) กำหนดเวลาที่ผู้ซื้อจะซื้อสิ่งของจากแหล่งอื่นเมื่อบอกเลิกสัญญาและมีสิทธิเรียกเงินในส่วนที่เพิ่มขึ้นจาก ราคาที่กำหนดไว้ในสัญญานั้น ให้อยู่ในดุลพินิจของผู้ซื้อโดยตกลงกับผู้ขาย และโดยปกติแล้ว ไม่ควรเกิน 3 เดือน')::character varying as field_f20,
			concat('(21) อัตราค่าปรับตามสัญญาข้อ 10 ให้กำหนดเป็นรายวันในอัตราระหว่างร้อยละ 0.10-0.20 ตามระเบียบ กระทรวงการคลังว่าด้วยการจัดซื้อจัดจ้างและการบริหารพัสดุภาครัฐ พ.ศ. 2560ข้อ 162 ส่วนกรณีจะปรับร้อยละเท่าใด ให้อยู่ใน ดุลพินิจของหน่วยงานของรัฐผู้ซื้อที่จะพิจารณา โดยคำนึงถึง ราคาและลักษณะของพัสดุที่ซื้อ ซึ่งอาจมีผลกระทบต่อการที่ผู้ขาย จะหลีกเลี่ยงไม่ปฏิบัติตามสัญญา แต่ทั้งนี้การที่จะกำหนดค่าปรับเป็นร้อยละเท่าใด จะต้องกำหนดไว้ในเอกสารเชิญชวนด้วย')::character varying as field_f21,
			concat('(22) เป็นข้อความหรือเงื่อนไขเพิ่มเติม ซึ่งหน่วยงานของรัฐผู้ทำสัญญาอาจเลือกใช้หรือตัดออก ได้ตามข้อเท็จจริง')::character varying as field_f22,
			case when deapprove.personal_id is not null and deapprove.signature_image_id is not null
				then concat((select sp.parameter_value  from su_parameter sp 
								where sp.parameter_group_code = 'ContentPath'
								and sp.parameter_code = 'SignatureURL')
								,'?PersonalId=',deapprove.personal_id,'&ContentId=',deapprove.signature_image_id)
				else null end::character varying as recipient_sign_image,
			deapprove.emp_name::character varying AS sign_nameTH
	from po_pur_ord_master a 
	left join ap_member am on a.ap_member_id = am.ap_member_id 
			left join ap_member_lang aml on aml.ap_member_id = am.ap_member_id and lower(aml.language_code) = lower(p_lin_id)
			left join db_prefix_lang aml2 on aml2.prefix_id = aml.prefix_id 
					and lower(aml2.language_code) = lower(p_lin_id)
	left join db_employee_name(p_lin_id) deapprove on deapprove.emp_id = a.sign_id
	where a.pur_ord_master_id = p_pur_ord_master_id;
END;
$function$
;
