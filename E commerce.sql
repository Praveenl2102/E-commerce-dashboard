create database ecommerce;
use ecommerce;
show tables;
select * from orders;
select state,amount,Profit from orders where Profit>1000;
select* from orders where amount>5000;
commit;
/*==========================================================
      E-COMMERCE SQL BUSINESS SCENARIOS
      Beginner → Advanced (20 Interview Questions)
==========================================================*/

/*----------------------------------------------------------
1. Find the total sales revenue.
----------------------------------------------------------*/
SELECT
    SUM(Amount) AS Total_Revenue
FROM orders;


/*----------------------------------------------------------
2. Find the total number of orders.
----------------------------------------------------------*/
SELECT
    COUNT(DISTINCT Order_ID) AS Total_Orders
FROM orders;


/*----------------------------------------------------------
3. Find the total number of customers.
----------------------------------------------------------*/
SELECT
    COUNT(DISTINCT Customer_Name) AS Total_Customers
FROM orders;


/*----------------------------------------------------------
4. Find the Average Order Value (AOV).
----------------------------------------------------------*/
SELECT
    ROUND(SUM(Amount) /
    COUNT(DISTINCT Order_ID),2) AS Average_Order_Value
FROM orders;


/*----------------------------------------------------------
5. Find the top 10 customers by total sales.
----------------------------------------------------------*/
SELECT
    Customer_Name,
    SUM(Amount) AS Total_Sales
FROM orders
GROUP BY Customer_Name
ORDER BY Total_Sales DESC
LIMIT 10;


/*----------------------------------------------------------
6. Find category-wise sales.
----------------------------------------------------------*/
SELECT
    Category,
    SUM(Amount) AS Sales
FROM orders
GROUP BY Category
ORDER BY Sales DESC;


/*----------------------------------------------------------
7. Find state-wise sales.
----------------------------------------------------------*/
SELECT
    State,
    SUM(Amount) AS Sales
FROM orders
GROUP BY State
ORDER BY Sales DESC;


/*----------------------------------------------------------
8. Find city-wise sales.
----------------------------------------------------------*/
SELECT
    City,
    SUM(Amount) AS Sales
FROM orders
GROUP BY City
ORDER BY Sales DESC;


/*----------------------------------------------------------
9. Find monthly sales.
----------------------------------------------------------*/
SELECT
    YEAR(Order_Date) AS Year,
    MONTH(Order_Date) AS Month,
    SUM(Amount) AS Monthly_Sales
FROM orders
GROUP BY YEAR(Order_Date),
         MONTH(Order_Date)
ORDER BY Year, Month;


/*----------------------------------------------------------
10. Find the most preferred payment mode.
----------------------------------------------------------*/
SELECT
    PaymentMode,
    COUNT(*) AS Total_Orders
FROM orders
GROUP BY PaymentMode
ORDER BY Total_Orders DESC;


/*----------------------------------------------------------
11. Find repeat customers.
----------------------------------------------------------*/
SELECT
    Customer_Name,
    COUNT(Order_ID) AS Orders
FROM orders
GROUP BY Customer_Name
HAVING COUNT(Order_ID) > 1;


/*----------------------------------------------------------
12. Find the top 5 products by sales.
----------------------------------------------------------*/
SELECT
    order_id,
    SUM(Amount) AS Sales
FROM orders
GROUP BY order_id
ORDER BY Sales DESC
LIMIT 5;

/*----------------------------------------------------------
13. Find products with negative profit.
----------------------------------------------------------*/
SELECT
    order_id,
    SUM(Profit) AS Total_Profit
FROM orders
GROUP BY order_id
HAVING SUM(Profit) < 0
ORDER BY Total_Profit;


/*----------------------------------------------------------
14. Rank products based on total sales.
----------------------------------------------------------*/
SELECT
    order_id,
    SUM(Amount) AS Sales,
    RANK() OVER(
        ORDER BY SUM(Amount) DESC
    ) AS Product_Rank
FROM orders
GROUP BY order_id;


/*----------------------------------------------------------
15. Calculate the running total of daily sales.
----------------------------------------------------------*/
SELECT
    Order_Date,
    SUM(Amount) AS Daily_Sales,
    SUM(SUM(Amount))
    OVER(
        ORDER BY Order_Date
    ) AS Running_Total
FROM orders
GROUP BY Order_Date;


/*----------------------------------------------------------
16. Find the top 3 customers from each state.
----------------------------------------------------------*/
WITH CustomerSales AS
(
SELECT
    State,
    Customer_Name,
    SUM(Amount) AS Total_Sales,
    ROW_NUMBER() OVER(
        PARTITION BY State
        ORDER BY SUM(Amount) DESC
    ) AS rn
FROM orders
GROUP BY State,
         Customer_Name
)

SELECT
    State,
    Customer_Name,
    Total_Sales
FROM CustomerSales
WHERE rn <= 3;


/*----------------------------------------------------------
17. Calculate each category's contribution to total sales.
----------------------------------------------------------*/
SELECT
    Category,
    SUM(Amount) AS Sales,
    ROUND(
        SUM(Amount) * 100 /
        SUM(SUM(Amount)) OVER(),
        2
    ) AS Contribution_Percentage
FROM orders
GROUP BY Category;


/*----------------------------------------------------------
18. Find customer lifetime value (CLV).
----------------------------------------------------------*/
SELECT
    Customer_Name,
    SUM(Amount) AS Customer_Lifetime_Value
FROM orders
GROUP BY Customer_Name
ORDER BY Customer_Lifetime_Value DESC;


/*----------------------------------------------------------
19. Find month-over-month sales growth.
----------------------------------------------------------*/
WITH MonthlySales AS
(
SELECT
    YEAR(Order_Date) AS Year,
    MONTH(Order_Date) AS Month,
    SUM(Amount) AS Sales
FROM orders
GROUP BY YEAR(Order_Date),
         MONTH(Order_Date)
)

SELECT
    Year,
    Month,
    Sales,
    LAG(Sales)
    OVER(
        ORDER BY Year, Month
    ) AS Previous_Month_Sales,

    Sales -
    LAG(Sales)
    OVER(
        ORDER BY Year, Month
    ) AS Sales_Growth
FROM MonthlySales;


/*----------------------------------------------------------
20. Find the highest-selling category in each state.
----------------------------------------------------------*/
WITH CategorySales AS
(
SELECT
    State,
    Category,
    SUM(Amount) AS Sales,

    RANK() OVER(
        PARTITION BY State
        ORDER BY SUM(Amount) DESC
    ) AS Rank_No

FROM orders
GROUP BY State,
         Category
)

SELECT
    State,
    Category,
    Sales
FROM CategorySales
WHERE Rank_No = 1;

/*======================== END ========================*/