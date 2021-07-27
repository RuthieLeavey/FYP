package com.example.wms_mobapp;

import junit.framework.TestCase;
import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.DriverManager;
import java.sql.SQLException;

public class ConnectionHelperTest extends TestCase {

    public void testConnectionclass() throws SQLException {
//        Connection result = null;
//        // Build the connection string, and get a connection
//        System.out.println("testConnectionclass");
//        String connectionUrl = "jdbc:jtds:sqlserver://database-1.chx79b5ss8ae.us-east-1.rds.amazonaws.com;DatabaseName=WEEK;user=adminUsername;password=adminPassword;";
//        try {
//            Class.forName("net.sourceforge.jtds.jdbc.Driver");
//            result = DriverManager.getConnection(connectionUrl);
//            DatabaseMetaData dm = (DatabaseMetaData) result.getMetaData();
//            System.out.println("Driver name: " + dm.getDriverName());
//        } catch (ClassNotFoundException e) {
//            e.printStackTrace();
//        }
//        System.out.println("Connected.");
//        assertEquals(result != null, true);
    }
}