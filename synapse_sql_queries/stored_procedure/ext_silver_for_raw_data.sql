USE taxi_project;

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

USE taxi_project;

IF OBJECT_ID('silver.payment_type') IS NOT NULL
    DROP EXTERNAL TABLE silver.payment_type
GO

CREATE EXTERNAL TABLE silver.payment_type
    WITH
    (
        DATA_SOURCE = silver_raw_taxi_project,
        LOCATION = 'payment_type',
        FILE_FORMAT = parquet_file_format
    )
AS
SELECT payment_type, description
  FROM OPENROWSET(
      BULK 'payment_type.json',
      DATA_SOURCE = 'raw_taxi_project',
      FORMAT = 'CSV',
      FIELDTERMINATOR = '0x0b',
      FIELDQUOTE = '0x0b'
  )
  WITH
  (
      jsonDoc NVARCHAR(MAX)
  ) AS payment_type
  CROSS APPLY OPENJSON(jsonDoc)
  WITH(
      payment_type SMALLINT,
      description VARCHAR(20) '$.payment_type_desc'
  );
  
USE taxi_project;

--- tranforming rate_code in bronze layer from csv to parquet and saving to silver layer
IF OBJECT_ID('silver.rate_code') IS NOT NULL
    DROP EXTERNAL TABLE silver.rate_code

CREATE EXTERNAL TABLE silver.rate_code
    WITH
    (
        DATA_SOURCE = silver_raw_taxi_project,
        LOCATION = 'rate_code',
        FILE_FORMAT = parquet_file_format
    )
AS
SELECT rate_code_id, rate_code
  FROM OPENROWSET(
      BULK 'rate_code.json',
      DATA_SOURCE = 'raw_taxi_project',
      FORMAT = 'CSV',
      FIELDTERMINATOR = '0x0b',
      FIELDQUOTE = '0x0b',
      ROWTERMINATOR = '0x0b'
  )
  WITH
  (
      jsonDoc NVARCHAR(MAX)
  ) AS rate_code
  CROSS APPLY OPENJSON(jsonDoc)
  WITH(
      rate_code_id TINYINT,
      rate_code VARCHAR(20) 
  )
  
USE taxi_project;

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


-- tranforming rate_code in bronze layer from csv to parquet and saving to silver layer
IF OBJECT_ID('silver.taxi_zone') IS NOT NULL
    DROP EXTERNAL TABLE silver.taxi_zone

CREATE EXTERNAL TABLE silver.taxi_zone
    WITH
    (
        DATA_SOURCE = silver_raw_taxi_project,
        LOCATION = 'taxi_zone',
        FILE_FORMAT = parquet_file_format
    )
AS
    SELECT *
    FROM
        bronze.taxi_zone
        
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


--- tranforming rate_code in bronze layer from csv to parquet and saving to silver layer
IF OBJECT_ID('silver.trip_type') IS NOT NULL
    DROP EXTERNAL TABLE silver.trip_type

CREATE EXTERNAL TABLE silver.trip_type
    WITH
    (
        DATA_SOURCE = silver_raw_taxi_project,
        LOCATION = 'trip_type',
        FILE_FORMAT = parquet_file_format
    )
AS
    SELECT *
    FROM
        bronze.trip_type

        