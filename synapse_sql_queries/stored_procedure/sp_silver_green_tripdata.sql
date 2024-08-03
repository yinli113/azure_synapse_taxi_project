USE taxi_project;
GO

CREATE OR ALTER PROCEDURE silver.green_tripdata_usp
@year VARCHAR(4),
@month VARCHAR(2)
AS
BEGIN

    DECLARE @create_sql_stmt NVARCHAR(MAX),
            @drop_sql_stmt   NVARCHAR(MAX);

    SET @create_sql_stmt = 
        'CREATE EXTERNAL TABLE silver.green_tripdata_' + @year + '_' + @month + 
        ' WITH
            (
                DATA_SOURCE = green_tripdata_src,
                LOCATION = ''silver/year=' + @year + '/month=' + @month + ''',
                FILE_FORMAT = parquet_file_format
            )
        AS
        SELECT 
        VendorID,
        lpep_pickup_datetime,
        lpep_dropoff_datetime,
        store_and_fwd_flag,
        RatecodeID,
        PULocationID,
        DOLocationID,
        passenger_count,
        trip_distance,
        fare_amount,
        extra,
        mta_tax,
        tip_amount,
        tolls_amount,
        improvement_surcharge,
        total_amount,
        payment_type,
        trip_type,
        congestion_surcharge,
        duration_minutes
        FROM silver.view_green_tripdata
        WHERE year = ''' + @year + '''
          AND month = ''' + @month + '''';    

    print(@create_sql_stmt)

    EXEC sp_executesql @create_sql_stmt;

    SET @drop_sql_stmt = 
        'DROP EXTERNAL TABLE silver.green_tripdata_' + @year + '_' + @month;

    print(@drop_sql_stmt)
    EXEC sp_executesql @drop_sql_stmt;

END;