CREATE OR ALTER PROCEDURE silver.clean_crm_prd_info AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME;
	SET @start_time=GETDATE();
	PRINT 'TRUNCATING TABLE : silver.crm_prd_info ';
	TRUNCATE TABLE silver.crm_prd_info;
	PRINT 'INSERTING INTO TABLE : silver.crm_prd_info ';
	INSERT INTO silver.crm_prd_info(
		prd_id,
		cat_id,
		prd_key,
		prd_nm,
		prd_cost,
		prd_line,
		prd_start_dt,
		prd_end_dt
	)
	Select
		prd_id,
		CONCAT(SUBSTRING(prd_key,1,2),'_',SUBSTRING(prd_key,4,2)) as cat_id,
		SUBSTRING(prd_key,7,LEN(prd_key)) as prd_key,
		TRIM(prd_nm) as prd_nm,
		CASE
			WHEN prd_cost is NULL OR prd_cost<0 THEN 0
			ELSE prd_cost
		END as prd_cost,
		CASE UPPER(TRIM(prd_line))
			WHEN 'M' THEN 'Mountain'
			WHEN 'R' THEN 'Road'
			WHEN 'S' THEN 'Sport'
			WHEN 'T' THEN 'Touring'
			ELSE 'N/A'
		END AS prd_line,
		prd_start_dt,
		DATEADD(day,-1,LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt))AS prd_end_dt
	FROM
		bronze.crm_prd_info
	SET @end_time=GETDATE();
	PRINT 'LOAD DURATION:' + CAST(DATEDIFF(second,@start_time,@end_time)AS NVARCHAR)+'seconds';
END