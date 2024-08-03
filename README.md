## NYC Taxi Fare Prediction: Building Azure Synapse Stored Procedure and Pipeline for Machine Learning

### Project Overview
#### This project aims to evaluate taxi service through the analysis of tips, zero charges, and disputed charges by providing sufficient data for machine learning predictions. The project utilizes ELT (Extract, Load, Transform) processes to extract meaningful insights from green taxi trip records.
1. Data Collection and Storage System

**Data Source**
- Year 2023 and 2024 Green:[ Taxi Trip Records: NYC Green Taxi Data](https://www.nyc.gov/site/tlc/about/tlc-trip-record-data.page)
-	Data Dictionary: [NYC Data Dictionary for Trip Records](https://www.nyc.gov/assets/tlc/downloads/pdf/data_dictionary_trip_records_green.pdf)

**Data Storage**
- Azure Data Lake Gen2 Storage (ADLS2): Used for uploading raw data and storing processed data.
- Azure Serverless SQL Pool: Used for storing pipeline data for Machine Learning and PowerBI analysis.
  
**Files in Container**
- Raw Data Files: payment_type.json, rate_code.json, taxi_zone.csv, trip_type.tsv
- Raw Green Taxi Data: green_tripdata_2023, green_tripdata_2024 (Parquet files)

2. ETL Pipeline
**Project Overview**
Create an ETL (Extract, Transform, Load) pipeline to extract data from the source, transform it according to specific rules, and load it into a target database.
-	Green Taxi Data (2023, 2024): Extract, clean, and transform using Python, then store in the structured_green_tripdata folder.
-	Raw Folder Files: Extract, transform, and load into the silver folder.
-	Further Transformation: Create external tables, views, and stored procedures for further transformation and aggregation. Load the final data into the gold folder.
-	Build Pipeline: For Machine Learning and Power BI usage.
  
3. Data Warehouse Solution
**Schema Design Strategies**
-	Denormalized Schemas: Due to the lack of primary key support in serverless SQL, a denormalized schema is chosen for green_tripdata.
-	Optimized Tables: The data warehouse tables are denormalized versions of the staging tables, optimized for data analysis, combining related tables into single, wide tables.
-	Star Schema: The green_tripdata table is linked to the unique surrogate keys of the dimension tables.
-	Surrogate Keys: Tables like rate_code, taxi_zone, trip_type, and payment_type use surrogate keys, which are ideally unique integers.
-	ETL Processes: Populate the data warehouse from staging databases without retrieving data from the main transaction database.
  
4. Best Practices for Using Serverless SQL Pools
   
**Partitioning and Indexing**
-	Partitioning: Manage large datasets efficiently by partitioning Parquet files as folder/year=*/month=*/*.parquet.
-	Indexing: Optimize data storage and access through careful partitioning, as serverless SQL pools don’t support traditional indexing.
  
**Data Preparation**
-	Pre-aggregate Data: Clean data to reduce computational load during querying.
-	Query-friendly Format: Store frequently accessed data in formats like Parquet.
  
**Materialized Views and using dynamic stored procedure to create the views**
-	Improving Performance: Create materialized views for common queries to reduce computation for repeated queries.
  
**Optimizing Data Types**
- Data Type Optimization: Check inferred data types to minimize data size and speed up processing.
-	ETL Pipeline Management: Use tools like Synapse Pipeline to manage ETL processes efficiently.

**Query Optimization**
-	Avoid Complex Joins: Optimize queries by avoiding complex joins and using filter conditions effectively.
-	CTEs and Temporary Tables: Use Common Table Expressions and temporary tables judiciously to simplify complex queries.
-	Data Type Optimization: Check inferred data types to minimize data size and speed up processing.
-	ETL Pipeline Management: Use tools like Synapse Pipeline to manage ETL processes efficiently.
  
Query Optimization
-	Avoid Complex Joins: Optimize queries by avoiding complex joins and using filter conditions effectively.
-	CTEs and Temporary Tables: Use Common Table Expressions and temporary tables judiciously to simplify complex queries.
