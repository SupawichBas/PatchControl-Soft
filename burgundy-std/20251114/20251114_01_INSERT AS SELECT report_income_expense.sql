INSERT INTO report_income_expense
(company_code, group_code, expense_code, description, expense_group_code, active, created_by, created_date, created_program)
select die.company_code as company_code
		,die.expense_group_code as group_code
		,die.expense_code as expense_code
		,die.description as description
		,die.expense_group_code as expense_group_code
		,die.active as active
	    ,'Script_20251114' as created_by
	    ,current_timestamp as created_date
	    ,'Migrate20251114' as created_program
from db_income_expense die 
where die.expense_group_code in ('EG001','EG002','EG003','EG004')
order by die.expense_group_code ;