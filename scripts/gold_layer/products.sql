CREATE OR ALTER VIEW gold.dim_products AS
SELECT
	ROW_NUMBER() OVER(ORDER BY prod.prd_start_dt,prod.prd_key) AS product_key,
	prod.prd_id AS product_id,
	prod.prd_key AS product_number,
	prod.prd_nm AS product_name,
	prod.prd_cost AS product_cost,
	prod.prd_line AS product_line,
	prod.cat_id AS category_id,
	pcat.cat AS category_name,
	pcat.subcat AS sub_category_name,
	pcat.maintenace AS maintenance,
	prod.prd_start_dt AS product_start_date
FROM
	silver.crm_prd_info prod

LEFT JOIN
	silver.erp_px_cat_g1v2 pcat
	ON prod.cat_id=pcat.id

WHERE prod.prd_end_dt IS NULL