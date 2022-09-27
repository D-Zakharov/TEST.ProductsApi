use TestDb
go

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE Prd.FindProductVersions
	@ProductPartName nvarchar(255) null = null,
	@ProductVersionPartName nvarchar(255) null = null,
	@MinSize float null = null,
	@MaxSize float null = null
AS
BEGIN
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT pv.ID, pr.[Name], pv.[Name], pv.[Length], pv.Width, pv.Height
	from TestDb.[Prd].[Product] pr
	left join TestDb.[Prd].[ProductVersion] pv on pv.ProductID = pr.ID
	where 
	 (@ProductPartName is null or pr.[Name] like '%' + @ProductPartName + '%') and
	 (@ProductVersionPartName is null or pv.[Name] like '%' + @ProductVersionPartName + '%') and
	 (@MinSize is null or @MinSize <= pv.Height * pv.[Length] * pv.Width) and
	 (@MinSize is null or @MaxSize >= pv.Height * pv.[Length] * pv.Width)
END
GO