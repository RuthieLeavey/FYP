
/*
sp_GetWardPatients
sp_GetCurrentWardPatients
sp_GetCurrentWardPatients_Short
wrote first two w/o realizing how similar they are
last one is better version of 2
review and delete unnecessary SPs
*/


-- An error occurred while executing batch. Error message is: ExecuteReader: CommandText property has not been initialized
-- above error occurs when run. it all works thogh ??????????????????????????????????????????????????

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[sp_GetWardSubModel] 
	@Ward_ID int  

AS   

    SET NOCOUNT ON;  
	select * from [dbo].[vw_GetWardsWithSubModelInclBands] w
	where w.Ward_ID = @Ward_ID
	order by 
		w.WorkTask_ID,
		w.TaskBand_Weight asc
      
GO



---------------------------------------------------------------


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[sp_GetWardPatients] 
	@Ward_ID int,
	@ShiftDate date, -- workshift date. will usually be TODAY but if we are on overnight shiftt, it willl be yesterdays date
	-- one of these SPs calls the vw_getallwardsWcurrentworkshift and then another view filters that down to a specific ward.
	-- our java code callls those, then stores that info from the ward, then calls this SP using that info as input params 
	@WorkShift_ID int 

AS   

    SET NOCOUNT ON;  
	--variables for the start and end of the specified workshift
	declare @ThisWorkShiftStart as datetime
	declare @ThisWorkShiftEnd as datetime

	set @ThisWorkShiftStart = 
		(select cast(@ShiftDate as datetime) + cast(s.StartTime as datetime) from dbo.WorkShift s where s.WorkShift_ID = @WorkShift_ID)

	set @ThisWorkShiftEnd = 
		(select cast(@ShiftDate as datetime) + cast(s.EndTime as datetime) from dbo.WorkShift s where s.WorkShift_ID = @WorkShift_ID)

--if end turns out to be earlier than start, it means it's a night shift that crosses midnight, so increment end by one day
	if @ThisWorkShiftEnd < @ThisWorkShiftStart
	begin
		set @ThisWorkShiftEnd = DATEADD(d,1,@ThisWorkShiftEnd)	
	end


	select p.* 
	from 
	dbo.vw_GetAllPatientsWithDetails p
	where 
	p.Ward_ID = @Ward_ID
	and p.episodeMoveStart <= @ThisWorkShiftEnd -- episode move started at any time before this workshift ended - could have started during it 
	and p.episodeMoveEnd >= @ThisWorkShiftStart -- episode move ends at any time after this workshift ended - could have ended during it 

      
GO

---------------------------------------------------------------------


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




-- When the user selects a ward, this sp is called and it returns the full list of patients on this ward at this time

CREATE PROCEDURE [dbo].[sp_GetCurrentWardPatients] 
	@Ward_ID int
	
AS   

    SET NOCOUNT ON;
	
	declare @ThisWorkShiftStart as datetime --date and time current shift starts
	declare @ThisWorkShiftEnd as datetime -- date and time current shift ends

	select 
		@ThisWorkShiftStart = 
		cast(c.ShiftDate as datetime) + cast(c.StartTime as datetime),
		@ThisWorkShiftEnd =
		case when c.StartTime < c.EndTime 
			then cast(c.ShiftDate as datetime) + cast(c.EndTime as datetime)
		else
			cast(dateadd(d,1,c.ShiftDate) as datetime) + cast(c.EndTime as datetime) end	-- set end to tomorrows date if its overnight shift
	from 
		[dbo].[vw_GetAllWardsWithCurrentWorkShift] c
	where
		c.Ward_ID = @Ward_ID
	
	select
	p.Ward_ID,
	p.WardName,
	p.Bed_ID,
	p.BedName,
	p.BedDescription,
	p.openStatus,
	p.PersistStatus,
	p.Pat_ID,
	p.PatMRN,
	p.PatFirstName,
	p.PatLastName,
	p.PatDOB,
	p.Diag_ID,
	p.DiagnosisName,
	p.DiagnosisDescription,
	p.Spec_ID,
	p.SpecName,
	p.SpecDescription,
	p.Episode_ID,
	p.episodeStart,
	p.episodeEnd,
	p.EpisodeMove_ID,
	p.episodeMoveStart,
	p.episodeMoveEnd,
	p.Param_ID as 'EpisodeStatus_ID',
	p.EpisodeStatus,
	p.EpisodeStatusDescription
	from 
	dbo.vw_GetAllPatientsWithDetails p
	where 
	p.Ward_ID = @Ward_ID
	and p.episodeMoveStart <= @ThisWorkShiftEnd -- episode move started at any time before this workshift ended - could have started during it 
	and p.episodeMoveEnd >= @ThisWorkShiftStart -- episode move ends at any time after this workshift ended - could have ended during it 
	order by p.Bed_ID
      
GO

------------------------------------------------------------

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/*
When the user selects a patient on a ward, this sp is called and it returns the work records entered for this patient for this shift

if there are no work records entered for this chift , it offers the latest entries
java app needs to represent current shift work records different to latest. 
user must know that curr record does not have to be updated (assuming no change), as it's there already for this workshift
but latest is not entered aleady, the system is just telling you that this is the latest but user still have to enter it 

*/
CREATE PROCEDURE [dbo].[sp_GetPatientCurrentAndPastShiftWork] 
	@Ward_ID int,
	@EpisodeMove_ID int 


AS  

	declare @WorkSubModel_ID as int
	declare @currentWorkShiftDate date
	declare @prevWorkShiftDate date
	declare @currentWorkShift_ID int
	declare @prevWorkShift_ID int
	declare @currentWorkShift_Order int
	declare @numShiftsInSequence as int
	declare @prevWorkShiftoverMidNight as int

	--get the submodel in use
	set @WorkSubModel_ID = 
	(select w.WorkSubModel_ID from dbo.Ward w where w.Ward_ID = @Ward_ID)

	-- get the cycle of shifts for this ward and where we are in it

	--how many shifts are in our sequence
	set @numShiftsInSequence = 
	(
	select count(*) from dbo.vw_GetWardsWithSequencesAndShifts s
	where s.Ward_ID = @Ward_ID
	)
	
	select 
	@currentWorkShiftDate = c.ShiftDate,	-- workshift date. will usually be TODAY but if we are on overnight shiftt, it willl be yesterdays date
	@currentWorkShift_ID = c.WorkShift_ID,
	@currentWorkShift_Order = c.WorkShift_Order
	from dbo.vw_GetAllWardsWithCurrentWorkShift c
	where c.Ward_ID = @Ward_ID

	--if we're on the first shift in the sequence, the previous shift is the last shift in the sequence
	if @currentWorkShift_Order = 1
	begin
		select 
		@prevWorkShift_ID = s.WorkShift_ID,
		@prevWorkShiftoverMidNight = s.overMidNight
		from dbo.vw_GetWardsWithSequencesAndShifts s
		where s.Ward_ID = @Ward_ID and s.WorkShift_Order = @numShiftsInSequence
	end
	else -- otherwise it's the shift before it in the sequence
	begin
		select 
		@prevWorkShift_ID = s.WorkShift_ID,
		@prevWorkShiftoverMidNight = s.overMidNight
		from dbo.vw_GetWardsWithSequencesAndShifts s
		where s.Ward_ID = @Ward_ID and s.WorkShift_Order = @currentWorkShift_Order - 1
	end

	--and if the previous shift crossed midnight decrement the date by 1
	set @prevWorkShiftDate = @currentWorkShiftDate
	if @prevWorkShiftoverMidNight = 1
	begin
		set @prevWorkShiftDate = dateadd(d,-1,@prevWorkShiftDate)
	end

	-- then for this episodeMove, workshift, workshiftdate get the work records entered
	--first check if there is an existing record there
	
		select
		'CURRENT WORK RECORDS' as 'WorkStatus',			-- this creates a new column during retrieval named Work Status whcih say ir this is curr/prev
		-- every row will have CURRENT WORK RECORDS in the field for this column
		w.WorkShiftDate,	-- not necessary but return it anyhow to keep consistent with when we have to return latest
		ws.WorkShiftName,	-- not necessary but return it anyhow to keep consistent with when we have to return latest
		w.EpisodeMove_ID,
		t.WorkTask_ID,
		t.WorkTaskName ,
		b.TaskBand_ID,
		b.TaskBandName,
		w.TaskFreeText,
		w.isOutlier,		-- need to display to user, that this is outlier
		-- if we could return outlier as outside of pie, it would be better.
		s.Unique_ID,
		w.DTStamp 
		from dbo.Work w
		inner join dbo.TaskBand b
		on w.TaskBand_ID = b.TaskBand_ID
		inner join dbo.WorkTask t
		on b.WorkTask_ID = t.WorkTask_ID
		inner join dbo.Staff s
		on w.Staff_ID = s.Staff_ID
		inner join dbo.WorkShift ws
		on w.WorkShift_ID = ws.WorkShift_ID   
		where w.EpisodeMove_ID = @EpisodeMove_ID
		and w.WorkShiftDate = @currentWorkShiftDate
		and w.WorkShift_ID = @currentWorkShift_ID
		and w.WorkSubModel_ID = @WorkSubModel_ID
	UNION
		-- if for one shift, only 2/5 tasks were entered, the other taksk dont ocunt, but they dont actually get entered as 0.
		-- they will not add to the count of workscore so they are same as 0.
		-- here though, when we pull latest records, if only 2/5 tasks were entered only 2/5 will be returned 
		-- the 0 tasks arent there to be pulled but user can infer that they were 0
		select
		'PREVIOUS WORK RECORDS' as 'WorkStatus',	-- this creates a new column during retrieval named Work Status whcih say ir this is curr/prev
		-- every row will have PREVIOUS WORK RECORDS in the field for this column
		w.WorkShiftDate, -- the date of the previous entry
		ws.WorkShiftName, -- the workshift name of the previous entry
		w.EpisodeMove_ID,
		t.WorkTask_ID,
		t.WorkTaskName ,
		b.TaskBand_ID,
		b.TaskBandName,
		w.TaskFreeText,
		w.isOutlier,
		s.Unique_ID,
		w.DTStamp 
		from dbo.Work w
		inner join dbo.TaskBand b
		on w.TaskBand_ID = b.TaskBand_ID
		inner join dbo.WorkTask t
		on b.WorkTask_ID = t.WorkTask_ID
		inner join dbo.Staff s
		on w.Staff_ID = s.Staff_ID
		inner join dbo.WorkShift ws
		on w.WorkShift_ID = ws.WorkShift_ID   
		where w.EpisodeMove_ID = @EpisodeMove_ID
		and w.WorkShiftDate = @prevWorkShiftDate
		and w.WorkShift_ID = @prevWorkShift_ID
		and w.WorkSubModel_ID = @WorkSubModel_ID
		--and not in the current
		and t.WorkTask_ID not in
			( 
			select t.WorkTask_ID from dbo.Work w
			inner join dbo.TaskBand b
			on w.TaskBand_ID = b.TaskBand_ID
			inner join dbo.WorkTask t
			on b.WorkTask_ID = t.WorkTask_ID
			where w.EpisodeMove_ID = @EpisodeMove_ID
			and w.WorkShiftDate = @currentWorkShiftDate
			and w.WorkShift_ID = @currentWorkShift_ID
			and w.WorkSubModel_ID = @WorkSubModel_ID
			)
	
	/*
	when the above is returned to our java app, it should be displayed as current or latest
	users must be able to see latest just mean previously entered (ie, a suggestion) so thye know they still havr to enter either same or new input
	And if nothing is returned here (no current or previous work) , we must make that clear on the app
	
	*/

    
GO



--------------------------------------------------------------------------------------------------
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




/*
When the user selects a ward, this sp is called and it returns the full list of patients on this ward at this time
(the system has previously returned the data on the current workshift and date for this ward) 
This sp will have ward only as parameter. 
*/

CREATE PROCEDURE [dbo].[sp_GetCurrentWardPatients_Short] 
	@Ward_ID int
	
AS   

    SET NOCOUNT ON;
	
	declare @ThisWorkShiftStart as datetime --date and time current shift starts
	declare @ThisWorkShiftEnd as datetime -- date and time current shift ends

	select 
		@ThisWorkShiftStart = 
		cast(c.ShiftDate as datetime) + cast(c.StartTime as datetime),
		@ThisWorkShiftEnd =
		case when c.StartTime < c.EndTime 
		then
		cast(c.ShiftDate as datetime) + cast(c.EndTime as datetime)
		else 
		cast(dateadd(d,1,c.ShiftDate) as datetime) + cast(c.EndTime as datetime) end	-- set end to tomorrows date if its overnight shift
	from 
		[dbo].[vw_GetAllWardsWithCurrentWorkShift] c
	where
		c.Ward_ID = @Ward_ID
	
	select
	p.BedName,
	p.Pat_ID,
	p.PatMRN,
	p.PatFirstName,
	p.PatLastName,
	p.PatDOB,
	p.DiagnosisName,
	p.SpecName,
	p.Episode_ID
	from 
	dbo.vw_GetAllPatientsWithDetails p
	where 
	p.Ward_ID = @Ward_ID
	and p.episodeMoveStart <= @ThisWorkShiftEnd -- episode move started at any time before this workshift ended - could have started during it 
	and p.episodeMoveEnd >= @ThisWorkShiftStart -- episode move ends at any time after this workshift ended - could have ended during it 
	order by p.Bed_ID
      
GO

-------------------------------------------------------------------------------------------------------------------------------- 

/*
The user calls this sp to return the outlier tasks - ie those tasks that 
are not part of the submodel being used by this ward
*/

/* we could call this and it would return the outliers and we could pick an outlier, and if we call this again, it would return all tasks not on the pie but it would also return the outlier we already chose, so java needs to make sure we dont pick same outlier twice */

CREATE PROCEDURE [dbo].[sp_GetOutlierTasks] 
	@WorkSubModel_ID int  

AS   

    SET NOCOUNT ON;  
	declare @WorkModel_ID as int
	set @WorkModel_ID =  
	(select s.WorkModel_ID from dbo.WorkSubModel s where s.WorkSubModel_ID = @WorkSubModel_ID)

	select	
	t.WorkTask_ID,
	t.WorkTaskName,
	t.WorkTaskDescription,
	b.TaskBand_ID,
	b.TaskBandName,
	b.TaskBandDescription,
	b.TaskBand_Weight,
	'outlier' as 'tasktype'

	from dbo.WorkTask t
	inner join dbo.TaskBand b
	on t.WorkTask_ID = b.WorkTask_ID
	inner join dbo.WorkModel m
	on t.WorkModel_ID = m.WorkModel_ID
	where t.WorkTask_ID not in
	(
		select st.WorkTask_ID from dbo.WorkSubModel s
		inner join dbo.SubModelTask st
		on s.WorkSubModel_ID = st.WorkSubModel_ID 
		where s.WorkSubModel_ID = @WorkSubModel_ID
	)
	
      
GO


-------------------------------------------------------------------------------------------------------------------------------- 


/*
This is an emergency sp, to be used only during development, to bulk insert work for a patient into every workshift over a given date range
Rather than archiving any records that are already there, it deletes them, and starts from scratch
It enters the default values for all bands
That means everyone has exactly the same work, and we don't really want that
so we will have another emergency script, dbo.sp_UpdateWorkForDateRange_DEV, for development only, to change a few of them
That will come later...for now we just get the default values in there 
*/
CREATE PROCEDURE [dbo].[sp_InsertDefaultWorkForDateRange_DEV] 
	@EpisodeMove_ID int,
	@startDate as datetime,
	@endDate as date
	 

AS   

    SET NOCOUNT ON;
	declare @ward_ID as int
	declare @SubModelDefault_ID as int
	declare @ShiftDate as date
	declare @episode_ID as int

	--make sure this episodemove spans the given date range, ie has started on or before the startdate given here
	--and has not ended before the end date
	if exists
	(
		select 'x' from dbo.EpisodeMove m
		where m.EpisodeMove_ID = @EpisodeMove_ID
		and 
			(m.StartDT > @startDate or m.EndDT < @endDate) --doesn't span the full date range
	)
	begin
		select 'date range is out of synch with episode move'
		return
	end

	--and do the same thing for episode even though we know that should be impossible if episode move is ok
	set @episode_ID = (select m.Episode_ID from dbo.EpisodeMove m where m.EpisodeMove_ID = @EpisodeMove_ID)
	if exists
	(
		select 'x' from dbo.Episode e
		where e.Episode_ID = @episode_ID
		and 
			(e.StartDT > @startDate or e.EndDT < @endDate) --doesn't span the full date range
	)
	begin
		select 'date range is out of synch with episode'
		return
	end

	--if everything is ok we carry on...
	
	-- get the ward for this episode
	set @Ward_ID =
	(
	select w.Ward_ID from dbo.EpisodeMove m
	inner join dbo.Bed b
	on m.Bed_ID = b.Bed_ID
	inner join dbo.Ward w 
	on b.Ward_ID = w.Ward_ID
	where m.EpisodeMove_ID = @EpisodeMove_ID
	)
	--get the submodel default
	set @SubModelDefault_ID = 
	(
	select w.SubModelDefault_ID from dbo.Ward w
	where w.Ward_ID = @Ward_ID
	)
	
	if @SubModelDefault_ID is null
	begin
		select 'no submodel exists for this ward'
		return
	end
	 
	
	--for this we will use RN1 as the nurse who entered the work
	--we know that the ID of RN1 is 1...but just to check
	declare @SystemLogIn_ID as int

	--return the id of the RN1 user 
	set @SystemLogIn_ID = 
	(
		select top(1) s.Staff_ID   
		from 
			dbo.Staff s			
		where 
			s.FirstName = 'System' and s.LastName = 'System'
	)

	if @SystemLogIn_ID is null
	begin
		select 'System System is an invalid staff identifier'
		return
	end

	--delete any existing records for this episode move in this date range - both Work and WorkArchive
	delete from dbo.WorkArchive where EpisodeMove_ID = @EpisodeMove_ID and WorkShiftDate between @startDate and @endDate
	delete from dbo.Work where EpisodeMove_ID = @EpisodeMove_ID and WorkShiftDate between @startDate and @endDate
		
	set @ShiftDate = @startDate
	while @ShiftDate <= @endDate
	begin
		insert into dbo.Work 
			(
			EpisodeMove_ID,
			WorkShiftDate,
			WorkShift_ID,
			WorkSubModel_ID,
			--WorkTask_ID,
			TaskFreeText,
			TaskBand_ID, 
			Staff_ID,
			DTStamp
			)
			select 
			@EpisodeMove_ID,
			@ShiftDate,
			ss.WorkShift_ID, -- how are weincrementing shift ? just before 'end' we increment date but how do we inc shift ??????????????????????????
			d.WorkSubModel_ID,
			--b.WorkTask_ID,
			'developer entering data for date range',
			b.TaskBand_ID, 
			@SystemLogIn_ID,
			GETDATE()
			from dbo.SubModelDefault d
			inner join dbo.SubModelDefaultBand b
			on d.SubModelDefault_ID = b.SubModelDefault_ID
			inner join dbo.Ward w
			on d.SubModelDefault_ID = w.SubModelDefault_ID
			inner join dbo.WorkSequence ws
			on w.WorkSeq_ID = ws.WorkSeq_ID
			inner join dbo.ShiftSequence ss
			on ws.WorkSeq_ID = ss.WorkSeq_ID
			where w.Ward_ID = @ward_ID and d.SubModelDefault_ID = @SubModelDefault_ID
			set @ShiftDate = dateadd(d,1,@ShiftDate)	-- increment date for next work insert.
			-- this only increments the day by one ? how do we increment to next shift ???????????????????????????????????????????????????
		end
	
      
GO

----------------------------------------------------------------
----USE [WMSRH]
--GO

/****** Object:  StoredProcedure [dbo].[sp_UpdateWorkForDateRange_DEV]    Script Date: 10/04/2021 17:16:30 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




/*
Previously, in another script, dbo.sp_InsertDefaultWorkForDateRange_DEV, we bulk inserted a whole lot of work over a date range.
In that script we used the default band values to make it quick.

That meant they all had the same work...and we don't really want that
This script allows us to change the band values
We can only change one task/band value at a time, but we change it over a whole date range
This way we can set it up to suit what we want for analysis
*/

CREATE PROCEDURE [dbo].[sp_UpdateWorkForDateRange_DEV] 
	@EpisodeMove_ID int,	
	@startDate as date,
	@endDate as date,
	@WorkTask_ID as int, -- the task we're changing...LEAVE IT IN HERE AS A SAFETY MEASURE
	@TaskBand_ID as int,  --	the new band ... we replace the old band in dbo.Work with this new band
	@allShifts as tinyint,  -- if this is 1 we update all shifts and ignore the value in @WorkShift_ID
	@WorkShift_ID as int = 0 -- the workshift to be edited if the value of @allShifts is 0 ... this allows us to be more specific about the update...
	-- we might want to show a trend in one shift that doesn't happen in any other shift

AS   

    SET NOCOUNT ON;

	--check that the episode move exists in dbo.Work during this date range
	if not exists
	(
		select 'x' from dbo.Work where EpisodeMove_ID = @EpisodeMove_ID
		and WorkShiftDate between @startDate and @endDate
	)
	begin
		select 'no record exists for this episode move during this date range'
		return
	end


	-- check that this task exists in dbo.Work for this episode during this date range
	if not exists
	(
		select 'x' from dbo.vw_JoinWorkWithTask where WorkTask_ID = @WorkTask_ID and EpisodeMove_ID = @EpisodeMove_ID
		and WorkShiftDate between @startDate and @endDate
	)
	begin
		select 'no record exists for this task in this episode move during this date range'
		return
	end

	--check that the new band actually belongs to the given task...that's why we have a taskid parameter in this sp
	if not exists
	(
		select 'x' from dbo.TaskBand where WorkTask_ID = @WorkTask_ID and TaskBand_ID = @TaskBand_ID
	)
	begin
		select 'Given band does not belong to given task'
		return
	end
	--select @allShifts
	--check that the value of @allShifts is either 0 or 1
	if @allShifts <> 0 and @allShifts <> 1
	begin
		select '@allShifts must be either 0 or 1'
		return
	end

	--if @allShifts is 0 then we want to edit only the given shift...check that it exists in range
	if @allShifts = 0
	begin
		if not exists
		(
			select 'x' from dbo.Work where WorkShift_ID = @WorkShift_ID and EpisodeMove_ID = @EpisodeMove_ID
			and WorkShiftDate between @startDate and @endDate
		)
			begin
				select 'no record exists for this workshift in this episode move during this date range'
				return	
			end		
	end

	

	--if everything is ok we carry on...

	--first store the old values for displaying afterwards
	declare @oldBand table
		(
		WardName nvarchar(50),
		BedName nvarchar(50),
		PatMRN nvarchar(50),
		PatFirstName nvarchar(50),
		PatLastName nvarchar(50),
		EpisodeMove_ID int, 
		WorkShiftDate date,
		WorkShift_ID int,
		WorkShiftName nvarchar(50), 
		StartTime time, 
		EndTime time, 
		WorkTask_ID int, 
		WorkTaskName nvarchar(50),
		TaskBand_ID int,
		TaskBandName nvarchar(50),
		TaskBand_Weight float
		)
	insert into @oldBand
	(
		WardName ,
		BedName ,
		PatMRN ,
		PatFirstName ,
		PatLastName ,
		EpisodeMove_ID , 
		WorkShiftDate,
		WorkShift_ID,
		WorkShiftName, 
		StartTime, 
		EndTime, 
		WorkTask_ID, 
		WorkTaskName,
		TaskBand_ID,
		TaskBandName ,
		TaskBand_Weight
	)
	select
	wd.WardName,
	bd.BedName,
	p.PatMRN,
	p.PatFirstName,
	p.PatLastName,
	w.EpisodeMove_ID, 
	w.WorkShiftDate,
	s.WorkShift_ID,
	s.WorkShiftName, 
	s.StartTime, 
	s.EndTime, 
	w.WorkTask_ID, 
	t.WorkTaskName,
	w.TaskBand_ID,
	b.TaskBandName,
	b.TaskBand_Weight
	from 
	dbo.vw_JoinWorkWithTask w 
	inner join dbo.WorkShift s on w.WorkShift_ID = s.WorkShift_ID
	inner join dbo.WorkTask t on w.WorkTask_ID = t.WorkTask_ID
	inner join dbo.TaskBand b on w.TaskBand_ID = b.TaskBand_ID
	inner join dbo.EpisodeMove em on w.EpisodeMove_ID = em.EpisodeMove_ID
	inner join dbo.Episode e on em.Episode_ID = e.Episode_ID
	inner join dbo.Patient p on e.Pat_ID = p.Pat_ID  
	inner join dbo.Bed bd on em.Bed_ID = bd.Bed_ID
	inner join dbo.Ward wd on bd.Ward_ID = wd.Ward_ID
	where 
	w.EpisodeMove_ID = @EpisodeMove_ID
	and w.WorkShiftDate between @startDate and @endDate
	 
	--just do the update
	if @allShifts = 0 -- update only the given shift
	begin
		update w set TaskBand_ID = @TaskBand_ID -- update the band with the new band
		from dbo.Work w  
		inner join dbo.TaskBand b 
		on w.TaskBand_ID = b.TaskBand_ID
		inner join dbo.WorkTask t
		on b.WorkTask_ID = t.WorkTask_ID
		where w.EpisodeMove_ID = @EpisodeMove_ID 
		and t.WorkTask_ID = @WorkTask_ID 
		and w.WorkShiftDate between @startDate and @endDate
		and w.WorkShift_ID = @WorkShift_ID
	end
	else -- update all shifts
	begin
		update w set TaskBand_ID = @TaskBand_ID -- update the band with the new band
		from dbo.Work w  
		inner join dbo.TaskBand b 
		on w.TaskBand_ID = b.TaskBand_ID
		inner join dbo.WorkTask t
		on b.WorkTask_ID = t.WorkTask_ID
		where w.EpisodeMove_ID = @EpisodeMove_ID 
		and t.WorkTask_ID = @WorkTask_ID 
		and w.WorkShiftDate between @startDate and @endDate
	end
	
	--then return all records for this episodemove between the start and end dates so we can see our changes
	
	select
	case when o.TaskBand_ID = n.TaskBand_ID then '' else 'changed' end'change', 
	o.WardName,
	o.BedName,
	o.PatMRN,
	o.PatFirstName,
	o.PatLastName,
	o.EpisodeMove_ID,
	o.WorkShiftDate,
	o.WorkShift_ID,
	o.WorkShiftName,
	o.StartTime,
	o.EndTime,
	o.WorkTask_ID,
	o.WorkTaskName,
	o.TaskBand_ID as 'oldBandID',
	o.TaskBandName as 'oldBandName',
	o.TaskBand_Weight  as 'oldBandWeight',
	n.TaskBand_ID as 'newBandID',
	n.TaskBandName as 'newBandName',
	n.TaskBand_Weight  as 'newBandWeight'
	
	from
	@oldBand o
	inner join
	(
	select
	wd.WardName,
	bd.BedName,
	p.PatMRN,
	p.PatFirstName,
	p.PatLastName,
	w.EpisodeMove_ID, 
	w.WorkShiftDate,
	s.WorkShift_ID,
	s.WorkShiftName, 
	s.StartTime, 
	s.EndTime, 
	w.WorkTask_ID, 
	t.WorkTaskName,
	w.TaskBand_ID,
	b.TaskBandName,
	b.TaskBand_Weight
	from 
	dbo.vw_JoinWorkWithTask w 
	inner join dbo.WorkShift s on w.WorkShift_ID = s.WorkShift_ID
	inner join dbo.WorkTask t on w.WorkTask_ID = t.WorkTask_ID
	inner join dbo.TaskBand b on w.TaskBand_ID = b.TaskBand_ID
	inner join dbo.EpisodeMove em on w.EpisodeMove_ID = em.EpisodeMove_ID
	inner join dbo.Episode e on em.Episode_ID = e.Episode_ID
	inner join dbo.Patient p on e.Pat_ID = p.Pat_ID  
	inner join dbo.Bed bd on em.Bed_ID = bd.Bed_ID
	inner join dbo.Ward wd on bd.Ward_ID = wd.Ward_ID
	where 
	w.EpisodeMove_ID = @EpisodeMove_ID
	and w.WorkShiftDate between @startDate and @endDate
	) n -- n for new
	 on o.EpisodeMove_ID = n.EpisodeMove_ID
	 and o.WorkShiftDate = n.WorkShiftDate
	 and o.WorkShift_ID = n.WorkShift_ID
	 and o.WorkTask_ID = n.WorkTask_ID 
	 order by o.WorkShiftDate, o.WorkShift_ID,o.WorkTask_ID, o.TaskBand_ID
GO

--------------------------------------------------------------------
--USE [WMSRH]
GO

/****** Object:  StoredProcedure [dbo].[sp_UpdateWorkForDateRangeDayOfWeek_DEV]    Script Date: 11/04/2021 15:21:29 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




/*
Previously, in another script, dbo.sp_InsertDefaultWorkForDateRange_DEV, we bulk inserted a whole lot of work over a date range.
In that script we used the default band values to make it quick.

That meant they all had the same work...and we don't really want that
This script allows us to change the band values
We can only change one task/band value at a time, but we change it over a whole date range
This way we can set it up to suit what we want for analysis
*/
CREATE PROCEDURE [dbo].[sp_UpdateWorkForDateRangeDayOfWeek_DEV] 
	@Staff_ID int,		-- staffID we are changing
	@EpisodeMove_ID int,	
	@startDate as date,
	@endDate as date,
	@WorkTask_ID as int, -- the task we're changing
	@TaskBand_ID as int,  --	the new band ... we replace the old band in dbo.Work with this new band
	@Mon as int,
	@Tue as int,
	@Wed as int,
	@Thu as int,
	@Fri as int,
	@Sat as int,
	@Sun as int,
	@allShifts as tinyint,  -- if this is 1 we update all shifts and ignore the value in @WorkShift_ID
	@WorkShift_ID as int = 0 -- the workshift to be edited if the value of @allShifts is 0 ... this allows us to be more specific about the update...
	-- we might want to show a trend in one shift that doesn't happen in any other shift

AS   

    SET NOCOUNT ON;

	--check that the episode move exists in dbo.Work during this date range
	if not exists
	(
		select 'x' from dbo.Work where EpisodeMove_ID = @EpisodeMove_ID
		and WorkShiftDate between @startDate and @endDate
	)
	begin
		select 'no record exists for this episode move during this date range'
		return
	end


	-- check that this task exists in dbo.Work for this episode during this date range
	if not exists
	(
		select 'x' from dbo.vw_JoinWorkWithTask where WorkTask_ID = @WorkTask_ID and EpisodeMove_ID = @EpisodeMove_ID
		and WorkShiftDate between @startDate and @endDate
	)
	begin
		select 'no record exists for this task in this episode move during this date range'
		return
	end

	--check that the new band actually belongs to the given task...that's why we have a taskid parameter in this sp
	if not exists
	(
		select 'x' from dbo.TaskBand where WorkTask_ID = @WorkTask_ID and TaskBand_ID = @TaskBand_ID
	)
	begin
		select 'Given band does not belong to given task'
		return
	end
	--select @allShifts
	--check that the value of @allShifts is either 0 or 1
	if @allShifts <> 0 and @allShifts <> 1
	begin
		select '@allShifts must be either 0 or 1'
		return
	end

	--if @allShifts is 0 then we want to edit only the given shift...check that it exists in range
	if @allShifts = 0
	begin
		if not exists
		(
			select 'x' from dbo.Work where WorkShift_ID = @WorkShift_ID and EpisodeMove_ID = @EpisodeMove_ID
			and WorkShiftDate between @startDate and @endDate
		)
			begin
				select 'no record exists for this workshift in this episode move during this date range'
				return	
			end		
	end
	--check that all weekdays are either 0 or 1 and that at least one of them is 1
	if 
	(
		(@Mon <> 0 and @Mon <> 1)
		and
		(@Tue <> 0 and @Tue <> 1)
		and
		(@Wed <> 0 and @Wed <> 1)
		and
		(@Thu <> 0 and @Thu <> 1)
		and
		(@Fri <> 0 and @Fri <> 1)
		and
		(@Sat <> 0 and @Sat <> 1)
		and
		(@Sun <> 0 and @Sun <> 1)
	)
	begin
		select 'all weekday values must be either 0 or 1'
		return	
	end 

	-- and that at least one of then is a 1
if 
	(
		(@Mon = 0)
		and
		(@Tue = 0)
		and
		(@Wed = 0)
		and
		(@Thu = 0)
		and
		(@Fri = 0)
		and
		(@Sat = 0)
		and
		(@Sun = 0)
	)
	begin
		select 'at least one weekday must have value of 1'
		return	
	end 
	--if everything is ok we carry on...

	--first store the old values for displaying afterwards
	declare @oldBand table
		(
		Staff_ID int,
		WardName nvarchar(50),
		BedName nvarchar(50),
		PatMRN nvarchar(50),
		PatFirstName nvarchar(50),
		PatLastName nvarchar(50),
		EpisodeMove_ID int, 
		WorkShiftDate date,
		WorkShift_ID int,
		WorkShiftName nvarchar(50), 
		StartTime time, 
		EndTime time, 
		WorkTask_ID int, 
		WorkTaskName nvarchar(50),
		TaskBand_ID int,
		TaskBandName nvarchar(50),
		TaskBand_Weight float
		)
	insert into @oldBand
	(
		Staff_ID, 
		WardName ,
		BedName ,
		PatMRN ,
		PatFirstName ,
		PatLastName ,
		EpisodeMove_ID , 
		WorkShiftDate,
		WorkShift_ID,
		WorkShiftName, 
		StartTime, 
		EndTime, 
		WorkTask_ID, 
		WorkTaskName,
		TaskBand_ID,
		TaskBandName ,
		TaskBand_Weight
	)
	select
	w.Staff_ID,
	wd.WardName,
	bd.BedName,
	p.PatMRN,
	p.PatFirstName,
	p.PatLastName,
	w.EpisodeMove_ID, 
	w.WorkShiftDate,
	s.WorkShift_ID,
	s.WorkShiftName, 
	s.StartTime, 
	s.EndTime, 
	w.WorkTask_ID, 
	t.WorkTaskName,
	w.TaskBand_ID,
	b.TaskBandName,
	b.TaskBand_Weight
	from 
	dbo.vw_JoinWorkWithTask w 
	inner join dbo.WorkShift s on w.WorkShift_ID = s.WorkShift_ID
	inner join dbo.WorkTask t on w.WorkTask_ID = t.WorkTask_ID
	inner join dbo.TaskBand b on w.TaskBand_ID = b.TaskBand_ID
	inner join dbo.EpisodeMove em on w.EpisodeMove_ID = em.EpisodeMove_ID
	inner join dbo.Episode e on em.Episode_ID = e.Episode_ID
	inner join dbo.Patient p on e.Pat_ID = p.Pat_ID  
	inner join dbo.Bed bd on em.Bed_ID = bd.Bed_ID
	inner join dbo.Ward wd on bd.Ward_ID = wd.Ward_ID
	where 
	w.EpisodeMove_ID = @EpisodeMove_ID
	and w.WorkShiftDate between @startDate and @endDate
	 


	--just do the update
	if @allShifts = 0 -- update only the given shift
	begin
		update w set TaskBand_ID = @TaskBand_ID, -- update the band with the new band
					Staff_ID = @Staff_ID
		from dbo.Work w  
		inner join dbo.TaskBand b 
		on w.TaskBand_ID = b.TaskBand_ID
		inner join dbo.WorkTask t
		on b.WorkTask_ID = t.WorkTask_ID
		where w.EpisodeMove_ID = @EpisodeMove_ID 
		and t.WorkTask_ID = @WorkTask_ID 
		and w.WorkShiftDate between @startDate and @endDate
		and w.WorkShift_ID = @WorkShift_ID
		and
		(
			(@Mon = 1 and datepart(weekday, w.WorkShiftDate) = 2)
			or
			(@Tue = 1 and datepart(weekday, w.WorkShiftDate) = 3)
			or
			(@Wed = 1 and datepart(weekday, w.WorkShiftDate) = 4)
			or
			(@Thu = 1 and datepart(weekday, w.WorkShiftDate) = 5)
			or
			(@Fri = 1 and datepart(weekday, w.WorkShiftDate) = 6)
			or
			(@Sat = 1 and datepart(weekday, w.WorkShiftDate) = 7)
			or
			(@Sun = 1 and datepart(weekday, w.WorkShiftDate) = 1)
		)
	end


	else -- update all shifts
	begin
		update w set TaskBand_ID = @TaskBand_ID, -- update the band with the new band
					Staff_ID = @Staff_ID
		from dbo.Work w  
		inner join dbo.TaskBand b 
		on w.TaskBand_ID = b.TaskBand_ID
		inner join dbo.WorkTask t
		on b.WorkTask_ID = t.WorkTask_ID
		where w.EpisodeMove_ID = @EpisodeMove_ID 
		and t.WorkTask_ID = @WorkTask_ID 
		and w.WorkShiftDate between @startDate and @endDate
		and
		(
			(@Mon = 1 and datepart(weekday, w.WorkShiftDate) = 2)
			or
			(@Tue = 1 and datepart(weekday, w.WorkShiftDate) = 3)
			or
			(@Wed = 1 and datepart(weekday, w.WorkShiftDate) = 4)
			or
			(@Thu = 1 and datepart(weekday, w.WorkShiftDate) = 5)
			or
			(@Fri = 1 and datepart(weekday, w.WorkShiftDate) = 6)
			or
			(@Sat = 1 and datepart(weekday, w.WorkShiftDate) = 7)
			or
			(@Sun = 1 and datepart(weekday, w.WorkShiftDate) = 1)
		)
	end
	


	--then return all records for this episodemove between the start and end dates so we can see our changes
	
	select
	case when o.TaskBand_ID = n.TaskBand_ID then '' else 'changedBand' end'changeBand?', 
	case when o.Staff_ID = n.Staff_ID then '' else 'changedStaff' end 'changeStaff?',
	o.WardName,
	o.BedName,
	o.PatMRN,
	o.PatFirstName,
	o.PatLastName,
	o.EpisodeMove_ID,
	o.WorkShiftDate,
	datename(weekday,o.WorkShiftDate) as 'weekday',
	o.WorkShift_ID,
	o.WorkShiftName,
	o.StartTime,
	o.EndTime,
	o.WorkTask_ID,
	o.WorkTaskName,
	o.TaskBand_ID as 'oldBandID',
	o.TaskBandName as 'oldBandName',
	o.TaskBand_Weight  as 'oldBandWeight',
	n.TaskBand_ID as 'newBandID',
	n.TaskBandName as 'newBandName',
	n.TaskBand_Weight  as 'newBandWeight',
	o.Staff_ID as 'oldStaffID',
	n.Staff_ID as 'newStaffID'
	
	from
	@oldBand o
	inner join
	(
	select
	w.Staff_ID,
	wd.WardName,
	bd.BedName,
	p.PatMRN,
	p.PatFirstName,
	p.PatLastName,
	w.EpisodeMove_ID, 
	w.WorkShiftDate,
	s.WorkShift_ID,
	s.WorkShiftName, 
	s.StartTime, 
	s.EndTime, 
	w.WorkTask_ID, 
	t.WorkTaskName,
	w.TaskBand_ID,
	b.TaskBandName,
	b.TaskBand_Weight
	from 
	dbo.vw_JoinWorkWithTask w 
	inner join dbo.WorkShift s on w.WorkShift_ID = s.WorkShift_ID
	inner join dbo.WorkTask t on w.WorkTask_ID = t.WorkTask_ID
	inner join dbo.TaskBand b on w.TaskBand_ID = b.TaskBand_ID
	inner join dbo.EpisodeMove em on w.EpisodeMove_ID = em.EpisodeMove_ID
	inner join dbo.Episode e on em.Episode_ID = e.Episode_ID
	inner join dbo.Patient p on e.Pat_ID = p.Pat_ID  
	inner join dbo.Bed bd on em.Bed_ID = bd.Bed_ID
	inner join dbo.Ward wd on bd.Ward_ID = wd.Ward_ID
	where 
	w.EpisodeMove_ID = @EpisodeMove_ID
	and w.WorkShiftDate between @startDate and @endDate
	) n -- n for new
	 on o.EpisodeMove_ID = n.EpisodeMove_ID
	 and o.WorkShiftDate = n.WorkShiftDate
	 and o.WorkShift_ID = n.WorkShift_ID
	 and o.WorkTask_ID = n.WorkTask_ID 
	 order by o.WorkShiftDate, o.WorkShift_ID,o.WorkTask_ID, o.TaskBand_ID
GO