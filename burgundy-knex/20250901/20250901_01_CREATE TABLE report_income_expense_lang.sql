CREATE TABLE report_income_expense_lang (
	group_code varchar(20) NOT NULL,
	expense_code varchar(20) NOT NULL,
	language_code varchar(20) NOT NULL,
	expense_name varchar(200) NULL,
	expense_group_code varchar(20) NULL,
	active bool NULL,
	created_by varchar(20) NULL,
	created_date timestamptz NULL,
	created_program varchar(100) NULL,
	updated_by varchar(20) NULL,
	updated_date timestamptz NULL,
	updated_program varchar(100) NULL,
	CONSTRAINT report_income_expense_lang_pkey PRIMARY KEY (group_code, expense_code, language_code),
	CONSTRAINT fk_report_income_expense_lang_report_income_expense FOREIGN KEY (group_code,expense_code) REFERENCES report_income_expense(group_code,expense_code) ON DELETE CASCADE
);