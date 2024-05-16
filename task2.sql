declare @User table(
Id int,
LName nvarchar(200),
FName nvarchar(200),
Tel nvarchar(15) null
);

declare @Territorys table(
Id int,
Name nvarchar(200),
ParentID int null
);

declare @Network table(
Id int,
Name nvarchar(200)
);

declare @Shop table(
Id int,
Name nvarchar(200),
CityId int,
NetworkId int
);

declare @Plan table(
Id int,
UserId int,
ShopId int,
DT date,
[PlanMin] int
);

declare @Fact table(
Id int identity(1,1),
PlanId int,
FactFrom int,
FactTo int
);


insert into @User(Id, LName, FName, Tel)
values (1, 'Иванов', 'Иван', '+7(123)1231212'), (2, 'Иванов', 'Вася', null);

insert into @Territorys(Id, Name, ParentID)
values (1, 'Moscow', null),
     (2, 'Москва', 1),
     (3, 'Владимир',   1),
     (4, 'Center', null),
     (5, 'Воронеж', 4),
     (6, 'Орел', 4);

insert into @Network(Id, Name)
values (1, 'ABK'),
     (2, 'Diksika'),
     (3, 'Orion');

insert into @Shop(Id, Name, CityId ,NetworkId)
values (1, 'Shop1', 2, 1),
     (2, 'Shop2', 2, 1),
     (3, 'Shop3', 2, 1),
     (4, 'Shop4', 2, 2),
     (5, 'Shop5', 2, 2),
     (6, 'Shop6', 3, 1),
     (7, 'Shop7', 3, 2),
     (8, 'Shop8', 5, 3),
     (9, 'Shop9', 5, 3),
     (10, 'Shop10', 5, 3),
     (11, 'Shop11', 6, 3);


insert into @Plan(Id, UserId, ShopId, DT, [PlanMin])
values (1, 1, 1, '01.04.2016', 60),
 (2, 1, 1, '02.04.2016', 70),
 (3, 1, 1, '03.04.2016', 60),
 (4, 1, 2, '01.04.2016', 30),
 (5, 1, 2, '02.04.2016', 180),
 (6, 1, 3, '01.04.2016', 120),
 (7, 1, 4, '01.04.2016', 60),
 (8, 1, 4, '02.04.2016', 90),
 (9, 1, 5, '01.04.2016', 60),

 (10, 2, 6, '01.04.2016', 55),
 (11, 2, 6, '02.04.2016', 33),
 (12, 2, 6, '03.04.2016', 60),
 (13, 2, 7, '01.04.2016', 22),
 (14, 2, 7, '02.04.2016', 123),
 (15, 2, 8, '01.04.2016', 120),
 (16, 2, 9, '01.04.2016', 70),
 (17, 2, 10, '02.04.2016', 90),
 (18, 2, 11, '01.04.2016', 65);


 insert into @Fact(PlanId, FactFrom, FactTo)
values (1, 0, 23),
 (2, 500, 600),
 (3, 33, 44),
 (4, 666, 785),
 (6, 1300, 1500),
 (7, 401, 480),
 (8, 720, 875),
 (10, 234, 432),
 (11, 1, 11),
 (12, 11, 111),
 (13, 22, 222),
 (15, 33, 333),
 (16, 44, 444);

SELECT
	(SELECT u.FName + ' ' + u.LName FROM @User AS u WHERE u.Id = plan0.UserId) AS Empl,
	(SELECT
		IIF(LEFT(CONVERT(varchar(5), DATEADD(minute, SUM(plan1.PlanMin), 0), 114), 1) = '0', RIGHT(CONVERT(varchar(5), DATEADD(minute, SUM(plan1.PlanMin), 0), 114), 4), CONVERT(varchar(5), DATEADD(minute, SUM(plan1.PlanMin), 0), 114))
		+ ' / ' +
		IIF(LEFT(CONVERT(varchar(5), DATEADD(minute, SUM(fact1.FactTo - fact1.FactFrom), 0), 114), 1) = '0', RIGHT(CONVERT(varchar(5), DATEADD(minute, SUM(fact1.FactTo - fact1.FactFrom), 0), 114), 4), CONVERT(varchar(5), DATEADD(minute, SUM(fact1.FactTo - fact1.FactFrom), 0), 114))
		FROM @Plan AS plan1 LEFT JOIN @Fact AS fact1 ON plan1.Id = fact1.PlanId WHERE plan1.DT = '01.04.2016' AND plan1.UserId = plan0.UserId)
	AS '01.04.2016',
	(SELECT
		IIF(LEFT(CONVERT(varchar(5), DATEADD(minute, SUM(plan2.PlanMin), 0), 114), 1) = '0', RIGHT(CONVERT(varchar(5), DATEADD(minute, SUM(plan2.PlanMin), 0), 114), 4), CONVERT(varchar(5), DATEADD(minute, SUM(plan2.PlanMin), 0), 114))
		+ ' / ' +
		IIF(LEFT(CONVERT(varchar(5), DATEADD(minute, SUM(fact2.FactTo - fact2.FactFrom), 0), 114), 1) = '0', RIGHT(CONVERT(varchar(5), DATEADD(minute, SUM(fact2.FactTo - fact2.FactFrom), 0), 114), 4), CONVERT(varchar(5), DATEADD(minute, SUM(fact2.FactTo - fact2.FactFrom), 0), 114))
		FROM @Plan AS plan2 LEFT JOIN @Fact AS fact2 ON plan2.Id = fact2.PlanId WHERE plan2.DT = '02.04.2016' AND plan2.UserId = plan0.UserId)
	AS '02.04.2016',
	(SELECT
		IIF(LEFT(CONVERT(varchar(5), DATEADD(minute, SUM(plan3.PlanMin), 0), 114), 1) = '0', RIGHT(CONVERT(varchar(5), DATEADD(minute, SUM(plan3.PlanMin), 0), 114), 4), CONVERT(varchar(5), DATEADD(minute, SUM(plan3.PlanMin), 0), 114))
		+ ' / ' +
		IIF(LEFT(CONVERT(varchar(5), DATEADD(minute, SUM(fact3.FactTo - fact3.FactFrom), 0), 114), 1) = '0', RIGHT(CONVERT(varchar(5), DATEADD(minute, SUM(fact3.FactTo - fact3.FactFrom), 0), 114), 4), CONVERT(varchar(5), DATEADD(minute, SUM(fact3.FactTo - fact3.FactFrom), 0), 114))
		FROM @Plan AS plan3 LEFT JOIN @Fact AS fact3 ON plan3.Id = fact3.PlanId WHERE plan3.DT = '03.04.2016' AND plan3.UserId = plan0.UserId)
	AS '03.04.2016'
FROM @Plan AS plan0
GROUP BY plan0.UserId
ORDER BY plan0.UserId DESC