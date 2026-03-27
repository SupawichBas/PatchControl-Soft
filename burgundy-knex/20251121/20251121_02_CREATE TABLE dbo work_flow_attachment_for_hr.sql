CREATE TABLE dbo.work_flow_attachment_for_hr (
	id serial4 NOT NULL,
	work_flow_id int4 NULL,
	attach_file_path varchar(500) NULL,
	attach_file_name varchar(200) NULL,
	work_flow_attachment_type_code varchar(100) NULL,
	ref_id int4 NULL,
	seq int4 NULL,
	created_by varchar(20) NULL,
	created_date timestamptz NULL,
	created_program varchar(100) NULL,
	updated_by varchar(20) NULL,
	updated_date timestamptz NULL,
	updated_program varchar(100) NULL,
	content_id int4 NULL,
	CONSTRAINT work_flow_attachment_for_hr_pkey PRIMARY KEY (id)
);