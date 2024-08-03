USE taxi_project;

-- check taxi_zone
SELECT 
    location_id,
    COUNT(DISTINCT location_id) AS number_of_location_id
FROM
    OPENROWSET(
        BULK 'taxi_zone.csv',
        DATA_SOURCE ='raw_taxi_project',
        FORMAT = 'CSV',
        PARSER_VERSION = '2.0',
        HEADER_ROW = TRUE
    ) 
    WITH (
        location_id SMALLINT,
        borough VARCHAR(15),
        zone    VARCHAR(50),
        service_zone VARCHAR(15)
    ) AS [result]
GROUP BY location_id
HAVING COUNT(DISTINCT location_id) > 1;