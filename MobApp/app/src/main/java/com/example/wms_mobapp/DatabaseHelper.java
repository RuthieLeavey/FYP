package com.example.wms_mobapp;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.Date;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class DatabaseHelper {

    //only for test connections!!!
//    public static Connection returnConn(){
//        Connection conn = null;
//        System.out.println("testConnectionclass");
//        String connectionUrl = "jdbc:jtds:sqlserver://database-1.chx79b5ss8ae.us-east-1.rds.amazonaws.com;DatabaseName=WEEK;user=adminUsername;password=adminPassword;";
//        try {
//            Class.forName("net.sourceforge.jtds.jdbc.Driver");
//            conn = DriverManager.getConnection(connectionUrl);
//            DatabaseMetaData dm = (DatabaseMetaData) conn.getMetaData();
//            System.out.println("Driver name: " + dm.getDriverName());
//        } catch (ClassNotFoundException | SQLException e) {
//            e.printStackTrace();
//        }
//        return conn;
//    }

    public static ResultSet returnWardNames(){
        ResultSet rs = null;
        try{
            ConnectionHelper conHelper = new ConnectionHelper();
            Connection connection = conHelper.connectionclass();
//            //TEST CALL
//            Connection connection = returnConn();
            System.out.println("returnWardNames: CONNECTED!");
            String SQL = "SELECT WardName FROM WARD";
            Statement s = connection.createStatement();
            rs = s.executeQuery(SQL);
        }catch(SQLException e){
            System.out.print("returnWardNames problem is :  " + e);
        }
        return rs;
    }

    public static int returnWardSubModId(String wardName){
        int id = 0;
        try{
            ConnectionHelper conHelper = new ConnectionHelper();
            Connection connection = conHelper.connectionclass();
//            //TEST ONLY
//            Connection connection = returnConn();
            System.out.println("returnWardSubModId: CONNECTED!");
            String SQL = "SELECT WorkSubModel_ID FROM Ward WHERE WardName='" + wardName + "'";
            Statement s = connection.createStatement();
            ResultSet rs = s.executeQuery(SQL);
            if(rs.next()){
                id = rs.getInt("WorkSubModel_ID");
            }
        }catch(SQLException e){
            System.out.print("returnWardSubModId problem is :  " + e);
        }
        return id;
    }

    public static int returnWardId(String wardName){
        int id = 0;
        try{
            ConnectionHelper conHelper = new ConnectionHelper();
            Connection connection = conHelper.connectionclass();
//            //TEST ONLY
//            Connection connection = returnConn();
            System.out.println("returnWardId: CONNECTEDDD!");
            String SQL = "SELECT Ward_ID FROM Ward WHERE WardName='" + wardName + "'";
            Statement s = connection.createStatement();
            ResultSet rs = s.executeQuery(SQL);
            if(rs.next()){
                id = rs.getInt("Ward_ID");
            }
        }catch(SQLException e){
            System.out.print("returnWardId problem is :  " + e);
        }
        return id;
    }

    public static ResultSet returnPatientInfoOnWard(Integer wardId){
        ResultSet rs = null;
        try{
            ConnectionHelper conHelper = new ConnectionHelper();
            Connection connection = conHelper.connectionclass();
//            //TEST ONLY
//            Connection connection = returnConn();
            System.out.println("returnPatientsOnWard: CONNECTED!");
            CallableStatement myCall = connection.prepareCall("{call sp_GetCurrentWardPatients(?)}");
            myCall.setInt(1, wardId);
            rs = myCall.executeQuery();
            return rs;
        }catch(SQLException e){
            System.out.print("returnPatientsOnWard problem is :  " + e);
        }
        return rs;
    }

    public static ResultSet returnPatientPieInfo(int subModId){
        ResultSet rs = null;
        try{
            ConnectionHelper conHelper = new ConnectionHelper();
            Connection connection = conHelper.connectionclass();
//            //TEST ONLY
//            Connection connection = returnConn();
            String SQL = "SELECT WorkModel_ID, WorkTask_ID, WorkTaskName, TaskSubModelRatio FROM vw_GetSubModelTaskRatio WHERE WorkSubModel_ID='" + subModId + "'";
            Statement s = connection.createStatement();
            rs = s.executeQuery(SQL);
        }catch(SQLException e){
            System.out.print("returnPatientPieInfo: The problem is:  " + e);
        }
        return rs;
    }

    public static ResultSet returnTaskBands(Integer taskId, Integer wardId){
        ResultSet rs = null;
        try{
            ConnectionHelper conHelper = new ConnectionHelper();
            Connection connection = conHelper.connectionclass();
//            //TEST ONLY
//            Connection connection = returnConn();
            String SQL = "SELECT TaskBand_ID, TaskBandName, TaskBand_Weight FROM vw_GetWardsWithSubModelInclBands WHERE WorkTask_ID='" + taskId  + "' AND Ward_ID='" + wardId + "'";
            Statement s = connection.createStatement();
            rs = s.executeQuery(SQL);
        }catch(SQLException e){
            System.out.print("returnBands problem is :  " + e);
        }
        return rs;
    }

    public static int returnCurrentShiftId(int wardId){
        Integer shiftId = null;
        try{
            ConnectionHelper conHelper = new ConnectionHelper();
            Connection connection = conHelper.connectionclass();
//            //TEST ONLY
//            Connection connection = returnConn();
            //[] needed because of whitespace between current and shift
            String SQL = "SELECT WorkShift_ID FROM vw_GetAllWardsWithCurrentWorkShift WHERE Ward_ID='" + wardId + "'";
            Statement s = connection.createStatement();
            ResultSet rs = s.executeQuery(SQL);
            if(rs.next()){
                shiftId = rs.getInt("WorkShift_ID");
                return shiftId;
            }
        }catch(SQLException e){
            System.out.print("returnCurrShift problem is :  " + e);
        }

        return shiftId;
    }

    public static void insertIntoWorkTable(Integer epMovId, Date shiftDate, Integer shiftId, Integer workSubModId, Integer workTaskId, Integer isOutlier, Integer taskBandId, Integer staffId){
        try{
            ConnectionHelper conHelper = new ConnectionHelper();
            Connection connection = conHelper.connectionclass();
//            //TEST ONLY
//            Connection connection = returnConn();
            CallableStatement myCall = connection.prepareCall("{call sp_InsertWork(?, ?, ?, ?, ?, ?, ?, ?)}");
            myCall.setInt(1, epMovId);
            myCall.setDate(2, shiftDate);
            myCall.setInt(3, shiftId);
            myCall.setInt(4, workSubModId);
            myCall.setInt(5, workTaskId);
            myCall.setInt(6, isOutlier);
            myCall.setInt(7, taskBandId);
            myCall.setInt(8, staffId);
            myCall.executeUpdate();

            System.out.println("SUCCESSFULLY UPDATED WORK TABLE!");

        }catch(SQLException e){
            System.out.print("insertIntoWorkTable problem is :  " + e);
        }
    }

}
