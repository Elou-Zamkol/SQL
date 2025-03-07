

USE master

DROP DATABASE CarDealership
GO

CREATE DATABASE CarDealership;
GO





USE CarDealership;
GO

create table Groups (
    Id int primary key identity,
    GroupName nvarchar(100),
    StudentsCount int default 0
);


create table Student (
    Id int primary key identity,
    FirstName nvarchar(100),
    LastName nvarchar(100),
    GroupId int foreign key references Groups(Id),
    AverageGrade float
);


create table Teacher (
    Id int primary key identity,
    FirstName nvarchar(100),
    LastName nvarchar(100)
);


create table Course (
    Id int primary key identity,
    Name nvarchar(100),
    TeacherId int foreign key references Teacher(Id)
);



create table CourseRegistration (
    Id int primary key identity,
    StudentId int foreign key references Student(Id),
    CourseId int foreign key references Course(Id)

);




create table Grade (
    Id int primary key identity,
    StudentId int foreign key references Student(Id),
    Grade int
);




create table Warning (
    Id int primary key identity,
    StudentId int foreign key references Student(Id),
    Reason nvarchar(max),
    Date datetime
);





create table GradeHistory (
    Id int primary key identity,
    StudentId int foreign key references Student(Id),
    OldGrade int,
    NewGrade int,
    ChangeTime datetime
);



create table Attendance (
    Id int primary key identity,
    StudentId int foreign key references Student(Id),
    AttendanceDate date,
    Missed bit
);



create table RetakeList (
    Id int primary key identity,
    StudentId int foreign key references Student(Id),
    Reason nvarchar(max)
);



create table Payments (
    Id int primary key identity,
    StudentId int foreign key references Student(Id),
    Amount decimal(10, 2),
    Status nvarchar(50)
);



--1

create trigger CheckStudentsCount on Student
for insert
as

begin
    if (select count(*) from Student
        inner join Groups on Groups.Id = Student.GroupId) >= 30

    begin

        print(N'Student limit reached! Cannot add more students');

    end

end

go


--2

create trigger UpdateStudentsCountOnInsert on Student
for insert
as

begin
    update Groups
    set StudentsCount = StudentsCount + 1
    from Groups G
    join inserted I on I.GroupId = G.Id;

end
go

create trigger UpdateStudentsCountOnDelete on Student
for delete
as

begin
    update Groups
    set StudentsCount = StudentsCount - 1
    from Groups G
    join deleted D on D.GroupId = G.Id;
end

go


--3

create trigger AutoRegisterStudentForIntroCourse on Student
for insert
as

begin
    declare @СourseId int;

    select @СourseId = Id from Course where Name = 'Введение в программирование';


    if @СourseId is not null
    begin
        insert into CourseRegistration (StudentId, CourseId)
        select StudentId, @СourseId from CourseRegistration;
    end

end
go



--4

create trigger WarningLowGrade on Grade
for insert, update

as
begin

    if exists (select 1 from inserted where Grade < 3)
    begin
        insert into Warning (StudentId, Reason, Date)
        select StudentId, 'Low grade', getdate() from inserted where Grade < 3;

    end
end
go



--5

create trigger PreventTeacherDelete on Teacher
for delete
as

begin
    if exists (select 1 from Course where TeacherId in (select Id from deleted))
    begin

        print(N'Cannot delete teacher with active courses!');
    end
end
go


--6

create trigger SaveGradeHistory on Grade
for update
as

begin
    insert into GradeHistory (StudentId, OldGrade, NewGrade, ChangeTime)
    select StudentId, deleted.Grade, inserted.Grade, getdate() from inserted
    join deleted on inserted.Id = deleted.Id

end
go


--7

create trigger TrackAttendance on Attendance
for insert
as
begin
    declare @ConsecutiveAbsences int;

    select @ConsecutiveAbsences = count(*)
    from Attendance
    where StudentId in (select StudentId from inserted) and Missed = 1 and AttendanceDate between (getdate() - 5) and getdate();

    if @ConsecutiveAbsences > 5
    begin

        insert into RetakeList (StudentId, Reason)
        select StudentId, 'More than 5 consecutive absences' from inserted;

    end
end
go



--8

create trigger PreventDeleteStudentWithDebts on Student
for delete
as
begin
    if exists (select 1 from Payments where StudentId in (select Id from deleted) and Status = 'Unpaid')
    begin

        print(N'Cannot delete student with unpaid debts!');
    end
end
go


--9

create trigger UpdateAverageGrade
on Grade
for insert, update
as

begin
    declare @StudentId int;

    select @StudentId = StudentId from inserted;

    update Student
    set AverageGrade = (select avg(Grade) from Grade where StudentId = @StudentId)
    where Id = @StudentId;
end
go



