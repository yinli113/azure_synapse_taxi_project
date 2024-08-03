USE taxi_project;

SELECT TOP 10
    CAST(JSON_VALUE (jsonDoc, '$.payment_type') AS SMALLINT) payment_type,
    CAST(JSON_VALUE (jsonDoc, '$.payment_type_desc') AS VARCHAR(15)) payment_type_desc
FROM
    OPENROWSET(
        BULK 'payment_type.json',
        DATA_SOURCE ='raw_taxi_project',
        FORMAT = 'CSV',
        PARSER_VERSION = '1.0',
        FIELDQUOTE = '0x0b',
        FIELDTERMINATOR ='0x0b',
        ROWTERMINATOR = '0x0a'
    )
    WITH (
        jsonDoc Nvarchar(MAX)
    ) AS [result]


EXEC sp_describe_first_result_set N'SELECT
    TOP 10
    CAST(JSON_VALUE (jsonDoc, ''$.payment_type'') AS SMALLINT) payment_type,
    CAST(JSON_VALUE (jsonDoc, ''$.payment_type_desc'') AS VARCHAR(15)) payment_type_desc
FROM
    OPENROWSET(
        BULK ''payment_type.json'',
        DATA_SOURCE =''raw_taxi_project'',
        FORMAT = ''CSV'',
        PARSER_VERSION = ''1.0'',
        FIELDQUOTE = ''0x0b'',
        FIELDTERMINATOR =''0x0b'',
        ROWTERMINATOR = ''0x0a''
    )
    WITH (
        jsonDoc Nvarchar(MAX)
    ) AS [result]'