CREATE PROCEDURE  [dbo].[InsertStaffType]   
    @StaffTypeName nvarchar(50),  
    @StaffTypeDescription nvarchar(100)

	AS   

    SET NOCOUNT ON;  
    if not exists(select * from [dbo].[StaffType] s 
	where s.StaffTypeName =  @StaffTypeName)
		BEGIN
		insert into [dbo].[StaffType]
		(StaffTypeName,
		StaffTypeDescription,
		DTStamp)
		values
		(@StaffTypeName,
		@StaffTypeDescription,
		 CURRENT_TIMESTAMP)
		END  
GO



-------------------------------------------------------------------------------------

CREATE PROCEDURE  [dbo].[InsertStaff]   
    @FirstName nvarchar(100),  
    @LastName nvarchar(100),
	@Unique_ID nvarchar(100),
	@Password nvarchar(100),
	@StaffType_ID int
AS   

    SET NOCOUNT ON;  
    if not exists(select * from [dbo].[Staff] s 
	where s.Unique_ID =  @Unique_ID)
		BEGIN
		insert into [dbo].[Staff]
		(FirstName,
		LastName,
		Unique_ID,
		[Password],
		DTStamp)
		values
		(@FirstName,
		@LastName,
		@Unique_ID,
		@Password,
		 CURRENT_TIMESTAMP)
		END  
GO

-----------------------------------------------------------------------------


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE  [dbo].[InsertHospital]   
    @HosName nvarchar(50),
	@HosDescription nvarchar(200)
      
AS   

    SET NOCOUNT ON;  
    if not exists(select * from [dbo].[Hospital] h where h.HosName =  @HosName)
		BEGIN
		insert into [dbo].[Hospital]
		(HosName,
		HosDescription,
		DTStamp)
		values
		(@HosName,
		@HosDescription,
		CURRENT_TIMESTAMP)
		END  
GO

-----------------------------------------------------------------------------------------

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





CREATE PROCEDURE  [dbo].[InsertSpecialty]   
    @SpecName nvarchar(50),  
    @SpecDescription nvarchar(50) = null 
AS   

    SET NOCOUNT ON;  
    if not exists(select * from [dbo].[Specialty] s 
	where s.SpecName =  @SpecName)
		BEGIN
		insert into [dbo].[Specialty]
		(SpecName,
		SpecDescription,
		DTStamp)
		values
		(@SpecName,
		@SpecDescription,
		CURRENT_TIMESTAMP)
		END  
GO


-----------------------------------------------------------------------------------


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






CREATE PROCEDURE [dbo].[InsertDiagnosis]
	@SpecID int,  
    @DiagnosisName nvarchar(50),  
    @DiagnosisDescription nvarchar(200) = null 
AS   

    SET NOCOUNT ON;  
    if not exists(select * from [dbo].[Diagnosis] d 
	where d.Spec_ID = @SpecID and d.DiagnosisName =  @DiagnosisName)
		BEGIN
		insert into [dbo].[Diagnosis]
		(Spec_ID,
		DiagnosisName,
		DiagnosisDescription,
		DTStamp)
		values
		(@SpecID,
		@DiagnosisName,
		@DiagnosisDescription,
		CURRENT_TIMESTAMP)
		END  
GO


--------------------------------------------------------------------------------------

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON

GO




CREATE PROCEDURE [dbo].[InsertDepartment]   
    @DepName nvarchar(50),  
    @DepDescription nvarchar(50) = null 
AS   

    SET NOCOUNT ON;  
    if not exists(select * from [dbo].[Department] d 
	where d.DepName =  @DepName)
		BEGIN
		insert into [dbo].[Department]
		(DepName,
		DepDescription,
		DTStamp)
		values
		(@DepName,
		@DepDescription,
		CURRENT_TIMESTAMP)
		END  
GO


-----------------------------------------------------------------


CREATE PROCEDURE [dbo].[InsertWard] 
	@Dep_ID int,  
    @WardName nvarchar(50),  
    @WardDescription nvarchar(50) = null,
	@WorkSubModel_ID int = null,
	@WorkSeq_ID int = null 
AS   

    SET NOCOUNT ON;  
    if not exists(select * from [dbo].[Ward] w 
	where w.[WardName] =  @WardName and w.Dep_ID = @Dep_ID)
		BEGIN
		insert into [dbo].[Ward]
		(Dep_ID,
		WardName,
		WardDescription,
		WorkSubModel_ID,
		WorkSeq_ID,
		DTStamp)
		values
		(@Dep_ID,
		@WardName,
		@WardDescription,
		@WorkSubModel_ID,
		@WorkSeq_ID,
		 CURRENT_TIMESTAMP)
		END  
GO
------------------------------------------------------------------------------


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[InsertBed]
	@WardID int,
	@BedName nvarchar (50),
	@BedDesc nvarchar (200),
	@PersistStatus bit,
	@OpenStatus bit

AS 

	if not exists (select * from [dbo].[Bed] b
	where b.Ward_ID = @WardID 
	and b.BedName = @BedName)
		BEGIN 
		INSERT INTO [dbo].[Bed] 
		(Ward_ID,
		BedName,
		BedDescription,
		PersistStatus,
		OpenStatus,
		DTStamp)
		VALUES 
		(@WardID,
		@BedName,
		@BedDesc,
		@PersistStatus,
		@OpenStatus,
		CURRENT_TIMESTAMP)
		END
GO

------------------------------------------------------------------------------




SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





CREATE PROCEDURE  [dbo].[InsertPatient]   
    @PatFirstName nvarchar(100),  
    @PatLastName nvarchar(100),
	@PatDOB date,
	@PatMRN nvarchar(50)
AS   

    SET NOCOUNT ON;  
    if not exists(select * from [dbo].[Patient] p 
	where p.PatMRN =  @PatMRN)
		BEGIN
		insert into [dbo].[Patient]
		(PatFirstName,
		PatLastName,
		PatDOB,
		PatMRN,
		DTStamp)
		values
		(@PatFirstName,
		@PatLastName,
		@PatDOB,
		@PatMRN,
		CURRENT_TIMESTAMP)
		END  
GO


--------------------------------------------------------------------------------------


CREATE PROCEDURE  [dbo].[InsertParamGroup]  
	@ParamGroupName nvarchar(50),  
    @ParamGroupDescription nvarchar(100) = null
     
AS   

    SET NOCOUNT ON;  
	if not exists (select * from [dbo].[ParamGroup] p
	where p.ParamGroupName = @ParamGroupName)
		BEGIN
		insert into [dbo].[ParamGroup]
		(ParamGroupName,
		ParamGroupDescription)
		values
		(@ParamGroupName,
		@ParamGroupDescription)
		END
GO

-----------------------------------------------------------------------------------

CREATE PROCEDURE  [dbo].[InsertParam]
	@ParamGroup_ID int,
	@ParamValue nvarchar(50),  
    @ParamDescription nvarchar(100) = null
     
AS   

    SET NOCOUNT ON;  
	if not exists (select * from [dbo].[Param] p
	where p.ParamValue = @ParamValue)
		BEGIN
		insert into [dbo].[Param]
		(ParamValue,
		ParamDescription)
		values
		(@ParamValue,
		@ParamDescription)
		END
GO

---------------------------------------------------------------------------------------



CREATE PROCEDURE  [dbo].[InsertEpisode]  
	@Pat_ID int,
	@Diag_ID int,
    @StartDT datetime, 
	@EndDT datetime
     
AS   

    SET NOCOUNT ON;  
		insert into [dbo].[Episode]
		(Pat_ID,
		Diag_ID,
		StartDT,
		EndDT,
		DTStamp)
		values
		(@Pat_ID,
		@Diag_ID,
		@StartDT,
		@EndDT, 
		CURRENT_TIMESTAMP)
GO		  
--------------------------------------------------------------------------------

CREATE PROCEDURE  [dbo].[InsertEpisodeMove]  
	@Episode_ID int,
	@Bed_ID int,
    @StartDT datetime, 
	@EndDT datetime
     
AS   

    SET NOCOUNT ON;  
		insert into [dbo].[EpisodeMove]
		(Episode_ID,
		Bed_ID,
		StartDT,
		EndDT,
		DTStamp)
		values
		(@Episode_ID,
		@Bed_ID,
		@StartDT,
		@EndDT,
		CURRENT_TIMESTAMP)
GO
----------------------------------------------------------------------------


CREATE PROCEDURE  [dbo].[InsertRoster]
	@Ward_ID int,
	@Staff_ID int,
	@RosterShift_ID int,
	@RosterDate date
     
AS   

    SET NOCOUNT ON;  
		insert into [dbo].[Roster]
		(Ward_ID,
		Staff_ID,
		RosterShift_ID,
		RosterDate,
		DTStamp)
		values
		(@Ward_ID,
		@Staff_ID,
		@RosterShift_ID,
		@RosterDate,
		CURRENT_TIMESTAMP)
GO
-------------------------------------------------------------------------
CREATE PROCEDURE  [dbo].[InsertRosterChange]
	@Roster_ID int,
	@NewStartTime datetime,
	@NewEndTime datetime,
	@NewHours float
     
AS   

    SET NOCOUNT ON;
		--add in code to cacel existing  
		insert into [dbo].[RosterChange]
		(Roster_ID,
		NewStartTime,
		NewEndTime,
		NewHours,
		DTStamp)
		values
		(@Roster_ID,
		@NewStartTime,
		@NewEndTime,
		@NewHours,
		CURRENT_TIMESTAMP)
GO
------------------------------------------------------------------------------------

CREATE PROCEDURE  [dbo].[InsertRosterShift]
	@RosterShiftName nvarchar(50),
	@RosterShiftAbbrev nvarchar(10),
	@RosterShiftDescription nvarchar(100),
	@StartTime time,
	@EndTime time,
	@Hours float
     
AS   

    SET NOCOUNT ON;
		--add in code to cancel existing  
		insert into [dbo].[RosterShift]
		(RosterShiftName,
		RosterShiftAbbrev,
		RosterShiftDescription,
		StartTime,
		EndTime,
		[Hours],
		DTStamp)
		values
		(@RosterShiftName,
		@RosterShiftAbbrev,
		@RosterShiftDescription,
		@StartTime,
		@EndTime,
		@Hours,
		CURRENT_TIMESTAMP)
GO
------------------------------------------------------------------------------

CREATE PROCEDURE  [dbo].[InsertShiftSequence]
	@WorkSeq_ID int,
	@WorkShift_ID int,
	@WorkShift_Order int
	     
AS   

    SET NOCOUNT ON;  
		insert into [dbo].[ShiftSequence]
		(WorkSeq_ID,
		WorkShift_ID,
		WorkShift_Order,
		DTStamp)
		values
		(@WorkSeq_ID,
		@WorkShift_ID,
		@WorkShift_Order,
		CURRENT_TIMESTAMP)
GO




-----------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[InsertWorkSequence]   
    @WorkSeqName nvarchar(50),  
    @WorkSeqDescription nvarchar(200) = null 
AS   

    SET NOCOUNT ON;  
    if not exists(select * from [dbo].[WorkSequence] s 
	where s.WorkSeqName =  @WorkSeqName)
		BEGIN
		insert into [dbo].[WorkSequence]
		(WorkSeqName,
		WorkSeqDescription,
		DTStamp)
		values
		(@WorkSeqName,
		@WorkSeqDescription,
		CURRENT_TIMESTAMP)
		END  
GO

---------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[InsertWorkShift]   
    @WorkShiftName nvarchar(50),  
    @StartTime time,
	@EndTime time 
AS   

    SET NOCOUNT ON;  
    if not exists(select * from [dbo].[WorkShift] s 
	where 
	(s.WorkShiftName =  @WorkShiftName) 
	or (s.StartTime = @StartTime and s.EndTime = @EndTime)
	)
		BEGIN
		insert into [dbo].[WorkShift]
		(WorkShiftName,
		StartTime,
		EndTime,
		DTStamp)
		values
		(@WorkShiftName,
		@StartTime,
		@EndTime,
		CURRENT_TIMESTAMP)
		END  
GO


---------------------------------------------------------------------------------
/* 19/03/2021 */ 
--------------------------------------------------------------------------------- 

CREATE PROCEDURE [dbo].[ReturnWorkModelID] 
	@WorkModelName nvarchar(50)

AS 
	SET NOCOUNT ON;
	SELECT WorkModel_ID FROM WorkModel WHERE WorkModelName = @WorkModelName
GO

--------------------------------------------------------------------------------- 

CREATE PROCEDURE [dbo].[ReturnWorkSubModelID]
	@WorkSubModelName nvarchar(50)

AS 
	SET NOCOUNT ON;
	SELECT WorkSubModel_ID FROM WorkSubModel WHERE WorkSubModelName = @WorkSubModelName
GO 

--------------------------------------------------------------------------------- 

CREATE PROCEDURE [dbo].[ReturnWorkModelNames]

AS 
	SET NOCOUNT ON;
	SELECT WorkModelName FROM WorkModel
GO

--------------------------------------------------------------------------------- 

CREATE PROCEDURE [dbo].[ReturnSubModelNames]

AS 
	SET NOCOUNT ON;
	SELECT WorkSubModelName FROM WorkSubModel
GO

--------------------------------------------------------------------------------- 

CREATE PROCEDURE [dbo].[ReturnWorkModelTaskID] 
	@WorkTaskName varchar(50),
	@WorkModelId int

AS
	SELECT WorkTask_ID FROM WorkTask WHERE WorkTaskName = @WorkTaskName AND WorkModel_ID = @WorkModelId
GO 

--------------------------------------------------------------------------------- 

CREATE PROCEDURE [dbo].[CheckWorkTask] 
	@WorkModelID int

AS 
	SELECT WorkTask_ID, WorkTaskName, WorkModel_Ratio, WorkTaskDescription FROM WorkTask WHERE WorkModel_ID = @WorkModelID 
GO

--------------------------------------------------------------------------------- 

CREATE PROCEDURE [dbo].[CheckWorkSubTask] 
	@WorkSubModelID int

AS 
	SELECT WorkTask_ID FROM SubModelTask WHERE WorkSubModel_ID = @WorkSubModelID
GO 

--------------------------------------------------------------------------------- 

CREATE PROCEDURE [dbo].[CheckTaskBand] 
	@WorkTaskID int

AS 
	SELECT * FROM TaskBand WHERE WorkTask_ID = @WorkTaskID
GO 

--------------------------------------------------------------------------------- 

CREATE PROCEDURE [dbo].[CheckWorkTaskName] 
	@WorkTaskName nvarchar(50),
	@WorkModelID int

AS
	SELECT * FROM WorkTask WHERE WorkTaskName = @WorkTaskName AND WorkModel_ID = @WorkModelID
GO 

--------------------------------------------------------------------------------- 

CREATE PROCEDURE [dbo].[CheckSubModelWorkTaskName] 
	@SubModelID int,
	@WorkTaskID int

AS
	SELECT * FROM SubModelTask WHERE WorkSubModel_ID = @SubModelID AND WorkTask_ID = @WorkTaskID
GO 

---------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[CheckTaskBandName] 
	@WorkTaskID int,
	@TaskBandName nvarchar(50),
	@BandTaskWeight float

AS
	SELECT * FROM TaskBand WHERE WorkTask_ID = @WorkTaskID AND TaskBandName = @TaskBandName AND TaskBand_Weight = @BandTaskWeight
GO 

---------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[InsertWorkModelData] 
	@WorkModelName nvarchar(50),
	@WorkModelDescription nvarchar(200)

AS 
	SET NOCOUNT ON;  
    if not exists(select * from [dbo].[WorkModel] wm 
	where wm.WorkModelName =  @WorkModelName)
		BEGIN
		insert into [dbo].[WorkModel]
		(WorkModelName,WorkModelDescription,DTStamp)
		values
		(@WorkModelName,@WorkModelDescription, CURRENT_TIMESTAMP)
		END
GO

---------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[InsertSubModelData] 
	@WorkModelID int,
	@SubModelName nvarchar(50),
	@SubModelDescription nvarchar(200)

AS 
	SET NOCOUNT ON;
	if not exists(select * from [dbo].[WorkSubModel] sm
	where sm.WorkSubModelName = @SubModelName)
		BEGIN
		INSERT INTO WorkSubModel 
		(WorkModel_ID, WorkSubModelName, WorkSubModelDescription, DTStamp)
		VALUES 
		(@WorkModelID, @SubModelName, @SubModelDescription, CURRENT_TIMESTAMP)
		END
GO

---------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[InsertTask]     
    @WorkModelID int,
	@WorkTaskName nvarchar(50),
	@WorkTaskDescription nvarchar(200) = null,
	@WorkModel_Ratio float

AS   

    SET NOCOUNT ON;  
    if not exists(select * from [dbo].[WorkTask] t 
	where t.WorkModel_ID =  @WorkModelID
	and t.WorkTaskName = @WorkTaskName)
		BEGIN
		insert into [dbo].[WorkTask]
		(WorkModel_ID,
		WorkTaskName,
		WorkTaskDescription,
		WorkModel_Ratio,
		DTStamp)
		values
		(@WorkModelID,
		@WorkTaskName,
		@WorkTaskDescription,
		@WorkModel_Ratio,
		 CURRENT_TIMESTAMP)
		END  
GO

---------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[InsertTaskBand]     
    @WorkTask_ID int,
	@TaskBandName nvarchar(50),
	@TaskBandDescription nvarchar(200) = null,
	@TaskBand_Weight float

AS   

    SET NOCOUNT ON;  
    if not exists(select * from [dbo].[TaskBand] b 
	where b.WorkTask_ID =  @WorkTask_ID
	and b.TaskBandName = @TaskBandName)
		BEGIN
		insert into [dbo].[TaskBand]
		(WorkTask_ID,
		TaskBandName,
		TaskBandDescription,
		TaskBand_Weight,
		DTStamp)
		values
		(@WorkTask_ID,
		@TaskBandName,
		@TaskBandDescription,
		@TaskBand_Weight,
		 CURRENT_TIMESTAMP)
		END  
GO

---------------------------------------------------------------------------------

CREATE PROCEDURE  [dbo].[InsertSubModelTask]   
    @WorkSubModel_ID int,  
    @WorkTask_ID int

AS   

    SET NOCOUNT ON;  
    if not exists(select * from [dbo].[SubModelTask] st 
	where st.WorkSubModel_ID =  @WorkSubModel_ID
	and st.WorkTask_ID = @WorkTask_ID)
		BEGIN
		insert into [dbo].[SubModelTask]
		(WorkSubModel_ID,
		WorkTask_ID,
		DTStamp)
		values
		(@WorkSubModel_ID,
		@WorkTask_ID,
		 CURRENT_TIMESTAMP)
		END  
GO

---------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[DeleteTask] 
	@TaskName nvarchar(50),
	@WorkModelID int
AS 
	SET NOCOUNT ON;
	if exists (select * from [dbo].[WorkTask] t
	where t.WorkTaskName = @TaskName 
	and t.WorkModel_ID = @WorkModelID)
		BEGIN 
		DELETE FROM [dbo].[WorkTask] WHERE WorkTaskName = @TaskName AND WorkModel_ID = @WorkModelID
		END 
GO

---------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[DeleteBand] 
	@BandName nvarchar(50),
	@WorkTaskID int
AS 
	SET NOCOUNT ON;
	if exists (select * from [dbo].[TaskBand] b
	where b.TaskBandName = @BandName 
	and b.WorkTask_ID = @WorkTaskID)
		BEGIN 
		DELETE FROM [dbo].[TaskBand] WHERE TaskBandName = @BandName AND WorkTask_ID = @WorkTaskID
		END 
GO

---------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[GetStaffList]

AS
	SELECT * FROM [dbo].[Staff]
GO

---------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[GetStaffTypeName]
	@staffTypeID int
AS
	SET NOCOUNT ON
	SELECT StaffTypeName 
	FROM StaffType st
	inner join dbo.Staff s
	on s.StaffType_ID =st.StaffType_ID
	WHERE s.StaffType_ID = @staffTypeID
GO
---------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[UpdatePwForUser]
	@username nvarchar (100),
	@newPassword nvarchar (100)
AS
	SET NOCOUNT ON
	UPDATE Staff 
	SET Password = @newPassword
	WHERE Unique_ID = @username
GO

---------------------------------------------------------------------------------------------------------------------------



--CREATE PROCEDURE [dbo].[BulkInsertCSV]
--	@workModelID as int, 
--	@filePath as nvarchar(300)
--AS 
--	DROP TABLE IF EXISTS #WorkModelUpload
--	DROP TABLE IF EXISTS #WorkTaskUpload
--	DROP TABLE IF EXISTS #TaskBandUpload
--	-- just good practice, ensure they are clear before we create them

	
---- create temp table consisting off all data from csv
--create table #WorkModelUpload	-- task and band info
--(
--[WorkTaskName] [nvarchar](50) not null,
--[WorkTaskDescription] [nvarchar](200) null,	
--RN_Time_Spent float not null, -- per task, on average or summed up over a week of time/motion study 
--HCA_Time_Spent float not null,	-- didnt bracket these just bc they dont go into real table so nice to single them out at a glance
--[TaskBandName] [nvarchar](50) not null,
--[TaskBandDescription] [nvarchar](200) null,
--[TaskBand_Weight] [float] not null,
--[WorkModel_Ratio] [float] not null,
--[WorkTask_ID] [int] not null,
--[TaskBand_ID] [int] not null
--)



---- bulk insert csv into this temp table
---- this file path will be absolute to the server the DB is running on online. need to figure out how to pass local file to cloud
--DECLARE @SQL_BULK VARCHAR(MAX)
--SET @SQL_BULK = '
--BULK INSERT #WorkModelUpload from @filePath
--with
--(FIRSTROW = 2,  FIELDTERMINATOR = ',', ROWTERMINATOR = '\n')' -- ignore first row in csv bc its just column headings

--EXEC @SQL_BULK


----insert all tasks into the task table as distinct - without their bands - 26 in this example
--CREATE TABLE #WorkTaskUpload(
--[WorkTask_ID] [int] NULL,
--[WorkTaskName] [nvarchar](50) NOT NULL,
--[WorkTaskDescription] [nvarchar](200) NULL,
--RN_Time_Spent float not null,
--HCA_Time_Spent float not null,	-- didnt bracket these just bc they dont go into real table so nice to single them out at a glance
--[WorkModel_Ratio] [float] NULL)


--insert into #WorkTaskUpload
--([WorkTaskName],[WorkTaskDescription],RN_Time_Spent,HCA_Time_Spent)
--select distinct w.WorkTaskName,w.WorkTaskDescription,w.RN_Time_Spent,w.HCA_Time_Spent from #WorkModelUpload w
---- task A has many entries in WorkModel Upload. we only want distinct name, desc, time spent.
---- distinct is applied to all cols but we have already checked distinctoni anyway but we need to add them all to #Tasks
----calculate the ratio for each task
--declare @sumTimeSpent as float
--set @sumTimeSpent= (select sum(w.RN_Time_Spent) from #WorkTaskUpload w) + (select sum(w.HCA_Time_Spent) from #WorkTaskUpload w) 
---- one row for every task in #WorkTaskUpload
---- adds time spent for all task together
--update 	#WorkTaskUpload	set [WorkModel_Ratio] = (RN_Time_Spent + HCA_Time_Spent) * 100/@sumTimeSpent
---- this will do it line by line 
---- sumTimeSpent is sum of all time spent on all tasks 
---- then find one tasks ratio of all tasks time spent



--CREATE TABLE #TaskBand(
--	[TaskBand_ID] [int] IDENTITY(1,1) NOT NULL,
--	[WorkTask_ID] [int] NOT NULL,
--	[TaskBandName] [nvarchar](50) NOT NULL,
--	[TaskBandDescription] [nvarchar](200) NULL,
--	[TaskBand_Weight] [float] NOT NULL,
--	[DTStamp] datetime NOT NULL)

--insert into #TaskBand
--	(WorkTask_ID,TaskBandName,TaskBandDescription,TaskBand_Weight,DTStamp)
--select distinct t.WorkTask_ID,u.TaskBandName,u.TaskBandDescription,u.TaskBand_Weight,GETDATE() 
--from dbo.WorkTask t inner join #WorkModelUpload u
--on t.WorkTaskName = u.WorkTaskName
--where t.WorkModel_ID = @workModelID


--DROP TABLE IF EXISTS #WorkModelUpload
--DROP TABLE IF EXISTS #WorkTaskUpload
--DROP TABLE IF EXISTS #TaskBandUpload
--GO




---------------------------------------------------------------------------------------------------------------------------
/* 
if the pie charts were dispayed as originally intended, the bands would be displayed based on their weight.
this sp would be called by the app when users are configuring bands for a pie chart. 
the user doesnt have to enter the No Work Required band.
thwhen the user clicks save bands button, the java app would save the configured bands and then create a NoWorkRequired band.
the value of the no work required band would be set by this sp.
the value would propbably be 0.1, so that the band would be 0.1 of the task slice.
then when the workscore is calculated in the GetWorkScores view, it would disregard the NowrokRequire dband, so that it doesnt count the 0.1 or whatever
*/

CREATE PROCEDURE [dbo].[UpdateNoWorkRequiredValue] 
	@NoWorkRequiredValue float 

AS   

    SET NOCOUNT ON;  
-- first check if we have a record for NoWorkRequired value
declare @Param_ID as int
declare @ParamGroup_ID as int
set @Param_ID =
( 
	select p.Param_ID from dbo.ParamGroup g
	inner join dbo.[Param] p
	on g.ParamGroup_ID = p.ParamGroup_ID
	where g.ParamGroupName = 'NoWorkRequired'
)

--if there is a record there, just update it
if @Param_ID is not null
	begin
		update dbo.[Param] set ParamValue = @NoWorkRequiredValue
		where Param_ID = @Param_ID
		return
	end






-- otherwise (if Param_ID is null, ie, if there was no value set yet and we are setting for the first time) 
-- check for the param group being there in the param group table
set @ParamGroup_ID =
( 
	select g.ParamGroup_ID 
	from dbo.ParamGroup g	
	where g.ParamGroupName = 'NoWorkRequired'
)


-- if ParamGroup is there, just add NoWorkRequired to Param table using ParamGroupID
 if @ParamGroup_ID is not null	
	 begin
		insert into dbo.[Param]
			(ParamGroup_ID, ParamValue,ParamDescription,DTStamp)
		values
			(@ParamGroup_ID, @NoWorkRequiredValue,'the value of a NoWorkRequired band',CURRENT_TIMESTAMP)
		return
	 end

--otherwise (if param group is null, ie, if paramgroup has not been configured yet) 
-- insert a group record and a param record
insert into dbo.ParamGroup
	(ParamGroupName,ParamGroupDescription,DTStamp)
values
	('NoWorkRequired','configuration for the value of a NoWorkRequired band',CURRENT_TIMESTAMP)

----return the ID to insert into Param table
set @ParamGroup_ID = (select p.ParamGroup_ID from dbo.ParamGroup p where p.ParamGroupName = 'NoWorkRequired')
insert into dbo.[Param]
			(ParamGroup_ID, ParamValue,ParamDescription,DTStamp)
		values
			(@ParamGroup_ID, @NoWorkRequiredValue, 'the value of a NoWorkRequired band',CURRENT_TIMESTAMP)

      
GO




---------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[InsertNoWorkRequiredBand]
	@WorkTaskID int

AS 

SET NOCOUNT ON;  
    if not exists(select * from [dbo].[TaskBand] tb
	where tb.WorkTask_ID =  @WorkTaskID
	and tb.TaskBand_Weight = 0)
	BEGIN

		exec dbo.UpdateNoWorkRequiredValue 0
		--return our value for use
		declare @NoWorkRequired as float
		set @NoWorkRequired =
		( 
			select p.ParamValue from dbo.ParamGroup g
			inner join dbo.[Param] p
			on g.ParamGroup_ID = p.ParamGroup_ID
			where g.ParamGroupName = 'NoWorkRequired'
		)

		insert into [dbo].[TaskBand]
		(WorkTask_ID,
		TaskBandName,
		TaskBandDescription,
		TaskBand_Weight,
		DTStamp)
		values
		(@WorkTaskID,
		'NoWorkRequired',
		'NoWorkRequired',
		@NoWorkRequired,
		GETDATE())
	END  
GO





---------------------------------------------------------------------------------






SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






/*
An existing work record gets archived for a couple of reasons
Either it's being updated normally bc there was a change in workload since last entered, or it was entered in error
We have also entered archive reasons for a change of submodel, or a late episode expiry - these would be rare
This archives one task, java code can deicde if a loop will run this SP for all submodel tasks in one go or if it runs one task at a time 
*/


CREATE PROCEDURE [dbo].[sp_ArchiveWork] 
	@EpisodeMove_ID int,
	@WorkShiftDate date,
	@WorkShift_ID int,
	@WorkSubModel_ID int,
	@WorkTask_ID as int,
	@ArchiveStaff_ID as int,
	@ArchiveReason_ID int,	-- default reson is update. write code to allow user to change reason?????????????????????????????????????????????????????
	@ArchiveFreeText nvarchar(100) = null

AS   

    SET NOCOUNT ON;

	insert into dbo.WorkArchive
		(
			EpisodeMove_ID,
			WorkShiftDate,
			WorkShift_ID,
			WorkSubModel_ID,
			--WorkTask_ID,
			isOutlier,
			TaskFreeText,
			TaskBand_ID,
			Staff_ID,
			DTStamp,
			ArchiveStaff_ID,
			ArchiveReason_ID,
			ArchiveFreeText,
			ArchiveDTStamp
		)
		select
			w.EpisodeMove_ID,
			w.WorkShiftDate,
			w.WorkShift_ID,
			w.WorkSubModel_ID,
			--w.WorkTask_ID,
			w.isOutlier,
			w.TaskFreeText,
			w.TaskBand_ID,
			w.Staff_ID,
			w.DTStamp,
			@ArchiveStaff_ID,
			@ArchiveReason_ID,
			@ArchiveFreeText,
			GETDATE()
		from dbo.vw_JoinWorkWithTask w
		where
			w.EpisodeMove_ID = @EpisodeMove_ID -- if no wokr record exists where this criteria matches, (if no record exists fo rthi shsift yet), nothing happens, the select statement is null and it inserts null into work archive 
			and w.WorkShiftDate = @WorkShiftDate
			and w.WorkShift_ID = @WorkShift_ID
			and w.WorkSubModel_ID = @WorkSubModel_ID
			and w.WorkTask_ID = @WorkTask_ID

		-- then delete it from dbo.Work
		delete w from dbo.Work w
		inner join dbo.TaskBand b
		on w.TaskBand_ID = b.TaskBand_ID
		inner join dbo.WorkTask t
		on b.WorkTask_ID = t.WorkTask_ID
		where
			w.EpisodeMove_ID = @EpisodeMove_ID
			and w.WorkShiftDate = @WorkShiftDate
			and w.WorkShift_ID = @WorkShift_ID
			and w.WorkSubModel_ID = @WorkSubModel_ID
			and t.WorkTask_ID = @WorkTask_ID
      
GO




------------------------------------------------------------------------


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





/*
This is where the user has selected the bands for a patient and is entering them
This enters one task, java code can use loop to call this for every task in submodel, or can allow user to neter one task at a time
If there is already an identical entry for this patient in this shift/episodeMove then there's no change, we do nothing, just leave it
If there is a change, eg updating, we push the old record into the WorkArchive table and enter the new record

Note
	Need to write different sp for entering an outlier task...that is a task that is  not
	part of the submodel for this ward, but it is part of the patients clinical profile
	and so has to be accounted for
*/






CREATE PROCEDURE [dbo].[sp_InsertWork] 
	@EpisodeMove_ID int,
	@WorkShiftDate as date,
	@WorkShift_ID as int,
	@WorkSubModel_ID as int,
	@WorkTask_ID as int,
	@isOutlier as bit,
	@TaskBand_ID as int,
	@Staff_ID as int,
	@ArchiveReason_ID int = 2, --default will be 2	update	an update gets archived and replaced with latest
	@TaskFreeText as nvarchar(100) = null,
	@ArchiveFreeText as nvarchar(100) = null -- would only have value if user need ed to explain something
	-- bottom 3 go in as null bc for any first time inerts these are irrelevant. it will not be archived. 
	-- we do need them though incase this happens to be a secon dtim einsert, and we take archive reasons.
	-- basically if this is first time insert, we take null archive reasons and dont enter them anywhere so thats why we default them to null

AS   

    SET NOCOUNT ON;

	--if there is an identical record already there, then there is no change so do nothing
	-- otherwise archive the existing record and enter this new record
	-- if not exists is the correct logic here. it means if there is no identical record here
	--which means 
	-- 1. there may be a non-identical record which has to be archived...exec [dbo].[sp_ArchiveWork] will archive the record if it's there ... otherwise it just does nothing
	-- 2. the new record has to be entered
	if not exists 
	(
		select 'x' from dbo.vw_JoinWorkWithTask w 
		where w.EpisodeMove_ID = @EpisodeMove_ID
		and w.WorkShiftDate = @WorkShiftDate
		and w.WorkShift_ID = @WorkShift_ID
		and w.WorkSubModel_ID = @WorkSubModel_ID
		and w.WorkTask_ID = @WorkTask_ID
		and w.TaskBand_ID = @TaskBand_ID
		and 
			(w.TaskFreeText = @TaskFreeText 
			or (w.TaskFreeText is null) and  @TaskFreeText is null)
	)
	begin
		-- archive any existing record
		-- 1. there may be a non-identical record which has to be archived...exec [dbo].[sp_ArchiveWork] will archive the record if it's there ... otherwise it just does nothing
			
		exec [dbo].[sp_ArchiveWork] 
				@EpisodeMove_ID,
				@WorkShiftDate,
				@WorkShift_ID,
				@WorkSubModel_ID,
				@WorkTask_ID,
				@Staff_ID,
				@ArchiveReason_ID,
				@ArchiveFreeText
		
		--and insert the new record
		-- 2. the new record has to be entered
		insert into dbo.Work
		(
			EpisodeMove_ID,
			WorkShiftDate,
			WorkShift_ID,
			WorkSubModel_ID,
			--WorkTask_ID,
			TaskFreeText,
			TaskBand_ID,
			isOutlier,
			Staff_ID,
			DTStamp
		)
		values
		(
			@EpisodeMove_ID,
			@WorkShiftDate,
			@WorkShift_ID,
			@WorkSubModel_ID,
			--@WorkTask_ID,
			@TaskFreeText,
			@TaskBand_ID,
			@isOutlier,
			@Staff_ID,
			GETDATE()
		)

	end -- END if not exists
	
      
GO