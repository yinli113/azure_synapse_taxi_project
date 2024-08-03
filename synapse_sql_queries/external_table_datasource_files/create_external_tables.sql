USE taxi_project;

-- Create taxi_zone table
IF OBJECT_ID('bronze.taxi_zone') IS NOT NULL
    DROP EXTERNAL TABLE bronze.taxi_zone;

CREATE EXTERNAL TABLE bronze.taxi_zone
    (   location_id SMALLINT ,
        borough VARCHAR(15) ,
        zone VARCHAR(50) ,
        service_zone VARCHAR(15) )  
    WITH (
            LOCATION = 'taxi_zone.csv',  
            DATA_SOURCE = raw_taxi_project,  
            FILE_FORMAT = csv_file_format_version1,
            REJECT_VALUE = 10,
            REJECTED_ROW_LOCATION = 'rejections/taxi_zone'
    );


-- Create vendor table
IF OBJECT_ID('bronze.vendor') IS NOT NULL
    DROP EXTERNAL TABLE bronze.vendor;

CREATE EXTERNAL TABLE bronze.vendor
    (
        vendor_id       TINYINT,
        vendor_name     VARCHAR(50)
    )  
    WITH (
            LOCATION = 'vendor.csv',  
            DATA_SOURCE = raw_taxi_project,  
            FILE_FORMAT = csv_file_format_version1,
            REJECT_VALUE = 10,
            REJECTED_ROW_LOCATION = 'rejections/vendor'
    );
SELECT TOP 10* FROM bronze.vendor;

-- Create trip_type table
IF OBJECT_ID('bronze.trip_type') IS NOT NULL
    DROP EXTERNAL TABLE bronze.trip_type;

CREATE EXTERNAL TABLE bronze.trip_type
    (
        trip_type       TINYINT,
        trip_type_desc  VARCHAR(50)
    )  
    WITH (
            LOCATION = 'trip_type.tsv',  
            DATA_SOURCE = raw_taxi_project,
            FILE_FORMAT = tsv_file_format_version1,
            REJECT_VALUE = 10,
            REJECTED_ROW_LOCATION = 'rejections/trip_type'
    );

SELECT TOP 10* FROM bronze.trip_type;