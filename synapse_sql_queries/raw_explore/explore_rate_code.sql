USE taxi_project;

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
  );
