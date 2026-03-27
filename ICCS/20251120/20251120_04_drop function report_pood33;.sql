drop function report_pood33;

CREATE OR REPLACE FUNCTION erp.report_pood33(p_lin_id character varying, p_receive_master_id integer)
 RETURNS TABLE(receive_master_id integer, div_code character varying, div_name character varying, doc_type character varying, receive_no character varying, deliver_date character varying, status character varying, status_name character varying, receive_detail_id integer, seq integer, product_code character varying, product_name character varying, ums_name character varying, qty numeric, unit_price numeric, amt numeric, remark character varying, total_amt character varying, approve_image character varying, approve_date character varying, approve_name character varying)
 LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN QUERY
select a.receive_master_id::integer  as receive_master_id
		,a.div_code::character varying as div_code
		,get_organization_hierarchy(p_lin_id, a.company_code, a.div_code)::character varying AS div_name
		,concat('เบิกวัสดุที่ใช้ในโครงการ')::character varying as doc_type 
		,a.receive_no::character varying as receive_no
		,concat(to_char(a.deliver_date, 'FMDD'), '/',
		            to_char(a.deliver_date, 'FMMM'), '/',
		            to_char(extract(year FROM a.deliver_date) + 543, 'FM9999')
		        )::character varying as deliver_date
		,a.status::character varying as status
		,(select dlvl.value_text 
			from db_list_value_lang dlvl
			where dlvl.group_code = 'PoStatusRE'
			and dlvl.value = a.status
			and lower(dlvl.language_code) = lower(p_lin_id))::character varying as status_name
		--detail
		,b.receive_detail_id::integer as receive_detail_id
		,b.seq::integer as seq
		,get_product_code(p_lin_id, b.product_type, b.product_id::integer, b.fa_type_id::integer, b.fa_mkind_id::integer)::character varying AS product_code
		,get_product_name(p_lin_id, b.product_type, b.product_id::integer, b.fa_type_id::integer, b.fa_mkind_id::integer)::character varying AS product_name
        ,get_ums_name(p_lin_id, b.product_type, b.ums_id::integer)::character varying AS ums_name
		,COALESCE(b.qty,0)::numeric as QTY
		,COALESCE(b.unit_price, 0)::numeric AS unit_price
		,COALESCE(b.gs_bef_disc, 0)::numeric AS amt
		--sum
		,a.remark::character varying as remark
		,to_char(COALESCE(a.total_amt, 0), 'FM999,999,999.00')::character varying as total_amt
		--footer
		,case when deapprove.personal_id is not null and deapprove.signature_image_id is not null
			then concat((select sp.parameter_value  from su_parameter sp 
							where sp.parameter_group_code = 'ContentPath'
							and sp.parameter_code = 'SignatureURL')
							,'?PersonalId=',deapprove.personal_id,'&ContentId=',deapprove.signature_image_id)
			else null end::character varying as approve_image
		,concat((select po_get_fromat_approve_date(pwf.approve_date::date)
				from po_work_flow pwf
				where pwf.company_code = a.company_code
				and pwf.doc_type = a.doc_type
				and pwf.doc_no = a.receive_no))::character varying as approve_date
		,(case when deapprove.emp_name is not null then concat('( ',deapprove.emp_name,' )')
				else ''
			end
			)::character varying as approve_name
from po_receive_master a 
	left join db_employee_name(p_lin_id) deapprove on deapprove.emp_id = (select su.emp_id from su_user su 
																			where su.user_id = (select pwf.approve_by_id 
																							from po_work_flow pwf
																							where pwf.company_code = a.company_code 
																							and pwf.doc_type = a.doc_type 
																							and pwf.doc_no = a.receive_no
																							order by pwf.seq desc  limit 1
																							)
																			limit 1)
left join po_receive_detail b on a.receive_master_id = b.receive_master_id 
where a.receive_master_id = p_receive_master_id
order by b.seq;
    
END;
$function$
;
