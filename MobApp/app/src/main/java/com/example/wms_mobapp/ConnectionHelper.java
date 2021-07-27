package com.example.wms_mobapp;

import android.annotation.SuppressLint;
import android.os.StrictMode;
import android.util.Log;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class ConnectionHelper {
//    String ip;
//    String db;
//    String userName;
//    String password;


    @SuppressLint("NewApi")
    public static Connection connectionclass()
    {
//        enter db info here
        String ip = "192.168.0.213";
        String db = "RUNRH";
        String userName = "sa";
        String password = "ca400";

        StrictMode.ThreadPolicy policy = new StrictMode.ThreadPolicy.Builder().permitAll().build();
        StrictMode.setThreadPolicy(policy);
        java.sql.Connection connection = null;
        String ConnectionURL;
        try
        {
            Class.forName("net.sourceforge.jtds.jdbc.Driver");
//            ConnectionURL = "jdbc:jtds:sqlserver://database-1.chx79b5ss8ae.us-east-1.rds.amazonaws.com;DatabaseName=AWSWMS;user=adminUsername;password=adminPassword;";
            ConnectionURL = "jdbc:jtds:sqlserver://" + ip +";DatabaseName="+ db + ";user=" + userName+ ";password=" + password + ";";
            connection = DriverManager.getConnection(ConnectionURL);
            System.out.println("Connected!");
        }
        catch (SQLException se)
        {
            Log.e("error 1 : ", se.getMessage());
            System.out.println("Error 1: " + se);
        }
        catch (ClassNotFoundException e)
        {
            Log.e("error 2 : ", e.getMessage());
            System.out.println("Error 2: " + e);
        }
        catch (Exception e)
        {
            Log.e("error 3 : ", e.getMessage());
            System.out.println("Error 3: " + e);
        }
//        System.out.println("connection: " + connection);
        return connection;

    }
}

