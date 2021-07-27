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
import org.junit.Rule;

/**
 *
 * @author harle
 */
public class HomePageTest {
    Connection conn;
    
    public HomePageTest() {
    }
    
    @BeforeClass
    public static void setUpClass() {
    }
    
    @AfterClass
    public static void tearDownClass() {
    }
    
    @Before
    public void setUp() {
        try {
        Class.forName("org.h2.Driver");  // jar file needs to be in project library or this line wont work
        conn = DriverManager.getConnection("jdbc:h2:~/test,username='sa',password=''");
        // above lines throws error if H2 is not running on machine when this file has been run 
        // Connection is broken: "java.net.SocketTimeoutException: Connect timed out: localhost" [90067-200]
        // for this to work, press windows key, type H2, click H2 console
        // the little yellow square H2 icon should appear in the windows taskbar (maybe press arrow in taskbar) 
        // and a browser should open localhost:8082/login.jsp? blah blah blah 
        // ^^^^ these comments were for when we were connection to H2 in server mode. 
        // now the we are connectin gin embedded mode these comments dont matter
    }    
    catch (ClassNotFoundException cnf) {
        System.out.println("ClassNotFounsException::::::: " + cnf.getMessage());
    }
    catch (SQLException e) {
        System.out.println("SQLEXception::::::::::::: " + e.getMessage());
    }
    }
    
    @After
    public void tearDown() {
    }

    /**
     * Test of getRemoteConnection method, of class HomePage.
     */
    @Test
    public void testGetRemoteConnection() {
        /* i used the following lines to get the H2 driver name and version, in order to hard code them into the expected results variables
        
        Class.forName("org.h2.Driver");
        Connection conn = DriverManager.getConnection("jdbc:h2:tcp://localhost/~/test", "sa", ""); 
        DatabaseMetaData dm = (DatabaseMetaData) conn.getMetaData();
        System.out.println("Driver name: " + dm.getDriverName());
        System.out.println("Driver version: " + dm.getDriverVersion());
        */
        
        try {            
            System.out.println("getRemoteConnection");
            String dbDriver = "org.h2.Driver";  // when this string is passed into the HP method it is not registered as a driver
            // dont know why it wont register bc the other tests here can register it fine on their own 
            // also the HP method can register the driver passed to it on a regular run on the application 
            // i wrote comments in the HP method getRemoteConnectoin to explain the problem for when i come back to try and fix it
            // String dbURL = "'jdbc:h2:tcp://localhost/~/test', 'sa', ''";
            // when dbDriver and dbURL are passed as params, an error occurs that says no suitable Driver for this URL
            // at first it sounded like the driver was the problem 
            // but then I tested TestGetStaffType with the URL as a string variable instead of a string literal
            // this produced the same "no suitable driver for this URL" error
            // which makes more sense anyway bc the URL string contains quotation marks itself which makes it error prone
            // URL format error; must be "jdbc:h2:{ {.|mem:}[name] | [file:]fileName | {tcp|ssl}:[//]server[:port][,server2[:port]]/name }[;key=value...]"
            // FIXED IT: the dbURL was giving the problem, it was connectiong to H2 server mode
            String dbURL = "jdbc:h2:~/test,username='sa',password=''";  // this fixed the problem, connectin gto H2 embedded mode
            String expDriverName = "H2 JDBC Driver";
            String expDriverVersion = "1.4.200 (2019-10-14)";
            System.out.println("test file about to run home page method");
            Connection result = HomePage.getRemoteConnection(dbDriver, dbURL);
            assertEquals(expDriverName, result.getMetaData().getDriverName());
            assertEquals(expDriverVersion, result.getMetaData().getDriverVersion());
        }
        catch (SQLException ex) {
            
            System.out.println("SQL EXception::::::" + ex.getMessage());
        }
        
    }
    
//    /**
//     * Test of getRemoteConnection method, of class HomePage.
//     */
//    @Test
//    public void testGetRemoteConnection2() {
////        @Rule
////         ClassNotFoundException thrown = ClassNotFoundException.class;
//        /* i used the following lines to get the H2 driver name and version, in order to hard code them into the expected results variables
//        
//        Class.forName("org.h2.Driver");
//        Connection conn = DriverManager.getConnection("jdbc:h2:tcp://localhost/~/test", "sa", ""); 
//        DatabaseMetaData dm = (DatabaseMetaData) conn.getMetaData();
//        System.out.println("Driver name: " + dm.getDriverName());
//        System.out.println("Driver version: " + dm.getDriverVersion());
//        */
////        @Test
////        public void testFooThrowsIndexOutOfBoundsException() {
////            Throwable exception = assertThrows(ClassNotFoundException.class, () -> HomePage.getRemoteConnection(dbDriver, dbURL));
////            assertEquals("ClassNotFoundException:::::::::::org.h2.Driverqwerty", exception.getMessage());
////        }
////        try {            
//            System.out.println("getRemoteConnection");
//            String dbDriver = "org.h2.Driverqwerty";  
//            String dbURL = "jdbc:h2:~/test,username='sa',password=''";  
//            String expDriverName = "H2 JDBC Driver";
//            String expDriverVersion = "1.4.200 (2019-10-14)";
//            System.out.println("test file about to run home page method");
//            ClassNotFoundException exception = assertThrows(ClassNotFoundException.class, () -> HomePage.getRemoteConnection(dbDriver, dbURL));
//            assertTrue(exception.getMessage().contains("org.h2.Driverqwerty"));
////            assertEquals("ClassNotFoundException:::::::::::org.h2.Driverqwerty", exception.getMessage());
//            Connection result = HomePage.getRemoteConnection(dbDriver, dbURL);
////            thrown.expectMessage("My custom runtime exception");
////            assertEquals(expDriverName, result.getMetaData().getDriverName());
////            assertEquals(expDriverVersion, result.getMetaData().getDriverVersion());
////        }
////        catch (SQLException ex) {
////            
////            System.out.println("SQL EXception::::::" + ex.getMessage());
////        }
//        
//    }

    /**
     * Test of getStaffType method, of class HomePage.
     * insert one user into DB and test that their staff_ID is retrieved
     */
    @Test
    public void testGetStaffType() {
        try {
            System.out.println("getStaffType"); 
            PreparedStatement ps1 = conn.prepareStatement("DROP TABLE IF EXISTS Staff");
            ps1.execute();
            PreparedStatement ps2 = conn.prepareStatement("CREATE TABLE Staff ("
                    + "Staff_ID INTEGER AUTO_INCREMENT NOT NULL, "
                    + "Unique_ID NVARCHAR(100) NOT NULL, "
                    + "Password NVARCHAR(100) NOT NULL, "
                    + "StaffType_ID INTEGER NOT NULL)");
            ps2.execute();
            PreparedStatement ps3 = conn.prepareStatement("INSERT INTO Staff (Unique_ID, Password, StaffType_ID) VALUES (?, ?, ?)");
            ps3.setString(1, "some_username");
            ps3.setString(2, "some_pw");
            ps3.setInt(3, 239);
            ps3.executeUpdate();
            
            String user = "some_username";
            Integer expResult = 239;
            Integer result = HomePage.getStaffType(conn, user);
            assertEquals(expResult, result);
            
            PreparedStatement psdroptable = conn.prepareStatement("DROP TABLE IF EXISTS Staff");
            psdroptable.execute();
        }
        
        catch (SQLException ex) {
            System.out.println("SQL EXception::::::" + ex.getMessage());
        }
    }    
    
    /**
     * Test of getStaffType method, of class HomePage.
     * insert two users into DB and test that the correct staff_ID is retrieved for one user
     */
    @Test
    public void testGetStaffType2() {
        try {
            System.out.println("getStaffType"); 
            PreparedStatement ps1 = conn.prepareStatement("DROP TABLE IF EXISTS Staff");
            ps1.execute();
            PreparedStatement ps2 = conn.prepareStatement("CREATE TABLE Staff ("
                    + "Staff_ID INTEGER AUTO_INCREMENT NOT NULL, "
                    + "Unique_ID NVARCHAR(100) NOT NULL, "
                    + "Password NVARCHAR(100) NOT NULL, "
                    + "StaffType_ID INTEGER NOT NULL)");
            ps2.execute();
            PreparedStatement ps3 = conn.prepareStatement("INSERT INTO Staff (Unique_ID, Password, StaffType_ID) VALUES (?, ?, ?)");
            ps3.setString(1, "some_username");
            ps3.setString(2, "some_pw");
            ps3.setInt(3, 239);
            ps3.executeUpdate();
            PreparedStatement ps4 = conn.prepareStatement("INSERT INTO Staff (Unique_ID, Password, StaffType_ID) VALUES (?, ?, ?)");
            ps3.setString(1, "some_username2");
            ps3.setString(2, "some_pw2");
            ps3.setInt(3, 240);
            ps4.executeUpdate();
            
            String user = "some_username2";
            Integer expResult = 240;
            Integer result = HomePage.getStaffType(conn, user);
            assertEquals(expResult, result);
            
            PreparedStatement psdroptable = conn.prepareStatement("DROP TABLE IF EXISTS Staff");
            psdroptable.execute();
        }
        
        catch (SQLException ex) {
            System.out.println("SQL EXception::::::" + ex.getMessage());
        }
    }
    
    /**
     * Test of getStaffType method, of class HomePage.
     * insert one user into DB and test that no staff_ID is returned when a non-existent username is searched
     */
    @Test
    public void testGetStaffType3() {
        try {
            System.out.println("getStaffType"); 
            PreparedStatement ps1 = conn.prepareStatement("DROP TABLE IF EXISTS Staff");
            ps1.execute();
            PreparedStatement ps2 = conn.prepareStatement("CREATE TABLE Staff ("
                    + "Staff_ID INTEGER AUTO_INCREMENT NOT NULL, "
                    + "Unique_ID NVARCHAR(100) NOT NULL, "
                    + "Password NVARCHAR(100) NOT NULL, "
                    + "StaffType_ID INTEGER NOT NULL)");
            ps2.execute();
            PreparedStatement ps3 = conn.prepareStatement("INSERT INTO Staff (Unique_ID, Password, StaffType_ID) VALUES (?, ?, ?)");
            ps3.setString(1, "some_username");
            ps3.setString(2, "some_pw");
            ps3.setInt(3, 239);
            ps3.executeUpdate();
            
            String user = "some_username_that_doesnt_exist_in_db";
            Integer expResult = 0;
            Integer result = HomePage.getStaffType(conn, user);
            assertEquals(expResult, result);
            
            PreparedStatement psdroptable = conn.prepareStatement("DROP TABLE IF EXISTS Staff");
            psdroptable.execute();
        }
        
        catch (SQLException ex) {
            System.out.println("SQL EXception::::::" + ex.getMessage());
        }
    }

    /**
     * Test of getPassword method, of class HomePage.
     * insert one user into DB and test that their password is retrieved
     */
    @Test
    public void testGetPassword() {
        try {
            System.out.println("getPassword");
            PreparedStatement ps1 = conn.prepareStatement("DROP TABLE IF EXISTS Staff");
            ps1.execute();
            PreparedStatement ps2 = conn.prepareStatement("CREATE TABLE Staff ("
                    + "Staff_ID INTEGER AUTO_INCREMENT NOT NULL, "
                    + "Unique_ID NVARCHAR(100) NOT NULL, "
                    + "Password NVARCHAR(100) NOT NULL, "
                    + "StaffType_ID INTEGER NOT NULL)");
            ps2.execute();
            PreparedStatement ps3 = conn.prepareStatement("INSERT INTO Staff (Unique_ID, Password, StaffType_ID) VALUES (?, ?, ?)");
            ps3.setString(1, "some_username");
            ps3.setString(2, "some_pw");
            ps3.setInt(3, 239);
            ps3.executeUpdate();
            
            String user = "some_username";
            String expResult = "some_pw";
            String result = HomePage.getPassword(conn, user);
            assertEquals(expResult, result);
            
            PreparedStatement psdroptable = conn.prepareStatement("DROP TABLE IF EXISTS Staff");
            psdroptable.execute();
        } 
        catch (SQLException ex) {
            System.out.println("SQL EXception::::::" + ex.getMessage());
        }
    }
    
    /**
     * Test of getPassword method, of class HomePage.
     * insert two users into DB and test that the correct password is retrieved when one user is searched
     */
    @Test
    public void testGetPassword2() {
        try {
            System.out.println("getPassword");
            PreparedStatement ps1 = conn.prepareStatement("DROP TABLE IF EXISTS Staff");
            ps1.execute();
            PreparedStatement ps2 = conn.prepareStatement("CREATE TABLE Staff ("
                    + "Staff_ID INTEGER AUTO_INCREMENT NOT NULL, "
                    + "Unique_ID NVARCHAR(100) NOT NULL, "
                    + "Password NVARCHAR(100) NOT NULL, "
                    + "StaffType_ID INTEGER NOT NULL)");
            ps2.execute();
            PreparedStatement ps3 = conn.prepareStatement("INSERT INTO Staff (Unique_ID, Password, StaffType_ID) VALUES (?, ?, ?)");
            ps3.setString(1, "some_username");
            ps3.setString(2, "some_pw");
            ps3.setInt(3, 239);
            ps3.executeUpdate();
            PreparedStatement ps4 = conn.prepareStatement("INSERT INTO Staff (Unique_ID, Password, StaffType_ID) VALUES (?, ?, ?)");
            ps3.setString(1, "some_username2");
            ps3.setString(2, "some_pw2");
            ps3.setInt(3, 240);
            ps4.executeUpdate();
            
            String user = "some_username";
            String expResult = "some_pw";
            String result = HomePage.getPassword(conn, user);
            assertEquals(expResult, result);
            
            PreparedStatement psdroptable = conn.prepareStatement("DROP TABLE IF EXISTS Staff");
            psdroptable.execute();
        } 
        catch (SQLException ex) {
            System.out.println("SQL EXception::::::" + ex.getMessage());
        }
    }
    
    /**
     * Test of getPassword method, of class HomePage.
     * insert one user into DB and test that no password is returned when non-existent user is searched
     */
    @Test
    public void testGetPassword3() {
        try {
            System.out.println("getPassword");
            PreparedStatement ps1 = conn.prepareStatement("DROP TABLE IF EXISTS Staff");
            ps1.execute();
            PreparedStatement ps2 = conn.prepareStatement("CREATE TABLE Staff ("
                    + "Staff_ID INTEGER AUTO_INCREMENT NOT NULL, "
                    + "Unique_ID NVARCHAR(100) NOT NULL, "
                    + "Password NVARCHAR(100) NOT NULL, "
                    + "StaffType_ID INTEGER NOT NULL)");
            ps2.execute();
            PreparedStatement ps3 = conn.prepareStatement("INSERT INTO Staff (Unique_ID, Password, StaffType_ID) VALUES (?, ?, ?)");
            ps3.setString(1, "some_username");
            ps3.setString(2, "some_pw");
            ps3.setInt(3, 239);
            ps3.executeUpdate();
            
            String user = "some_username_who_does_not_exist_in_db";
            String expResult = "";
            String result = HomePage.getPassword(conn, user);
            assertEquals(expResult, result);
            
            PreparedStatement psdroptable = conn.prepareStatement("DROP TABLE IF EXISTS Staff");
            psdroptable.execute();
        } 
        catch (SQLException ex) {
            System.out.println("SQL EXception::::::" + ex.getMessage());
        }
    }

    /**
     * Test of isPasswordCorrect method, of class HomePage.
     * insert one user/password into DB and test that a user entered (existing) user/password combo is checked for the (existing) matching set in DB
     */
    @Test
    public void testIsPasswordCorrect() {
        try {
            System.out.println("isPasswordCorrect");
            PreparedStatement ps1 = conn.prepareStatement("DROP TABLE IF EXISTS Staff");
            ps1.execute();
            PreparedStatement ps2 = conn.prepareStatement("CREATE TABLE Staff ("
                    + "Staff_ID INTEGER AUTO_INCREMENT NOT NULL, "
                    + "Unique_ID NVARCHAR(100) NOT NULL, "
                    + "Password NVARCHAR(100) NOT NULL, "
                    + "StaffType_ID INTEGER NOT NULL)");
            ps2.execute();
            PreparedStatement ps3 = conn.prepareStatement("INSERT INTO Staff (Unique_ID, Password, StaffType_ID) VALUES (?, ?, ?)");
            ps3.setString(1, "some_username");
            ps3.setString(2, "abcd");
            ps3.setInt(3, 239);
            int a = ps3.executeUpdate();
            
            String user = "some_username";
            char[] input = new char[4];
            input[0] = 'a';
            input[1] = 'b';
            input[2] = 'c';
            input[3] = 'd';
            boolean expResult = true;
            boolean result = HomePage.isPasswordCorrect(conn, user, input);
            assertEquals(expResult, result);
            
            PreparedStatement psdroptable = conn.prepareStatement("DROP TABLE IF EXISTS Staff");
            psdroptable.execute();
        }
        
        catch (SQLException ex) {
            System.out.println("SQL EXception::::::" + ex.getMessage());
        }
        
    }
    
    /**
     * Test of isPasswordCorrect method, of class HomePage.
     * insert two user/password combos into DB and test that a user entered (existing) user/password combo is checked for the correct (existing) matching set in DB
     */
    @Test
    public void testIsPasswordCorrect2() {
        try {
            System.out.println("isPasswordCorrect");
            PreparedStatement ps1 = conn.prepareStatement("DROP TABLE IF EXISTS Staff");
            ps1.execute();
            PreparedStatement ps2 = conn.prepareStatement("CREATE TABLE Staff ("
                    + "Staff_ID INTEGER AUTO_INCREMENT NOT NULL, "
                    + "Unique_ID NVARCHAR(100) NOT NULL, "
                    + "Password NVARCHAR(100) NOT NULL, "
                    + "StaffType_ID INTEGER NOT NULL)");
            ps2.execute();
            PreparedStatement ps3 = conn.prepareStatement("INSERT INTO Staff (Unique_ID, Password, StaffType_ID) VALUES (?, ?, ?)");
            ps3.setString(1, "some_username");
            ps3.setString(2, "abcd");
            ps3.setInt(3, 239);
            ps3.executeUpdate();
            PreparedStatement ps4 = conn.prepareStatement("INSERT INTO Staff (Unique_ID, Password, StaffType_ID) VALUES (?, ?, ?)");
            ps3.setString(1, "some_username2");
            ps3.setString(2, "abcd2");
            ps3.setInt(3, 239);
            ps4.executeUpdate();
            
            String user = "some_username";
            char[] input = new char[4];
            input[0] = 'a';
            input[1] = 'b';
            input[2] = 'c';
            input[3] = 'd';
            boolean expResult = true;
            boolean result = HomePage.isPasswordCorrect(conn, user, input);
            assertEquals(expResult, result);
            
            PreparedStatement psdroptable = conn.prepareStatement("DROP TABLE IF EXISTS Staff");
            psdroptable.execute();
        }
        
        catch (SQLException ex) {
            System.out.println("SQL EXception::::::" + ex.getMessage());
        }
        
    }
    
    /**
     * Test of isPasswordCorrect method, of class HomePage.
     * insert two user/password combos into DB and test that a user entered (existing) username w (someone else's) password combo is not matched up as acceptable in DB
     */
    @Test
    public void testIsPasswordCorrect3() {
        try {
            System.out.println("isPasswordCorrect");
            PreparedStatement ps1 = conn.prepareStatement("DROP TABLE IF EXISTS Staff");
            ps1.execute();
            PreparedStatement ps2 = conn.prepareStatement("CREATE TABLE Staff ("
                    + "Staff_ID INTEGER AUTO_INCREMENT NOT NULL, "
                    + "Unique_ID NVARCHAR(100) NOT NULL, "
                    + "Password NVARCHAR(100) NOT NULL, "
                    + "StaffType_ID INTEGER NOT NULL)");
            ps2.execute();
            PreparedStatement ps3 = conn.prepareStatement("INSERT INTO Staff (Unique_ID, Password, StaffType_ID) VALUES (?, ?, ?)");
            ps3.setString(1, "some_username");
            ps3.setString(2, "abcd");
            ps3.setInt(3, 239);
            ps3.executeUpdate();
            PreparedStatement ps4 = conn.prepareStatement("INSERT INTO Staff (Unique_ID, Password, StaffType_ID) VALUES (?, ?, ?)");
            ps3.setString(1, "some_username2");
            ps3.setString(2, "abcd2");
            ps3.setInt(3, 239);
            ps4.executeUpdate();
            
            String user = "some_username";
            char[] input = new char[5];
            input[0] = 'a';
            input[1] = 'b';
            input[2] = 'c';
            input[3] = 'd';
            input[4] = '2';
            boolean expResult = false;
            boolean result = HomePage.isPasswordCorrect(conn, user, input);
            assertEquals(expResult, result);
            
            PreparedStatement psdroptable = conn.prepareStatement("DROP TABLE IF EXISTS Staff");
            psdroptable.execute();
        }
        
        catch (SQLException ex) {
            System.out.println("SQL EXception::::::" + ex.getMessage());
        }
        
    }
    
    /**
     * Test of isPasswordCorrect method, of class HomePage.
     * insert one user/password into DB and test that a user entered (existing) user w (non-existing) password combo is not matched up as acceptable in DB
     */
    @Test
    public void testIsPasswordCorrect4() {
        try {
            System.out.println("isPasswordCorrect");
            PreparedStatement ps1 = conn.prepareStatement("DROP TABLE IF EXISTS Staff");
            ps1.execute();
            PreparedStatement ps2 = conn.prepareStatement("CREATE TABLE Staff ("
                    + "Staff_ID INTEGER AUTO_INCREMENT NOT NULL, "
                    + "Unique_ID NVARCHAR(100) NOT NULL, "
                    + "Password NVARCHAR(100) NOT NULL, "
                    + "StaffType_ID INTEGER NOT NULL)");
            ps2.execute();
            PreparedStatement ps3 = conn.prepareStatement("INSERT INTO Staff (Unique_ID, Password, StaffType_ID) VALUES (?, ?, ?)");
            ps3.setString(1, "some_username");
            ps3.setString(2, "abcd");
            ps3.setInt(3, 239);
            int a = ps3.executeUpdate();
            
            String user = "some_username";
            char[] input = new char[4];
            input[0] = '1';
            input[1] = '2';
            input[2] = '3';
            input[3] = '4';
            boolean expResult = false;
            boolean result = HomePage.isPasswordCorrect(conn, user, input);
            assertEquals(expResult, result);
            
            PreparedStatement psdroptable = conn.prepareStatement("DROP TABLE IF EXISTS Staff");
            psdroptable.execute();
        }
        
        catch (SQLException ex) {
            System.out.println("SQL EXception::::::" + ex.getMessage());
        }
        
    }
    
    /**
     * Test of isPasswordCorrect method, of class HomePage.
     * insert one user/password into DB and test that a user entered (non-existing) user w (non-existing) password combo is not matched up as acceptable in DB
     */
    @Test
    public void testIsPasswordCorrect5() {
        try {
            System.out.println("isPasswordCorrect");
            PreparedStatement ps1 = conn.prepareStatement("DROP TABLE IF EXISTS Staff");
            ps1.execute();
            PreparedStatement ps2 = conn.prepareStatement("CREATE TABLE Staff ("
                    + "Staff_ID INTEGER AUTO_INCREMENT NOT NULL, "
                    + "Unique_ID NVARCHAR(100) NOT NULL, "
                    + "Password NVARCHAR(100) NOT NULL, "
                    + "StaffType_ID INTEGER NOT NULL)");
            ps2.execute();
            PreparedStatement ps3 = conn.prepareStatement("INSERT INTO Staff (Unique_ID, Password, StaffType_ID) VALUES (?, ?, ?)");
            ps3.setString(1, "some_username");
            ps3.setString(2, "abcd");
            ps3.setInt(3, 239);
            int a = ps3.executeUpdate();
            
            String user = "some_username2";
            char[] input = new char[4];
            input[0] = '1';
            input[1] = '2';
            input[2] = '3';
            input[3] = '4';
            boolean expResult = false;
            boolean result = HomePage.isPasswordCorrect(conn, user, input);
            assertEquals(expResult, result);
            
            PreparedStatement psdroptable = conn.prepareStatement("DROP TABLE IF EXISTS Staff");
            psdroptable.execute();
        }
        
        catch (SQLException ex) {
            System.out.println("SQL EXception::::::" + ex.getMessage());
        }
        
    }
    
    /**
     * Test of isPasswordCorrect method, of class HomePage.
     * insert one user/password into DB and test that a user entered (non-existing) user w (existing) password combo is not matched up as acceptable in DB
     */
    @Test
    public void testIsPasswordCorrect6  () {
        try {
            System.out.println("isPasswordCorrect");
            PreparedStatement ps1 = conn.prepareStatement("DROP TABLE IF EXISTS Staff");
            ps1.execute();
            PreparedStatement ps2 = conn.prepareStatement("CREATE TABLE Staff ("
                    + "Staff_ID INTEGER AUTO_INCREMENT NOT NULL, "
                    + "Unique_ID NVARCHAR(100) NOT NULL, "
                    + "Password NVARCHAR(100) NOT NULL, "
                    + "StaffType_ID INTEGER NOT NULL)");
            ps2.execute();
            PreparedStatement ps3 = conn.prepareStatement("INSERT INTO Staff (Unique_ID, Password, StaffType_ID) VALUES (?, ?, ?)");
            ps3.setString(1, "some_username");
            ps3.setString(2, "abcd");
            ps3.setInt(3, 239);
            int a = ps3.executeUpdate();
            
            String user = "some_username2";
            char[] input = new char[4];
            input[0] = 'a';
            input[1] = 'b';
            input[2] = 'c';
            input[3] = 'd';
            boolean expResult = false;
            boolean result = HomePage.isPasswordCorrect(conn, user, input);
            assertEquals(expResult, result);
            
            PreparedStatement psdroptable = conn.prepareStatement("DROP TABLE IF EXISTS Staff");
            psdroptable.execute();
        }
        
        catch (SQLException ex) {
            System.out.println("SQL EXception::::::" + ex.getMessage());
        }
        
    }

//    /**
//     * Test of main method, of class HomePage.
//     */
//    @Test
//    public void testMain() {
//        System.out.println("main");
//        String[] args = null;
//        HomePage.main(args);
//        // TODO review the generated test code and remove the default call to fail.
//        fail("The test case is a prototype.");
//    }
    
}
