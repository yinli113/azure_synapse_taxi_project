USE taxi_project;

-- DROP EXTERNAL DATA SOURCE ;

IF NOT EXISTS (SELECT * FROM sys.external_data_sources WHERE name = 'green_tripdata_src')
    CREATE EXTERNAL DATA SOURCE green_tripdata_src
    WITH
    (    LOCATION         = 'https://taxidatalake.blob.core.windows.net/taxicontainer'
    );
    
USE taxi_project;

-- DROP EXTERNAL DATA SOURCE ;

IF NOT EXISTS (SELECT * FROM sys.external_data_sources WHERE name = 'raw_taxi_project')
    CREATE EXTERNAL DATA SOURCE raw_taxi_project
    WITH(
        LOCATION = 'abfss://taxicontainer@taxidatalake.dfs.core.windows.net/raw'
    )
    
USE taxi_project;

-- DROP EXTERNAL DATA SOURCE ;

IF NOT EXISTS (SELECT * FROM sys.external_data_sources WHERE name = 'silver_raw_taxi_project')
    CREATE EXTERNAL DATA SOURCE silver_raw_taxi_project
    WITH(
        LOCATION = 'abfss://taxicontainer@taxidatalake.dfs.core.windows.net/silver'
    )
    
