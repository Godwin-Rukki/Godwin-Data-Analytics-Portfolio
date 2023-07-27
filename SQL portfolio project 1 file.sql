/*
* MAVEN ANALYTICS PLAYGROUND DATASET
*MAVEN NORTHWIND TRADERS CHALLENGE
*/
/* THE FILE CAME BASICALLY CLEAN SO I JUST FORMATED INTO A TABLE AND UPLOADED IT WITH OUT CODE (IE. I RIGHT CLICKED ON THE EMPTY DATABASE
* A POPUP MENU WOULD SHOW, CLICK ON TASK, AONTHER DROP DOWN MENU WOULD COME UP, CLICK ON IMPORT FLAT FILE AND I IMPORTED THE FILE IN CSV FORMART)*/
 
 -- RESULTS WOULD BE VISUALIZED USING TABLEAU

/*CATEGORY TABLE*/
SELECT *
FROM Categories

/* CUSTOMER TABLE */
SELECT *
FROM Customers

/* EMPLOYEES TABLE */
SELECT *
FROM Employees

/* ORDER DETAILS */
SELECT *
FROM OrderDetails

/* ORDERS */
SELECT *
FROM Orders

/* PRODUCTS */
SELECT *
FROM Product

/* SHIPPERS */
SELECT *
FROM Categories

/* FROM THE CHALLENGE WE WERE ASKED TO FIND THE SALES TREND OVER TIME, BEST AND WORST SELLING PRODUCT, KEY CUSTOMERS AND IF SHIPPING COST IS CONSISTENT AMONG PROVIDERS
*
*SHOWING THE SALES TREND OVER TIME */ 

SELECT 
      DATEPART(YEAR, O.ORDERDATE) AS SALES_YEAR,
	  DATEPART(MONTH, O.ORDERDATE) AS SALES_MONTH,
	  SUM(OD.unitPrice * OD.quantity) AS TOTAL_SALES
FROM dbo.Orders AS O
JOIN dbo.OrderDetails AS OD
     ON OD.ORDERID = O.ORDERID
GROUP BY DATEPART(YEAR, O.ORDERDATE), DATEPART(MONTH, O.ORDERDATE)
ORDER BY DATEPART(YEAR, O.ORDERDATE), DATEPART(MONTH, O.ORDERDATE);

/* SHOWING THE BEST AND WORST SELLING PRODUCT
* THE BEST SELLING PRODUCT
* LIMITING TO THE TOP TEN BEST SELLING PRODUCT*/

SELECT
     p.productID,
	 p.productName,
	 sum(od.quantity) as total_sales
FROM dbo.Product as p
JOIN  dbo.OrderDetails as od
on od.productID = p.productID
group by  p.productID, p.productName
order by total_sales Desc;

-- SHOWING THE WORST SELLING PRODUCT
SELECT
     p.productID,
	 p.productName,
	 sum(od.quantity) as total_sales
FROM dbo.Product as p
JOIN  dbo.OrderDetails as od
on od.productID = p.productID
group by  p.productID, p.productName
order by total_sales ;

-- SHOWING KEY CUSTOMERS
SELECT 
    c.customerID,
	c.companyName,
	count(o.orderid) as total_sales,
	sum(od.unitPrice * od.quantity) as total_spent
FROM
    dbo.Customers as c
join dbo.Orders as o
    on o.customerID = c.customerID
join dbo.OrderDetails as od 
    on od.orderID = o.orderID
group by c.customerID, c.companyName
order by total_spent desc;

-- SHOWING IF SHIPPING PRICE IS CONSISTENT AMONGST PROVIDERS
SELECT 
      s.shipperID,
	  s.companyName,
	  AVG(o.freight) as avg_shipping_cost
FROM dbo.Shippers as s
JOIN dbo.Orders as o
    ON o.shipperID = s.shipperID
GROUP BY s.shipperID, s.companyName
order by s.shipperID;

-- I COULDN'T JUST LEAVE IT AS IT IS HERE. SO, I HAD TO DIG IN TO FIND MORE INSIGHTS FROM THIS DATA
-- I CHECKED FOR GEOGRAPHICAL SALES ANALYSIS, PRODUCT AVAILABILITY IMPACT ON SALES, EMPLOYEE SALES PERFORMANCE OVER TIME AND CUSTOMER ORDER PATTERNS

-- SHOWING GEGRAPHICAL SALES ANALYSIS
SELECT
     city,
	 country,
	 COUNT(o.orderID) as total_orders,
	 SUM(od.unitPrice * od.quantity) as total_sales
FROM dbo.Customers as c
JOIN dbo.Orders as o
    ON c.customerID = o.customerID
JOIN dbo.OrderDetails as od 
    ON o.orderID = od.orderID
GROUP BY city, country
ORDER BY total_sales desc;

-- SHOWING THE IMPACT OF PRODUCT AVAILABILITY ON SALES
SELECT
     p.productID,
	 p.productName,
	 p.discontinued,
	 sum(od.quantity) as total_sold
FROM dbo.Product as p
join dbo.OrderDetails as od 
   on p.productID = od.productID
group by  p.productID, p.productName, p.discontinued
order by total_sold desc;

-- SHOWING EMPLOYEE SALES PERFORMANCE OVER TIME

SELECT
     e.employeeID,
	 e.employeeName,
	 DATEPART(YEAR, o.orderDate) as sales_year,
	 DATEPART(MONTH, o.orderDate) AS sales_month,
	 COUNT(o.orderid) as total_orders,
	 SUM(od.unitPrice * od.quantity) as total_sales
FROM dbo.Employees as e
left join dbo.Orders as o
         on e.employeeID = o.employeeID
left join dbo.OrderDetails as od
         on o.orderID = od.orderID
group by e.employeeID,e.employeeName, DATEPART(YEAR, o.orderDate), DATEPART(MONTH, o.orderDate)
order by e.employeeID, sales_year, sales_month;

-- SHOWING CUSTOMER ORDER PATTERNS

with ordered as (
                 select
				      c.customerID,
					  c.companyName,
					  o.orderDate,
					  ROW_NUMBER() over (partition by c.customerID order by o.orderDate) as order_rank
				 from dbo.Customers as c
				 join dbo.Orders as o on c.customerID = o.customerID )
		select
		     customerID,
			 companyName,
			 orderDate,
			 DATEDIFF(day, LAG(orderdate) over (partition by customerId order by orderDate), orderDate) as days_btw_orders
		from ordered
		where order_rank > 1
		order by customerID, orderDate;