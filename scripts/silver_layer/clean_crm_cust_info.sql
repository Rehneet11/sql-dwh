CREATE OR ALTER PROCEDURE silver.clean_crm_cust_info AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME;
	SET @start_time=GETDATE();
	PRINT 'TRUNCATING TABLE : silver.crm_cust_info ';
	TRUNCATE TABLE silver.crm_cust_info;
	PRINT 'INSERTING INTO TABLE : silver.crm_cust_info ';
	INSERT INTO silver.crm_cust_info(
		cst_id,
		cst_key,
		cst_firstname,
		cst_lastname,
		cst_marital_status,
		cst_gndr,
		cst_create_date)

	Select 
		cst_id,
		cst_key,
		TRIM(cst_firstname) as cst_first_name,
		TRIM(cst_lastname)as cst_lastname,

		CASE 
			WHEN UPPER(TRIM(cst_marital_status))='M' THEN 'Married'
			WHEN UPPER(TRIM(cst_marital_status))='S' THEN 'Single'
			ELSE 'N/A'
		END as cst_marital_status,

		CASE 
			WHEN UPPER(TRIM(cst_gndr))='M' THEN 'Male'
			WHEN UPPER(TRIM(cst_gndr))='F' THEN 'Female'
			ELSE 'N/A'
		END as cst_gndr,

		cst_create_date

	from
	(	Select 
			*,
			ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) as flag_last
		from bronze.crm_cust_info)t 
	where flag_last=1 and cst_id is NOT NULL
	SET @end_time=GETDATE();
	PRINT 'LOAD DURATION:' + CAST(DATEDIFF(second,@start_time,@end_time)AS NVARCHAR)+'seconds';
END

