
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- place for columns which only have 2 or 3 possible values, keep all these miscellaneous things together 
-- ParaGroup just has a row to identify each column we refer to
-- Param table has the values and which ParamGroup (which column) they are associated with 
CREATE TABLE [dbo].[ParamGroup](
	[ParamGroup_ID] [int] IDENTITY(1,1) NOT NULL,
	[ParamGroupName] [nvarchar](50) NOT NULL,
	[ParamGroupDescription] [nvarchar](100) NOT NULL
	CONSTRAINT PK_ParamGroup_ID PRIMARY KEY CLUSTERED ([ParamGroup_ID] ASC)
	)ON [PRIMARY]
ALTER TABLE [dbo].[ParamGroup] ADD DTStamp datetime not null

-- place for columns which only have 2 or 3 possible values, keep all these miscellaneous things together 
-- ParaGroup just has a row to identify each column we refer to
-- Param table has the values and which ParamGroup (which column) they are associated with 
CREATE TABLE [dbo].[Param](
	[Param_ID] [int] IDENTITY(1,1) NOT NULL,
	[ParamGroup_ID] int NOT NULL,
	[ParamValue] [nvarchar](50) NOT NULL,
	[ParamDescription] [nvarchar](100) NOT NULL
	CONSTRAINT PK_Param_ID PRIMARY KEY CLUSTERED ([Param_ID] ASC)
	)ON [PRIMARY]
ALTER TABLE [dbo].[Param] ADD CONSTRAINT FK_Param_ParamGroup_ID FOREIGN KEY ([ParamGroup_ID]) REFERENCES [dbo].[ParamGroup] ([ParamGroup_ID])
ALTER TABLE [dbo].[Param] ADD DTStamp datetime not null

-- period of time we are taking a work input for
-- standalone items ie. can be in this table and there can be no wards using it 
-- in practice they would be created with specific wards in mind
CREATE TABLE [dbo].[WorkShift](
	[WorkShift_ID] [int] IDENTITY(1,1) NOT NULL,
	[WorkShiftName] [nvarchar](10) NOT NULL,
	[StartTime] time NOT NULL,
	[EndTime] time NOT NULL,
	[DTStamp] datetime NOT NULL
	CONSTRAINT PK_WorkShift_ID PRIMARY KEY CLUSTERED ([WorkShift_ID] ASC)
) ON [PRIMARY]

-- names of different dequences, then shift sequence table fills in work shifts and what order they come in the sequence
-- used like WorkSubModel table with names of WorkSubModel and then SubModelTasks lists a task and the submodel it goes in to
CREATE TABLE [dbo].[WorkSequence](
	[WorkSeq_ID] [int] IDENTITY(1,1) NOT NULL,
	[WorkSeqName] [nvarchar](50) NOT NULL,
	[WorkSeqDescription] [nvarchar](200) NULL,
	[DTStamp] datetime NOT NULL
	CONSTRAINT PK_WorkSeq_ID PRIMARY KEY CLUSTERED ([WorkSeq_ID] ASC)
) ON [PRIMARY]

-- lists a WorkShift and what WorkSequence it goes in to
-- used like WorkSubModel table with names of WorkSubModel and then SubModelTasks lists a task and the submodel it goes in to
CREATE TABLE [dbo].[ShiftSequence](
	[ShiftSeq_ID] [int] IDENTITY(1,1) NOT NULL,
	[WorkSeq_ID] [int] NOT NULL,
	[WorkShift_ID] [int] NOT NULL,
	[WorkShift_Order] [int] NOT NULL,
	[DTStamp] datetime NOT NULL
	CONSTRAINT PK_ShiftSeq_ID PRIMARY KEY CLUSTERED ([ShiftSeq_ID] ASC)
) ON [PRIMARY]
ALTER TABLE [dbo].[ShiftSequence] ADD CONSTRAINT FK_ShiftSeq_WorkSeq_ID FOREIGN KEY ([WorkSeq_ID]) REFERENCES [dbo].[WorkSequence] ([WorkSeq_ID])
ALTER TABLE [dbo].[ShiftSequence] ADD CONSTRAINT FK_ShiftSeq_WorkShift_ID FOREIGN KEY ([WorkShift_ID]) REFERENCES [dbo].[WorkShift] ([WorkShift_ID])

-- name of a WorkModel
CREATE TABLE [dbo].[WorkModel](
	[WorkModel_ID] [int] IDENTITY(1,1) NOT NULL,
	[WorkModelName] [nvarchar](50) NOT NULL,
	[WorkModelDescription] [nvarchar](200) NULL,
	[DTStamp] datetime NOT NULL
	CONSTRAINT PK_WorkModel_ID PRIMARY KEY CLUSTERED ([WorkModel_ID] ASC)
) ON [PRIMARY]

-- name of a Task, what WorkModel it belongs to, and the ratio this task has in the entire WorkModel
CREATE TABLE [dbo].[WorkTask](
	[WorkTask_ID] [int] IDENTITY(1,1) NOT NULL,
	[WorkModel_ID] [int] NOT NULL,
	[WorkTaskName] [nvarchar](50) NOT NULL,
	[WorkTaskDescription] [nvarchar](200) NULL,
	[WorkModel_Ratio] [float] NOT NULL,
	[DTStamp] datetime NOT NULL
	CONSTRAINT PK_WorkTask_ID PRIMARY KEY CLUSTERED ([WorkTask_ID] ASC)
) ON [PRIMARY]
ALTER TABLE [dbo].[WorkTask] ADD CONSTRAINT FK_WorkTask_WorkModel_ID FOREIGN KEY ([WorkModel_ID]) REFERENCES [dbo].[WorkModel] ([WorkModel_ID])

-- name of a Band, what Task it belongs to, and the weight (not ratio) this band has in its own Task
CREATE TABLE [dbo].[TaskBand](
	[TaskBand_ID] [int] IDENTITY(1,1) NOT NULL,
	[WorkTask_ID] [int] NOT NULL,
	[TaskBandName] [nvarchar](50) NOT NULL,
	[TaskBandDescription] [nvarchar](200) NULL,
	[TaskBand_Weight] [float] NOT NULL,
	[DTStamp] datetime NOT NULL
	CONSTRAINT PK_TaskBand_ID PRIMARY KEY CLUSTERED ([TaskBand_ID] ASC)
) ON [PRIMARY]
ALTER TABLE [dbo].[TaskBand] ADD CONSTRAINT FK_TaskBand_WorkTask_ID FOREIGN KEY ([WorkTask_ID]) REFERENCES [dbo].[WorkTask] ([WorkTask_ID])

-- name of a SubModel, and the WorkModel it is made from
CREATE TABLE [dbo].[WorkSubModel](
	[WorkSubModel_ID] [int] IDENTITY(1,1) NOT NULL,
	[WorkModel_ID] [int] NOT NULL,
	[WorkSubModelName] [nvarchar](50) NOT NULL,
	[WorkSubModelDescription] [nvarchar](200) NULL,
	[DTStamp] datetime NOT NULL
	CONSTRAINT PK_WorkSubModel_ID PRIMARY KEY CLUSTERED ([WorkSubModel_ID] ASC)
) ON [PRIMARY]
ALTER TABLE [dbo].[WorkSubModel] ADD CONSTRAINT FK_WorkSubModel_WorkModel_ID FOREIGN KEY ([WorkModel_ID]) REFERENCES [dbo].[WorkModel] ([WorkModel_ID])

-- lists a task and what WorkSubModel it goes into
CREATE TABLE [dbo].[SubModelTask](
	[SubModelTask_ID] [int] IDENTITY(1,1) NOT NULL,
	[WorkSubModel_ID] [int] NOT NULL,
	[WorkTask_ID] [int] NOT NULL,
	[DTStamp] datetime NOT NULL
	CONSTRAINT PK_SubModelTask_ID PRIMARY KEY CLUSTERED ([SubModelTask_ID] ASC)
) ON [PRIMARY]
ALTER TABLE [dbo].[SubModelTask] ADD CONSTRAINT FK_SubModelTask_WorkSubModel_ID FOREIGN KEY ([WorkSubModel_ID]) REFERENCES [dbo].[WorkSubModel] ([WorkSubModel_ID])
ALTER TABLE [dbo].[SubModelTask] ADD CONSTRAINT FK_SubModelTask_WorkTask_ID FOREIGN KEY ([WorkTask_ID]) REFERENCES [dbo].[WorkTask] ([WorkTask_ID])

-- creates the name of a default SubModel for the default values to be entered into
-- any Ward using this SubModel will use these default values
CREATE TABLE [dbo].[SubModelDefault](
	[SubModelDefault_ID] [int] IDENTITY(1,1) NOT NULL,
	[WorkSubModel_ID] [int] NOT NULL,
	[SubModelDefaultName] [nvarchar](50) NOT NULL,
	[SubModelDefaultDescription] [nvarchar](200) NULL, 
	[DTStamp] datetime NOT NULL
	CONSTRAINT PK_SubModelDefault_ID PRIMARY KEY CLUSTERED ([SubModelDefault_ID] ASC)
) ON [PRIMARY]
ALTER TABLE [dbo].[SubModelDefault] ADD CONSTRAINT FK_SubModelDefault_WorkSubModel_ID FOREIGN KEY ([WorkSubModel_ID]) REFERENCES [dbo].[WorkSubModel] ([WorkSubModel_ID])

-- lists the DefaultSubModel we are referring to and the default Band value for each Task in that SubModel
CREATE TABLE [dbo].[SubModelDefaultBand](
	[SubModelDefaultBand_ID] [int] IDENTITY(1,1) NOT NULL,
	[SubModelDefault_ID] [int] NOT NULL,
	[TaskBand_ID] [int] NOT NULL,
	[DTStamp] datetime NOT NULL
	CONSTRAINT PK_SubModelDefaultBand_ID PRIMARY KEY CLUSTERED ([SubModelDefaultBand_ID] ASC)
) ON [PRIMARY]
ALTER TABLE [dbo].[SubModelDefaultBand] ADD CONSTRAINT FK_SubModelDefaultBand_SubModelDefault_ID FOREIGN KEY ([SubModelDefault_ID]) REFERENCES [dbo].[SubModelDefault] ([SubModelDefault_ID])
ALTER TABLE [dbo].[SubModelDefaultBand] ADD CONSTRAINT FK_SubModelDefaultBand_TaskBand_ID FOREIGN KEY ([TaskBand_ID]) REFERENCES [dbo].[TaskBand] ([TaskBand_ID])

-- department in a hospital
CREATE TABLE [dbo].[Department](
	[Dep_ID] [int] IDENTITY(1,1) NOT NULL,
	[DepName] [nvarchar](50) NOT NULL,
	[DepDescription] [nvarchar](200) NULL,
	[WorkModel_ID] [int] NULL, -- workmodel table was created already so no worries about foreign key
	[DTStamp] datetime NOT NULL
	CONSTRAINT PK_Dep_ID PRIMARY KEY CLUSTERED ([Dep_ID] ASC)
) ON [PRIMARY]
ALTER TABLE [dbo].[Department] ADD CONSTRAINT FK_Department_WorkModel_ID FOREIGN KEY ([WorkModel_ID]) REFERENCES [dbo].[WorkModel] ([WorkModel_ID])

-- the different specialties 
CREATE TABLE [dbo].[Specialty](
	[Spec_ID] [int] IDENTITY(1,1) NOT NULL,
	[SpecName] [nvarchar](50) NOT NULL,
	[SpecDescription] [nvarchar](200) NULL,
	[DTStamp] datetime NOT NULL
	CONSTRAINT PK_Spec_ID PRIMARY KEY CLUSTERED ([Spec_ID] ASC)
) ON [PRIMARY]

-- lists wards, the department they belong to, the WorkSubModel they use, the WorkSequence they use, the DefaultSubModel they use
CREATE TABLE [dbo].[Ward](
	[Ward_ID] [int] IDENTITY(1,1) NOT NULL,
	[Dep_ID] [int] NOT NULL,
	[WardName] [nvarchar](50) NOT NULL,
	[WardDescription] [nvarchar](200) NULL,
	[WorkSubModel_ID] [int] NULL, -- worksubmodel is created above this so no worries about FK
	[WorkSeq_ID] [int] NULL, 
	[SubModelDefault_ID] [int] NULL,
	[ConfigItemOne_ID] [int] NULL, -- a spare - just in case we need to use for config later we can rename htese rather than adding them in
	-- perhaps, some users like to enter tasks on a patients pie chart one by one throuhgout the shift
	-- but some users like to enter all tasks in one go at the end of a shit 
	-- a ward manager mayprefer one over th eother and want to enforce the entering of all tasks in one go
	-- they could create a param in the param and param group table which states which of these is to happen 
	-- they could set one of these config columns to hold the param ID 
	-- then on entering work for a patient, this column o fthe ward would be checked to see which practice is to be used
	[ConfigItemTwo_ID] [int] NULL, -- a spare - just in case we need to use for config later  we can rename htese rather than adding them in
	[DTStamp] datetime NOT NULL
	CONSTRAINT PK_Ward_ID PRIMARY KEY CLUSTERED ([Ward_ID] ASC)
) ON [PRIMARY]
ALTER TABLE [dbo].[Ward] ADD CONSTRAINT FK_Ward_Dep_ID FOREIGN KEY (Dep_ID) REFERENCES [dbo].[Department] ([Dep_ID])
ALTER TABLE [dbo].[Ward] ADD CONSTRAINT FK_Ward_WorkSeq_ID FOREIGN KEY ([WorkSeq_ID]) REFERENCES [dbo].[WorkSequence] ([WorkSeq_ID])
ALTER TABLE [dbo].[Ward] ADD CONSTRAINT FK_Ward_WorkSubModel_ID FOREIGN KEY ([WorkSubModel_ID]) REFERENCES [dbo].[WorkSubModel] ([WorkSubModel_ID])
ALTER TABLE [dbo].[Ward] ADD CONSTRAINT FK_Ward_SubModelDefault_ID FOREIGN KEY ([SubModelDefault_ID]) REFERENCES [dbo].[SubModelDefault] ([SubModelDefault_ID])


-- lists beds, the wards they belong to, their persist status (perm/temp), and their open status (available for use/unavailable)
CREATE TABLE [dbo].[Bed](
	[Bed_ID] [int] IDENTITY(1,1) NOT NULL,
	[Ward_ID] [int] NOT NULL,
	[BedName] [nvarchar](50) NOT NULL,
	[BedDescription] [nvarchar](200) NULL,
	[PersistStatus] bit default 1 NOT NULL,
	[OpenStatus] bit default 1 NOT NULL,
	[DTStamp] datetime NOT NULL
	CONSTRAINT PK_Bed_ID PRIMARY KEY CLUSTERED ([Bed_ID] ASC)
) ON [PRIMARY]
ALTER TABLE [dbo].[Bed] ADD CONSTRAINT FK_Bed_Ward_ID FOREIGN KEY ([Ward_ID]) REFERENCES [dbo].[Ward] ([Ward_ID])

-- lists diagnosis and the specialty they belong to
CREATE TABLE [dbo].[Diagnosis](
	[Diag_ID] [int] IDENTITY(1,1) NOT NULL,
	[Spec_ID] [int] NOT NULL,
	[DiagnosisName] [nvarchar](50) NOT NULL,
	[DiagnosisDescription] [nvarchar](200) NULL,
	[DTStamp] datetime NOT NULL
	CONSTRAINT PK_Diag_ID PRIMARY KEY CLUSTERED ([Diag_ID] ASC)
) ON [PRIMARY]
ALTER TABLE [dbo].[Diagnosis] ADD CONSTRAINT FK_Diag_Spec_ID FOREIGN KEY (Spec_ID) REFERENCES [dbo].[Specialty] (Spec_ID)

-- lists patient name, DOB, MRN
CREATE TABLE [dbo].[Patient](
	[Pat_ID] [int] IDENTITY(1,1) NOT NULL,
	[PatFirstName] [nvarchar](100) NOT NULL,
	[PatLastName] [nvarchar](100) NOT NULL,
	[PatDOB] date  NULL,
	[PatMRN] [nvarchar](50) NOT NULL, --maybe take this out...confirm normalisation
	[DTStamp] datetime NOT NULL
	CONSTRAINT PK_Pat_ID PRIMARY KEY CLUSTERED ([Pat_ID] ASC)
) ON [PRIMARY]

-- an episode refers to a specific visit to the hospital
-- lists patient, diagnosis, start date, end date(year 3000 upon entering, changed when patient leaves)
CREATE TABLE [dbo].[Episode](
	[Episode_ID] [int] IDENTITY(1,1) NOT NULL,
	[Pat_ID] [int] NOT NULL, 
	[Diag_ID] [int] NULL,
	[StartDT] datetime  NOT NULL,
	[EndDT] datetime  NOT NULL,
	[DTStamp] datetime NOT NULL
	CONSTRAINT PK_Episode_ID PRIMARY KEY CLUSTERED ([Episode_ID] ASC)
) ON [PRIMARY]

ALTER TABLE [dbo].[Episode] ADD CONSTRAINT FK_Episode_Pat_ID FOREIGN KEY ([Pat_ID]) REFERENCES [dbo].[Patient] ([Pat_ID])
ALTER TABLE [dbo].[Episode] ADD CONSTRAINT FK_Episode_Diag_ID FOREIGN KEY ([Diag_ID]) REFERENCES [dbo].[Diagnosis] ([Diag_ID])

-- episode move is placing a patient where they belong
-- lists episode, bed to go into, start date, end date(year 3000 until changed upon patient leaving)
CREATE TABLE [dbo].[EpisodeMove](
	[EpisodeMove_ID] [int] IDENTITY(1,1) NOT NULL,
	[Episode_ID] [int] NOT NULL,
	[Bed_ID] [int] NOT NULL,
	[EpStatus] [int] NOT NULL, -- in param tci trans etc 
	[StartDT] datetime  NOT NULL,
	[EndDT] datetime  NOT NULL,
	[DTStamp] datetime NOT NULL
	CONSTRAINT PK_EpisodeMove_ID PRIMARY KEY CLUSTERED ([EpisodeMove_ID] ASC)
) ON [PRIMARY]
ALTER TABLE [dbo].[EpisodeMove] ADD CONSTRAINT FK_EpisodeMove_Bed_ID FOREIGN KEY ([Bed_ID]) REFERENCES [dbo].[Bed] ([Bed_ID])
ALTER TABLE [dbo].[EpisodeMove] ADD CONSTRAINT FK_EpisodeMove_EpStatus FOREIGN KEY ([EpStatus]) REFERENCES [dbo].[Param] ([Param_ID])
ALTER TABLE [dbo].[EpisodeMove] ADD CONSTRAINT FK_EpisodeMove_Episode_ID FOREIGN KEY ([Episode_ID]) REFERENCES [dbo].[Episode] ([Episode_ID])

-- lists staff type and gives them an ID, eg registered nurse, health care assistant, manager, director
CREATE TABLE [dbo].[StaffType](
	[StaffType_ID] [int] IDENTITY(1,1) NOT NULL,
	[StaffTypeName] [nvarchar](50) NOT NULL,
	[StaffTypeDescription] [nvarchar](100) NOT NULL,
	[DTStamp] datetime NOT NULL
	CONSTRAINT PK_StaffType_ID PRIMARY KEY CLUSTERED ([StaffType_ID] ASC)
) ON [PRIMARY]

-- lists staff by name, log in id, log in password, staff type
CREATE TABLE [dbo].[Staff](
	[Staff_ID] [int] IDENTITY(1,1) NOT NULL,
	[FirstName] [nvarchar](100) NOT NULL,
	[LastName] [nvarchar](100) NOT NULL,
	[Unique_ID] [nvarchar](100) NOT NULL,
	[Password] [nvarchar](100) NOT NULL,
	[StaffType_ID] [int] NOT NULL, 
	[DTStamp] datetime NOT NULL
	CONSTRAINT PK_Staff_ID PRIMARY KEY CLUSTERED ([Staff_ID] ASC)
) ON [PRIMARY]
ALTER TABLE [dbo].[Staff] ADD CONSTRAINT FK_Staff_StaffType_ID FOREIGN KEY ([StaffType_ID]) REFERENCES [dbo].[StaffType] ([StaffType_ID])

-- the hospitals actual roster shifts (different to WorkShift which is just the periods of time we want to account work for)
-- lists RosterShift name, abbr, start time, end time, how many hours are actually worked (dont want to include breaks)
CREATE TABLE [dbo].[RosterShift](
	[RosterShift_ID] [int] IDENTITY(1,1) NOT NULL,
	[RosterShiftName] [nvarchar](50) NOT NULL,
	[RosterShiftAbbrev] [nvarchar](100) NULL, -- this is nickname really rather than abbrev
	[RosterShiftDescription] [nvarchar](100) NULL,
	[StartTime] time NOT NULL,
	[EndTime] time NOT NULL,
	[Hours] float NOT NULL,
	[DTStamp] datetime NOT NULL
	CONSTRAINT PK_RosterShift_ID PRIMARY KEY CLUSTERED ([RosterShift_ID] ASC)
) ON [PRIMARY]

-- lists the roster for each ward on different dates
-- lists ward, staff member, roster shift, roster date
CREATE TABLE [dbo].[Roster](
	[Roster_ID] [int] IDENTITY(1,1) NOT NULL,
	[Ward_ID] [int] NOT NULL,
	[Staff_ID] [int] NOT NULL,
	[RosterShift_ID] [int] NOT NULL, 
	[RosterDate] date NOT NULL,
	[DTStamp] datetime NOT NULL
	CONSTRAINT PK_Roster_ID PRIMARY KEY CLUSTERED ([Roster_ID] ASC)
) ON [PRIMARY]
ALTER TABLE [dbo].[Roster] ADD CONSTRAINT FK_Roster_Ward_ID FOREIGN KEY ([Ward_ID]) REFERENCES [dbo].[Ward] ([Ward_ID])
ALTER TABLE [dbo].[Roster] ADD CONSTRAINT FK_Roster_Staff_ID FOREIGN KEY ([Staff_ID]) REFERENCES [dbo].[Staff] ([Staff_ID])
ALTER TABLE [dbo].[Roster] ADD CONSTRAINT FK_Roster_RosterShift_ID FOREIGN KEY ([RosterShift_ID]) REFERENCES [dbo].[RosterShift] ([RosterShift_ID])


-- stores inputs from nurses on patient pie charts
-- takes episode move (we get patient, diagnosis, ward from this)
-- lists workshiftdate, workshiftID, worksubmodel,  task free text, task band, isoutlier (t/f), staff ID
CREATE TABLE [dbo].[Work](
	[Work_ID] [int] IDENTITY(1,1) NOT NULL,
	[EpisodeMove_ID] [int] NOT NULL,
	[WorkShiftDate] date NOT NULL,	
	[WorkShift_ID] [int] NOT NULL, 
	[WorkSubModel_ID] [int] NOT NULL, 
	[TaskFreeText] [nvarchar](100) NULL,
	[TaskBand_ID] [int] NOT NULL,
	[isOutlier] bit default 0 NOT NULL, -- will be 1 when entry is for atypical task, not part of the submodel
	[Staff_ID] [int] NOT NULL,
	[DTStamp] datetime NOT NULL
	CONSTRAINT PK_Work_ID PRIMARY KEY CLUSTERED ([Work_ID] ASC)
) ON [PRIMARY]
ALTER TABLE [dbo].[Work] ADD CONSTRAINT FK_Work_EpisodeMove_ID FOREIGN KEY ([EpisodeMove_ID]) REFERENCES [dbo].[EpisodeMove] ([EpisodeMove_ID])
ALTER TABLE [dbo].[Work] ADD CONSTRAINT FK_Work_Staff_ID FOREIGN KEY ([Staff_ID]) REFERENCES [dbo].[Staff] ([Staff_ID])
ALTER TABLE [dbo].[Work] ADD CONSTRAINT FK_Work_WorkShift_ID FOREIGN KEY ([WorkShift_ID]) REFERENCES [dbo].[WorkShift] ([WorkShift_ID])
ALTER TABLE [dbo].[Work] ADD CONSTRAINT FK_Work_WorkSubModel_ID FOREIGN KEY ([WorkSubModel_ID]) REFERENCES [dbo].[WorkSubModel] ([WorkSubModel_ID])
ALTER TABLE [dbo].[Work] ADD CONSTRAINT FK_Work_TaskBand_ID FOREIGN KEY ([TaskBand_ID]) REFERENCES [dbo].[TaskBand] ([TaskBand_ID])

-- when second input is logged for same task in one WorkShift, the prev is pushed to WorkArchive and the curr (correct) input goes into Work
-- new fields added 
-- archive staffID (staff member who input new work)
-- archive reason (from Param table)
-- archive free text (comment if wanted)
-- original DTStamp goes in and new one goes in as archiveDTStamp
CREATE TABLE [dbo].[WorkArchive](
	[WorkArchive_ID] [int] IDENTITY(1,1) NOT NULL,
	[EpisodeMove_ID] [int] NOT NULL,
	[WorkShiftDate] date NOT NULL,	
	[WorkShift_ID] [int] NOT NULL, 
	[WorkSubModel_ID] [int] NOT NULL,
	[TaskFreeText] [nvarchar](100) NULL,
	[TaskBand_ID] [int] NOT NULL,
	[isOutlier] bit default 0 NOT NULL, -- will be 1 when entry is for atypical task, not part of the submodel
	[Staff_ID] [int] NOT NULL,
	[DTStamp] datetime NOT NULL,
	[ArchiveStaff_ID] [int] NOT NULL, -- ? can two reference same field
	[ArchiveReason_ID] [int] NOT NULL, -- either being updated, or deleted due to error or something else, see param table
	[ArchiveFreeText] [nvarchar](100) NULL,
	[ArchiveDTStamp] datetime NOT NULL

	CONSTRAINT PK_WorkArchive_ID PRIMARY KEY CLUSTERED ([WorkArchive_ID] ASC)
) ON [PRIMARY]
ALTER TABLE [dbo].[WorkArchive] ADD CONSTRAINT FK_WorkArchive_EpisodeMove_ID FOREIGN KEY ([EpisodeMove_ID]) REFERENCES [dbo].[EpisodeMove] ([EpisodeMove_ID])
ALTER TABLE [dbo].[WorkArchive] ADD CONSTRAINT FK_WorkArchive_Staff_ID FOREIGN KEY ([Staff_ID]) REFERENCES [dbo].[Staff] ([Staff_ID])
ALTER TABLE [dbo].[WorkArchive] ADD CONSTRAINT FK_WorkArchive_WorkShift_ID FOREIGN KEY ([WorkShift_ID]) REFERENCES [dbo].[WorkShift] ([WorkShift_ID])
ALTER TABLE [dbo].[WorkArchive] ADD CONSTRAINT FK_WorkArchive_WorkSubModel_ID FOREIGN KEY ([WorkSubModel_ID]) REFERENCES [dbo].[WorkSubModel] ([WorkSubModel_ID])
ALTER TABLE [dbo].[WorkArchive] ADD CONSTRAINT FK_WorkArchive_TaskBand_ID FOREIGN KEY ([TaskBand_ID]) REFERENCES [dbo].[TaskBand] ([TaskBand_ID])
ALTER TABLE [dbo].[WorkArchive] ADD CONSTRAINT FK_WorkArchive_ArchiveStaff_ID FOREIGN KEY ([ArchiveStaff_ID]) REFERENCES [dbo].[Staff] ([Staff_ID])
ALTER TABLE [dbo].[WorkArchive] ADD CONSTRAINT FK_WorkArchive_ArchiveReason_ID FOREIGN KEY ([ArchiveReason_ID]) REFERENCES [dbo].[Param] ([Param_ID])


