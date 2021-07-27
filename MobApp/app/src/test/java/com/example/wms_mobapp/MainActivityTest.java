package com.example.wms_mobapp;

import android.os.StrictMode;

import junit.framework.TestCase;

import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.DriverManager;
import java.sql.SQLException;

public class MainActivityTest extends TestCase {

    public void testOnCreate() {
    }

    public void testClickListenerLoginButton() {
    }

    public void testEnsureNoEmptyFields() {
    }

    public void testCheckForCorrectPassword() {
    }

    public void testIsPasswordCorrect() {
//        System.out.println("testIsPasswordCorrect");
//
//        Connection conn = null;
//        String connectionUrl = "jdbc:jtds:sqlserver://database-1.chx79b5ss8ae.us-east-1.rds.amazonaws.com;DatabaseName=WEEK;user=adminUsername;password=adminPassword;";
//        try {
//            Class.forName("net.sourceforge.jtds.jdbc.Driver");
//            conn = DriverManager.getConnection(connectionUrl);
//            DatabaseMetaData dm = (DatabaseMetaData) conn.getMetaData();
//            System.out.println("Driver name: " + dm.getDriverName());
//        } catch (ClassNotFoundException | SQLException e) {e.printStackTrace(); }
//        System.out.println("Connected.");
//
//        String user = "RN1";
//        String pw = "RN1";
//        char[] input = pw.toCharArray();
//        boolean expResult = true;
//        boolean result = MainActivity.isPasswordCorrect(conn, user, input);
//        assertEquals(expResult, result);
    }

    public void testGetPassword() {
//        System.out.println("testGetPassword");
//        Connection conn = null;
//        String connectionUrl = "jdbc:jtds:sqlserver://database-1.chx79b5ss8ae.us-east-1.rds.amazonaws.com;DatabaseName=WEEK;user=adminUsername;password=adminPassword;";
//        try {
//            Class.forName("net.sourceforge.jtds.jdbc.Driver");
//            conn = DriverManager.getConnection(connectionUrl);
//            DatabaseMetaData dm = (DatabaseMetaData) conn.getMetaData();
//            System.out.println("Driver name: " + dm.getDriverName());
//        } catch (ClassNotFoundException | SQLException e) {e.printStackTrace(); }
//        System.out.println("Connected.");
//        String user = "RN1";
//        String expResult = "RN1";
//        String result = MainActivity.getPassword(conn, user);
//        assertEquals(result!=null, true);
//        assertEquals(expResult, result);
    }

    public void testGetStaffId() {
//        System.out.println("testGetStaffId");
//        Connection conn = null;
//        String connectionUrl = "jdbc:jtds:sqlserver://database-1.chx79b5ss8ae.us-east-1.rds.amazonaws.com;DatabaseName=WEEK;user=adminUsername;password=adminPassword;";
//        try {
//            Class.forName("net.sourceforge.jtds.jdbc.Driver");
//            conn = DriverManager.getConnection(connectionUrl);
//            DatabaseMetaData dm = (DatabaseMetaData) conn.getMetaData();
//            System.out.println("Driver name: " + dm.getDriverName());
//        } catch (ClassNotFoundException | SQLException e) {e.printStackTrace(); }
//        System.out.println("Connected.");
//        String user = "RN1";
//        Integer expResult = 2;
//        Integer result = MainActivity.getStaffId(conn, user);
//        assertEquals(result!=null, true);
//        assertEquals(expResult, result);
    }
}