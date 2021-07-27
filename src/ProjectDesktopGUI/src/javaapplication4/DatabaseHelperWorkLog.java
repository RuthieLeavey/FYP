/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package javaapplication4;

import java.sql.*;

/**
 *
 * @author leaveyr2
 */
public class DatabaseHelperWorkLog {
//    protected static Connection conn = HomePage.conn;
    protected static Connection conn = returnConnection();
//    protected static Connection conn = DriverManager.getConnection("jdbc:sqlserver://DESKTOP-AFJQMNH;databaseName=WMSRH", "sa", "ca400");
    
    public static Connection returnConnection(){
        return HomePage.conn;
//        String dbDriver = "com.microsoft.sqlserver.jdbc.SQLServerDriver"; 
//        String dbURL = "jdbc:sqlserver://DESKTOP-AFJQMNH;databaseName=thursday;username=sa;password=ca400";
////        String dbURL = "jdbc:sqlserver://DESKTOP-DHB3GRA:1433;databaseName=WEEK;username=sa;password=ca400";
//        try {
//            Class.forName(dbDriver);            // Returns the Class object associated with the interface that has the given string name
//            Driver d = DriverManager.getDriver(dbURL);  // Attempts to locate a driver that understands the given URL. 
//            System.out.println(d.acceptsURL(dbURL)); // Retrieves whether the driver thinks that it can open a connection to the given URL.
//            // these two lines are added in here to debug the test of this method
//            // driver is registered but the dbURL is causing the problem I believe
//            // leaving these comments here so i can remember what the problem is when i come back to it
//            System.out.println("trying to establish connection to: " +  dbURL);
//            Connection conn = DriverManager.getConnection(dbURL);
//            System.out.println("Succesfully connected to: " +  dbURL);
//
//            return conn;
//        }
//        catch (ClassNotFoundException cnf) {
//                System.out.println("ClassNotFoundException:::::::::::" + cnf.getMessage());
//            }  
//            catch (SQLException ex) {
//                System.out.println("SQL EXception::::::" + ex.getMessage());
//            }
//        return null;
    }
    
    //returns ward names to be displayed by the combobox to the user
    public static ResultSet returnWardNames(){
        ResultSet rs = null;
        try{
            String SQL = "SELECT WardName FROM WARD";
            Statement s = conn.createStatement();
            rs = s.executeQuery(SQL);
            
        }catch(SQLException e){
            System.out.print("returnWardNames problem is :  ");
            System.out.println(e);
        }
        
        return rs;
    }
    
    //return the sub model id for the ward selected
    public static int returnWardSubModId(String wardName){
        int id = 0;
        try{
            String SQL = "SELECT WorkSubModel_ID FROM Ward WHERE WardName='" + wardName + "'";
            Statement s = conn.createStatement();
            ResultSet rs = s.executeQuery(SQL);
            
            if(rs.next()){
                id = rs.getInt("WorkSubModel_ID");
            }
            
        }catch(SQLException e){
            System.out.print("returnWardSubModId problem is :  ");
            System.out.println(e);
        }
        
        return id;
    }
    
    //return the ward id so that further info can be found
    //May not be needed?????
    public static int returnWardId(String wardName){
        int id = 0;
        try{
            String SQL = "SELECT Ward_ID FROM Ward WHERE WardName='" + wardName + "'";
            Statement s = conn.createStatement();
            ResultSet rs = s.executeQuery(SQL);
            
            if(rs.next()){
                id = rs.getInt("Ward_ID");
            }
            
        }catch(SQLException e){
            System.out.print("returnWardId problem is :  ");
            System.out.println(e);
        }
        
        return id;
    }
    
    // call the stored procedure in the db called GetCurrentWardPatients to return patients to the UI
    //SP uses view GetPatientDetails 
    //Return a result set so that the app can save multiple pieces of info
    public static ResultSet returnPatientsOnWard(Integer wardId){
        ResultSet rs = null;        
        try{
            CallableStatement myCall = conn.prepareCall("{call sp_GetCurrentWardPatients(?)}");
            myCall.setInt(1, wardId);
            rs = myCall.executeQuery();
            return rs;            
            
        }catch(SQLException e){
            System.out.print("returnPatientsOnWard problem is :  ");
            System.out.println(e);
        }
        
        return rs;
    }
    
    //return result set of all task information
    //This info is needed for the pie chart display once a patient is selected
    //uses view GetSubModelTaskRatio which contains the recalculated sub model ratios
    public static ResultSet returnPatientPieInfo(int subModId){
        ResultSet rs = null;
        try{
            String SQL = "SELECT WorkModel_ID, WorkTask_ID, WorkTaskName, TaskSubModelRatio FROM vw_GetSubModelTaskRatio WHERE WorkSubModel_ID='" + subModId + "'";
            Statement s = conn.createStatement();
            rs = s.executeQuery(SQL);
        }catch(SQLException e){
            System.out.print("returnPatientPieInfo: The problem is:  ");
            System.out.println(e);
        }
        return rs;
    }
    
//    public static ResultSet returnWorkTaskId(Integer subId){
//        ResultSet rs = null;
//        
//        try{
//            String SQL = "SELECT WorkTask_ID FROM SubModelTask WHERE WorkSubModel_ID='" + subId + "'";
//            Statement s = conn.createStatement();
//            rs = s.executeQuery(SQL);            
//            
//        }catch(SQLException e){
//            System.out.print("returnWorkTaskId problem is :  ");
//            System.out.println(e);
//        }
//        
//        return rs;
//    }

    
    //Return a result set of task band info to display when a user selects a task to log 
    //view used 
    public static ResultSet returnTaskBands(Integer taskId, Integer wardId){
            ResultSet rs = null;
            
            try{
                String SQL = "SELECT TaskBand_ID, TaskBandName FROM vw_GetWardsWithSubModelInclBands WHERE WorkTask_ID='" + taskId + "' AND Ward_ID='" + wardId + "'";
                Statement s = conn.createStatement();
                rs = s.executeQuery(SQL);            
            
            }catch(SQLException e){
                System.out.print("returnBands problem is :  ");
                System.out.println(e);
            }
            
            return rs; 
        }
    
    
    //return the current work shift to the app
    //uses view which has the current shift and ward info in the same table
    public static int returnCurrentShiftId(int wardId){
        Integer shiftId = 0;
            try{
                //[] needed because of whitespace between current and shift
                String SQL = "SELECT WorkShift_ID FROM vw_GetAllWardsWithCurrentWorkShift WHERE Ward_ID='" + wardId + "'";
                Statement s = conn.createStatement();
                ResultSet rs = s.executeQuery(SQL); 
                if(rs.next()){
                    shiftId = rs.getInt("WorkShift_ID");
                    return shiftId;
                } 
            }catch(SQLException e){
                System.out.print("returnCurrShift problem is :  ");
                System.out.println(e);
            }
            
            return shiftId;
    }
    
    //insert the task, band logged for the patient in the ward
    public static void insertIntoWorkTable(Integer epMovId, Date shiftDate, Integer shiftId, Integer workSubModId, Integer workTaskId, Integer isOutlier, Integer taskBandId, Integer staffId){
        try{
            CallableStatement myCall = conn.prepareCall("{call sp_InsertWork(?, ?, ?, ?, ?, ?, ?, ?)}");
            myCall.setInt(1, epMovId);
            myCall.setDate(2, shiftDate);
            myCall.setInt(3, shiftId);
            myCall.setInt(4, workSubModId);
            myCall.setInt(5, workTaskId);
            myCall.setInt(6, isOutlier);
            myCall.setInt(7, taskBandId);
            myCall.setInt(8, staffId);
//            myCall.executeUpdate();
            myCall.execute();
           
            
        }catch(SQLException e){
            System.out.print("insertIntoWorkTable problem is :  ");
            System.out.println(e);
        }
    }
}
