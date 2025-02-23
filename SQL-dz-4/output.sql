
use Step
------------------------------------------------------------------------------------------------------


select * from Curators; -- Кураторы

select * from Faculties; -- Факультеты

select * from Departments; -- Кафедры

select * from Groups; -- Группы

select * from Subjects; -- Дисциплины

select * from Teachers; -- Преподаватели

select * from Lectures; -- Лекции

select * from Students; -- Студенты

select * from GroupsCurators; -- Группы и кураторы

select * from GroupsLectures; -- Группы и лекции

select * from GroupsStudents; -- Группы и студенты


--1

select BuildingDepartments from Departments d
where  d.FinancingDepartments > 100000;



--2


select NameGroups from Groups g
join Departments d on g.DepartmentId = d.Id
where g.YearGroups = 5 and d.NameDepartments = 'Software Development'

--3

select G.NameGroups FROM Groups G
join GroupsStudents GS ON G.Id = GS.GroupsId
join Students S ON GS.StudentId = S.Id
GROUP BY G.NameGroups
having AVG(S.Rating) > (
    select AVG(S2.Rating)
    FROM GroupsStudents GS2
    join Groups G1 ON G1.Id = GS2.GroupsId
    join Students S2 ON GS2.StudentId = S2.Id
    where G1.NameGroups = 'D221');


--4

select t.SurnameTeachers ,t.NameTeachers from Teachers t
GROUP BY t.SurnameTeachers ,t.NameTeachers
having AVG(t.Salary) > (
    select AVG(t2.Salary)
    FROM Teachers t2
    where t2.IsProfessor > 0);


--5

select G.NameGroups from GroupsCurators GC
join Groups G on G.Id = GC.GroupId
GROUP BY G.NameGroups
having count(GC.CuratorId) > 1;


--6

select G.NameGroups from GroupsStudents GS
join Groups G on GS.GroupsId = G.Id
join Students S on GS.StudentId = S.Id
group by g.NameGroups
having AVG(S.Rating) < (
    select MIN(AvgRating)
    FROM (
        select AVG(S2.Rating) AS AvgRating
        FROM GroupsStudents GS2
        join Groups G1 ON G1.Id = GS2.GroupsId
        join Students S2 ON GS2.StudentId = S2.Id
        where G1.YearGroups = 5
        group by G1.NameGroups
    ) AS subquery
);


--7

select f.NameFaculties FROM Departments D
join Faculties F ON F.Id = D.FacultyId

GROUP BY f.NameFaculties
having sum(D.FinancingDepartments) > (
    select SUM(d1.FinancingDepartments) FROM Departments D1
    join Faculties F1 ON F1.Id = D1.FacultyId
    where d1.NameDepartments = 'Computer Science');

--8

select  S.NameSubjects, T.NameTeachers from Lectures L
join Subjects S on S.Id = L.SubjectId
join Teachers T on T.Id = L.TeacherId
GROUP BY  S.NameSubjects, T.NameTeachers
HAVING count(s.Id) = (select MAX(CountId)
    FROM (
        select COUNT(L1.Id) AS CountId
        FROM Lectures L1
        join Subjects S1 on S1.Id = L1.SubjectId
        GROUP BY l1.TeacherId, s1.Id
    ) AS Count
);


--9
select S.NameSubjects from Lectures L
join Subjects S on S.Id = L.SubjectId
join Teachers T on T.Id = L.TeacherId
GROUP BY S.NameSubjects, T.NameTeachers
HAVING count(L.Id) = (select min(CountId)
    FROM (
        select COUNT(L1.Id) AS CountId
        FROM Lectures L1
        join Subjects S1 on S1.Id = L1.SubjectId
        GROUP BY l1.TeacherId, s1.Id
    ) AS Count
);

--10

SELECT COUNT(DISTINCT s.Id) AS StudentCount, COUNT(DISTINCT l.SubjectId) AS SubjectCount
FROM Departments d
join Groups g ON d.Id = g.DepartmentId
join GroupsStudents gs ON g.Id = gs.GroupsId
join Students s ON gs.StudentId = s.Id
join GroupsLectures gl ON g.Id = gl.GroupsId
join Lectures l ON gl.LectureId = l.Id
where d.NameDepartments = 'Software Development';

