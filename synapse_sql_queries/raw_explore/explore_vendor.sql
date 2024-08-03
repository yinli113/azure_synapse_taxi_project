USE taxi_project;

SELECT
    *
FROM
    OPENROWSET(
        BULK 'vendor.csv',
        DATA_SOURCE ='raw_taxi_project',
        FORMAT = 'CSV',
        PARSER_VERSION = '2.0',
        HEADER_ROW = TRUE,
        FIELDQUOTE = '"'
    )  AS [result]