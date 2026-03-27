drop function report_smexrp02_sub;

CREATE OR REPLACE FUNCTION dbo.report_smexrp02_sub(p_work_flow_id integer)
 RETURNS TABLE(reference_document_no character varying, work_flow_id integer, work_flow_type_code character varying, navigatereport character varying)
 LANGUAGE plpgsql
AS $function$ 
BEGIN
    RETURN QUERY
    select wf.document_no::varchar as reference_document_no,
    		wf.work_flow_id::integer as work_flow_id,
			wf.work_flow_type_code::varchar as work_flow_type_code,
			concat(dbo.get_su_system_configuration('NavigateReport', 'NavigateReport'),wf.work_flow_id,'/',wf.work_flow_type_code)::varchar as NavigateReport
	    from fn_expense_reference fer 
		left join work_flow wf on wf.work_flow_id = fer.reference_workflow_id 
	where fer.work_flow_id  = P_work_flow_id;
END;
$function$
;
