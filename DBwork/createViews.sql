-- An error occurred while executing batch. Error message is: ExecuteReader: CommandText property has not been initialized
-- above error occurs on run. i think it all works though ??????????????????????????????????????????????



SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





/*
For normalisation reasons we can't have the taskid in the work table
But we often need it along with the work table
This view simply joins the work table back to the task
*/
CREATE VIEW [dbo].[vw_JoinWorkWithTask]
AS

select 
	w.Work_ID, 
	w.EpisodeMove_ID,
	w.WorkShiftDate,
	w.WorkShift_ID,
	w.WorkSubModel_ID,
	w.TaskFreeText,
	w.TaskBand_ID,
	w.isOutlier,
	w.Staff_ID,
	w.DTStamp,
	t.WorkModel_ID,
	t.WorkTask_ID,
	t.WorkTaskName,
	t.WorkTaskDescription,
	t.WorkModel_Ratio
from 
	dbo.Work w
	inner join dbo.TaskBand b
on 
	w.TaskBand_ID = b.TaskBand_ID
	inner join dbo.WorkTask t
on 
	b.WorkTask_ID = t.WorkTask_ID

GO






--------------------------------------------------------------------------------




SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[vw_GetSequencesAndShifts]
AS

select 
	wq.WorkSeq_ID, 
	wq.WorkSeqName, 
	wq.WorkSeqDescription,
	sh.WorkShift_ID,
	sh.WorkShiftName,
	sh.StartTime,
	sh.EndTime,
	sq.ShiftSeq_ID,
	sq.WorkShift_Order,
	datediff(mi,sh.StartTime,sh.EndTime) as 'duration', -- duration is minus duration (8hrs = -8hrs) if shift is overnight
	case when datediff(mi,sh.StartTime,sh.EndTime) > 0
	then 0 else 1 end 'overMidNight'
 
from 
	dbo.WorkSequence wq
	inner join dbo.ShiftSequence sq 
	on wq.WorkSeq_ID = sq.WorkSeq_ID --join sequence with its list of participating shifts
	inner join dbo.WorkShift sh
	on sh.WorkShift_ID = sq.WorkShift_ID -- join work shift in the sequence back to the actual work shifts


GO



--------------------------------------------------------------------------------------------------------------------------------------------




SET ANSI_NULLS ON
GO



SET QUOTED_IDENTIFIER ON
GO



CREATE VIEW [dbo].[vw_GetSubModelsAndTasks]
AS
select
	wm.WorkModel_ID, 
	wm.WorkModelName,
	wm.WorkModelDescription, 
	ws.WorkSubModel_ID, 
	ws.WorkSubModelName,
	ws.WorkSubModelDescription,
	wt.WorkTask_ID,
	wt.WorkTaskName,
	wt.WorkTaskDescription,
	wt.WorkModel_Ratio
from
	dbo.WorkModel wm
	inner join dbo.WorkSubModel ws
	on wm.WorkModel_ID = ws.WorkModel_ID
	inner join dbo.SubModelTask st
	on st.WorkSubModel_ID = ws.WorkSubModel_ID
	inner join dbo.WorkTask wt
	on wt.WorkTask_ID = st.WorkTask_ID
	
GO

------------------------------------------------------------------------




SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[vw_GetSubModelRatioTotal]
AS
select 
	st.WorkSubModel_ID,
	sum(st.WorkModel_Ratio) as 'TotalSubModelRatio' -- will be used later to get the new pro rata ratios
from
	[dbo].[vw_GetSubModelsAndTasks] st
group by
	st.WorkSubModel_ID -- summed within each submodel

GO






-----------------------------------------------------------------------




SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[vw_GetSubModelTaskRatio]
AS
select 
	st.*, 
	st.WorkModel_Ratio * 100/rt.TotalSubModelRatio as 'TaskSubModelRatio', --simple pro rata maths
	rt.TotalSubModelRatio
 
from
	[dbo].[vw_GetSubModelsAndTasks] st
	inner join dbo.vw_GetSubModelRatioTotal rt
	on 
	st.WorkSubModel_ID = rt.WorkSubModel_ID

GO

------------------------------------------------------------------------



SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[vw_GetWardsWithSequencesAndShifts]
AS

select 
	w.Ward_ID, 
	w.WardName,
	ss.*
 
from 
	dbo.Ward w
	left outer join dbo.vw_GetSequencesAndShifts ss -- outer join to ensure ward is returned even if it has no sequence associated
	on w.WorkSeq_ID = ss.WorkSeq_ID --join ward with sequence

GO






--------------------------------------------------------------------------------------------------------------------------------------------



SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE VIEW [dbo].[vw_GetWardsWithSubModel]
AS
select 
	w.Ward_ID, 
	w.WardName,
	r.*	
	from
	dbo.Ward w
	left outer join [dbo].[vw_GetSubModelTaskRatio] r		--outer join to ensure ward is returned even if it doesn't have a submodel
	on w.WorkSubModel_ID = r.WorkSubModel_ID 
	
	

GO


------------------------------------------------------------------




SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE VIEW [dbo].[vw_GetWardsWithSubModelInclBands]
AS
select 
	wsm.*,
	b.TaskBand_ID,
	b.TaskBandName,
	b.TaskBandDescription,
	b.TaskBand_Weight
	from
	dbo.vw_GetWardsWithSubModel wsm
	inner join dbo.TaskBand b
	on wsm.WorkTask_ID = b.WorkTask_ID
	
	

GO

-----------------------------------------------------------------------------


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE VIEW [dbo].[vw_GetWardsWithSubModelAndDefaults]
AS

SELECT distinct
	w.Ward_ID, 
	w.WardName,
	w.WardDescription,
	s.WorkSubModel_ID,
	s.WorkSubModelName,
	s.WorkSubModelDescription,
	t.WorkTask_ID,
	t.WorkTaskName,
	t.WorkTaskDescription,
	tr.TaskSubModelRatio,
	b.TaskBand_ID,
	b.TaskBand_Weight,
	b.TaskBandName,
	b.TaskBandDescription,
	case when b.TaskBand_ID = db.TaskBand_ID then 'Yes' else 'No' end 'is default',
	d.SubModelDefault_ID,
	d.SubModelDefaultName,
	d.SubModelDefaultDescription,
	db.TaskBand_ID as 'default Band'
FROM
	dbo.Ward w
	left outer join  dbo.WorkSubModel s 
	on 
	w.WorkSubModel_ID = s.WorkSubModel_ID -- join ward to submodel if it has one
	inner join dbo.SubModelTask st
	on
	s.WorkSubModel_ID = st.WorkSubModel_ID --join submodel to submodel tasks
	inner join dbo.WorkTask t
	on
	st.WorkTask_ID = t.WorkTask_ID -- join submodel tasks to real tasks
	inner join dbo.TaskBand b
	on 
	t.WorkTask_ID = b.WorkTask_ID -- join task to bands
	inner join [dbo].[vw_GetSubModelTaskRatio] tr
	on tr.WorkSubModel_ID = s.WorkSubModel_ID --join submodel with view that calculates its task ratios
	and tr.WorkTask_ID = t.WorkTask_ID
	left outer join dbo.SubModelDefault d
	on
	w.SubModelDefault_ID = d.SubModelDefault_ID  -- join ward to default if it has one (default is the default bands)
	inner join dbo.SubModelDefaultBand db
	on 
	d.SubModelDefault_ID = db.SubModelDefault_ID -- join default to its default bands
	inner join dbo.TaskBand dtb
	on 
	db.TaskBand_ID = dtb.TaskBand_ID -- and join those bands to their native bands
	and t.WorkTask_ID = dtb.WorkTask_ID -- and join the parent tasks of the default bands back to the task table	

GO




--------------------------------------------------------------------------------------------------------------------------------------------




SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE VIEW [dbo].[vw_GetAllPatientsWithDetails]
AS


select  
	p.Pat_ID,
	p.PatMRN,
	p.PatFirstName,
	p.PatLastName,
	p.PatDOB,
	e.Episode_ID,
	e.StartDT as 'episodeStart',
	e.EndDT as 'episodeEnd',
	m.EpisodeMove_ID,
	pm.Param_ID,
	pm.ParamValue as 'EpisodeStatus',
	pm.ParamDescription as 'EpisodeStatusDescription',	
	m.StartDT as 'episodeMoveStart',
	m.EndDT as 'episodeMoveEnd',
	b.Bed_ID,
	b.BedName,
	b.BedDescription,
	case when b.OpenStatus = 1 then 'Open' else 'Closed' end 'openStatus',
	case when b.PersistStatus = 1 then 'Permanent' else 'Temporary' end 'PersistStatus',
	w.Ward_ID,
	w.WardName,
	w.WardDescription,
	d.Dep_ID,
	d.DepName,
	d.DepDescription,
	ds.Diag_ID,
	ds.DiagnosisName,
	ds.DiagnosisDescription,
	s.Spec_ID,
	s.SpecName,
	s.SpecDescription

	from 
	dbo.Patient p
	inner join dbo.Episode e
	on p.Pat_ID = e.Pat_ID			--join patient with episode
	inner join dbo.EpisodeMove m
	on e.Episode_ID = m.Episode_ID	--join episode with episode move (during patient's stay we track their move from one ward to another)
	inner join dbo.Bed b
	on m.Bed_ID = b.Bed_ID		-- join episode move with be
	inner join dbo.Ward w
	on b.Ward_ID = w.Ward_ID	-- join bed with ward
	inner join dbo.Department d
	on w.Dep_ID = d.Dep_ID		-- join ward with department
	inner join dbo.Diagnosis ds
	on e.Diag_ID = ds.Diag_ID	-- join episode with diagnosis
	inner join dbo.[Param] pm
	on m.EpStatus = pm.Param_ID -- join episode status back to param
	inner join dbo.ParamGroup pg
	on pm.ParamGroup_ID = pg.ParamGroup_ID and pg.ParamGroupName = 'EpisodeStatus' -- join param to param group (might not need this here)
	inner join dbo.Specialty s
	on ds.Spec_ID = s.Spec_ID	-- join diagnosis with specialty


GO


----------------------------------------------------------------------------


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[vw_GetAllWardsWithCurrentWorkShift]
AS


select
	s.Ward_ID,
	s.WardName,
	s.WorkShift_ID, 
	s.WorkShift_Order,
	s.WorkShiftName,
	s.StartTime,
	cast(CURRENT_TIMESTAMP as time) as 'currentTime',
	s.EndTime,
	--s.duration,
	s.overMidNight,
	case when s.overMidNight = 0		--does not cross midnight
		and datediff(mi,s.StartTime,cast(CURRENT_TIMESTAMP as time)) >= 0 -- current time is greater than start time
		and datediff(mi,s.EndTime,cast(CURRENT_TIMESTAMP as time)) <= 0	--current time is less than end time
		then 1

	when s.overMidNight = 1				-- does cross midnight
		and datediff(mi,s.StartTime,cast(CURRENT_TIMESTAMP as time)) >= 0 --current time is greater than start time
		and datediff(mi,s.EndTime,cast(CURRENT_TIMESTAMP as time)) >= 0  -- current time is greater than end time
		then 1						-- this is the current shift, and current time is between shift start and midnight

	when s.overMidNight = 1				-- does cross midnight
		and datediff(mi,s.StartTime,cast(CURRENT_TIMESTAMP as time)) <= 0 --current time is less than start time
		and datediff(mi,s.EndTime,cast(CURRENT_TIMESTAMP as time)) <= 0  -- current time is less than end time
		then 1						-- this is the current shift, and current time is between midnight and shift end
	else 0 

	end 'currentShift', -- flag shift as current or not 

	case when s.overMidNight = 0		--does not cross midnight
		and datediff(mi,s.StartTime,cast(CURRENT_TIMESTAMP as time)) >= 0 -- current time is greater than start time
		and datediff(mi,s.EndTime,cast(CURRENT_TIMESTAMP as time)) <= 0  --current time is less than end time
		then cast(CURRENT_TIMESTAMP as date)  -- it's the current shift - therefore current date
	
	when s.overMidNight = 1				-- does cross midnight
		and datediff(mi,s.StartTime,cast(CURRENT_TIMESTAMP as time)) >= 0 --current time is greater than start time
		and datediff(mi,s.EndTime,cast(CURRENT_TIMESTAMP as time)) >= 0  -- current time is greater than end time
		then cast(CURRENT_TIMESTAMP as date) -- no change to the date. -- current shift crossing midnight and time is between shift start and midnight
	
	when s.overMidNight = 1				-- does cross midnight
		and datediff(mi,s.StartTime,cast(CURRENT_TIMESTAMP as time)) <= 0 --current time is less than start time
		and datediff(mi,s.EndTime,cast(CURRENT_TIMESTAMP as time)) <= 0  -- current time is less than end time
		then dateadd(d,-1,cast(CURRENT_TIMESTAMP as date)) --shift started yesterday so holds start date - decrement by 1. -- current shift crossing midnight and the time is between midnight and shift end

	end 'ShiftDate'

	from 
	dbo.vw_GetWardsWithSequencesAndShifts s
	where
	(
	s.overMidNight = 0		--does not cross midnight
		and datediff(mi,s.StartTime,cast(CURRENT_TIMESTAMP as time)) >= 0 -- current time is greater than start time
		and datediff(mi,s.EndTime,cast(CURRENT_TIMESTAMP as time)) <= 0	--current time is less than end time
	)
	or
	(	
	s.overMidNight = 1				-- does cross midnight
		and datediff(mi,s.StartTime,cast(CURRENT_TIMESTAMP as time)) >= 0 --current time is greater than start time
		and datediff(mi,s.EndTime,cast(CURRENT_TIMESTAMP as time)) >= 0  -- current time is greater than end time
							-- this is the current shift, and current time is between shift start and midnight
	)
	or
	(
	s.overMidNight = 1				-- does cross midnight
		and datediff(mi,s.StartTime,cast(CURRENT_TIMESTAMP as time)) <= 0 --current time is less than start time
		and datediff(mi,s.EndTime,cast(CURRENT_TIMESTAMP as time)) <= 0  -- current time is less than end time
	)							-- this
	

GO




--------------------------------------------------------------------------------------------------------------------------------------------


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[vw_GetAdjustedBandWeight]
AS

	select 
	b.TaskBand_ID,
	b.WorkTask_ID,
	b.TaskBandName,
	b.TaskBandDescription,
	b.TaskBand_Weight as 'OriginalBandWeight',
	case when b.TaskBand_Weight =  
		(
			select p.ParamValue from dbo.[ParamGroup] g
			inner join dbo.[Param] p
			on g.ParamGroup_ID = p.ParamGroup_ID 
			where g.ParamGroupName = 'NoWorkRequired'
		)
	then 0 
	else b.TaskBand_Weight 
	end 'AdjustedBandWeight'
	from dbo.TaskBand b


GO




---------------------------------------------------------------------------

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE VIEW [dbo].[vw_GetAllWorkWithWeights]
AS


select
	w.WorkShiftDate,	-- the date of the work
	ws.WorkShift_ID,ws.WorkShiftName,ws.StartTime,ws.EndTime, -- details of workshift
	em.EpisodeMove_ID, -- we might use this later for another join on this view
	em.Bed_ID,
	wd.Ward_ID,
	wd.WardName,
	tr.WorkSubModel_ID as 'TaskSubModelParent_ID',	-- id of  parent submodel of this task.. will be null for outlier
	tr.WorkSubModelName as 'TaskSubModelParent_Name', -- name of  parent submodel of this task.. will be null for outlier
	rt.WorkSubModel_ID as 'WardSubModel_ID', -- id of submodel being used by this ward..will have value even if task is outlier
	t.WorkTask_ID, -- 
	t.WorkTaskName,
	t.WorkTaskDescription,
	w.TaskFreeText, -- free text re text entered when this record was entered...nice idea but we may not have time to get to this...may be null or default
	w.isOutlier, -- 0 where the task is part of the submodel, otherwise 1, very important for showing where work had to be done that wasn't the usual work on this ward
	t.WorkModel_Ratio as 'OriginalWorkModelRatio', -- the ratio of the task calculated when the workmodel was first created, not related to submodel
	b.TaskBand_ID, 
	b.TaskBandName,
	b.TaskBandDescription,
	------------------------------------------------------------------------------
	b.OriginalBandWeight,   -- the band weight specified (between minimum weight ? 0.1 and 1) when the work model was first created
	b.AdjustedBandWeight,   -- weight is adjusted to 0 when it's the band for NoWorkRequired
	-------------------------------------------------------------------------------
	-- first the weight of the work in the context of the whole sub model - not very  valuable but may be of some use, so we include for now
	t.WorkModel_Ratio * b.AdjustedBandWeight as 'WeightWRTWorkModel', -- simply multiply task ratio by band weight to get value of work - refer context 1 in explanation above
	-------------------------------------------------------------------------------
	-- then getting the weight of the work in the context of the submodel - this is the valuable info
	-- get the ratio first
	case when tr.TaskSubModelRatio is not null  --if the task is part of the submodel (not an outlier)
		then tr.TaskSubModelRatio -- return the task ratio that we calculated in the view for this submodel
		-- otherwise the task is an outlier ie not part of this submodel 
	else t.WorkModel_Ratio * 100 / rt.TotalSubModelRatio -- calculate its ratio in the contest of this submodel - simply pro rata it
		end 'RatioWRTSubModel',
	----------------------------------------------------------------------------------
	--and then multiply the ratio by the band...this is the final piece...this is the weight
	case when tr.TaskSubModelRatio is not null 
		then tr.TaskSubModelRatio * b.AdjustedBandWeight
	else (t.WorkModel_Ratio * 100 / rt.TotalSubModelRatio) * b.AdjustedBandWeight 
		end 'WeightWRTSubModel',
	
	rt.TotalSubModelRatio

	from
	dbo.Work w
	inner join dbo.vw_GetAdjustedBandWeight b -- use view that adjusts NoWorkRequired weight to 0
	on w.TaskBand_ID = b.TaskBand_ID -- join work with task band
	inner join dbo.WorkTask t 
	on b.WorkTask_ID = t.WorkTask_ID  -- join band with task
	inner join dbo.WorkShift ws
	on w.WorkShift_ID = ws.WorkShift_ID  -- join work with workshift..need this for start and end times of work shift
	left outer join dbo.vw_GetSubModelTaskRatio tr -- this is left join to allow for outlier tasks that are not part of the submodel
	on w.WorkSubModel_ID = tr.WorkSubModel_ID  -- the work record will reference the submodel ID, even for outlier tasks  
	and t.WorkTask_ID = tr.WorkTask_ID -- but the left join will return null from view where task is an outlier
	inner join dbo.vw_GetSubModelRatioTotal rt -- because the submodelid is in the work table for outliers as well as submodel tasks, this returns the submodel total ratio for all records, including outliers
	on w.WorkSubModel_ID = rt.WorkSubModel_ID -- join work with view that gets total submodel ratio
	inner join dbo.EpisodeMove em
	on w.EpisodeMove_ID = em.EpisodeMove_ID
	inner join dbo.Bed bd
	on em.Bed_ID=bd.Bed_ID
	inner join dbo.Ward wd
	on bd.Ward_ID=wd.Ward_ID

GO



---------------------------------------------------------------------------

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vw_GetWorkScores]
AS
select 
	s.EpisodeMove_ID,
	s.Ward_ID,
	s.WardName,
	s.WorkShiftDate ,
	s.WorkShift_ID ,
	s.WorkShiftName,
	s.WardSubModel_ID ,
	s.SubModelWork ,
	case 
		when o.OutlierWork is null then 0 else o.OutlierWork end 'OutlierWork',
	w.WorkModelWork  
	from
	(
		select
			w.EpisodeMove_ID,
			w.Ward_ID,
			w.WardName,
			w.WorkShiftDate,
			w.WorkShift_ID,
			w.WorkShiftName,
			w.WardSubModel_ID,
			sum(w.WeightWRTSubModel) as 'SubModelWork'
		from 
			dbo.vw_GetAllWorkWithWeights w
		where 
			w.isOutlier = 0
		group by
			w.EpisodeMove_ID,
			w.Ward_ID,
			w.WardName,
			w.WorkShiftDate,
			w.WorkShiftName,
			w.WorkShift_ID,
			w.WardSubModel_ID
	) s -- s for submodel work
inner join
	(
		select
			w.EpisodeMove_ID,
			w.Ward_ID,
			w.WardName,
			w.WorkShiftDate,
			w.WorkShift_ID,
			w.WorkShiftName,
			w.WardSubModel_ID,
			sum(w.WeightWRTWorkModel) as 'WorkModelWork'
		from 
			dbo.vw_GetAllWorkWithWeights w
		where 
			w.isOutlier = 0
		group by
			w.EpisodeMove_ID,
			w.Ward_ID,
			w.WardName,
			w.WorkShiftDate,
			w.WorkShift_ID,
			w.WorkShiftName,
			w.WardSubModel_ID
	)w	-- w for workmodel
on
	s.EpisodeMove_ID = w.EpisodeMove_ID
	and s.Ward_ID = w.Ward_ID
	and s.WardName = w.WardName
	and s.WorkShiftDate = w.WorkShiftDate 
	and s.WorkShift_ID = w.WorkShift_ID 
	and s.WorkShiftName = w.WorkShiftName
	and s.WardSubModel_ID = w.WardSubModel_ID 		
left outer join   -- bring submodel totals even where there are no outliers
	(
		select 
			w.EpisodeMove_ID,
			w.Ward_ID,
			w.WardName,
			w.WorkShiftDate,
			w.WorkShift_ID,
			w.WorkShiftName,
			w.WardSubModel_ID,
			sum(w.WeightWRTSubModel) as 'OutlierWork'
		from 
			dbo.vw_GetAllWorkWithWeights w
		where 
			w.isOutlier = 1
		group by
			w.EpisodeMove_ID,
			w.Ward_ID,
			w.WardName,
			w.WorkShiftDate,
			w.WorkShift_ID,
			w.WorkShiftName,
			w.WardSubModel_ID
	) o -- o for outlier work
on 
	s.EpisodeMove_ID = o.EpisodeMove_ID
	and s.WardName = o.WardName
	and s.WorkShiftDate = o.WorkShiftDate 
	and s.WorkShift_ID = o.WorkShift_ID 
	and s.WorkShiftName = o.WorkShiftName
	and s.WardSubModel_ID = o.WardSubModel_ID 

GO



--------------------------------------------------------------------------

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[vw_GetWorkScoresOrdered]
AS
	select
	a.WorkShiftDate,
	a.WorkShift_ID,
	a.WorkShiftName,
	a.EpisodeMove_ID,
	a.Ward_ID,
	a.WardName,
	a.SubModelWork
	from vw_GetWorkScores a
	GROUP BY a.WorkShiftDate, a.Ward_ID, a.WardName, a.WorkShift_ID, a.WorkShiftName, a.EpisodeMove_ID, a.SubModelWork
GO

--------------------------------------------------------------------------

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vw_GetWardAllShiftsEver]
AS
select
	w.WorkShiftDate,
	w.Ward_ID,
	w.WardName,
	w.WorkShift_ID,
	w.WorkShiftName,
	w.SubModelWork,
	count(SubModelWork) as 'NumberOfPatientsInWard',
	sum(w.SubModelWork) as 'SumOfSubModelWork',
	sum(w.SubModelWork)/count(SubModelWork) as 'WardWorkloadScore'
	from vw_GetWorkScoresOrdered w
	GROUP BY w.WorkShiftDate, w.Ward_ID, w.WardName, w.WorkShift_ID, w.WorkShiftName, w.SubModelWork
GO

--------------------------------------------------------------------------------



SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/*
this view selects the RealTime workload score for all patients for all workshifts of today. the view vw_GetWorkScores_allPatientscurrentShift gets RT rn
*/ 

/*
This view has a bug because if any two wards are both using the same work shift !as part of different work sequences! at the current moment, 
it counts each patient in each shift for the number of wards who are currently using that work shift.

it happens with N1 bc it is used in DN and in MAN 
it happens with M1 bc it is used in MAN and in MAEN

eg. Sligo uses DN and Wicklow uses MAN. during the N1 shift, 2 wards are using that shift 
when this view calculates the current workload score of each individaul patient at the current moment, 
it counts each patient in Sligo as 2 times its work (the 2 is coming from 2 wards using the work shift) 
so each patient is worth 200 and the whole ward worth 1600 (each patient shoud be 100 and the whole ward should be 800 based on mock data inserted)

it also counts each patient in Wicklow as 2 times its work. Mock data inserts random bands for Wicklow patients 
but we can see sometimes the Wicklow patients workscores are more than 100 so we are certain they are twice what they should be
so each patient is worth twice its actual work and the whole ward worth twice its actual average

this does not happen when wards use the same work shift in the same work sequence, only when they use the same work shift in different work sequences
*/

CREATE VIEW [dbo].[vw_GetWorkScores_allPatientsAllShiftsToday]
AS

SELECT 

v.*,  
b.Bed_ID,
b.BedName,
p.PatMRN,
p.PatFirstName + ' ' + p.PatLastName AS 'PatFullName',
case when s.overMidNight = 0		--does not cross midnight
		and datediff(mi,s.StartTime,cast(CURRENT_TIMESTAMP as time)) >= 0 -- current time is greater than start time
		and datediff(mi,s.EndTime,cast(CURRENT_TIMESTAMP as time)) <= 0	--current time is less than end time
		then 1

	when s.overMidNight = 1				-- does cross midnight
		and datediff(mi,s.StartTime,cast(CURRENT_TIMESTAMP as time)) >= 0 --current time is greater than start time
		and datediff(mi,s.EndTime,cast(CURRENT_TIMESTAMP as time)) >= 0  -- current time is greater than end time
		then 1						-- this is the current shift, and current time is between shift start and midnight

	when s.overMidNight = 1				-- does cross midnight
		and datediff(mi,s.StartTime,cast(CURRENT_TIMESTAMP as time)) <= 0 --current time is less than start time
		and datediff(mi,s.EndTime,cast(CURRENT_TIMESTAMP as time)) <= 0  -- current time is less than end time
		then 1	
	

	end 'currentShift' -- flag shift as current or not

FROM vw_GetWorkScores v
inner join vw_GetSequencesAndShifts s 
on v.WorkShift_ID = s.WorkShift_ID
inner join EpisodeMove em
on v.EpisodeMove_ID = em.EpisodeMove_ID
inner join Bed b 
on em.Bed_ID = b.Bed_ID 
inner join Ward wd 
on b.Ward_ID = wd.Ward_ID
inner join Episode e 
on em.Episode_ID = e.Episode_ID
inner join Patient p
on e.Pat_ID = p.Pat_ID

WHERE v.WorkShiftDate = cast(CURRENT_TIMESTAMP as date)

GO

--------------------------------------------------------------------------


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/*
this view gets RT rn all patients all wards, this shift
*/ 
CREATE VIEW [dbo].[vw_GetWorkScores_allPatientsCurrentShift]
AS

	SELECT * FROM vw_GetWorkScores_allPatientsAllShiftsToday WHERE currentShift = 1

GO
----------------------------------------------------------------------------------------------------------------------------------------------------




/****** Object:  View [dbo].[vw_GetWardWorkScoreAllShiftsToday]    Script Date: 03/05/2021 11:27:42 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- ran at 22:17 thursday night and it selected 2 current shifts for sigo, dublin, and wicklow ??????????????????????????????????????????
CREATE VIEW [dbo].[vw_GetWardWorkScoreAllShiftsToday]
AS
select
	w.WorkShiftDate,
	w.Ward_ID,
	w.WardName,
	w.WorkShift_ID,
	w.SubModelWork,
	count(SubModelWork) as 'NumberOfPatientsInWard',
	sum(w.SubModelWork) as 'SumOfSubModelWork',
	sum(w.SubModelWork)/count(SubModelWork) as 'WardWorkloadScore',
	case when s.overMidNight = 0		--does not cross midnight
		and datediff(mi,s.StartTime,cast(CURRENT_TIMESTAMP as time)) >= 0 -- current time is greater than start time
		and datediff(mi,s.EndTime,cast(CURRENT_TIMESTAMP as time)) <= 0	--current time is less than end time
		then 1

	when s.overMidNight = 1				-- does cross midnight
		and datediff(mi,s.StartTime,cast(CURRENT_TIMESTAMP as time)) >= 0 --current time is greater than start time
		and datediff(mi,s.EndTime,cast(CURRENT_TIMESTAMP as time)) >= 0  -- current time is greater than end time
		then 1						-- this is the current shift, and current time is between shift start and midnight

	when s.overMidNight = 1				-- does cross midnight
		and datediff(mi,s.StartTime,cast(CURRENT_TIMESTAMP as time)) <= 0 --current time is less than start time
		and datediff(mi,s.EndTime,cast(CURRENT_TIMESTAMP as time)) <= 0  -- current time is less than end time
		then 1	
	

	end 'currentShift' -- flag shift as current or not
	from vw_GetWorkScoresOrdered w
	inner join vw_GetSequencesAndShifts s 
	on w.WorkShift_ID = s.WorkShift_ID
	WHERE w.WorkShiftDate = cast(CURRENT_TIMESTAMP as date)
	GROUP BY w.WorkShiftDate, w.Ward_ID, w.WardName, w.WorkShift_ID, w.SubModelWork, s.overMidNight, s.StartTime, s.EndTime
GO



--------------------------------------------------------------------------





/****** Object:  View [dbo].[vw_GetWardWorkScore_CurrentShift]    Script Date: 03/05/2021 11:27:00 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/*
this view gets RT rn all patients all wards, this shift
*/ 

-- this is selecting sligo twice, dublin twice, and wicklow twice. but still waterford once and cork onc e??????????????????????????????????????
-- ahhh the problem is in vw_GetWardWorkScoreAllShiftsToday. its return more then one shift as 1 for currentShift
CREATE VIEW [dbo].[vw_GetWardWorkScore_CurrentShift]
AS

	SELECT * FROM vw_GetWardWorkScoreAllShiftsToday WHERE currentShift = 1

GO





--------------------------------------------------------------------------





/****** Object:  View [dbo].[vw_getNurseCompliance]    Script Date: 06/05/2021 19:27:00 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE VIEW [dbo].[vw_getNurseLogs]
AS
	SELECT
	w.WorkShiftDate,
	wd.Ward_ID,
	wd.WardName,
	w.WorkShift_ID,
	ws.WorkShiftName,
	s.Staff_ID,
	s.Unique_ID,
	p.PatMRN,
	count(s.Staff_ID) AS 'countOfLogsForThisStaffID'

	FROM 
	Work w
	inner join Staff s
	on w.Staff_ID = s.Staff_ID
	inner join EpisodeMove em
	on w.EpisodeMove_ID = em.EpisodeMove_ID
	inner join Bed b 
	on em.Bed_ID = b.Bed_ID 
	inner join Ward wd 
	on b.Ward_ID = wd.Ward_ID
	inner join Episode e 
	on em.Episode_ID = e.Episode_ID
	inner join Patient p
	on e.Pat_ID = p.Pat_ID
	inner join WorkShift ws
	on w.WorkShift_ID = ws.WorkShift_ID

	group by 
	w.WorkShiftDate,
	wd.Ward_ID,
	wd.WardName,
	w.WorkShift_ID,
	ws.WorkShiftName,
	s.Staff_ID,
	s.Unique_ID,
	p.PatMRN
	

	--order by 
	--WorkShiftDate,
	--WardName,
	--WorkShift_ID

GO


--------------------------------------------------------------------------


