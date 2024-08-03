USE taxi_project;
GO

-- Create view for green_tripdata 
DROP VIEW IF EXISTS silver.view_green_tripdata;
GO

CREATE VIEW silver.view_green_tripdata
AS
SELECT
    result.filepath(1) AS year,
    result.filepath(2) AS month,
    result.*
FROM
    OPENROWSET(
        BULK 'structured_green_tripdata/year=*/month=*/*.parquet',
        DATA_SOURCE = 'green_tripdata_src',
        FORMAT = 'PARQUET'
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
        improvement_surcharge FLOAT,
        total_amount FLOAT,
        payment_type FLOAT,
        trip_type FLOAT,
        congestion_surcharge FLOAT,
        duration_minutes FLOAT
    ) AS result;
GO

SELECT TOP (100) *
FROM silver.view_green_tripdata;
