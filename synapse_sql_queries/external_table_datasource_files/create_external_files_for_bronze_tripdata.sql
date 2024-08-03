USE taxi_project;


-- Create trip_data_green_parquet table
IF OBJECT_ID('bronze.green_tripdata') IS NOT NULL
    DROP EXTERNAL TABLE bronze.green_tripdata;

-- Create external table  
CREATE EXTERNAL TABLE bronze.green_tripdata
 (
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
    improvement_surcharge FLOAT,
    total_amount FLOAT,
    payment_type FLOAT,
    trip_type FLOAT,
    congestion_surcharge FLOAT,
    duration_minutes FLOAT
)
WITH (
    LOCATION = 'structured_green_tripdata/year=*/month=*/*.parquet',
    DATA_SOURCE = green_tripdata_src,
    FILE_FORMAT = parquet_file_format
);


SELECT TOP(10) * FROM bronze.green_tripdata;