/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package javaapplication4;

import java.sql.*;
import org.junit.After;
import org.junit.AfterClass;
import org.junit.Before;
import org.junit.BeforeClass;
import org.junit.Test;
import static org.junit.Assert.*;

/**
 *
 * @author harle
 */
public class DatabaseHelperSPTest {
    
    // THESE TESTS ARE NOT WORKING AT ALLLLLLLLLLLLLLLLLLLLLLLLLLLL ???????????????????????????????????
    // think H2 db cant work with stored procedures
    
    public DatabaseHelperSPTest() {
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
     * Test of returnID method, of class DatabaseHelperSP.
     */
    @Test
    public void testReturnID() {
        try {
            Class.forName("org.h2.Driver");     // jar file needs to be in project library or this line wont work
            Connection conn = DriverManager.getConnection("jdbc:h2:tcp://localhost/~/test", "sa", "");  
            // above lines throws error if H2 is not running on machine when this file has been run 
            // Connection is broken: "java.net.SocketTimeoutException: Connect timed out: localhost" [90067-200]
            // for this to work, press windows key, type H2, click H2 console
            // the little yellow square H2 icon should appear in the windows taskbar (maybe press arrow in taskbar) 
            // and a browser should open localhost:8082/login.jsp? blah blah blah 
            PreparedStatement prepstmt = conn.prepareStatement("DROP TABLE IF EXISTS WorkModel");
            prepstmt.execute();
            PreparedStatement ps = conn.prepareStatement("CREATE TABLE WorkModel (WorkModel_ID INTEGER AUTO_INCREMENT NOT NULL, WorkModelName NVARCHAR(50) NOT NULL, WorkModelDescription NVARCHAR(200) NULL, DTStamp datetime NOT NULL)");
            ps.execute();
            PreparedStatement s = conn.prepareStatement("INSERT INTO WorkModel(WorkModelName, WorkModelDescription, DTStamp) VALUES (?, ?, ?)");
            s.setString(1, "Test Name");
            s.setString(2, "Description");
            Timestamp t = new Timestamp(System.currentTimeMillis());
            s.setTimestamp(3, t);
            int a = s.executeUpdate();
            if(a>0){
                System.out.println("Row updated"); 
            }
            
            System.out.println("returnID");
            String name = "Test Name";
            int expResult = 1;
            int result = DatabaseHelperSP.returnID(conn, name);
            assertEquals(expResult, result);
            // TODO review the generated test code and remove the default call to fail.
//            fail("The test case is a prototype.");
//            p sure above line is used only in tests that are supposed to be broken and catch an exception. so u use this line to fial it if it keeps runninf ie. hasnt caught the exception 
            PreparedStatement prepstmt2 = conn.prepareStatement("DROP TABLE IF EXISTS WorkModel");
            prepstmt2.execute();
            conn.close();
        }
          
        catch (ClassNotFoundException cnf) 
        {
            System.out.println("ClassNotFoundException:::::::::::" + cnf.getMessage());
        }  
        catch (SQLException ex) {
            System.out.println("SQL EXception::::::" + ex.getMessage());
        }
        
    }
















//
//    /**
//     * Test of subreturnID method, of class DatabaseHelperSP.
//     */
//    @Test
//    public void testSubreturnID() {
//        try {
//            Class.forName("org.h2.Driver");
//            Connection conn = DriverManager.getConnection("jdbc:h2:tcp://localhost/~/test", "sa", "");
//            PreparedStatement ps0 = conn.prepareStatement("CREATE TABLE WorkTask( WorkTask_ID INTEGER AUTO_INCREMENT NOT NULL, WorkModel_ID INTEGER NOT NULL, WorkTaskName NVARCHAR(50) NOT NULL, WorkTaskDescription NVARCHAR(200) NULL, WorkModel_Ratio FLOAT NOT NULL, DTStamp datetime NOT NULL)");
//            ps0.execute();
//            
//            PreparedStatement s0 = conn.prepareStatement("INSERT INTO WorkTask(WorkModel_ID, WorkTaskName, WorkTaskDescription, WorkModel_Ratio, DTStamp) VALUES (?, ?, ?, ?, ?)");
//            s0.setInt(1, 1);
//            s0.setString(2, "Test Task Name");
//            s0.setString(3, "Test Description");
//            s0.setFloat(4, 3);
//            Timestamp t0 = new Timestamp(System.currentTimeMillis());
//            s0.setTimestamp(5, t0);
//            int a0 = s0.executeUpdate();
//            
////            if(a0>0){
////                System.out.println("Row updated0");
////            }
//            
//            PreparedStatement ps = conn.prepareStatement("CREATE TABLE WorkSubModel( WorkSubModel_ID INTEGER AUTO_INCREMENT NOT NULL, WorkModel_ID INTEGER NOT NULL, WorkSubModelName NVARCHAR(50) NOT NULL, WorkSubModelDescription NVARCHAR(200) NULL, DTStamp datetime NOT NULL)");
//            ps.execute();            
//            
//            PreparedStatement s = conn.prepareStatement("INSERT INTO WorkSubModel(WorkModel_ID, WorkSubModelName, WorkSubModelDescription, DTStamp) VALUES (?, ?, ?, ?)");
//            s.setInt(1, 1);
//            s.setString(2, "Test Sub Model");
//            s.setString(3, "Test Description");
//            Timestamp t = new Timestamp(System.currentTimeMillis());
//            s.setTimestamp(4, t);
//            int a = s.executeUpdate();
//            
////            if(a>0){
////                System.out.println("Row updated");
////            }
//            
//            System.out.println("subreturnID");
//            String name = "Test Sub Model";
//            int expResult = 1;
//            int result = DatabaseHelperSP.subreturnID(conn, name);
//            assertEquals(expResult, result);
//            // TODO review the generated test code and remove the default call to fail.
////            fail("The test case is a prototype.");
//            PreparedStatement prepstmt0 = conn.prepareStatement("DROP TABLE WorkTask");
//            prepstmt0.execute();
//            PreparedStatement prepstmt = conn.prepareStatement("DROP TABLE WorkSubModel");
//            prepstmt.execute();
//            conn.close();
//        }
//          
//        catch (ClassNotFoundException cnf) 
//        {
//            System.out.println("ClassNotFoundException:::::::::::" + cnf.getMessage());
//        }  
//        catch (SQLException ex) {
//            System.out.println("SQL EXception::::::" + ex.getMessage());
//        }
//    }
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//    
//
//    /**
//     * Test of subreturnTskID method, of class DatabaseHelperSP.
//     */
//    @Test
//    public void testSubreturnTskID() {
//        try {
//            Class.forName("org.h2.Driver");
//            Connection conn = DriverManager.getConnection("jdbc:h2:tcp://localhost/~/test", "sa", "");
//            
//            PreparedStatement ps0 = conn.prepareStatement("CREATE TABLE WorkTask( WorkTask_ID INTEGER AUTO_INCREMENT NOT NULL, WorkModel_ID INTEGER NOT NULL, WorkTaskName NVARCHAR(50) NOT NULL, WorkTaskDescription NVARCHAR(200) NULL, WorkModel_Ratio FLOAT NOT NULL, DTStamp datetime NOT NULL)");
//            ps0.execute();
//            
//            PreparedStatement s = conn.prepareStatement("INSERT INTO WorkTask(WorkModel_ID, WorkTaskName, WorkTaskDescription, WorkModel_Ratio, DTStamp) VALUES (?, ?, ?, ?, ?)");
//            s.setInt(1, 1);
//            s.setString(2, "Test Task Name");
//            s.setString(3, "Test Description");
//            s.setFloat(4, 3);
//            Timestamp t = new Timestamp(System.currentTimeMillis());
//            s.setTimestamp(5, t);
//            int a = s.executeUpdate();
//            
//            if(a>0){
//                System.out.println("Row updated");
//            }
//            
//            
//            System.out.println("subreturnTskID");
//            String name = "Test Task Name";
//            Integer modId = 1;
//            int expResult = 1;
//            int result = DatabaseHelperSP.subreturnTskID(conn, name, modId);
//            assertEquals(expResult, result);
//            // TODO review the generated test code and remove the default call to fail.
////            fail("The test case is a prototype.");
//            PreparedStatement prepstmt = conn.prepareStatement("DROP TABLE WorkTask");
//            prepstmt.execute();
//            conn.close();
//        }
//          
//        catch (ClassNotFoundException cnf) 
//        {
//            System.out.println("ClassNotFoundException:::::::::::" + cnf.getMessage());
//        }  
//        catch (SQLException ex) {
//            System.out.println("SQL EXception::::::" + ex.getMessage());
//        }
//    }
//
//    
//    
//    
//    
//    
//    
//    /**
//     * Test of checkWorkTask method, of class DatabaseHelperSP.
//     */
//    @Test
//    public void testCheckWorkTask() {
//        try {
//            Class.forName("org.h2.Driver");
//            Connection conn = DriverManager.getConnection("jdbc:h2:tcp://localhost/~/test", "sa", "");
//            System.out.println("connected to h2 driver yayy");
//            PreparedStatement ps = conn.prepareStatement("CREATE TABLE WorkTask( WorkTask_ID INTEGER AUTO_INCREMENT NOT NULL, WorkModel_ID INTEGER NOT NULL, WorkTaskName NVARCHAR(50) NOT NULL, WorkTaskDescription NVARCHAR(200) NULL, WorkModel_Ratio FLOAT NOT NULL, DTStamp datetime NOT NULL)");
//            ps.execute();
//            
//            PreparedStatement s = conn.prepareStatement("INSERT INTO WorkTask(WorkModel_ID, WorkTaskName, WorkTaskDescription, WorkModel_Ratio, DTStamp) VALUES (?, ?, ?, ?, ?)");
//            s.setInt(1, 1);
//            s.setString(2, "Test Task Name");
//            s.setString(3, "Test Description");
//            s.setFloat(4, 3);
//            Timestamp t = new Timestamp(System.currentTimeMillis());
//            s.setTimestamp(5, t);
//            int a = s.executeUpdate();
//            
////            if(a>0){
////                System.out.println("Row updated");
////            }
//            
//            System.out.println("checkWorkTask");
//            Integer id = 1;
//            String expResult = "rs3: columns: 3 rows: 1 pos: 1";    // i ran this and printed result (commented out below) to find this
//            // expResult needs to be hard coded result set. need to learn what it will print like and put it here
//            // i though commenting out (PrepStmt s = blah blah)(lines 213 - 224) would mean returned resultset = null, and test would pass, but it failed. 
//            // need to look into this one more
//            ResultSet result = DatabaseHelperSP.checkWorkTask(conn, id);
////            System.out.println(result);
//            assertEquals(expResult, result.toString());
//            // TODO review the generated test code and remove the default call to fail.
////            fail("The test case is a prototype.");
//            PreparedStatement prepstmt = conn.prepareStatement("DROP TABLE WorkTask");
//            prepstmt.execute();
//            conn.close();
//        }
//          
//        catch (ClassNotFoundException cnf) 
//        {
//            System.out.println("ClassNotFoundException:::::::::::" + cnf.getMessage());
//        }  
//        catch (SQLException ex) {
//            System.out.println("SQL EXception::::::" + ex.getMessage());
//        }
//    }
//
//    /**
//     * Test of checkWorkSubTask method, of class DatabaseHelperSP.
//     */
//    @Test
//    public void testCheckWorkSubTask() {
//        try {
//            Class.forName("org.h2.Driver");
//            Connection conn = DriverManager.getConnection("jdbc:h2:tcp://localhost/~/test", "sa", "");
//            System.out.println("connected to h2 driver yayy");
//            
//            PreparedStatement ps = conn.prepareStatement("CREATE TABLE SubModelTask(SubModelTask_ID INTEGER AUTO_INCREMENT NOT NULL, WorkSubModel_ID INTEGER NOT NULL, WorkTask_ID INTEGER AUTO_INCREMENT NOT NULL, DTStamp datetime NOT NULL)");
//            ps.execute();
//            
//            PreparedStatement s = conn.prepareStatement("INSERT INTO SubModelTask(SubModelTask_ID, WorkSubModel_ID, WorkTask_ID, DTStamp) VALUES (?, ?, ?, ?)");
//            s.setInt(1, 1);
//            s.setInt(2, 1);
//            s.setInt(3, 1);
//            Timestamp t = new Timestamp(System.currentTimeMillis());
//            s.setTimestamp(5, t);
//            int a = s.executeUpdate();
//            
//            System.out.println("checkWorkSubTask");
//            Integer subId = 1;
//            String expResult = "";
//            ResultSet result = DatabaseHelperSP.checkWorkSubTask(conn, subId);
//            assertEquals(expResult, result.toString());
//            // TODO review the generated test code and remove the default call to fail.
//            fail("The test case is a prototype.");
//            
//            PreparedStatement prepstmt = conn.prepareStatement("DROP TABLE SubModelTask");
//            prepstmt.execute();
//            conn.close();
//        }
//        
//        catch (ClassNotFoundException cnf) 
//        {
//            System.out.println("ClassNotFoundException:::::::::::" + cnf.getMessage());
//        }  
//        catch (SQLException ex) {
//            System.out.println("SQL EXception::::::" + ex.getMessage());
//        }
//    }
//    
//    
//
//    /**
//     * Test of checkTaskBand method, of class DatabaseHelperSP.
//     */
//    @Test
//    public void testCheckTaskBand() {
//        System.out.println("checkTaskBand");
//        Integer workTskId = null;
//        ResultSet expResult = null;
//        ResultSet result = DatabaseHelperSP.checkTaskBand(workTskId);
//        assertEquals(expResult, result);
//        // TODO review the generated test code and remove the default call to fail.
//        fail("The test case is a prototype.");
//    }
//
//    /**
//     * Test of checkWorkTaskName method, of class DatabaseHelperSP.
//     */
//    @Test
//    public void testCheckWorkTaskName() {
//        System.out.println("checkWorkTaskName");
//        String name = "";
//        Integer id = null;
//        ResultSet expResult = null;
//        ResultSet result = DatabaseHelperSP.checkWorkTaskName(name, id);
//        assertEquals(expResult, result);
//        // TODO review the generated test code and remove the default call to fail.
//        fail("The test case is a prototype.");
//    }
//
//    /**
//     * Test of checkSubWorkTaskName method, of class DatabaseHelperSP.
//     */
//    @Test
//    public void testCheckSubWorkTaskName() {
//        System.out.println("checkSubWorkTaskName");
//        Integer subId = null;
//        Integer taskId = null;
//        ResultSet expResult = null;
//        ResultSet result = DatabaseHelperSP.checkSubWorkTaskName(subId, taskId);
//        assertEquals(expResult, result);
//        // TODO review the generated test code and remove the default call to fail.
//        fail("The test case is a prototype.");
//    }
//
//    /**
//     * Test of checkTaskBandName method, of class DatabaseHelperSP.
//     */
//    @Test
//    public void testCheckTaskBandName() {
//        System.out.println("checkTaskBandName");
//        Integer worktskID = null;
//        String bandName = "";
//        Float weight = null;
//        ResultSet expResult = null;
//        ResultSet result = DatabaseHelperSP.checkTaskBandName(worktskID, bandName, weight);
//        assertEquals(expResult, result);
//        // TODO review the generated test code and remove the default call to fail.
//        fail("The test case is a prototype.");
//    }
//
//    /**
//     * Test of insertWorkModelData method, of class DatabaseHelperSP.
//     */
//    @Test
//    public void testInsertWorkModelData() {
//********* testing started but not finished    
//        System.out.println("Insert Work Model Data");
//        String insertWorkModelData = "{call insertWorkModelData('hm','asdf')}";
        
//        try {
//            Class.forName("org.h2.Driver");
//            Connection conn = DriverManager.getConnection("jdbc:h2:tcp://localhost/~/test", "sa", "");
//            PreparedStatement ps = conn.prepareStatement("CREATE TABLE WorkModel (WorkModel_ID INTEGER AUTO_INCREMENT NOT NULL, WorkModelName NVARCHAR(50) NOT NULL, WorkModelDescription NVARCHAR(200) NULL, DTStamp datetime NOT NULL)");
//            ps.execute();
//            
//            System.out.println("insertWorkModelData");
//            String name = "Test Model Name";
//            String descr = "Test Model Description";
//            Timestamp t = new Timestamp(System.currentTimeMillis());
//            Timestamp dtstamp = t;
//            DatabaseHelperSP.insertWorkModelData(conn, name, descr, dtstamp);
//            // TODO review the generated test code and remove the default call to fail.
////            fail("The test case is a prototype.");
//
//            String SQL = "SELECT * FROM WorkModel WHERE WorkModelName='" + name + "'";
//            Statement s = conn.createStatement();
//            ResultSet rs = s.executeQuery(SQL);
//            
//            // this method in DBHelper class needs to return a result set or and int or something so we have osmehting to test against
//            // assertEquals(expected, result);
//            
//            PreparedStatement prepstmt = conn.prepareStatement("DROP TABLE WorkModel");
//            prepstmt.execute();
//            conn.close();
//        }
//          
//        catch (ClassNotFoundException cnf) 
//        {
//            System.out.println("ClassNotFoundException:::::::::::" + cnf.getMessage());
//        }  
//        catch (SQLException ex) {
//            System.out.println("SQL EXception::::::" + ex.getMessage());
//        }
//    }
//
//    /**
//     * Test of insertIntoTaskTable method, of class DatabaseHelperSP.
//     */
//    @Test
//    public void testInsertIntoTaskTable() {
//        System.out.println("insertIntoTaskTable");
//        Integer workModelId = null;
//        String taskName = "";
//        String taskDescr = "";
//        Float workModelRatio = null;
//        Timestamp dtstamp = null;
//        DatabaseHelperSP.insertIntoTaskTable(workModelId, taskName, taskDescr, workModelRatio, dtstamp);
//        // TODO review the generated test code and remove the default call to fail.
//        fail("The test case is a prototype.");
//    }
//
//    /**
//     * Test of insertWorkSubModelData method, of class DatabaseHelperSP.
//     */
//    @Test
//    public void testInsertWorkSubModelData() {
//        System.out.println("insertWorkSubModelData");
//        Integer id = null;
//        String name = "";
//        String descr = "";
//        Timestamp dtstamp = null;
//        DatabaseHelperSP.insertWorkSubModelData(id, name, descr, dtstamp);
//        // TODO review the generated test code and remove the default call to fail.
//        fail("The test case is a prototype.");
//    }
//
//    /**
//     * Test of insertIntoSubTaskTable method, of class DatabaseHelperSP.
//     */
//    @Test
//    public void testInsertIntoSubTaskTable() {
//        System.out.println("insertIntoSubTaskTable");
//        Integer worksubModelId = null;
//        Integer workTaskId = null;
//        Timestamp dtstamp = null;
//        DatabaseHelperSP.insertIntoSubTaskTable(worksubModelId, workTaskId, dtstamp);
//        // TODO review the generated test code and remove the default call to fail.
//        fail("The test case is a prototype.");
//    }
//
//    /**
//     * Test of insertIntoTaskBandTable method, of class DatabaseHelperSP.
//     */
//    @Test
//    public void testInsertIntoTaskBandTable() {
//        System.out.println("insertIntoTaskBandTable");
//        Integer workTskBand = null;
//        String taskBandName = "";
//        Float workTskWeight = null;
//        Timestamp dtStamp = null;
//        DatabaseHelperSP.insertIntoTaskBandTable(workTskBand, taskBandName, workTskWeight, dtStamp);
//        // TODO review the generated test code and remove the default call to fail.
//        fail("The test case is a prototype.");
//    }
//
//    /**
//     * Test of deleteTask method, of class DatabaseHelperSP.
//     */
//    @Test
//    public void testDeleteTask() {
//        System.out.println("deleteTask");
//        String taskName = "";
//        Integer id = null;
//        DatabaseHelperSP.deleteTask(taskName, id);
//        // TODO review the generated test code and remove the default call to fail.
//        fail("The test case is a prototype.");
//    }
//
//    /**
//     * Test of deleteBand method, of class DatabaseHelperSP.
//     */
//    @Test
//    public void testDeleteBand() {
//        System.out.println("deleteBand");
//        String bandName = "";
//        Integer taskId = null;
//        DatabaseHelperSP.deleteBand(bandName, taskId);
//        // TODO review the generated test code and remove the default call to fail.
//        fail("The test case is a prototype.");
//    }
//
//    /**
//     * Test of returnWorkModelNames method, of class DatabaseHelperSP.
//     */
//    @Test
//    public void testReturnWorkModelNames() {
//        try {
//            Class.forName("org.h2.Driver");
//            Connection conn = DriverManager.getConnection("jdbc:h2:tcp://localhost/~/test", "sa", "");
//            PreparedStatement ps = conn.prepareStatement("CREATE TABLE WorkModel (WorkModel_ID INTEGER AUTO_INCREMENT NOT NULL, WorkModelName NVARCHAR(50) NOT NULL, WorkModelDescription NVARCHAR(200) NULL, DTStamp datetime NOT NULL)");
//            ps.execute();
//            
//            PreparedStatement s = conn.prepareStatement("INSERT INTO WorkModel(WorkModelName, WorkModelDescription, DTStamp) VALUES (?, ?, ?)");
//            s.setString(1, "Test Name");
//            s.setString(2, "Description");
//            Timestamp t = new Timestamp(System.currentTimeMillis());
//            s.setTimestamp(3, t);
//            int a = s.executeUpdate();
////            if(a>0){
////                System.out.println("Row updated"); 
////            }
//            
//            System.out.println("returnWorkModelNames");
//            ResultSet expResult = null;
////            // expResult needs to be hard coded result set. need to learn what it will print like and put it here
////            // i though commenting out (PrepStmt s = blah blah)(lines 457 - 465) would mean returned resultset = null, and test would pass, but it failed. 
////            // need to look into this one more
//            ResultSet result = DatabaseHelperSP.returnWorkModelNames(conn);
//            System.out.println(result);
//            assertEquals(expResult, result);
//            // TODO review the generated test code and remove the default call to fail.
////            fail("The test case is a prototype.");
//            PreparedStatement prepstmt = conn.prepareStatement("DROP TABLE WorkModel");
//            prepstmt.execute();
//            conn.close();
//        }
//          
//        catch (ClassNotFoundException cnf) 
//        {
//            System.out.println("ClassNotFoundException:::::::::::" + cnf.getMessage());
//        }  
//        catch (SQLException ex) {
//            System.out.println("SQL EXception::::::" + ex.getMessage());
//        }
//    }
    
}
