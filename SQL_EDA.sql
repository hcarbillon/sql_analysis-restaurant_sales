-- EXPLORATORY DATA ANALYSIS

SELECT *
FROM restaurant_sales_data_staging;


-- The date range of the dataset and the total orders for each year
SELECT YEAR(`Order Date`), SUM(`Order Total`)
FROM restaurant_sales_data_staging
GROUP BY YEAR(`Order Date`)
ORDER BY 1 ASC
;



-- Ranking the most ordered item from each category across the date range
WITH ranking AS
(
SELECT Category, Item, SUM(`Order Total`) AS total_order
FROM restaurant_sales_data_staging
GROUP BY Category, Item
)
SELECT *, DENSE_RANK() OVER(PARTITION BY Category ORDER BY total_order DESC) AS Ranking
FROM ranking
WHERE Item != ''
;



# Finding the customers who have the most orders each year
WITH top_customer AS
(
SELECT `Customer ID`, YEAR(`Order Date`) AS year_order, SUM(`Order Total`) AS sum_order
FROM restaurant_sales_data_staging
GROUP BY `Customer ID`, YEAR(`Order Date`)
), ranking AS
(
SELECT *, DENSE_RANK() OVER(PARTITION BY year_order ORDER BY sum_order DESC) as ranking_customers
FROM top_customer
)
SELECT `Customer ID`, sum_order AS `Total Orders` ,year_order `Year`
FROM ranking
WHERE ranking_customers = 1
;


# Rolling total of the orders per month
WITH rolling_sum AS
(
SELECT SUBSTRING(`Order Date`,1,7) AS per_month, SUM(`Order Total`) AS sum_total
FROM restaurant_sales_data_staging
GROUP BY per_month
ORDER BY 1 ASC
)
SELECT per_month, sum_total, SUM(sum_total) OVER(ORDER BY per_month) AS rolling_total
FROM rolling_sum
;