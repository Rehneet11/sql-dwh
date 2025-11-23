CREATE OR ALTER PROCEDURE silver.clean_erp_cust_az12 AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME;
	SET @start_time=GETDATE();
	PRINT 'TRUNCATING TABLE : silver.erp_cust_az12 ';
	TRUNCATE TABLE silver.erp_cust_az12;
	PRINT 'INSERTING INTO TABLE : silver.erp_cust_az12 ';
	INSERT INTO silver.erp_cust_az12(
		cid,
		bdate,
		gen
	)
	SELECT 
		CASE
			WHEN cid LIKE 'NAS%'THEN SUBSTRING(cid,4,len(cid))
			ELSE cid
			END AS cid,
		CASE 
			WHEN bdate>GETDATE() THEN NULL
			ELSE bdate
			END AS bdate,
		CASE
			WHEN gen IS NULL or gen='' THEN 'N/A'
			WHEN UPPER(TRIM(gen)) IN ('F','FEMALE') THEN 'Female'
			WHEN UPPER(TRIM(gen)) IN ('M','MALE') THEN 'Male'
			ELSE gen
			END as gen
	FROM
		bronze.erp_cust_az12
	SET @end_time=GETDATE();
	PRINT 'LOAD DURATION:' + CAST(DATEDIFF(second,@start_time,@end_time)AS NVARCHAR)+'seconds';
END