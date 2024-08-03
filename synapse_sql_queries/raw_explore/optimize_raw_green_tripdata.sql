USE taxi_project;


SELECT
    TOP 10 *
FROM
    OPENROWSET(
        BULK 'raw_green_tripdata/green_tripdata_2023/green_tripdata_2023-01.parquet',
        FORMAT = 'PARQUET',
        DATA_SOURCE ='green_tripdata_src'
    ) AS [result]




-- Identify the interred data types
EXEC sp_describe_first_result_set N'
SELECT
    TOP 10 *
FROM
    OPENROWSET(
        BULK ''raw_green_tripdata/green_tripdata_2023/green_tripdata_2023-01.parquet'',
        FORMAT = ''PARQUET'',
        DATA_SOURCE =''green_tripdata_src''
    ) AS [result]'

-- Define Columns and data types
SELECT
    TOP 10 *
FROM
    OPENROWSET(
        BULK 'raw_green_tripdata/green_tripdata_2023/green_tripdata_2023-01.parquet',
        FORMAT = 'PARQUET',
        DATA_SOURCE ='green_tripdata_src'
    )  
    WITH (
      VendorID INT,
        lpep_pickup_datetime datetime2(7),
        lpep_dropoff_datetime datetime2(7),
        store_and_fwd_flag CHAR(1),
        RatecodeID FLOAT,
        PULocationID INT,
        DOLocationID INT,
        passenger_count FLOAT,
        trip_distance FLOAT,
        fare_amount FLOAT,
        extra FLOAT,
        mta_tax FLOAT,
        tip_amount FLOAT,
        tolls_amount FLOAT,
        ehail_fee INT,
        improvement_surcharge FLOAT,
        total_amount FLOAT,
        payment_type FLOAT,
        trip_type FLOAT,
        congestion_surcharge FLOAT
  ) AS [result]

-- metadata of 2024
EXEC sp_describe_first_result_set N'
SELECT
    TOP 10 *
FROM
    OPENROWSET(
        BULK ''raw_green_tripdata/green_tripdata_2024/green_tripdata_2024-01.parquet'',
        FORMAT = ''PARQUET'',
        DATA_SOURCE =''green_tripdata_src''
    ) AS [result]'

-- Define Columns and data types
SELECT
    TOP 10 *
FROM
    OPENROWSET(
        BULK 'raw_green_tripdata/green_tripdata_2024/green_tripdata_2024-01.parquet',
        FORMAT = 'PARQUET',
        DATA_SOURCE ='green_tripdata_src'
    )  
    WITH (
      VendorID INT,
        lpep_pickup_datetime datetime2(7),
        lpep_dropoff_datetime datetime2(7),
        store_and_fwd_flag CHAR(1),
        RatecodeID INT,
        PULocationID INT,
        DOLocationID INT,
        passenger_count INT,
        trip_distance FLOAT,
        fare_amount FLOAT,
        extra FLOAT,
        mta_tax FLOAT,
        tip_amount FLOAT,
        tolls_amount FLOAT,
        ehail_fee FLOAT,
        improvement_surcharge FLOAT,
        total_amount FLOAT,
        payment_type INT,
        trip_type INT,
        congestion_surcharge FLOAT
  ) AS [result]

        