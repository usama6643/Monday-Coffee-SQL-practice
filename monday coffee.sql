-- Monday Coffee SCHEMAS

DROP TABLE IF EXISTS sales;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS city;


CREATE TABLE city
(
	city_id	INT PRIMARY KEY,
	city_name VARCHAR(15),	
	population	BIGINT,
	estimated_rent	FLOAT,
	city_rank INT
);

CREATE TABLE customers
(
	customer_id INT PRIMARY KEY,	
	customer_name VARCHAR(25),	
	city_id INT,
	CONSTRAINT fk_city FOREIGN KEY (city_id) REFERENCES city(city_id)
);


CREATE TABLE products
(
	product_id	INT PRIMARY KEY,
	product_name VARCHAR(35),	
	Price float
);


CREATE TABLE sales
(
	sale_id	INT PRIMARY KEY,
	sale_date	date,
	product_id	INT,
	customer_id	INT,
	total FLOAT,
	rating INT,
	CONSTRAINT fk_products FOREIGN KEY (product_id) REFERENCES products(product_id),
	CONSTRAINT fk_customers FOREIGN KEY (customer_id) REFERENCES customers(customer_id) 
);

--Show all customers with their city name
select c1.customer_id,c2.city_name from customers c1
join city c2
on c1.city_id = c2.city_id;

--select * from sales
--select * from customers
--select * from products
--select * from city

--Show all sales with product name
select sum(s.total),p.product_name from sales s
join products p
on s.product_id =p.product_id
group by p.product_name;

----Show all sales with product name
select s.sum(total),p.product_name from sales s
join products p
on s.product_id =p.product_id

--Find total number of customers
select count(*) from customers

--Find total number of products
select count(*) from products

--Find total sales amount
select sum(total) from sales

--Show sales made on a specific date
select * from sales
where sale_date = '2023-09-01'

--Find products with price greater than 500
select * from products
where price > 500;

--Find customers from a specific city
select * from city
where city_name = 'Pune'

--Count number of customers per city
select count(c1.customer_id) as customer_numbers,c2.city_name from customers c1
join city c2
on c1.city_id=c2.city_id
group by c2.city_name;
--Find total sales per product
select sum(s.total),p.product_name from sales s
join products p
on s.product_id =p.product_id
group by p.product_name;

--Find average rating of all sales
select avg(rating) from sales

--Show top 5 most expensive products
select * from products
order by price desc
limit 5

--Count total sales per day
select sale_date,sum(total) from sales
group by sale_date
--Show customers who gave rating 5
select c.customer_id, s.rating
from customers c
join sales s
on c.customer_id = s.customer_id
where s.rating = 5;

--Find cities with population greater than 1 million
select * from city
where population > 1000000

--Find total revenue per city
select sum(s.total),c.city_name from sales s
join customers cu on s.customer_id=cu.customer_id
join city c on cu.city_id=c.city_id
group by c.city_name

--Find top 3 selling products (based on total revenue)
select p.product_name,sum(s.total) from products p
join sales s
on p.product_id=s.product_id
group by p.product_name
order by sum(s.total) desc
limit 3

--Find customer who spent the most money
select c.customer_name,sum(s.total) from customers c
join sales s
on c.customer_id=s.customer_id
group by c.customer_name
order by sum(s.total) desc
limit 1

--Find average spending per customer
select c.customer_name,avg(s.total) from customers c
join sales s
on c.customer_id=s.customer_id
group by c.customer_name

--Find city with highest total revenue
select c.city_name,sum(s.total) from city c
join customers cs on c.city_id=cs.city_id
join sales s on cs.customer_id=s.customer_id
group by c.city_name
order by sum(s.total) desc
limit 1

--Find customers who made more than 5 purchases
select count(*),customer_id from sales
group by customer_id
having count(*) > 5;

--Find products that were never sold
select p.product_id,s.sale_id from products p
left join sales s
on p.product_id= s.product_id
where s.product_id is null;

--Find customers who never made a purchase
select c.customer_id,s.sale_id from customers c
left join sales s
on c.customer_id= s.customer_id
where s.customer_id is null;

--Find monthly total sales
SELECT 
    date_trunc('month',sale_date) as sale_month,
    SUM(total) AS total_sales
FROM sales
GROUP BY DATE_TRUNC('month', sale_date)
ORDER BY sale_month;

--Find average rating per product
select product_id,avg(rating) from sales
group by product_id

--Find best rated product (highest avg rating)
select product_id,avg(rating) from sales
group by product_id
order by avg(rating) desc
limit 1

--Find revenue contribution percentage per product
SELECT 
    product_id,
    SUM(total) AS product_revenue,
    ROUND(
        ((SUM(total) * 100.0) / SUM(SUM(total)) OVER ())::numeric,
        2
    ) AS revenue_percentage
FROM sales
GROUP BY product_id
ORDER BY revenue_percentage DESC;

--Rank products based on total sales
SELECT 
    product_id,
    SUM(total) AS total_sales
FROM sales
GROUP BY product_id
order by total_sales desc;
--
SELECT product_id,total_sales,
    DENSE_RANK() OVER(ORDER BY total_sales DESC) AS rank
FROM (
    SELECT 
        product_id,
        SUM(total) AS total_sales
    FROM sales
    GROUP BY product_id
) AS sub
ORDER BY rank;

--Find first purchase date per customer
select customer_id,min(sale_date ) from sales
group by customer_id

--Find customers whose total spending is above average spending
SELECT customer_id,total_spent
FROM (
    SELECT customer_id,
        SUM(total) AS total_spent,
        AVG(SUM(total)) OVER () AS avg_spent
    FROM sales
    GROUP BY customer_id
) t
WHERE total_spent > avg_spent
ORDER BY total_spent DESC;

--Find repeat customers (customers who purchased more than one different product)
SELECT customer_id FROM sales
GROUP BY customer_id
HAVING COUNT(DISTINCT product_id) > 1;

--Find city-wise average rating
select ci.city_name,round(avg(s.rating),2) from sales s
join customers c
on s.customer_id = c.customer_id
join city ci
on ci.city_id=c.city_id
group by ci.city_name

--Find product with highest single sale amount
select product_id, total
from sales
order by total desc
limit 1;

--Find daily average sales amount
select sale_date,avg(total) from sales
group by sale_date

--Find total number of sales per product.
select count(sale_id),product_id from sales
group by product_id

--Find customers whose name starts with 'A'.
select * from customers
where customer_name like 'A%'

--select * from sales
--select * from customers
--select * from products
--select * from city

--Find second highest priced product.
select price,product_name from
(select price,product_name,
dense_rank() over(order by price desc) as rank
from products
)t
where rank = 2

--Find cumulative (running) sales amount by date.
select sale_date,sum(total) as daily_sales,
sum(sum(total))over(order by sale_date) as running_total
from sales
group by sale_date

--Count number of customers per city
select count(c.customer_id),ci.city_name from customers c
join city ci
on c.city_id = ci.city_id
group by ci.city_name
--Find total number of sales per product
select count(sale_id),product_id from sales
group by product_id



