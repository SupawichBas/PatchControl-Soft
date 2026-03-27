CREATE TABLE db_cost_center_default_approval (
	id serial4 NOT NULL,
	company_code varchar(20) NOT NULL,
	cost_center_code varchar(20) NOT NULL,
	emp_code varchar(20) NOT NULL,
    seq INT NULL, 
	active bool NULL DEFAULT true,
	created_by varchar(100) NULL,
	created_date timestamp NULL,
	created_program varchar(100) NULL,
	updated_by varchar(100) NULL,
	updated_date timestamp NULL,
	updated_program varchar(100) NULL,
	CONSTRAINT pk_db_cost_center_default_approval PRIMARY KEY (id)
);