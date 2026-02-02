CREATE DATABASE DVA_ASSESSMENT

USE DVA_ASSESSMENT

SELECT * from Sales_Shipment_Data

select * from Inventory_Stock_Data

---DATA AUDIT 
--Q1 Calculate Number of rows of Sales_Shipment_Data and Inventory_Stock_Data

select count(*)[Number of rows] from Sales_Shipment_Data

select count(*)[Number of rows] from Inventory_Stock_Data

---Q2 Calculate Number of columns of Sales_Shipment_Data and Inventory_Stock_Data

SELECT COUNT(*) [Number of columns]
  FROM INFORMATION_SCHEMA.COLUMNS
  WHERE table_catalog = 'DVA_ASSESSMENT' 
   AND table_name = 'Sales_Shipment_Data'

SELECT COUNT(*) [Number of columns]
  FROM INFORMATION_SCHEMA.COLUMNS
  WHERE table_catalog = 'DVA_ASSESSMENT' 
   AND table_name = 'Inventory_Stock_Data'

   ---Q3 calculate numerical number of columns of Sales_Shipment_Data and Inventory_Stock_Data

  SELECT COUNT(*) [Number of Numerical columns]
  FROM INFORMATION_SCHEMA.COLUMNS
  WHERE table_catalog = 'DVA_ASSESSMENT' 
  AND table_name = 'Sales_Shipment_Data'
  and DATA_TYPE = 'tinyint' or DATA_TYPE = 'int' or DATA_TYPE = 'smallint' or DATA_TYPE = 'float' 

  SELECT COUNT(*) [Number of Numerical columns]
  FROM INFORMATION_SCHEMA.COLUMNS
  WHERE table_catalog = 'DVA_ASSESSMENT' 
  AND table_name = 'Inventory_Stock_Data'
  and DATA_TYPE = 'tinyint'  or DATA_TYPE = 'bit' 


  ---Q4 calculate categorical number of columns of Sales_Shipment_Data and Inventory_Stock_Data

   SELECT COUNT(*) [Number of categorical columns]
  FROM INFORMATION_SCHEMA.COLUMNS
  WHERE table_catalog = 'DVA_ASSESSMENT' 
   AND table_name = 'Sales_Shipment_Data'
   and DATA_TYPE = 'nvarchar'

    SELECT COUNT(*) [Number of categorical columns]
  FROM INFORMATION_SCHEMA.COLUMNS
  WHERE table_catalog = 'DVA_ASSESSMENT' 
   AND table_name = 'Inventory_Stock_Data'
   and DATA_TYPE = 'nvarchar'

   ---List of analysis

   ---1.a) Q1.a) Calculate Total sale value

select sum(sales)[Total sales] from Sales_Shipment_Data

---Q1.b) Calculate Total sale unit

select sum(Order_Item_Quantity)[Total sale unit] from Sales_Shipment_Data

---Q1.c) Calculate Inventory value

select sum(Product_Price) [Inventory value] from Sales_Shipment_Data

---Q1.d) Calculate Inventory quantity

select sum(current_stock)[Inventory quantity] from Inventory_Stock_Data

---Q1.e) Calculate profit value

select sum(Order_Profit_Per_Order)[Profit value] from Sales_Shipment_Data

---Q1.f) Calculate number of distinct products

select  count(distinct product_name)[Number of distinct products] from Inventory_Stock_Data

---Q1.g) Calculate number of distinct categories

select count(distinct Category_Name)[number of distinct categories] from Sales_Shipment_Data

---Q2. Status of orders

select Order_Status,count(Order_Id)[Number of Orders] from Sales_Shipment_Data
group by Order_Status

---Q3.Status of Delivery of orders

select Delivery_Status,count(Order_Id)[Number of Orders] from Sales_Shipment_Data
group by Delivery_Status

---Q4. Late delivery risk by time

select T.Month,T.Quarter,T.Week,T.Year,COUNT(T.Order_Id)[Late delivery risk]  from
(select Last_Delivery_Risk,Order_Id, DATEPART(WEEK,shipping_date_DateOrders)[Week],DATENAME(MONTH,shipping_date_DateOrders)[Month], 
datepart(QUARTER,shipping_date_DateOrders)[Quarter],DATEPART(YEAR,shipping_date_DateOrders)[Year]
from Sales_Shipment_Data) T
where Last_Delivery_Risk = 'Late'
group by T.Month,T.Quarter,T.Week,T.Year
order by T.Month,T.Quarter,T.Week,T.Year

--Another Method

select T.Month ,T.Quarter,T.Week ,T.Year,COUNT(Order_id)[Late_delivery_risk] from
(select case when Days_for_shipment_scheduled < Days_for_shipping_real then 'Late'
			when Days_for_shipment_scheduled > Days_for_shipping_real then 'NotLate'
			end [Late_delivery_risk],DATEPART(month,shipping_date_DateOrders)[Month],DATEPART(Quarter,shipping_date_DateOrders)[Quarter],
			DATEPART(year,shipping_date_DateOrders)[Year],DATEPART(week,shipping_date_DateOrders)[Week],Order_Id from Sales_Shipment_Data) T
where Late_delivery_risk = 'Late'
group by T.Month ,T.Quarter,T.Week ,T.Year


---Q5. Order item qty by time

select Count(O.Order_Item_Quantity) [Order item quantity],O.Week,O.Month,O.Quarter,O.Year from
(select Order_Item_Quantity,DATEPART(WEEK,order_date_DateOrders)[Week],DATENAME(mm,order_date_DateOrders)[Month], 
datepart(qq,order_date_DateOrders)[Quarter],DATEPART(YYYY,order_date_DateOrders)[Year]
from Sales_Shipment_Data) O
group by O.Week,O.Month,O.Quarter,O.Year
order by O.Week,O.Month,O.Quarter,O.Year

---Q6. Sales units/value by time

select sum(S.Sales)[Sales Units],S.Week,S.Month,S.Quarter,S.Year from
(select sales,Order_Item_Quantity, DATEPART(WEEK,order_date_DateOrders)[Week],DATENAME(mm,order_date_DateOrders)[Month], 
datepart(qq,order_date_DateOrders)[Quarter],DATEPART(YYYY,order_date_DateOrders)[Year]
from Sales_Shipment_Data) S
group by S.Week,S.Month,S.Quarter,S.Year 
order by S.Week,S.Month,S.Quarter,S.Year 

---Q7. Profit orders/value by time

select SUM(P.Order_Profit_Per_Order)[Profit orders],P.Week,P.Month,P.Quarter,P.Year  from
(select Order_Profit_Per_Order, DATEPART(WEEK,order_date_DateOrders)[Week],DATENAME(mm,order_date_DateOrders)[Month], 
datepart(qq,order_date_DateOrders)[Quarter],DATEPART(YYYY,order_date_DateOrders)[Year]
from Sales_Shipment_Data) P
group by P.Week,P.Month,P.Quarter,P.Year  
order by P.Week,P.Month,P.Quarter,P.Year

---Q8. Order profit per order by time

select count(P.Order_Profit_Per_Order)[Order Profit per order],P.Week,P.Month,P.Quarter,P.Year  from
(select Order_Profit_Per_Order, DATEPART(WEEK,order_date_DateOrders)[Week],DATENAME(mm,order_date_DateOrders)[Month], 
datepart(qq,order_date_DateOrders)[Quarter],DATEPART(YYYY,order_date_DateOrders)[Year]
from Sales_Shipment_Data) P
group by P.Week,P.Month,P.Quarter,P.Year  
order by P.Week,P.Month,P.Quarter,P.Year 


---Q9. Order count by country/state/by time

select COUNT(O.Order_Id)[Order count],O.Order_Country[Country],O.Order_State[State],O.Week,O.Month,O.Quarter,O.Year
from
(select Order_Id,Order_Country,Order_State, DATEPART(WEEK,order_date_DateOrders)[Week],DATENAME(mm,order_date_DateOrders)[Month], 
datepart(qq,order_date_DateOrders)[Quarter],DATEPART(YYYY,order_date_DateOrders)[Year]
from Sales_Shipment_Data) O
group by O.Order_Country,O.Order_State,O.Week,O.Month,O.Quarter,O.Year
order by O.Order_Country,O.Order_State,O.Week,O.Month,O.Quarter,O.Year

---Q10. Inventory Units by each class or cluster

select S.Class,sum(distinct current_stock)[current_stock] 
from Sales_Shipment_Data S left join Inventory_Stock_Data I on S.Product_Id = I.product_id
group by S.Class


---Q11. Inventory value by each class or cluster

select Class,sum(Product_Price)[Inventory value] from Sales_Shipment_Data
group by Class

---Q12. Inventory by class

select S.Class,sum(distinct current_stock)[Inventory] 
from Sales_Shipment_Data S left join Inventory_Stock_Data I on S.Product_Id = I.product_id
group by S.Class

---Q13. Detail stock action

select S.product_name,S.order_now,S.[order_now status],sum(S.current_stock)[Inventory Unit] from
(select order_now,
case when order_now = 'green' then 'Products not required to ordered'
    when order_now = 'orange' then 'Products to be ordered'	
end [order_now status],product_name,current_stock
from  Inventory_Stock_Data ) S
group by S.product_name,S.order_now,S.[order_now status]
order by S.order_now desc


---Q14. Product order qty trend by time

select P.Product_Name,P.Week,P.Month,P.Quarter,P.Year,SUM(P.Order_Item_Quantity)[Order Item Qty]  from
(select Product_Name,Order_Item_Quantity, DATENAME(DW,order_date_DateOrders)[Week],DATENAME(mm,order_date_DateOrders)[Month], 
datepart(qq,order_date_DateOrders)[Quarter],DATEPART(YYYY,order_date_DateOrders)[Year]
from Sales_Shipment_Data )P
group by P.Product_Name,P.Week,P.Month,P.Quarter,P.Year
order by P.Product_Name,P.Week,P.Month,P.Quarter,P.Year

----------------------------------------------------------

select Product_Name,sum(Order_Item_Quantity)[Tot_order_qty],DATEName(week,order_date_DateOrders)[Week], DATENAME(Month,order_date_DateOrders)[Month], 
DATEPART(quarter,order_date_DateOrders)[Quarter], DATEPART(Year,order_date_DateOrders)[Year],
sum(Order_Item_Quantity)/lag(sum(Order_Item_Quantity),1) over (partition by Product_Name order by DATEName(week,order_date_DateOrders), DATENAME(Month,order_date_DateOrders), 
DATEPART(quarter,order_date_DateOrders), DATEPART(Year,order_date_DateOrders))[Change by time]
from Sales_Shipment_Data
group by Product_Name,DATEName(week,order_date_DateOrders), DATENAME(Month,order_date_DateOrders), 
DATEPART(quarter,order_date_DateOrders), DATEPART(Year,order_date_DateOrders)


---Q15. Top 10 most ordered products/Top 10 most categories/
---Top 10 cities in terms of revenue and sale units(qty)

select * from
(select top 10 Product_Name,sum(Sales)[Revenue],sum(Order_Item_Quantity)[Sales unit] from Sales_Shipment_Data
group by Product_Name,Order_Item_Quantity
order by sum(Sales) desc) P
order by [Sales unit] desc

select * from 
(select top 10 Category_Name,sum(Sales)[Revenue],sum(Order_Item_Quantity)[Sales unit] from Sales_Shipment_Data
group by Category_Name,Order_Item_Quantity
order by sum(Sales) desc) C 
order by [Sales unit] desc

select * from
(select top 10 Order_City,sum(Sales)[Revenue],sum(Order_Item_Quantity)[Sales unit] from Sales_Shipment_Data
group by Order_City,Order_Item_Quantity
order by sum(Sales) desc) O 
order by [Sales unit] desc


---Q16. Top payment methods by each product category

select distinct Category_Name,Type,count(type)[Number of uses of payment methods] from Sales_Shipment_Data
group by Category_Name,Type
order by count(type) desc

---Q17. Which shipping mode is more efficient interms of not delaying?

select top 1 Shipping_Mode from Sales_Shipment_Data
where Last_Delivery_Risk = 'Not Late'
group by Shipping_Mode,Last_Delivery_Risk
order by count(shipping_mode) desc

---Q18. Number of orders,sales,qty by order status

select Order_Status,count(Order_Id)[Number of order],Count(Sales)[Number of sales],count(Order_Item_Quantity)[Number of Qty] 
from Sales_Shipment_Data
group by Order_Status

---Q19. Which categories are most profitable categories(top5)?

select top 5 Category_Name from Sales_Shipment_Data
group by Category_Name
order by sum(Order_Profit_Per_Order) desc

---Q20. Which categories have been given highest average discount(top5)?

select top 5 Category_Name from Sales_Shipment_Data
group by Category_Name
order by Avg(Order_Item_Discount) desc
