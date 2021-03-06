USE [ERP]
GO
/****** Object:  UserDefinedFunction [dbo].[Create_Column_Script]    Script Date: 10-Oct-18 5:34:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Function [dbo].[Create_Column_Script]
(
    @vsTableName varchar(50),
    @vsColumnName varchar(50)
)

Returns
    VarChar(Max)
--With ENCRYPTION

Begin

Declare @ScriptCommand varchar(Max)

Select @ScriptCommand =(SELECT 'ALTER TABLE '+TABLE_NAME+' ADD   [' + column_name + '] ' + 
             data_type + 
             (
                Case data_type
                    When 'sql_variant' 
                        Then ''
                    When 'text' 
                        Then ''
                    When 'decimal' 
                        Then '(' + Cast( numeric_precision_radix As varchar ) + ', ' + Cast( numeric_scale As varchar ) + ') '
                    Else Coalesce( '(' + 
                                        Case 
                                            When character_maximum_length = -1 
                                                Then 'MAX'
                                            Else Cast( character_maximum_length As VarChar ) 
                                        End + ')' , ''
                                 ) 
                End 
            ) 
            + ' ' +
            (
                Case 
                    When Exists ( 
                                    Select id 
                                    From syscolumns
                                    Where 
                                        ( object_name(id) =  @vsTableName )
                                        And 
                                        ( name = column_name )
                                        And 
                                        ( columnproperty(id,name,'IsIdentity') = 1 )
                                ) 
                        Then 'IDENTITY(' + 
                                Cast( ident_seed( @vsTableName) As varchar ) + ',' + 
                                Cast( ident_incr( @vsTableName) As varchar ) + ')'

                    Else ''

                End
            ) + ' ' +

            (
                Case 
                    When IS_NULLABLE = 'No' 
                        Then 'NOT ' 
                    Else '' 
                End 
            ) + 'NULL ' + 
            (
                Case 
                    When information_schema.columns.COLUMN_DEFAULT IS NOT NULL 
                        Then 'DEFAULT ' + information_schema.columns.COLUMN_DEFAULT 
                    ELse '' 
                End 
            )    From information_schema.columns WHERE table_name=@vsTableName AND column_name=@vsColumnName FOR XML PATH(''))
/*
Select @ScriptCommand =
    ' Create Table [' + SO.name + '] (' + o.list + ')' 
    +
    (
        Case
        When TC.Constraint_Name IS NULL 
            Then ''
        Else 'ALTER TABLE ' + SO.Name + ' ADD CONSTRAINT ' +
            TC.Constraint_Name  + ' PRIMARY KEY ' + ' (' + LEFT(j.List, Len(j.List)-1) + ')'
        End
    )
From sysobjects As SO
    Cross Apply

    (
        Select 
            '  [' + column_name + '] ' + 
             data_type + 
             (
                Case data_type
                    When 'sql_variant' 
                        Then ''
                    When 'text' 
                        Then ''
                    When 'decimal' 
                        Then '(' + Cast( numeric_precision_radix As varchar ) + ', ' + Cast( numeric_scale As varchar ) + ') '
                    Else Coalesce( '(' + 
                                        Case 
                                            When character_maximum_length = -1 
                                                Then 'MAX'
                                            Else Cast( character_maximum_length As VarChar ) 
                                        End + ')' , ''
                                 ) 
                End 
            ) 
            + ' ' +
            (
                Case 
                    When Exists ( 
                                    Select id 
                                    From syscolumns
                                    Where 
                                        ( object_name(id) = SO.name )
                                        And 
                                        ( name = column_name )
                                        And 
                                        ( columnproperty(id,name,'IsIdentity') = 1 )
                                ) 
                        Then 'IDENTITY(' + 
                                Cast( ident_seed(SO.name) As varchar ) + ',' + 
                                Cast( ident_incr(SO.name) As varchar ) + ')'

                    Else ''

                End
            ) + ' ' +

            (
                Case 
                    When IS_NULLABLE = 'No' 
                        Then 'NOT ' 
                    Else '' 
                End 
            ) + 'NULL ' + 
            (
                Case 
                    When information_schema.columns.COLUMN_DEFAULT IS NOT NULL 
                        Then 'DEFAULT ' + information_schema.columns.COLUMN_DEFAULT 
                    ELse '' 
                End 
            ) + ', ' 
        From information_schema.columns 
        Where 
            ( table_name = SO.name AND COLUMN_NAME= @vsColumnName) 
        Order by ordinal_position
        FOR XML PATH('')) o (list)

        Inner Join information_schema.table_constraints As TC On (
                                                                    ( TC.Table_name = SO.Name )
                                                                    AND 
                                                                    ( TC.Constraint_Type  = 'PRIMARY KEY' )
                                                                    And 
                                                                    ( TC.TABLE_NAME = @vsTableName )
                                                                 )
        Cross Apply
            (
                Select '[' + Column_Name + '], '
                From  information_schema.key_column_usage As kcu
                Where 
                    ( kcu.Constraint_Name = TC.Constraint_Name )
                Order By ORDINAL_POSITION
                FOR XML PATH('')
            ) As j (list)
Where
    ( xtype = 'U' )
    AND 
    ( Name NOT IN ('dtproperties') )
    */
Return @ScriptCommand

End
GO
/****** Object:  UserDefinedFunction [dbo].[Get_Table_Script]    Script Date: 10-Oct-18 5:34:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Function [dbo].[Get_Table_Script]
(
    @vsTableName varchar(50)
)

Returns
    VarChar(Max)
--With ENCRYPTION

Begin

Declare @ScriptCommand varchar(Max)

Select @ScriptCommand =
    ' Create Table [' + SO.name + '] (' + o.list + ')' 
    +
    (
        Case
        When TC.Constraint_Name IS NULL 
            Then ''
        Else 'ALTER TABLE ' + SO.Name + ' ADD CONSTRAINT ' +
            TC.Constraint_Name  + ' PRIMARY KEY ' + ' (' + LEFT(j.List, Len(j.List)-1) + ')'
        End
    )
From sysobjects As SO
    Cross Apply

    (
        Select 
            '  [' + column_name + '] ' + 
             data_type + 
             (
                Case data_type
                    When 'sql_variant' 
                        Then ''
                    When 'text' 
                        Then ''
                    When 'decimal' 
                        Then '(' + Cast( numeric_precision_radix As varchar ) + ', ' + Cast( numeric_scale As varchar ) + ') '
                    Else Coalesce( '(' + 
                                        Case 
                                            When character_maximum_length = -1 
                                                Then 'MAX'
                                            Else Cast( character_maximum_length As VarChar ) 
                                        End + ')' , ''
                                 ) 
                End 
            ) 
            + ' ' +
            (
                Case 
                    When Exists ( 
                                    Select id 
                                    From syscolumns
                                    Where 
                                        ( object_name(id) = SO.name )
                                        And 
                                        ( name = column_name )
                                        And 
                                        ( columnproperty(id,name,'IsIdentity') = 1 )
                                ) 
                        Then 'IDENTITY(' + 
                                Cast( ident_seed(SO.name) As varchar ) + ',' + 
                                Cast( ident_incr(SO.name) As varchar ) + ')'

                    Else ''

                End
            ) + ' ' +

            (
                Case 
                    When IS_NULLABLE = 'No' 
                        Then 'NOT ' 
                    Else '' 
                End 
            ) + 'NULL ' + 
            (
                Case 
                    When information_schema.columns.COLUMN_DEFAULT IS NOT NULL 
                        Then 'DEFAULT ' + information_schema.columns.COLUMN_DEFAULT 
                    ELse '' 
                End 
            ) + ', ' 
        From information_schema.columns 
        Where 
            ( table_name = SO.name )
        Order by ordinal_position
        FOR XML PATH('')) o (list)

        Inner Join information_schema.table_constraints As TC On (
                                                                    ( TC.Table_name = SO.Name )
                                                                    AND 
                                                                    ( TC.Constraint_Type  = 'PRIMARY KEY' )
                                                                    And 
                                                                    ( TC.TABLE_NAME = @vsTableName )
                                                                 )
        Cross Apply
            (
                Select '[' + Column_Name + '], '
                From  information_schema.key_column_usage As kcu
                Where 
                    ( kcu.Constraint_Name = TC.Constraint_Name )
                Order By ORDINAL_POSITION
                FOR XML PATH('')
            ) As j (list)
Where
    ( xtype = 'U' )
    AND 
    ( Name NOT IN ('dtproperties') )

Return @ScriptCommand

End
GO
/****** Object:  Table [dbo].[AccountMaster]    Script Date: 10-Oct-18 5:34:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[AccountMaster](
	[AccountMasterId] [bigint] IDENTITY(1,1) NOT NULL,
	[AccountName] [varchar](50) NOT NULL,
	[GroupMasterId] [bigint] NULL,
	[HistoryMasterId] [bigint] NULL,
 CONSTRAINT [PK_AccountMaster_AccountMasterId] PRIMARY KEY CLUSTERED 
(
	[AccountMasterId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[AnnualMaster]    Script Date: 10-Oct-18 5:34:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[AnnualMaster](
	[AnnualMasterId] [bigint] IDENTITY(1,1) NOT NULL,
	[AnnualName] [varchar](50) NOT NULL,
 CONSTRAINT [PK_AnnualMaster_AnnualMasterId] PRIMARY KEY CLUSTERED 
(
	[AnnualMasterId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Audit]    Script Date: 10-Oct-18 5:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Audit](
	[AuditID] [bigint] IDENTITY(1,1) NOT NULL,
	[Type] [char](1) NULL,
	[TableName] [varchar](128) NULL,
	[PrimaryKeyField] [varchar](1000) NULL,
	[PrimaryKeyValue] [varchar](1000) NULL,
	[FieldName] [varchar](128) NULL,
	[OldValue] [varchar](1000) NULL,
	[NewValue] [varchar](1000) NULL,
	[UpdateDate] [datetime] NULL CONSTRAINT [DF__Audit__UpdateDat__5772F790]  DEFAULT (getdate()),
	[UserName] [varchar](128) NULL,
 CONSTRAINT [PK_Audit] PRIMARY KEY CLUSTERED 
(
	[AuditID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[CompanyMaster]    Script Date: 10-Oct-18 5:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CompanyMaster](
	[CompanyMasterId] [bigint] IDENTITY(1,1) NOT NULL,
	[CompanyName] [varchar](50) NOT NULL,
	[CompanyAddress] [varchar](50) NOT NULL,
	[CompanyLandMark] [varchar](50) NOT NULL,
	[CompanyCity] [varchar](50) NOT NULL,
	[CompanyState] [varchar](50) NOT NULL,
	[CompanyEmail] [varchar](50) NOT NULL,
	[CompanyGST] [varchar](50) NOT NULL,
	[CompanyWebUrl] [varchar](50) NOT NULL,
	[CompanyMobile] [varchar](50) NOT NULL,
 CONSTRAINT [PK_CompanyMaster_CompanyMasterId] PRIMARY KEY CLUSTERED 
(
	[CompanyMasterId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[DrCrMaster]    Script Date: 10-Oct-18 5:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[DrCrMaster](
	[DrCrMasterId] [bigint] IDENTITY(1,1) NOT NULL,
	[DrCrShortName] [varchar](10) NULL,
	[DrCrFullName] [varchar](10) NULL,
 CONSTRAINT [PK_DrCrMaster_DrCrMasterId] PRIMARY KEY CLUSTERED 
(
	[DrCrMasterId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[FormMaster]    Script Date: 10-Oct-18 5:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[FormMaster](
	[FormMasterId] [bigint] IDENTITY(1,1) NOT NULL,
	[FormName] [varchar](50) NULL,
	[FormTypeId] [bigint] NOT NULL,
 CONSTRAINT [PK_FormMaster_FormMasterId] PRIMARY KEY CLUSTERED 
(
	[FormMasterId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[FormType]    Script Date: 10-Oct-18 5:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[FormType](
	[FormTypeId] [bigint] IDENTITY(1,1) NOT NULL,
	[FormTypeName] [varchar](50) NULL,
 CONSTRAINT [PK_FormType_FormTypeId] PRIMARY KEY CLUSTERED 
(
	[FormTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[GodownMaster]    Script Date: 10-Oct-18 5:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[GodownMaster](
	[GodownMasterId] [bigint] IDENTITY(1,1) NOT NULL,
	[GodownName] [varchar](50) NULL,
 CONSTRAINT [PK_GodownMaster_GodownMasterId] PRIMARY KEY CLUSTERED 
(
	[GodownMasterId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[GroupMaster]    Script Date: 10-Oct-18 5:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[GroupMaster](
	[GroupMasterId] [bigint] IDENTITY(1,1) NOT NULL,
	[GroupName] [varchar](50) NOT NULL,
	[AnnualMasterId] [bigint] NOT NULL,
	[CrDrMasterId] [bigint] NOT NULL,
 CONSTRAINT [PK_GroupMaster_GroupMasterId] PRIMARY KEY CLUSTERED 
(
	[GroupMasterId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[HistoryDelete]    Script Date: 10-Oct-18 5:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HistoryDelete](
	[HistoryDeleteId] [bigint] IDENTITY(1,1) NOT NULL,
	[HistoryDetailsId] [bigint] NULL,
	[HistoryMasterId] [bigint] NULL,
	[Query] [text] NULL,
 CONSTRAINT [PK_HistoryDelete_HistoryDeleteId] PRIMARY KEY CLUSTERED 
(
	[HistoryDeleteId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[HistoryDetails]    Script Date: 10-Oct-18 5:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[HistoryDetails](
	[HistoryDetailsId] [bigint] IDENTITY(1,1) NOT NULL,
	[HistoryMasterId] [bigint] NULL,
	[TableName] [varchar](50) NULL,
	[TableNameId] [bigint] NULL,
	[RowStatusId] [bigint] NULL,
 CONSTRAINT [PK_HistoryDetails_HistoryDetailsId] PRIMARY KEY CLUSTERED 
(
	[HistoryDetailsId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[HistoryMaster]    Script Date: 10-Oct-18 5:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[HistoryMaster](
	[HistoryMasterId] [bigint] IDENTITY(1,1) NOT NULL,
	[SessionMasterId] [bigint] NULL,
	[Description] [varchar](50) NULL,
	[Dated] [datetime] NULL,
	[HistoryStatus] [smallint] NULL,
 CONSTRAINT [PK_HistoryMaster_HistoryMasterId] PRIMARY KEY CLUSTERED 
(
	[HistoryMasterId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[HistoryUpdate]    Script Date: 10-Oct-18 5:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[HistoryUpdate](
	[HistoryUpdateId] [bigint] IDENTITY(1,1) NOT NULL,
	[HistoryDetailsId] [bigint] NULL,
	[HistoryMasterId] [bigint] NULL,
	[FieldName] [varchar](128) NULL,
	[OldValue] [nvarchar](1000) NULL,
	[NewValue] [nvarchar](1000) NULL,
 CONSTRAINT [PK_HistoryUpdate_HistoryUpdateId] PRIMARY KEY CLUSTERED 
(
	[HistoryUpdateId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ItemMaster]    Script Date: 10-Oct-18 5:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ItemMaster](
	[ItemMasterId] [bigint] IDENTITY(1,1) NOT NULL,
	[ItemName] [varchar](50) NULL,
	[PurRate] [money] NULL,
	[SaleRate] [money] NULL,
	[GstRate] [float] NULL,
	[UnitMasterId] [bigint] NULL,
 CONSTRAINT [PK_ItemMaster_ItemMasterId] PRIMARY KEY CLUSTERED 
(
	[ItemMasterId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ItemUnitMaster]    Script Date: 10-Oct-18 5:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ItemUnitMaster](
	[ItemUnitMasterId] [bigint] IDENTITY(1,1) NOT NULL,
	[Srno] [int] NOT NULL,
	[ItemMasterId] [bigint] NOT NULL,
	[UnitMasterId] [bigint] NOT NULL,
	[Ratio] [float] NOT NULL,
 CONSTRAINT [PK_ItemUnitMaster_ItemUnitMasterId] PRIMARY KEY CLUSTERED 
(
	[ItemUnitMasterId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[MenuMaster]    Script Date: 10-Oct-18 5:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[MenuMaster](
	[MenuMasterId] [bigint] IDENTITY(1,1) NOT NULL,
	[MenuId] [bigint] NOT NULL,
	[ChildId] [bigint] NOT NULL,
	[MenuName] [varchar](50) NULL,
	[FormTypeId] [bigint] NOT NULL,
 CONSTRAINT [PK_MenuMaster_MenuMasterId] PRIMARY KEY CLUSTERED 
(
	[MenuMasterId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[RowStatus]    Script Date: 10-Oct-18 5:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[RowStatus](
	[RowStatusId] [bigint] IDENTITY(1,1) NOT NULL,
	[RowStatusName] [varchar](50) NULL,
 CONSTRAINT [PK_RowStatus_RowStatusId] PRIMARY KEY CLUSTERED 
(
	[RowStatusId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[SessionMaster]    Script Date: 10-Oct-18 5:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SessionMaster](
	[SessionMasterId] [bigint] IDENTITY(1,1) NOT NULL,
	[UserMasterId] [bigint] NULL,
	[StartTime] [datetime] NULL,
	[EndTime] [datetime] NULL,
	[Active] [bit] NULL,
 CONSTRAINT [PK_SessionMaster_SessionMasterId] PRIMARY KEY CLUSTERED 
(
	[SessionMasterId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[TranDetails]    Script Date: 10-Oct-18 5:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TranDetails](
	[TranDetailsId] [bigint] IDENTITY(1,1) NOT NULL,
	[TranMainId] [bigint] NULL,
	[SrNo] [int] NULL,
	[DrCrMasterId] [bigint] NULL,
	[AccountMasterId] [bigint] NULL,
	[Amount] [money] NULL,
	[bankdate] [date] NULL,
	[Remarks] [varchar](500) NULL,
 CONSTRAINT [PK_TranDetails_TranDetailsId] PRIMARY KEY CLUSTERED 
(
	[TranDetailsId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TranInventory]    Script Date: 10-Oct-18 5:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TranInventory](
	[TranInventoryId] [bigint] IDENTITY(1,1) NOT NULL,
	[TranMainId] [bigint] NULL,
	[TranDetailsId] [bigint] NULL,
	[ItemMasterId] [bigint] NULL,
	[Quantity] [float] NULL,
	[QuantityItemUnitMasterId] [bigint] NULL,
	[Rate] [money] NULL,
	[RateItemUnitMasterId] [bigint] NULL,
	[Ratio] [float] NOT NULL,
	[DiscountAmount] [money] NULL,
	[Amount] [money] NULL,
	[GSTAmount] [money] NULL,
	[Total] [money] NULL,
	[Remarks] [varchar](500) NULL,
	[GodownMasterId] [bigint] NULL,
 CONSTRAINT [PK_TranInventory_TranInventoryId] PRIMARY KEY CLUSTERED 
(
	[TranInventoryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TranInvGST]    Script Date: 10-Oct-18 5:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TranInvGST](
	[TranInvGSTId] [bigint] IDENTITY(1,1) NOT NULL,
	[TranInventoryId] [bigint] NULL,
	[TranDetails] [bigint] NULL,
	[TranMain] [bigint] NULL,
	[GSTRate] [float] NULL,
	[GSTAmount] [money] NULL,
	[Remarks] [varchar](500) NULL,
 CONSTRAINT [PK_TranInvGST_TranInvGSTId] PRIMARY KEY CLUSTERED 
(
	[TranInvGSTId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TranMain]    Script Date: 10-Oct-18 5:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TranMain](
	[TranMainId] [bigint] IDENTITY(1,1) NOT NULL,
	[BillNo] [varchar](50) NULL,
	[InvoiceNo] [varchar](50) NULL,
	[InvoiceDate] [varchar](50) NULL,
	[TranDate] [datetime] NULL,
	[Remarks] [varchar](500) NULL,
	[TypeMasterId] [bigint] NULL,
	[YearMasterId] [bigint] NULL,
	[CompanyMasterId] [bigint] NULL,
 CONSTRAINT [PK_TranMain_TranMainId] PRIMARY KEY CLUSTERED 
(
	[TranMainId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TypeMaster]    Script Date: 10-Oct-18 5:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TypeMaster](
	[TypeMasterId] [bigint] IDENTITY(1,1) NOT NULL,
	[TypeShortName] [varchar](10) NOT NULL,
	[TypeFullName] [varchar](50) NOT NULL,
	[DrAccountMasterId] [bigint] NULL,
	[CrAccountMasterId] [bigint] NULL,
	[DrGroupMasterId] [bigint] NULL,
	[CrGroupMasterId] [bigint] NULL,
	[Remarks] [varchar](500) NULL,
 CONSTRAINT [PK_TypeMaster_TypeMasterId] PRIMARY KEY CLUSTERED 
(
	[TypeMasterId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[UnitMaster]    Script Date: 10-Oct-18 5:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[UnitMaster](
	[UnitMasterId] [bigint] IDENTITY(1,1) NOT NULL,
	[UnitName] [varchar](50) NULL,
 CONSTRAINT [PK_UnitMaster_UnitMasterId] PRIMARY KEY CLUSTERED 
(
	[UnitMasterId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[UserMaster]    Script Date: 10-Oct-18 5:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[UserMaster](
	[UserMasterId] [bigint] IDENTITY(1,1) NOT NULL,
	[UserName] [varchar](50) NOT NULL,
	[Password] [varbinary](50) NOT NULL,
	[Email] [varchar](50) NULL,
	[Phone] [varchar](50) NULL,
	[IsActive] [bit] NOT NULL,
 CONSTRAINT [PK_UserMaster_UserMasterId] PRIMARY KEY CLUSTERED 
(
	[UserMasterId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[YearMaster]    Script Date: 10-Oct-18 5:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[YearMaster](
	[YearMasterId] [bigint] IDENTITY(1,1) NOT NULL,
	[CompanyMasterId] [bigint] NOT NULL,
	[YearName] [varchar](50) NULL,
	[YearStartDate] [date] NULL,
	[YearEndDate] [date] NULL,
 CONSTRAINT [PK_YearMaster_YearMasterId] PRIMARY KEY CLUSTERED 
(
	[YearMasterId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  View [dbo].[vwAccountDetails]    Script Date: 10-Oct-18 5:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwAccountDetails]
AS
SELECT        dbo.AccountMaster.AccountMasterId, dbo.AccountMaster.AccountName, dbo.TranDetails.Amount
FROM            dbo.AccountMaster INNER JOIN
                         dbo.TranDetails ON dbo.AccountMaster.AccountMasterId = dbo.TranDetails.AccountMasterId

GO
/****** Object:  View [dbo].[vwAccountMaster]    Script Date: 10-Oct-18 5:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[vwAccountMaster]
AS



SELECT        AM.AccountMasterId, AM.AccountName,  SUM(TD.Amount) AS Balance
FROM            dbo.AccountMaster  AM
INNER JOIN
                         dbo.TranDetails TD ON AM.AccountMasterId = TD.AccountMasterId
				    GROUP BY AM.AccountMasterId, AM.AccountName


GO
/****** Object:  View [dbo].[vwItemDetails]    Script Date: 10-Oct-18 5:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwItemDetails]
AS
SELECT        dbo.ItemMaster.ItemMasterId, dbo.ItemMaster.ItemName, dbo.TranInventory.Quantity, dbo.TranInventory.Rate, dbo.TranInventory.DiscountAmount, dbo.TranInventory.GSTAmount, dbo.TranInventory.Total, 
                         dbo.TranInventory.Remarks, dbo.TranInventory.GodownMasterId
FROM            dbo.ItemMaster INNER JOIN
                         dbo.TranInventory ON dbo.ItemMaster.ItemMasterId = dbo.TranInventory.ItemMasterId

GO
/****** Object:  View [dbo].[vwItemMaster]    Script Date: 10-Oct-18 5:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwItemMaster]
AS
SELECT        ItemMasterId, ItemName, PurRate, SaleRate, GstRate, UnitMasterId
FROM            dbo.ItemMaster

GO
ALTER TABLE [dbo].[ItemUnitMaster] ADD  CONSTRAINT [DF_ItemUnitMaster_Ratio]  DEFAULT ((1)) FOR [Ratio]
GO
ALTER TABLE [dbo].[TranInventory] ADD  CONSTRAINT [DF_TranInventory_Ratio]  DEFAULT ((1)) FOR [Ratio]
GO
ALTER TABLE [dbo].[UserMaster] ADD  CONSTRAINT [DF_UserMaster_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[AccountMaster]  WITH CHECK ADD  CONSTRAINT [FK_GroupMaster_GroupMasterId] FOREIGN KEY([GroupMasterId])
REFERENCES [dbo].[GroupMaster] ([GroupMasterId])
GO
ALTER TABLE [dbo].[AccountMaster] CHECK CONSTRAINT [FK_GroupMaster_GroupMasterId]
GO
ALTER TABLE [dbo].[FormMaster]  WITH CHECK ADD  CONSTRAINT [FK_FormType_FormTypeId] FOREIGN KEY([FormTypeId])
REFERENCES [dbo].[FormType] ([FormTypeId])
GO
ALTER TABLE [dbo].[FormMaster] CHECK CONSTRAINT [FK_FormType_FormTypeId]
GO
ALTER TABLE [dbo].[GroupMaster]  WITH CHECK ADD  CONSTRAINT [FK_AnnualMaster_AnnualMasterId] FOREIGN KEY([AnnualMasterId])
REFERENCES [dbo].[AnnualMaster] ([AnnualMasterId])
GO
ALTER TABLE [dbo].[GroupMaster] CHECK CONSTRAINT [FK_AnnualMaster_AnnualMasterId]
GO
ALTER TABLE [dbo].[HistoryDetails]  WITH CHECK ADD  CONSTRAINT [FK_RowStatus_RowStatusId] FOREIGN KEY([RowStatusId])
REFERENCES [dbo].[RowStatus] ([RowStatusId])
GO
ALTER TABLE [dbo].[HistoryDetails] CHECK CONSTRAINT [FK_RowStatus_RowStatusId]
GO
ALTER TABLE [dbo].[HistoryUpdate]  WITH CHECK ADD  CONSTRAINT [FK_HistoryDetails_HistoryDetailsId] FOREIGN KEY([HistoryDetailsId])
REFERENCES [dbo].[HistoryDetails] ([HistoryDetailsId])
GO
ALTER TABLE [dbo].[HistoryUpdate] CHECK CONSTRAINT [FK_HistoryDetails_HistoryDetailsId]
GO
ALTER TABLE [dbo].[ItemMaster]  WITH CHECK ADD  CONSTRAINT [FK_UnitMaster_UnitMasterId] FOREIGN KEY([UnitMasterId])
REFERENCES [dbo].[UnitMaster] ([UnitMasterId])
GO
ALTER TABLE [dbo].[ItemMaster] CHECK CONSTRAINT [FK_UnitMaster_UnitMasterId]
GO
ALTER TABLE [dbo].[SessionMaster]  WITH CHECK ADD  CONSTRAINT [FK_UserMaster_UserMasterId] FOREIGN KEY([UserMasterId])
REFERENCES [dbo].[UserMaster] ([UserMasterId])
GO
ALTER TABLE [dbo].[SessionMaster] CHECK CONSTRAINT [FK_UserMaster_UserMasterId]
GO
ALTER TABLE [dbo].[TranDetails]  WITH CHECK ADD  CONSTRAINT [FK_DrCrMaster_DrCrMasterId] FOREIGN KEY([DrCrMasterId])
REFERENCES [dbo].[DrCrMaster] ([DrCrMasterId])
GO
ALTER TABLE [dbo].[TranDetails] CHECK CONSTRAINT [FK_DrCrMaster_DrCrMasterId]
GO
ALTER TABLE [dbo].[TranDetails]  WITH CHECK ADD  CONSTRAINT [FK_TranMain_TranMainId] FOREIGN KEY([TranMainId])
REFERENCES [dbo].[TranMain] ([TranMainId])
GO
ALTER TABLE [dbo].[TranDetails] CHECK CONSTRAINT [FK_TranMain_TranMainId]
GO
ALTER TABLE [dbo].[TranInventory]  WITH CHECK ADD  CONSTRAINT [FK_GodownMaster_GodownMasterId] FOREIGN KEY([GodownMasterId])
REFERENCES [dbo].[GodownMaster] ([GodownMasterId])
GO
ALTER TABLE [dbo].[TranInventory] CHECK CONSTRAINT [FK_GodownMaster_GodownMasterId]
GO
ALTER TABLE [dbo].[TranInventory]  WITH CHECK ADD  CONSTRAINT [FK_ItemMaster_ItemMasterId] FOREIGN KEY([ItemMasterId])
REFERENCES [dbo].[ItemMaster] ([ItemMasterId])
GO
ALTER TABLE [dbo].[TranInventory] CHECK CONSTRAINT [FK_ItemMaster_ItemMasterId]
GO
ALTER TABLE [dbo].[TranInventory]  WITH CHECK ADD  CONSTRAINT [FK_ItemUnitMaster_QuantityItemUnitMasterId] FOREIGN KEY([QuantityItemUnitMasterId])
REFERENCES [dbo].[ItemUnitMaster] ([ItemUnitMasterId])
GO
ALTER TABLE [dbo].[TranInventory] CHECK CONSTRAINT [FK_ItemUnitMaster_QuantityItemUnitMasterId]
GO
ALTER TABLE [dbo].[TranInventory]  WITH CHECK ADD  CONSTRAINT [FK_ItemUnitMaster_RateItemUnitMasterId] FOREIGN KEY([RateItemUnitMasterId])
REFERENCES [dbo].[ItemUnitMaster] ([ItemUnitMasterId])
GO
ALTER TABLE [dbo].[TranInventory] CHECK CONSTRAINT [FK_ItemUnitMaster_RateItemUnitMasterId]
GO
ALTER TABLE [dbo].[TranInventory]  WITH CHECK ADD  CONSTRAINT [FK_TranDetails_TranDetailsId] FOREIGN KEY([TranDetailsId])
REFERENCES [dbo].[TranDetails] ([TranDetailsId])
GO
ALTER TABLE [dbo].[TranInventory] CHECK CONSTRAINT [FK_TranDetails_TranDetailsId]
GO
ALTER TABLE [dbo].[TranInventory]  WITH CHECK ADD  CONSTRAINT [FK_UnitMaster_QuantityItemUnitMasterId] FOREIGN KEY([QuantityItemUnitMasterId])
REFERENCES [dbo].[UnitMaster] ([UnitMasterId])
GO
ALTER TABLE [dbo].[TranInventory] CHECK CONSTRAINT [FK_UnitMaster_QuantityItemUnitMasterId]
GO
ALTER TABLE [dbo].[TranInventory]  WITH CHECK ADD  CONSTRAINT [FK_UnitMaster_RateItemUnitMasterId] FOREIGN KEY([RateItemUnitMasterId])
REFERENCES [dbo].[UnitMaster] ([UnitMasterId])
GO
ALTER TABLE [dbo].[TranInventory] CHECK CONSTRAINT [FK_UnitMaster_RateItemUnitMasterId]
GO
ALTER TABLE [dbo].[TranInvGST]  WITH CHECK ADD  CONSTRAINT [FK_TranInventory_TranInventoryId] FOREIGN KEY([TranInventoryId])
REFERENCES [dbo].[TranInventory] ([TranInventoryId])
GO
ALTER TABLE [dbo].[TranInvGST] CHECK CONSTRAINT [FK_TranInventory_TranInventoryId]
GO
ALTER TABLE [dbo].[TranMain]  WITH CHECK ADD  CONSTRAINT [FK_CompanyMaster_CompanyMasterId] FOREIGN KEY([CompanyMasterId])
REFERENCES [dbo].[CompanyMaster] ([CompanyMasterId])
GO
ALTER TABLE [dbo].[TranMain] CHECK CONSTRAINT [FK_CompanyMaster_CompanyMasterId]
GO
ALTER TABLE [dbo].[TranMain]  WITH CHECK ADD  CONSTRAINT [FK_TypeMaster_TypeMasterId] FOREIGN KEY([TypeMasterId])
REFERENCES [dbo].[TypeMaster] ([TypeMasterId])
GO
ALTER TABLE [dbo].[TranMain] CHECK CONSTRAINT [FK_TypeMaster_TypeMasterId]
GO
ALTER TABLE [dbo].[TranMain]  WITH CHECK ADD  CONSTRAINT [FK_YearMaster_YearMasterId] FOREIGN KEY([YearMasterId])
REFERENCES [dbo].[YearMaster] ([YearMasterId])
GO
ALTER TABLE [dbo].[TranMain] CHECK CONSTRAINT [FK_YearMaster_YearMasterId]
GO
ALTER TABLE [dbo].[TypeMaster]  WITH CHECK ADD  CONSTRAINT [FK_GroupMaster_CrGroupMasterId] FOREIGN KEY([CrGroupMasterId])
REFERENCES [dbo].[GroupMaster] ([GroupMasterId])
GO
ALTER TABLE [dbo].[TypeMaster] CHECK CONSTRAINT [FK_GroupMaster_CrGroupMasterId]
GO
ALTER TABLE [dbo].[TypeMaster]  WITH CHECK ADD  CONSTRAINT [FK_GroupMaster_DrGroupMasterId] FOREIGN KEY([DrGroupMasterId])
REFERENCES [dbo].[GroupMaster] ([GroupMasterId])
GO
ALTER TABLE [dbo].[TypeMaster] CHECK CONSTRAINT [FK_GroupMaster_DrGroupMasterId]
GO
/****** Object:  StoredProcedure [dbo].[Missing]    Script Date: 10-Oct-18 5:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Missing] 

AS
BEGIN

--Missing Primary Key
SELECT c.name, b.name 
FROM sys.tables b 
INNER JOIN sys.schemas c ON b.schema_id = c.schema_id 
WHERE b.type = 'U' 
AND NOT EXISTS
(SELECT a.name 
FROM sys.key_constraints a 
WHERE a.parent_object_id = b.OBJECT_ID 
AND a.schema_id = c.schema_id 
AND a.type = 'PK' )
--Missing identiy Column
SELECT  t.TABLE_NAME,  OBJECT_NAME(OBJECT_ID) AS TABLENAME,
         NAME AS COLUMNNAME,
         SEED_VALUE,
         INCREMENT_VALUE,
         LAST_VALUE,
         IS_NOT_FOR_REPLICATION,*
FROM     SYS.IDENTITY_COLUMNS c
right JOIN INFORMATION_SCHEMA.TABLES t 
ON t.TABLE_NAME=OBJECT_NAME(c.OBJECT_ID) 
WHERE  c.Name is NULL AND t.TABLE_TYPE='BASE TABLE'
--Wrong Primary Key
SELECT  'ALTER TABLE '+ OBJECT_NAME(ic.OBJECT_ID)+' DROP CONSTRAINT '+i.name+'', 
'ALTER TABLE '+ OBJECT_NAME(ic.OBJECT_ID)+' ADD CONSTRAINT PK_'+OBJECT_NAME(ic.OBJECT_ID)+'_'+  COL_NAME(ic.OBJECT_ID,ic.column_id)+'  PRIMARY KEY CLUSTERED ('+ COL_NAME(ic.OBJECT_ID,ic.column_id)+' ASC)', 
 i.name AS IndexName,
        OBJECT_NAME(ic.OBJECT_ID) AS TableName,
        COL_NAME(ic.OBJECT_ID,ic.column_id) AS ColumnName
FROM    sys.indexes AS i INNER JOIN 
        sys.index_columns AS ic ON  i.OBJECT_ID = ic.OBJECT_ID
                                AND i.index_id = ic.index_id
						  WHERE   i.is_primary_key = 1
						  AND i.name<>'PK_'+OBJECT_NAME(ic.OBJECT_ID)+'_'+  COL_NAME(ic.OBJECT_ID,ic.column_id)
						

--Missing Foregin Key
/*
SELECT c.COLUMN_NAME,c.TABLE_NAME, *  FROM INFORMATION_SCHEMA.COLUMNS c
INNER JOIN 

(SELECT  i.name AS IndexName,
        OBJECT_NAME(ic.OBJECT_ID) AS TableName,
        COL_NAME(ic.OBJECT_ID,ic.column_id) AS ColumnName
FROM    sys.indexes AS i INNER JOIN 
        sys.index_columns AS ic ON  i.OBJECT_ID = ic.OBJECT_ID
                                AND i.index_id = ic.index_id
						  WHERE   i.is_primary_key = 1
						  ) e
						  ON e.ColumnName=c.COLUMN_NAME
						  AND e.TableName<>c.TABLE_NAME
						  */


SELECT 'ALTER TABLE  '+c.TABLE_NAME+'    ADD CONSTRAINT FK_'+t.TABLE_NAME+'_'+c.COLUMN_NAME+' FOREIGN KEY ('+c.COLUMN_NAME+')         REFERENCES   '+t.TABLE_NAME+'('+t.TABLE_NAME+'Id)',  * 
 FROM INFORMATION_SCHEMA.COLUMNS c 
 INNER JOIN INFORMATION_SCHEMA.TABLES t ON c.COLUMN_NAME LIKE '%'+t.TABLE_NAME+'%' 
 WHERE  c.DATA_TYPE='bigint' AND c.COLUMN_NAME LIKE '%Id'
 --AND c.IS_NULLABLE='NO'
AND c.TABLE_NAME+'Id'<>c.COLUMN_NAME
AND NOT exists( 
SELECT *

FROM information_schema.table_constraints cs
	WHERE CONSTRAINT_TYPE = 'FOREIGN KEY'
	AND cs.CONSTRAINT_NAME='FK_'+t.TABLE_NAME+'_'+c.COLUMN_NAME
	)


--Missing Default  value
SELECT 

 'ALTER TABLE '+OBJECT_NAME(parent_object_id)+' DROP CONSTRAINT '+ dc.name,
 'ALTER TABLE '+OBJECT_NAME(parent_object_id)+' ADD CONSTRAINT DF_'+OBJECT_NAME(parent_object_id)+'_'+c.name+' DEFAULT '+dc.definition+' FOR ' +c.name 
    

FROM sys.default_constraints dc
INNER JOIN sys.columns c
ON c.object_id=dc.parent_object_id AND dc.parent_column_id=c.column_id
WHERE 'DF_'+OBJECT_NAME(parent_object_id)+'_'+c.name <>dc.name

--Missing Descirption 
--Mising PRIMARY Name

SELECT  i.name AS IndexName,
        OBJECT_NAME(ic.OBJECT_ID) AS TableName,
        COL_NAME(ic.OBJECT_ID,ic.column_id) AS ColumnName
FROM    sys.indexes AS i INNER JOIN 
        sys.index_columns AS ic ON  i.OBJECT_ID = ic.OBJECT_ID
                                AND i.index_id = ic.index_id
WHERE   i.is_primary_key = 1
AND OBJECT_NAME(ic.OBJECT_ID)+'Id' <>   COL_NAME(ic.OBJECT_ID,ic.column_id) 
--unMatch Column 
SELECT c.COLUMN_NAME,c.DATA_TYPE,c.COLUMN_DEFAULT,c.CHARACTER_MAXIMUM_LENGTH, c.NUMERIC_PRECISION, c.NUMERIC_SCALE,count(1)
 FROM INFORMATION_SCHEMA.COLUMNS c
 GROUP BY
 c.COLUMN_NAME,c.DATA_TYPE,c.COLUMN_DEFAULT,c.CHARACTER_MAXIMUM_LENGTH, c.NUMERIC_PRECISION, c.NUMERIC_SCALE
 HAVING count(1) <>(SELECT  count(1)    FROM INFORMATION_SCHEMA.COLUMNS c2 WHERE c2.COLUMN_NAME=c.COLUMN_NAME)

 --id wrong data taype
 SELECT *  FROM INFORMATION_SCHEMA.COLUMNS c  WHERE c.COLUMN_NAME LIKE '%Id' AND c.DATA_TYPE<>'bigint'
END
GO
/****** Object:  StoredProcedure [dbo].[SP_compareERP]    Script Date: 10-Oct-18 5:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_compareERP]
(  
                            @SourceDB SYSNAME, 
                            @TargetDb SYSNAME ,
					   @FileName varchar(max)=''
                            )  
AS
BEGIN
--Must FunctionName :
	  
--Script:Default Data Copy
--Script:All View,SP,Function
 SET nocount ON  
  SET ansi_warnings ON  
  SET ansi_nulls ON  
  DECLARE @SQL AS varchar(MAX)
                 
  CREATE TABLE #TABTABLE_SOURCE 
  (  
        ID INT IDENTITY(1,1), 
        DATABASENAME sysname, 
        TABLENAME SYSNAME , 
        SCRIPT  varchar(max)
  )  
   


    PRINT 'Getting table Script!'; 

  SET @sql='SELECT '''+@SourceDB +''', T1.TABLE_NAME TABLENAME,  [dbo].[Get_Table_Script](T1.TABLE_NAME) 
			  
                    FROM '+@SourceDB+'.INFORMATION_SCHEMA.TABLES T1  
                        LEFT JOIN  '+@TargetDb+'.INFORMATION_SCHEMA.TABLES T2
                            ON T1.TABLE_NAME=T2.TABLE_NAME 
                            
					   WHERE T2.TABLE_NAME IS NULL AND T1.Table_Type=''BASE TABLE''
                        
                        
                        '
      INSERT INTO #TABTABLE_SOURCE(DATABASENAME, TABLENAME,SCRIPT) 
	 
        EXEC(@sql);         
	  -- print(@sql)
	   PRINT 'Getting Add Column Script!'; 
	    CREATE TABLE #TABCOLUMN_SOURCE 
  (  
        ID INT IDENTITY(1,1), 
        DATABASENAME sysname, 
        TABLENAME SYSNAME , 
	   ColumnName Varchar(max),  
        SCRIPT  varchar(max)
  )  
    SET @sql='SELECT '''+@SourceDB +''', T1.TABLE_NAME TABLENAME, C1.COLUMN_NAME, [dbo].[Create_Column_Script](T1.TABLE_NAME,C1.COLUMN_NAME) 
			  
                    FROM '+@SourceDB+'.INFORMATION_SCHEMA.TABLES T1  
				INNER JOIN '+@SourceDB+'.INFORMATION_SCHEMA.COLUMNS C1  
				ON T1.TABLE_NAME=C1.TABLE_NAME
                         INNER JOIN  '+@TargetDb+'.INFORMATION_SCHEMA.TABLES T2
                            ON T1.TABLE_NAME=T2.TABLE_NAME 
					   LEFT JOIN '+@TargetDb+'.INFORMATION_SCHEMA.COLUMNS C2  
					   ON C1.TABLE_NAME=C2.TABLE_NAME AND C1.COLUMN_NAME=C2.COLUMN_NAME
                            
					   WHERE C2.COLUMN_NAME IS NULL AND T1.Table_Type=''BASE TABLE''
                        
                        
                        '
      INSERT INTO #TABColumn_SOURCE(DATABASENAME, TABLENAME,ColumnName,SCRIPT) 
	 
        EXEC(@sql);
	   --print(@sql)
	    

--Script:Update DataSize Increase


 PRINT 'Getting  Column DataSize Increase Script!'; 
	    CREATE TABLE #TABCOLUMNSIZEINC_SOURCE 
  (  
        ID INT IDENTITY(1,1), 
        DATABASENAME sysname, 
        TABLENAME SYSNAME , 
	   ColumnName Varchar(max),  
        SCRIPT  varchar(max)
  )  
    SET @sql='SELECT '''+@SourceDB +''', T1.TABLE_NAME TABLENAME, C1.COLUMN_NAME, [dbo].[Create_Column_Script](T1.TABLE_NAME,C1.COLUMN_NAME) 
			  
                    FROM '+@SourceDB+'.INFORMATION_SCHEMA.TABLES T1  
				INNER JOIN '+@SourceDB+'.INFORMATION_SCHEMA.COLUMNS C1  
				ON T1.TABLE_NAME=C1.TABLE_NAME
                         INNER JOIN  '+@TargetDb+'.INFORMATION_SCHEMA.TABLES T2
                            ON T1.TABLE_NAME=T2.TABLE_NAME 
					   INNER JOIN '+@TargetDb+'.INFORMATION_SCHEMA.COLUMNS C2  
					   ON C1.TABLE_NAME=C2.TABLE_NAME AND C1.COLUMN_NAME=C2.COLUMN_NAME AND C1.DATA_TYPE=C2.DATA_TYPE
                            
					   WHERE C1.CHARACTER_MAXIMUM_LENGTH >C2.CHARACTER_MAXIMUM_LENGTH AND    T1.Table_Type=''BASE TABLE''
                        
                        
                        '
      INSERT INTO #TABCOLUMNSIZEINC_SOURCE(DATABASENAME, TABLENAME,ColumnName,SCRIPT) 
	 
        EXEC(@sql);







 PRINT 'Getting  Column  MisMatch Data Type!'; 
	    CREATE TABLE #TABCOLUMNMISMATCHDATATYPEC_SOURCE 
  (  
        ID INT IDENTITY(1,1), 
        DATABASENAME sysname, 
        TABLENAME SYSNAME , 
	   ColumnName Varchar(max),  
        SCRIPT  varchar(max)
  )  
    SET @sql='SELECT '''+@SourceDB +''', T1.TABLE_NAME TABLENAME, C1.COLUMN_NAME, [dbo].[Create_Column_Script](T1.TABLE_NAME,C1.COLUMN_NAME) 
			  
                    FROM '+@SourceDB+'.INFORMATION_SCHEMA.TABLES T1  
				INNER JOIN '+@SourceDB+'.INFORMATION_SCHEMA.COLUMNS C1  
				ON T1.TABLE_NAME=C1.TABLE_NAME
                         INNER JOIN  '+@TargetDb+'.INFORMATION_SCHEMA.TABLES T2
                            ON T1.TABLE_NAME=T2.TABLE_NAME 
					   INNER JOIN '+@TargetDb+'.INFORMATION_SCHEMA.COLUMNS C2  
					   ON C1.TABLE_NAME=C2.TABLE_NAME AND C1.COLUMN_NAME=C2.COLUMN_NAME  
                            
					   WHERE C1.DATA_TYPE<>C2.DATA_TYPE AND    T1.Table_Type=''BASE TABLE''
                        
                        
                        '
      INSERT INTO #TABCOLUMNMISMATCHDATATYPEC_SOURCE(DATABASENAME, TABLENAME,ColumnName,SCRIPT) 
	 
        EXEC(@sql);





 PRINT 'Getting  Column DataSize Dec Script!'; 
	    CREATE TABLE #TABCOLUMNSIZEDEC_SOURCE 
  (  
        ID INT IDENTITY(1,1), 
        DATABASENAME sysname, 
        TABLENAME SYSNAME , 
	   ColumnName Varchar(max),  
        SCRIPT  varchar(max)
  )  
    SET @sql='SELECT '''+@SourceDB +''', T1.TABLE_NAME TABLENAME, C1.COLUMN_NAME, [dbo].[Create_Column_Script](T1.TABLE_NAME,C1.COLUMN_NAME) 
			  
                    FROM '+@SourceDB+'.INFORMATION_SCHEMA.TABLES T1  
				INNER JOIN '+@SourceDB+'.INFORMATION_SCHEMA.COLUMNS C1  
				ON T1.TABLE_NAME=C1.TABLE_NAME
                         INNER JOIN  '+@TargetDb+'.INFORMATION_SCHEMA.TABLES T2
                            ON T1.TABLE_NAME=T2.TABLE_NAME 
					   INNER JOIN '+@TargetDb+'.INFORMATION_SCHEMA.COLUMNS C2  
					   ON C1.TABLE_NAME=C2.TABLE_NAME AND C1.COLUMN_NAME=C2.COLUMN_NAME AND C1.DATA_TYPE=C2.DATA_TYPE
                            
					   WHERE C1.CHARACTER_MAXIMUM_LENGTH <C2.CHARACTER_MAXIMUM_LENGTH AND    T1.Table_Type=''BASE TABLE''
                        
                        
                        '
      INSERT INTO #TABCOLUMNSIZEDEC_SOURCE(DATABASENAME, TABLENAME,ColumnName,SCRIPT) 
	 
        EXEC(@sql);


	   
 PRINT 'Getting  Column DataSize Dec Script!'; 
	    CREATE TABLE #TAB_VIEW_SP_FUN 
  (  
        ID INT IDENTITY(1,1), 
        DATABASENAME sysname, 
	   TYPENAME Varchar(max), 
        NAME Varchar(max) , 
        SCRIPT  varchar(max)
  )  

	   SET @sql='SELECT 
    '''+@SourceDB +''',
    CASE WHEN Obj.Type=''P'' THEN ''PROCEDURE''
     WHEN Obj.Type=''V'' THEN ''VIEW''
	WHEN Obj.Type=''FN'' THEN ''FUNCATION''
	WHEN Obj.Type=''TR'' THEN ''TRIGGER''
	END
    ,obj.NAME, SM.Definition
FROM ' +@SourceDB+'.SYS.SQL_Modules As SM INNER JOIN ' +@SourceDB+'.SYS.Objects As Obj
ON SM.Object_ID = Obj.Object_ID WHERE Obj.Type IN(''P'',''V'',''FN'',''TR'')
                        ORDER BY  Obj.Type 
                        '
      INSERT INTO #TAB_VIEW_SP_FUN(DATABASENAME, TYPENAME,NAME,SCRIPT) 
	 
        EXEC(@sql);
	   print(@sql)
	  
SET @sql='';
--SELECT *  FROM #TABTABLE_SOURCE
--SELECT  *  FROM #TABCOLUMN_SOURCE
--SELECT *  FROM #TABCOLUMNSIZEINC_SOURCE
--SELECT *  FROM #TABCOLUMNMISMATCHDATATYPEC_SOURCE
--SELECT *  FROM #TABCOLUMNSIZEDEC_SOURCE
SELECT *  FROM #TAB_VIEW_SP_FUN ORDER BY ID

DECLARE @Cmd AS VARCHAR(max)
--print(@sql)
SET @Cmd ='echo ' +  @sql + '  DAppTextFile.txt'
--EXECUTE Master.dbo.xp_CmdShell  @Cmd

PRINT ('Finish')
END

GO
/****** Object:  StoredProcedure [dbo].[TableFKFind]    Script Date: 10-Oct-18 5:34:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE  [dbo].[TableFKFind](
@tableName varchar(max)
)
as
BEGIN
SELECT 
    'ALTER TABLE [' +  OBJECT_SCHEMA_NAME(parent_object_id) +
    '].[' + OBJECT_NAME(parent_object_id) + 
    '] DROP CONSTRAINT [' + name + ']'
FROM sys.foreign_keys
WHERE referenced_object_id = object_id(@tableName)
END
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "AccountMaster"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 119
               Right = 218
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "TranDetails"
            Begin Extent = 
               Top = 6
               Left = 256
               Bottom = 242
               Right = 436
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwAccountDetails'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwAccountDetails'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "AccountMaster"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 287
               Right = 256
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwAccountMaster'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwAccountMaster'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "ItemMaster"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 208
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "TranInventory"
            Begin Extent = 
               Top = 6
               Left = 246
               Bottom = 241
               Right = 473
            End
            DisplayFlags = 280
            TopColumn = 5
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwItemDetails'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwItemDetails'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "ItemMaster"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 188
               Right = 208
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwItemMaster'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwItemMaster'
GO
