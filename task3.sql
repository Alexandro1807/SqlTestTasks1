declare @UserCredit table (
Id int IDENTITY(1,1),
UserId int,
Credit numeric(18,2)
);

insert into @UserCredit
values (1, 20), (2, 25);
  
declare @UserPurchase table (
Id int IDENTITY(1,1),
UserId int,
Cost numeric(18,2), 
DT date, 
Name varchar(50)
);

insert into @UserPurchase 
values
 (1, 5, '24.04.2016', 'sku1'),
 (1, 6, '19.04.2016', 'sku2'),
 (1, 7, '22.04.2016', 'sku3'),
 (1, 8, '04.04.2016', 'sku4'),
 (1, 4, '18.04.2016', 'sku5'),
 (1, 5, '18.04.2016', 'sku6'),
 (1, 2, '29.04.2016', 'sku7');
 insert into @UserPurchase 
values
 (2, 5, '24.04.2016', 'sku1'),
 (2, 6, '19.04.2016', 'sku2'),
 (2, 7, '22.04.2016', 'sku3'),
 (2, 8, '04.04.2016', 'sku4'),
 (2, 4, '18.04.2016', 'sku5'),
 (2, 2, '29.04.2016', 'sku7');

 SELECT Purc.UserId, CONVERT(varchar(10), Purc.DT, 120) AS DT, Purc.Name AS Name,
	(SELECT IIF((Cred.Credit - (SELECT SUM(Purc2.Cost) FROM @UserPurchase AS Purc2 WHERE Purc2.UserId = Cred.UserId AND Purc2.DT >= Purc.DT)) >= 0, Purc1.Cost, (Cred.Credit - (SELECT SUM(Purc2.Cost) FROM @UserPurchase AS Purc2 WHERE Purc2.UserId = Cred.UserId AND Purc2.DT > Purc.DT))) FROM @UserPurchase AS Purc1 WHERE Purc1.Id = Purc.Id) AS 'Purchase/Rest'
 FROM @UserPurchase AS Purc
 INNER JOIN @UserCredit AS Cred ON Cred.UserId = Purc.UserId
 EXCEPT
 SELECT Purc.UserId, CONVERT(varchar(10), Purc.DT, 120) AS DT, Purc.Name AS Name,
	(SELECT IIF((Cred.Credit - (SELECT SUM(Purc2.Cost) FROM @UserPurchase AS Purc2 WHERE Purc2.UserId = Cred.UserId AND Purc2.DT >= Purc.DT)) >= 0, Purc1.Cost, (Cred.Credit - (SELECT SUM(Purc2.Cost) FROM @UserPurchase AS Purc2 WHERE Purc2.UserId = Cred.UserId AND Purc2.DT > Purc.DT))) FROM @UserPurchase AS Purc1 WHERE Purc1.Id = Purc.Id) AS 'Purchase/Rest'
 FROM @UserPurchase AS Purc
 INNER JOIN @UserCredit AS Cred ON Cred.UserId = Purc.UserId
 WHERE (SELECT SUM(Purc2.Cost) FROM @UserPurchase AS Purc2 WHERE Purc2.UserId = Cred.UserId AND (Purc2.DT > Purc.DT OR (Purc2.DT = Purc.DT AND Purc2.Id > Purc.Id))) > Cred.Credit
 ORDER BY 1, 2 DESC