


--question 1
--A query that examines the month with the highest sales cycle in each year.
select *
from
     (
      select
        year(h.OrderDate) as  'year' ,
        MONTH(H.OrderDate) as 'MonthOfSale',
        format(SUM(D.LineTotal),'###,###') as 'TotalSales_Month',
        rank() over (partition by year(orderdate) order by SUM(D.LineTotal) desc ) as 'RankMonth'
      from Sales.SalesOrderDetail D
        join Sales.SalesOrderHeader H
        on D.SalesOrderID = H.SalesOrderID
        join Production.Product P
        on D.ProductID = P.ProductID
      group by year(h.OrderDate),
          Month(H.OrderDate)

       ) as mr
where RankMonth =1


/* After we received from the previous query that June is the month with the highest 
sales cycle overall, we would also like to examine the profitability in this month.
for 2012 and 2013
*/
select
       year(h.OrderDate) as  'year' ,
       MONTH(H.OrderDate) as 'MonthOfSale',
       format(SUM(D.LineTotal),'###,###') as 'TotalSales_Month',
       format(SUM(D.LineTotal - (P.StandardCost*d.OrderQty)),'###,###') as 'TotalProfit_Month'
from Sales.SalesOrderDetail D
       join Sales.SalesOrderHeader H
on D.SalesOrderID = H.SalesOrderID
       join Production.Product P
on D.ProductID = P.ProductID
where
       month(h.orderdate) = 6 and YEAR(h.OrderDate) between 2012 and 2013
group by
     year(h.OrderDate),
      Month(H.OrderDate)
order by
        year(h.orderdate)

/*
Now we will run a query that will display the most profitable month in each year,
and we will examine if there is a match between the months with the highest revenue and the most profitable months.

*/

select
      *
from
   (

   select
      year(h.OrderDate) as  year ,
      MONTH(H.OrderDate) as 'MonthOfSale',
      format(SUM(D.LineTotal),'###,###') as 'TotalSales_Month',
      format(SUM(D.LineTotal - (P.StandardCost*d.OrderQty)),'###,###') as 'TotalProfit_Month'
      ,rank() over (partition by year(h.orderdate) order by SUM(D.LineTotal - (P.StandardCost*d.OrderQty)) desc ) as 'rankm'
   from Sales.SalesOrderDetail D
      join Sales.SalesOrderHeader H
         on D.SalesOrderID = H.SalesOrderID
      join Production.Product P
          on D.ProductID = P.ProductID
   group by
      year(h.OrderDate),
        Month(H.OrderDate)

    ) as mr
where RankM =1






/*Here is my translation of the additional Hebrew text to English:
Now we will run a query that will display the increase 
and decrease in profitability in each quarter in order to examine the volatility across quarters for the years where the data was complete (2012 and 2013).

*/
 
SELECT
    CONCAT(Year(h.OrderDate), ' Q', DATEPART(q, h.OrderDate)) AS 'YearQuarter',
    FORMAT(SUM(D.Linetotal), '###,###') AS 'Q_TotalSales',
    FORMAT(
        (SUM(D.Linetotal) / LAG(SUM(D.Linetotal), 1) OVER ( ORDER BY CONCAT(Year(h.OrderDate), ' Q', DATEPART(q, h.OrderDate)))) - 1,
        'p'
    ) AS 'Q_Growth_Precent'
FROM
    Sales.SalesOrderDetail D
JOIN
    Sales.SalesOrderHeader H ON D.SalesOrderID = H.SalesOrderID
JOIN
    Production.Product P ON D.ProductID = P.ProductID
where (YEAR(h.OrderDate) between 2012 and 2013)
GROUP BY
    Year(h.OrderDate),
    DATEPART(q, h.OrderDate)
ORDER BY
    Year(h.OrderDate),
    DATEPART(q, h.OrderDate);


--  Now we will run a query that will display the revenue growth in each quarter in order to examine the volatility across quarters.
SELECT
    CONCAT(Year(h.OrderDate), ' Q', DATEPART(q, h.OrderDate)) AS 'YearQuarter',
    FORMAT(SUM(D.Linetotal), '###,###') AS 'Q_TotalSales',
    FORMAT(
        (SUM(D.Linetotal) / LAG(SUM(D.Linetotal), 1) OVER ( ORDER BY CONCAT(Year(h.OrderDate), ' Q', DATEPART(q, h.OrderDate)))) - 1,
        'p'
    ) AS 'Q_Growth_Precent'
FROM
    Sales.SalesOrderDetail D
JOIN
    Sales.SalesOrderHeader H ON D.SalesOrderID = H.SalesOrderID
JOIN
    Production.Product P ON D.ProductID = P.ProductID
GROUP BY
    Year(h.OrderDate),
    DATEPART(q, h.OrderDate)
ORDER BY
    Year(h.OrderDate),
    DATEPART(q, h.OrderDate);


--question 2


--  Now we will run a query that will display the revenue growth in each quarter in order to examine the volatility across quarters.

SELECT
    CONCAT(Year(h.OrderDate), ' Q', DATEPART(q, h.OrderDate)) AS 'YearQuarter',
    FORMAT(SUM(D.Linetotal), '###,###') AS Q_TotalSales,
    FORMAT(
        (SUM(D.Linetotal) / LAG(SUM(D.Linetotal), 1) OVER ( ORDER BY CONCAT(Year(h.OrderDate), ' Q', DATEPART(q, h.OrderDate)))) - 1,
        'p'
    ) AS 'Q_Growth_Precent'
FROM
    Sales.SalesOrderDetail D
JOIN
    Sales.SalesOrderHeader H ON D.SalesOrderID = H.SalesOrderID
JOIN
    Production.Product P ON D.ProductID = P.ProductID
GROUP BY
    Year(h.OrderDate),
    DATEPART(q, h.OrderDate)
ORDER BY
    Year(h.OrderDate),
    DATEPART(q, h.OrderDate);



--	A query representing the trends of revenue and profitability over the years.
select
      year(h.OrderDate) as  'year' ,
      MONTH(H.OrderDate) as 'MonthOfSale',
      format(SUM(D.LineTotal),'###,###') as 'TotalSales_Month',
      format(SUM(D.LineTotal - (P.StandardCost*d.OrderQty)),'###,###') as 'TotalProfit_Month'
      ,rank() over (partition by year(h.orderdate) order by SUM(D.LineTotal - (P.StandardCost*d.OrderQty)) desc ) as 'rankm'
   from Sales.SalesOrderDetail D
      join Sales.SalesOrderHeader H
         on D.SalesOrderID = H.SalesOrderID
      join Production.Product P
          on D.ProductID = P.ProductID
   group by
      year(h.OrderDate),
        Month(H.OrderDate)



--question 3


--A query in order to get a status picture of the profitability and sales in the online stores versus the physical stores.
select


    FORMAT(SUM(CASE WHEN h.OnlineOrderFlag = 1 THEN (D.LineTotal - (P.StandardCost*D.OrderQty)) ELSE 0 END), '###,###') AS 'OnlineProfit',
    FORMAT(SUM(CASE WHEN h.OnlineOrderFlag = 0 THEN (D.LineTotal - (P.StandardCost*D.OrderQty)) ELSE 0 END), '###,###') AS 'PhysicalProfit',
FORMAT(SUM(CASE WHEN h.OnlineOrderFlag = 1 THEN (D.LineTotal) ELSE 0 END), '###,###') AS 'OnlineSales',
    FORMAT(SUM(CASE WHEN h.OnlineOrderFlag = 0 THEN (D.LineTotal) ELSE 0 END), '###,###') AS 'Physicasales',
    FORMAT(SUM(D.LineTotal), '###,###') AS 'TotalSales',
FORMAT(SUM(D.LineTotal - (P.StandardCost*D.OrderQty)), '###,###') AS 'TotalProfit'

FROM
    Production.Product AS p
JOIN
    Sales.SalesOrderDetail AS d ON p.ProductID = d.ProductID
JOIN
    Sales.SalesOrderHeader AS h ON d.SalesOrderID = h.SalesOrderID




--A query for the profitability by country in the online and physical stores.

SELECT
   
    st.Name as 'Country',
    FORMAT(SUM(CASE WHEN h.OnlineOrderFlag = 1 THEN (D.LineTotal - (P.StandardCost*D.OrderQty)) ELSE 0 END), '###,###') AS 'OnlineProfit',
    FORMAT(SUM(CASE WHEN h.OnlineOrderFlag = 0 THEN (D.LineTotal - (P.StandardCost*D.OrderQty)) ELSE 0 END), '###,###') AS 'PhysicalProfit'

FROM
    Production.Product AS p
JOIN
    Sales.SalesOrderDetail AS d ON p.ProductID = d.ProductID
JOIN
    Sales.SalesOrderHeader AS h ON d.SalesOrderID = h.SalesOrderID
JOIN
    Sales.SalesTerritory AS st ON st.TerritoryID = h.TerritoryID

GROUP BY
    st.Name
ORDER BY
    sum(D.LineTotal - (P.StandardCost*D.OrderQty)) DESC;
