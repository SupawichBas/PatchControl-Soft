-- DROP FUNCTION erp.report_pood06(varchar, int4);

CREATE OR REPLACE FUNCTION erp.report_pood06(p_lin_id character varying, p_pur_ord_master_id integer)
 RETURNS TABLE(pur_ord_master_id integer, parameter1 character varying, parameter2 character varying, parameter3 character varying, parameter4 character varying, parameter5 character varying, parameter6 character varying, parameter7 character varying, parameter8 character varying, parameter9 character varying, parameter10 character varying, parameter11 character varying, parameter12 character varying, footer1 character varying, footer2 character varying, footer3 character varying, footer4 character varying, footer5 character varying, footer6 character varying, footer7 character varying, remake1 character varying, remake2 character varying, summay1 character varying, summay2 character varying, summay3 character varying, summay4 character varying, summay5 character varying, company character varying)
 LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN QUERY
    SELECT 
        a.pur_ord_master_id::integer AS pur_ord_master_id,
        aml.full_name::character varying AS parameter1,
        a.contract_code_egp::character varying AS parameter2,
        po_get_full_address(am.house_no, am.village, am.building, am.moo, am.soi, am.road, am.sub_district_id, am.district_id, am.province_id, am.postal_code_id, 'PODT06', upper(p_lin_id))::character varying AS parameter3,
        concat(
            concat(to_char(a.po_date, 'FMDD')),
            ' ', Monthlangpodate.value_text,
            ' ',
            CASE 
                WHEN a.po_date IS NOT NULL THEN 
                    CASE p_lin_id 
                        WHEN 'TH' THEN to_char(extract(year FROM a.po_date) + 543 ,'FM9999')
                        ELSE to_char(extract(year FROM a.po_date) ,'FM9999')
                    END
            END
        )::character varying AS parameter4,
        am.telephone::character varying AS parameter5,
        (select dol.organization_name from db_organization_lang dol
			where dol.company_code = a.company_code
			and dol.organization_code = a.ref_div_code
			and lower(dol.language_code) = lower(p_lin_id)
			limit 1)::character varying AS parameter6,
        am.tax_id::character varying AS parameter7,
        a.div_addr_rep::character varying AS parameter8,
        amp.account_number::character varying AS parameter9,
        a.tel_rep::character varying AS parameter10,
        ambankl.full_name::character varying AS parameter11,
        dbl.bank_name::character varying AS parameter12,
        concat('ครบกำหนดส่งมอบวันที่',' ', coalesce(TO_CHAR(a.end_due_date  + INTERVAL '543 years', 'fmDD'),'-'), ' ', coalesce(Monthlang.value_text,'-'),' พ.ศ', ' ',coalesce(TO_CHAR(a.end_due_date + INTERVAL '543 years', 'yyyy'),'-'))::character varying AS footer1,
        concat('สถานที่ส่งมอบ', ' ', coalesce(a.rec_place,'-'))::character varying AS footer2,
        concat('ระยะเวลารับประกัน', ' ', coalesce(a.gua_year::character varying,'-'), ' ', 'ปี', ' ', coalesce(a.gua_month::character varying,'-'), ' ', 'เดือน')::character varying AS footer3,
        concat(
            'สงวนสิทธิ์ค่าปรับกรณีส่งมอบเกินกำหนด โดยคิดค่าปรับเป็นรายวันในอัตรา', ' ', 
            CASE 
                WHEN fine_ums = '1' THEN 'ร้อยละ'
                WHEN fine_ums = '2' THEN ''
                ELSE ''
            END,' ',
            coalesce(a.fine_rate,0), ' ', 'ของราคางานซื้อ/จ้าง แต่ต้องไม่ต่ำกว่าวันละ 100.00 บาท'
        )::character varying AS footer4,
        concat('ส่วนราชการสงวนสิทธิ์ที่จะไม่รับมอบถ้าหากปรากฏว่าสินค้านั้นมีลักษณะไม่ตรงตามรายการที่ระบุไว้ในใบสั่งจ้าง กรณีนี้ผู้ขายจะต้องดำเนินการเปลี่ยนใหม่ให้ถูกต้องตามใบสั่งซื้อทุกประการ')::character varying AS footer5,
        concat('การจ้างช่วง ผู้รับจ้างจะต้องไม่เอางานทั้งหมดหรือแต่บางส่วนไปจ้างช่วงอีกทอดหนึ่ง เว้นแต่การจ้างช่วงงานแต่บางส่วนที่ได้รับอนุญาตเป็นหนังสือจากผู้ว่าจ้างแล้ว การที่ผู้ว่าจ้างได้อนุญาตให้จ้างช่วงงานแต่บางส่วนดังกล่าวนั้น ไม่เป็นเหตุให้ผู้รับจ้างหลุดพ้นจากความรับผิดหรือพันธะหน้าที่และผู้รับจ้างจะยังคงต้องรับผิดในความผิดและความประมาทเลินเล่อของผู้รับจ้างช่วงหรือของตัวแทน หรือลูกจ้างของผู้รับจ้างช่วงนั้นทุกประการ กรณีผู้รับจ้างไปจ้างช่วงงานแต่บางส่วน โดยฝ่าฝืนความในวรรคหนึ่ง ผู้รับจ้างต้องชำระค่าปรับ ให้แก่ผู้ว่าจ้างเป็นจำนวนเงินในอัตราร้อยละ 10 (สิบ) ของวงเงินที่จ้างช่วง ทั้งนี้ ไม่ตัดสิทธิผู้ว่าจ้างในการบอกเลิกสัญญา')::character varying AS footer6,
        concat('การประเมินผลการปฏิบัติงานของผู้ประกอบการหน่วยงานของรัฐสามารถนำผลการปฏิบัติงานแล้วเสร็จตามสัญญา หรือข้อตกลงของคู่สัญญาเพื่อนำมาประเมินผลการปฏิบัติงานของผู้ประกอบการ')::character varying AS footer7,
        concat('ใบสั่งซื้อนี้อ้างอิงตามใบเสนอราคาเลขที่', ' ', coalesce(a.ref_qo_no,'..................................'))::character varying AS remake1,
		concat('การติดอากรแสตมป์ให้เป็นไปตามประมวลกฎหมายรัษฎากร หากต้องการให้ใบสั่งจ้างมีผลตามกฎหมาย')::character varying AS remake2,
        CASE 
            WHEN design.emp_name IS NOT NULL THEN concat('(', design.emp_name, ')')
            ELSE ''
        END::character varying AS summay1,
        a.sign_posi::character varying AS summay2,
        a.approve_posi::character varying AS summay3,
        CASE 
            WHEN design.emp_name IS NOT NULL THEN concat('(', aml.full_name, ')')
            ELSE ''
        END::character varying AS summay4,
        concat('')::character varying AS summay5,
        concat((select dcl.company_name from db_company_lang dcl where dcl.company_code = a.company_code and lower(dcl.language_code) = lower(p_lin_id)))::character varying AS company
    FROM po_pur_ord_master a
        LEFT JOIN db_list_value_lang Monthlang 
            ON Monthlang.group_code = 'Month' 
            AND Monthlang.value = TO_CHAR(a.end_due_date, 'FMMM')
            AND lower(Monthlang.language_code) = lower(p_lin_id)
        LEFT JOIN db_list_value_lang Monthlangpodate  
            ON Monthlangpodate.group_code = 'Month' 
            AND Monthlangpodate.value = TO_CHAR(a.po_date , 'FMMM')
            AND lower(Monthlangpodate.language_code) = lower(p_lin_id)
        LEFT JOIN db_employee_name(p_lin_id) depersonal 
            ON depersonal.emp_id = a.personal_id
        LEFT JOIN db_employee_name(p_lin_id) design 
            ON design.emp_id = a.sign_id
        LEFT JOIN ap_member am 
            ON am.ap_member_id = a.ap_member_id 
        LEFT JOIN ap_member_lang aml 
            ON aml.ap_member_id = am.ap_member_id
            AND lower(aml.language_code) = lower(p_lin_id)
        LEFT JOIN po_pr_master ppm 
            ON ppm.company_code = a.company_code 
            AND ppm.doc_type = a.ref_doc_type 
            AND ppm.pr_no = a.ref_doc_no 
        LEFT JOIN ap_member_payment amp 
            ON amp.ap_member_id = a.ap_member_id
            AND (amp.fsource_gov = 'A' 
                OR amp.fsource_gov = (
                    CASE WHEN ppm.fsource_gov = true THEN 'Y' ELSE 'N' END
                )
            )
        LEFT JOIN db_bank bank 
            ON bank.bank_code = amp.bank_code 
        LEFT JOIN db_bank_lang dbl 
            ON dbl.bank_code = bank.bank_code 
            AND lower(dbl.language_code) = lower(p_lin_id)
        LEFT JOIN db_bank_branch dbb 
            ON dbb.bank_code = bank.bank_code 
            AND dbb.branch_code = amp.branch_code 
        LEFT JOIN db_bank_branch_lang dbbl 
            ON dbbl.bank_branch_id = dbb.bank_branch_id 
            AND lower(dbbl.language_code) = lower(p_lin_id)
        LEFT JOIN ap_member_lang ambankl 
            ON ambankl.ap_member_id = amp.ap_member_id
            AND lower(ambankl.language_code) = lower(p_lin_id)
    WHERE a.pur_ord_master_id = p_pur_ord_master_id;
END;
$function$
;
