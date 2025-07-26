-- DATA CLEANING

-- Checking the original dataset

SELECT *
FROM restaurant_sales_data
;

-- Creating a staging table to perform queries

CREATE TABLE restaurant_sales_data_staging
LIKE restaurant_sales_data
;

SELECT *
FROM restaurant_sales_data_staging;

INSERT INTO restaurant_sales_data_staging
SELECT *
FROM restaurant_sales_data
;

SELECT *
FROM restaurant_sales_data_staging;




-- Assigning the appropriate data type for some of the columns

# Assigning the empty values of the Price column to null first
UPDATE restaurant_sales_data_staging
SET Price = NULL
WHERE Price = ''
;

ALTER TABLE restaurant_sales_data_staging
MODIFY COLUMN Price DOUBLE;

# Changing the data type of Quantity to INT
ALTER TABLE restaurant_sales_data_staging
MODIFY COLUMN Quantity INT
;

ALTER TABLE restaurant_sales_data_staging
MODIFY COLUMN `Order Date` DATE
;



-- Checking for duplicates

CREATE TABLE `restaurant_sales_data_staging2` (
  `Order ID` text,
  `Customer ID` text,
  `Category` text,
  `Item` text,
  `Price` double DEFAULT NULL,
  `Quantity` int DEFAULT NULL,
  `Order Total` double DEFAULT NULL,
  `Order Date` date DEFAULT NULL,
  `Payment Method` text,
  `Row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT *
FROM restaurant_sales_data_staging2;

INSERT INTO restaurant_sales_data_staging2
SELECT *,
ROW_NUMBER() OVER(PARTITION BY `Order ID`, `Customer ID`, Category, Item, Price, Quantity, `Order Total`, `Order Date`, `Payment Method`) AS Row_num
FROM restaurant_sales_data_staging
;

SELECT *
FROM restaurant_sales_data_staging2
WHERE Row_num > 1
;

# No duplicates
# Continue using restaurant_sales_data_staging for the next queries




-- Handling missing values
SELECT *
FROM restaurant_sales_data_staging
;


-- Handling the nulls in the Price column by dividing the value from the Order Total to Quantity

SELECT *
FROM restaurant_sales_data_staging
WHERE Price IS NULL
;

UPDATE restaurant_sales_data_staging
SET Price = `Order Total` / Quantity
WHERE Price IS NULL;

SELECT *
FROM restaurant_sales_data_staging;



# Checking if the combination of category and price produces only 1 option for the item value
SELECT *
FROM restaurant_sales_data_staging
WHERE `Category` = 'Desserts' AND
`Price` = '4'
;
#The query above has exactly one value for Item (Fruit salad)


SELECT *
FROM restaurant_sales_data_staging
WHERE `Category` = 'Desserts' AND
`Price` = '6'
;
#However, this query produces 2 values for the Item (Brownie or Chocolate Cake)


#Listing down all combinations of category and price that have a missing Item value
SELECT DISTINCT Category, Price
FROM restaurant_sales_data_staging
WHERE Item = '' AND
(Category != '' OR Category IS NOT NULL) AND
Price IS NOT NULL
ORDER BY 1
;

# Creating a CTE to filter down the combination of Category and Price that contains only one value
# and populating the Item column with its corresponding value
WITH corresponding_item AS
(
SELECT Category, Price, MAX(Item) AS Item
FROM restaurant_sales_data_staging
WHERE Item != ''
GROUP BY Category, Price
HAVING COUNT(DISTINCT Item) = 1
)
UPDATE restaurant_sales_data_staging AS r_data
JOIN corresponding_item AS corr
	ON r_data.Category = corr.Category AND r_data.Price = corr.Price
SET r_data.Item = corr.Item
WHERE r_data.Item = ''
;

SELECT *
FROM restaurant_sales_data_staging
;


# Items that contains 2 options based on the combination of Category and Price were not filled in with data as it is too ambiguous


# Checking if the Order Total are calculated correctly based on the Price and Quantity
SELECT COUNT(`Order Total`)
FROM restaurant_sales_data_staging
WHERE `Order Total` != Price * Quantity
;



# Decided to not clean the missing values for the Payment Method, as they were too ambiguous
# A customer might use two method of payments on the same day


# Checking the dataset after all the cleaning
SELECT *
FROM restaurant_sales_data_staging
;