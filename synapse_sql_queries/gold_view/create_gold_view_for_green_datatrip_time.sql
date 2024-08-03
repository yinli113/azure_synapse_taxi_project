USE taxi_project;
GO

-- Create view for green_tripdata 
DROP VIEW IF EXISTS gold.view_green_tripdata_time;
GO

CREATE VIEW gold.view_green_tripdata_time
AS
SELECT
    r.filepath(1) AS year,
    r.filepath(2) AS month,
    r.tip_amount,
    r.total_amount,
    r.duration_minutes,
    r.DayOfWeek,
    r.PickupTime,
    r.PickupTime_type,
    r.duration_type
FROM
    OPENROWSET(
        BULK 'gold/gold_time/year=*/month=*/*.parquet',
        DATA_SOURCE = 'green_tripdata_src',
        FORMAT = 'PARQUET'
    ) AS r;
GO

-- Test the view
SELECT TOP (100) *
FROM gold.view_green_tripdata_time;