create database if not exists orderdb;

use orderdb;

-- load table CSV to DataBaseOrderdb
SELECT * FROM orderdb.orders_with_issues limit 10;
create table if not exists orders (
                            OrderID int,
                            CustomerID varchar(10),
                            OrderDate date,
                            ShppedDate date,
                            ShippingCost Double,
                            ShipCountry varchar(50),
                            shipCity varchar(50),
                            ShippingCompany varchar(150));
                            
-- load data to Table
SET GLOBAL local_infile = 1;

LOAD DATA LOCAL INFILE 'E:/data engineer/DE with python/Orders_with_issues.csv'
INTO TABLE orderdb.orders
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;
select * from orderdb.orders limit 10;
                            
-- check missing Vlues
select count(OrderID) from orderdb.orders where OrderID IS NULL OR OrderID = '';
update orderdb.orders
set OrderID = null
where OrderID = 0 ;
-- handle missing values in orderId Fill First row data
 create table if not exists orders_filled_ID as
 (select OrderID,
         case 
			when OrderID is null then COALESCE(OrderID, LAG(OrderID) over())
            else OrderID
      end as filled_id ,
      CustomerID,
      OrderDate,
      ShppedDate,
      ShippingCost,
      ShipCountry,
      shipCity,
      ShippingCompany
      from orders );

truncate table Orders;
INSERT INTO Orders (
    OrderID,
    CustomerID,
    OrderDate,
    ShppedDate,
    ShippingCost,
    ShipCountry,
    ShipCity,
    ShippingCompany
)
SELECT 
    filled_id,     -- alias for OrderID
    CustomerID,
    OrderDate,
    ShppedDate,
    ShippingCost,
    ShipCountry,
    ShipCity,
    ShippingCompany
FROM orders_filled_id;




------------------------------------------
-- # handle missing values in CustomerID fill with unknown
select * from orders where CustomerID is null or CustomerID ='';

update Orders
set CustomerID = 'Unknown'
where CustomerID is null or CustomerID ='';
   

----------------------------------------------------
-- # handle missing values in Shipcity fill with unspecified
select * from Orders where shipCity is null or shipCity ='';

update Orders 
set shipCity = 'Unspecified'
where shipCity is null or shipCity ='';


---------------------------------------------------------

-- Standardize Names

update Orders
set ShipCountry = trim(ShipCountry) ;
update Orders
 set shipCity = trim(shipCity) ;
 update Orders
 set ShippingCompany = trim(ShippingCompany);
 
 
 --------------------------------------
 -- create deliveryDays column clculating the difference between shippingdate and ordwrdate
 
 alter table Orders
 add column deliveryDays int ;
 
 update Orders
 set deliveryDays = DATEDIFF(ShppedDate, OrderDate);
 
 -------------------------------------------------------------
 -- create DeliveryStatus column 
 alter table Orders
 add column DeliveryStatus varchar(10);
 
 update Orders
 set DeliveryStatus = case 
                           when deliveryDays is null then 'Unknown'
                           when deliveryDays > 30 then 'Late'
                           else 'On Time'
                      end ;     
 

-------------------------------------------
-- Domestic vs International

alter table Orders
add column IsDomestic varchar(5);

update Orders
set IsDomestic = case  
                         when ShipCountry = 'Germany' then 'Yes'
                         else 'No'
                 end;        
-----------------------------------------------------
-- average ShippingCost by ShippingCompany

select ShippingCompany, round(avg(ShippingCost),2) as AvgShippingCost from Orders group by ShippingCompany order by avg(ShippingCost) desc;


-----------------------------------------------
-- Export cleaned_orders_sql to csv file
SHOW VARIABLES LIKE 'secure_file_priv';
SELECT *
FROM Orders
INTO OUTFILE 'E:/data engineer/DE with python/Orders_cleaned_sql.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';