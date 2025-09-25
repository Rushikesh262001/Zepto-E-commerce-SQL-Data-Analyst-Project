drop table  if exists zepto;

create table zepto(
sku_id serial primary key,
category varchar (120),
name varchar (150) not null,
mrp numeric (8,2),
discountPercent numeric (5,2),
availableQuantity int,
discountedSellingPrice numeric (8,2),
weightInGms int,
outOfStock boolean,
quantity int 
);

ALTER TABLE zepto_v1
DROP COLUMN sku_id;

ALTER TABLE zepto_v1
ADD COLUMN sku_id serial primary key FIRST;

--count of rows
select count(*) from zepto_v1;

--sample data
select * from zepto_v1
limit 20;

/*null values*/
select * from zepto_v1
where name is null
or
category is null
or
mrp is null
or
discountPercent is null
or
availableQuantity is null
or
discountedSellingPrice is null
or
weightInGms is null
or
outOfStock is null
or
quantity is null;

ALTER TABLE zepto_v1
RENAME COLUMN ï»¿Category TO category;

--different product category

select distinct category
from zepto_v1
order by category;

--product in stock v/s out of stock

select outOfStock,count(sku_id) 
from zepto_v1
group by outOfStock;

--product name present multiple times
select name, count(sku_id) as "Number_of_sku's"
from zepto_v1
group by name
having count(sku_id) > 1
order by count(sku_id) desc;

/*data cleaning

product with mrp = 0*/
select * from zepto_v1
where mrp = 0 or discountedSellingPrice = 0;

delete from zepto_v1
where sku_id = 3653;

--convert  paise ti rupees

update zepto_v1
set mrp = mrp/100.0,
discountedSellingPrice = discountedSellingPrice / 100.0;

SET SQL_SAFE_UPDATES = 0;
select mrp, discountedSellingPrice from zepto_v1;

--Q1. Find the top 10 best-value products based on the discount percentage.

select distinct name,mrp,discountPercent
from zepto_v1
order by discountPercent desc
limit 10;

--Q2.What are the Products with High MRP but Out of Stock

select distinct name,mrp
from zepto_v1
where outOfStock = 'True' and mrp > 300
order by mrp desc;

--Q3.Calculate Estimated Revenue for each category
select category,sum(discountedSellingPrice * availableQuantity) as total_revenue
from zepto_v1
group by category
order by total_revenue;

-- Q4. Find all products where MRP is greater than ₹500 and discount is less than 10%.
select distinct name,mrp,discountPercent
from zepto_v1
where mrp > 500 and discountPercent < 10
order by mrp desc,discountPercent desc;

select discountPercent
from zepto_v1;


-- Q5. Identify the top 5 categories offering the highest average discount percentage.
select category,
round(avg(discountPercent),2) as avg_discount_percent
from zepto_v1
group by category
order by avg_discount_percent desc
limit 5;

-- Q6. Find the price per gram for products above 100g and sort by best value.
select distinct name,
mrp,
weightInGms,
discountedSellingPrice,
round((discountedSellingPrice / weightInGms),2) as price_per_gram
from zepto_v1
where weightInGms >= 100
order by price_per_gram;

--Q7.Group the products into categories like Low, Medium, Bulk.
select distinct name,weightInGms,
case when weightInGms < 1000 then 'Low'
     when weightInGms < 5000 then 'Medium'
     else 'Bulk'
end as 'weight_categories'
from zepto_v1;
--Q8.What is the Total Inventory Weight Per Category 
select category,sum(weightInGms * availableQuantity) as total_inventory
from zepto_v1
group by category
order by total_inventory desc;