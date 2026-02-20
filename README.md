# Monday-Coffee-SQL-practice
This repository contains SQL practice queries for **internship and associate level data analyst preparation**.   The dataset includes the following tables:  - **city**: City details including population, rent, and rank - **customers**: Customer information linked to cities - **products**: Product details with price -
## Objectives

- Practice basic SQL queries (SELECT, WHERE, GROUP BY, HAVING)
- Practice joins and multi-table queries
- Calculate basic aggregations (SUM, AVG, COUNT)
- Identify top products, customers, and revenue per city
- Practice “never purchased” or “never sold” queries
- String filtering using `LIKE`

## Tables Schema

```sql
-- City Table
city(city_id INT PRIMARY KEY, city_name VARCHAR(15), population BIGINT, estimated_rent FLOAT, city_rank INT)

-- Customers Table
customers(customer_id INT PRIMARY KEY, customer_name VARCHAR(25), city_id INT REFERENCES city(city_id))

-- Products Table
products(product_id INT PRIMARY KEY, product_name VARCHAR(35), price FLOAT)

-- Sales Table
sales(sale_id INT PRIMARY KEY, sale_date DATE, product_id INT REFERENCES products(product_id), customer_id INT REFERENCES customers(customer_id), total FLOAT, rating INT)
