# Exploratory Data Analysis on Restaurant Sales

## Introduction
The goal of this EDA is to provide insights into the restaurant’s sales performance, essential patterns, and identify factors that can enhance its productivity. The dataset was obtained from Kaggle, which composed of 17,534 transactions. Analyzing the data will help predict future sales trends and boost customer satisfaction.  

## Objectives
This file contains queries that identify the most popular menu item across various categories and rank them based on the frequency of orders. It also features the top customers and total orders for each year. Additionally, it provides the rolling total of orders by month. 

## Skills and Techniques Used
- Aggregations were used to find the sum of total orders.
- Common Table Expressions (CTEs) combined with the window function DENSE_RANK() were applied to provide a ranking system for items within each category and to determine the top customers for each year.
-  For the rolling total of orders per month, a CTE was used, accompanied by the SUM() OVER() window function to calculate the cumulative sum over a window of rows.

## Setup information
- Open the SQL file in the same schema and table(must be named "restaurant_sales_data") where the restaurant sales Excel data was imported.
- Read the comments in the file and execute the queries.


