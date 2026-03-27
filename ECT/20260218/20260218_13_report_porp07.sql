-- DROP FUNCTION erp.report_porp07(varchar, varchar, varchar, varchar, varchar, varchar, int4);

CREATE OR REPLACE FUNCTION erp.report_porp07(p_lin_id character varying, p_company_code character varying, p_start_div character varying, p_end_div character varying, p_start_date character varying, p_end_date character varying, p_user_id integer)
 RETURNS TABLE(pr_master_id integer, pr_supplier_id integer, header1 character varying, header2 character varying, column1 integer, column2 character varying, column3 character varying, column4 character varying, column5 character varying, column6 character varying, column7 character varying, column8 numeric, column9 character varying, column10 character varying, column11 character varying, column12 numeric, column13 numeric, column14 character varying, column15 character varying, column16 character varying, column17 character varying, column18 character varying)
 LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN QUERY
select pps.pr_master_id::integer as pr_master_id
		,pps.pr_supplier_id::integer as pr_supplier_id
		,concat('สรุปผลการจัดซื้อจัดจ้าง')::character varying as header1
		,concat('ระหว่างวันที่ ',coalesce(
					erp.po_format_date_thai(null,null,null,to_date(p_start_date,'DD/MM/YYYY')::date,p_lin_id::varchar),
					erp.get_report_label_name('PORP07', 'START', p_lin_id)),
					' ถึง วันที่ ',
					coalesce(erp.po_format_date_thai(null,null,null,to_date(p_end_date,'DD/MM/YYYY')::date,p_lin_id::varchar),
					erp.get_report_label_name('PORP07', 'END', p_lin_id)))::character varying as header2
		,TO_CHAR(EXTRACT(YEAR FROM ppm.pr_date::date) + 543, 'FM9999')::integer as column1--ปีงบประมาณ
		,concat('องค์การอิสระ')::character varying as column2--ประเภทหน่วยงาน
		,concat('')::character varying as column3 --กระทรวง
		,dcl.company_name::character varying as column4--ชื่อหน่วยงาน
		,ddl.district_name::character varying as column5--อำเภอ
		,dpl.province_name::character varying as column6--จังหวัด
		,ppm.subject::character varying as column7--งานจัดซื้อจัดจ้าง
		,COALESCE(ppm.total_amt,0)::numeric as column8--วงเงินงบประมาณที่ได้รับจัดสรร
		,case 
			when ppm.fsource_gov then 'พ.ร.บ. งบประมาณรายจ่าย'
			else 'เงินนอก'
		end::character varying as column9--แหล่งที่มาของงบประมาณ
		,(case 
			when ppm.status in ('N','W','A','B') then 'ยังไม่ลงนามในสัญญา'
			when ppm.status = 'C' then 'ยกเลิกการดำเนินการ'
			when ppm.status = 'R' -- ถูกอ้างอิง
				then (select case
								when ppom.status in ('N','W','B') then 'ยังไม่ลงนามในสัญญา'
								when ppom.status = 'A' then 'อยู่ระหว่างระยะสัญญา'
								else ppom.status
							end
						from po_pur_ord_master ppom
						where ppom.company_code = ppm.company_code
						and ppom.ref_doc_type = ppm.doc_type
						and ppom.ref_doc_no = ppm.pr_no)
			when ppm.status = 'E' -- ปิด
		        then (case 
		                when not exists (
		                    select 1
		                    from po_receive_master prm
		                    where prm.company_code = ppm.company_code
		                        and prm.pr_type = ppm.doc_type
		                        and prm.pr_no = ppm.pr_no
		                        and prm.status not in ('C', 'A') --status <> A 
		                ) --เช็ค ว่าเป็น A ทุกใบไหม 1 ยังมีสถานะอื่นอยู่ null เป็น A ทุกใบ
		                then 'สิ้นสุดสัญญา' -- A ทุกใบ
		                else 'อยู่ระหว่างระยะสัญญา' -- <> A ทุกใบ
		              end)
			else ppm.status
		end)::character varying as column10--สถานะการจัดซื้อจัดจ้าง
		,pml.method_name::character varying as column11--สถานะการจัดซื้อจัดจ้าง
		,(select SUM(sub_grp_1.sum_group_detail_seq) AS final_total_amount
			from (select ppsd.pr_supplier_id
						,ppsd.detail_seq
						,max(coalesce(ppd.unit_price,0))*sum(coalesce(ppd.std_price,0)) as sum_group_detail_seq
					from po_pr_supplier_detail ppsd 
							join po_pr_detail ppd on ppsd.company_code = ppd.company_code
								and ppsd.doc_type = ppd.doc_type 
								and ppsd.pr_no = ppd.pr_no 
								and ppsd.detail_seq = ppd.seq 
					where ppsd.pr_supplier_id = pps.pr_supplier_id
					GROUP BY ppsd.pr_supplier_id,ppsd.detail_seq) as sub_grp_1
			GROUP by sub_grp_1.pr_supplier_id)::numeric as column12--ราคากลาง
		,(select SUM(sub_grp_2.sum_group_detail_seq) AS final_total_amount
			from (select ppsd.pr_supplier_id
						,ppsd.detail_seq
						,max(coalesce(ppd.unit_price,0)) as unit_price
						,sum(coalesce(ppsd.qty,0)) as sum_qty
						,max(coalesce(ppd.unit_price,0))*sum(coalesce(ppsd.qty,0)) as sum_group_detail_seq
					from po_pr_supplier_detail ppsd 
							join po_pr_detail ppd on ppsd.company_code = ppd.company_code
								and ppsd.doc_type = ppd.doc_type 
								and ppsd.pr_no = ppd.pr_no 
								and ppsd.detail_seq = ppd.seq 
					where ppsd.pr_supplier_id = pps.pr_supplier_id
					GROUP BY ppsd.pr_supplier_id,ppsd.detail_seq) as sub_grp_2
			GROUP by sub_grp_2.pr_supplier_id)::numeric as column13--ราคาที่ตงลงซื้อจ้าง
		,am.tax_id::character varying as column14--เลขประจำตัวผู้เสียภาษี
		,aml.full_name::character varying as column15--รายชื่อผู้ประกอบการที่ได้รับการคัดเลือก
		,(select ppom.project_code_egp
			from po_pur_ord_master ppom
			where ppom.company_code = pps.company_code
			and ppom.doc_type = pps.ref_doc_type
			and ppom.po_no = pps.ref_doc_no)::character varying as column16--เลขที่โครงการ
		,(select erp.format_date_thai(ppom.start_con_date::date)
			from po_pur_ord_master ppom
			where ppom.company_code = pps.company_code
			and ppom.doc_type = pps.ref_doc_type
			and ppom.po_no = pps.ref_doc_no)::character varying as column17--วันที่เริ่มต้นสัญญา
		,(select erp.format_date_thai(ppom.end_con_date::date)
			from po_pur_ord_master ppom
			where ppom.company_code = pps.company_code
			and ppom.doc_type = pps.ref_doc_type
			and ppom.po_no = pps.ref_doc_no)::character varying as column18--วันที่สิ้นสุดสัญญา
from po_pr_supplier pps
left join ap_member am on am.ap_member_id = pps.ap_member_id
	left join ap_member_lang aml on aml.ap_member_id = am.ap_member_id
		and lower(aml.language_code) = lower(p_lin_id) 
join po_pr_master ppm on ppm.pr_master_id = pps.pr_master_id
left join po_method_lang pml on pml.method_id = ppm.pr_method_id
	and lower(pml.language_code) = lower(p_lin_id)
left join db_company_lang dcl on dcl.company_code = pps.company_code
	and lower(dcl.language_code) = lower(p_lin_id)
left join db_province_lang dpl on dpl.province_id = dcl.province_id
	and lower(dpl.language_code) = lower(p_lin_id)
left join db_district_lang ddl on ddl.district_id = dcl.district_id
	and lower(ddl.language_code) = lower(p_lin_id)
where pps.company_code = p_company_code
	and ppm.div_code between  COALESCE(p_start_div ,ppm.div_code)
					and COALESCE(p_end_div ,ppm.div_code)
	and date(ppm.pr_date) BETWEEN to_date(COALESCE(p_start_date, '01/01/1000'),'DD/MM/YYYY') 
					AND to_date(COALESCE(p_end_date,'31/12/9999' ), 'DD/MM/YYYY')
	and exists (select 'X' from su_user_organization su
                    where su.user_id = p_User_Id
                    and su.company_code = p_company_code
                    and su.organization_code = ppm.div_code
                    and coalesce(cast(su.start_effective_date as date), current_date) <= current_date
                    and coalesce(cast(su.end_effective_date as date), current_date) >= current_date)
order by pps.pr_supplier_id;
    
END;
$function$
;
