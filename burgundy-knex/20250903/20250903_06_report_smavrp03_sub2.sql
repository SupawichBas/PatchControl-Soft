drop function report_smavrp03_sub2;

CREATE OR REPLACE FUNCTION dbo.report_smavrp03_sub2(p_av_document_id integer)
 RETURNS TABLE(work_flow_id integer, document_no character varying, document_date character varying, total_expense_amount numeric, banktocom numeric, work_flow_type_code character varying, navigatereport character varying)
 LANGUAGE plpgsql
AS $function$ 
BEGIN
    RETURN QUERY
		select wf.work_flow_id::integer as work_flow_id,
				wf.document_no::varchar as document_no,
				to_char(wf.document_date , 'dd/MM/yyyy')::varchar as document_date ,
				coalesce(fed.total_expense_amount,0)::numeric as total_expense_amount,
				case when coalesce(fed.pay_back_to_company,0) > 0 then fed.pay_back_to_company
					when coalesce(fed.addition_pay_from_company,0) > 0 then fed.addition_pay_from_company
					else 0 end::numeric as BankToCom,
				wf.work_flow_type_code::varchar as work_flow_type_code,
				concat(dbo.get_su_system_configuration('NavigateReport', 'NavigateReport'),wf.work_flow_id,'/',wf.work_flow_type_code)::varchar as NavigateReport
		from fn_expense_reference fer 
		join work_flow wf on fer.work_flow_id = wf.work_flow_id 
		join fn_expense_document fed on fed.work_flow_id = wf.work_flow_id 
		where fer.av_document_id = p_av_document_id
		ORDER BY fed.work_flow_id;
END;
$function$
;
