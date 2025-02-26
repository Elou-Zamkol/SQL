
use Academy1

--1
insert into Customers (CustomerID, FirstName, LastName, Email)
values (1, 'Иван', 'Иванов', 'ivanov@example.com');

--2
update Customers
set Email = 'newemail@example.com'
where CustomerID = 1;

--3

delete from Customers
where CustomerID = 5;

--4

select * from Customers
order by LastName;

--5

insert into Customers (CustomerID, FirstName, LastName, Email)
values
(2, 'raul', 'abd', 'raul@gmail.com'),
(3, 'tom', 'eminov', 'tom@gmail.com'),
(4, 'tim', 'eminov', 'tim@gmail.com');

--6

insert into Orders (OrderID, CustomerID, OrderDate, TotalAmount, CustomerID)
values (1, 1, '2023-05-01', 250.00, 2);

--7

update Orders set TotalAmount = 300.00
where OrderID = 2;

--8

delete from Orders
where OrderID = 3;

--9

select * from Orders
where CustomerID = 1;

--10

select * from Orders
where year(OrderDate) = 2023;

--11

insert into Products (ProductID, ProductName, Price)
values (1, 'Cola', 150.00);

--12

update Products set Price = 120.00
where ProductID = 2;

--13

delete from Products
where ProductID = 4;

--14

select * from Products
where Price > 100;

--15

select * from Products
where Price <= 50;

--16

insert into OrderDetails (OrderDetailID, OrderID, ProductID, Quantity, Price, OrderID, ProductID)
values (1, 1, 2, 3, 100.00, 1, 1);

--17

update OrderDetails set Quantity = 5
where OrderDetailID = 1;

--18

delete from OrderDetails
where OrderDetailID = 2;

--19

select p.ProductName, od.Quantity, od.Price from OrderDetails od
join Products p on od.ProductID = p.ProductID
where od.OrderID = 1;

--20

select o.OrderID, o.OrderDate, od.Quantity, od.Price from Orders o
join OrderDetails od on o.OrderID = od.OrderID
where od.ProductID = 2;

--21

select o.OrderID, o.OrderDate, c.FirstName, c.LastName AS FullName from Orders o
join Customers c ON o.CustomerID = c.CustomerID;


--22

select c.FirstName + ' ' + c.LastName as FullName, p.ProductName, od.Quantity from OrderDetails od
join Orders o on od.OrderID = o.OrderID
join Customers c on o.CustomerID = c.CustomerID
join Products p on od.ProductID = p.ProductID;

--23

select o.OrderID, o.OrderDate, o.TotalAmount, c.FirstName, c.LastName from Orders o
join Customers c on o.CustomerID = c.CustomerID;

--24

select o.OrderID, o.OrderDate, p.ProductName from Orders o
inner join OrderDetails od on o.OrderID = od.OrderID
inner join Products p on od.ProductID = p.ProductID;

--25

select c.CustomerID, c.FirstName, c.LastName, o.OrderID, o.OrderDate, o.TotalAmount from Customers c
left join Orders o on c.CustomerID = o.CustomerID;

--26

select p.ProductID, p.ProductName, o.OrderID, o.OrderDate from Products p
right join OrderDetails od on p.ProductID = od.ProductID
right join Orders o on od.OrderID = o.OrderID;

--27

select o.OrderID, o.OrderDate, p.ProductName from Orders o
inner join OrderDetails od on o.OrderID = od.OrderID
inner join Products p on od.ProductID = p.ProductID;

--28

select c.FirstName, c.LastName, o.OrderID, o.OrderDate, p.ProductName, od.Quantity, od.Price from Customers c
inner join Orders o on c.CustomerID = o.CustomerID
inner join OrderDetails od on o.OrderID = od.OrderID
inner join Products p on od.ProductID = p.ProductID;

--29

select FirstName, LastName
from Customers
where CustomerID in (
    select CustomerID
    from Orders
    where TotalAmount > 500
);

--30

select ProductName
from Products
where ProductID in (
    select ProductID
    from OrderDetails
    group by ProductID
    having COUNT(*) > 10
);

--31

select FirstName, LastName,
       (select sum(TotalAmount)
        from Orders
        where Orders.CustomerID = Customers.CustomerID) as TotalSpent
from Customers;

--32

select ProductName, Price
from Products
where Price > (
    select avg(Price)
    from Products
);

--33

select o.OrderID, o.OrderDate, o.TotalAmount,
       c.FirstName, c.LastName, c.Email,
       p.ProductName, od.Quantity, od.Price from Orders o
inner join Customers c on o.CustomerID = c.CustomerID
inner join OrderDetails od on o.OrderID = od.OrderID
inner join Products p on od.ProductID = p.ProductID;

--34

select c.FirstName, c.LastName, o.OrderID, o.OrderDate,
       p.ProductName, od.Quantity, od.Price
from Customers c


inner join Orders o on c.CustomerID = o.CustomerID
inner join OrderDetails od on o.OrderID = od.OrderID
inner join Products p on od.ProductID = p.ProductID;


--35

select c.FirstName, c.LastName, p.ProductName,
       od.Quantity, od.Price,
       (od.Quantity * od.Price) AS TotalCost from Customers c

inner join Orders o on c.CustomerID = o.CustomerID
inner join OrderDetails od on o.OrderID = od.OrderID
inner join Products p ON od.ProductID = p.ProductID;

--36

select o.OrderID, o.OrderDate, SUM(od.Quantity * od.Price) AS TotalCost
from Orders o
inner join OrderDetails od ON o.OrderID = od.OrderID
group by o.OrderID, o.OrderDate
having SUM(od.Quantity * od.Price) > 1000;

--37

select Customers.FirstName, Customers.LastName
from Customers
where Customers.CustomerID in (
    select Orders.CustomerID
    from Orders
    group by Orders.CustomerID
    having SUM(Orders.TotalAmount) > (
        select AVG(TotalAmount)
        from Orders
    )
);

--38

select c.FirstName, c.LastName, COUNT(o.OrderID) AS OrderCount from Customers c
left join Orders o on c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.FirstName, c.LastName;

--39

select OrderDetails.ProductID, SUM(OrderDetails.Quantity) AS TotalQuantity from OrderDetails
group by OrderDetails.ProductID
having SUM(OrderDetails.Quantity) > 3;

--40

select c.FirstName, c.LastName, o.OrderID, SUM(od.Quantity) as TotalQuantity
from Customers c
inner join Orders o on c.CustomerID = o.CustomerID
inner join OrderDetails od on o.OrderID = od.OrderID
group by c.CustomerID, o.OrderID, c.FirstName, c.LastName;





