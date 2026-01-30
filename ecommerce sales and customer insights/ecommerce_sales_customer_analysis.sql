Create database ecommerce_sales
use ecommerce_sales


select * from sales

--Total revenue per customer
select Customer_Name, sum(Sales) as total_revenue from sales 
group by customer_Name

---Top 5 customers by Revenue  (Window Function

select Customer_Name, total_revenue 
from (
select Customer_Name, sum(Sales) as total_revenue, rank() over (order by sum(Sales) desc) as rnk from Sales
group by Customer_Name) t
where rnk <=5

--Monthly sales Trend

select month(order_date) as month, sum(Sales) as monthly_sales from Sales
group by month(order_date)
order by month(order_date)

---Most Popular Product_Category

select top 1 Category,Sub_Category , sum(Quantity) as total_qty from sales
group by Category, Sub_Category 
order by total_qty desc


---Repeat customers

select Customer_Name, count(order_id) as total_orders from Sales
group by Customer_Name
having count(order_id) > 1
order by count(order_id) desc

--- Revenue contribution by category (CTE)
select Category, total_revenue , round(100 * total_revenue / sum(total_revenue) over(),2) as revenue_percentage
from (
select Category, sum(sales) as total_revenue from sales
group by Category) t

---Order classification using CASE
select order_id, 
case 
when sum(sales) >10000 then 'High Value'
when sum(sales) between 5000 and 10000 then 'Medium Value'
else 'Low Value' 
end as order_type
from sales
group by order_id
order by order_type


