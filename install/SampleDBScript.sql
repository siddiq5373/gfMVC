-- DROP DATABASE gfMVCSampleDB

CREATE DATABASE gfMVCSampleDB
GO

USE gfMVCSampleDB
GO
CREATE TABLE [dbo].[tblStatus](
	[StatusID] [int] NOT NULL,
	[Code] [varchar](50) NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[Description] [varchar](255) NULL,
 CONSTRAINT [PK_tblStatus] PRIMARY KEY CLUSTERED 
(
	[StatusID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO 


CREATE TABLE [dbo].[tblUser](
	[UserID] [int] IDENTITY(1,1) NOT NULL,
	[LoginName] [varchar](100) NOT NULL,
	[Password] [varchar](100) NOT NULL,
	[FirstName] [varchar](100) NOT NULL,
	[LastName] [varchar](100) NOT NULL,
	[Email] [varchar](255) NOT NULL,
	[LastLoggedIn] [datetime] NULL,
	[CreatedDate] [datetime] NOT NULL,
	[ModifiedDate] [datetime] NULL,
	[CreatedBy] [int] NULL,
	[ModifiedBy] [int] NULL,
	[StatusID] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[UserID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[tblUser]  WITH CHECK ADD  CONSTRAINT [User_Status] FOREIGN KEY([StatusID])
REFERENCES [dbo].[tblStatus] ([StatusID])
GO

ALTER TABLE [dbo].[tblUser] CHECK CONSTRAINT [User_Status]
GO

ALTER TABLE [dbo].[tblUser]  WITH CHECK ADD  CONSTRAINT [User_CreatedBy_User] FOREIGN KEY([CreatedBy])
REFERENCES [dbo].[tblUser] ([UserID])
GO

ALTER TABLE [dbo].[tblUser] CHECK CONSTRAINT [User_CreatedBy_User]
GO

ALTER TABLE [dbo].[tblUser]  WITH CHECK ADD  CONSTRAINT [User_ModifiedBy_User] FOREIGN KEY([ModifiedBy])
REFERENCES [dbo].[tblUser] ([UserID])
GO

ALTER TABLE [dbo].[tblUser] CHECK CONSTRAINT [User_ModifiedBy_User]
GO



CREATE TABLE [dbo].[tblContent](
	[ContentID] [int] IDENTITY(1,1) NOT NULL,
	[Title] [varchar](100) NOT NULL,
	[Abstract] [varchar](255) NULL,
	[HTMLText] [text] NOT NULL,
	[MetaTitle] [varchar](100) NULL,
	[MetaDescription] [varchar](255) NULL,
	[HighPriorityEndDate] [datetime] NULL,
	[IsHighPriority] [bit] NULL,
	[EffectiveDate] [datetime] NULL,
	[ExpireDate] [datetime] NULL,
	[CreatedDate] [datetime] NULL,
	[ModifiedDate] [datetime] NULL,
	[CreatedBy] [int] NULL,
	[ModifiedBy] [int] NULL,
	[StatusID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[ContentID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[tblContent]  WITH CHECK ADD  CONSTRAINT [Content_Status] FOREIGN KEY([StatusID])
REFERENCES [dbo].[tblStatus] ([StatusID])
GO

ALTER TABLE [dbo].[tblContent] CHECK CONSTRAINT [Content_Status]
GO

ALTER TABLE [dbo].[tblContent]  WITH CHECK ADD  CONSTRAINT [Content_CreatedBy_User] FOREIGN KEY([CreatedBy])
REFERENCES [dbo].[tblUser] ([UserID])
GO

ALTER TABLE [dbo].[tblContent] CHECK CONSTRAINT [Content_CreatedBy_User]
GO

ALTER TABLE [dbo].[tblContent]  WITH CHECK ADD  CONSTRAINT [Content_ModifiedBy_User] FOREIGN KEY([ModifiedBy])
REFERENCES [dbo].[tblUser] ([UserID])
GO

ALTER TABLE [dbo].[tblContent] CHECK CONSTRAINT [Content_ModifiedBy_User]
GO

ALTER TABLE [dbo].[tblContent] ADD  DEFAULT ((0)) FOR [IsHighPriority]
GO


INSERT INTO [gfMVCSampleDB].[dbo].[tblStatus]
           ([StatusID]
           ,[Code]
           ,[Name]
           ,[Description])
     VALUES
           (1
           ,'Active'
           ,'Active'
           ,'Active Status')
GO


INSERT INTO [gfMVCSampleDB].[dbo].[tblStatus]
           ([StatusID]
           ,[Code]
           ,[Name]
           ,[Description])
     VALUES
           (2
           ,'NotActive'
           ,'NotActive'
           ,'Not Active Status')
GO



INSERT INTO [gfMVCSampleDB].[dbo].[tblUser]
           ([LoginName]
           ,[Password]
           ,[FirstName]
           ,[LastName]
           ,[Email]
           ,[LastLoggedIn]
           ,[CreatedDate]
           ,[ModifiedDate]
           ,[CreatedBy]
           ,[ModifiedBy]
           ,[StatusID])
     VALUES
           ('administator'
           ,'supaCoo',
           'Site',
           'Administrator',
           'admin@getfused.com',
           NULL,
           GETDATE(),
           NULL,
           NULL,
           NULL,
           1)
GO


