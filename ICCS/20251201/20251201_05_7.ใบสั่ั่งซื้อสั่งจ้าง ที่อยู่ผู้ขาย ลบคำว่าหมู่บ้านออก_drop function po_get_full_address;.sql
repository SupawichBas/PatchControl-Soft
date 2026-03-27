drop function po_get_full_address;

CREATE OR REPLACE FUNCTION erp.po_get_full_address(p_house_no text, p_village text, p_building text, p_moo text, p_soi text, p_road text, p_sub_district_id bigint, p_district_id bigint, p_province_id bigint, p_postal_code_id bigint, p_program_code text, p_lang text)
 RETURNS TABLE(full_address text)
 LANGUAGE plpgsql
AS $function$
declare
	v_address text;
	v_province text;
	v_district text;
	v_sub_district text;
	v_postal_code text;
BEGIN
	select coalesce(p_house_no||' ','')
	||case when coalesce(trim(p_village),'') = '' then '' else 
--	get_program_label_name(p_program_code, 'AdsVillage', p_lang)||
	p_village||' ' end
	||case when coalesce(trim(p_building),'') = '' then '' else get_program_label_name(p_program_code, 'AdsBuilding', p_lang)||p_building||' ' end
	||case when coalesce(trim(p_moo),'') = '' then '' else get_program_label_name(p_program_code, 'AdsMoo', p_lang)||p_moo||' ' end
	||case when coalesce(trim(p_soi),'') = '' then '' else get_program_label_name(p_program_code, 'AdsSoi', p_lang)||p_soi||' ' end
	||case when coalesce(trim(p_road),'') = '' then '' else get_program_label_name(p_program_code, 'AdsRoad', p_lang)||p_road||' ' end
	into v_address;

	begin 
		select get_program_label_name(p_program_code, 'ProvinceShort', p_lang)||dpl.province_name||' '
		into v_province
		from db_province dp 
		Left JOIN db_province_lang dpl ON dp.province_id = dpl.province_id
									AND dpl.language_code = p_lang
		where dp.province_id = p_province_id;
	exception when no_data_found then 
		v_province = null ;
	end;

	begin
		select case when p_province_id = db_get_parameter_value('PO','ProvinceIdBKK')::int then get_program_label_name(p_program_code, 'SubDistrictBKK', p_lang)||dsdl.sub_district_name||' '  else get_program_label_name(p_program_code, 'SubDistrictShort', p_lang)||dsdl.sub_district_name||' '  end
		into v_sub_district
		from db_sub_district dsd 
		Left JOIN db_sub_district_lang dsdl ON dsd.sub_district_id = dsdl.sub_district_id 
		                                     AND dsdl.language_code = p_lang 
		where dsd.sub_district_id = p_sub_district_id;
	exception when no_data_found then
		v_sub_district = null;
	end;

	begin
		select case when p_province_id = db_get_parameter_value('PO','ProvinceIdBKK')::int then get_program_label_name(p_program_code, 'DistrictBKK', p_lang)||ddl.district_name||' '  else get_program_label_name(p_program_code, 'DistrictShort', p_lang)||ddl.district_name||' '  end 
		into v_district
		from db_district dd 
		Left JOIN db_district_lang ddl ON dd.district_id = ddl.district_id 
		                                AND ddl.language_code = p_lang
		where dd.district_id = p_district_id;
	exception when no_data_found then
		v_district = null;
	end;

	begin	
		select dpc.postal_code 
		into v_postal_code
		from db_postal_code dpc 
		where dpc.postal_code_id = p_postal_code_id;	
	exception when no_data_found then
		v_postal_code = null;
	end;
	

	return query
--	select v_address||v_sub_district||v_district||v_province||v_postal_code::text;
	select concat(v_address,v_sub_district,v_district,v_province,v_postal_code)::text;
		

	END;
$function$
;
