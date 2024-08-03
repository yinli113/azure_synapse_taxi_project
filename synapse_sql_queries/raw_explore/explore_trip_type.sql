USE taxi_project;

SELECT
    TOP 10 *
FROM
    OPENROWSET(
        BULK 'trip_type.tsv',
        DATA_SOURCE ='raw_taxi_project',
        FORMAT = 'CSV',
        PARSER_VERSION = '2.0',
        HEADER_ROW = TRUE,
        FIELDTERMINATOR ='\t'
    ) AS [result]
