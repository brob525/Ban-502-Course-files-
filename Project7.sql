---Ben Robison	
--- MIS 504
--- Project 7

---1)Find any products that have not appeared on an order, ever. (LEFT JOIN, WHERE IS NULL)

select products.ProductID
from products
left join [Order Details] on [Order Details].productID = products.productID
where [Order Details].productID is Null



---2)Find any products that have not appeared on an order in 1996. (subquery with NOT IN)


select products.productname
from products
where productID not in (select ProductID
						from [order details],orders
						where year(Orderdate)=1996 and orders.orderID = [order details].orderID)


---3)Find any customers who have not placed an order, ever (similar to #1).

SELECT     Customers.CustomerID
FROM       Customers
LEFT JOIN  Orders ON Customers.customerid = orders.customerID
WHERE      Orders.customerID IS NULL

---4)Find any customers that did not place an order in 1996 (similar to #2).

select Customers.Companyname
from customers
where CustomerID not in (select CustomerID
						from orders
						where year(Orderdate)=1996)

---5)List all products that have been sold (any date). We need this to run fast, and we don't really want to see anything from the [order details] table, so use EXISTS.

select ProductID, ProductName
from Products
where exists (select ProductID
			  from [Order Details]
			  where products.productID = [Order Details].ProductID)
order by ProductID asc
						
---6)Give all details of all the above-average priced products. (simple subquery)

select *
from products
where UnitPrice > (select AVG(unitprice)
				   from Products)
order by UnitPrice asc

---7)Find all orders where the ShipName has non-ASCII characters in it (trick: WHERE shipname <> CAST(ShipName AS VARCHAR).

select *
from Orders
where ShipName <> CAST(Shipname as varchar)
	
---8)Show all Customers' CompanyName and region. Replace any NULL region with the word 'unknown'. Use the ISNULL() function. (Do a search on SQL ISNULL)

select CustomerID,
	   Companyname,
	   isnull(region,'unknown')
from Customers

---9)We need to know a list of customers (companyname) who paid more than $100 for freight on an order in 1996 (based on orderdate). Use the ANY operator to get this list. (We are expecting this to have to run often on billions of records. This could be done much less efficiently with a JOIN and DISTINCT.)

select companyname
from Customers
where $100 < any (select freight
				 from orders
				 where year(orderdate)=1996
				 and orders.CustomerID=Customers.CustomerID)



---10)We want to know a list of customers (companyname) who paid more than $100 for freight on all of their orders in 1996 (based on orderdate). Use the ALL operator. (We are expecting this to have to run often on billions of records. This could be done much less efficiently using COUNTs.)

select companyname
from Customers
where $100 < all (select freight
				 from orders
				 where year(orderdate)=1996
				 and orders.CustomerID=Customers.CustomerID)

---11)Darn! These unicode characters are messing up a downstream system. How bad is the problem? List all orders where the shipName has characters in it that are not upper case letters A-Z or lower case letters a-z. Use LIKE to do this. (see the LIKE video, and use '%[^a-zA-Z]%'


select orderID, ShipName
from Orders
where ShipName like '%[^a-zA-Z]%'




