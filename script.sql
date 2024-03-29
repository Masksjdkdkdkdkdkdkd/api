USE [DB_Roster]
GO
/****** Object:  Table [dbo].[DayModel]    Script Date: 12/27/2022 7:51:51 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DayModel](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Code] [varchar](255) NOT NULL,
	[Name] [varchar](500) NOT NULL,
	[StartOrd] [float] NULL,
	[StopOrd] [float] NULL,
	[StopSot] [float] NULL,
	[Shift] [varchar](1) NULL,
	[LastModified] [date] NOT NULL,
 CONSTRAINT [PK_DayModelCW] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UQ_DayModelCW] UNIQUE NONCLUSTERED 
(
	[Code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EmployeeTime]    Script Date: 12/27/2022 7:51:51 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmployeeTime](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[EmployeeId] [varchar](100) NOT NULL,
	[LeaveType] [varchar](10) NOT NULL,
	[TimeType] [varchar](255) NULL,
	[StartDate] [date] NOT NULL,
	[EndDate] [date] NOT NULL,
	[LeaveReason] [varchar](4000) NOT NULL,
	[LeaveDays] [numeric](13, 0) NOT NULL,
	[WorkingDays] [numeric](13, 0) NULL,
	[LeaveAddress] [varchar](255) NOT NULL,
	[ApprovalStatus] [varchar](128) NOT NULL,
	[LastUpdateDate] [datetime] NULL,
 CONSTRAINT [PK_EmployeeTime] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EmpRoster]    Script Date: 12/27/2022 7:51:51 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmpRoster](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[EmployeeId] [varchar](100) NOT NULL,
	[RosterDate] [date] NOT NULL,
	[Shift] [varchar](10) NOT NULL,
	[RosterCode] [varchar](128) NULL,
	[ShiftCode] [varchar](10) NULL,
	[CurrentCoordinate] [int] NULL,
	[NumberOfDays] [int] NULL,
	[WorkCodes] [varchar](1000) NULL,
	[PatternStartDate] [date] NULL,
	[StartDate] [date] NULL,
	[EndDate] [date] NULL,
	[LastUpdateDate] [datetime] NULL,
	[DepartmentCode] [varchar](128) NOT NULL,
	[DepartmentName] [varchar](90) NOT NULL,
	[InputBy] [varchar](100) NOT NULL,
	[InputByName] [varchar](500) NOT NULL,
 CONSTRAINT [PK_EmpRoster] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UQ_EmpRoster] UNIQUE NONCLUSTERED 
(
	[EmployeeId] ASC,
	[RosterDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PayPoint]    Script Date: 12/27/2022 7:51:51 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PayPoint](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[EmployeeId] [varchar](100) NOT NULL,
	[PayLocationCode] [varchar](32) NULL,
	[PayLocation] [varchar](256) NULL,
	[LastUpdateDate] [datetime] NULL,
 CONSTRAINT [PK_PayPoint] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RoleMaster]    Script Date: 12/27/2022 7:51:51 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RoleMaster](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Role] [varchar](150) NULL,
	[Email] [varchar](250) NULL,
	[CreateDateTime] [datetime] NULL,
	[CreateBy] [varchar](250) NULL,
	[LastModifiedDateTime] [datetime] NULL,
	[LastModifiedBy] [varchar](250) NULL,
 CONSTRAINT [PK_RoleMaster] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DayModel] ADD  DEFAULT (getdate()) FOR [LastModified]
GO
ALTER TABLE [dbo].[EmployeeTime] ADD  DEFAULT (getdate()) FOR [LastUpdateDate]
GO
ALTER TABLE [dbo].[EmpRoster] ADD  DEFAULT (getdate()) FOR [LastUpdateDate]
GO
ALTER TABLE [dbo].[PayPoint] ADD  DEFAULT (getdate()) FOR [LastUpdateDate]
GO
/****** Object:  StoredProcedure [dbo].[UploadDataRoster]    Script Date: 12/27/2022 7:51:51 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [dbo].[UploadDataRoster](
@badgeid varchar(8), @rosterdate varchar(10), @shift varchar(1), @rostcode varchar(30), @deptcode varchar(8),  @deptname varchar(40), @inputby varchar(8), @inputname varchar(45)
)
AS
BEGIN
DECLARE @jumlah int;



select @jumlah = COUNT(*) FROM dbo.EmpRoster where EmployeeId =@badgeid and RosterDate =@rosterdate;
if @jumlah=0
   insert into EmpRoster values(rtrim(@badgeid),@rosterdate,@shift,rtrim(@rostcode),null,0,0,null,null,null,null,null,@deptcode,rtrim(@deptname), @inputby, rtrim(@inputname));
else
   update EmpRoster set Shift =@shift, RosterCode=rtrim(@rostcode) where EmployeeId =rtrim(@badgeid) and RosterDate =@rosterdate;

END

GO
