/*  THE KEVIN COOKIE COMPANY DATASET
*THIS DATASET WAS GOTTEN FROM KEVIN STRATVERT's SQL FOR BEGINNERS TUTORIAL AND IT WAS ACTUALLY THE FIRST DATASET I PRACTICE SQL ON
* THIS FILE WAS UPLOADED WITH THE TABLES AND ALL SO I DIDNT HAVE TO DO ANY CLEANING*/
-- I WOULD BE VISUALIZING THE RESULTS GOTTEN FROM THIS PROJECT ON TABLEAU

-- CUSTOMER TABLE
select *
from dbo.customers
-- ORDER PRODUCT TABLE
select * 
from dbo.Order_Product
-- ORDERS TABLE
select *
from dbo.Orders
-- PRODUCT TABLES
select *
from dbo.Product

-- FIRST I WANT TO CHECK HOW WE ARE DOING SO I'LL LOOK AT THE SALES TREND OVER TIME
SELECT
     DATEPART(YEAR, O.OrderDate) AS SALES_YEAR,
	 DATEPART(MONTH, O.OrderDate) AS SALES_MONTH,
	 SUM(O.OrderTotal) AS MONTHLY_REVENUE 
FROM DBO.Orders AS O
GROUP BY   DATEPART(YEAR, O.OrderDate), DATEPART(MONTH, O.OrderDate)
ORDER BY SALES_YEAR, SALES_MONTH;

-- NEXT I WOULD LOOK FOR THE TOP CUSTOMER BY ORDERS
SELECT
     C.CustomerID,
	 C.CustomerName,
	 COUNT(O.OrderID) AS ORDER_COUNT
FROM DBO.Customers AS C
JOIN DBO.Orders AS O
    ON C.CustomerID = O.CustomerID
GROUP BY C.CustomerID, C.CustomerName
ORDER BY ORDER_COUNT DESC;

-- LOOKING FOR PROFIT MARGIN PER COOKIE
SELECT 
     P.CookieName,
	 P.RevenuePerCookie,
	 P.CostPerCookie,
	 (P.RevenuePerCookie - P.CostPerCookie)/P.RevenuePerCookie * 100 AS PROFIT_MARGIN
FROM DBO.Product AS P;

-- LOOKING FOR AVERAGE ORDER 
SELECT
     AVG(OrderTotal) AS AVG_ORDER
FROM DBO.Orders

-- LOOKING FOR TOP CUSTOMER BY REVENUE
SELECT
      C.CustomerID,
	  C.CustomerName,
	  SUM(O.OrderTotal) AS TOTAL_GENERATED_REVENUE
FROM DBO.Customers AS C
JOIN DBO.Orders AS O
    ON C.CustomerID = O.CustomerID
GROUP BY C.CustomerID, C.CustomerName
ORDER BY TOTAL_GENERATED_REVENUE DESC;

-- LOOKING FOR THE AVERAGE NUMBER OF COOKIE ORDERED (FOR THIS I TRIED TO RUN THE QUERY USING A TEMP TABLE INSTEAD OF THE DIRECT QUERY)
SELECT CookieID, Quantity
INTO #ORDERPRODUCTTEMP
FROM DBO.Order_Product;

SELECT 
      AVG(Quantity) AS AVG_COOKIES_ORDERED
FROM #ORDERPRODUCTTEMP;

DROP TABLE #ORDERPRODUCTTEMP;

-- LOOKING FOR WHICH COOKIE WAS ORDERED THE MOST (USING A SUBQUERY)
SELECT TOP 1
          P.CookieName,
		  ORDER_COUNT,
		  RevenuePerCookie
FROM (
       SELECT
	        CookieID,
			COUNT(OrderID) AS ORDER_COUNT
	   FROM DBO.Order_Product
	   GROUP BY CookieID
	   ) AS OP
JOIN DBO.Product P 
    ON OP.CookieID = P.CookieID
ORDER BY ORDER_COUNT DESC;

-- SIDENOTE I REALLY WANTED IT TO BE CHOCOLATE CHIP

-- LOOKING FOR THE TOP 2 MOST PROFITABLE COOKIES FOR FUN
SELECT TOP 2 
         CookieName,
		 RevenuePerCookie,
		(RevenuePerCookie - CostPerCookie) AS PROFIT_PER_COOKIE
FROM DBO.Product
ORDER BY PROFIT_PER_COOKIE DESC;

-- LOOKING FOR THE TOTAL SALES AND PROFIT PER COOKIE
SELECT
         P.CookieID,
         P.CookieName,
		 SUM(OP.Quantity) AS TOTAL_SALES,
		 SUM(OP.Quantity * P.RevenuePerCookie - OP.Quantity * P.CostPerCookie) AS TOTAL_PROFIT
FROM DBO.Product P
join dbo.Order_Product OP
    ON P.CookieID = OP.CookieID
GROUP BY P.CookieID, P.CookieName
ORDER BY TOTAL_SALES, TOTAL_PROFIT;

-- LOOKING FOR CUSTOMER THAT ONLY ORDERED 1 COOKIE TYPE AT ANY TIME
SELECT
      O.OrderID,
	  O.OrderDate,
	  O.OrderTotal,
	  C.CustomerName,
	  COUNT(DISTINCT OP.CookieID) AS COOKIE_TYPES_ORDERED
FROM DBO.Orders O
JOIN DBO.Customers C
     ON O.CustomerID = C.CustomerID
JOIN DBO.Order_Product OP
     ON O.OrderID = OP.OrderID
GROUP BY O.OrderID, O.OrderDate, O.OrderTotal, C.CustomerName
HAVING COUNT(DISTINCT OP.CookieID) = 1;

-- LOOKING FOR REVENUE TRENDS BY MONTH AND YEAR
SELECT
      DATEPART(YEAR, O.OrderDate) AS SALES_YEAR,
	  DATEPART(MONTH, O.OrderDate) AS SALES_MONTH,
	  SUM(P.RevenuePerCookie) AS MONTHLY_REVENUE
FROM DBO.Orders O
JOIN DBO.Order_Product OP
     ON O.OrderID = OP.OrderID
JOIN DBO.Product P 
     ON OP.CookieID = P.CookieID
GROUP BY DATEPART(YEAR, O.OrderDate), DATEPART(MONTH, O.OrderDate)
ORDER BY SALES_YEAR, SALES_MONTH;