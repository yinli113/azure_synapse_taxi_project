USE taxi_project;
GO

CREATE OR ALTER PROCEDURE gold.sp_green_tripdata_no_time_factors
@year VARCHAR(4),
@month VARCHAR(2)
AS
BEGIN
    DECLARE @create_sql_stmt NVARCHAR(MAX),
            @drop_sql_stmt   NVARCHAR(MAX);

    -- Drop the external table if it exists
    SET @drop_sql_stmt = 
        'IF OBJECT_ID(''gold.green_tripdata_no_time_' + @year + '_' + @month + ''') IS NOT NULL 
         BEGIN 
            DROP EXTERNAL TABLE gold.green_tripdata_no_time_' + @year + '_' + @month + '; 
         END';

    PRINT(@drop_sql_stmt);
    EXEC sp_executesql @drop_sql_stmt;

    -- Create the external table
    SET @create_sql_stmt = 
        'CREATE EXTERNAL TABLE gold.green_tripdata_no_time_' + @year + '_' + @month + 
        ' WITH
            (
                DATA_SOURCE = green_tripdata_src,
                LOCATION = ''gold/gold_no_time/year=' + @year + '/month=' + @month + ''',
                FILE_FORMAT = parquet_file_format
            )
        AS
        SELECT 
            sv.year,
            sv.month,
            sr.rate_code,
            st.borough,
            sv.passenger_count,
            sv.trip_distance,
            sv.tip_amount,
            sv.total_amount,
            str.trip_type_desc,
            sp.description,
            sv.congestion_surcharge
        FROM
            silver.view_green_tripdata sv
        JOIN silver.rate_code sr ON (sv.RatecodeID = sr.rate_code_id)
        JOIN silver.taxi_zone st ON (sv.PULocationID = st.location_id)
        JOIN silver.trip_type str ON (sv.trip_type = str.trip_type)
        JOIN silver.payment_type sp ON (sv.payment_type = sp.payment_type )
        WHERE sv.year = ''' + @year + '''
              AND sv.month = ''' + @month + '''';

    PRINT(@create_sql_stmt);
    EXEC sp_executesql @create_sql_stmt;
END;

USE taxi_project;

-- create gold table for analyse the relation between total amount money and factors
-- that include ratecode, borough, passenger_count,trip_distance, payment_type,trip_type,congestion_surcharge
/*
SELECT 
        sv.year,
        sv.month,
        sr.rate_code,
        st.borough,
        sv.passenger_count,
        sv.trip_distance,
        sv.tip_amount,
        sv.total_amount,
        str.trip_type_desc,
        sp.description,
        sv.congestion_surcharge
FROM
    silver.view_green_tripdata sv
JOIN silver.rate_code sr ON (sv.RatecodeID = sr.rate_code_id)
JOIN silver.taxi_zone st ON (sv.PULocationID = st.location_id)
JOIN silver.trip_type str ON (sv.trip_type = str.trip_type)
JOIN silver.payment_type sp ON (sv.payment_type = sp.payment_type )
*/


EXEC gold.sp_green_tripdata_no_time_factors '2024','01'
EXEC gold.sp_green_tripdata_no_time_factors '2024','02'
EXEC gold.sp_green_tripdata_no_time_factors '2024','03'
EXEC gold.sp_green_tripdata_no_time_factors '2024','04'
EXEC gold.sp_green_tripdata_no_time_factors '2023','01'
EXEC gold.sp_green_tripdata_no_time_factors '2023','02'
EXEC gold.sp_green_tripdata_no_time_factors '2023','03'
EXEC gold.sp_green_tripdata_no_time_factors '2023','04'
EXEC gold.sp_green_tripdata_no_time_factors '2023','05'
EXEC gold.sp_green_tripdata_no_time_factors '2023','06'
EXEC gold.sp_green_tripdata_no_time_factors '2023','07'
EXEC gold.sp_green_tripdata_no_time_factors '2023','08'
EXEC gold.sp_green_tripdata_no_time_factors '2023','09'
EXEC gold.sp_green_tripdata_no_time_factors '2023','10'
EXEC gold.sp_green_tripdata_no_time_factors '2023','11'
EXEC gold.sp_green_tripdata_no_time_factors '2023','12'