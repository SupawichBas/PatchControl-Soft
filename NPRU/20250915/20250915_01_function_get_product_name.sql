drop function get_product_name;

CREATE OR REPLACE FUNCTION erp.get_product_name(p_lin_id character varying, p_product_type character varying, p_product_id integer, fa_type_id integer, fa_mkind_id integer)
 RETURNS character varying
 LANGUAGE plpgsql
AS $function$
DECLARE 
    v_product_name varchar(500);
BEGIN
    IF p_product_type = '1' THEN
        SELECT igl.goods_desc 
        INTO v_product_name
        FROM in_goods ig 
        LEFT JOIN in_goods_lang igl 
            ON ig.goods_id = igl.goods_id 
            AND lower(igl.language_code) = lower(p_lin_id)
        WHERE ig.goods_id = p_product_id 
        AND ig.group_id = fa_type_id
        AND ig.item_type_id = fa_mkind_id;
    ELSIF p_product_type = '2' THEN
        SELECT fsl.skind_name
        INTO v_product_name
        FROM fa_skind fs2 
        LEFT JOIN fa_skind_lang fsl 
            ON fs2.skind_id = fsl.skind_id 
            AND lower(fsl.language_code) = lower(p_lin_id)  
        WHERE fs2.skind_id = p_product_id  
        AND fs2.type_id = fa_type_id
        AND fs2.mkind_id = fa_mkind_id;
    ELSIF p_product_type = '3' THEN
        SELECT fa.asset_name 
        INTO v_product_name
        FROM fa_asset fa
        WHERE fa.asset_id = p_product_id  
        AND fa.type_id = fa_type_id
        AND fa.mkind_id = fa_mkind_id;
    ELSIF p_product_type = '4' THEN
        SELECT psl.service_type_name 
        INTO v_product_name
        FROM po_service ps 
        LEFT JOIN po_service_lang psl 
            ON ps.service_type_id = psl.service_type_id 
            AND lower(psl.language_code) = lower(p_lin_id)  
        WHERE ps.service_type_id = p_product_id;
   	ELSE
        v_product_name := NULL;
    END IF;
    RETURN v_product_name;
END;
$function$
;
