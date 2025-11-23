CREATE OR ALTER PROCEDURE silver.clean_erp_px_cat_g1v2 AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME;
	SET @start_time=GETDATE();
	PRINT 'TRUNCATING TABLE : silver.erp_px_cat_g1v2 ';
	TRUNCATE TABLE silver.erp_px_cat_g1v2;
	PRINT 'INSERTING INTO TABLE : silver.erp_px_cat_g1v2 ';
	INSERT INTO silver.erp_px_cat_g1v2(
		id,
		cat,
		subcat,
		maintenace
	)
	Select
		id,
		TRIM(cat) as cat,
		TRIM(subcat) as subcat,
		TRIM(maintenace) as maintenace
	FROM
		bronze.erp_px_cat_g1v2
	SET @end_time=GETDATE();
	PRINT 'LOAD DURATION:' + CAST(DATEDIFF(second,@start_time,@end_time)AS NVARCHAR)+'seconds';
END