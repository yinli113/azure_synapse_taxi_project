USE taxi_project;
GO

CREATE OR ALTER PROCEDURE gold.sp_green_tripdata_time_factors
@year VARCHAR(4),
@month VARCHAR(2)
AS
BEGIN
    DECLARE @create_sql_stmt NVARCHAR(MAX),
            @drop_sql_stmt   NVARCHAR(MAX);

    -- Drop the external table if it exists
    SET @drop_sql_stmt = 
        'IF OBJECT_ID(''gold.green_tripdata_time_' + @year + '_' + @month + ''') IS NOT NULL 
         BEGIN 
            DROP EXTERNAL TABLE gold.green_tripdata_time_' + @year + '_' + @month + '; 
         END';

    PRINT(@drop_sql_stmt);
    EXEC sp_executesql @drop_sql_stmt;

    -- Create the external table
    SET @create_sql_stmt = 
        'CREATE EXTERNAL TABLE gold.green_tripdata_time_' + @year + '_' + @month + 
        ' WITH
            (
                DATA_SOURCE = green_tripdata_src,
                LOCATION = ''gold/gold_time/year=' + @year + '/month=' + @month + ''',
                FILE_FORMAT = parquet_file_format
            )
        AS
        SELECT 
            sv.year,
            sv.month,
            sv.tip_amount,
            sv.total_amount,
            sv.duration_minutes,
            DATEPART(WEEKDAY, sv.lpep_pickup_datetime) AS DayOfWeek,
            FORMAT(sv.lpep_pickup_datetime, ''HH:mm:ss'') AS PickupTime,
            CASE 
                WHEN DATEPART(HOUR, sv.lpep_pickup_datetime) >= 0 AND DATEPART(HOUR, sv.lpep_pickup_datetime) < 3 THEN ''1''
                WHEN DATEPART(HOUR, sv.lpep_pickup_datetime) >= 3 AND DATEPART(HOUR, sv.lpep_pickup_datetime) < 6 THEN ''2''
                WHEN DATEPART(HOUR, sv.lpep_pickup_datetime) >= 6 AND DATEPART(HOUR, sv.lpep_pickup_datetime) < 9 THEN ''3''
                WHEN DATEPART(HOUR, sv.lpep_pickup_datetime) >= 9 AND DATEPART(HOUR, sv.lpep_pickup_datetime) < 16 THEN ''4''
                WHEN DATEPART(HOUR, sv.lpep_pickup_datetime) >= 16 AND DATEPART(HOUR, sv.lpep_pickup_datetime) < 20 THEN ''5''
                WHEN DATEPART(HOUR, sv.lpep_pickup_datetime) >= 20 AND DATEPART(HOUR, sv.lpep_pickup_datetime) < 24 THEN ''6''
            END AS PickupTime_type,
            CASE
                WHEN sv.duration_minutes = 0 THEN ''not_depart''
                WHEN sv.duration_minutes > 0 AND sv.duration_minutes < 60 THEN ''to_hour''
                WHEN sv.duration_minutes >= 60 AND sv.duration_minutes < 180 THEN ''mid_hour''
                WHEN sv.duration_minutes >= 180 AND sv.duration_minutes < 300 THEN ''long_hour''
                WHEN sv.duration_minutes >= 300 THEN  ''super_hour''
            END AS duration_type
        FROM
            silver.view_green_tripdata sv
        WHERE sv.year = ''' + @year + '''
          AND sv.month = ''' + @month + '''';    

    PRINT(@create_sql_stmt);
    EXEC sp_executesql @create_sql_stmt;
END;

USE taxi_project;

-- create gold table for analyse the relation between total amount and time related factors
/*
SELECT 
    sv.year,
    sv.month,
    tip_amount,
    total_amount,
    duration_minutes,
    DATEPART(WEEKDAY, lpep_pickup_datetime) AS DayOfWeek,
    FORMAT(lpep_pickup_datetime, 'HH:mm:ss') AS PickupTime,
    CASE 
        WHEN DATEPART(HOUR, lpep_pickup_datetime) >= 0 AND DATEPART(HOUR, lpep_pickup_datetime) < 3 THEN '1'
        WHEN DATEPART(HOUR, lpep_pickup_datetime) >= 3 AND DATEPART(HOUR, lpep_pickup_datetime) < 6 THEN '2'
        WHEN DATEPART(HOUR, lpep_pickup_datetime) >= 6 AND DATEPART(HOUR, lpep_pickup_datetime) < 9 THEN '3'
        WHEN DATEPART(HOUR, lpep_pickup_datetime) >= 9 AND DATEPART(HOUR, lpep_pickup_datetime) < 16 THEN '4'
        WHEN DATEPART(HOUR, lpep_pickup_datetime) >= 16 AND DATEPART(HOUR, lpep_pickup_datetime) < 20 THEN '5'
        WHEN DATEPART(HOUR, lpep_pickup_datetime) >= 20 AND DATEPART(HOUR, lpep_pickup_datetime) < 24 THEN '6'
    END AS PickupTime_type,
    CASE
        WHEN duration_minutes = 0 THEN 'not_depart'
        WHEN duration_minutes > 0 AND duration_minutes < 60 THEN 'to_hour'
        WHEN duration_minutes >= 60 AND duration_minutes < 180 THEN 'mid_hour'
        WHEN duration_minutes >= 180 AND duration_minutes < 300 THEN 'long_hour'
        WHEN duration_minutes >= 300 THEN 'super_hour'
    END AS duration_type
FROM
    silver.view_green_tripdata sv;
*/

EXEC gold.sp_green_tripdata_time_factors '2024','01'
EXEC gold.sp_green_tripdata_time_factors '2024','02'
EXEC gold.sp_green_tripdata_time_factors '2024','03'
EXEC gold.sp_green_tripdata_time_factors '2024','04'
EXEC gold.sp_green_tripdata_time_factors '2023','01'
EXEC gold.sp_green_tripdata_time_factors '2023','02'
EXEC gold.sp_green_tripdata_time_factors '2023','03'
EXEC gold.sp_green_tripdata_time_factors '2023','04'
EXEC gold.sp_green_tripdata_time_factors '2023','05'
EXEC gold.sp_green_tripdata_time_factors '2023','06'
EXEC gold.sp_green_tripdata_time_factors '2023','07'
EXEC gold.sp_green_tripdata_time_factors '2023','08'
EXEC gold.sp_green_tripdata_time_factors '2023','09'
EXEC gold.sp_green_tripdata_time_factors '2023','10'
EXEC gold.sp_green_tripdata_time_factors '2023','11'
EXEC gold.sp_green_tripdata_time_factors '2023','12'
