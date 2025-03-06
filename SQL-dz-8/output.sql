use CarDealership

--1

create trigger TrackPriceChange on cars
after update
as
begin
    if update(Price)
    begin
        declare @CarId int, @OldPrice decimal(10,2), @NewPrice decimal(10,2);


        select @CarId = Id, @OldPrice = price
        from deleted;
        select @NewPrice = price
        from inserted;

        insert into carpricehistory (CarId, OldPrice, NewPrice, ChangeDate)
        values (@CarId, @OldPrice, @NewPrice, getdate());
    end
end;

--2


create trigger PreventDeleteCustomerWithActiveOrders on Customers
instead of delete
as
begin

    declare @CustomerId int;
    select @CustomerId = id from deleted;

    if exists (select 1 from Orders where CustomerId = @CustomerId)
    begin
        print ('It is impossible to delete a customer with active orders!');
    end


    else
    begin

        delete from Customers where id = @CustomerId;
    end
end;

--3

create trigger LogDeletedOrder on Orders
after delete

as
begin

    declare @OrderId int, @CustomerId int, @CarId int, @OrderDate datetime;

    select @OrderId = id, @CustomerId = CustomerId, @CarId = CarId, @OrderDate = OrderDate
    from deleted;

    insert into deletedorderslog (OrderId, CustomerId, CarId, OrderDate, DeletedAt)
    values (@OrderId, @CustomerId, @CarId, @OrderDate, getdate());
end;


--4

create trigger UpdateCarPriceOnYearChange on Cars
after update
as
begin

    declare @CarId int, @OldYear int, @NewYear int;

    select @CarId = id, @OldYear = year
    from deleted;
    select @NewYear = year
    from inserted;


    if @OldYear <> @NewYear
    begin
        update Cars
        set price = price * 0.95
        where id = @CarId;
    end
end;



--5

create trigger PreventDuplicateOrder on Orders
instead of insert
as
begin
    declare @CustomerId int, @CarId int;

    select @CustomerId = CustomerId, @CarId = CarId from inserted;

    if exists (select 1 from Orders where CustomerId = @CustomerId and CarId = @CarId)
    begin
        print('It is not possible to place an order for this car twice!');
    end

    else
    begin

        insert into Orders (CustomerId, CarId, OrderDate)
        select CustomerId, CarId, OrderDate from inserted;

    end
end;


