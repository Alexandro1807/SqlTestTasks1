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

DECLARE @xml XML;
SET @xml = (
  SELECT TOP(1)
		(SELECT reg0.Name AS Region,
			(SELECT IIF(LEFT(CONVERT(varchar(5), DATEADD(minute, (IIF (SUM(plan1.PlanMin) != 0, SUM(plan1.PlanMin), 0)), 0), 114), 1) = '0', RIGHT(CONVERT(varchar(5), DATEADD(minute, (IIF (SUM(plan1.PlanMin) != 0, SUM(plan1.PlanMin), 0)), 0), 114), 4), CONVERT(varchar(5), DATEADD(minute, (IIF (SUM(plan1.PlanMin) != 0, SUM(plan1.PlanMin), 0)), 0), 114))
			FROM @Territorys AS reg1
			INNER JOIN @Territorys AS city1 ON reg1.ID = city1.ParentId
			INNER JOIN @Shop AS shop1 ON city1.Id = shop1.CityId
			INNER JOIN @Network AS net1 ON shop1.NetworkId = net1.Id
			INNER JOIN @Plan AS plan1 ON shop1.Id = plan1.ShopId
			LEFT JOIN @Fact AS fact1 ON plan1.Id = fact1.PlanId
			WHERE reg1.Name = reg0.Name
			GROUP BY reg1.Name)
		AS PlanMin,
			(SELECT IIF(LEFT(CONVERT(varchar(5), DATEADD(minute, SUM(fact1.FactTo - fact1.FactFrom), 0), 114), 1) = '0', RIGHT(CONVERT(varchar(5), DATEADD(minute, SUM(fact1.FactTo - fact1.FactFrom), 0), 114), 4), CONVERT(varchar(5), DATEADD(minute, SUM(fact1.FactTo - fact1.FactFrom), 0), 114))
			FROM @Territorys AS reg1
			INNER JOIN @Territorys AS city1 ON reg1.ID = city1.ParentId
			INNER JOIN @Shop AS shop1 ON city1.Id = shop1.CityId
			INNER JOIN @Network AS net1 ON shop1.NetworkId = net1.Id
			INNER JOIN @Plan AS plan1 ON shop1.Id = plan1.ShopId
			LEFT JOIN @Fact AS fact1 ON plan1.Id = fact1.PlanId
			WHERE reg1.Name = reg0.Name
			GROUP BY reg1.Name)
		AS FactMin,
			(SELECT city1.Name AS City,
				(SELECT IIF(LEFT(CONVERT(varchar(5), DATEADD(minute, (IIF (SUM(plan2.PlanMin) != 0, SUM(plan2.PlanMin), 0)), 0), 114), 1) = '0', RIGHT(CONVERT(varchar(5), DATEADD(minute, (IIF (SUM(plan2.PlanMin) != 0, SUM(plan2.PlanMin), 0)), 0), 114), 4), CONVERT(varchar(5), DATEADD(minute, (IIF (SUM(plan2.PlanMin) != 0, SUM(plan2.PlanMin), 0)), 0), 114))
				FROM @Territorys AS reg2
				INNER JOIN @Territorys AS city2 ON reg2.ID = city2.ParentId
				INNER JOIN @Shop AS shop2 ON city2.Id = shop2.CityId
				INNER JOIN @Network AS net2 ON shop2.NetworkId = net2.Id
				INNER JOIN @Plan AS plan2 ON shop2.Id = plan2.ShopId
				LEFT JOIN @Fact AS fact2 ON plan2.Id = fact2.PlanId
				WHERE city2.Name = city1.Name
				GROUP BY city2.Name)
			AS PlanMin,
				(SELECT IIF(LEFT(CONVERT(varchar(5), DATEADD(minute, (IIF (SUM(fact2.FactTo - fact2.FactFrom) != 0, SUM(fact2.FactTo - fact2.FactFrom), 0)), 0), 114), 1) = '0', RIGHT(CONVERT(varchar(5), DATEADD(minute, (IIF (SUM(fact2.FactTo - fact2.FactFrom) != 0, SUM(fact2.FactTo - fact2.FactFrom), 0)), 0), 114), 4), CONVERT(varchar(5), DATEADD(minute, (IIF (SUM(fact2.FactTo - fact2.FactFrom) != 0, SUM(fact2.FactTo - fact2.FactFrom), 0)), 0), 114))
				FROM @Territorys AS reg2
				INNER JOIN @Territorys AS city2 ON reg2.ID = city2.ParentId
				INNER JOIN @Shop AS shop2 ON city2.Id = shop2.CityId
				INNER JOIN @Network AS net2 ON shop2.NetworkId = net2.Id
				INNER JOIN @Plan AS plan2 ON shop2.Id = plan2.ShopId
				LEFT JOIN @Fact AS fact2 ON plan2.Id = fact2.PlanId
				WHERE city2.Name = city1.Name
				GROUP BY city2.Name)
			AS FactMin,
				(SELECT net2.Name AS Network,
					(SELECT IIF(LEFT(CONVERT(varchar(5), DATEADD(minute, (IIF (SUM(plan3.PlanMin) != 0, SUM(plan3.PlanMin), 0)), 0), 114), 1) = '0', RIGHT(CONVERT(varchar(5), DATEADD(minute, (IIF (SUM(plan3.PlanMin) != 0, SUM(plan3.PlanMin), 0)), 0), 114), 4), CONVERT(varchar(5), DATEADD(minute, (IIF (SUM(plan3.PlanMin) != 0, SUM(plan3.PlanMin), 0)), 0), 114))
					FROM @Plan AS plan3
					LEFT JOIN @Shop AS shop3 ON plan3.ShopId = shop3.Id
					INNER JOIN @Network AS net3 ON shop3.NetworkId = net3.Id
					LEFT JOIN @Territorys AS city3 ON city3.Id = shop3.CityId
					WHERE net3.Name = net2.Name AND city3.Name = city1.Name)
				AS PlanMin,
					(SELECT IIF(LEFT(CONVERT(varchar(5), DATEADD(minute, (IIF (SUM(fact3.FactTo - fact3.FactFrom) != 0, SUM(fact3.FactTo - fact3.FactFrom), 0)), 0), 114), 1) = '0', RIGHT(CONVERT(varchar(5), DATEADD(minute, (IIF (SUM(fact3.FactTo - fact3.FactFrom) != 0, SUM(fact3.FactTo - fact3.FactFrom), 0)), 0), 114), 4), CONVERT(varchar(5), DATEADD(minute, (IIF (SUM(fact3.FactTo - fact3.FactFrom) != 0, SUM(fact3.FactTo - fact3.FactFrom), 0)), 0), 114))
					FROM @Territorys AS reg3
					INNER JOIN @Territorys AS city3 ON reg3.ID = city3.ParentId
					INNER JOIN @Shop AS shop3 ON city3.Id = shop3.CityId
					INNER JOIN @Network AS net3 ON shop3.NetworkId = net3.Id
					INNER JOIN @Plan AS plan3 ON shop3.Id = plan3.ShopId
					LEFT JOIN @Fact AS fact3 ON plan3.Id = fact3.PlanId
					WHERE net3.Name = net2.Name AND city3.Name = city1.Name)
				AS FactMin
				FROM @Territorys AS reg2
				INNER JOIN @Territorys AS city2 ON reg2.ID = city2.ParentId
				INNER JOIN @Shop AS shop2 ON city2.Id = shop2.CityId
				INNER JOIN @Network AS net2 ON shop2.NetworkId = net2.Id
				INNER JOIN @Plan AS plan2 ON shop2.Id = plan2.ShopId
				LEFT JOIN @Fact AS fact2 ON plan2.Id = fact2.PlanId
				WHERE city2.Name = city1.Name
				GROUP BY net2.Name
				FOR XML PATH('item'), TYPE) AS items
			FROM @Territorys AS reg1
			INNER JOIN @Territorys AS city1 ON reg1.ID = city1.ParentId
			INNER JOIN @Shop AS shop1 ON city1.Id = shop1.CityId
			INNER JOIN @Network AS net1 ON shop1.NetworkId = net1.Id
			INNER JOIN @Plan AS plan1 ON shop1.Id = plan1.ShopId
			LEFT JOIN @Fact AS fact1 ON plan1.Id = fact1.PlanId
			WHERE reg1.Name = reg0.Name
			GROUP BY city1.Name
			FOR XML PATH('item'), TYPE) AS items
		FROM @Territorys AS reg0
		INNER JOIN @Territorys AS city0 ON reg0.ID = city0.ParentId
		INNER JOIN @Shop AS shop0 ON city0.Id = shop0.CityId
		INNER JOIN @Network AS net0 ON shop0.NetworkId = net0.Id
		INNER JOIN @Plan AS plan0 ON shop0.Id = plan0.ShopId
		LEFT JOIN @Fact AS fact0 ON plan0.Id = fact0.PlanId
		WHERE reg0.ParentID is NULL
		GROUP BY reg0.Name
		ORDER BY reg0.Name
		FOR XML PATH('item'), TYPE) AS items
	FROM @Territorys AS reg
	GROUP BY reg.Name
	FOR XML PATH(''), TYPE
);
SELECT @xml