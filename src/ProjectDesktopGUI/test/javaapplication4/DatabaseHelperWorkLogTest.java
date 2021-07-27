
package javaapplication4;

import java.sql.Connection;
import java.sql.Date;
import java.sql.ResultSet;
import java.sql.Statement;
import java.lang.*;
import java.sql.SQLException;
import java.time.LocalDate;
import static org.hamcrest.CoreMatchers.instanceOf;
import static org.hamcrest.CoreMatchers.is;
import org.junit.After;
import org.junit.AfterClass;
import org.junit.Before;
import org.junit.BeforeClass;
import org.junit.Test;
import static org.junit.Assert.*;

/**
 *
 * @author ruthl
 */
public class DatabaseHelperWorkLogTest {
    
    public DatabaseHelperWorkLogTest() {
    }
    
    @BeforeClass
    public static void setUpClass() {
    }
    
    @AfterClass
    public static void tearDownClass() {
    }
    
    @Before
    public void setUp() {
    }
    
    @After
    public void tearDown() {
    }

    /**
     * Test of returnWardNames method, of class DatabaseHelperWorkLog.
     */
    @Test
    public void testReturnWardNames() {
//        System.out.println("returnWardNames");
//        ResultSet result = DatabaseHelperWorkLog.returnWardNames();
//        assertEquals(result!=null, true);
    }

    /**
     * Test of returnWardSubModId method, of class DatabaseHelperWorkLog.
     */
    @Test
    public void testReturnWardSubModId() {
//        System.out.println("returnWardSubModIdSligoWard");
//        String wardName1 = "Sligo";
//        int expResult1 = 3;
//        int result1 = DatabaseHelperWorkLog.returnWardSubModId(wardName1);
//        System.out.println("returnWardSubModIdDublinWard");
//        String wardName2 = "Dublin";
//        int expResult2 = 3;
//        int result2 = DatabaseHelperWorkLog.returnWardSubModId(wardName2);
//        System.out.println("returnWardSubModIdWicklowWard");
//        String wardName3 = "Wicklow";
//        int expResult3 = 2;
//        int result3 = DatabaseHelperWorkLog.returnWardSubModId(wardName3);
//        System.out.println("returnWardSubModIdWaterfordWard");
//        String wardName4 = "Waterford";
//        int expResult4 = 2;
//        int result4 = DatabaseHelperWorkLog.returnWardSubModId(wardName4);
//        System.out.println("returnWardSubModIdCorkWard");
//        String wardName5 = "Cork";
//        int expResult5 = 3;
//        int result5 = DatabaseHelperWorkLog.returnWardSubModId(wardName5);        
//        assertEquals(expResult1, result1);
//        assertEquals(expResult2, result2);
//        assertEquals(expResult3, result3);
//        assertEquals(expResult4, result4);
//        assertEquals(expResult5, result5);

//        System.out.println("returnWardSubModIdWrongWard1");
//        String wardName = "Wrong1";
//        int expResult = 3;
//        int result = DatabaseHelperWorkLog.returnWardSubModId(wardName);        
//        assertNotEquals(expResult, result);
//        assertEquals(0, result);

//        System.out.println("returnWardSubModIdWrongWard2");
//        String wardName4 = "Wrong2";
//        int expResult = 2;
//        int result = DatabaseHelperWorkLog.returnWardSubModId(wardName4);        
//        assertNotEquals(expResult, result);
//        assertEquals(0, result);
//
//        System.out.println("returnWardSubModIdWrongWard3");
//        String wardName = "Wrong3";
//        int expResult = 3;
//        int result = DatabaseHelperWorkLog.returnWardSubModId(wardName);        
//        assertNotEquals(expResult, result);
//        assertEquals(0, result);

//        System.out.println("returnWardSubModIdWrongWard3");
//        String wardName = "Wrong3";
//        int expResult = 1;
//        int result = DatabaseHelperWorkLog.returnWardSubModId(wardName);        
//        assertNotEquals(expResult, result);
//        assertEquals(0, result);
        
    }

    /**
     * Test of returnWardId method, of class DatabaseHelperWorkLog.
     */
    @Test
    public void testReturnWardId() {
//        System.out.println("returnWardIdSligo");
//        String wardName = "Sligo";
//        int expResult = 1;
//        int result = DatabaseHelperWorkLog.returnWardId(wardName);
//        assertEquals(expResult, result);
//                
//        System.out.println("returnWardIdWicklow");
//        String wardName3 = "Wicklow";
//        int expResult3 = 3;
//        int result3 = DatabaseHelperWorkLog.returnWardId(wardName3);
//        assertEquals(expResult3, result3);
//        
//        System.out.println("returnWardIdCork");
//        String wardName5 = "Cork";
//        int expResult5 = 5;
//        int result5 = DatabaseHelperWorkLog.returnWardId(wardName5);
//        assertEquals(expResult5, result5);

//        System.out.println("returnWardIdNonExisting1");
//        String wardName6 = "NotInDB1";
//        int expResult6 = 1;  //Sligo id
//        int result6 = DatabaseHelperWorkLog.returnWardId(wardName6);
//        assertNotEquals(expResult6, result6);
//        assertEquals(0, result6);
//        
//        System.out.println("returnWardIdNonExisting2");
//        String wardName7 = "NotInDB2";
//        int expResult7 = 3; //wicklow
//        int result7 = DatabaseHelperWorkLog.returnWardId(wardName7);
//        assertNotEquals(expResult7, result7);
//        assertEquals(0, result7);
////        
//        System.out.println("returnWardIdNonExisting3");
//        String wardName8 = "NotInDB3";
//        int expResult8 = 5; //cork
//        int result8 = DatabaseHelperWorkLog.returnWardId(wardName8);
//        assertNotEquals(expResult8, result8);
//        assertEquals(0, result8);


    }

    /**
     * Test of returnPatientsOnWard method, of class DatabaseHelperWorkLog.
     */
    @Test
    public void testReturnPatientsOnWard() {
//        System.out.println("returnPatientsOnSligoWard");
//        Integer wardId = 1;
//        ResultSet result = DatabaseHelperWorkLog.returnPatientsOnWard(wardId);
//        assertEquals(result != null, true);
//
//        System.out.println("returnPatientsOnWicklowWard");
//        Integer wardId2 = 3;
//        ResultSet result2 = DatabaseHelperWorkLog.returnPatientsOnWard(wardId2);
//        assertEquals(result2 != null, true);

//        System.out.println("returnPatientsOnCorkWard");
//        Integer wardId3 = 5;
//        ResultSet result3 = DatabaseHelperWorkLog.returnPatientsOnWard(wardId3);
//        assertEquals(result3 != null, true);
//        
//        System.out.println("returnPatientsOnEmptyWard");
//        Integer wardId4 = 6;
//        ResultSet result4 = DatabaseHelperWorkLog.returnPatientsOnWard(wardId3);
//        assertEquals(result4 != null, true);

//        System.out.println("returnPatientsOnNonExistingWard1");
//        Integer wardId5 = 15;
//        ResultSet result5 = DatabaseHelperWorkLog.returnPatientsOnWard(wardId5);
//        assertEquals(result5 != null, true);
//
//        System.out.println("returnPatientsOnNonExistingWard2");
//        Integer wardId6 = 20;
//        ResultSet result6 = DatabaseHelperWorkLog.returnPatientsOnWard(wardId6);
//        assertEquals(result6 != null, true);
//
//        System.out.println("returnPatientsOnNonExistingWard3");
//        Integer wardId7 = 25;
//        ResultSet result7 = DatabaseHelperWorkLog.returnPatientsOnWard(wardId7);
//        assertEquals(result7 != null, true);

    }

    /**
     * Test of returnPatientPieInfo method, of class DatabaseHelperWorkLog.
     */
    @Test
    public void testReturnPatientPieInfo() {
//        System.out.println("returnPatientPieInfoSubMod1");
//        int subModId = 1;
//        ResultSet result = DatabaseHelperWorkLog.returnPatientPieInfo(subModId);
//        assertEquals(result!=null, true);
//        
//        System.out.println("returnPatientPieInfoSubMod2");
//        int subModId2 = 2;
//        ResultSet result2 = DatabaseHelperWorkLog.returnPatientPieInfo(subModId2);
//        assertEquals(result2!=null, true);
//        
//        System.out.println("returnPatientPieInfoSubMod3");
//        int subModId3 = 3;
//        ResultSet result3 = DatabaseHelperWorkLog.returnPatientPieInfo(subModId3);
//        assertEquals(result3!=null, true);
//        
//        System.out.println("returnPatientPieInfoSubMod4");
//        int subModId4 = 4;
//        ResultSet result4 = DatabaseHelperWorkLog.returnPatientPieInfo(subModId4);
//        assertEquals(result4!=null, true);

//        System.out.println("returnPatientPieInfoNonExistingSub");
//        int subModId4 = 20; //20 doesn't exit in the db being tested
//        ResultSet result4 = DatabaseHelperWorkLog.returnPatientPieInfo(subModId4);
//        assertEquals(result4!=null, true);

    }

    /**
     * Test of returnTaskBands method, of class DatabaseHelperWorkLog.
     */
    @Test
    public void testReturnTaskBands() {
//        System.out.println("returnTaskBandsForSligo");
//        Integer taskId1 = 1; //task A
//        Integer taskId2 = 5; //task E
//        Integer taskId3 = 9; //task I
//        Integer wardId1 = 1; //sligo ward
//        ResultSet result1 = DatabaseHelperWorkLog.returnTaskBands(taskId1, wardId1);
//        ResultSet result2 = DatabaseHelperWorkLog.returnTaskBands(taskId2, wardId1);
//        ResultSet result3 = DatabaseHelperWorkLog.returnTaskBands(taskId3, wardId1);
//        assertEquals(result1!=null, true);
//        assertEquals(result2!=null, true);
//        assertEquals(result3!=null, true);

//        System.out.println("returnTaskBandsForWicklow");
//        Integer taskId4 = 1; //task A
//        Integer taskId5 = 4; //task D
//        Integer taskId6 = 10; //task J
//        Integer wardId2 = 3; //wicklow ward
//        ResultSet result4 = DatabaseHelperWorkLog.returnTaskBands(taskId4, wardId2);
//        ResultSet result5 = DatabaseHelperWorkLog.returnTaskBands(taskId5, wardId2);
//        ResultSet result6 = DatabaseHelperWorkLog.returnTaskBands(taskId6, wardId2);
//        assertEquals(result4!=null, true);
//        assertEquals(result5!=null, true);
//        assertEquals(result6!=null, true);

//        System.out.println("returnTaskBandsCork");
//        Integer taskId7 = 1; //task A
//        Integer taskId8 = 4; //task D
//        Integer taskId9 = 13; //task M
//        Integer wardId3 = 5; //cork ward
//        ResultSet result7 = DatabaseHelperWorkLog.returnTaskBands(taskId7, wardId3);
//        ResultSet result8 = DatabaseHelperWorkLog.returnTaskBands(taskId8, wardId3);
//        ResultSet result9 = DatabaseHelperWorkLog.returnTaskBands(taskId9, wardId3);
//        assertEquals(result7!=null, true);
//        assertEquals(result8!=null, true);
////        assertEquals(result9!=null, true);
    }

    /**
     * Test of returnCurrentShiftId method, of class DatabaseHelperWorkLog.
     */
    @Test
    public void testReturnCurrentShiftId() {
        //test case 1 - sligo and cork ward -- DIFFERENT TIMES****
        //when only sligo is in the db************
        //when only cork is in the db************
        //an id that doesn't exist
        
//        System.out.println("returnCurrentShiftId1");
//        int wardId = 1; //sligo ward
//        int expResult = 10; //current workshiftID at time 16:23 of test created
//        int result = DatabaseHelperWorkLog.returnCurrentShiftId(wardId);
//        assertEquals(expResult, result);
//        
//        System.out.println("returnCurrentShiftId2");
//        int wardId2 = 3; //wicklow ward
//        int expResult2 = 5; //current workshiftID at time 16:49 of test created
//        int result2 = DatabaseHelperWorkLog.returnCurrentShiftId(wardId2);
//        assertEquals(expResult2, result2);
//        
//        System.out.println("returnCurrentShiftId3");
//        int wardId3 = 5; //cork ward
//        int expResult3 = 4; //current workshiftID at time 16:23 of test created
//        int result3 = DatabaseHelperWorkLog.returnCurrentShiftId(wardId3);
//        assertEquals(expResult3, result3);
//        
//        System.out.println("returnCurrentShiftIdOfNonExistingWard");
//        int wardId4 = 7; //non existing ward
//        int expResult4 = 0; //current workshiftID at time 16:23 of test created
//        int result4 = DatabaseHelperWorkLog.returnCurrentShiftId(wardId4);
//        assertEquals(expResult4, result4);
        
        
    }

    /**
     * Test of insertIntoWorkTable method, of class DatabaseHelperWorkLog.
     */
    @Test
    public void testInsertIntoWorkTable() throws SQLException {
//        System.out.println("insertIntoWorkTable");
//        Integer epMovId = 2; //patient 2 on sligo
//        Date shiftDate = Date.valueOf(LocalDate.now());
//        Integer shiftId = 10; //curr shift
//        Integer workSubModId = 2; //sub model for Sligo
//        Integer workTaskId = 3; //task C
//        Integer isOutlier = 0;
//        Integer taskBandId = 51;
//        Integer staffId = 6;
//        DatabaseHelperWorkLog.insertIntoWorkTable(epMovId, shiftDate, shiftId, workSubModId, workTaskId, isOutlier, taskBandId, staffId);
        
//        // use sligo ward and ids, band id=0, and different staff id=cnm5
//        //then select from the db and check if each value in every col is the same 
//        Connection connection = DatabaseHelperWorkLog.returnConnection();
//        String sql = "SELECT * FROM WORK WHERE Staff_ID='6' AND TaskBand_ID ='51' AND WorkShiftDate='" + shiftDate + "'";
//        Statement s = connection.createStatement();
//        ResultSet rs = s.executeQuery(sql);
//        boolean b = rs.next();
//        assertTrue(b);
        
    }

    /**
     * Test of returnConnection method, of class DatabaseHelperWorkLog.
     */
    @Test
    public void testReturnConnection() {
//        System.out.println("returnConnection");
//        Connection result = DatabaseHelperWorkLog.returnConnection();
//        assertEquals(result != null, true);
    }

//    private void assertTrue(int result) {
//        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
//    }
    
}
