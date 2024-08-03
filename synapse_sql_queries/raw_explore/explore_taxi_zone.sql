CREATE DATABASE taxi_project;
USE taxi_project;
ALTER DATABASE taxi_project COLLATE latin1_General_100_CI_AI_SC_UTF8;

SELECT
    TOP 10 *
FROM
    OPENROWSET(
        BULK 'abfss://taxicontainer@taxidatalake.dfs.core.windows.net/raw/taxi_zone.csv',
        FORMAT = 'CSV',
        PARSER_VERSION = '2.0',
        HEADER_ROW = TRUE,
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '\n'
    ) AS [result]

-- examine the data types for the columns
EXEC sp_describe_first_result_set N'SELECT
   TOP 10 *
FROM
    OPENROWSET(
        BULK ''abfss://taxicontainer@taxidatalake.dfs.core.windows.net/raw/taxi_zone.csv'',
        FORMAT = ''CSV'',
        PARSER_VERSION = ''2.0'',
        HEADER_ROW = TRUE
    ) AS [result]' 

-- Check the real length of the selected columns
SELECT
    MAX(LEN(locationID)) AS len_locationid,
    MAX(LEN(Borough)) AS len_borough,
    MAX(LEN(Zone)) AS len_zone,
    MAX(LEN(service_zone)) AS len_service_zone
FROM
    OPENROWSET(
        BULK 'abfss://taxicontainer@taxidatalake.dfs.core.windows.net/raw/taxi_zone.csv',
        FORMAT = 'CSV',
        PARSER_VERSION = '2.0',
        HEADER_ROW = TRUE
    ) AS [result]

--use WITH clause to provide explicit data types
SELECT
    TOP 10 *
FROM
    OPENROWSET(
        BULK 'abfss://taxicontainer@taxidatalake.dfs.core.windows.net/raw/taxi_zone.csv',
        FORMAT = 'CSV',
        PARSER_VERSION = '2.0',
        HEADER_ROW = TRUE
    ) 
    WITH (
        LocationID SMALLINT,
        Borough VARCHAR(15),
        Zone    VARCHAR(50),
        service_zone VARCHAR(15)
    ) AS [result]

-- change column names
SELECT
    TOP 10 *
FROM
    OPENROWSET(
        BULK 'abfss://taxicontainer@taxidatalake.dfs.core.windows.net/raw/taxi_zone.csv',
        FORMAT = 'CSV',
        PARSER_VERSION = '2.0',
        HEADER_ROW = TRUE
    ) 
    WITH (
        location_id SMALLINT 1,
        borough VARCHAR(15) 2,
        zone    VARCHAR(50) 3,
        service_zone VARCHAR(15) 4
    ) AS [result]

-- Create external data source
CREATE EXTERNAL DATA SOURCE raw_taxi_project
WITH(
    LOCATION = 'abfss://taxicontainer@taxidatalake.dfs.core.windows.net/raw'
)

SELECT
    TOP 10 *
FROM
    OPENROWSET(
        BULK 'taxi_zone.csv',
        DATA_SOURCE ='raw_taxi_project',
        FORMAT = 'CSV',
        PARSER_VERSION = '2.0',
        HEADER_ROW = TRUE
    ) 
    WITH (
        location_id SMALLINT 1,
        borough VARCHAR(15) 2,
        zone    VARCHAR(50) 3,
        service_zone VARCHAR(15) 4
    ) AS [result]