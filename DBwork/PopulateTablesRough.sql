-- Ep Statu sgiving errors bc my tables dont have it. need to add it back into my tables for this to run
-- insert data into Hospital own system tables
-- inserts Bed, Dep, Ep, EpMove, Hos, Par, ParG, Pat, RosShift, ShiftSeq, Spec, Staff, StaffType, Ward, WorkShift, 
-- does not insert Roster, RosterChange
-- does not insert SubModDef, SubModeDefBand, SubModTask, TaskBand, Work, WorkArch, WorkMod, WorkSubMod, WorkTask

-- code to populate lots of tables in one swoop
--ensure you run the script BulkInsert.sql first to ensure you have submodels entered
declare @subModelOneID as int
declare @subModelTwoID as int
declare @subModelThreeID as int
set @subModelOneID = (select s.WorkSubModel_ID from dbo.WorkSubModel s where s.WorkSubModelName = 'HarleySubModel')
set @subModelTwoID = (select s.WorkSubModel_ID from dbo.WorkSubModel s where s.WorkSubModelName = 'RuthieSubModel')
set @subModelThreeID = (select s.WorkSubModel_ID from dbo.WorkSubModel s where s.WorkSubModelName = 'DavidSubModel')

declare @defaultNameOneID as int
declare @defaultNameTwoID as int
declare @defaultNameThreeID as int
declare @defaultNameFourID as int
declare @defaultNameFiveID as int
declare @defaultNameSixID as int

set @defaultNameOneID = (select d.SubModelDefault_ID from dbo.SubModelDefault d where d.SubModelDefaultName = 'HarleyDefaultOne')
set @defaultNameTwoID = (select d.SubModelDefault_ID from dbo.SubModelDefault d where d.SubModelDefaultName = 'HarleyDefaultTwo')
set @defaultNameThreeID = (select d.SubModelDefault_ID from dbo.SubModelDefault d where d.SubModelDefaultName = 'RuthieDefaultOne')
set @defaultNameFourID = (select d.SubModelDefault_ID from dbo.SubModelDefault d where d.SubModelDefaultName = 'RuthieDefaultTwo')
set @defaultNameFiveID = (select d.SubModelDefault_ID from dbo.SubModelDefault d where d.SubModelDefaultName = 'DavidDefaultOne')
set @defaultNameSixID = (select d.SubModelDefault_ID from dbo.SubModelDefault d where d.SubModelDefaultName = 'DavidDefaultTwo')




------------------------------------------------------








--insert param groups

insert into dbo.ParamGroup
	(ParamGroupName,ParamGroupDescription,DTStamp)
values
	('EpisodeStatus','something about the status eg. expected in, for transfer or for home',CURRENT_TIMESTAMP)
--return the ID for use in entering the Params
declare @EpStatus_ID as int
set @EpStatus_ID = (select p.ParamGroup_ID from dbo.ParamGroup p where p.ParamGroupName = 'EpisodeStatus')


--insert some params


insert into dbo.[Param]
	(ParamGroup_ID,ParamValue,ParamDescription,DTStamp)
values
	(@EpStatus_ID,'tci','patient is expected in but has not yet physically arrived',CURRENT_TIMESTAMP),
	(@EpStatus_ID,'adm','patient is on the ward',CURRENT_TIMESTAMP),
	(@EpStatus_ID,'trans','patient is expected as a transfer from another ward but has not yet physically arrived',CURRENT_TIMESTAMP),
	(@EpStatus_ID,'disc','patient is discharged, but has not yet physically left the ward',CURRENT_TIMESTAMP)

declare @tci_ID as int
declare @adm_ID as int
declare @trans_ID as int
declare @disc_ID as int

set @tci_ID = (select p.Param_ID from dbo.[Param] p where p.ParamValue = 'tci')
set @adm_ID = (select p.Param_ID from dbo.[Param] p where p.ParamValue = 'adm')
set @trans_ID = (select p.Param_ID from dbo.[Param] p where p.ParamValue = 'trans')
set @disc_ID = (select p.Param_ID from dbo.[Param] p where p.ParamValue = 'disc')







-------------------------------------------------------------------------








-- also some archive params

insert into dbo.ParamGroup
	(ParamGroupName,ParamGroupDescription,DTStamp)
values
	('ArchiveReason','something about the archive reason, probably only two',CURRENT_TIMESTAMP)
--return the ID for use later
declare @ArchiveReason_ID as int
set @ArchiveReason_ID = (select p.ParamGroup_ID from dbo.ParamGroup p where p.ParamGroupName = 'ArchiveReason')


--and the reasons
insert into dbo.[Param]
	(ParamGroup_ID,ParamValue,ParamDescription,DTStamp)
values
	(@ArchiveReason_ID,'error','an error record gets archived and flagged as error',CURRENT_TIMESTAMP),
	(@ArchiveReason_ID,'update','an update gets archived and replaced with latest',CURRENT_TIMESTAMP)
	
declare @error_ID as int
declare @update_ID as int
set @error_ID = (select p.Param_ID from dbo.[Param] p where p.ParamValue = 'error')
set @update_ID = (select p.Param_ID from dbo.[Param] p where p.ParamValue = 'update')


------------------------------------------------------------------------------------------










--three departments
insert into [dbo].[Department]
	(DepName,DepDescription,DTStamp)
values
	('West Wing', 'Different wards in the west wing are managed here', CURRENT_TIMESTAMP),
	('East Wing', 'Different wards in the east wing are managed here', CURRENT_TIMESTAMP),
	('South Wing', 'Different wards in the south wing are managed here', CURRENT_TIMESTAMP)

DECLARE @westWing_ID as int
DECLARE @eastWing_ID as int
DECLARE @southWing_ID as int
set @westWing_ID = (select d.Dep_ID from [dbo].Department d where d.DepName = 'West Wing')
set @eastWing_ID = (select d.Dep_ID from [dbo].Department d where d.DepName = 'East Wing')
set @southWing_ID = (select d.Dep_ID from [dbo].Department d where d.DepName = 'South Wing')








-----------------------------------------------------------------------------------------------------








DELETE FROM [dbo].[Ward]
--insert a couple of wards in each department
--name the wards with counties
insert into [dbo].[Ward]
	(Dep_ID,WardName,WardDescription,WorkSubModel_ID,WorkSeq_ID,SubModelDefault_ID,DTStamp)
values
	(@westWing_ID,'Sligo','something',null,null,null, CURRENT_TIMESTAMP),
	(@eastWing_ID,'Dublin','something',null,null,null, CURRENT_TIMESTAMP), -- first null is WorkSubModel, then 2 config items
	(@eastWing_ID,'Wicklow','something',null,null,null, GETDATE()),
	(@southWing_ID,'Waterford','something',null,null,null, GETDATE()),
	(@southWing_ID,'Cork','something',null,null,null, GETDATE())


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


/*
--show all departments and their wards
select d.DepName,w.* from dbo.Ward w
INNER JOIN dbo.Department d
on w.Dep_ID = d.Dep_ID
*/







-------------------------------------------------------------------------------










--insert a few beds in each ward


insert into [dbo].[Bed]
	(Ward_ID,BedName,BedDescription,PersistStatus,OpenStatus,DTStamp)
values

	(@SligoWard_ID,'SligoBed1','something',1,1, CURRENT_TIMESTAMP),
	(@SligoWard_ID,'SligoBed2','something',1,1, CURRENT_TIMESTAMP),
	(@SligoWard_ID,'SligoBed3','something',1,1, CURRENT_TIMESTAMP),
	(@SligoWard_ID,'SligoBed4','something',1,1, CURRENT_TIMESTAMP),
	(@SligoWard_ID,'SligoBed5','something',1,1, CURRENT_TIMESTAMP),
	(@SligoWard_ID,'SligoBed6','something',1,1, CURRENT_TIMESTAMP),
	(@SligoWard_ID,'SligoBed7','something',1,1, CURRENT_TIMESTAMP),
	(@SligoWard_ID,'SligoBed8','something',1,1, CURRENT_TIMESTAMP),
	(@SligoWard_ID,'SligoBed9','something',1,1, CURRENT_TIMESTAMP),
	(@SligoWard_ID,'SligoBed10','something',1,1, CURRENT_TIMESTAMP),

	(@DublinWard_ID,'DublinBed1','something',1,1, CURRENT_TIMESTAMP),
	(@DublinWard_ID,'DublinBed2','something',1,1, CURRENT_TIMESTAMP),
	(@DublinWard_ID,'DublinBed3','something',1,1, CURRENT_TIMESTAMP),
	(@DublinWard_ID,'DublinBed4','something',1,1, CURRENT_TIMESTAMP),
	(@DublinWard_ID,'DublinBed5','something',1,1, CURRENT_TIMESTAMP),
	(@DublinWard_ID,'DublinBed6','something',1,1, CURRENT_TIMESTAMP),
	(@DublinWard_ID,'DublinBed7','something',1,1, CURRENT_TIMESTAMP),
	(@DublinWard_ID,'DublinBed8','something',1,1, CURRENT_TIMESTAMP),

	(@WicklowWard_ID,'WicklowBed1','something',1,1, GETDATE()),
	(@WicklowWard_ID,'WicklowBed2','something',1,1, GETDATE()),
	(@WicklowWard_ID,'WicklowBed3','something',1,1, GETDATE()),
	(@WicklowWard_ID,'WicklowBed4','something',1,1, GETDATE()),
	(@WicklowWard_ID,'WicklowBed5','something',1,1, GETDATE()),
	(@WicklowWard_ID,'WicklowBed6','something',1,1, GETDATE()),

	(@WaterfordWard_ID,'WaterfordBed1','something',1,1, GETDATE()),
	(@WaterfordWard_ID,'WaterfordBed2','something',1,1, GETDATE()),
	(@WaterfordWard_ID,'WaterfordBed3','something',1,1, GETDATE()),
	(@WaterfordWard_ID,'WaterfordBed4','something',1,1, GETDATE()),

	(@CorkWard_ID,'CorkBed1','something',1,1, GETDATE()),
	(@CorkWard_ID,'CorkBed2','something',1,1, GETDATE())


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











--------------------------------------------------------------------------









-- make a few specialties
insert into [dbo].[Specialty]
	(SpecName,SpecDescription,DTStamp)
values
	('General Surgery', 'Covers lots of different operations', CURRENT_TIMESTAMP),
	('Orthopaedics', 'Specifically for bones', CURRENT_TIMESTAMP),
	('Gynaecology', 'gynae surgery only', CURRENT_TIMESTAMP),
	('General Medicine', 'covers lots of different medical illnesses', CURRENT_TIMESTAMP),
	('Cardiology', 'illnesses of the heart only', CURRENT_TIMESTAMP),
	('Endocrinology', 'diabetes and other endocrine disorders', CURRENT_TIMESTAMP),
	('ENT', 'ear, nose and throat only', CURRENT_TIMESTAMP),
	('Ophthalmology', 'eyes', CURRENT_TIMESTAMP)

DECLARE @GeneralSurgery_ID as int
DECLARE @Orthopaedics_ID as int
DECLARE @Gynaecology_ID as int
DECLARE @GeneralMedicine_ID as int
DECLARE @Cardiology_ID as int
DECLARE @Endocrinology_ID as int
DECLARE @ENT_ID as int
DECLARE @Ophthalmology_ID as int
--return the IDs for use later
set @GeneralSurgery_ID = (select s.Spec_ID from [dbo].[Specialty] s where s.SpecName = 'General Surgery')
set @Orthopaedics_ID = (select s.Spec_ID from [dbo].[Specialty] s where s.SpecName = 'Orthopaedics')
set @Gynaecology_ID = (select s.Spec_ID from [dbo].[Specialty] s where s.SpecName = 'Gynaecology')
set @GeneralMedicine_ID = (select s.Spec_ID from [dbo].[Specialty] s where s.SpecName = 'General Medicine')
set @Cardiology_ID = (select s.Spec_ID from [dbo].[Specialty] s where s.SpecName = 'Cardiology')
set @Endocrinology_ID = (select s.Spec_ID from [dbo].[Specialty] s where s.SpecName = 'Endocrinology')
set @ENT_ID = (select s.Spec_ID from [dbo].[Specialty] s where s.SpecName = 'ENT')
set @Ophthalmology_ID = (select s.Spec_ID from [dbo].[Specialty] s where s.SpecName = 'Ophthalmology')










-----------------------------------------------------------------------------------------------











--for each specialty enter a few diagnoses
insert into [dbo].[Diagnosis]
	(Spec_ID,DiagnosisName,DiagnosisDescription,DTStamp)
values
	(@GeneralSurgery_ID,'Appendicitis','may need appendicectomy', CURRENT_TIMESTAMP),
	(@GeneralSurgery_ID,'Choleycystitis','may need gall bladder removed', CURRENT_TIMESTAMP),
	(@GeneralSurgery_ID,'HeadInjury','head injury', CURRENT_TIMESTAMP),
	(@Orthopaedics_ID,'FractureFemur','may need surgery', CURRENT_TIMESTAMP),
	(@Orthopaedics_ID,'DislocatedShoulder','needs to be set back', CURRENT_TIMESTAMP),
	(@Gynaecology_ID,'Hysterectomy','for hysterectomy', CURRENT_TIMESTAMP),
	(@GeneralMedicine_ID,'Pneumonia','Pneumonia', CURRENT_TIMESTAMP),
	(@GeneralMedicine_ID,'Hypertension','Hypertension', CURRENT_TIMESTAMP),
	(@Cardiology_ID,'Angina','Angina', CURRENT_TIMESTAMP),
	(@Cardiology_ID,'IrregularHeartBeat','IrregularHeartBeat', CURRENT_TIMESTAMP),
	(@Endocrinology_ID,'Diabetes','Diabetes', CURRENT_TIMESTAMP),
	(@ENT_ID,'Tonsillectomy','Tonsillectomy', CURRENT_TIMESTAMP),
	(@Ophthalmology_ID,'Cataracts','Cataract surgery', CURRENT_TIMESTAMP),
	(@Ophthalmology_ID,'Glaucoma','Glaucoma surgery', CURRENT_TIMESTAMP)

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
--and return the IDs
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







-------------------------------------------------------------------------------------------------












--enter a few work shifts
/*
[WorkShiftName]	[StartTime]	[EndTime]	[DTStamp]
M1	08:00:00	13:59:59	xx
M2	08:00:00	14:59:59	xx
M3	08:00:00	15:59:59	xx
A1	14:00:00	17:59:59	xx
A2	14:00:00	19:59:59	xx
A3	15:00:00	19:59:59	xx
A4	16:00:00	19:59:59	xx
E1	18:00:00	22:59:59	xx
D1	08:00:00	17:59:59	xx
D2	08:00:00	19:59:59	xx
N1	20:00:00	07:59:59	xx
N2	23:00:00	07:59:59	xx
N3	23:00:00	05:59:59	xx
EM1	06:00:00	07:59:59	xx

*/


insert into dbo.WorkShift 
	(WorkShiftName,StartTime,EndTime,DTStamp)
values
	('M1','08:00:00','13:59:59',CURRENT_TIMESTAMP),
	('M2','08:00:00','14:59:59',CURRENT_TIMESTAMP),
	('M3','08:00:00','15:59:59',CURRENT_TIMESTAMP),
	('A1','14:00:00','17:59:59',CURRENT_TIMESTAMP),
	('A2','14:00:00','19:59:59',CURRENT_TIMESTAMP),
	('A3','15:00:00','19:59:59',CURRENT_TIMESTAMP),
	('A4','16:00:00','19:59:59',CURRENT_TIMESTAMP),
	('E1','18:00:00','22:59:59',CURRENT_TIMESTAMP),
	('D1','08:00:00','17:59:59',CURRENT_TIMESTAMP),
	('D2','08:00:00','19:59:59',CURRENT_TIMESTAMP),
	('N1','20:00:00','07:59:59',CURRENT_TIMESTAMP),
	('N2','23:00:00','07:59:59',CURRENT_TIMESTAMP),
	('N3','23:00:00','05:59:59',CURRENT_TIMESTAMP),
	('EM1','06:00:00','07:59:59',CURRENT_TIMESTAMP)

DECLARE @M1_ID as int
DECLARE @M2_ID as int
DECLARE @M3_ID as int
DECLARE @A1_ID as int
DECLARE @A2_ID as int
DECLARE @A3_ID as int
DECLARE @A4_ID as int
DECLARE @E1_ID as int
DECLARE @D1_ID as int
DECLARE @D2_ID as int
DECLARE @N1_ID as int
DECLARE @N2_ID as int
DECLARE @N3_ID as int
DECLARE @EM1_ID as int
--return the IDs for use later
set @M1_ID = (select w.WorkShift_ID from dbo.WorkShift w where w.WorkShiftName = 'M1')
set @M2_ID = (select w.WorkShift_ID from dbo.WorkShift w where w.WorkShiftName = 'M2')
set @M3_ID = (select w.WorkShift_ID from dbo.WorkShift w where w.WorkShiftName = 'M3')
set @A1_ID = (select w.WorkShift_ID from dbo.WorkShift w where w.WorkShiftName = 'A1')
set @A2_ID = (select w.WorkShift_ID from dbo.WorkShift w where w.WorkShiftName = 'A2')
set @A3_ID = (select w.WorkShift_ID from dbo.WorkShift w where w.WorkShiftName = 'A3')
set @A4_ID = (select w.WorkShift_ID from dbo.WorkShift w where w.WorkShiftName = 'A4')
set @E1_ID = (select w.WorkShift_ID from dbo.WorkShift w where w.WorkShiftName = 'E1')
set @D1_ID = (select w.WorkShift_ID from dbo.WorkShift w where w.WorkShiftName = 'D1')
set @D2_ID = (select w.WorkShift_ID from dbo.WorkShift w where w.WorkShiftName = 'D2')
set @N1_ID = (select w.WorkShift_ID from dbo.WorkShift w where w.WorkShiftName = 'N1')
set @N2_ID = (select w.WorkShift_ID from dbo.WorkShift w where w.WorkShiftName = 'N2')
set @N3_ID = (select w.WorkShift_ID from dbo.WorkShift w where w.WorkShiftName = 'N3')
set @EM1_ID = (select w.WorkShift_ID from dbo.WorkShift w where w.WorkShiftName = 'EM1')







------------------------------------------------------------------------------------------------------











--enter a few work sequences
insert into dbo.WorkSequence 
	(WorkSeqName,WorkSeqDescription,DTStamp)
values
	('WorkSeqDN','D-N Just two work shifts - day and night',CURRENT_TIMESTAMP),
	('WorkSeqMAN','M-A-N A sequence of morning, afternoon and night workshifts',CURRENT_TIMESTAMP),
	('WorkSeqMAEN','M-A-E-N	A sequence of morning , afternoon, evening and night workshifts',CURRENT_TIMESTAMP)

DECLARE @WorkSeqDN_ID as int	--D-N	Just two work shifts - day and night
DECLARE @WorkSeqMAN_ID as int	--M-A-N	A sequence of morning, afternoon and night workshifts
DECLARE @WorkSeqMAEN_ID as int	--M-A-E-N	A sequence of morning , afternoon, evening and night workshifts
--return the IDs for use later
set @WorkSeqDN_ID = (select w.WorkSeq_ID from dbo.WorkSequence w where w.WorkSeqName = 'WorkSeqDN')
set @WorkSeqMAN_ID = (select w.WorkSeq_ID from dbo.WorkSequence w where w.WorkSeqName = 'WorkSeqMAN')
set @WorkSeqMAEN_ID = (select w.WorkSeq_ID from dbo.WorkSequence w where w.WorkSeqName = 'WorkSeqMAEN')









---------------------------------------------------------------------------------------------------









--create a shift sequence by matching workshifts to each of the newly created work sequences above
insert into dbo.ShiftSequence
	(WorkSeq_ID,WorkShift_ID,WorkShift_Order,DTStamp)
values
	(@WorkSeqDN_ID,@D2_ID,1,CURRENT_TIMESTAMP),
	(@WorkSeqDN_ID,@N1_ID,2,CURRENT_TIMESTAMP),

	(@WorkSeqMAN_ID,@M1_ID,1,CURRENT_TIMESTAMP),
	(@WorkSeqMAN_ID,@A2_ID,2,CURRENT_TIMESTAMP),
	(@WorkSeqMAN_ID,@N1_ID,3,CURRENT_TIMESTAMP),

	(@WorkSeqMAEN_ID,@M1_ID,1,CURRENT_TIMESTAMP),
	(@WorkSeqMAEN_ID,@A1_ID,2,CURRENT_TIMESTAMP),
	(@WorkSeqMAEN_ID,@E1_ID,3,CURRENT_TIMESTAMP),
	(@WorkSeqMAEN_ID,@N2_ID,4,CURRENT_TIMESTAMP)








-----------------------------------------------------------------------------------------------------



-- we need a system usertype and user -- used when we will be insertin default values for workbands upon patient entry to ward
declare @system_ID as int
insert into dbo.[StaffType]
	(StaffTypeName,StaffTypeDescription,DTStamp)
values
	('System','System',CURRENT_TIMESTAMP)
--return its id and insert one system user
set @system_ID = (select s.StaffType_ID from dbo.[StaffType] s where s.StaffTypeName = 'System')
insert into dbo.[Staff]
	(StaffType_ID,FirstName,LastName,Unique_ID,[Password],DTStamp)
values
	(@system_ID,'System','System', 'System','System',CURRENT_TIMESTAMP)





-----------------------------------------------------------------------------------------------------



-- insert some staff types
insert into dbo.[StaffType]
	(StaffTypeName,StaffTypeDescription,DTStamp)
values
	('RN','Registered Nurse',CURRENT_TIMESTAMP),
	('StdN','Student Nurse',CURRENT_TIMESTAMP),
	('HCA','Health Care Assistant',CURRENT_TIMESTAMP),
	('CNM','Clinical Nurse Manager',CURRENT_TIMESTAMP),
	('ADON','Assistant Director of Nursing',CURRENT_TIMESTAMP),
	('DON','Director of Nursing',CURRENT_TIMESTAMP)

declare @RN_ID as int
declare @StdN_ID as int
declare @HCA_ID as int
declare @CNM_ID as int --jnr ward manager
declare @ADON_ID as int	--assistant director of nursing
declare @DON_ID as int	--director of nursing
-- return the IDs for use later
set @RN_ID = (select s.StaffType_ID from dbo.[StaffType] s where s.StaffTypeName = 'RN')
set @StdN_ID = (select s.StaffType_ID from dbo.[StaffType] s where s.StaffTypeName = 'StdN')
set @HCA_ID = (select s.StaffType_ID from dbo.[StaffType] s where s.StaffTypeName = 'HCA')
set @CNM_ID = (select s.StaffType_ID from dbo.[StaffType] s where s.StaffTypeName = 'CNM')
set @ADON_ID = (select s.StaffType_ID from dbo.[StaffType] s where s.StaffTypeName = 'ADON')
set @DON_ID = (select s.StaffType_ID from dbo.[StaffType] s where s.StaffTypeName = 'DON')







------------------------------------------------------------------------------------------







--insert some staff
-- some RN
declare @RN1_ID as int
declare @RN2_ID as int
declare @RN3_ID as int
declare @RN4_ID as int
declare @RN5_ID as int
declare @RN6_ID as int
declare @RN7_ID as int
declare @RN8_ID as int
declare @RN9_ID as int
declare @RN10_ID as int

declare @RN11_ID as int
declare @RN12_ID as int
declare @RN13_ID as int
declare @RN14_ID as int
declare @RN15_ID as int
declare @RN16_ID as int
declare @RN17_ID as int
declare @RN18_ID as int
declare @RN19_ID as int
declare @RN20_ID as int

declare @StdN1_ID as int
declare @StdN2_ID as int
declare @StdN3_ID as int
declare @StdN4_ID as int
declare @StdN5_ID as int
declare @StdN6_ID as int
declare @StdN7_ID as int
declare @StdN8_ID as int
declare @StdN9_ID as int
declare @StdN10_ID as int


declare @HCA1_ID as int
declare @HCA2_ID as int
declare @HCA3_ID as int
declare @HCA4_ID as int
declare @HCA5_ID as int
declare @HCA6_ID as int
declare @HCA7_ID as int
declare @HCA8_ID as int
declare @HCA9_ID as int
declare @HCA10_ID as int

declare @HCA11_ID as int
declare @HCA12_ID as int
declare @HCA13_ID as int
declare @HCA14_ID as int
declare @HCA15_ID as int
declare @HCA16_ID as int
declare @HCA17_ID as int
declare @HCA18_ID as int
declare @HCA19_ID as int
declare @HCA20_ID as int

declare @CNM1_ID as int
declare @CNM2_ID as int
declare @CNM3_ID as int
declare @CNM4_ID as int
declare @CNM5_ID as int
declare @CNM6_ID as int
declare @CNM7_ID as int
declare @CNM8_ID as int
declare @CNM9_ID as int
declare @CNM10_ID as int


declare @ADON1_ID as int
declare @ADON2_ID as int
declare @DON1_ID as int



insert into dbo.[Staff]
	(StaffType_ID,FirstName,LastName,Unique_ID,[Password],DTStamp)
values
	--20 RN
	(@RN_ID,'RN1','RN1', 'RN1','RN1',CURRENT_TIMESTAMP),
	(@RN_ID,'RN2','RN2', 'RN2','RN2',CURRENT_TIMESTAMP),
	(@RN_ID,'RN3','RN3', 'RN3','RN3',CURRENT_TIMESTAMP),
	(@RN_ID,'RN4','RN4', 'RN4','RN4',CURRENT_TIMESTAMP),
	(@RN_ID,'RN5','RN5', 'RN5','RN5',CURRENT_TIMESTAMP),
	(@RN_ID,'RN6','RN6', 'RN6','RN6',CURRENT_TIMESTAMP),
	(@RN_ID,'RN7','RN7', 'RN7','RN7',CURRENT_TIMESTAMP),
	(@RN_ID,'RN8','RN8', 'RN8','RN8',CURRENT_TIMESTAMP),
	(@RN_ID,'RN9','RN9', 'RN9','RN9',CURRENT_TIMESTAMP),
	(@RN_ID,'RN10','RN10', 'RN10','RN10',CURRENT_TIMESTAMP),

	(@RN_ID,'RN11','RN11', 'RN11','RN11',CURRENT_TIMESTAMP),
	(@RN_ID,'RN12','RN12', 'RN12','RN12',CURRENT_TIMESTAMP),
	(@RN_ID,'RN13','RN13', 'RN13','RN13',CURRENT_TIMESTAMP),
	(@RN_ID,'RN14','RN14', 'RN14','RN14',CURRENT_TIMESTAMP),
	(@RN_ID,'RN15','RN15', 'RN15','RN15',CURRENT_TIMESTAMP),
	(@RN_ID,'RN16','RN16', 'RN16','RN16',CURRENT_TIMESTAMP),
	(@RN_ID,'RN17','RN17', 'RN17','RN17',CURRENT_TIMESTAMP),
	(@RN_ID,'RN18','RN18', 'RN18','RN18',CURRENT_TIMESTAMP),
	(@RN_ID,'RN19','RN19', 'RN19','RN19',CURRENT_TIMESTAMP),
	(@RN_ID,'RN20','RN20', 'RN20','RN20',CURRENT_TIMESTAMP),

	--10 STDN
	(@StdN_ID,'StdN1','StdN1', 'StdN1','StdN1',CURRENT_TIMESTAMP),
	(@StdN_ID,'StdN2','StdN2', 'StdN2','StdN2',CURRENT_TIMESTAMP),
	(@StdN_ID,'StdN3','StdN3', 'StdN3','StdN3',CURRENT_TIMESTAMP),
	(@StdN_ID,'StdN4','StdN4', 'StdN4','StdN4',CURRENT_TIMESTAMP),
	(@StdN_ID,'StdN5','StdN5', 'StdN5','StdN5',CURRENT_TIMESTAMP),
	(@StdN_ID,'StdN6','StdN6', 'StdN6','StdN6',CURRENT_TIMESTAMP),
	(@StdN_ID,'StdN7','StdN7', 'StdN7','StdN7',CURRENT_TIMESTAMP),
	(@StdN_ID,'StdN8','StdN8', 'StdN8','StdN8',CURRENT_TIMESTAMP),
	(@StdN_ID,'StdN9','StdN9', 'StdN9','StdN9',CURRENT_TIMESTAMP),
	(@StdN_ID,'StdN10','StdN10', 'StdN10','StdN10',CURRENT_TIMESTAMP),

	--20 HCA
	(@HCA_ID,'HCA1','HCA1', 'HCA1','HCA1',CURRENT_TIMESTAMP),
	(@HCA_ID,'HCA2','HCA2', 'HCA2','HCA2',CURRENT_TIMESTAMP),
	(@HCA_ID,'HCA3','HCA3', 'HCA3','HCA3',CURRENT_TIMESTAMP),
	(@HCA_ID,'HCA4','HCA4', 'HCA4','HCA4',CURRENT_TIMESTAMP),
	(@HCA_ID,'HCA5','HCA5', 'HCA5','HCA5',CURRENT_TIMESTAMP),
	(@HCA_ID,'HCA6','HCA6', 'HCA6','HCA6',CURRENT_TIMESTAMP),
	(@HCA_ID,'HCA7','HCA7', 'HCA7','HCA7',CURRENT_TIMESTAMP),
	(@HCA_ID,'HCA8','HCA8', 'HCA8','HCA8',CURRENT_TIMESTAMP),
	(@HCA_ID,'HCA9','HCA9', 'HCA9','HCA9',CURRENT_TIMESTAMP),
	(@HCA_ID,'HCA10','HCA10', 'HCA10','HCA10',CURRENT_TIMESTAMP),

	(@HCA_ID,'HCA11','HCA11', 'HCA11','HCA11',CURRENT_TIMESTAMP),
	(@HCA_ID,'HCA12','HCA12', 'HCA12','HCA12',CURRENT_TIMESTAMP),
	(@HCA_ID,'HCA13','HCA13', 'HCA13','HCA13',CURRENT_TIMESTAMP),
	(@HCA_ID,'HCA14','HCA14', 'HCA14','HCA14',CURRENT_TIMESTAMP),
	(@HCA_ID,'HCA15','HCA15', 'HCA15','HCA15',CURRENT_TIMESTAMP),
	(@HCA_ID,'HCA16','HCA16', 'HCA16','HCA16',CURRENT_TIMESTAMP),
	(@HCA_ID,'HCA17','HCA17', 'HCA17','HCA17',CURRENT_TIMESTAMP),
	(@HCA_ID,'HCA18','HCA18', 'HCA18','HCA18',CURRENT_TIMESTAMP),
	(@HCA_ID,'HCA19','HCA19', 'HCA19','HCA19',CURRENT_TIMESTAMP),
	(@HCA_ID,'HCA20','HCA20', 'HCA20','HCA20',CURRENT_TIMESTAMP),

	--10 CNM
	(@CNM_ID,'CNM1','CNM1', 'CNM1','CNM1',CURRENT_TIMESTAMP),
	(@CNM_ID,'CNM2','CNM2', 'CNM2','CNM2',CURRENT_TIMESTAMP),
	(@CNM_ID,'CNM3','CNM3', 'CNM3','CNM3',CURRENT_TIMESTAMP),
	(@CNM_ID,'CNM4','CNM4', 'CNM4','CNM4',CURRENT_TIMESTAMP),
	(@CNM_ID,'CNM5','CNM5', 'CNM5','CNM5',CURRENT_TIMESTAMP),
	(@CNM_ID,'CNM6','CNM6', 'CNM6','CNM6',CURRENT_TIMESTAMP),
	(@CNM_ID,'CNM7','CNM7', 'CNM7','CNM7',CURRENT_TIMESTAMP),
	(@CNM_ID,'CNM8','CNM8', 'CNM8','CNM8',CURRENT_TIMESTAMP),
	(@CNM_ID,'CNM9','CNM9', 'CNM9','CNM9',CURRENT_TIMESTAMP),
	(@CNM_ID,'CNM10','CNM10', 'CNM10','CNM10',CURRENT_TIMESTAMP),

	-- 2 ADON
	(@ADON_ID,'ADON1','ADON1', 'ADON1','ADON1',CURRENT_TIMESTAMP),
	-- 1 DON
	(@ADON_ID,'ADON2','ADON2', 'ADON2','ADON2',CURRENT_TIMESTAMP),
	(@DON_ID,'DON1','DON1', 'DON1','DON1',CURRENT_TIMESTAMP)

-- return the IDs of some a few of them to use later
set @RN1_ID = (select s.Staff_ID from [dbo].[Staff] s where s.FirstName = 'RN1')
set @RN2_ID = (select s.Staff_ID from [dbo].[Staff] s where s.FirstName = 'RN2')
set @RN3_ID = (select s.Staff_ID from [dbo].[Staff] s where s.FirstName = 'RN3')
set @RN4_ID = (select s.Staff_ID from [dbo].[Staff] s where s.FirstName = 'RN4')
set @RN5_ID = (select s.Staff_ID from [dbo].[Staff] s where s.FirstName = 'RN5')
set @RN6_ID = (select s.Staff_ID from [dbo].[Staff] s where s.FirstName = 'RN6')
set @RN7_ID = (select s.Staff_ID from [dbo].[Staff] s where s.FirstName = 'RN7')
set @RN8_ID = (select s.Staff_ID from [dbo].[Staff] s where s.FirstName = 'RN8')
set @RN9_ID = (select s.Staff_ID from [dbo].[Staff] s where s.FirstName = 'RN9')
set @RN10_ID = (select s.Staff_ID from [dbo].[Staff] s where s.FirstName = 'RN10')

set @RN11_ID = (select s.Staff_ID from [dbo].[Staff] s where s.FirstName = 'RN11')
set @RN12_ID = (select s.Staff_ID from [dbo].[Staff] s where s.FirstName = 'RN12')
set @RN13_ID = (select s.Staff_ID from [dbo].[Staff] s where s.FirstName = 'RN13')
set @RN14_ID = (select s.Staff_ID from [dbo].[Staff] s where s.FirstName = 'RN14')
set @RN15_ID = (select s.Staff_ID from [dbo].[Staff] s where s.FirstName = 'RN15')
set @RN16_ID = (select s.Staff_ID from [dbo].[Staff] s where s.FirstName = 'RN16')
set @RN17_ID = (select s.Staff_ID from [dbo].[Staff] s where s.FirstName = 'RN17')
set @RN18_ID = (select s.Staff_ID from [dbo].[Staff] s where s.FirstName = 'RN18')
set @RN19_ID = (select s.Staff_ID from [dbo].[Staff] s where s.FirstName = 'RN19')
set @RN20_ID = (select s.Staff_ID from [dbo].[Staff] s where s.FirstName = 'RN20')
	
--the 10 std
set @StdN1_ID = (select s.Staff_ID from [dbo].[Staff] s where s.FirstName = 'Std1')
set @StdN2_ID = (select s.Staff_ID from [dbo].[Staff] s where s.FirstName = 'Std2')
set @StdN3_ID = (select s.Staff_ID from [dbo].[Staff] s where s.FirstName = 'Std3')
set @StdN4_ID = (select s.Staff_ID from [dbo].[Staff] s where s.FirstName = 'Std4')
set @StdN5_ID = (select s.Staff_ID from [dbo].[Staff] s where s.FirstName = 'Std5')
set @StdN6_ID = (select s.Staff_ID from [dbo].[Staff] s where s.FirstName = 'Std6')
set @StdN7_ID = (select s.Staff_ID from [dbo].[Staff] s where s.FirstName = 'Std7')
set @StdN8_ID = (select s.Staff_ID from [dbo].[Staff] s where s.FirstName = 'Std8')
set @StdN9_ID = (select s.Staff_ID from [dbo].[Staff] s where s.FirstName = 'Std9')
set @StdN10_ID = (select s.Staff_ID from [dbo].[Staff] s where s.FirstName = 'Std10')

--the 20 hca
set @HCA1_ID = (select s.Staff_ID from [dbo].[Staff] s where s.FirstName = 'HCA1')
set @HCA2_ID = (select s.Staff_ID from [dbo].[Staff] s where s.FirstName = 'HCA2')
set @HCA3_ID = (select s.Staff_ID from [dbo].[Staff] s where s.FirstName = 'HCA3')
set @HCA4_ID = (select s.Staff_ID from [dbo].[Staff] s where s.FirstName = 'HCA4')
set @HCA5_ID = (select s.Staff_ID from [dbo].[Staff] s where s.FirstName = 'HCA5')
set @HCA6_ID = (select s.Staff_ID from [dbo].[Staff] s where s.FirstName = 'HCA6')
set @HCA7_ID = (select s.Staff_ID from [dbo].[Staff] s where s.FirstName = 'HCA7')
set @HCA8_ID = (select s.Staff_ID from [dbo].[Staff] s where s.FirstName = 'HCA8')
set @HCA9_ID = (select s.Staff_ID from [dbo].[Staff] s where s.FirstName = 'HCA9')
set @HCA10_ID = (select s.Staff_ID from [dbo].[Staff] s where s.FirstName = 'HCA10')

set @HCA11_ID = (select s.Staff_ID from [dbo].[Staff] s where s.FirstName = 'HCA11')
set @HCA12_ID = (select s.Staff_ID from [dbo].[Staff] s where s.FirstName = 'HCA12')
set @HCA13_ID = (select s.Staff_ID from [dbo].[Staff] s where s.FirstName = 'HCA13')
set @HCA14_ID = (select s.Staff_ID from [dbo].[Staff] s where s.FirstName = 'HCA14')
set @HCA15_ID = (select s.Staff_ID from [dbo].[Staff] s where s.FirstName = 'HCA15')
set @HCA16_ID = (select s.Staff_ID from [dbo].[Staff] s where s.FirstName = 'HCA16')
set @HCA17_ID = (select s.Staff_ID from [dbo].[Staff] s where s.FirstName = 'HCA17')
set @HCA18_ID = (select s.Staff_ID from [dbo].[Staff] s where s.FirstName = 'HCA18')
set @HCA19_ID = (select s.Staff_ID from [dbo].[Staff] s where s.FirstName = 'HCA19')
set @HCA20_ID = (select s.Staff_ID from [dbo].[Staff] s where s.FirstName = 'HCA20')

--10 CNM
set @CNM1_ID = (select s.Staff_ID from [dbo].[Staff] s where s.FirstName = 'CNM1')
set @CNM2_ID = (select s.Staff_ID from [dbo].[Staff] s where s.FirstName = 'CNM2')
set @CNM3_ID = (select s.Staff_ID from [dbo].[Staff] s where s.FirstName = 'CNM3')
set @CNM4_ID = (select s.Staff_ID from [dbo].[Staff] s where s.FirstName = 'CNM4')
set @CNM5_ID = (select s.Staff_ID from [dbo].[Staff] s where s.FirstName = 'CNM5')
set @CNM6_ID = (select s.Staff_ID from [dbo].[Staff] s where s.FirstName = 'CNM6')
set @CNM7_ID = (select s.Staff_ID from [dbo].[Staff] s where s.FirstName = 'CNM7')
set @CNM8_ID = (select s.Staff_ID from [dbo].[Staff] s where s.FirstName = 'CNM8')
set @CNM9_ID = (select s.Staff_ID from [dbo].[Staff] s where s.FirstName = 'CNM9')
set @CNM10_ID = (select s.Staff_ID from [dbo].[Staff] s where s.FirstName = 'CNM10')

set @ADON1_ID = (select s.Staff_ID from [dbo].[Staff] s where s.FirstName = 'ADON1')
set @ADON2_ID = (select s.Staff_ID from [dbo].[Staff] s where s.FirstName = 'ADON2')

set @DON1_ID = (select s.Staff_ID from [dbo].[Staff] s where s.FirstName = 'DON1')

--we will assign shifts to the above further down









-----------------------------------------------------------------------------------












--create some roster shifts
insert into dbo.RosterShift
	(RosterShiftName,RosterShiftAbbrev,RosterShiftDescription,StartTime,EndTime,[Hours],DTStamp)
values
	('RSM1','M1 7:30 - 14:00','morning shift 7:30am to 2pm','07:30:00','13:59:59',6,CURRENT_TIMESTAMP),
	('RSM2','M2 7:30 - 16:00','morning shift 7:30am to 4pm','07:30:00','15:59:59',8,CURRENT_TIMESTAMP),
	('RSD1','D1 7:30 - 20:30','long day shift 7:30am to 8:30pm','07:30:00','20:29:59',12,CURRENT_TIMESTAMP),
	('RSE1','E1 13:00 - 20:30','evening shift 1pm to 8:30 pm','13:00:00','20:29:59',7,CURRENT_TIMESTAMP),
	('RSE2','E2 16:00 - 20:30','evening shift 4pm to 8:30 pm','16:00:00','20:29:59',4.5,CURRENT_TIMESTAMP),
	('RSN1','N1 20:00 - 08:00','night shift 8pm to 8am','20:00:00','07:59:59',11,CURRENT_TIMESTAMP)

DECLARE @RSM1_ID as int	-- morning shift 7:30am to 2pm
DECLARE @RSM2_ID as int	-- morning shift 7:30am to 4pm
DECLARE @RSD1_ID as int	--long day shift 7:30am to 8:30pm
DECLARE @RSE1_ID as int	-- evening shift 1pm to 8:30 pm
DECLARE @RSE2_ID as int	-- evening shift 4pm to 8:30 pm
DECLARE @RSN1_ID as int	-- night shift 8pm to 8am
--return the IDs for using later when assigning staff to the roster
set @RSM1_ID = (select r.RosterShift_ID from dbo.RosterShift r where r.RosterShiftName = 'RSM1')
set @RSM2_ID = (select r.RosterShift_ID from dbo.RosterShift r where r.RosterShiftName = 'RSM2')
set @RSD1_ID = (select r.RosterShift_ID from dbo.RosterShift r where r.RosterShiftName = 'RSD1')
set @RSE1_ID = (select r.RosterShift_ID from dbo.RosterShift r where r.RosterShiftName = 'RSE1')
set @RSE2_ID = (select r.RosterShift_ID from dbo.RosterShift r where r.RosterShiftName = 'RSE2')
set @RSN1_ID = (select r.RosterShift_ID from dbo.RosterShift r where r.RosterShiftName = 'RSN1')





-----------------------------------------------------------------------------------------------

--assign staff to shifts on dates -- do the roster
-- come back to this later

----------------------------------------------------------------------------------------------

-- roster
--assume that we have a workmodel created by bulk insert from csv
-- assume that we have a submodel -- created at the same time as workmodel in bulk insert



/*
SELECT * FROM SubModelDefault

@defaultName1 = 'HarleyDefaultOne'	= ID 1 = Sub 1
@defaultName2 = 'HarleyDefaultTwo' = ID 2 = Sub 1 
@defaultName3 = 'DavidDefaultOne' = ID 3 = Sub 2 = Sligo, Cork
@defaultName4 = 'DavidDefaultTwo' = ID 4 = Sub 2 = Dublin
@defaultName5 = 'RuthieDefaultOne' = ID 5 = Sub 3 = Wicklow
@defaultName6 = 'RuthieDefaultTwo' = ID 6 = Sub 3 = Waterford



*/

--attach a ward to a submodel
update dbo.Ward set WorkSubModel_ID = @subModelTwoID where Ward_ID = @SligoWard_ID
update dbo.Ward set WorkSubModel_ID = @subModelTwoID where Ward_ID = @DublinWard_ID
update dbo.Ward set WorkSubModel_ID = @subModelThreeID where Ward_ID = @WicklowWard_ID
update dbo.Ward set WorkSubModel_ID = @subModelThreeID where Ward_ID = @WaterfordWard_ID
update dbo.Ward set WorkSubModel_ID = @subModelTwoID where Ward_ID = @CorkWard_ID
-- now Sligo Dub and Cork have same sub model
-- Waterford and Wicklow have same sub model

--set defaults for wards...careful that default belongs to submodel
update dbo.Ward set SubModelDefault_ID = @defaultNameThreeID where Ward_ID = @SligoWard_ID
update dbo.Ward set SubModelDefault_ID = @defaultNameFourID where Ward_ID = @DublinWard_ID
update dbo.Ward set SubModelDefault_ID = @defaultNameFiveID where Ward_ID = @WicklowWard_ID
update dbo.Ward set SubModelDefault_ID = @defaultNameSixID where Ward_ID = @WaterfordWard_ID
update dbo.Ward set SubModelDefault_ID = @defaultNameThreeID where Ward_ID = @CorkWard_ID
-- now Sligo and Cork have same defaults (will see diffs in workscore bc SLigo has 8 pats and Cork has 2 pats)
-- Dublin and Sligo have same sub model but diff defaults (will see diff in workscore even though they have same num pats)
-- Waterford and Wicklow have same sub but diff defaults (will see diff in workscore even though they have same num pats)

--set a work sequence for a ward
update dbo.Ward set WorkSeq_ID = @WorkSeqDN_ID where Ward_ID = @SligoWard_ID
update dbo.Ward set WorkSeq_ID = @WorkSeqMAN_ID where Ward_ID = @DublinWard_ID
update dbo.Ward set WorkSeq_ID = @WorkSeqMAN_ID where Ward_ID = @WicklowWard_ID
update dbo.Ward set WorkSeq_ID = @WorkSeqMAEN_ID where Ward_ID = @WaterfordWard_ID
update dbo.Ward set WorkSeq_ID = @WorkSeqMAEN_ID where Ward_ID = @CorkWard_ID

--now all your wards are set up with their worksubmodel and the sequence of shifts for recording the work


---------------------------------------------------------------------





