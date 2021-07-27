-- creates a work model full of tasks from CSV file
-- creates 3 submodels full of tasks

declare @distinctTasks as int	-- think this and below are for checks, not ready yet 
declare @distinctTasksWithDetail as int		-- think this and above are for checks, not ready yet 

declare @WorkModelName as nvarchar(50) --maybe make this longer and validate lenght ie reject if longer than 50. it currently will chop off end
declare @WorkModelDescription as nvarchar(200)
declare @returnErrorMessage as nvarchar(1000)
declare @newWorkModelID as int 
set @returnErrorMessage = ''
-- errors will be concatonated onto this
-- so that users will not receive some error, fix it, run, receive another error, fix it, run, another, fix, etc
-- they will receive all erros and can fix them all and rerun

--prepare 3 names for the 3 submodels we will create once the WorkModel is entered successfully
declare @subModelName1 as nvarchar(50)
declare @subModelName2 as nvarchar(50)
declare @subModelName3 as nvarchar(50)
set @subModelName1 = 'HarleySubModel'
set @subModelName2 = 'DavidSubModel'
set @subModelName3 = 'RuthieSubModel'

declare @subModelDescr1 as nvarchar(50)
declare @subModelDescr2 as nvarchar(50)
declare @subModelDescr3 as nvarchar(50)
set @subModelDescr1 = 'something about Harley submodel'
set @subModelDescr2 = 'something about David submodel'
set @subModelDescr3 = 'something about Ruthie submodel'




--prepare the default names and descriptions for use when the submodels are entered
--and we want to create defaults
declare @defaultName1 as nvarchar(50)
declare @defaultName2 as nvarchar(50)
declare @defaultName3 as nvarchar(50)
declare @defaultName4 as nvarchar(50)
declare @defaultName5 as nvarchar(50)
declare @defaultName6 as nvarchar(50)
set @defaultName1 = 'HarleyDefaultOne'	
set @defaultName2 = 'HarleyDefaultTwo'
set @defaultName3 = 'DavidDefaultOne'
set @defaultName4 = 'DavidDefaultTwo'
set @defaultName5 = 'RuthieDefaultOne'
set @defaultName6 = 'RuthieDefaultTwo'

declare @defaultDescr1 as nvarchar(50)
declare @defaultDescr2 as nvarchar(50)
declare @defaultDescr3 as nvarchar(50)
declare @defaultDescr4 as nvarchar(50)
declare @defaultDescr5 as nvarchar(50)
declare @defaultDescr6 as nvarchar(50)
set @defaultDescr1 = 'Something about HarleyDefaultOne'
set @defaultDescr2 = 'Something about HarleyDefaultTwo'
set @defaultDescr3 = 'Something about DavidDefaultOne'
set @defaultDescr4 = 'Something about DavidDefaultTwo'
set @defaultDescr5 = 'Something about RuthieDefaultOne'
set @defaultDescr6 = 'Something about RuthieDefaultTwo'




------------------------------------------------------------------------------




--make sure there is a value configured for NoWorkRequired....edit the value if changing
-- if GUI was ideal and each pie slice displayed it's bands based on their weight 
	-- (ie. band which indicated a lot of work would take up bigger section of slice than band which indicated a small amount of work )
-- then this SP would set the NoWorkRequired band to *some* value, eg. 0.1, for it to be displayed and clickable (if it was 0, it would not be displayed)
-- we left it in here to show the functioning of it, if the GUI was able to to as we pleased
-- SP sets the value in the param table 
exec dbo.UpdateNoWorkRequiredValue 0.0
--return our value for use
declare @NoWorkRequired as float
set @NoWorkRequired =
( 
	select p.ParamValue from dbo.ParamGroup g
	inner join dbo.[Param] p
	on
	g.ParamGroup_ID = p.ParamGroup_ID
	where
	g.ParamGroupName = 'NoWorkRequired'
)




------------------------------------------------------------------------------



-- set name of WorkModel we will be inserting
set @WorkModelName = 'FirstWorkModel'
--ensure name doesn't already exist
if exists(select * from [dbo].[WorkModel] w 
	where w.WorkModelName =  @WorkModelName)
		BEGIN
		set @returnErrorMessage = 'Errorrrrrrrrr: ' + @WorkModelName + ' already exists'
		-- this is giving error someimtes even thogh there is no FirstworkModel name inWorkModel tbale ?????????????????????????????????????????????????
		select @returnErrorMessage
		return
		END  
		



------------------------------------------------------------------------------






DROP TABLE IF EXISTS #WorkModelUpload
DROP TABLE IF EXISTS #WorkTaskUpload
DROP TABLE IF EXISTS #TaskBandUpload
-- just good practice, ensure they are clear before we create them




------------------------------------------------------------------------------





-- create temp table consisting off all data from csv
create table #WorkModelUpload	-- task and band info
(
[WorkTaskName] [nvarchar](50) not null,
[WorkTaskDescription] [nvarchar](200) null,	
RN_Time_Spent float not null, -- per task, on average or summed up over a week of time/motion study 
HCA_Time_Spent float not null,	-- didnt bracket these just bc they dont go into real table so nice to single them out at a glance
[TaskBandName] [nvarchar](50) not null,
[TaskBandDescription] [nvarchar](200) null,
[TaskBand_Weight] [float] not null,
[WorkModel_Ratio] [float] not null,
[WorkTask_ID] [int] not null,
[TaskBand_ID] [int] not null
)


-- bulk insert csv into this temp table
-- this file path will be absolute to the server the DB is running on online. need to figure out how to pass local file to cloud
BULK INSERT #WorkModelUpload from 'C:\Users\harle\CA400FYP\2021-ca400-leaveyr2-martinh5\DBwork\WorkModelUpload.csv'
with
(FIRSTROW = 2,  FIELDTERMINATOR = ',', ROWTERMINATOR = '\n') -- ignore first row in csv bc its just column headings
SELECT * FROM #WorkModelUpload
select distinct w.WorkTaskName,w.TaskBand_Weight from #WorkModelUpload w
select * from #WorkModelUpload w where w.TaskBand_Weight = 1







------------------------------------------------------------------------------






	

--insert all tasks into the task table as distinct - without their bands - 26 in this example
CREATE TABLE #WorkTaskUpload(
[WorkTask_ID] [int] NULL,
[WorkTaskName] [nvarchar](50) NOT NULL,
[WorkTaskDescription] [nvarchar](200) NULL,
RN_Time_Spent float not null,
HCA_Time_Spent float not null,	-- didnt bracket these just bc they dont go into real table so nice to single them out at a glance
[WorkModel_Ratio] [float] NULL)


insert into #WorkTaskUpload
([WorkTaskName],[WorkTaskDescription],RN_Time_Spent,HCA_Time_Spent)
select distinct w.WorkTaskName,w.WorkTaskDescription,w.RN_Time_Spent,w.HCA_Time_Spent from #WorkModelUpload w
-- task A has many entries in WorkModel Upload. we only want distinct name, desc, time spent.
-- distinct is applied to all cols but we have already checked distinctoni anyway but we need to add them all to #Tasks
--calculate the ratio for each task
declare @sumTimeSpent as float
set @sumTimeSpent= (select sum(w.RN_Time_Spent) from #WorkTaskUpload w) + (select sum(w.HCA_Time_Spent) from #WorkTaskUpload w) 
-- one row for every task in #WorkTaskUpload
-- adds time spent for all task together
update 	#WorkTaskUpload	set [WorkModel_Ratio] = (RN_Time_Spent + HCA_Time_Spent) * 100/@sumTimeSpent
-- this will do it line by line 
-- sumTimeSpent is sum of all time spent on all tasks 
-- then find one tasks ratio of all tasks time spent





------------------------------------------------------------------------------




--create the new model - just its title for now
	
insert into [dbo].[WorkModel]
	(WorkModelName,WorkModelDescription,DTStamp)
	values
	(@WorkModelName,@WorkModelDescription, GETDATE())
--return its id
SET @newWorkModelID = SCOPE_IDENTITY()





--and insert the tasks and bands in the associated tables from csv
--first the tasks from csv
insert into dbo.WorkTask
	(WorkModel_ID,WorkTaskName,WorkTaskDescription,WorkModel_Ratio,DTStamp)
select @newWorkModelID,t.WorkTaskName,t.WorkTaskDescription,t.WorkModel_Ratio,GETDATE() 
from #WorkTaskUpload t






-- next is the bands from csv
insert into dbo.TaskBand
	(WorkTask_ID,TaskBandName,TaskBandDescription,TaskBand_Weight,DTStamp)
select distinct t.WorkTask_ID,u.TaskBandName,u.TaskBandDescription,u.TaskBand_Weight,GETDATE() 
from dbo.WorkTask t inner join #WorkModelUpload u
on t.WorkTaskName = u.WorkTaskName
where t.WorkModel_ID = @newWorkModelID






--then enter a band with a value of @NoWorkRequired for each of the tasks 
insert into dbo.TaskBand
	(WorkTask_ID,TaskBandName,TaskBandDescription,TaskBand_Weight,DTStamp)
select distinct t.WorkTask_ID,'NoWorkRequired','NoWorkRequiredDescription',@NoWorkRequired,GETDATE() 
from dbo.WorkTask t inner join #WorkModelUpload u
on t.WorkTaskName = u.WorkTaskName
where t.WorkModel_ID = @newWorkModelID




------------------------------------------------------------------------------





--have a look at everything
select * from dbo.WorkModel
select * from dbo.WorkTask
select * from dbo.TaskBand

select * from dbo.WorkModel w inner join dbo.WorkTask t
on w.WorkModel_ID = t.WorkModel_ID
inner join dbo.TaskBand b on t.WorkTask_ID = b.WorkTask_ID
order by t.WorkModel_ID, t.WorkTask_ID, b.TaskBand_ID 








------------------------------------------------------------------------------




-- return the values and use them to create a submodel
-- the last thing now is the submodel
	
declare @NewWorkSubModelID as int
--make the first submodel
----ensure name doesn't already exist
if exists(select * from [dbo].[WorkSubModel] w 
where w.WorkSubModelName =  @subModelName1)
	BEGIN
	set @returnErrorMessage = 'Errorrrrrr: ' + @subModelName1 + ' already exists'
	END
	ELSE
	BEGIN
	-- I am selecting the tasks that I know were entered as part of bulk insert above
	-- be careful with this -- keep an eye on our tasks and make sure we don't break the integrity
	insert into dbo.WorkSubModel
		(WorkModel_ID,WorkSubModelName,WorkSubModelDescription,DTStamp)
	values
		(@newWorkModelID,@subModelName1,@subModelDescr1,GETDATE())

	SET @NewWorkSubModelID = SCOPE_IDENTITY() -- return the id
	--then choose the tasks we want included in this new submodel
	insert into dbo.SubModelTask
		(WorkSubModel_ID,WorkTask_ID,DTStamp)
	select @NewWorkSubModelID, t.WorkTask_ID, GETDATE()		
	 from dbo.WorkTask t where t.WorkModel_ID = @newWorkModelID
	 and t.WorkTaskName in ('Task A', 'Task B','Task C','Task D','Task E','Task F','Task G')
	END
		











--make another
----ensure name doesn't already exist
if exists(select * from [dbo].[WorkSubModel] w 
where w.WorkSubModelName =  @subModelName2)
	BEGIN
	set @returnErrorMessage = 'Errorrrrrrr: ' + @subModelName2 + ' already exists'
	END
	ELSE
	BEGIN
	-- I am selecting the tasks that I know were entered as part of bulk insert above
	-- be careful with this -- keep an eye on our tasks and make sure we don't break the integrity
	insert into dbo.WorkSubModel
		(WorkModel_ID,WorkSubModelName,WorkSubModelDescription,DTStamp)
	values
		(@newWorkModelID,@subModelName2,@subModelDescr2,GETDATE())

	SET @NewWorkSubModelID = SCOPE_IDENTITY() -- return the id
	--then choose the tasks you want included in this new submodel -- a few the same and a few different
	insert into dbo.SubModelTask
		(WorkSubModel_ID,WorkTask_ID,DTStamp)
	select @NewWorkSubModelID, t.WorkTask_ID, GETDATE()		
	 from dbo.WorkTask t where t.WorkModel_ID = @newWorkModelID
	 and t.WorkTaskName in ('Task A', 'Task B','Task C','Task D','Task H','Task I','Task J')
	END 




















--and another
	

----ensure name doesn't already exist
if exists(select * from [dbo].[WorkSubModel] w 
where w.WorkSubModelName =  @subModelName3)
	BEGIN
	set @returnErrorMessage = 'Errorrrrrrr: ' + @subModelName3 + ' already exists'
	END
	ELSE
	BEGIN
	-- I am selecting the tasks that I know were entered as part of bulk insert above
	-- be careful with this -- keep an eye on our tasks and make sure we don't break the integrity
	insert into dbo.WorkSubModel
		(WorkModel_ID,WorkSubModelName,WorkSubModelDescription,DTStamp)
	values
		(@newWorkModelID,@subModelName3,@subModelDescr3,GETDATE())

	SET @NewWorkSubModelID = SCOPE_IDENTITY() -- return the id
	--then choose the tasks you want included in this new submodel -- a few the same and a few different
	insert into dbo.SubModelTask
		(WorkSubModel_ID,WorkTask_ID,DTStamp)
	select @NewWorkSubModelID, t.WorkTask_ID, GETDATE()		
	 from dbo.WorkTask t where t.WorkModel_ID = @newWorkModelID
	 and t.WorkTaskName in ('Task A', 'Task B','Task C','Task D','Task K','Task L','Task M')
	END  















-----------------------------------------------------------------------------------------------
/*
			Now have a look at our work
			The following are views to show what we've entered
*/
-----------------------------------------------------------------------------------------------

			-- return all work models
select * from dbo.WorkModel
			--and the submodels on their own 
select * from dbo.WorkSubModel
-----------------------------------------------------------------------------------------------
			-- return all work models joined with their tasks
select * from dbo.WorkModel m
	inner join dbo.WorkTask t
	on m.WorkModel_ID = t.WorkModel_ID
	order by m.WorkModelName, t.WorkTaskName
------------------------------------------------------------------------------------------------
			-- return all work models joined with their tasks joined with their bands
select * from dbo.WorkModel m
	inner join dbo.WorkTask t
	on m.WorkModel_ID = t.WorkModel_ID
	inner join dbo.TaskBand b
	on t.WorkTask_ID = b.WorkTask_ID
	order by m.WorkModelName, t.WorkTaskName, b.TaskBand_Weight

------------------------------------------------------------------------------------------------
			--return all work models joined with their submodels
select * from dbo.WorkModel w 
	inner join dbo.WorkSubModel s
on w.WorkModel_ID = s.WorkModel_ID

















------------------------------------------------------------------------------------------------



/*
SELECT * FROM SubModelDefault

@defaultName1 = 'HarleyDefaultOne'	= ID 1 = Sub 1
@defaultName2 = 'HarleyDefaultTwo' = ID 2 = Sub 1 
@defaultName3 = 'DavidDefaultOne' = ID 3 = Sub 2 = Sligo, Cork
@defaultName4 = 'DavidDefaultTwo' = ID 4 = Sub 2 = Dublin
@defaultName5 = 'RuthieDefaultOne' = ID 5 = Sub 3 = Wicklow
@defaultName6 = 'RuthieDefaultTwo' = ID 6 = Sub 3 = Waterford



*/




-- create default sub models for each sub work model
--you can create as many defaults as you like for each submodel, 
-- and then each ward chooses the default they want that suits them (defaults are standalone, but mad with a ward in mind)

--for now we will just create two defaults for each submodel - we declared the names earlier
--return the id of the first submodel
declare @newSubModelDefaultID as int
set @NewWorkSubModelID = (select s.WorkSubModel_ID from dbo.WorkSubModel s where s.WorkSubModelName = @subModelName1)
insert into [dbo].[SubModelDefault]
	([WorkSubModel_ID],[SubModelDefaultName],[SubModelDefaultDescription],[DTStamp])
values
	(@NewWorkSubModelID,@defaultName1,@defaultDescr1,GETDATE()) 
--return the id of this new default submodel
set @newSubModelDefaultID = SCOPE_IDENTITY()



/*
now for this default, declare the default band for each task in this submodel
 (this is entirely hard-coded here just to get data in there) 
we know that submodel 1 uses the following tasks
'Task A', 'Task B','Task C','Task D','Task E','Task F','Task G'
get the id of each task and then randomely select one of its bands
select top(1) 
order by newid() for random
*/

--SELECT * 
--FROM TaskBand b
--inner join WorkTask t 
--on b.WorkTask_ID = t.WorkTask_ID
--WHERE t.WorkTaskName = 'Task A'
--SELECT * FROM TaskBand
--SELECT * FROM WorkTask



declare @taskID as int
declare @defaultBandID as int

set @taskID = (select t.WorkTask_ID from dbo.WorkTask t where t.WorkTaskName = 'Task A' and t.WorkModel_ID = @newWorkModelID)
set @defaultBandID = (select top(1) b.TaskBand_ID from dbo.TaskBand b where b.WorkTask_ID = @taskID order by newid())
--and insert these values into the default table
insert into dbo.SubModelDefaultBand 
	(SubModelDefault_ID,TaskBand_ID,DTStamp)
values
	(@newSubModelDefaultID,@defaultBandID,GETDATE())
--then carry on and do this for every task in this submodel

--Task B
set @taskID = (select t.WorkTask_ID from dbo.WorkTask t where t.WorkTaskName = 'Task B' and t.WorkModel_ID = @newWorkModelID)
set @defaultBandID = (select top(1) b.TaskBand_ID from dbo.TaskBand b where b.WorkTask_ID = @taskID order by newid())
--and insert these values into the default table
insert into dbo.SubModelDefaultBand 
	(SubModelDefault_ID,TaskBand_ID,DTStamp)
values
	(@newSubModelDefaultID,@defaultBandID,GETDATE())

	--Task C
set @taskID = (select t.WorkTask_ID from dbo.WorkTask t where t.WorkTaskName = 'Task C' and t.WorkModel_ID = @newWorkModelID)
set @defaultBandID = (select top(1) b.TaskBand_ID from dbo.TaskBand b where b.WorkTask_ID = @taskID order by newid())
--and insert these values into the default table
insert into dbo.SubModelDefaultBand 
	(SubModelDefault_ID,TaskBand_ID,DTStamp)
values
	(@newSubModelDefaultID,@defaultBandID,GETDATE())

	--Task D
set @taskID = (select t.WorkTask_ID from dbo.WorkTask t where t.WorkTaskName = 'Task D' and t.WorkModel_ID = @newWorkModelID)
set @defaultBandID = (select top(1) b.TaskBand_ID from dbo.TaskBand b where b.WorkTask_ID = @taskID order by newid())
--and insert these values into the default table
insert into dbo.SubModelDefaultBand 
	(SubModelDefault_ID,TaskBand_ID,DTStamp)
values
	(@newSubModelDefaultID,@defaultBandID,GETDATE())

	--Task E
set @taskID = (select t.WorkTask_ID from dbo.WorkTask t where t.WorkTaskName = 'Task E' and t.WorkModel_ID = @newWorkModelID)
set @defaultBandID = (select top(1) b.TaskBand_ID from dbo.TaskBand b where b.WorkTask_ID = @taskID order by newid())
--and insert these values into the default table
insert into dbo.SubModelDefaultBand 
	(SubModelDefault_ID,TaskBand_ID,DTStamp)
values
	(@newSubModelDefaultID,@defaultBandID,GETDATE())

	--Task F
set @taskID = (select t.WorkTask_ID from dbo.WorkTask t where t.WorkTaskName = 'Task F' and t.WorkModel_ID = @newWorkModelID)
set @defaultBandID = (select top(1) b.TaskBand_ID from dbo.TaskBand b where b.WorkTask_ID = @taskID order by newid())
--and insert these values into the default table
insert into dbo.SubModelDefaultBand 
	(SubModelDefault_ID,TaskBand_ID,DTStamp)
values
	(@newSubModelDefaultID,@defaultBandID,GETDATE())

	--Task G
set @taskID = (select t.WorkTask_ID from dbo.WorkTask t where t.WorkTaskName = 'Task G' and t.WorkModel_ID = @newWorkModelID)
set @defaultBandID = (select top(1) b.TaskBand_ID from dbo.TaskBand b where b.WorkTask_ID = @taskID order by newid())
--and insert these values into the default table
insert into dbo.SubModelDefaultBand 
	(SubModelDefault_ID,TaskBand_ID,DTStamp)
values
	(@newSubModelDefaultID,@defaultBandID,GETDATE())

--that's one default created for the first submodel












--now another default for this submodel...we already have the id of this submodel...we returned it for previous
--this will be default 2 for submodel 1
insert into [dbo].[SubModelDefault]
	([WorkSubModel_ID],[SubModelDefaultName],[SubModelDefaultDescription],[DTStamp])
values
	(@NewWorkSubModelID,@defaultName2,@defaultDescr2,GETDATE()) 
--return the id of this new default submodel
set @newSubModelDefaultID = SCOPE_IDENTITY()
/*
same as above
for this default, declare the default band for each task in this submodel
 (this is entirely hard-coded here just to get data in there) 
we know that submodel 1 uses the following tasks
'Task A', 'Task B','Task C','Task D','Task E','Task F','Task G'
get the id of each task and then randomely select one of its bands
select top(1) 
order by newid() for random
*/

set @taskID = (select t.WorkTask_ID from dbo.WorkTask t where t.WorkTaskName = 'Task A' and t.WorkModel_ID = @newWorkModelID)
set @defaultBandID = (select top(1) b.TaskBand_ID from dbo.TaskBand b where b.WorkTask_ID = @taskID order by newid())
--and insert these values into the default table
insert into dbo.SubModelDefaultBand 
	(SubModelDefault_ID,TaskBand_ID,DTStamp)
values
	(@newSubModelDefaultID,@defaultBandID,GETDATE())
--then carry on and do this for every task in this submodel

--Task B
set @taskID = (select t.WorkTask_ID from dbo.WorkTask t where t.WorkTaskName = 'Task B' and t.WorkModel_ID = @newWorkModelID)
set @defaultBandID = (select top(1) b.TaskBand_ID from dbo.TaskBand b where b.WorkTask_ID = @taskID order by newid())
--and insert these values into the default table
insert into dbo.SubModelDefaultBand 
	(SubModelDefault_ID,TaskBand_ID,DTStamp)
values
	(@newSubModelDefaultID,@defaultBandID,GETDATE())

	--Task C
set @taskID = (select t.WorkTask_ID from dbo.WorkTask t where t.WorkTaskName = 'Task C' and t.WorkModel_ID = @newWorkModelID)
set @defaultBandID = (select top(1) b.TaskBand_ID from dbo.TaskBand b where b.WorkTask_ID = @taskID order by newid())
--and insert these values into the default table
insert into dbo.SubModelDefaultBand 
	(SubModelDefault_ID,TaskBand_ID,DTStamp)
values
	(@newSubModelDefaultID,@defaultBandID,GETDATE())

	--Task D
set @taskID = (select t.WorkTask_ID from dbo.WorkTask t where t.WorkTaskName = 'Task D' and t.WorkModel_ID = @newWorkModelID)
set @defaultBandID = (select top(1) b.TaskBand_ID from dbo.TaskBand b where b.WorkTask_ID = @taskID order by newid())
--and insert these values into the default table
insert into dbo.SubModelDefaultBand 
	(SubModelDefault_ID,TaskBand_ID,DTStamp)
values
	(@newSubModelDefaultID,@defaultBandID,GETDATE())

	--Task E
set @taskID = (select t.WorkTask_ID from dbo.WorkTask t where t.WorkTaskName = 'Task E' and t.WorkModel_ID = @newWorkModelID)
set @defaultBandID = (select top(1) b.TaskBand_ID from dbo.TaskBand b where b.WorkTask_ID = @taskID order by newid())
--and insert these values into the default table
insert into dbo.SubModelDefaultBand 
	(SubModelDefault_ID,TaskBand_ID,DTStamp)
values
	(@newSubModelDefaultID,@defaultBandID,GETDATE())

	--Task F
set @taskID = (select t.WorkTask_ID from dbo.WorkTask t where t.WorkTaskName = 'Task F' and t.WorkModel_ID = @newWorkModelID)
set @defaultBandID = (select top(1) b.TaskBand_ID from dbo.TaskBand b where b.WorkTask_ID = @taskID order by newid())
--and insert these values into the default table
insert into dbo.SubModelDefaultBand 
	(SubModelDefault_ID,TaskBand_ID,DTStamp)
values
	(@newSubModelDefaultID,@defaultBandID,GETDATE())

	--Task G
set @taskID = (select t.WorkTask_ID from dbo.WorkTask t where t.WorkTaskName = 'Task G' and t.WorkModel_ID = @newWorkModelID)
set @defaultBandID = (select top(1) b.TaskBand_ID from dbo.TaskBand b where b.WorkTask_ID = @taskID order by newid())
--and insert these values into the default table
insert into dbo.SubModelDefaultBand 
	(SubModelDefault_ID,TaskBand_ID,DTStamp)
values
	(@newSubModelDefaultID,@defaultBandID,GETDATE())


















--and then the same for the other two submodels - create two defaults for each

--the second submodel - two defaults for it - this will be default 3 and default 4
set @NewWorkSubModelID = (select s.WorkSubModel_ID from dbo.WorkSubModel s where s.WorkSubModelName = @subModelName2)
insert into [dbo].[SubModelDefault]
	([WorkSubModel_ID],[SubModelDefaultName],[SubModelDefaultDescription],[DTStamp])
values
	(@NewWorkSubModelID,@defaultName3,@defaultDescr3,GETDATE()) 
--return the id of this new default submodel
set @newSubModelDefaultID = SCOPE_IDENTITY()
/*
same as before
for this default, declare the default band for each task in this submodel
 (this is entirely hard-coded here just to get data in there) 
we know that submodel 2 uses the following tasks
'Task A', 'Task B','Task C','Task D','Task H','Task I','Task J'
get the id of each task and then 
set the defaults = 1 (so that this default model will always have full work done)
*/
SELECT * FROM TaskBand
--Task A
set @taskID = (select t.WorkTask_ID from dbo.WorkTask t where t.WorkTaskName = 'Task A' and t.WorkModel_ID = @newWorkModelID)
set @defaultBandID = (select b.TaskBand_ID from dbo.TaskBand b inner join dbo.WorkTask t on b.WorkTask_ID = t.WorkTask_ID where t.WorkTaskName = 'Task A' and b.TaskBand_Weight = 1)
--set @defaultBandID = (select top(1) b.TaskBand_ID from dbo.TaskBand b where b.WorkTask_ID = @taskID order by newid())
--and insert these values into the default table
insert into dbo.SubModelDefaultBand 
	(SubModelDefault_ID,TaskBand_ID,DTStamp)
values
	(@newSubModelDefaultID,@defaultBandID,GETDATE())
--Task B
set @taskID = (select t.WorkTask_ID from dbo.WorkTask t where t.WorkTaskName = 'Task B' and t.WorkModel_ID = @newWorkModelID)
set @defaultBandID = (select b.TaskBand_ID from dbo.TaskBand b inner join dbo.WorkTask t on b.WorkTask_ID = t.WorkTask_ID where t.WorkTaskName = 'Task B' and b.TaskBand_Weight = 1)
--set @defaultBandID = (select top(1) b.TaskBand_ID from dbo.TaskBand b where b.WorkTask_ID = @taskID order by newid())
--and insert these values into the default table
insert into dbo.SubModelDefaultBand 
	(SubModelDefault_ID,TaskBand_ID,DTStamp)
values
	(@newSubModelDefaultID,@defaultBandID,GETDATE())

	--Task C
set @taskID = (select t.WorkTask_ID from dbo.WorkTask t where t.WorkTaskName = 'Task C' and t.WorkModel_ID = @newWorkModelID)
set @defaultBandID = (select b.TaskBand_ID from dbo.TaskBand b inner join dbo.WorkTask t on b.WorkTask_ID = t.WorkTask_ID where t.WorkTaskName = 'Task C' and b.TaskBand_Weight = 1)
--set @defaultBandID = (select top(1) b.TaskBand_ID from dbo.TaskBand b where b.WorkTask_ID = @taskID order by newid())
--and insert these values into the default table
insert into dbo.SubModelDefaultBand 
	(SubModelDefault_ID,TaskBand_ID,DTStamp)
values
	(@newSubModelDefaultID,@defaultBandID,GETDATE())

	--Task D
set @taskID = (select t.WorkTask_ID from dbo.WorkTask t where t.WorkTaskName = 'Task D' and t.WorkModel_ID = @newWorkModelID)
set @defaultBandID = (select b.TaskBand_ID from dbo.TaskBand b inner join dbo.WorkTask t on b.WorkTask_ID = t.WorkTask_ID where t.WorkTaskName = 'Task D' and b.TaskBand_Weight = 1)
--set @defaultBandID = (select top(1) b.TaskBand_ID from dbo.TaskBand b where b.WorkTask_ID = @taskID order by newid())
--and insert these values into the default table
insert into dbo.SubModelDefaultBand 
	(SubModelDefault_ID,TaskBand_ID,DTStamp)
values
	(@newSubModelDefaultID,@defaultBandID,GETDATE())

	--Task H
set @taskID = (select t.WorkTask_ID from dbo.WorkTask t where t.WorkTaskName = 'Task H' and t.WorkModel_ID = @newWorkModelID)
set @defaultBandID = (select b.TaskBand_ID from dbo.TaskBand b inner join dbo.WorkTask t on b.WorkTask_ID = t.WorkTask_ID where t.WorkTaskName = 'Task H' and b.TaskBand_Weight = 1)
--set @defaultBandID = (select top(1) b.TaskBand_ID from dbo.TaskBand b where b.WorkTask_ID = @taskID order by newid())
--and insert these values into the default table
insert into dbo.SubModelDefaultBand 
	(SubModelDefault_ID,TaskBand_ID,DTStamp)
values
	(@newSubModelDefaultID,@defaultBandID,GETDATE())

		--Task I
set @taskID = (select t.WorkTask_ID from dbo.WorkTask t where t.WorkTaskName = 'Task I' and t.WorkModel_ID = @newWorkModelID)
set @defaultBandID = (select b.TaskBand_ID from dbo.TaskBand b inner join dbo.WorkTask t on b.WorkTask_ID = t.WorkTask_ID where t.WorkTaskName = 'Task I' and b.TaskBand_Weight = 1)
--set @defaultBandID = (select top(1) b.TaskBand_ID from dbo.TaskBand b where b.WorkTask_ID = @taskID order by newid())
--and insert these values into the default table
insert into dbo.SubModelDefaultBand 
	(SubModelDefault_ID,TaskBand_ID,DTStamp)
values
	(@newSubModelDefaultID,@defaultBandID,GETDATE())

		--Task J
set @taskID = (select t.WorkTask_ID from dbo.WorkTask t where t.WorkTaskName = 'Task J' and t.WorkModel_ID = @newWorkModelID)
set @defaultBandID = (select b.TaskBand_ID from dbo.TaskBand b inner join dbo.WorkTask t on b.WorkTask_ID = t.WorkTask_ID where t.WorkTaskName = 'Task J' and b.TaskBand_Weight = 1)
--set @defaultBandID = (select top(1) b.TaskBand_ID from dbo.TaskBand b where b.WorkTask_ID = @taskID order by newid())
--and insert these values into the default table
insert into dbo.SubModelDefaultBand 
	(SubModelDefault_ID,TaskBand_ID,DTStamp)
values
	(@newSubModelDefaultID,@defaultBandID,GETDATE())


	-- thats first default made for SubMod2 (default 3 out of all defaults)










-- then the second default for this submodel ...still submodel 2 and default 4

insert into [dbo].[SubModelDefault]
	([WorkSubModel_ID],[SubModelDefaultName],[SubModelDefaultDescription],[DTStamp])
values
	(@NewWorkSubModelID,@defaultName4,@defaultDescr4,GETDATE()) 
--return the id of this new default submodel
set @newSubModelDefaultID = SCOPE_IDENTITY()
/*
same as before
for this default, declare the default band for each task in this submodel
 (this is entirely hard-coded here just to get data in there) 
we know that submodel 2 uses the following tasks
'Task A', 'Task B','Task C','Task D','Task H','Task I','Task J'
get the id of each task and then randomely select one of its bands
select top(1) 
order by newid() for random
*/

--Task A
set @taskID = (select t.WorkTask_ID from dbo.WorkTask t where t.WorkTaskName = 'Task A' and t.WorkModel_ID = @newWorkModelID)
set @defaultBandID = (select b.TaskBand_ID from dbo.TaskBand b inner join dbo.WorkTask t on b.WorkTask_ID = t.WorkTask_ID where t.WorkTaskName = 'Task A' and b.TaskBand_Weight = 0)
--set @defaultBandID = (select top(1) b.TaskBand_ID from dbo.TaskBand b where b.WorkTask_ID = @taskID order by newid())
--and insert these values into the default table
insert into dbo.SubModelDefaultBand 
	(SubModelDefault_ID,TaskBand_ID,DTStamp)
values
	(@newSubModelDefaultID,@defaultBandID,GETDATE())
--Task B
set @taskID = (select t.WorkTask_ID from dbo.WorkTask t where t.WorkTaskName = 'Task B' and t.WorkModel_ID = @newWorkModelID)
set @defaultBandID = (select b.TaskBand_ID from dbo.TaskBand b inner join dbo.WorkTask t on b.WorkTask_ID = t.WorkTask_ID where t.WorkTaskName = 'Task B' and b.TaskBand_Weight = 0)
--set @defaultBandID = (select top(1) b.TaskBand_ID from dbo.TaskBand b where b.WorkTask_ID = @taskID order by newid())
--and insert these values into the default table
insert into dbo.SubModelDefaultBand 
	(SubModelDefault_ID,TaskBand_ID,DTStamp)
values
	(@newSubModelDefaultID,@defaultBandID,GETDATE())

	--Task C
set @taskID = (select t.WorkTask_ID from dbo.WorkTask t where t.WorkTaskName = 'Task C' and t.WorkModel_ID = @newWorkModelID)
set @defaultBandID = (select b.TaskBand_ID from dbo.TaskBand b inner join dbo.WorkTask t on b.WorkTask_ID = t.WorkTask_ID where t.WorkTaskName = 'Task C' and b.TaskBand_Weight = 0)
--set @defaultBandID = (select top(1) b.TaskBand_ID from dbo.TaskBand b where b.WorkTask_ID = @taskID order by newid())
--and insert these values into the default table
insert into dbo.SubModelDefaultBand 
	(SubModelDefault_ID,TaskBand_ID,DTStamp)
values
	(@newSubModelDefaultID,@defaultBandID,GETDATE())

	--Task D
set @taskID = (select t.WorkTask_ID from dbo.WorkTask t where t.WorkTaskName = 'Task D' and t.WorkModel_ID = @newWorkModelID)
set @defaultBandID = (select b.TaskBand_ID from dbo.TaskBand b inner join dbo.WorkTask t on b.WorkTask_ID = t.WorkTask_ID where t.WorkTaskName = 'Task D' and b.TaskBand_Weight = 0)
--set @defaultBandID = (select top(1) b.TaskBand_ID from dbo.TaskBand b where b.WorkTask_ID = @taskID order by newid())
--and insert these values into the default table
insert into dbo.SubModelDefaultBand 
	(SubModelDefault_ID,TaskBand_ID,DTStamp)
values
	(@newSubModelDefaultID,@defaultBandID,GETDATE())

	--Task H
set @taskID = (select t.WorkTask_ID from dbo.WorkTask t where t.WorkTaskName = 'Task H' and t.WorkModel_ID = @newWorkModelID)
set @defaultBandID = (select b.TaskBand_ID from dbo.TaskBand b inner join dbo.WorkTask t on b.WorkTask_ID = t.WorkTask_ID where t.WorkTaskName = 'Task H' and b.TaskBand_Weight = 0)
--set @defaultBandID = (select top(1) b.TaskBand_ID from dbo.TaskBand b where b.WorkTask_ID = @taskID order by newid())
--and insert these values into the default table
insert into dbo.SubModelDefaultBand 
	(SubModelDefault_ID,TaskBand_ID,DTStamp)
values
	(@newSubModelDefaultID,@defaultBandID,GETDATE())

		--Task I
set @taskID = (select t.WorkTask_ID from dbo.WorkTask t where t.WorkTaskName = 'Task I' and t.WorkModel_ID = @newWorkModelID)
set @defaultBandID = (select b.TaskBand_ID from dbo.TaskBand b inner join dbo.WorkTask t on b.WorkTask_ID = t.WorkTask_ID where t.WorkTaskName = 'Task I' and b.TaskBand_Weight = 0)
--set @defaultBandID = (select top(1) b.TaskBand_ID from dbo.TaskBand b where b.WorkTask_ID = @taskID order by newid())
--and insert these values into the default table
insert into dbo.SubModelDefaultBand 
	(SubModelDefault_ID,TaskBand_ID,DTStamp)
values
	(@newSubModelDefaultID,@defaultBandID,GETDATE())

		--Task J
set @taskID = (select t.WorkTask_ID from dbo.WorkTask t where t.WorkTaskName = 'Task J' and t.WorkModel_ID = @newWorkModelID)
set @defaultBandID = (select b.TaskBand_ID from dbo.TaskBand b inner join dbo.WorkTask t on b.WorkTask_ID = t.WorkTask_ID where t.WorkTaskName = 'Task J' and b.TaskBand_Weight = 0)
--set @defaultBandID = (select top(1) b.TaskBand_ID from dbo.TaskBand b where b.WorkTask_ID = @taskID order by newid())
--and insert these values into the default table
insert into dbo.SubModelDefaultBand 
	(SubModelDefault_ID,TaskBand_ID,DTStamp)
values
	(@newSubModelDefaultID,@defaultBandID,GETDATE())
















--and now the last two defaults, this is submodel 3 and the two defaults are default4 and default 5
set @NewWorkSubModelID = (select s.WorkSubModel_ID from dbo.WorkSubModel s where s.WorkSubModelName = @subModelName3)
insert into [dbo].[SubModelDefault]
	([WorkSubModel_ID],[SubModelDefaultName],[SubModelDefaultDescription],[DTStamp])
values
	(@NewWorkSubModelID,@defaultName5,@defaultDescr5,GETDATE()) 
--return the id of this new default submodel
set @newSubModelDefaultID = SCOPE_IDENTITY()

--'Task A', 'Task B','Task C','Task D','Task K','Task L','Task M'
/*
same as before for this default, declare the default band for each task in this submodel
 (this is entirely hard-coded here just to get data in there) 
we know that submodel 1 uses the following tasks
'Task A', 'Task B','Task C','Task D','Task K','Task L','Task M'
get the id of each task and then randomely select one of its bands
select top(1) 
order by newid() for random
*/

-- Task A
set @taskID = (select t.WorkTask_ID from dbo.WorkTask t where t.WorkTaskName = 'Task A' and t.WorkModel_ID = @newWorkModelID)
set @defaultBandID = (select top(1) b.TaskBand_ID from dbo.TaskBand b where b.WorkTask_ID = @taskID order by newid())
--and insert these values into the default table
insert into dbo.SubModelDefaultBand 
	(SubModelDefault_ID,TaskBand_ID,DTStamp)
values
	(@newSubModelDefaultID,@defaultBandID,GETDATE())

--Task B
set @taskID = (select t.WorkTask_ID from dbo.WorkTask t where t.WorkTaskName = 'Task B' and t.WorkModel_ID = @newWorkModelID)
set @defaultBandID = (select top(1) b.TaskBand_ID from dbo.TaskBand b where b.WorkTask_ID = @taskID order by newid())
--and insert these values into the default table
insert into dbo.SubModelDefaultBand 
	(SubModelDefault_ID,TaskBand_ID,DTStamp)
values
	(@newSubModelDefaultID,@defaultBandID,GETDATE())

	--Task C
set @taskID = (select t.WorkTask_ID from dbo.WorkTask t where t.WorkTaskName = 'Task C' and t.WorkModel_ID = @newWorkModelID)
set @defaultBandID = (select top(1) b.TaskBand_ID from dbo.TaskBand b where b.WorkTask_ID = @taskID order by newid())
--and insert these values into the default table
insert into dbo.SubModelDefaultBand 
	(SubModelDefault_ID,TaskBand_ID,DTStamp)
values
	(@newSubModelDefaultID,@defaultBandID,GETDATE())

	--Task D
set @taskID = (select t.WorkTask_ID from dbo.WorkTask t where t.WorkTaskName = 'Task D' and t.WorkModel_ID = @newWorkModelID)
set @defaultBandID = (select top(1) b.TaskBand_ID from dbo.TaskBand b where b.WorkTask_ID = @taskID order by newid())
--and insert these values into the default table
insert into dbo.SubModelDefaultBand 
	(SubModelDefault_ID,TaskBand_ID,DTStamp)
values
	(@newSubModelDefaultID,@defaultBandID,GETDATE())

	--Task K
set @taskID = (select t.WorkTask_ID from dbo.WorkTask t where t.WorkTaskName = 'Task K' and t.WorkModel_ID = @newWorkModelID)
set @defaultBandID = (select top(1) b.TaskBand_ID from dbo.TaskBand b where b.WorkTask_ID = @taskID order by newid())
--and insert these values into the default table
insert into dbo.SubModelDefaultBand 
	(SubModelDefault_ID,TaskBand_ID,DTStamp)
values
	(@newSubModelDefaultID,@defaultBandID,GETDATE())

	--Task L
set @taskID = (select t.WorkTask_ID from dbo.WorkTask t where t.WorkTaskName = 'Task L' and t.WorkModel_ID = @newWorkModelID)
set @defaultBandID = (select top(1) b.TaskBand_ID from dbo.TaskBand b where b.WorkTask_ID = @taskID order by newid())
--and insert these values into the default table
insert into dbo.SubModelDefaultBand 
	(SubModelDefault_ID,TaskBand_ID,DTStamp)
values
	(@newSubModelDefaultID,@defaultBandID,GETDATE())

		--Task M
set @taskID = (select t.WorkTask_ID from dbo.WorkTask t where t.WorkTaskName = 'Task M' and t.WorkModel_ID = @newWorkModelID)
set @defaultBandID = (select top(1) b.TaskBand_ID from dbo.TaskBand b where b.WorkTask_ID = @taskID order by newid())
--and insert these values into the default table
insert into dbo.SubModelDefaultBand 
	(SubModelDefault_ID,TaskBand_ID,DTStamp)
values
	(@newSubModelDefaultID,@defaultBandID,GETDATE())

	-- default 5 made there ^ that is first default for SubMod3


















	--default 6, still submodel 3

insert into [dbo].[SubModelDefault]
	([WorkSubModel_ID],[SubModelDefaultName],[SubModelDefaultDescription],[DTStamp])
values
	(@NewWorkSubModelID,@defaultName6,@defaultDescr6,GETDATE()) 
--return the id of this new default submodel
set @newSubModelDefaultID = SCOPE_IDENTITY()

--'Task A', 'Task B','Task C','Task D','Task K','Task L','Task M'
/*
same as before for this default, declare the default band for each task in this submodel
 (this is entirely hard-coded here just to get data in there) 
we know that submodel 1 uses the following tasks
'Task A', 'Task B','Task C','Task D','Task K','Task L','Task M'
get the id of each task and then randomely select one of its bands
select top(1) 
order by newid() for random
*/

-- Task A
set @taskID = (select t.WorkTask_ID from dbo.WorkTask t where t.WorkTaskName = 'Task A' and t.WorkModel_ID = @newWorkModelID)
set @defaultBandID = (select top(1) b.TaskBand_ID from dbo.TaskBand b where b.WorkTask_ID = @taskID order by newid())
--and insert these values into the default table
insert into dbo.SubModelDefaultBand 
	(SubModelDefault_ID,TaskBand_ID,DTStamp)
values
	(@newSubModelDefaultID,@defaultBandID,GETDATE())

--Task B
set @taskID = (select t.WorkTask_ID from dbo.WorkTask t where t.WorkTaskName = 'Task B' and t.WorkModel_ID = @newWorkModelID)
set @defaultBandID = (select top(1) b.TaskBand_ID from dbo.TaskBand b where b.WorkTask_ID = @taskID order by newid())
--and insert these values into the default table
insert into dbo.SubModelDefaultBand 
	(SubModelDefault_ID,TaskBand_ID,DTStamp)
values
	(@newSubModelDefaultID,@defaultBandID,GETDATE())

	--Task C
set @taskID = (select t.WorkTask_ID from dbo.WorkTask t where t.WorkTaskName = 'Task C' and t.WorkModel_ID = @newWorkModelID)
set @defaultBandID = (select top(1) b.TaskBand_ID from dbo.TaskBand b where b.WorkTask_ID = @taskID order by newid())
--and insert these values into the default table
insert into dbo.SubModelDefaultBand 
	(SubModelDefault_ID,TaskBand_ID,DTStamp)
values
	(@newSubModelDefaultID,@defaultBandID,GETDATE())

	--Task D
set @taskID = (select t.WorkTask_ID from dbo.WorkTask t where t.WorkTaskName = 'Task D' and t.WorkModel_ID = @newWorkModelID)
set @defaultBandID = (select top(1) b.TaskBand_ID from dbo.TaskBand b where b.WorkTask_ID = @taskID order by newid())
--and insert these values into the default table
insert into dbo.SubModelDefaultBand 
	(SubModelDefault_ID,TaskBand_ID,DTStamp)
values
	(@newSubModelDefaultID,@defaultBandID,GETDATE())

	--Task K
set @taskID = (select t.WorkTask_ID from dbo.WorkTask t where t.WorkTaskName = 'Task K' and t.WorkModel_ID = @newWorkModelID)
set @defaultBandID = (select top(1) b.TaskBand_ID from dbo.TaskBand b where b.WorkTask_ID = @taskID order by newid())
--and insert these values into the default table
insert into dbo.SubModelDefaultBand 
	(SubModelDefault_ID,TaskBand_ID,DTStamp)
values
	(@newSubModelDefaultID,@defaultBandID,GETDATE())

	--Task L
set @taskID = (select t.WorkTask_ID from dbo.WorkTask t where t.WorkTaskName = 'Task L' and t.WorkModel_ID = @newWorkModelID)
set @defaultBandID = (select top(1) b.TaskBand_ID from dbo.TaskBand b where b.WorkTask_ID = @taskID order by newid())
--and insert these values into the default table
insert into dbo.SubModelDefaultBand 
	(SubModelDefault_ID,TaskBand_ID,DTStamp)
values
	(@newSubModelDefaultID,@defaultBandID,GETDATE())

		--Task M
set @taskID = (select t.WorkTask_ID from dbo.WorkTask t where t.WorkTaskName = 'Task M' and t.WorkModel_ID = @newWorkModelID)
set @defaultBandID = (select top(1) b.TaskBand_ID from dbo.TaskBand b where b.WorkTask_ID = @taskID order by newid())
--and insert these values into the default table
insert into dbo.SubModelDefaultBand 
	(SubModelDefault_ID,TaskBand_ID,DTStamp)
values
	(@newSubModelDefaultID,@defaultBandID,GETDATE())


--SELECT * FROM dbo.WorkSubModel s
--inner join dbo.WorkModel m on 


--			do the housekeeping






DROP TABLE IF EXISTS #WorkModelUpload
DROP TABLE IF EXISTS #WorkTaskUpload
DROP TABLE IF EXISTS #TaskBandUpload