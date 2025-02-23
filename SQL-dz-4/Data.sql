IF NOT EXISTS (SELECT name FROM master.sys.databases WHERE name = 'Step')
BEGIN
    CREATE DATABASE Step;
END
GO

USE master

DROP DATABASE Step
GO


USE Step

--1
CREATE Table Curators
(
    [Id] int identity(1, 1) PRIMARY KEY NOT NULL,
    [NameCurators] nvarchar(max) NOT NULL CHECK (len([NameCurators]) > 0) ,
    [SurnameCurators] nvarchar(max) NOT NULL CHECK (len([SurnameCurators]) > 0)

);


GO


--3
CREATE Table Faculties
(
	[Id] int identity(1, 1) PRIMARY KEY NOT NULL,
	[FinancingFaculties] money NOT NULL DEFAULT 0 CHECK ([FinancingFaculties] > 0),
    [NameFaculties] nvarchar(100) NOT NULL UNIQUE CHECK (len([NameFaculties]) > 0)
);


GO

--2
CREATE Table Departments
(
    [Id] int identity(1, 1) PRIMARY KEY NOT NULL,
    [BuildingDepartments] int NOT NULL CHECK (BuildingDepartments > 1 and BuildingDepartments <= 5),
    [FinancingDepartments] money NOT NULL DEFAULT 0 CHECK ([FinancingDepartments] > 0),
	[NameDepartments] nvarchar(100) NOT NULL UNIQUE CHECK (len([NameDepartments]) > 0),
	[FacultyId] int NOT NULL FOREIGN KEY REFERENCES Faculties(Id)
);


GO


--4
CREATE Table Groups
(
    [Id] int identity(1, 1) PRIMARY KEY NOT NULL,
    [NameGroups] nvarchar(10) NOT NULL CHECK (len([NameGroups]) > 0),
    [YearGroups] int NOT NULL CHECK ([YearGroups] >= 1 and [YearGroups] <= 5),
    [DepartmentId] int NOT NULL FOREIGN KEY REFERENCES Departments(Id)

);


GO


--5
CREATE Table GroupsCurators
(
    [Id] int identity(1, 1) PRIMARY KEY NOT NULL,
    [CuratorId] int NOT NULL FOREIGN KEY REFERENCES Curators(Id),
	[GroupId] int NOT NULL FOREIGN KEY REFERENCES Groups(Id)

);


--8
CREATE Table Subjects
(
    [Id] int identity(1, 1) PRIMARY KEY NOT NULL,
    [NameSubjects] nvarchar(100) NOT NULL CHECK (len([NameSubjects]) > 0)

);


--9

CREATE Table Teachers
(
    [Id] int identity(1, 1) PRIMARY KEY NOT NULL,
	[Salary] money NOT NULL CHECK ([Salary] > 0),
	[NameTeachers] nvarchar(max) NOT NULL CHECK (len([NameTeachers]) > 0) ,
    [SurnameTeachers] nvarchar(max) NOT NULL CHECK (len([SurnameTeachers]) > 0),
    [IsProfessor] bit NOT NULL DEFAULT 0


);

--7=====

CREATE Table Lectures
(
    [Id] int identity(1, 1) PRIMARY KEY NOT NULL,
    [LectureRoom] nvarchar(10) NOT NULL CHECK (len([LectureRoom]) > 0),
	[SubjectId] int NOT NULL FOREIGN KEY REFERENCES Subjects(Id),
	[TeacherId] int NOT NULL FOREIGN KEY REFERENCES Teachers(Id)

);


CREATE Table Students
(
    [Id] int identity(1, 1) PRIMARY KEY NOT NULL,
    [NameStudents] nvarchar(max) NOT NULL CHECK (len([NameStudents]) > 0) ,
    [SurnameStudents] nvarchar(max) NOT NULL CHECK (len([SurnameStudents]) > 0),
    [Rating] int not null  CHECK ([Rating] >= 0 and [Rating] < 5)

);
--6

CREATE Table GroupsLectures
(
    [Id] int identity(1, 1) PRIMARY KEY NOT NULL,
    [GroupsId] int NOT NULL FOREIGN KEY REFERENCES Groups(Id),
	[LectureId] int NOT NULL FOREIGN KEY REFERENCES Lectures(Id)

);

CREATE Table GroupsStudents
(
    [Id] int identity(1, 1) PRIMARY KEY NOT NULL,
    [GroupsId] int NOT NULL FOREIGN KEY REFERENCES Groups(Id),
	[StudentId] int NOT NULL FOREIGN KEY REFERENCES Students(Id)

);







