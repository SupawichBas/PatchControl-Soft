drop function get_exists_on_report;

CREATE OR REPLACE FUNCTION dbo.get_exists_on_report(p_work_flow_id integer, p_doa_approver_code character varying)
 RETURNS text
 LANGUAGE plpgsql
AS $function$
DECLARE response text := '';
begin
    IF EXISTS (
        select 1
        from work_flow_approval wfa 
        where wfa.work_flow_id = p_work_flow_id
			and wfa.approver_type = 'Approver'
			and wfa.doa_approver_code = p_doa_approver_code
    )
    OR EXISTS (
        select 1
        from su_user_profile sup 
			inner join su_profile sp on sp.profile_code = sup.profile_code 
			inner join db_employee de on de.user_id = sup.user_id
		where de.emp_code = p_doa_approver_code
			and sp.profile_group in ('Accounting','Admin')
			and CAST(current_timestamp AS DATE) BETWEEN CAST(COALESCE(sup.effective_date, current_timestamp) AS DATE) 
											and CAST(COALESCE(sup.end_date, current_timestamp) AS DATE)
    )
    THEN
        response := 'X';
    END IF;

    RETURN response;
END;
$function$
;
