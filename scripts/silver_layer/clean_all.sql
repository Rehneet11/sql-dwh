CREATE OR ALTER PROCEDURE silver.clean_all AS
BEGIN
	DECLARE @start_time DATETIME,@end_time DATETIME;
	BEGIN TRY

		PRINT '===============================================';
		PRINT 'LOADING SILVER LAYER';
		PRINT '===============================================';

		PRINT 'LOADING CRM';
		PRINT '-----------------------------------------------';

		SET @start_time=GETDATE();
		PRINT 'CLEANING AND STANDARDIZING silver.crm_cust_info';
		EXEC silver.clean_crm_cust_info;
		PRINT '-----------------------------------------------';

		PRINT 'CLEANING AND STANDARDIZING silver.crm_prd_info';
		EXEC silver.clean_crm_prd_info;
		PRINT '-----------------------------------------------';

		PRINT 'CLEANING AND STANDARDIZING silver.crm_sales_details';
		EXEC silver.clean_crm_sales_details;
		PRINT '-----------------------------------------------';

		PRINT '===============================================';
		PRINT 'LOADING ERP';
		PRINT '-----------------------------------------------';

		PRINT 'CLEANING AND STANDARDIZING silver.erp_cust_az12';
		EXEC silver.clean_erp_cust_az12;
		PRINT '-----------------------------------------------';

		PRINT 'CLEANING AND STANDARDIZING silver.erp_loc_a101';
		EXEC silver.clean_erp_loc_a101;
		PRINT '-----------------------------------------------';

		PRINT 'CLEANING AND STANDARDIZING silver.erp_px_cat_g1v2';
		EXEC silver.clean_erp_px_cat_g1v2;
		PRINT '-----------------------------------------------';

		SET @end_time=GETDATE();
		PRINT '===============================================';
		PRINT 'TIME DURATION TO CLEAN AND STANDARDIZE SILVER LAYER :'+ CAST(DATEDIFF(second,@start_time,@end_time) as NVARCHAR) + ' seconds';
	END TRY
	BEGIN CATCH

		PRINT '===============================================';
		PRINT 'ERROR DURING CLEANING AND STANDARDIZING SILVER LAYER';
		PRINT 'ERROR MESSAGE' + ERROR_MESSAGE();
		PRINT 'ERROR NUMBER' + CAST(ERROR_NUMBER() AS NVARCHAR);
		PRINT '===============================================';

	END CATCH
END