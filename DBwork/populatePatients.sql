



/* going to populate sligo and dublin properly over a timerange of 3 months, start of feb to end of apr */

/*
 we will populate the tables with patients for every ward.
 previously we had patients in mayo ward only, starting on 25th jan 2021
 and one of these patients started in sligo ward and on 25th jan and then moved
 to mayo ward on 30th jan - one episode move
 we will not have any more episode moves, we will leave all our patients
 in their beds indefinitely.
 so now we will enter the new patients to all the other wards

 we will create 12 patients for each ward, but we only have ten beds so we will
 only be using 10 of them for now, the other two are for use later if we get to it

 they will all start on 1st feb
 we will eatablish the default band values for each ward and assign those to the work table
 for every work shift between the start and end dates

 if we have time later we will make changes to some of those band values, so that every entry is not exactly the same

*/







--declare a start date - we will start them all on the same day
declare @startDateTime as datetime
set @startDateTime =  '2021-02-01 00:00'
--without the time part
declare @startDate as date
set @startDate =  '2021-02-01'
declare @endDate as date  -- for entering the work in this script - we will enter it from the start date to the end date, just to get data in there
set @endDate = '2021-05-31'





















-- some things to check before we start
--=====================================================================
-- do any of the mrn numbers we propose to enter, already exist
if exists(select 'x' from dbo.Patient p where p.PatMRN between 112 and 171)
begin
	select 'mrn already exists'
	return
end
--======================================================================
--for any of the beds we propose to use (ie all the beds on each ward), are any of them in use since our start date
if exists
(
	select * from dbo.EpisodeMove m 
	inner join dbo.Bed b
	on m.Bed_ID = b.Bed_ID
	inner join dbo.Ward w on b.Ward_ID = w.Ward_ID
	where w.Ward_ID in (2,3,4,5,6) -- these are the wards we are going to enter in (Sligo, Dublin)
	and m.StartDT <= @startDateTime and m.EndDT > = @startDateTime -- straddles the start datetime
)
begin
	select 'bed overlap'
	return
end
--==========================================================================================
-- as we are going to use the default bands, and these were asigned manually to the wards
-- do a check here to make sure they are ok, default must match submodel
if exists
(
	select * from dbo.Ward w inner join
	dbo.WorkSubModel s 
	on w.WorkSubModel_ID = s.WorkSubModel_ID
	inner join dbo.SubModelDefault d
	on w.SubModelDefault_ID = d.SubModelDefault_ID
	where s.WorkSubModel_ID <> d.WorkSubModel_ID
	and w.Ward_ID in (2,3,4,5,6)
)
begin
	select 'ward submodel and default are out of sync'
	return
end
--==========================================================================================
--ensure there is a submodel and a default specified for each of these wards
if exists
(
	select * from dbo.Ward w where w.WorkSubModel_ID is null or w.SubModelDefault_ID is null
)
begin
	select 'missing submodel or default'
	return
end

--==========================================================================================



















declare @adm_ID as int
-- we will make them all the standard admission with nothing unusual about them
-- this is the Episode Status 
-- eg. whether we are entering they in the system while awaiting their arrival, 
-- whether they have arrived and are in bed,
-- whether they are discharged but are sitting in a chair somewhere still being looked after before they leave the building

set @adm_ID = (select p.Param_ID from dbo.[Param] p where p.ParamValue = 'adm')

declare @SligoSubModel as int
declare @DublinSubModel as int
declare @WicklowSubModel as int
declare @WaterfordSubModel as int
declare @CorkSubModel as int

declare @SligoDefault as int
declare @DublinDefault as int
declare @WicklowDefault as int
declare @WaterfordDefault as int
declare @CorkDefault as int

set @SligoSubModel = (select w.WorkSubModel_ID from dbo.Ward w where w.WardName = 'Sligo')
set @DublinSubModel = (select w.WorkSubModel_ID from dbo.Ward w where w.WardName = 'Dublin')
set @WicklowSubModel = (select w.WorkSubModel_ID from dbo.Ward w where w.WardName = 'Wicklow')
set @WaterfordSubModel = (select w.WorkSubModel_ID from dbo.Ward w where w.WardName = 'Waterford')
set @CorkSubModel = (select w.WorkSubModel_ID from dbo.Ward w where w.WardName = 'Cork')

set @SligoDefault = (select w.SubModelDefault_ID from dbo.Ward w where w.WardName = 'Sligo')
set @DublinDefault = (select w.SubModelDefault_ID from dbo.Ward w where w.WardName = 'Dublin')
set @WicklowDefault = (select w.SubModelDefault_ID from dbo.Ward w where w.WardName = 'Wicklow')
set @WaterfordDefault = (select w.SubModelDefault_ID from dbo.Ward w where w.WardName = 'Waterford')
set @CorkDefault = (select w.SubModelDefault_ID from dbo.Ward w where w.WardName = 'Cork')

-- get the diagnosis info
DECLARE @Appendicitis_ID as int
DECLARE @Choleycystitis_ID as int
DECLARE @HeadInjury_ID as int
DECLARE @FractureFemur_ID as int
DECLARE @DislocatedShoulder_ID as int
DECLARE @Hysterectomy_ID as int
DECLARE @Pneumonia_ID as int
DECLARE @Hypertension_ID as int
DECLARE @Angina_ID as int
DECLARE @IrregularHeartBeat_ID as int
DECLARE @Diabetes_ID as int
DECLARE @Tonsillectomy_ID as int
DECLARE @Cataracts_ID as int
DECLARE @Glaucoma_ID as int

set @Appendicitis_ID = (select d.Diag_ID from [dbo].Diagnosis d where d.DiagnosisName = 'Appendicitis')
set @Choleycystitis_ID = (select d.Diag_ID from [dbo].Diagnosis d where d.DiagnosisName = 'Choleycystitis')
set @HeadInjury_ID = (select d.Diag_ID from [dbo].Diagnosis d where d.DiagnosisName = 'HeadInjury')
set @FractureFemur_ID = (select d.Diag_ID from [dbo].Diagnosis d where d.DiagnosisName = 'FractureFemur')
set @DislocatedShoulder_ID = (select d.Diag_ID from [dbo].Diagnosis d where d.DiagnosisName = 'DislocatedShoulder')
set @Hysterectomy_ID = (select d.Diag_ID from [dbo].Diagnosis d where d.DiagnosisName = 'Hysterectomy')
set @Pneumonia_ID = (select d.Diag_ID from [dbo].Diagnosis d where d.DiagnosisName = 'Pneumonia')
set @Hypertension_ID = (select d.Diag_ID from [dbo].Diagnosis d where d.DiagnosisName = 'Hypertension')
set @Angina_ID = (select d.Diag_ID from [dbo].Diagnosis d where d.DiagnosisName = 'Angina')
set @IrregularHeartBeat_ID = (select d.Diag_ID from [dbo].Diagnosis d where d.DiagnosisName = 'IrregularHeartBeat')
set @Diabetes_ID = (select d.Diag_ID from [dbo].Diagnosis d where d.DiagnosisName = 'Diabetes')
set @Tonsillectomy_ID = (select d.Diag_ID from [dbo].Diagnosis d where d.DiagnosisName = 'Tonsillectomy')
set @Cataracts_ID = (select d.Diag_ID from [dbo].Diagnosis d where d.DiagnosisName = 'Cataracts')
set @Glaucoma_ID = (select d.Diag_ID from [dbo].Diagnosis d where d.DiagnosisName = 'Glaucoma')


-- make sligo medical ward eg pneumonia, hypertension, use submodel 1
-- make dublin and wicklow general surgery and orthopaedic surgery
-- make waterford and cork ophthalmology - eyes

-- get the ward info
DECLARE @SligoWard_ID as int
DECLARE @DublinWard_ID as int
DECLARE @WicklowWard_ID as int
DECLARE @WaterfordWard_ID as int
DECLARE @CorkWard_ID as int

set @SligoWard_ID = (select w.Ward_ID from [dbo].[Ward] w where w.WardName = 'Sligo')
set @DublinWard_ID = (select w.Ward_ID from [dbo].[Ward] w where w.WardName = 'Dublin')
set @WicklowWard_ID = (select w.Ward_ID from [dbo].[Ward] w where w.WardName = 'Wicklow')
set @WaterfordWard_ID = (select w.Ward_ID from [dbo].[Ward] w where w.WardName = 'Waterford')
set @CorkWard_ID = (select w.Ward_ID from [dbo].[Ward] w where w.WardName = 'Cork')

--get the bed info
DECLARE @SligoBed1_ID as int
DECLARE @SligoBed2_ID as int
DECLARE @SligoBed3_ID as int
DECLARE @SligoBed4_ID as int
DECLARE @SligoBed5_ID as int
DECLARE @SligoBed6_ID as int
DECLARE @SligoBed7_ID as int
DECLARE @SligoBed8_ID as int
DECLARE @SligoBed9_ID as int
DECLARE @SligoBed10_ID as int

DECLARE @DublinBed1_ID as int
DECLARE @DublinBed2_ID as int
DECLARE @DublinBed3_ID as int
DECLARE @DublinBed4_ID as int
DECLARE @DublinBed5_ID as int
DECLARE @DublinBed6_ID as int
DECLARE @DublinBed7_ID as int
DECLARE @DublinBed8_ID as int

DECLARE @WicklowBed1_ID as int
DECLARE @WicklowBed2_ID as int
DECLARE @WicklowBed3_ID as int
DECLARE @WicklowBed4_ID as int
DECLARE @WicklowBed5_ID as int
DECLARE @WicklowBed6_ID as int

DECLARE @WaterfordBed1_ID as int
DECLARE @WaterfordBed2_ID as int
DECLARE @WaterfordBed3_ID as int
DECLARE @WaterfordBed4_ID as int
DECLARE @WaterfordBed5_ID as int
DECLARE @WaterfordBed6_ID as int

DECLARE @CorkBed1_ID as int
DECLARE @CorkBed2_ID as int

	set @SligoBed1_ID = (select b.Bed_ID from [dbo].[Bed] b where b.BedName = 'SligoBed1')
	set @SligoBed2_ID = (select b.Bed_ID from [dbo].[Bed] b where b.BedName = 'SligoBed2')
	set @SligoBed3_ID = (select b.Bed_ID from [dbo].[Bed] b where b.BedName = 'SligoBed3')
	set @SligoBed4_ID = (select b.Bed_ID from [dbo].[Bed] b where b.BedName = 'SligoBed4')
	set @SligoBed5_ID = (select b.Bed_ID from [dbo].[Bed] b where b.BedName = 'SligoBed5')
	set @SligoBed6_ID = (select b.Bed_ID from [dbo].[Bed] b where b.BedName = 'SligoBed6')
	set @SligoBed7_ID = (select b.Bed_ID from [dbo].[Bed] b where b.BedName = 'SligoBed7')
	set @SligoBed8_ID = (select b.Bed_ID from [dbo].[Bed] b where b.BedName = 'SligoBed8')
	set @SligoBed9_ID = (select b.Bed_ID from [dbo].[Bed] b where b.BedName = 'SligoBed9')
	set @SligoBed10_ID = (select b.Bed_ID from [dbo].[Bed] b where b.BedName = 'SligoBed10')

	set @DublinBed1_ID = (select b.Bed_ID from [dbo].[Bed] b where b.BedName = 'DublinBed1')
	set @DublinBed2_ID = (select b.Bed_ID from [dbo].[Bed] b where b.BedName = 'DublinBed2')
	set @DublinBed3_ID = (select b.Bed_ID from [dbo].[Bed] b where b.BedName = 'DublinBed3')
	set @DublinBed4_ID = (select b.Bed_ID from [dbo].[Bed] b where b.BedName = 'DublinBed4')
	set @DublinBed5_ID = (select b.Bed_ID from [dbo].[Bed] b where b.BedName = 'DublinBed5')
	set @DublinBed6_ID = (select b.Bed_ID from [dbo].[Bed] b where b.BedName = 'DublinBed6')
	set @DublinBed7_ID = (select b.Bed_ID from [dbo].[Bed] b where b.BedName = 'DublinBed7')
	set @DublinBed8_ID = (select b.Bed_ID from [dbo].[Bed] b where b.BedName = 'DublinBed8')

	set @WicklowBed1_ID = (select b.Bed_ID from [dbo].[Bed] b where b.BedName = 'WicklowBed1')
	set @WicklowBed2_ID = (select b.Bed_ID from [dbo].[Bed] b where b.BedName = 'WicklowBed2')
	set @WicklowBed3_ID = (select b.Bed_ID from [dbo].[Bed] b where b.BedName = 'WicklowBed3')
	set @WicklowBed4_ID = (select b.Bed_ID from [dbo].[Bed] b where b.BedName = 'WicklowBed4')
	set @WicklowBed5_ID = (select b.Bed_ID from [dbo].[Bed] b where b.BedName = 'WicklowBed5')
	set @WicklowBed6_ID = (select b.Bed_ID from [dbo].[Bed] b where b.BedName = 'WicklowBed6')

	set @WaterfordBed1_ID = (select b.Bed_ID from [dbo].[Bed] b where b.BedName = 'WaterfordBed1')
	set @WaterfordBed2_ID = (select b.Bed_ID from [dbo].[Bed] b where b.BedName = 'WaterfordBed2')
	set @WaterfordBed3_ID = (select b.Bed_ID from [dbo].[Bed] b where b.BedName = 'WaterfordBed3')
	set @WaterfordBed4_ID = (select b.Bed_ID from [dbo].[Bed] b where b.BedName = 'WaterfordBed4')


	set @CorkBed1_ID = (select b.Bed_ID from [dbo].[Bed] b where b.BedName = 'CorkBed1')
	set @CorkBed2_ID = (select b.Bed_ID from [dbo].[Bed] b where b.BedName = 'CorkBed2')


--enter some patients  first sligo...we're leaving mayo as is...we put some patients there in the beginning
declare @SligoPt1_ID as int
declare @SligoPt2_ID as int
declare @SligoPt3_ID as int
declare @SligoPt4_ID as int
declare @SligoPt5_ID as int
declare @SligoPt6_ID as int
declare @SligoPt7_ID as int
declare @SligoPt8_ID as int

insert into dbo.Patient
	(PatFirstName,PatLastName,PatDOB,PatMRN,DTStamp)
values
	('SligoPt1','SligoPt1','1950-01-01', 112, GETDATE()),
	('SligoPt2','SligoPt2','1978-01-01',113, GETDATE()),
	('SligoPt3','SligoPt3','1945-01-01',114, GETDATE()),
	('SligoPt4','SligoPt4','1976-01-01',115, GETDATE()),
	('SligoPt5','SligoPt5','1978-01-01',116, GETDATE()),
	('SligoPt6','SligoPt6','1980-01-01',117, GETDATE()),
	('SligoPt7','SligoPt7','1990-01-01',118, GETDATE()),
	('SligoPt8','SligoPt8','1995-01-01',119, GETDATE())

--return the IDs for use later
set @SligoPt1_ID = (select p.Pat_ID from dbo.Patient p where p.PatMRN = 112)
set @SligoPt2_ID = (select p.Pat_ID from dbo.Patient p where p.PatMRN = 113)
set @SligoPt3_ID = (select p.Pat_ID from dbo.Patient p where p.PatMRN = 114)
set @SligoPt4_ID = (select p.Pat_ID from dbo.Patient p where p.PatMRN = 115)
set @SligoPt5_ID = (select p.Pat_ID from dbo.Patient p where p.PatMRN = 116)
set @SligoPt6_ID = (select p.Pat_ID from dbo.Patient p where p.PatMRN = 117)
set @SligoPt7_ID = (select p.Pat_ID from dbo.Patient p where p.PatMRN = 118)
set @SligoPt8_ID = (select p.Pat_ID from dbo.Patient p where p.PatMRN = 119)

--create episodes for all these patients - just declare the ids here to use later
declare @SligoPt1_Ep as int
declare @SligoPt2_Ep as int
declare @SligoPt3_Ep as int
declare @SligoPt4_Ep as int
declare @SligoPt5_Ep as int
declare @SligoPt6_Ep as int
declare @SligoPt7_Ep as int
declare @SligoPt8_Ep as int

--enter the episodes and return the ids to use in making episode moves
-- make mayo and sligo medical wards eg pneumonia, hypertension, they use submodel 1
-- for sligo we will use the medical type diagnosis
-- @Pneumonia_ID @Hypertension_ID @Diabetes_ID
insert  into dbo.Episode
	(Pat_ID,Diag_ID,StartDT,EndDT,DTStamp)
values
	(@SligoPt1_ID,@Pneumonia_ID,@startDateTime,'2500-01-01',GETDATE()),
	(@SligoPt2_ID,@Pneumonia_ID,@startDateTime,'2500-01-01',GETDATE()),
	(@SligoPt3_ID,@Pneumonia_ID,@startDateTime,'2500-01-01',GETDATE()),
	(@SligoPt4_ID,@Diabetes_ID,@startDateTime,'2500-01-01',GETDATE()),
	(@SligoPt5_ID,@Diabetes_ID,@startDateTime,'2500-01-01',GETDATE()),
	(@SligoPt6_ID,@Hypertension_ID,@startDateTime,'2500-01-01',GETDATE()),
	(@SligoPt7_ID,@Hypertension_ID,@startDateTime,'2500-01-01',GETDATE()),
	(@SligoPt8_ID,@Hypertension_ID,@startDateTime,'2500-01-01',GETDATE())
--return the episodes and enter the episode moves - these are the first locations of the patient in this episode
-- at this stage everything is new so we know we will only return one record - the one we've just entered
set @SligoPt1_Ep = (select e.Episode_ID from dbo.Episode e where e.Pat_ID = @SligoPt1_ID and e.Diag_ID = @Pneumonia_ID)
set @SligoPt2_Ep = (select e.Episode_ID from dbo.Episode e where e.Pat_ID = @SligoPt2_ID and e.Diag_ID = @Pneumonia_ID)
set @SligoPt3_Ep = (select e.Episode_ID from dbo.Episode e where e.Pat_ID = @SligoPt3_ID and e.Diag_ID = @Pneumonia_ID)
set @SligoPt4_Ep = (select e.Episode_ID from dbo.Episode e where e.Pat_ID = @SligoPt4_ID and e.Diag_ID = @Diabetes_ID)
set @SligoPt5_Ep = (select e.Episode_ID from dbo.Episode e where e.Pat_ID = @SligoPt5_ID and e.Diag_ID = @Diabetes_ID)
set @SligoPt6_Ep = (select e.Episode_ID from dbo.Episode e where e.Pat_ID = @SligoPt6_ID and e.Diag_ID = @Hypertension_ID)
set @SligoPt7_Ep = (select e.Episode_ID from dbo.Episode e where e.Pat_ID = @SligoPt7_ID and e.Diag_ID = @Hypertension_ID)
set @SligoPt8_Ep = (select e.Episode_ID from dbo.Episode e where e.Pat_ID = @SligoPt8_ID and e.Diag_ID = @Hypertension_ID)

--enter the first episode move for 10 of these, episodes for 10 only, keep the other two spare
--insert some episode moves for these
insert into dbo.EpisodeMove
	(Episode_ID,Bed_ID,EpStatus,StartDT,EndDT,DTStamp)
values
	(@SligoPt1_Ep,@SligoBed1_ID,@adm_ID,@startDateTime,'2500-01-01',GETDATE()),	
	(@SligoPt2_Ep,@SligoBed2_ID,@adm_ID,@startDateTime,'2500-01-01',GETDATE()),
	(@SligoPt3_Ep,@SligoBed3_ID,@adm_ID,@startDateTime,'2500-01-01',GETDATE()),
	(@SligoPt4_Ep,@SligoBed4_ID,@adm_ID,@startDateTime,'2500-01-01',GETDATE()),
	(@SligoPt5_Ep,@SligoBed5_ID,@adm_ID,@startDateTime,'2500-01-01',GETDATE()),
	(@SligoPt6_Ep,@SligoBed6_ID,@adm_ID,@startDateTime,'2500-01-01',GETDATE()),
	(@SligoPt7_Ep,@SligoBed7_ID,@adm_ID,@startDateTime,'2500-01-01',GETDATE()),
	(@SligoPt8_Ep,@SligoBed8_ID,@adm_ID,@startDateTime,'2500-01-01',GETDATE())
--declare the episode moves
declare @SligoPt1_EpMove as int
declare @SligoPt2_EpMove as int
declare @SligoPt3_EpMove as int
declare @SligoPt4_EpMove as int
declare @SligoPt5_EpMove as int
declare @SligoPt6_EpMove as int
declare @SligoPt7_EpMove as int
declare @SligoPt8_EpMove as int

set @SligoPt1_EpMove = (select m.EpisodeMove_ID from dbo.EpisodeMove m where m.Episode_ID = @SligoPt1_Ep)
set @SligoPt2_EpMove = (select m.EpisodeMove_ID from dbo.EpisodeMove m where m.Episode_ID = @SligoPt2_Ep)
set @SligoPt3_EpMove = (select m.EpisodeMove_ID from dbo.EpisodeMove m where m.Episode_ID = @SligoPt3_Ep)
set @SligoPt4_EpMove = (select m.EpisodeMove_ID from dbo.EpisodeMove m where m.Episode_ID = @SligoPt4_Ep)
set @SligoPt5_EpMove = (select m.EpisodeMove_ID from dbo.EpisodeMove m where m.Episode_ID = @SligoPt5_Ep)
set @SligoPt6_EpMove = (select m.EpisodeMove_ID from dbo.EpisodeMove m where m.Episode_ID = @SligoPt6_Ep)
set @SligoPt7_EpMove = (select m.EpisodeMove_ID from dbo.EpisodeMove m where m.Episode_ID = @SligoPt7_Ep)
set @SligoPt8_EpMove = (select m.EpisodeMove_ID from dbo.EpisodeMove m where m.Episode_ID = @SligoPt8_Ep)

--now with each of these episode moves we will call the sp to enter the default bands from startdate to end date
exec [dbo].[sp_InsertDefaultWorkForDateRange_DEV] @SligoPt1_EpMove, @startDateTime, @endDate
exec [dbo].[sp_InsertDefaultWorkForDateRange_DEV] @SligoPt2_EpMove, @startDateTime, @endDate
exec [dbo].[sp_InsertDefaultWorkForDateRange_DEV] @SligoPt3_EpMove, @startDateTime, @endDate
exec [dbo].[sp_InsertDefaultWorkForDateRange_DEV] @SligoPt4_EpMove, @startDateTime, @endDate
exec [dbo].[sp_InsertDefaultWorkForDateRange_DEV] @SligoPt5_EpMove, @startDateTime, @endDate
exec [dbo].[sp_InsertDefaultWorkForDateRange_DEV] @SligoPt6_EpMove, @startDateTime, @endDate
exec [dbo].[sp_InsertDefaultWorkForDateRange_DEV] @SligoPt7_EpMove, @startDateTime, @endDate
exec [dbo].[sp_InsertDefaultWorkForDateRange_DEV] @SligoPt8_EpMove, @startDateTime, @endDate













--same for dublin, wicklow, waterford and cork
--dublin
declare @DublinPt1_ID as int
declare @DublinPt2_ID as int
declare @DublinPt3_ID as int
declare @DublinPt4_ID as int
declare @DublinPt5_ID as int
declare @DublinPt6_ID as int
declare @DublinPt7_ID as int
declare @DublinPt8_ID as int

insert into dbo.Patient
	(PatFirstName,PatLastName,PatDOB,PatMRN,DTStamp)
values
	('DublinPt1','DublinPt1','1950-01-01', 124, GETDATE()),
	('DublinPt2','DublinPt2','1978-01-01',125, GETDATE()),
	('DublinPt3','DublinPt3','1945-01-01',126, GETDATE()),
	('DublinPt4','DublinPt4','1976-01-01',127, GETDATE()),
	('DublinPt5','DublinPt5','1978-01-01',128, GETDATE()),
	('DublinPt6','DublinPt6','1980-01-01',129, GETDATE()),
	('DublinPt7','DublinPt7','1990-01-01',130, GETDATE()),
	('DublinPt8','DublinPt8','1995-01-01',131, GETDATE())

--return the IDs for use later
set @DublinPt1_ID = (select p.Pat_ID from dbo.Patient p where p.PatMRN = 124)
set @DublinPt2_ID = (select p.Pat_ID from dbo.Patient p where p.PatMRN = 125)
set @DublinPt3_ID = (select p.Pat_ID from dbo.Patient p where p.PatMRN = 126)
set @DublinPt4_ID = (select p.Pat_ID from dbo.Patient p where p.PatMRN = 127)
set @DublinPt5_ID = (select p.Pat_ID from dbo.Patient p where p.PatMRN = 128)
set @DublinPt6_ID = (select p.Pat_ID from dbo.Patient p where p.PatMRN = 129)
set @DublinPt7_ID = (select p.Pat_ID from dbo.Patient p where p.PatMRN = 130)
set @DublinPt8_ID = (select p.Pat_ID from dbo.Patient p where p.PatMRN = 131)

--create episodes for all these patients
declare @DublinPt1_Ep as int
declare @DublinPt2_Ep as int
declare @DublinPt3_Ep as int
declare @DublinPt4_Ep as int
declare @DublinPt5_Ep as int
declare @DublinPt6_Ep as int
declare @DublinPt7_Ep as int
declare @DublinPt8_Ep as int
-- make dublin and wicklow general surgery and orthopaedic surgery
--
insert  into dbo.Episode
	(Pat_ID,Diag_ID,StartDT,EndDT,DTStamp)
values
	(@DublinPt1_ID,@Appendicitis_ID,@startDateTime,'2500-01-01',GETDATE()),
	(@DublinPt2_ID,@Appendicitis_ID,@startDateTime,'2500-01-01',GETDATE()),
	(@DublinPt3_ID,@Tonsillectomy_ID,@startDateTime,'2500-01-01',GETDATE()),
	(@DublinPt4_ID,@Tonsillectomy_ID,@startDateTime,'2500-01-01',GETDATE()),
	(@DublinPt5_ID,@FractureFemur_ID,@startDateTime,'2500-01-01',GETDATE()),
	(@DublinPt6_ID,@FractureFemur_ID,@startDateTime,'2500-01-01',GETDATE()),
	(@DublinPt7_ID,@Choleycystitis_ID,@startDateTime,'2500-01-01',GETDATE()),
	(@DublinPt8_ID,@Choleycystitis_ID,@startDateTime,'2500-01-01',GETDATE())

--return the episodes and enter the episode moves - these are the first locations of the patient in this episode
-- at this stage everything is new so we know we will only return one record - the one we've just entered
set @DublinPt1_Ep = (select e.Episode_ID from dbo.Episode e where e.Pat_ID = @DublinPt1_ID and e.Diag_ID = @Appendicitis_ID)
set @DublinPt2_Ep = (select e.Episode_ID from dbo.Episode e where e.Pat_ID = @DublinPt2_ID and e.Diag_ID = @Appendicitis_ID)
set @DublinPt3_Ep = (select e.Episode_ID from dbo.Episode e where e.Pat_ID = @DublinPt3_ID and e.Diag_ID = @Tonsillectomy_ID)
set @DublinPt4_Ep = (select e.Episode_ID from dbo.Episode e where e.Pat_ID = @DublinPt4_ID and e.Diag_ID = @Tonsillectomy_ID)
set @DublinPt5_Ep = (select e.Episode_ID from dbo.Episode e where e.Pat_ID = @DublinPt5_ID and e.Diag_ID = @FractureFemur_ID)
set @DublinPt6_Ep = (select e.Episode_ID from dbo.Episode e where e.Pat_ID = @DublinPt6_ID and e.Diag_ID = @FractureFemur_ID)
set @DublinPt7_Ep = (select e.Episode_ID from dbo.Episode e where e.Pat_ID = @DublinPt7_ID and e.Diag_ID = @Choleycystitis_ID)
set @DublinPt8_Ep = (select e.Episode_ID from dbo.Episode e where e.Pat_ID = @DublinPt8_ID and e.Diag_ID = @Choleycystitis_ID)

--enter the first episode move for 10 of these, episodes for 10 only, keep the other two spare
--insert some episode moves for these
insert into dbo.EpisodeMove
	(Episode_ID,Bed_ID,EpStatus,StartDT,EndDT,DTStamp)
values
	(@DublinPt1_Ep,@DublinBed1_ID,@adm_ID,@startDateTime,'2500-01-01',GETDATE()),	
	(@DublinPt2_Ep,@DublinBed2_ID,@adm_ID,@startDateTime,'2500-01-01',GETDATE()),
	(@DublinPt3_Ep,@DublinBed3_ID,@adm_ID,@startDateTime,'2500-01-01',GETDATE()),
	(@DublinPt4_Ep,@DublinBed4_ID,@adm_ID,@startDateTime,'2500-01-01',GETDATE()),
	(@DublinPt5_Ep,@DublinBed5_ID,@adm_ID,@startDateTime,'2500-01-01',GETDATE()),
	(@DublinPt6_Ep,@DublinBed6_ID,@adm_ID,@startDateTime,'2500-01-01',GETDATE()),
	(@DublinPt7_Ep,@DublinBed7_ID,@adm_ID,@startDateTime,'2500-01-01',GETDATE()),
	(@DublinPt8_Ep,@DublinBed8_ID,@adm_ID,@startDateTime,'2500-01-01',GETDATE())
--declare the episode moves
declare @DublinPt1_EpMove as int
declare @DublinPt2_EpMove as int
declare @DublinPt3_EpMove as int
declare @DublinPt4_EpMove as int
declare @DublinPt5_EpMove as int
declare @DublinPt6_EpMove as int
declare @DublinPt7_EpMove as int
declare @DublinPt8_EpMove as int

set @DublinPt1_EpMove = (select m.EpisodeMove_ID from dbo.EpisodeMove m where m.Episode_ID = @DublinPt1_Ep)
set @DublinPt2_EpMove = (select m.EpisodeMove_ID from dbo.EpisodeMove m where m.Episode_ID = @DublinPt2_Ep)
set @DublinPt3_EpMove = (select m.EpisodeMove_ID from dbo.EpisodeMove m where m.Episode_ID = @DublinPt3_Ep)
set @DublinPt4_EpMove = (select m.EpisodeMove_ID from dbo.EpisodeMove m where m.Episode_ID = @DublinPt4_Ep)
set @DublinPt5_EpMove = (select m.EpisodeMove_ID from dbo.EpisodeMove m where m.Episode_ID = @DublinPt5_Ep)
set @DublinPt6_EpMove = (select m.EpisodeMove_ID from dbo.EpisodeMove m where m.Episode_ID = @DublinPt6_Ep)
set @DublinPt7_EpMove = (select m.EpisodeMove_ID from dbo.EpisodeMove m where m.Episode_ID = @DublinPt7_Ep)
set @DublinPt8_EpMove = (select m.EpisodeMove_ID from dbo.EpisodeMove m where m.Episode_ID = @DublinPt8_Ep)

--now with each of these episode moves we will call the sp to enter the default bands from startdate to end date
exec [dbo].[sp_InsertDefaultWorkForDateRange_DEV] @DublinPt1_EpMove, @startDateTime, @endDate
exec [dbo].[sp_InsertDefaultWorkForDateRange_DEV] @DublinPt2_EpMove, @startDateTime, @endDate
exec [dbo].[sp_InsertDefaultWorkForDateRange_DEV] @DublinPt3_EpMove, @startDateTime, @endDate
exec [dbo].[sp_InsertDefaultWorkForDateRange_DEV] @DublinPt4_EpMove, @startDateTime, @endDate
exec [dbo].[sp_InsertDefaultWorkForDateRange_DEV] @DublinPt5_EpMove, @startDateTime, @endDate
exec [dbo].[sp_InsertDefaultWorkForDateRange_DEV] @DublinPt6_EpMove, @startDateTime, @endDate
exec [dbo].[sp_InsertDefaultWorkForDateRange_DEV] @DublinPt7_EpMove, @startDateTime, @endDate
exec [dbo].[sp_InsertDefaultWorkForDateRange_DEV] @DublinPt8_EpMove, @startDateTime, @endDate







--wicklow
declare @WicklowPt1_ID as int
declare @WicklowPt2_ID as int
declare @WicklowPt3_ID as int
declare @WicklowPt4_ID as int

insert into dbo.Patient
	(PatFirstName,PatLastName,PatDOB,PatMRN,DTStamp)
values
	('WicklowPt1','WicklowPt1','1950-01-01', 136, GETDATE()),
	('WicklowPt2','WicklowPt2','1978-01-01',137, GETDATE()),
	('WicklowPt3','WicklowPt3','1945-01-01',138, GETDATE()),
	('WicklowPt4','WicklowPt4','1976-01-01',139, GETDATE())

--return the IDs for use later
set @WicklowPt1_ID = (select p.Pat_ID from dbo.Patient p where p.PatMRN = 136)
set @WicklowPt2_ID = (select p.Pat_ID from dbo.Patient p where p.PatMRN = 137)
set @WicklowPt3_ID = (select p.Pat_ID from dbo.Patient p where p.PatMRN = 138)
set @WicklowPt4_ID = (select p.Pat_ID from dbo.Patient p where p.PatMRN = 139)

--create episodes for all these patients
declare @WicklowPt1_Ep as int
declare @WicklowPt2_Ep as int
declare @WicklowPt3_Ep as int
declare @WicklowPt4_Ep as int

insert  into dbo.Episode
	(Pat_ID,Diag_ID,StartDT,EndDT,DTStamp)
values
	(@WicklowPt1_ID,@Tonsillectomy_ID,@startDateTime,'2500-01-01',GETDATE()),
	(@WicklowPt2_ID,@Tonsillectomy_ID,@startDateTime,'2500-01-01',GETDATE()),
	(@WicklowPt3_ID,@DislocatedShoulder_ID,@startDateTime,'2500-01-01',GETDATE()),
	(@WicklowPt4_ID,@DislocatedShoulder_ID,@startDateTime,'2500-01-01',GETDATE())

--return the episodes and enter the episode moves - these are the first locations of the patient in this episode
-- at this stage everything is new so we know we will only return one record - the one we've just entered
set @WicklowPt1_Ep = (select e.Episode_ID from dbo.Episode e where e.Pat_ID = @WicklowPt1_ID and e.Diag_ID = @Tonsillectomy_ID)
set @WicklowPt2_Ep = (select e.Episode_ID from dbo.Episode e where e.Pat_ID = @WicklowPt2_ID and e.Diag_ID = @Tonsillectomy_ID)
set @WicklowPt3_Ep = (select e.Episode_ID from dbo.Episode e where e.Pat_ID = @WicklowPt3_ID and e.Diag_ID = @DislocatedShoulder_ID)
set @WicklowPt4_Ep = (select e.Episode_ID from dbo.Episode e where e.Pat_ID = @WicklowPt4_ID and e.Diag_ID = @DislocatedShoulder_ID)

--enter the first episode move for 10 of these, episodes for 10 only, keep the other two spare
--insert some episode moves for these
insert into dbo.EpisodeMove
	(Episode_ID,Bed_ID,EpStatus,StartDT,EndDT,DTStamp)
values
	(@WicklowPt1_Ep,@WicklowBed1_ID,@adm_ID,@startDateTime,'2500-01-01',GETDATE()),	
	(@WicklowPt2_Ep,@WicklowBed2_ID,@adm_ID,@startDateTime,'2500-01-01',GETDATE()),
	(@WicklowPt3_Ep,@WicklowBed3_ID,@adm_ID,@startDateTime,'2500-01-01',GETDATE()),
	(@WicklowPt4_Ep,@WicklowBed4_ID,@adm_ID,@startDateTime,'2500-01-01',GETDATE())

--declare the episode moves
declare @WicklowPt1_EpMove as int
declare @WicklowPt2_EpMove as int
declare @WicklowPt3_EpMove as int
declare @WicklowPt4_EpMove as int

set @WicklowPt1_EpMove = (select m.EpisodeMove_ID from dbo.EpisodeMove m where m.Episode_ID = @WicklowPt1_Ep)
set @WicklowPt2_EpMove = (select m.EpisodeMove_ID from dbo.EpisodeMove m where m.Episode_ID = @WicklowPt2_Ep)
set @WicklowPt3_EpMove = (select m.EpisodeMove_ID from dbo.EpisodeMove m where m.Episode_ID = @WicklowPt3_Ep)
set @WicklowPt4_EpMove = (select m.EpisodeMove_ID from dbo.EpisodeMove m where m.Episode_ID = @WicklowPt4_Ep)

--now with each of these episode moves we will call the sp to enter the default bands from startdate to end date
exec [dbo].[sp_InsertDefaultWorkForDateRange_DEV] @WicklowPt1_EpMove, @startDateTime, @endDate
exec [dbo].[sp_InsertDefaultWorkForDateRange_DEV] @WicklowPt2_EpMove, @startDateTime, @endDate
exec [dbo].[sp_InsertDefaultWorkForDateRange_DEV] @WicklowPt3_EpMove, @startDateTime, @endDate
exec [dbo].[sp_InsertDefaultWorkForDateRange_DEV] @WicklowPt4_EpMove, @startDateTime, @endDate






--waterford
declare @WaterfordPt1_ID as int
declare @WaterfordPt2_ID as int
declare @WaterfordPt3_ID as int
declare @WaterfordPt4_ID as int

insert into dbo.Patient
	(PatFirstName,PatLastName,PatDOB,PatMRN,DTStamp)
values
	('WaterfordPt1','WaterfordPt1','1950-01-01', 148, GETDATE()),
	('WaterfordPt2','WaterfordPt2','1978-01-01',149, GETDATE()),
	('WaterfordPt3','WaterfordPt3','1945-01-01',150, GETDATE()),
	('WaterfordPt4','WaterfordPt4','1976-01-01',151, GETDATE())


--return the IDs for use later
set @WaterfordPt1_ID = (select p.Pat_ID from dbo.Patient p where p.PatMRN = 148)
set @WaterfordPt2_ID = (select p.Pat_ID from dbo.Patient p where p.PatMRN = 149)
set @WaterfordPt3_ID = (select p.Pat_ID from dbo.Patient p where p.PatMRN = 150)
set @WaterfordPt4_ID = (select p.Pat_ID from dbo.Patient p where p.PatMRN = 151)

--create episodes for all these patients
declare @WaterfordPt1_Ep as int
declare @WaterfordPt2_Ep as int
declare @WaterfordPt3_Ep as int
declare @WaterfordPt4_Ep as int
--waterford and cork are for treating eyes
insert  into dbo.Episode
	(Pat_ID,Diag_ID,StartDT,EndDT,DTStamp)
values
	(@WaterfordPt1_ID,@Cataracts_ID,@startDateTime,'2500-01-01',GETDATE()),
	(@WaterfordPt2_ID,@Cataracts_ID,@startDateTime,'2500-01-01',GETDATE()),
	(@WaterfordPt3_ID,@Glaucoma_ID,@startDateTime,'2500-01-01',GETDATE()),
	(@WaterfordPt4_ID,@Glaucoma_ID,@startDateTime,'2500-01-01',GETDATE())

--return the episodes and enter the episode moves - these are the first locations of the patient in this episode
-- at this stage everything is new so we know we will only return one record - the one we've just entered
set @WaterfordPt1_Ep = (select e.Episode_ID from dbo.Episode e where e.Pat_ID = @WaterfordPt1_ID and e.Diag_ID = @Cataracts_ID)
set @WaterfordPt2_Ep = (select e.Episode_ID from dbo.Episode e where e.Pat_ID = @WaterfordPt2_ID and e.Diag_ID = @Cataracts_ID)
set @WaterfordPt3_Ep = (select e.Episode_ID from dbo.Episode e where e.Pat_ID = @WaterfordPt3_ID and e.Diag_ID = @Glaucoma_ID)
set @WaterfordPt4_Ep = (select e.Episode_ID from dbo.Episode e where e.Pat_ID = @WaterfordPt4_ID and e.Diag_ID = @Glaucoma_ID)

--enter the first episode move for 10 of these, episodes for 10 only, keep the other two spare
--insert some episode moves for these
insert into dbo.EpisodeMove
	(Episode_ID,Bed_ID,EpStatus,StartDT,EndDT,DTStamp)
values
	(@WaterfordPt1_Ep,@WaterfordBed1_ID,@adm_ID,@startDateTime,'2500-01-01',GETDATE()),	
	(@WaterfordPt2_Ep,@WaterfordBed2_ID,@adm_ID,@startDateTime,'2500-01-01',GETDATE()),
	(@WaterfordPt3_Ep,@WaterfordBed3_ID,@adm_ID,@startDateTime,'2500-01-01',GETDATE()),
	(@WaterfordPt4_Ep,@WaterfordBed4_ID,@adm_ID,@startDateTime,'2500-01-01',GETDATE())

--declare the episode moves
declare @WaterfordPt1_EpMove as int
declare @WaterfordPt2_EpMove as int
declare @WaterfordPt3_EpMove as int
declare @WaterfordPt4_EpMove as int

set @WaterfordPt1_EpMove = (select m.EpisodeMove_ID from dbo.EpisodeMove m where m.Episode_ID = @WaterfordPt1_Ep)
set @WaterfordPt2_EpMove = (select m.EpisodeMove_ID from dbo.EpisodeMove m where m.Episode_ID = @WaterfordPt2_Ep)
set @WaterfordPt3_EpMove = (select m.EpisodeMove_ID from dbo.EpisodeMove m where m.Episode_ID = @WaterfordPt3_Ep)
set @WaterfordPt4_EpMove = (select m.EpisodeMove_ID from dbo.EpisodeMove m where m.Episode_ID = @WaterfordPt4_Ep)

--now with each of these episode moves we will call the sp to enter the default bands from startdate to end date
exec [dbo].[sp_InsertDefaultWorkForDateRange_DEV] @WaterfordPt1_EpMove, @startDateTime, @endDate
exec [dbo].[sp_InsertDefaultWorkForDateRange_DEV] @WaterfordPt2_EpMove, @startDateTime, @endDate
exec [dbo].[sp_InsertDefaultWorkForDateRange_DEV] @WaterfordPt3_EpMove, @startDateTime, @endDate
exec [dbo].[sp_InsertDefaultWorkForDateRange_DEV] @WaterfordPt4_EpMove, @startDateTime, @endDate



--cork
declare @CorkPt1_ID as int
declare @CorkPt2_ID as int

insert into dbo.Patient
	(PatFirstName,PatLastName,PatDOB,PatMRN,DTStamp)
values
	('CorkPt1','CorkPt1','1950-01-01', 160, GETDATE()),
	('CorkPt2','CorkPt2','1978-01-01',161, GETDATE())


--return the IDs for use later
set @CorkPt1_ID = (select p.Pat_ID from dbo.Patient p where p.PatMRN = 160)
set @CorkPt2_ID = (select p.Pat_ID from dbo.Patient p where p.PatMRN = 161)

--create episodes for all these patients
declare @CorkPt1_Ep as int
declare @CorkPt2_Ep as int

-- cork is also an eye ward, but we are having one patient with diabetes
insert  into dbo.Episode
	(Pat_ID,Diag_ID,StartDT,EndDT,DTStamp)
values
	(@CorkPt1_ID,@Cataracts_ID,@startDateTime,'2500-01-01',GETDATE()),
	(@CorkPt2_ID,@Cataracts_ID,@startDateTime,'2500-01-01',GETDATE())

--return the episodes and enter the episode moves - these are the first locations of the patient in this episode
-- at this stage everything is new so we know we will only return one record - the one we've just entered
set @CorkPt1_Ep = (select e.Episode_ID from dbo.Episode e where e.Pat_ID = @CorkPt1_ID and e.Diag_ID = @Cataracts_ID)
set @CorkPt2_Ep = (select e.Episode_ID from dbo.Episode e where e.Pat_ID = @CorkPt2_ID and e.Diag_ID = @Cataracts_ID)

--enter the first episode move for 10 of these, episodes for 10 only, keep the other two spare
--insert some episode moves for these
insert into dbo.EpisodeMove
	(Episode_ID,Bed_ID,EpStatus,StartDT,EndDT,DTStamp)
values
	(@CorkPt1_Ep,@CorkBed1_ID,@adm_ID,@startDateTime,'2500-01-01',GETDATE()),	
	(@CorkPt2_Ep,@CorkBed2_ID,@adm_ID,@startDateTime,'2500-01-01',GETDATE())
--declare the episode moves
declare @CorkPt1_EpMove as int
declare @CorkPt2_EpMove as int

set @CorkPt1_EpMove = (select m.EpisodeMove_ID from dbo.EpisodeMove m where m.Episode_ID = @CorkPt1_Ep)
set @CorkPt2_EpMove = (select m.EpisodeMove_ID from dbo.EpisodeMove m where m.Episode_ID = @CorkPt2_Ep)

--now with each of these episode moves we will call the sp to enter the default bands from startdate to end date
exec [dbo].[sp_InsertDefaultWorkForDateRange_DEV] @CorkPt1_EpMove, @startDateTime, @endDate
exec [dbo].[sp_InsertDefaultWorkForDateRange_DEV] @CorkPt2_EpMove, @startDateTime, @endDate


/*
if everything has gone ok, we now have 8 new patients in Sligo ward, 8 in Dublin, 4 in Wicklow, 4 in Waterford, 2 in Cork

they all have have an episode move starting on 1st Feb and never ending

we have given them the default work for every shift in every day in the date range

We will use a different sp , sp_UpdateWorkForDateRange_DEV,  to make some changes to those default values so they are not all the same


*/





/* below here we will use sp_UpdateWorkForDatRange_DEV to add a bit more variety to the work inserts 
so that the graphs can display some more meaningful data */





--SELECT * FROM Work WHERE EpisodeMove_ID = 1 AND WorkShiftDate = '2021-02-01'
--exec sp_UpdateWorkForDateRange_DEV 1, '2021-02-01', '2021-02-01', 1, 2, 1, 0
-- 9-16 ep move for dub ward
-- 1 2 3 8 9 10 work task
-- staff ID 22 = StdN1

exec sp_UpdateWorkForDateRangeDayOfWeek_DEV 22, 9, '2021-02-01', '2021-05-31', 1, 3, 0, 0, 0, 0, 1, 1, 1, 1, 0
exec sp_UpdateWorkForDateRangeDayOfWeek_DEV 22, 9, '2021-02-01', '2021-05-31', 2, 6, 0, 0, 0, 0, 1, 1, 1, 1, 0
exec sp_UpdateWorkForDateRangeDayOfWeek_DEV 22, 9, '2021-02-01', '2021-05-31', 3, 10, 0, 0, 0, 0, 1, 1, 1, 1, 0
exec sp_UpdateWorkForDateRangeDayOfWeek_DEV 22, 9, '2021-02-01', '2021-05-31', 8, 28, 0, 0, 0, 0, 1, 1, 1, 1, 0
exec sp_UpdateWorkForDateRangeDayOfWeek_DEV 22, 9, '2021-02-01', '2021-05-31', 9, 32, 0, 0, 0, 0, 1, 1, 1, 1, 0
exec sp_UpdateWorkForDateRangeDayOfWeek_DEV 22, 9, '2021-02-01', '2021-05-31', 10, 36, 0, 0, 0, 0, 1, 1, 1, 1, 0

exec sp_UpdateWorkForDateRangeDayOfWeek_DEV 22, 10, '2021-02-01', '2021-05-31', 1, 3, 0, 0, 0, 0, 1, 1, 1, 1, 0
exec sp_UpdateWorkForDateRangeDayOfWeek_DEV 22, 10, '2021-02-01', '2021-05-31', 2, 6, 0, 0, 0, 0, 1, 1, 1, 1, 0
exec sp_UpdateWorkForDateRangeDayOfWeek_DEV 22, 10, '2021-02-01', '2021-05-31', 3, 10, 0, 0, 0, 0, 1, 1, 1, 1, 0
exec sp_UpdateWorkForDateRangeDayOfWeek_DEV 22, 10, '2021-02-01', '2021-05-31', 8, 28, 0, 0, 0, 0, 1, 1, 1, 1, 0
exec sp_UpdateWorkForDateRangeDayOfWeek_DEV 22, 10, '2021-02-01', '2021-05-31', 9, 32, 0, 0, 0, 0, 1, 1, 1, 1, 0
exec sp_UpdateWorkForDateRangeDayOfWeek_DEV 22, 10, '2021-02-01', '2021-05-31', 10, 36, 0, 0, 0, 0, 1, 1, 1, 1, 0

exec sp_UpdateWorkForDateRangeDayOfWeek_DEV 22, 11, '2021-02-01', '2021-05-31', 1, 3, 0, 0, 0, 0, 1, 1, 1, 1, 0
exec sp_UpdateWorkForDateRangeDayOfWeek_DEV 22, 11, '2021-02-01', '2021-05-31', 2, 6, 0, 0, 0, 0, 1, 1, 1, 1, 0
exec sp_UpdateWorkForDateRangeDayOfWeek_DEV 22, 11, '2021-02-01', '2021-05-31', 3, 10, 0, 0, 0, 0, 1, 1, 1, 1, 0
exec sp_UpdateWorkForDateRangeDayOfWeek_DEV 22, 11, '2021-02-01', '2021-05-31', 8, 28, 0, 0, 0, 0, 1, 1, 1, 1, 0
exec sp_UpdateWorkForDateRangeDayOfWeek_DEV 22, 11, '2021-02-01', '2021-05-31', 9, 32, 0, 0, 0, 0, 1, 1, 1, 1, 0
exec sp_UpdateWorkForDateRangeDayOfWeek_DEV 22, 11, '2021-02-01', '2021-05-31', 10, 36, 0, 0, 0, 0, 1, 1, 1, 1, 0

exec sp_UpdateWorkForDateRangeDayOfWeek_DEV 22, 12, '2021-02-01', '2021-05-31', 1, 3, 0, 0, 0, 0, 1, 1, 1, 1, 0
exec sp_UpdateWorkForDateRangeDayOfWeek_DEV 22, 12, '2021-02-01', '2021-05-31', 2, 6, 0, 0, 0, 0, 1, 1, 1, 1, 0
exec sp_UpdateWorkForDateRangeDayOfWeek_DEV 22, 12, '2021-02-01', '2021-05-31', 3, 10, 0, 0, 0, 0, 1, 1, 1, 1, 0
exec sp_UpdateWorkForDateRangeDayOfWeek_DEV 22, 12, '2021-02-01', '2021-05-31', 8, 28, 0, 0, 0, 0, 1, 1, 1, 1, 0
exec sp_UpdateWorkForDateRangeDayOfWeek_DEV 22, 12, '2021-02-01', '2021-05-31', 9, 32, 0, 0, 0, 0, 1, 1, 1, 1, 0
exec sp_UpdateWorkForDateRangeDayOfWeek_DEV 22, 12, '2021-02-01', '2021-05-31', 10, 36, 0, 0, 0, 0, 1, 1, 1, 1, 0

exec sp_UpdateWorkForDateRangeDayOfWeek_DEV 22, 13, '2021-02-01', '2021-05-31', 1, 3, 0, 0, 0, 0, 1, 1, 1, 1, 0
exec sp_UpdateWorkForDateRangeDayOfWeek_DEV 22, 13, '2021-02-01', '2021-05-31', 2, 6, 0, 0, 0, 0, 1, 1, 1, 1, 0
exec sp_UpdateWorkForDateRangeDayOfWeek_DEV 22, 13, '2021-02-01', '2021-05-31', 3, 10, 0, 0, 0, 0, 1, 1, 1, 1, 0
exec sp_UpdateWorkForDateRangeDayOfWeek_DEV 22, 13, '2021-02-01', '2021-05-31', 8, 28, 0, 0, 0, 0, 1, 1, 1, 1, 0
exec sp_UpdateWorkForDateRangeDayOfWeek_DEV 22, 13, '2021-02-01', '2021-05-31', 9, 32, 0, 0, 0, 0, 1, 1, 1, 1, 0
exec sp_UpdateWorkForDateRangeDayOfWeek_DEV 22, 13, '2021-02-01', '2021-05-31', 10, 36, 0, 0, 0, 0, 1, 1, 1, 1, 0

exec sp_UpdateWorkForDateRangeDayOfWeek_DEV 22, 14, '2021-02-01', '2021-05-31', 1, 3, 0, 0, 0, 0, 1, 1, 1, 1, 0
exec sp_UpdateWorkForDateRangeDayOfWeek_DEV 22, 14, '2021-02-01', '2021-05-31', 2, 6, 0, 0, 0, 0, 1, 1, 1, 1, 0
exec sp_UpdateWorkForDateRangeDayOfWeek_DEV 22, 14, '2021-02-01', '2021-05-31', 3, 10, 0, 0, 0, 0, 1, 1, 1, 1, 0
exec sp_UpdateWorkForDateRangeDayOfWeek_DEV 22, 14, '2021-02-01', '2021-05-31', 8, 28, 0, 0, 0, 0, 1, 1, 1, 1, 0
exec sp_UpdateWorkForDateRangeDayOfWeek_DEV 22, 14, '2021-02-01', '2021-05-31', 9, 32, 0, 0, 0, 0, 1, 1, 1, 1, 0
exec sp_UpdateWorkForDateRangeDayOfWeek_DEV 22, 14, '2021-02-01', '2021-05-31', 10, 36, 0, 0, 0, 0, 1, 1, 1, 1, 0

exec sp_UpdateWorkForDateRangeDayOfWeek_DEV 22, 15, '2021-02-01', '2021-05-31', 1, 3, 0, 0, 0, 0, 1, 1, 1, 1, 0
exec sp_UpdateWorkForDateRangeDayOfWeek_DEV 22, 15, '2021-02-01', '2021-05-31', 2, 6, 0, 0, 0, 0, 1, 1, 1, 1, 0
exec sp_UpdateWorkForDateRangeDayOfWeek_DEV 22, 15, '2021-02-01', '2021-05-31', 3, 10, 0, 0, 0, 0, 1, 1, 1, 1, 0
exec sp_UpdateWorkForDateRangeDayOfWeek_DEV 22, 15, '2021-02-01', '2021-05-31', 8, 28, 0, 0, 0, 0, 1, 1, 1, 1, 0
exec sp_UpdateWorkForDateRangeDayOfWeek_DEV 22, 15, '2021-02-01', '2021-05-31', 9, 32, 0, 0, 0, 0, 1, 1, 1, 1, 0
exec sp_UpdateWorkForDateRangeDayOfWeek_DEV 22, 15, '2021-02-01', '2021-05-31', 10, 36, 0, 0, 0, 0, 1, 1, 1, 1, 0

exec sp_UpdateWorkForDateRangeDayOfWeek_DEV 22, 16, '2021-02-01', '2021-05-31', 1, 3, 0, 0, 0, 0, 1, 1, 1, 1, 0
exec sp_UpdateWorkForDateRangeDayOfWeek_DEV 22, 16, '2021-02-01', '2021-05-31', 2, 6, 0, 0, 0, 0, 1, 1, 1, 1, 0
exec sp_UpdateWorkForDateRangeDayOfWeek_DEV 22, 16, '2021-02-01', '2021-05-31', 3, 10, 0, 0, 0, 0, 1, 1, 1, 1, 0
exec sp_UpdateWorkForDateRangeDayOfWeek_DEV 22, 16, '2021-02-01', '2021-05-31', 8, 28, 0, 0, 0, 0, 1, 1, 1, 1, 0
exec sp_UpdateWorkForDateRangeDayOfWeek_DEV 22, 16, '2021-02-01', '2021-05-31', 9, 32, 0, 0, 0, 0, 1, 1, 1, 1, 0
exec sp_UpdateWorkForDateRangeDayOfWeek_DEV 22, 16, '2021-02-01', '2021-05-31', 10, 36, 0, 0, 0, 0, 1, 1, 1, 1, 0

-- above is Mon-Thurs Dublin patients getting small band 0.2 on all 6 takss for every hsift of every day
-- below is Fri Sat Sun Dublin patients getting large band 1 on all 6 tasks for mornign shift

exec sp_UpdateWorkForDateRangeDayOfWeek_DEV 52, 9, '2021-02-01', '2021-05-31', 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 1
exec sp_UpdateWorkForDateRangeDayOfWeek_DEV 52, 9, '2021-02-01', '2021-05-31', 2, 7, 1, 1, 1, 1, 0, 0, 0, 0, 1
exec sp_UpdateWorkForDateRangeDayOfWeek_DEV 52, 9, '2021-02-01', '2021-05-31', 3, 8, 1, 1, 1, 1, 0, 0, 0, 0, 1
exec sp_UpdateWorkForDateRangeDayOfWeek_DEV 52, 9, '2021-02-01', '2021-05-31', 8, 29, 1, 1, 1, 1, 0, 0, 0, 0, 1
exec sp_UpdateWorkForDateRangeDayOfWeek_DEV 52, 9, '2021-02-01', '2021-05-31', 9, 33, 1, 1, 1, 1, 0, 0, 0, 0, 1
exec sp_UpdateWorkForDateRangeDayOfWeek_DEV 52, 9, '2021-02-01', '2021-05-31', 10, 37, 1, 1, 1, 1, 0, 0, 0, 0, 1

exec sp_UpdateWorkForDateRangeDayOfWeek_DEV 52, 10, '2021-02-01', '2021-05-31', 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 1
exec sp_UpdateWorkForDateRangeDayOfWeek_DEV 52, 10, '2021-02-01', '2021-05-31', 2, 7, 1, 1, 1, 1, 0, 0, 0, 0, 1
exec sp_UpdateWorkForDateRangeDayOfWeek_DEV 52, 10, '2021-02-01', '2021-05-31', 3, 8, 1, 1, 1, 1, 0, 0, 0, 0, 1
exec sp_UpdateWorkForDateRangeDayOfWeek_DEV 52, 10, '2021-02-01', '2021-05-31', 8, 29, 1, 1, 1, 1, 0, 0, 0, 0, 1
exec sp_UpdateWorkForDateRangeDayOfWeek_DEV 52, 10, '2021-02-01', '2021-05-31', 9, 33, 1, 1, 1, 1, 0, 0, 0, 0, 1
exec sp_UpdateWorkForDateRangeDayOfWeek_DEV 52, 10, '2021-02-01', '2021-05-31', 10, 37, 1, 1, 1, 1, 0, 0, 0, 0, 1

exec sp_UpdateWorkForDateRangeDayOfWeek_DEV 52, 11, '2021-02-01', '2021-05-31', 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 1
exec sp_UpdateWorkForDateRangeDayOfWeek_DEV 52, 11, '2021-02-01', '2021-05-31', 2, 7, 1, 1, 1, 1, 0, 0, 0, 0, 1
exec sp_UpdateWorkForDateRangeDayOfWeek_DEV 52, 11, '2021-02-01', '2021-05-31', 3, 8, 1, 1, 1, 1, 0, 0, 0, 0, 1
exec sp_UpdateWorkForDateRangeDayOfWeek_DEV 52, 11, '2021-02-01', '2021-05-31', 8, 29, 1, 1, 1, 1, 0, 0, 0, 0, 1
exec sp_UpdateWorkForDateRangeDayOfWeek_DEV 52, 11, '2021-02-01', '2021-05-31', 9, 33, 1, 1, 1, 1, 0, 0, 0, 0, 1
exec sp_UpdateWorkForDateRangeDayOfWeek_DEV 52, 11, '2021-02-01', '2021-05-31', 10, 37, 1, 1, 1, 1, 0, 0, 0, 0, 1

exec sp_UpdateWorkForDateRangeDayOfWeek_DEV 52, 12, '2021-02-01', '2021-05-31', 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 1
exec sp_UpdateWorkForDateRangeDayOfWeek_DEV 52, 12, '2021-02-01', '2021-05-31', 2, 7, 1, 1, 1, 1, 0, 0, 0, 0, 1
exec sp_UpdateWorkForDateRangeDayOfWeek_DEV 52, 12, '2021-02-01', '2021-05-31', 3, 8, 1, 1, 1, 1, 0, 0, 0, 0, 1
exec sp_UpdateWorkForDateRangeDayOfWeek_DEV 52, 12, '2021-02-01', '2021-05-31', 8, 29, 1, 1, 1, 1, 0, 0, 0, 0, 1
exec sp_UpdateWorkForDateRangeDayOfWeek_DEV 52, 12, '2021-02-01', '2021-05-31', 9, 33, 1, 1, 1, 1, 0, 0, 0, 0, 1
exec sp_UpdateWorkForDateRangeDayOfWeek_DEV 52, 12, '2021-02-01', '2021-05-31', 10, 37, 1, 1, 1, 1, 0, 0, 0, 0, 1

exec sp_UpdateWorkForDateRangeDayOfWeek_DEV 52, 13, '2021-02-01', '2021-05-31', 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 1
exec sp_UpdateWorkForDateRangeDayOfWeek_DEV 52, 13, '2021-02-01', '2021-05-31', 2, 7, 1, 1, 1, 1, 0, 0, 0, 0, 1
exec sp_UpdateWorkForDateRangeDayOfWeek_DEV 52, 13, '2021-02-01', '2021-05-31', 3, 8, 1, 1, 1, 1, 0, 0, 0, 0, 1
exec sp_UpdateWorkForDateRangeDayOfWeek_DEV 52, 13, '2021-02-01', '2021-05-31', 8, 29, 1, 1, 1, 1, 0, 0, 0, 0, 1
exec sp_UpdateWorkForDateRangeDayOfWeek_DEV 52, 13, '2021-02-01', '2021-05-31', 9, 33, 1, 1, 1, 1, 0, 0, 0, 0, 1
exec sp_UpdateWorkForDateRangeDayOfWeek_DEV 52, 13, '2021-02-01', '2021-05-31', 10, 37, 1, 1, 1, 1, 0, 0, 0, 0, 1

exec sp_UpdateWorkForDateRangeDayOfWeek_DEV 52, 14, '2021-02-01', '2021-05-31', 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 1
exec sp_UpdateWorkForDateRangeDayOfWeek_DEV 52, 14, '2021-02-01', '2021-05-31', 2, 7, 1, 1, 1, 1, 0, 0, 0, 0, 1
exec sp_UpdateWorkForDateRangeDayOfWeek_DEV 52, 14, '2021-02-01', '2021-05-31', 3, 8, 1, 1, 1, 1, 0, 0, 0, 0, 1
exec sp_UpdateWorkForDateRangeDayOfWeek_DEV 52, 14, '2021-02-01', '2021-05-31', 8, 29, 1, 1, 1, 1, 0, 0, 0, 0, 1
exec sp_UpdateWorkForDateRangeDayOfWeek_DEV 52, 14, '2021-02-01', '2021-05-31', 9, 33, 1, 1, 1, 1, 0, 0, 0, 0, 1
exec sp_UpdateWorkForDateRangeDayOfWeek_DEV 52, 14, '2021-02-01', '2021-05-31', 10, 37, 1, 1, 1, 1, 0, 0, 0, 0, 1

exec sp_UpdateWorkForDateRangeDayOfWeek_DEV 52, 15, '2021-02-01', '2021-05-31', 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 1
exec sp_UpdateWorkForDateRangeDayOfWeek_DEV 52, 15, '2021-02-01', '2021-05-31', 2, 7, 1, 1, 1, 1, 0, 0, 0, 0, 1
exec sp_UpdateWorkForDateRangeDayOfWeek_DEV 52, 15, '2021-02-01', '2021-05-31', 3, 8, 1, 1, 1, 1, 0, 0, 0, 0, 1
exec sp_UpdateWorkForDateRangeDayOfWeek_DEV 52, 15, '2021-02-01', '2021-05-31', 8, 29, 1, 1, 1, 1, 0, 0, 0, 0, 1
exec sp_UpdateWorkForDateRangeDayOfWeek_DEV 52, 15, '2021-02-01', '2021-05-31', 9, 33, 1, 1, 1, 1, 0, 0, 0, 0, 1
exec sp_UpdateWorkForDateRangeDayOfWeek_DEV 52, 15, '2021-02-01', '2021-05-31', 10, 37, 1, 1, 1, 1, 0, 0, 0, 0, 1

exec sp_UpdateWorkForDateRangeDayOfWeek_DEV 52, 16, '2021-02-01', '2021-05-31', 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 1
exec sp_UpdateWorkForDateRangeDayOfWeek_DEV 52, 16, '2021-02-01', '2021-05-31', 2, 7, 1, 1, 1, 1, 0, 0, 0, 0, 1
exec sp_UpdateWorkForDateRangeDayOfWeek_DEV 52, 16, '2021-02-01', '2021-05-31', 3, 8, 1, 1, 1, 1, 0, 0, 0, 0, 1
exec sp_UpdateWorkForDateRangeDayOfWeek_DEV 52, 16, '2021-02-01', '2021-05-31', 8, 29, 1, 1, 1, 1, 0, 0, 0, 0, 1
exec sp_UpdateWorkForDateRangeDayOfWeek_DEV 52, 16, '2021-02-01', '2021-05-31', 9, 33, 1, 1, 1, 1, 0, 0, 0, 0, 1
exec sp_UpdateWorkForDateRangeDayOfWeek_DEV 52, 16, '2021-02-01', '2021-05-31', 10, 37, 1, 1, 1, 1, 0, 0, 0, 0, 1


/*
@Staff_ID int, @EpisodeMove_ID int,	@startDate as date, @endDate as date, @WorkTask_ID as int, @TaskBand_ID as int, 
@Mon as int, @Tue as int, @Wed as int, @Thu as int, @Fri as int, @Sat as int, @Sun as int,
@allShifts as tinyint, @WorkShift_ID as int = 0
*/

