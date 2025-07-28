# Data Cleaning Portion

## Overview  
This file contains queries for cleaning and preparing the restaurant sales dataset for analysis. It involves the general cleaning methods such as handling duplicates, changing the appropriate data type for the columns, and dealing with missing and null values.

## Skills and Techniques Used  
- To maintain the original table, I created a staging table (restaurant_sales_data_staging) to perform all the queries.
- Modifying the data type for some of the columns (Price, Quantity, Order Date). Assigned empty values to null first before changing the type.
- Handling the duplicates by adding an extra column for row number(Row_num) and applying the window function, ROW_NUMBER().
- Managing the empty values by searching for patterns. Missing values for Price were resolved by dividing the Order Total to Quantity, while blank values for Item were handled by creating a CTE to determine rows that have the exact same value for Category and Price, and using those matching rows to infer and fill the missing Item values.
Items with two selections were ignored.

## Setup information
- Import dataset into MySQL Workbench.
- Create a new schema for the dataset and use the “Table Data Import Wizard” to import the dataset file.
- Name the table "restaurant_sales_data".
- Open the provided SQL file, review the comments in each query, and run it.

