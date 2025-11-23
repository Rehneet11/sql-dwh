CREATE OR ALTER PROCEDURE silver.clean_erp_loc_a101 AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME;
	SET @start_time=GETDATE();
	PRINT 'TRUNCATING TABLE : silver.erp_loc_a101 ';
	TRUNCATE TABLE silver.erp_loc_a101;
	PRINT 'INSERTING INTO TABLE : silver.erp_loc_a101 ';
	INSERT INTO silver.erp_loc_a101(
		cid,
		cntry
	)
	SELECT
		REPLACE(cid,'-','') cid,
		CASE
			WHEN TRIM(cntry)='DE' THEN 'Germany'
			WHEN TRIM(cntry) IN ('US','USA') THEN 'United States'
			WHEN cntry IS NULL OR cntry='' THEN 'N/A'
			ELSE cntry
			END AS cntry
	FROM
		bronze.erp_loc_a101
	SET @end_time=GETDATE();
	PRINT 'LOAD DURATION:' + CAST(DATEDIFF(second,@start_time,@end_time)AS NVARCHAR)+'seconds';
END