USE [TestDb]
GO

declare @ProductItemsCount int = 5;
declare @ProductVersionsItemsCount int = 10;
--------------------------------------

WHILE @ProductItemsCount > 0
BEGIN
	declare @ProductId uniqueidentifier = newid();

	INSERT INTO [Prd].[Product] ([ID],[Name]) VALUES (@ProductId, 'Product ' + convert(nvarchar(10), @ProductItemsCount))

	declare @ProductVersionsCounter int = @ProductVersionsItemsCount;
	WHILE @ProductVersionsCounter > 0
	BEGIN
		INSERT INTO [Prd].[ProductVersion] ([ID],[ProductID],[Name],[Width],[Height],[Length]) 
		VALUES (newid(), @ProductId, 'Product version ' + convert(nvarchar(10), @ProductVersionsCounter)
				   ,@ProductVersionsCounter * 1.2
				   ,@ProductVersionsCounter * 1.1
				   ,@ProductVersionsCounter * 5)

		set @ProductVersionsCounter = @ProductVersionsCounter -1;
	END

    set @ProductItemsCount = @ProductItemsCount - 1;
END
