create database inventory;
create table cust1
(c_id int primary key,
cname varchar(30) not null,
country varchar(25)
);

insert into cust1 values
(11,'Mark','Germany'),
(12,'Vikrant','India'),
(13,'Jacob','Spain'),
(14,'Victor','Germany'),
(15,'Emily','France'),
(16,'Vicent','Italy'),
(17,'Shashank','India'),
(18,'Anupam','India'),
(19,'Dustin','France'),
(20,'Claudia','Spain'),
(21,'Mark','Spain'),
(22,'Zoe','Spain'),
(23,'Anisha','India'),
(24,'Morata','Italy'),
(25,'Antonie','Germany');


create table prod1
(p_id int primary key,
pdesc varchar(50), 
price int);

insert into prod1 values
(101,'Book', 110),
(102,'Wallet', 210),
(103,'T-Shirt', 310),
(104,'Slippers', 180),
(105,'Sports_Shoe', 450),
(106,'Bottle', 150),
(107,'Football', 570),
(108,'KeyChain', 45),
(109,'Adapter', 160),
(110,'SmartWatch', 950);

create table orders1
(o_id varchar(10) primary key,
c_id int not null,
p_id int not null,
order_date date,
qty int,
Ordered_from varchar(100)
);


insert into orders1 values
('A1',12,107,'2022-11-20',1,'Amazon'),
('A2',11,108,'2022-12-15',5,'Ebay'),
('A3',12,107,'2022-10-18',2,'Amazon'),
('A4',14,101,'2023-02-05',4,'Ebay'),
('A5',17,103,'2022-11-30',7,'Walmart'),  
('A6',18,102,'2023-01-07',1,'Amazon'),    
('A7',13,105,'2022-12-10',2,'Walmart'),
('A8',18,103,'2023-01-07',2,'Alibaba'),   
('A9',21,106,'2022-12-24',1,'Walmart'),
('A10',24,103,'2022-12-27',3,'Amazon'),  
('A11',13,110,'2022-12-27',1,'Walmart'),
('A12',21,104,'2023-01-16',2,'Ebay'),
('A13',25,109,'2023-02-12',2,'Alibaba'),
('A14',22,107,'2023-03-09',1,'Ebay'),   
('A15',22,108,'2022-09-05',3,'Alibaba'),   
('A16',25,103,'2022-09-20',2,'Amazon'),
('A17',15,110,'2022-12-19',1,'Walmart'),
('A18',20,104,'2023-03-11',2,'Amazon'),
('A19',12,101,'2022-12-24',2,'Alibaba'),
('A20',25,109,'2023-01-02',3,'Alibaba'),    
('A21',16,101,'2023-01-01',4,'Walmart'),
('A22',11,102,'2023-02-08',2,'Ebay'),
('A23',23,103,'2023-03-14',1,'Alibaba'),
('A24',12,105,'2023-03-11',3,'Alibaba'),
('A25',21,103,'2022-11-30',2,'Amazon'),     
('A26',22,103,'2022-12-22',5,'Amazon'),
('A27',24,108,'2022-10-15',8,'Ebay'),
('A28',22,109,'2022-09-05',5,'Walmart'),    
('A29',12,108,'2023-03-09',4,'Alibaba'),    
('A30',23,101,'2022-11-20',2,'Amazon');

create table inventory1
(Proprietry varchar(100),
Prod_ID int,
Stock_Level int);

insert into inventory1 values
('Amazon',101,5),('Amazon',102,5),('Amazon',103,15),('Amazon',104,7),
('Amazon',105,10),('Amazon',106,6),('Amazon',107,5),('Amazon',108,6),
('Amazon',109,8),('Amazon',110,9),
('Alibaba',101,8),('Alibaba',102,6),('Alibaba',103,5),('Alibaba',104,10),
('Alibaba',105,5),('Alibaba',106,4),('Alibaba',107,8),('Alibaba',108,10),
('Alibaba',109,7),('Alibaba',110,15),
('Walmart',101,7),('Walmart',102,10),('Walmart',103,10),('Walmart',104,4),
('Walmart',105,5),('Walmart',106,6),('Walmart',107,4),('Walmart',108,6),
('Walmart',109,8),('Walmart',110,5),
('Ebay',101,5),('Ebay',102,6),('Ebay',103,7),('Ebay',104,6),
('Ebay',105,8),('Ebay',106,10),('Ebay',107,5),('Ebay',108,15),
('Ebay',109,5),('Ebay',110,7);


# cust1 - (c_id,cname,country)
# prod1 - (p_id,pdesc,price)
# orders1 - (o_id,c_id,p_id,order_date,qty,ordered_from)
# inventory1 - (Proprietry,Prod_Id,Stock_Level)

# Q1) Find top 5 customers who have spent the most. 
# Return C_ID,Customer Name, Country, amount spend. 
# If a customer has multiple orders then sum of amount has to be displayed for
# each c_id, cname and country.
select c.C_id,c.cname as 'Customer Name',c.country,sum(p.price*o.qty) as 'Amount spend' from cust1 c
join orders1 o on c.C_id=o.c_id join prod1 p on o.p_id = p.p_id group by c.c_id,c.cname,c.country order by `Amount spend` desc limit 5;
 

# Q2) Rank top 3 customers from each country who spend the most.
# Return Country, Customer name, amount spend(in descreasing order) and 
# Rank in ascending order.
-- select c.country,c.cname, sum(p.price*o.qty) as 'Amount spend', rank() over(order by sum(p.price*o.qty) desc) as 'Rank by spending' from cust1 c 
-- join orders1 o on c.c_id=o.c_id 
-- join prod1 p on o.p_id=p.p_id group by c.country,c.cname order by `Amount spend` desc limit 3;

select * from (select c.country, c.cname, sum(p.price*o.qty) as Amount, row_number() over(partition by country order by sum(p.price*o.qty) desc) as Drank from cust1 c join orders1 o 
on c.c_id =o.c_id
join prod1 p on p.p_id=o.p_id
group by c.country, c.cname) dt where Drank <=3 order by country;


create or replace view CPO1 as
select c.country, c.cname, sum(p.price*o.qty) as Amount 
from cust1 c join orders1 o  on c.c_id =o.c_id
join prod1 p on p.p_id=o.p_id
group by c.country, c.cname;


select * from cpo1;

# Q3) Find customers who have spend more than avg amount spend by all customers.
# Return C_ID, Customer name, and Amount. Solve 
# a) using Subquery
# b) using CTE
-- Subquery--
select c.cname, c.c_id, sum(p.price*o.qty) as Amount from cust1 c join orders1 o on c.c_id=o.c_id join prod1 p on p.p_id=o.p_id group by c.cname, c.c_id
having Amount > 
(select Avg(Amt) from (select c.cname, c.c_id, sum(p.price*o.qty) as Amt from cust1 c join orders1 o on c.c_id=o.c_id join prod1 p on p.p_id=o.p_id group by c.c_id, c.cname) t);

-- CTE
with cte1 as 
(select c.c_id, c.cname, sum(p.price*o.qty) as Amount from cust1 c 
join orders1 o on c.c_id=o.c_id
join prod1 p on p.p_id=o.p_id group by c.c_id, c.cname)
select c_id, cname, Amount as amount from cte1 where Amount > (select avg(Amount) from cte1);


# Q4) Find customers who have spend 1000 or more in the month of Dec or Jan
# Return C_ID, Customer name, and Amount.
select c.c_id as 'Customer ID', c.cname as 'Customer Name',month(o.order_date) as 'Order Month', sum(p.price*o.qty) as 'Amount' from cust1 c 
join orders1 o on c.c_id = o.c_id join prod1 p on o.p_id = p.p_id 
where month(o.order_date) in (12,1) group by c.c_id, c.cname, month(o.order_date) 
having sum(p.price*o.qty) >= 1000 order by `Amount` ;



# Q5) Rank top 3 customers from each country who spend the most. 
# The result should only inlcude customers from each country where there are 
# at least 3 customers available from each country. 
# Return Country, Customer name, amount spend(in descreasing order) and 
# Rank in ascending order 

select country, cname, Amount, AmountRank, CountryCount from
(select c.country, c.cname, sum(p.price*o.qty) as Amount, row_number() over (partition by country order by sum(p.price*o.qty) desc) as AmountRank,
count(*) over(partition by country) as CountryCount
from cust1 c join orders1 o
on c.c_id = o.c_id
join prod1 p 
on p.p_id = o.p_id
group by c.c_id, c.cname) dt
where AmountRank <=3 and CountryCount >=3
order by country;

select c.country, c.cname, sum(p.price*o.qty) as Amount, row_number() over (partition by country order by sum(p.price*o.qty) desc) as AmountRank,
count(*) over(partition by country) as CountryCount
from cust1 c join orders1 o
on c.c_id = o.c_id
join prod1 p 
on p.p_id = o.p_id
group by c.c_id, c.cname;


# Q6) Find the overall Median Amount.
 set @rowidx = -1;
 select @rowidx;
 
 select avg(amount) as Median from
 (select @rowidx := @rowidx +1 as RowIndex, amount from cpo1
 order by amount) as dt
 where dt.RowIndex in (Floor(@rowidx /2), Ceil(@rowidx /2));

# using percent_rank()
-- select amount, percent_rank() over(order by amount) as PRank from cpo1;

# Q7) Generate a Stored Prcoedure to find avg order amount for each Country. 
# Use Country as argument

delimiter //
create procedure sp1(in loc varchar(25))
begin
select c.country, avg(p.price*o.qty) as Amt
from cust1 c join orders1 o on c.c_id = o.c_id
join prod1 p on o.p_id=p.p_id where c.country =loc
group by c.country;
end //
delimiter ;

call sp1('Germany');
# Q8) Generate a Stored Prcoedure to fetch top N customers who have spent most amount
# per ecommerce platform
delimiter //
create procedure sp2(in loc int)
begin
select c.c_id, c.cname, c.country, sum(p.price*o.qty) from cust1 c join orders1 o on c.c_id = o.c_id
join prod1 p on o.p_id=p.p_id where count(c.c_id) = loc 
group by o.Ordered_from;
end //
delimiter ;
call sp2(5);

select c_id, cname, country,ordered_from, Amount,AmountRank from (select c.c_id, c.cname, c.country,o.ordered_from, sum(p.price*o.qty) as Amount, row_number() over(partition by o.Ordered_from order by sum(p.price*o.qty) desc) as AmountRank 
from cust1 c 
join orders1 o on c.c_id=o.c_id
join prod1 p on o.p_id=p.p_id
group by c.c_id, c.cname, c.country, o.ordered_from order by Amount desc) dt order by ordered_from desc limit 5; 


drop procedure sp5;

delimiter //
create procedure sp5 (in n int)
begin
select * from
(select c.c_id, o.ordered_from, sum(p.price*o.qty) as Amount, row_number() over(partition by o.ordered_from order by sum(p.price*o.qty) desc) as Rnum
from cust1 c join orders1 o on c.c_id=o.c_id
join prod1 p on o.p_id=p.p_id
group by c.c_id, o.Ordered_from) dt
where Rnum<=n;
end//
delimiter;

call sp5(3);

# Q9) Find the customers who fall into the 3rd quartile(Q3) based on the 
# amount spend.
select * from cpo1;

select * from 
(select cname, Amount, ntile(4) over (order by Amount) AmtQuartile from CPO1) dt
 where AmtQuartile = 3;

# Q10) Find year and month wise amount spend in decreasing order of Amount spend
select year(o.order_date) as Year, month(o.order_date) as Month, sum(p.price*o.qty) as Amount 
from cust1 c join orders1 o on c.c_id=o.c_id 
join prod1 p on o.p_id = p.p_id group by Year, month order by Amount desc;


# Q11) Generate a Stored Procedure to find Order statistics 
# ie:- min, max and mean Amount per Country.
delimiter //
create procedure min_max_avg()
begin
select c.country, min(p.price*o.qty)as Min_amt, max(p.price*o.qty) as Max_amt, avg(p.price*o.qty) as Avg_amt from cust1 c join orders1 o on 
c.c_id=o.c_id join prod1 p on o.p_id=p.p_id group by c.country;
end//
delimiter;

call min_max_avg();
# Q12) Find Country, Ecommerce Brand wise most sold product and its 
# count in terms of quantity.
select c.country, o.ordered_from, p.pdesc, sum(qty) as sumqty
from orders1 o join cust1 c on o.c_id=c.c_id
join prod1 p on o.p_id = p.p_id
group by c.country, o.ordered_from, p.pdesc
order by c.country, o.ordered_from;

select c.country, p.pdesc, sum(qty) as sumqty
from orders1 o join cust1 c on o.c_id=c.c_id
join prod1 p on o.p_id = p.p_id
group by c.country, p.pdesc
order by c.country;

# Q13) Find Country wise number of Customers who made an order. Also list 
# all the customer name along with the count
select  c.country, count(o.o_id) as count,
group_concat(c.cname) as List_of_customers
from cust1 c join orders1 o on o.c_id = c.c_id
join prod1 p on o.p_id=p.p_id
group by c.country;


# Q14) If Amazon offers 12% disocunt in month of Jan, 
# Alibaba offers 15% discount in the month of Dec,
# Ebay offers 20% disocunt in Feb and Walmart offers 25% discount in Nov
# Compute month wise order amount after adjusting for discount. 
select concat(year(o.order_date),"-",month(o.order_date)) as period,
sum(p.price*o.qty) as 'Origional Price',
sum(case
    when month(o.order_date) = 1 and o.ordered_from = 'Amazon' then 0.88*p.price*o.qty
    when month(o.order_date) = 12 and o.ordered_from = 'Alibaba' then 0.85*p.price*o.qty
    when month(o.order_date) = 2 and o.ordered_from = 'Ebay' then 0.80*p.price*o.qty
    when month(o.order_date) = 11 and o.ordered_from = 'Walmart' then 0.75*p.price*o.qty
    else p.price*o.qty
end) as Discounted_Amt
from cust1 c join orders1 o on c.c_id = o.c_id
join prod1 p on o.p_id = p.p_id
group by period order by period asc;

SELECT DATE_FORMAT(o.order_date, '%Y-%m') AS MName, 
    SUM(p.price * o.qty) AS Org_Amount,
    SUM(CASE
        WHEN MONTH(o.order_date) = 1 AND o.ordered_from = 'Amazon' THEN 0.88 * p.price * o.qty
        WHEN MONTH(o.order_date) = 12 AND o.ordered_from = 'Alibaba' THEN 0.85 * p.price * o.qty
        WHEN MONTH(o.order_date) = 2 AND o.ordered_from = 'Ebay' THEN 0.80 * p.price * o.qty
        WHEN MONTH(o.order_date) = 11 AND o.ordered_from = 'Walmart' THEN 0.75 * p.price * o.qty
        ELSE p.price * o.qty
    END) AS Discounted_Amt
FROM cust1 c JOIN orders1 o ON c.c_id = o.c_id JOIN prod1 p ON p.p_id = o.p_id
GROUP BY MName ORDER BY MName ASC;
# Q15) Create an insert trigger into order1 tables that restricts setting 
# order qty to a negative number.Set it to 1 if order qty is less than 0.
delimiter //
create trigger before_insert_order
before insert on orders1 for each row
begin
	if new.qty<0 then set new.qty=1;
    end if;
end//
delimiter;

insert into orders1 values
('A32',20,102,'2023-01-29',-5,'Ebay');
select * from orders1;

# Q16) Create a order date validation trigger. The trigger should prevent
# insertion of an order with future order date. The err msg should be
# 'Future order dates not allowed'

delimiter //
create trigger before_insert_order_date_error
before insert on orders1 for each row
begin
	if new.order_date>current_date() then 
     signal sqlstate '45000' 
     set message_text = 'Future order dates not allowed';
    end if;
end//
delimiter;

insert into orders1 values
('A40',20,102,'2024-01-29',-5,'Ebay');
drop trigger before_insert_order_date_error;

delimiter //
create trigger before_insert_order_date_update
before insert on orders1 for each row
begin
	if new.order_date>current_date() then set new.order_date=current_date();
    end if;
end//
delimiter ;
select * from orders1;
select curdate();

# Q17) Create a trigger Preventing Invalid Product Orders. The trigger should
# prevent the insertion of an order if the specified product does not exist 
# in the prod1 table. Err msg should be 'Invalid product specified'
delimiter //
create trigger Invalid_product_orders
before insert on orders1 for each row
begin
	declare product_count int;
    select count(*) into product_count from prod1 where p_id = new.p_id;
    if product_count= 0 then
    signal sqlstate '45000'
    set message_text ='Product is not available';
    end if;
end//
delimiter ;

insert into orders1 values
('A40',20,99,'2023-01-29',-5,'Amazon');


# Q18) Amazon has a return policy for 10 days, Walmart for 1 week, 
# Alibaba for 15 days, Ebay for 12 days. Create a SP to return the 
# total_price and return date for each order that the customer made. 
# The stored procedure accepts order_id as the argument
drop procedure return_date;
delimiter //
create procedure return_date(in order_id varchar(25))
begin
select o.o_id,o.ordered_from, o.order_date, sum(p.price*o.qty) as 'Amount',
case
 when o.Ordered_from = 'Amazon' then adddate(o.order_date,10)
     when o.Ordered_from = 'Alibaba' then adddate(o.order_date,15)
     when o.Ordered_from = 'Ebay' then adddate(o.order_date,12)
     when o.ordered_from = 'Walmart' then adddate(o.order_date,7)
     end as Return_date
    from cust1 c join orders1 o on c.c_id=o.c_id join prod1 p on p.p_id=o.p_id 
    where o.o_id=order_id
    group by o.o_id, o.Ordered_from, o.order_date, Return_date;
end//
delimiter ;
call return_date('A30');

# Q19) Find Ecommerce_brand and Month wise sum of sales, where Ecommerce names
# are represented as Column Names and Month_Num is set as Index.
-- Simple Solution
select o.ordered_from, year(o.order_date) as 'Year', month(o.order_date) as 'Month', sum(p.price*o.qty) as 'Amount'
from cust1 c join orders1 o on c.c_id=o.c_id join prod1 p on p.p_id=o.p_id group by o.Ordered_from, Year, month order by o.Ordered_from, Year, month; 

-- Pivot Table Solution
select year(o.order_date) as year, month(o.order_date) as Month, 
sum(case when o.ordered_from = 'Amazon' then p.price *o.qty else 0 end) as Amazon,
sum(case when o.ordered_from = 'Ebay' then p.price* o.qty else 0 end) as Ebay,
sum(case when o.ordered_from = 'Alibaba' then p.price*o.qty else 0 end) as Alibaba,
sum(case when o.ordered_from = 'Walmart' then p.price*o.qty else 0 end) as Walmart
from cust1 c join orders1 o on o.c_id=c.c_id
join prod1 p on p.p_id=o.p_id
group by year, month order by year, month;


# Q20) Find Ecommerce brand and Prod_Id wise total qty sold.
# Ecommerce Brabd should be represented as seperate columns and prod_id should
# set as Index
create or replace view quantity_pivot as
select p.p_id, 
sum(case when o.ordered_from = 'Amazon' then o.qty else 0 end) as Amazon,
sum(case when o.Ordered_from = 'Ebay' then o.qty else 0 end) as Ebay,
sum(case when o.Ordered_from = 'Alibaba' then o.qty else 0 end) as Alibaba,
sum(case when o.Ordered_from = 'Walmart' then o.qty else 0 end) as Walmart
from cust1 c join orders1 o on o.c_id=c.c_id
join prod1 p on p.p_id=o.p_id
group by p.p_id order by p.p_id;

select * from quantity_pivot;



# Q21) Create a mysql insert trigger that prevents ordering products more than
# the available stock levels. If such an order is made, the error text should 
# be 'Out of Stock'.
delimiter //
create trigger prevent_over_order_tr1
before insert on orders1 for each row
begin
	declare stock_level int;
    declare ordered_qty int;
    declare total_ordered_qty int;
    
    select i.stock_level into stock_level
    from inventory1 i
    where i.Prod_ID=new.p_id and i.Proprietry=new.ordered_from;
    
    select coalesce(sum(o.qty),0) into total_ordered_qty
    from orders1 o
    where o.p_id = new.p_id and o.Ordered_from = new.ordered_from;
    
    set ordered_qty = total_ordered_qty + new.qty;
    
    if ordered_qty > i.Stock_Level then
    signal sqlstate '45000'
    set message_text = 'Out of Stock';
    end if;
end//
delimiter ;


# Q22) Create a CTE to represent year and month wise sales.
with Year_month_cte as (
select year(o.order_date) as 'Year', month(o.order_date) as 'Month', o.ordered_from as 'Proprietry', sum(o.qty) as 'Total Sales'
from cust1 c join orders1 o on c.c_id=o.c_id
join prod1 p on o.p_id = p.p_id group by year, month, Proprietry order by year)
select Year, Month, Proprietry, `Total Sales` from Year_month_cte;

# Q23) Modify the CTE created in previous question to find 
# a) The previous month revenue, difference from prev month revenue and
# percent diff in Monthly_revenue from the previous month revenue.
# b) Cumulative sum and cumulative percentage of revenue.

WITH Year_Month_CTE AS (
    SELECT
        YEAR(o.order_date) AS "Year",
        MONTH(o.order_date) AS "Month",
        o.ordered_from AS "Proprietary",
        SUM(o.qty) AS "Total Sales",
        LAG(SUM(o.qty)) OVER (PARTITION BY o.ordered_from ORDER BY YEAR(o.order_date), MONTH(o.order_date)) AS "Prev Month Sales"
    FROM cust1 c
    JOIN orders1 o ON c.c_id = o.c_id
    JOIN prod1 p ON o.p_id = p.p_id
    GROUP BY YEAR(o.order_date), MONTH(o.order_date), o.ordered_from
    ORDER BY "Year"
)
SELECT
    Year,
    Month,
    Proprietary,
    "Total Sales",
    "Prev Month Sales",
    "Total Sales" - COALESCE("Prev Month Sales", 0) AS "Difference from Prev Month",
    CASE
        WHEN COALESCE("Prev Month Sales", 0) = 0 THEN NULL
        ELSE (("Total Sales" - COALESCE("Prev Month Sales", 0)) / COALESCE("Prev Month Sales", 0)) * 100
    END AS "Percent Diff from Prev Month",
    SUM("Total Sale") OVER (PARTITION BY "Proprietar" ORDER BY "Year", "Month") AS "Cumulative Sales",
    (SUM("Total Sales") OVER (PARTITION BY "Proprietary" ORDER BY "Year","Month") / SUM("Total Sales") 
    OVER (PARTITION BY "Proprietary" ORDER BY "Year", "Month" ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)) * 100 AS "Cumulative Percent"
FROM
    Year_Month_CTE;

	
# Q24) Find top N selling products by month. Use a stored procedure to 
# compute the same. N is the argument of stored procedure.
select * from (select year(o.order_date) as 'Year', month(o.order_date) as 'Month', o.ordered_from as 'Proprietry',p.p_id, sum(o.qty) as Sales,
rank() over(partition by o.ordered_from order by sum(o.qty) desc) as salesrank
from cust1 c join orders1 o on c.c_id=o.c_id
join prod1 p on o.p_id = p.p_id 
group by year, month, Proprietry,p.p_id order by Proprietry, Sales desc) t where t.salesrank <= 3;	

DELIMITER //

CREATE PROCEDURE GetTopSellingProductsByMonth(IN N INT)
BEGIN
    DROP TEMPORARY TABLE IF EXISTS MonthlySalesTemp;
    CREATE TEMPORARY TABLE MonthlySalesTemp (
        Year INT,
        Month INT,
        p_id INT,
        ProductDescription VARCHAR(50),
        TotalSales INT,
        Ranks INT
    );

    INSERT INTO MonthlySalesTemp
    SELECT
        YEAR(o.order_date) AS Year,
        MONTH(o.order_date) AS Month,
        p.p_id AS p_id,
        p.pdesc AS ProductDescription,
        SUM(o.qty) AS TotalSales,
        RANK() OVER (PARTITION BY YEAR(o.order_date), MONTH(o.order_date) ORDER BY SUM(o.qty) DESC) AS Ranks
    FROM
        orders1 o
    JOIN
        prod1 p ON o.p_id = p.p_id
    GROUP BY
        Year,
        Month,
        p.p_id,
        ProductDescription;

    SELECT
        Year,
        Month,
        p_id AS ProductID,
        ProductDescription,
        TotalSales
    FROM
        MonthlySalesTemp
    WHERE
        Ranks <= N
    ORDER BY
        Year,
        Month,
        Ranks;

    DROP TEMPORARY TABLE IF EXISTS MonthlySalesTemp;
END //

DELIMITER ;

Call GetTopSellingProductsByMonth(5);