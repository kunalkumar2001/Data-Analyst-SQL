Q1. -- Retrieve the total number of orders placed.

SELECT 
    COUNT(order_id) AS total_numbers_orders
FROM
    orders;

Q2. -- Calculate the total revenue generated from pizza sales.

SELECT 
    ROUND(SUM(orders_deatils.quantity * pizzas.price),
            2) AS total_revenue
FROM
    orders_deatils
        JOIN
    pizzas ON orders_deatils.pizza_id = pizzas.pizza_id;

Q3. -- Identify the highest-priced pizza.

SELECT 
    pizza_types.name, pizzas.price
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
ORDER BY pizzas.price DESC
LIMIT 1;

Q4. -- Identify the most common pizza size ordered.

SELECT 
    pizzas.size,
    COUNT(orders_deatils.order_details_id) AS order_count
FROM
    pizzas
        JOIN
    orders_deatils ON pizzas.pizza_id = orders_deatils.pizza_id
GROUP BY pizzas.size
ORDER BY order_count DESC
LIMIT 1;

Q5. -- List the top 5 most ordered pizza types along with their quantities.

SELECT 
    pizza_types.name, SUM(orders_deatils.quantity) AS quantities
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    orders_deatils ON pizzas.pizza_id = orders_deatils.pizza_id
GROUP BY pizza_types.name
ORDER BY quantities DESC
LIMIT 5;

Q6. -- Join the necessary tables to find the total quantity of each pizza category ordered.

SELECT 
    pizza_types.category,
    SUM(orders_deatils.quantity) AS quantity
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    orders_deatils ON pizzas.pizza_id = orders_deatils.pizza_id
GROUP BY pizza_types.category
ORDER BY quantity DESC

Q7. -- Determine the distribution of orders by hour of the day.

SELECT 
    HOUR(orders.order_time) AS hours,
    COUNT(orders.order_id) AS order_count
FROM
    orders
GROUP BY HOUR(orders.order_time);

Q8. -- Join relevant tables to find the category-wise distribution of pizzas.

select category, count(name) from pizza_types
group by category;

Q9. -- Group the orders by date and calculate the average number of pizzas ordered per day.

SELECT 
    ROUND(AVG(quantity), 0)
FROM
    (SELECT 
        orders.order_date, SUM(orders_deatils.quantity) AS quantity
    FROM
        orders
    JOIN orders_deatils ON orders.order_id = orders_deatils.order_id
    GROUP BY orders.order_date) AS order_data;

Q10. -- Determine the top 3 most ordered pizza types based on revenue.

SELECT 
    pizza_types.name,
    SUM(orders_deatils.quantity * pizzas.price) AS revenue
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    orders_deatils ON pizzas.pizza_id = orders_deatils.pizza_id
GROUP BY pizza_types.name
ORDER BY revenue DESC
LIMIT 3;

Q11. -- Calculate the percentage contribution of each pizza type to total revenue.

with category_revenue as (
	select pizza_types.category , round(sum(orders_deatils.quantity* pizzas.price),2) as revenue
	from pizza_types
	join pizzas on pizza_types.pizza_type_id = pizzas.pizza_type_id
	join orders_deatils on pizzas.pizza_id = orders_deatils.pizza_id
	group by pizza_types.category
)
select category, revenue, round((revenue/ (select sum(revenue) from category_revenue) *100),2) as percent_contribution
from category_revenue
order by revenue desc;

Q12. -- Analyze the cumulative revenue generated over time.

select order_date, sum(revenue) over(order by order_date) as cum_revenue
from
(select orders.order_date, sum(orders_deatils.quantity* pizzas.price) as revenue
from orders_deatils join pizzas
on orders_deatils.pizza_id = pizzas.pizza_id
join orders on orders_deatils.order_id = orders.order_id
group by orders.order_date) as sales

Q13. -- Determine the top 3 most ordered pizza types based on revenue for each pizza category.

select name,category,revenue
from
(select name, category, revenue,
rank() over(partition by category order by revenue desc) as  rank_pizza
from
 (select pizza_types.name, pizza_types.category, sum(orders_deatils.quantity* pizzas.price) as revenue
 from pizza_types
 join pizzas on pizza_types.pizza_type_id = pizzas. pizza_type_id
 join orders_deatils on pizzas.pizza_id = orders_deatils.pizza_id
 group by pizza_types.name, pizza_types.category) as a) as b
 where rank_pizza<=3
