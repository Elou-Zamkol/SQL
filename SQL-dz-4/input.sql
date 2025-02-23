--------------------------------------------------------------------------------------------------------------------------
use Step
INSERT INTO Curators (NameCurators, SurnameCurators) VALUES
(N'raul', N'Abd'),
(N'Tom', N'Imoli');



-- Заполняем Faculty
INSERT INTO Faculties (FinancingFaculties, NameFaculties) VALUES
(44 ,N'ин'),
(33, N'математики');

-- Заполняем Departments
INSERT INTO Departments (BuildingDepartments, FinancingDepartments, NameDepartments, FacultyId) VALUES
(2,4400000 ,N'hkby', 1),
(4, 33, N'bnjgyj',2);

-- Заполняем Group
INSERT INTO Groups (NameGroups, YearGroups, DepartmentId) VALUES
(N'IT-101', 3, 1),
(N'P107', 2, 2),
(N'D221', 2, 2),
(N'D1', 5, 2),
(N'MATH-201', 1, 1);


-- Заполняем Subject
INSERT INTO Subjects (NameSubjects) VALUES
(N'Математика'),
(N'Программирование'),
(N'Database Theory');

-- Заполняем Teacher
INSERT INTO Teachers (Salary, NameTeachers, SurnameTeachers, IsProfessor) VALUES
(55, N'raul', N'abdu', 0),
(66, N'oleg', N'aasd', 1);

-- Заполняем Lectures
INSERT INTO Lectures (LectureRoom, SubjectId, TeacherId) VALUES
(N'комната 1', 2, 1),
(N'комната 2', 1, 2),
(N'комната 3', 3, 1),
(N'P107', 3, 2);


INSERT INTO Students (NameStudents, SurnameStudents, Rating) VALUES
(N'raul', N'rr', 4),
(N'tom', N'tt', 2),
(N'gera', N'gg', 4),
(N'dmitriy', N'dd', 1),
(N'oleg', N'oo', 3),
(N'tim', N'tii', 2);


-- Заполняем GroupCurator
INSERT INTO GroupsCurators (CuratorId, GroupId) VALUES
(1, 1),
(2, 2);

-- Заполняем GroupsLectures
INSERT INTO GroupsLectures (GroupsId, LectureId) VALUES
(1, 2),
(3, 1),
(2, 3),
(3, 3);

INSERT INTO GroupsStudents (GroupsId, StudentId) VALUES
(1, 1),
(3, 2),
(2, 3),
(1, 4),
(3, 5),
(2, 6);

