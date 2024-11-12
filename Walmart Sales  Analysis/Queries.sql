Generic Questions

-- Q1. How many distinct cities are present in the dataset?

select distinct city from walmart_sales

-- Q2.In which city is each branch situated?

select distinct branch, city from walmart_sales

Product Analysis  

-- Q1.How many distinct product lines are there in the dataset?

select count(distinct product_line)as product_count from walmart_sales

-- Q2.What is the most common payment method?

SELECT payment, count(payment) as common_payment_method from walmart_sales
group by payment
order by common_payment_method desc
limit 1

-- Q3.What is the most selling product line?

  select product_line, count(product_line) as  most_selling from walmart_sales
group by Product_line
order by most_selling desc limit 1

-- Q4.What is the total revenue by month?

select month_name, sum(total) as total_revenue from walmart_sales
group by month_name
order by total_revenue desc

-- Q5.Which month recorded the highest Cost of Goods Sold (COGS)?

select month_name, sum(cogs) as total_cogs from walmart_sales
group by month_name
order by total_cogs desc limit 1

-- Q6.Which product line generated the highest revenue?

select product_line, sum(total) as total_revenue from walmart_sales
group by Product_line
order by total_revenue desc

-- Q7.Which city has the highest revenue?

select city, sum(total) as total_revenue from walmart_sales
group by city
order by total_revenue desc

-- Q8.Which product line incurred the highest VAT?

select product_line, sum(VAT) as total_vat from walmart_sales
group by product_line
order by total_vat desc

-- 9.Retrieve each product line and add a column product_category, indicating 'Good' or 'Bad,'based on whether its sales are above the average.

ALTER TABLE sales ADD COLUMN product_category VARCHAR(20);

select 
UPDATE walmart_sales
SET product_category = 
    CASE
        WHEN total >= (SELECT AVG(total) FROM (SELECT total FROM walmart_sales) AS subquery) THEN "Good"
        ELSE "Bad"
    END;
  
select product_line, product_category
from walmart_sales

-- Q12.What is the average rating of each product line?

select product_line, round(avg(rating),2) as average_rating
from walmart_sales
group by Product_line
order by average_rating desc

Sales Analysis

--Q1.Number of sales made in each time of the day per weekday

select day_name, time_of_day, count(*) from walmart_sales
group by day_name, time_of_day having day_name not in ('sunday', 'saturday')

-- Q2.Identify the customer type that generates the highest revenue.

select customer_type, sum(total) as total_revenue from walmart_sales
group by Customer_type
order by total_revenue desc limit 1

-- Q3.Which city has the largest tax percent/ VAT (Value Added Tax)?

select city, sum(vat) as total_vat from walmart_sales
group by city
order by total_vat desc limit 1

-- 4.Which customer type pays the most in VAT?

select customer_type, sum(vat) as total_vat from walmart_sales
group by Customer_type
order by total_vat desc 


Customer Analysis

-- Q1.How many unique customer types does the data have?

select count(distinct customer_type) from walmart_sales

-- Q2.How many unique payment methods does the data have?

select count(distinct payment) from walmart_sales

-- Q3.Which is the most common customer type?

select customer_type, count(customer_type) as common_customer from walmart_sales
group by Customer_type
order by common_customer desc  limit 1

-- Q4. which customer type buys the most

select customer_type, sum(total) as total_sales from walmart_sales
group by Customer_type
order by total_sales desc limit 1

-- Q5.which is the gender of the most of the customer?

select gender, count(*) as all_genders from walmart_sales
group by gender
order by all_genders desc limit 1

-- Q6.what is the gender distribution per branch?

select branch, gender, count(gender) as gender_distribution
from walmart_sales group by Branch,Gender
order by branch

-- Q7.Which day of the week has the best average ratings per branch?

select branch, day_name, round(avg(rating),2) as average_rating
from walmart_sales
group by day_name,Branch order by average_rating descV













