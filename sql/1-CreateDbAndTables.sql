﻿create database TestDb
go

use TestDb
go

create schema Prd
go

--------------------------

CREATE TABLE [Prd].[Product](
	[ID] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](255) NOT NULL,
	[Description] [nvarchar](max) NULL,
 CONSTRAINT [PK_Product] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_Name] UNIQUE NONCLUSTERED 
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

--------------------------

CREATE TABLE [Prd].[ProductVersion](
	[ID] [uniqueidentifier] NOT NULL,
	[ProductID] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](255) NOT NULL,
	[Description] [nvarchar](max) NULL,
	[CreatingDate] [datetime] NOT NULL,
	[Width] [float] NOT NULL,
	[Height] [float] NOT NULL,
	[Length] [float] NOT NULL,
	[TotalSize]  AS (([Width]*[Height])*[Length]) PERSISTED NOT NULL,

 CONSTRAINT [PK_ProductVersion] PRIMARY KEY CLUSTERED ([ID] ASC)
  WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 
 INDEX IND_PV_Name NONCLUSTERED ([Name]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF),
 INDEX IND_PV_Width NONCLUSTERED ([Width]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF),
 INDEX IND_PV_Height NONCLUSTERED ([Height]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF),
 INDEX IND_PV_Length NONCLUSTERED ([Length]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF),
 INDEX IND_PV_CreatingDate NONCLUSTERED ([CreatingDate]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF)
 INDEX IND_PV_TotalSize NONCLUSTERED ([TotalSize]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF)

) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [Prd].[ProductVersion] ADD  CONSTRAINT [DF_PV_Created]  DEFAULT (getdate()) FOR [CreatingDate]
GO

ALTER TABLE [Prd].[ProductVersion]  WITH CHECK ADD  CONSTRAINT [FK_ProductVersion_Product] FOREIGN KEY([ProductID])
REFERENCES [Prd].[Product] ([ID])
ON DELETE CASCADE
GO

ALTER TABLE [Prd].[ProductVersion] CHECK CONSTRAINT [FK_ProductVersion_Product]
GO

--------------------------

CREATE TABLE [Prd].[EventLog](
	[ID] [uniqueidentifier] NOT NULL,
	[EventDate] [datetime2] NOT NULL,
	[Description] [nvarchar](max) NULL,
 CONSTRAINT [PK_EventLog] PRIMARY KEY CLUSTERED ([ID] ASC)
  WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],

 INDEX IND_EL_EventDate NONCLUSTERED (EventDate) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF)
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [Prd].[EventLog] ADD  CONSTRAINT [DF_EL_EventDate]  DEFAULT (getdate()) FOR [EventDate]
GO


