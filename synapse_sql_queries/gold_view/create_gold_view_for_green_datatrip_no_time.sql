USE taxi_project;
GO

-- Create view for green_tripdata 
DROP VIEW IF EXISTS gold.view_green_tripdata_no_time;
GO

CREATE VIEW gold.view_green_tripdata_no_time
AS
SELECT
    result.filepath(1) AS year,
    result.filepath(2) AS month,
    result.rate_code,
    result.borough,
    result.passenger_count,
    result.trip_distance,
    result.tip_amount,
    result.total_amount,
    result.trip_type_desc,
    result.description,
    result.congestion_surcharge
FROM
    OPENROWSET(
        BULK 'gold/gold_no_time/year=*/month=*/*.parquet',
        DATA_SOURCE = 'green_tripdata_src',
        FORMAT = 'PARQUET'
    ) AS result;
GO

-- Test the view
SELECT TOP (100) *
FROM gold.view_green_tripdata_no_time;