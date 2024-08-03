import pandas as pd
import os

# Define the folder paths
output_folder = r'C:\Users\yin li\OneDrive\Desktop\taxi_project\cleaned_data'
silver_output_folder = r'C:\Users\yin li\OneDrive\Desktop\taxi_project\silver_green_tripdata'

# Function to add month and day of week columns
def add_date_columns(df):
    df['pickup_month'] = df['lpep_pickup_datetime'].dt.month
    df['pickup_day_of_week'] = df['lpep_pickup_datetime'].dt.day_name()
    return df

# Function to save DataFrame to Parquet file with structured path
def save_to_parquet(df, year, month, output_folder):
    month_str = f'{month:02d}'
    path = os.path.join(output_folder, f'year={year}', f'month={month_str}')
    os.makedirs(path, exist_ok=True)
    file_path = os.path.join(path, f'data_{year}_{month_str}.parquet')
    df.to_parquet(file_path)
    print(f"Saved to {file_path}")

# List all cleaned Parquet files in the output folder, filtering for year=2023
all_files = []
for year_folder in os.listdir(output_folder):
    if year_folder == 'year=2023':  # Only process files from 2023
        year_path = os.path.join(output_folder, year_folder)
        if os.path.isdir(year_path):
            for month_folder in os.listdir(year_path):
                month_path = os.path.join(year_path, month_folder)
                if os.path.isdir(month_path):
                    for file in os.listdir(month_path):
                        if file.endswith('.parquet'):
                            all_files.append(os.path.join(month_path, file))

# Read, add columns, and save each Parquet file
for file in all_files:
    df = pd.read_parquet(file)
    df_with_dates = add_date_columns(df)
    year = 2023
    month = df_with_dates['pickup_month'].iloc[0]
    save_to_parquet(df_with_dates, year, month, silver_output_folder)
