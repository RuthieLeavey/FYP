package com.example.wms_mobapp;

import junit.framework.TestCase;

import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.Date;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.time.LocalDate;

public class DatabaseHelperTest extends TestCase {

    //only for test connections!!!
//    public static Connection returnConn(){
////        Connection conn = null;
////        System.out.println("testConnectionclass");
////        String connectionUrl = "jdbc:jtds:sqlserver://database-1.chx79b5ss8ae.us-east-1.rds.amazonaws.com;DatabaseName=WEEK;user=adminUsername;password=adminPassword;";
////        try {
////            Class.forName("net.sourceforge.jtds.jdbc.Driver");
////            conn = DriverManager.getConnection(connectionUrl);
////            DatabaseMetaData dm = (DatabaseMetaData) conn.getMetaData();
////            System.out.println("Driver name: " + dm.getDriverName());
////        } catch (ClassNotFoundException | SQLException e) {
////            e.printStackTrace();
////        }
////        return conn;
//    }

    public void testReturnWardNames() {
//        System.out.println("testReturnWardNames");
//        ResultSet rs = DatabaseHelper.returnWardNames();
//        assertEquals(rs!=null, true);
    }

    public void testReturnWardSubModId() {
//        System.out.println("testReturnWardSubModId");
//        String wardName = "Sligo";
//        Integer result = DatabaseHelper.returnWardSubModId(wardName);
//        Integer expResult = 2;
//        assertEquals(expResult, result);
    }

    public void testReturnWardId() {
//        System.out.println("testReturnWardId");
//        String wardName = "Sligo";
//        Integer result = DatabaseHelper.returnWardId(wardName);
//        Integer expResult = 1;
//        assertEquals(expResult, result);
    }

    public void testReturnPatientInfoOnWard() throws SQLException {
//        System.out.println("testReturnPatientInfoOnWard");
//        Integer wardId = 1;
//        ResultSet rs = DatabaseHelper.returnPatientInfoOnWard(wardId);
//        assertEquals(rs!=null, true);
//
//        System.out.println("testReturnPatientInfoOnWard");
//        Integer wardId2 = 27;
//        ResultSet rs2 = DatabaseHelper.returnPatientInfoOnWard(wardId2);
//        boolean b = rs2.next();
//        assertEquals(rs2!=null, true);
//        assertFalse(b);
    }

    public void testReturnPatientPieInfo() throws SQLException {
//        System.out.println("testReturnPatientPieInfo");
//        Integer subModId = 1;
//        ResultSet rs = DatabaseHelper.returnPatientPieInfo(subModId);
//        assertTrue(rs != null);
//        boolean b = rs.next();
//        assertTrue(b);
//
//            Integer workModId = rs.getInt("WorkModel_ID");
//            Integer expResult1 = 1;
//            assertTrue(workModId != null);
//            assertEquals(expResult1, workModId);
//            Integer workTaskId = rs.getInt("WorkTask_ID");
//            Integer expResult2 = 1;
//            assertTrue(workTaskId != null);
//            assertEquals(expResult2, workTaskId);
//            String workTaskName = rs.getString("WorkTaskName");
//            String expResult3 = "Task A";
//            assertTrue(workTaskName != null);
//            assertEquals(expResult3, workTaskName);
//            Float taskRatio = rs.getFloat("TaskSubModelRatio");
//            Float expResult4 = (float)5.33807829181495;
//            assertTrue(taskRatio != null);
//            assertEquals(expResult4, taskRatio);
    }

    public void testReturnTaskBands() throws SQLException {
//        System.out.println("testReturnTaskBands");
//        Integer taskId = 1;
//        Integer wardId = 1;
//        ResultSet rs = DatabaseHelper.returnTaskBands(taskId,wardId);
//        assertTrue(rs != null);
//        boolean b = rs.next();
//        assertTrue(b);
//
//        Integer taskBndId = rs.getInt("TaskBand_ID");
//        Integer expResult1 = 1;
//        assertTrue(taskBndId != null);
//        assertEquals(expResult1, taskBndId);
//        String taskBndName = rs.getString("TaskBandName");
//        String expResult3 = "Task A Large";
//        assertTrue(taskBndName != null);
//        assertEquals(expResult3, taskBndName);
//        Float taskBndWeight = rs.getFloat("TaskBand_Weight");
//        Float expResult4 = (float)1;
//        assertTrue(taskBndWeight != null);
//        assertEquals(expResult4, taskBndWeight);
    }

    public void testReturnCurrentShiftId() {
//        System.out.println("testReturnCurrentShiftId");
//        Integer wardId = 1;
//        Integer result = DatabaseHelper.returnCurrentShiftId(wardId);
//        Integer expResult = 10;
//        assertEquals(expResult, result);
    }

    public void testInsertIntoWorkTable() throws SQLException {
////        System.out.println("testInsertIntoWorkTable");
//        Date date = Date.valueOf(String.valueOf(LocalDate.now()));
////        DatabaseHelper.insertIntoWorkTable(1,
////                date,10, 1, 1, 0, 49, 5);
////        //task a- 49, task b - 50, task c - 51, task d - 52, task e - 53, task f - 54, task g -55
//
//        Connection connection = returnConn();
//        String sql = "SELECT * FROM WORK WHERE Staff_ID='5' AND TaskBand_ID ='49' AND WorkShiftDate='" + date + "'";
//        Statement s = connection.createStatement();
//        ResultSet rs = s.executeQuery(sql);
//        boolean b = rs.next();
//        assertTrue(b);


    }
}