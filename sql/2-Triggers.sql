use TestDb
go

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER Prd.ProductAfterInsert
   ON  [Prd].[Product]
   AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;

	declare @InsertedName nvarchar(255);
	select @InsertedName = inserted.[Name] from inserted;

    insert into [Prd].[EventLog] (ID, [Description])
	values (NEWID(), N'Создан новый продукт с именем "' + @InsertedName + '"')
END
GO

CREATE TRIGGER Prd.ProductAfterUpdate
   ON  [Prd].[Product]
   AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;

	declare @InsertedName nvarchar(255);
	declare @InsertedDescription nvarchar(max);
	select @InsertedName = inserted.[Name], @InsertedDescription = inserted.Description from inserted;

    insert into [Prd].[EventLog] (ID, [Description])
	values (NEWID(), N'Обновлен продукт с именем "' + @InsertedName + N'", новое описание: "' + @InsertedDescription + '"')
END
GO

CREATE TRIGGER Prd.ProductAfterDelete
   ON  [Prd].[Product]
   AFTER DELETE
AS 
BEGIN
	SET NOCOUNT ON;

    insert into [Prd].[EventLog] (ID, [Description])
	select NEWID(), N'Удален продукт с именем "' + deleted.[Name] + '"' from deleted
END
GO

-------------------------

CREATE TRIGGER Prd.ProductVersionAfterInsert
   ON  [Prd].[ProductVersion]
   AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;

	declare @ProductName nvarchar(255);
	declare @ProductID uniqueidentifier;
	declare @VersionName nvarchar(255);
	select @VersionName = inserted.[Name], @ProductID = inserted.ProductID from inserted;
	select @ProductName = pr.[Name] from [Prd].Product pr where pr.ID = @ProductID

    insert into [Prd].[EventLog] (ID, [Description])
	values (NEWID(), N'Создана новая версия продукта с именем "' + @ProductName + N'", наименование версии: "' + @VersionName + '"')
END
GO

CREATE TRIGGER Prd.ProductVersionAfterUpdate
   ON [Prd].[ProductVersion]
   AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;

	declare @ProductName nvarchar(255);
	declare @ProductID uniqueidentifier;
	declare @VersionName nvarchar(255);
	declare @Width float, @Height float, @Length float;
	
	select @VersionName = inserted.[Name], @ProductID = inserted.ProductID, 
	 @Width = inserted.Width, @Length = inserted.[Length], @Height = inserted.Height
	from inserted;
	
	select @ProductName = pr.[Name] from [Prd].Product pr where pr.ID = @ProductID

    insert into [Prd].[EventLog] (ID, [Description])
	values (NEWID(), N'Обновлена версия продукта с именем "' + @ProductName + N'", наименование версии: "' + @VersionName
					+ N'", ширина: ' + CONVERT(nvarchar(20), @Width)
					+ N', длина: ' + CONVERT(nvarchar(20), @Length)
					+ N', высота: ' + CONVERT(nvarchar(20), @Height))
END
GO

CREATE TRIGGER Prd.ProductVersionAfterDelete
   ON [Prd].[ProductVersion]
   AFTER DELETE
AS 
BEGIN
	SET NOCOUNT ON;

    insert into [Prd].[EventLog] (ID, [Description])
	select NEWID(), N'Удалена версия продукта, наименование версии: "' + deleted.[Name] + '"' from deleted
END
GO

