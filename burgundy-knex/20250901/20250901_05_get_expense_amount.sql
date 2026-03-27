drop function get_expense_amount;

CREATE OR REPLACE FUNCTION get_expense_amount(p_workflow_id integer, p_expense_group_code character varying)
 RETURNS numeric
 LANGUAGE plpgsql
AS $function$
    DECLARE 
        ret numeric(18,2);  
    BEGIN  
        -- Initialize the return value
        ret := NULL;

        -- Calculate the total expense amount for the given workflow ID and expense group code
        SELECT COALESCE(SUM(expense.Amount), 0)
        INTO ret
        FROM (
            SELECT ex.work_flow_id, exInvItem.expense_code, SUM(COALESCE(exInvItem.local_amount, 0)) AS Amount
            ,ex.company_code
            FROM fn_expense_document ex
            INNER JOIN fn_expense_invoice exInv ON ex.expense_document_id = exInv.expense_document_id
            INNER JOIN fn_expense_invoice_item exInvItem ON exInv.expense_invoice_id = exInvItem.expense_invoice_id
            GROUP BY ex.work_flow_id, exInvItem.expense_code,ex.company_code
            
            UNION ALL 
            
            SELECT per.work_flow_id, per.expense_code, SUM(COALESCE(per.local_amount, 0)) AS Amount
            	,per.company_code 
            FROM fn_expense_perdiem per
            GROUP BY per.work_flow_id, per.expense_code,per.company_code 
            
            UNION ALL 
            
            SELECT mi.work_flow_id, mi.expense_code, SUM(COALESCE(mi.local_amount, 0)) AS Amount
            	,mi.company_code 
            FROM fn_expense_mileage mi
            GROUP BY mi.work_flow_id, mi.expense_code,mi.company_code 
            
            UNION ALL 
            
            SELECT pd.work_flow_id, pdii.expense_code , SUM(COALESCE(pdii.local_amount , 0)) AS Amount
            	,pd.company_code 
            FROM pc_document pd
            inner join pc_document_invoice pdi ON pdi.pc_document_id = pd.pc_document_id 
            inner join pc_document_invoice_item pdii on pdii.pc_document_invoice_id = pdi.pc_document_invoice_id 
            GROUP BY pd.work_flow_id, pdii.expense_code,pd.company_code
            
            UNION ALL 
            
            SELECT pdm.work_flow_id, pdm.expense_code, SUM(COALESCE(pdm.local_amount, 0)) AS Amount
            	,pdm.company_code 
            FROM pc_document_mileage pdm
            GROUP BY pdm.work_flow_id, pdm.expense_code,pdm.company_code 
        ) AS expense
        INNER JOIN report_income_expense die ON expense.expense_code = die.expense_code
        WHERE expense.work_flow_id = p_workflow_id
        AND coalesce(die.active,false) = true
        AND die.expense_group_code = p_expense_group_code;

        -- Return the calculated expense amount
        RETURN ret;
    END;
$function$
;
