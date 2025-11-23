CREATE OR ALTER PROCEDURE silver.clean_crm_sales_details AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME;
	SET @start_time=GETDATE();
	PRINT 'TRUNCATING TABLE : silver.crm_sales_details ';
	TRUNCATE TABLE silver.crm_sales_details;
	PRINT 'INSERTING INTO TABLE : silver.crm_sales_details ';
	INSERT INTO silver.crm_sales_details(
		sls_ord_num,
		sls_prd_key,
		sls_cust_id,
		sls_order_dt,
		sls_ship_dt,
		sls_due_dt,
		sls_sales,
		sls_quantity,
		sls_price
	)
	SELECT
		TRIM(sls_ord_num) as sls_ord_num,
		TRIM(sls_prd_key) as sls_prd_key,
		sls_cust_id,
		CASE
			WHEN sls_order_dt<=0 OR LEN(sls_order_dt)!=8 THEN NULL
			ELSE CAST(CAST(sls_order_dt as VARCHAR) AS DATE) 
			END AS sls_order_dt,
		CASE
			WHEN sls_ship_dt<=0 OR LEN(sls_ship_dt)!=8 THEN NULL
			ELSE CAST(CAST(sls_ship_dt as VARCHAR) AS DATE) 
			END AS sls_ship_dt,
		CASE
			WHEN sls_due_dt<=0 OR LEN(sls_due_dt)!=8 THEN NULL
			ELSE CAST(CAST(sls_due_dt as VARCHAR) AS DATE) 
			END AS sls_due_dt,
		CASE
			WHEN sls_sales IS NULL OR sls_sales<=0 OR sls_sales!=sls_quantity*ABS(sls_price)
				THEN sls_quantity*ABS(sls_price)
			ELSE sls_sales
			END as sls_sales,
		CASE
			WHEN sls_quantity<=0 THEN NULL
			ELSE sls_quantity
			END as sls_quantity,
		CASE
			WHEN sls_price IS NULL OR sls_price<=0
				THEN sls_sales/NULLIF(sls_quantity,0)
			ELSE ABS(sls_price)
			END as sls_price
	FROM
		bronze.crm_sales_details
	SET @end_time=GETDATE();
	PRINT 'LOAD DURATION:' + CAST(DATEDIFF(second,@start_time,@end_time)AS NVARCHAR)+'seconds';
END