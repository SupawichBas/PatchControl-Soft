drop function report_smsumrp08;

CREATE OR REPLACE FUNCTION dbo.report_smsumrp08(p_lin_id character varying, p_ou_code character varying, p_branch_code character varying, p_requester_code character varying, p_invoice_date_from character varying, p_invoice_date_to character varying, p_document_date_from character varying, p_document_date_to character varying, p_document_no character varying, p_vendor_code character varying, user_login integer)
 RETURNS TABLE(company_name character varying, branch_name character varying, print_date timestamp with time zone, document_no character varying, document_date character varying, vendor_tax_id character varying, vendor_branch_code character varying, vendor_branch_name character varying, vendor_name character varying, vendor_address character varying, vendor_sub_district character varying, vendor_district character varying, vendor_province character varying, vendor_postal_code character varying, vendor_address_prompt character varying, payment_date character varying, imcome_type character varying, tax_rate numeric, total_amount numeric, total_wht_amount numeric, description character varying, vendor_name_cri character varying, requester_name_cri character varying)
 LANGUAGE plpgsql
AS $function$
declare UserCompany varchar(20);
declare UserCode varchar(20);
declare CheckPrivilege varchar(1);
	BEGIN
	UserCompany = get_user_company_code(user_login);
	UserCode = get_user_code(user_login);
	CheckPrivilege = dbo.get_user_privilege(UserCompany, user_login);
	RETURN QUERY
	-- Start query
	
		SELECT 	
			NULLIF(get_company_code_name(
				p_lin_id,
				NULLIF(wf.company_code, '')
			), ''):: CHARACTER VARYING AS company_name,
			NULLIF(get_branch_code_name(
				p_lin_id,
				NULLIF(wf.branch_code, '')
			), ''):: CHARACTER VARYING AS branch_name,
			current_timestamp AS print_date,
			NULLIF(wf.document_no, ''):: CHARACTER VARYING AS document_no,
			NULLIF(to_char(wf.document_date, 'dd/MM/yyyy'), ''):: CHARACTER VARYING AS document_date,
			NULLIF(prq_item.vendor_tax_id, ''):: CHARACTER VARYING AS vendor_tax_id,
			NULLIF(vb.vendor_branch_code, ''):: CHARACTER VARYING AS vendor_branch_code,
			NULLIF(vbl.vendor_branch_name , ''):: CHARACTER VARYING AS vendor_branch_name,
			CASE WHEN COALESCE(v.is_onetime, FALSE) = TRUE THEN NULLIF(prq_item.vendor_name, '')
				 ELSE NULLIF(vl.vendor_name, '')
				  END :: CHARACTER VARYING AS vendor_name,
			CASE WHEN COALESCE(v.is_onetime, FALSE) = TRUE THEN NULLIF(prq_item.vendor_address_4, '')
				 ELSE NULLIF(vbl.address, '')
				  END :: CHARACTER VARYING AS vendor_address,
			NULLIF(sdl.sub_district_name, ''):: CHARACTER VARYING AS vendor_sub_district,
			NULLIF(dl.district_name, ''):: CHARACTER VARYING AS vendor_district,
			NULLIF(pl.province_name, ''):: CHARACTER VARYING AS vendor_province,
			NULLIF(prq_item.vendor_postal_code, ''):: CHARACTER VARYING AS vendor_postal_code,
			NULLIF(vbl.address_prompt, ''):: CHARACTER VARYING AS vendor_address_prompt,
			NULLIF(to_char(prq_item.payment_date, 'dd/MM/yyyy'), ''):: CHARACTER VARYING AS payment_date,
			tl.tax_name:: CHARACTER VARYING AS imcome_type,
			prq_item_wht.wht_rate:: NUMERIC AS tax_rate,
			prq_item.total_amount_local:: NUMERIC AS total_amount,
			prq_item.total_wht_amount_local:: NUMERIC AS total_wht_amount,
			prq_item.description:: CHARACTER VARYING AS description,
			vdl_cri.vendor_name:: CHARACTER VARYING AS vendor_name_cri,
			get_employee_name(	
				p_lin_id, 
				wf.company_code, 
				wf.branch_code, 
				wf.requester_user_code
			 ):: CHARACTER VARYING AS requester_name_cri
	FROM work_flow wf
	INNER JOIN prq_document prq ON prq.work_flow_id = wf.work_flow_id
	INNER JOIN prq_document_item prq_item ON prq_item.prq_document_id = prq.prq_document_id
	INNER JOIN prq_document_item_wht prq_item_wht ON prq_item_wht.prq_document_item_id = prq_item.prq_document_item_id 
	LEFT JOIN db_vendor v ON v.vendor_code = prq_item.vendor_code 
						 AND v.company_code = prq_item.company_code
	LEFT JOIN db_vendor_lang vl ON vl.vendor_code = v.vendor_code 
							   AND vl.company_code = v.company_code 
							   AND vl.language_code = p_lin_id
	LEFT JOIN db_vendor_branch vb ON vb.vendor_code = v.vendor_code 
								 AND vb.company_code = v.company_code 
								 AND vb.vendor_branch_code = prq_item.vendor_branch_code
	LEFT JOIN db_vendor_branch_lang vbl ON vbl.vendor_code = vb.vendor_code 
									   AND vbl.company_code = vb.company_code 
									   AND vbl.vendor_branch_code = vb.vendor_branch_code 
									   AND vbl.language_code = p_lin_id
	LEFT JOIN db_province_lang pl ON pl.company_code = prq_item.company_code 
								 AND pl.province_code = prq_item.vendor_address_1
								 AND pl.language_code = p_lin_id
	LEFT JOIN db_district_lang dl ON dl.company_code = prq_item.company_code 
								 AND dl.province_code = prq_item.vendor_address_1
								 AND dl.district_code = prq_item.vendor_address_2 
								 AND dl.language_code = p_lin_id
	LEFT JOIN db_sub_district_lang sdl ON sdl.company_code = prq_item.company_code 
									  AND sdl.province_code = prq_item.vendor_address_1 
									  AND sdl.district_code = prq_item.vendor_address_2 
									  AND sdl.sub_district_code = prq_item.vendor_address_3 
									  AND sdl.language_code = p_lin_id
	LEFT JOIN db_vendor_lang AS vdl_cri	ON vdl_cri.vendor_code = prq_item.vendor_code
							           AND vdl_cri.company_code = prq_item.company_code 
							           AND vdl_cri.language_code = p_lin_id
  	LEFT JOIN db_tax_lang tl ON tl.company_code = prq_item_wht.company_code 
  							AND tl.tax_code = prq_item_wht.wht_method_code
  							AND tl.language_code = p_lin_id
	WHERE COALESCE(prq_item.has_wht, FALSE) = TRUE
	AND COALESCE(wf.company_code, '') = COALESCE(p_ou_code, wf.company_code, '')
	AND COALESCE(wf.branch_code, '') = COALESCE(p_branch_code, wf.branch_code, '')
	AND COALESCE(wf.requester_user_code, '') = COALESCE(p_requester_code, wf.requester_user_code, '')
	AND COALESCE(wf.document_no, '') = COALESCE(p_document_no, wf.document_no, '')
	AND COALESCE(prq_item.vendor_code, '') = COALESCE(p_vendor_code, prq_item.vendor_code, '')
	AND	COALESCE(prq_item.available_document_date::DATE, '1970-01-01'::DATE) BETWEEN
																			 COALESCE(p_invoice_date_from::DATE, prq_item.available_document_date::DATE, '1970-01-01'::DATE)
																			 AND
																			 COALESCE(p_invoice_date_to::DATE, prq_item.available_document_date::DATE, '1970-01-01'::DATE)
	AND	COALESCE(wf.document_date::DATE, '1970-01-01'::DATE) BETWEEN
															 COALESCE(p_document_date_from::DATE, wf.document_date::DATE, '1970-01-01'::DATE)
															 AND
															 COALESCE(p_document_date_to::DATE, wf.document_date::DATE, '1970-01-01'::DATE)
	and EXISTS (select get_exists_on_report(wf.work_flow_id, UserCode))
	-- AND (
	-- 	    (
	-- 	    CheckPrivilege = '1'
	-- 	    and
	-- 	    EXISTS (
	--             SELECT 'x' FROM su_user_organization suo
	--             WHERE suo.user_id = user_login --'214'
	--             AND suo.company_code = wf.company_code
	--             and suo.profile_type = 'Document'
	--         		))
	-- 	    OR EXISTS (
	-- 	        SELECT 'x' FROM su_user_authorized sua 
	-- 	        WHERE sua.authorized_emp_code = wf.requester_user_code
	-- 	        AND sua.emp_code = UserCode
	-- 	    		) 
	-- 	    OR (wf.requester_user_code = UserCode 
	-- 	    OR wf.creator_user_code = UserCode )
	-- 		)
	-- End query
	;END;
$function$
;
