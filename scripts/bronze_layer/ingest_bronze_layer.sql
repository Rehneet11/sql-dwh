CREATE OR ALTER PROCEDURE bronze.ingest_bronze AS
BEGIN

	DECLARE @start_time DATETIME, @end_time DATETIME, @overall_start_time DATETIME , @overall_end_time DATETIME

	BEGIN TRY

		PRINT '===============================================';
		PRINT 'LOADING BRONZE LAYER';
		PRINT '===============================================';

		PRINT 'LOADING CRM';
		PRINT '-----------------------------------------------';
		SET @start_time=GETDATE();
		SET @overall_start_time=GETDATE();
		PRINT 'TRUNCATING TABLE : bronze.crm_cust_info '
		TRUNCATE TABLE bronze.crm_cust_info;
		PRINT 'INSERTING INTO TABLE : bronze.crm_cust_info '
		BULK INSERT bronze.crm_cust_info
		FROM 'C:\dwh_project\datasets\source_crm\cust_info.csv'
		WITH (
			FIRSTROW=2,
			FIELDTERMINATOR=',',
			TABLOCK
		);
		SET @end_time=GETDATE();
		PRINT 'LOAD DURATION:' + CAST(DATEDIFF(second,@start_time,@end_time)AS NVARCHAR)+'seconds';
		PRINT '-----------------------------------------------';


		SET @start_time=GETDATE();
		PRINT 'TRUNCATING TABLE : bronze.crm_prd_info '
		TRUNCATE TABLE bronze.crm_prd_info;
		PRINT 'INSERTING INTO TABLE : bronze.crm_prd_info '
		BULK INSERT bronze.crm_prd_info
		FROM 'C:\dwh_project\datasets\source_crm\prd_info.csv'
		WITH (
			FIRSTROW=2,
			FIELDTERMINATOR=',',
			TABLOCK
		);
		SET @end_time=GETDATE();
		PRINT 'LOAD DURATION:' + CAST(DATEDIFF(second,@start_time,@end_time)AS NVARCHAR)+'seconds';
		PRINT '-----------------------------------------------';


		SET @start_time=GETDATE();
		PRINT 'TRUNCATING TABLE : bronze.crm_sales_details '
		TRUNCATE TABLE bronze.crm_sales_details;
		PRINT 'INSERTING INTO TABLE : bronze.crm_sales_details '
		BULK INSERT bronze.crm_sales_details
		FROM 'C:\dwh_project\datasets\source_crm\sales_details.csv'
		WITH (
			FIRSTROW=2,
			FIELDTERMINATOR=',',
			TABLOCK
		);
		SET @end_time=GETDATE();
		PRINT 'LOAD DURATION:' + CAST(DATEDIFF(second,@start_time,@end_time)AS NVARCHAR)+'seconds';
		PRINT '-----------------------------------------------';


		PRINT '===============================================';
		PRINT 'LOADING ERP';

		PRINT '-----------------------------------------------';
		SET @start_time=GETDATE();
		PRINT 'TRUNCATING TABLE : bronze.erp_cust_az12 '
		TRUNCATE TABLE bronze.erp_cust_az12;
		PRINT 'INSERTING INTO TABLE : bronze.erp_cust_az12'
		BULK INSERT bronze.erp_cust_az12
		FROM 'C:\dwh_project\datasets\source_erp\cust_az12.csv'
		WITH (
			FIRSTROW=2,
			FIELDTERMINATOR=',',
			TABLOCK
		);
		SET @end_time=GETDATE();
		PRINT 'LOAD DURATION:' + CAST(DATEDIFF(second,@start_time,@end_time)AS NVARCHAR)+'seconds';
		PRINT '-----------------------------------------------';


		SET @start_time=GETDATE();
		PRINT 'TRUNCATING TABLE : bronze.erp_loc_a101 '
		TRUNCATE TABLE bronze.erp_loc_a101;
		PRINT 'INSERTING INTO TABLE : bronze.erp_loc_a101 '
		BULK INSERT bronze.erp_loc_a101
		FROM 'C:\dwh_project\datasets\source_erp\loc_a101.csv'
		WITH (
			FIRSTROW=2,
			FIELDTERMINATOR=',',
			TABLOCK
		);
		SET @end_time=GETDATE();
		PRINT 'LOAD DURATION:' + CAST(DATEDIFF(second,@start_time,@end_time)AS NVARCHAR)+'seconds';
		PRINT '-----------------------------------------------';


		SET @start_time=GETDATE();
		PRINT 'TRUNCATING TABLE : bronze.erp_px_cat_g1v2 '
		TRUNCATE TABLE bronze.erp_px_cat_g1v2;
		PRINT 'INSERTING INTO TABLE : bronze.erp_px_cat_g1v2 '
		BULK INSERT bronze.erp_px_cat_g1v2
		FROM 'C:\dwh_project\datasets\source_erp\px_cat_g1v2.csv'
		WITH (
			FIRSTROW=2,
			FIELDTERMINATOR=',',
			TABLOCK
		);
		SET @end_time=GETDATE();
		PRINT 'LOAD DURATION:' + CAST(DATEDIFF(second,@start_time,@end_time)AS NVARCHAR)+' seconds';
		PRINT '-----------------------------------------------';

		SET @overall_end_time=GETDATE();
		PRINT '===============================================';
		PRINT 'BRONZE LAYER INGEST DURATION:' + CAST(DATEDIFF(second,@overall_start_time,@overall_end_time)AS NVARCHAR)+'seconds';
		PRINT '===============================================';

	END TRY

	BEGIN CATCH

		PRINT '===============================================';
		PRINT 'ERROR DURING INGESTING BRONZE LAYER';
		PRINT 'ERROR MESSAGE' + ERROR_MESSAGE();
		PRINT 'ERROR NUMBER' + CAST(ERROR_NUMBER() AS NVARCHAR);
		PRINT '===============================================';

	END CATCH
END;