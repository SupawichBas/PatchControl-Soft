DROP FUNCTION dbo.report_smpcod08_sub2(varchar, int4);

CREATE OR REPLACE FUNCTION dbo.report_smpcod08_sub2(p_lin_id character varying, p_work_flow_id integer)
 RETURNS TABLE(work_flow_id integer, bank_name character varying, bank_account_no character varying, bank_account_name character varying, transfer_date_time character varying, transfer_amount numeric, pca_return_amount numeric, pc_document_id integer)
 LANGUAGE plpgsql
AS $function$ 
BEGIN
    RETURN QUERY
-- ปิดวงเงิน Close SMPCOD08_SUB2
select
	wf.work_flow_id::integer as work_flow_id,
	dbl.bank_name::varchar as bank_name,--ธนาคาร
	prai.bank_account_no::varchar as bank_account_no,--เลขที่บัญชี
	dbba.bank_account_name::varchar as bank_account_name,--ชื่อบัญชี 
	concat(to_CHAR(prai.transfer_date ,'DD/MM/YYYY'),' ',to_CHAR(prai.transfer_time,'HH24:MI'))::varchar as transfer_date_time,--วัน เวลาที่โอนเงิน  
	coalesce(prai.transfer_amount ,0)::numeric as transfer_amount,--จำนวนเงินที่โอนเงิน
	coalesce(pd.pca_return_amount ,0)::numeric as pca_return_amount,--จำนวนเงินทั้งหมด
	pd.pc_document_id ::integer as pc_document_id
FROM 
    work_flow wf 
    LEFT JOIN pc_document pd on wf.work_flow_id = pd.work_flow_id 
    left join pc_return_amount_information prai on pd.pc_document_id = prai.pc_document_id 
		left join db_branch_bank_account dbba on prai.bank_code = dbba.bank_code
				and prai.company_code = dbba.company_code 
				and prai.branch_code  = dbba.branch_code 
				and prai.bank_account_no = dbba.bank_account_no
	LEFT join db_bank db on db.bank_code = prai.bank_code 
		and db.company_code = pd.company_code  
	LEFT join db_bank_lang dbl on dbl.bank_code = db.bank_code 
		and dbl.company_code = db.company_code 
		and dbl.language_code = p_lin_id
WHERE 
    wf.work_flow_id = p_work_flow_id;--2058
END;
$function$
;
