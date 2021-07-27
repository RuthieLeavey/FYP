/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package javaapplication4;

import java.sql.*;
import java.util.ArrayList;
//import static javaapplication4.DatabaseHelper.getLineNumber;

/**
 *
 * @author harle
 */
public class DatabaseHelperSP {
    
    public static ResultSet returnDeptNames(){
        ResultSet rs = null;
        try{
            String SQL = "SELECT DepName FROM Department";
            Statement s = HomePage.conn.createStatement();
            rs = s.executeQuery(SQL);            
        }catch(SQLException e){
            System.out.print("returnDeptNames problem is :  ");
            System.out.println(e);
        }        
        return rs;
    }
    
    public static ResultSet returnWorkModelInfo(){
        ResultSet rs = null;
        try{
            System.out.println("attempting method: workModelInfo");
        
            String SQL = "SELECT WorkModelName, WorkModel_ID , WorkModelDescription FROM WorkModel";
            Statement s = HomePage.conn.createStatement();            
            rs = s.executeQuery(SQL);            
        }catch(SQLException e) {
            System.out.println("workModelInfo: ERROR!");
            System.out.println("LINE NUMBER: " + getLineNumber());
            System.out.println(e.getMessage());
        }          
        return rs;
    }
    
    public static ResultSet returnSubModelInfo(int workModId){
        ResultSet rs = null;
        try{
            System.out.println("attempting method: returnSubModelInfo");
            String SQL = "SELECT * FROM WorkSubModel WHERE WorkModel_ID='" + workModId + "'";
            Statement s = HomePage.conn.createStatement();            
            rs = s.executeQuery(SQL);            
        }catch(SQLException e) {
            System.out.println("returnSubModelInfo: ERROR!");
            System.out.println("LINE NUMBER: " + getLineNumber());
            System.out.println(e.getMessage());
        }          
        return rs;
    }
    
    public static ResultSet returnDeptWards(String deptName){
        ResultSet rs = null;        
        try{
            String SQL = "SELECT WardName FROM vw_GetAllPatientsWithDetails WHERE DepName='" + deptName + "'";
            Statement s = HomePage.conn.createStatement();
            rs = s.executeQuery(SQL);
            return rs;
        }catch(SQLException e){
            System.out.print("returnPatientsOnWard problem is :  ");
            System.out.println(e);
        }
        return rs;
    }
    
    public static void updateDeptTable(int workModId, String deptName){
        try{
            String SQL = "UPDATE Department SET WorkModel_ID='" + workModId + "' WHERE DepName='" + deptName + "'";
            PreparedStatement ps = HomePage.conn.prepareStatement(SQL);
            int a = ps.executeUpdate();            
            if (a>0){
                System.out.println("Dept row updated");
            }
        }catch(SQLException e){
            System.out.print("returnPatientsOnWard problem is :  ");
            System.out.println(e);
        }
    }
    
    public static int returnDepWorkModelID(String dep){
        int id = 0;
        try{
            System.out.println("attempting method: returnDepWorkModelID");            
            String SQL = "SELECT WorkModel_ID FROM Department WHERE DepName='" + dep + "'";
            Statement s = HomePage.conn.createStatement();        
            ResultSet rs = s.executeQuery(SQL);        
            if(rs.next()){
                System.out.println("This name EXISTS in the table!");
                id = rs.getInt("WorkModel_ID");
            }else{
                System.out.println("returnDepWorkModelIDD: DOES NOT EXIST!!");
                id = 0;
            }                      
        }catch(SQLException e) {
            System.out.println("ERRORRRRR!!");
            System.out.println("LINE NUMBER: " + getLineNumber());
            System.out.println(e.getMessage());
        }        
        return id; 
    }
    
    public static void insertSubDefaultData(Integer workModel, String defaultName, Timestamp dtStamp){
        
        try {
            System.out.println("attempting method: insertSubDefaultData");
            
            PreparedStatement s = HomePage.conn.prepareStatement("INSERT INTO SubModelDefault(WorkSubModel_ID, SubModelDefaultName, DTStamp) VALUES (?, ?, ?)");
            s.setInt(1, workModel);
            s.setString(2, defaultName);
            s.setTimestamp(3, dtStamp);
            int a = s.executeUpdate();            
            if(a>0){
                System.out.println("Sub Model Default Row updated");
            }
            
        }catch(SQLException e) {
            System.out.println("insertSubDefaultData: ERRORRRRR!");
            System.out.println("LINE NUMBER: " + getLineNumber());
            System.out.println(e.getMessage());
        }
        
    }
    
    public static int returnDefaultSubModID(Integer subModelId){
        int id = 0;
        try{
            System.out.println("attempting method: returnDefaultSubModID");            
            String SQL = "SELECT SubModelDefault_ID FROM SubModelDefault WHERE WorkSubModel_ID='" + subModelId + "'";
            Statement s = HomePage.conn.createStatement();        
            ResultSet rs = s.executeQuery(SQL);        
            if(rs.next()){
                System.out.println("This name EXISTS in the table!");
                id = rs.getInt("SubModelDefault_ID");
            }else{
                System.out.println("returnDefaultSubModID: DOES NOT EXIST!!");
                id = 0;
            }                      
        }catch(SQLException e) {
            System.out.println("ERRORRRRR!!");
            System.out.println("LINE NUMBER: " + getLineNumber());
            System.out.println(e.getMessage());
        }        
        return id; 
    }
    
    public static void insertDefaultBandData(Integer subModDefaultId, Integer bandId, Timestamp dtStamp){
        try {
            System.out.println("attempting method: insertDefaultBandData");            
            PreparedStatement s = HomePage.conn.prepareStatement("INSERT INTO SubModelDefaultBand(SubModelDefault_ID, TaskBand_ID, DTStamp) VALUES (?, ?, ?)");
            s.setInt(1, subModDefaultId);
            s.setInt(2, bandId);
            s.setTimestamp(3, dtStamp);
            int a = s.executeUpdate();            
            if(a>0){
                System.out.println("Sub Model Default Row updated");
                System.out.println("subModelDefaultID = " + subModDefaultId);
                System.out.println("band id = " + bandId);
            }            
        }catch(SQLException e) {
            System.out.println("insertDefaultBandData: ERRORRRRR!");
            System.out.println("LINE NUMBER: " + getLineNumber());
            System.out.println(e.getMessage());
        }
        
    }
    
    public static int getLineNumber() {
        return Thread.currentThread().getStackTrace()[2].getLineNumber();
    }

    // return WorkModel_ID for the argument name entered
    public static int returnID(Connection conn, String name){        
        CallableStatement cstmt = null;
        Integer returnid = 0;
        try {
            System.out.println("attempting method: returnID");
            
            cstmt = conn.prepareCall("{call ReturnWorkModelID(?)}");
            cstmt.setString(1, name);
            cstmt.executeQuery();
            ResultSet rs = cstmt.getResultSet(); 
            
            if(rs.next()){
                returnid = rs.getInt(1);
            }
            else {
                System.out.println("returnID: DOES NOT EXIST!!");
            }
            
        } 
        catch (Exception e) {
            System.out.println("ERRORRRRR!!");
            System.out.println("LINE NUMBER: " + getLineNumber());
            System.out.println(e.getMessage());
        }
        return returnid;
    }

    
    //return the WorkSubModel_ID from the WorkSubModel table associated with the argument name=WorkSubModelName
    public static int subreturnID(Connection conn, String name){        
        CallableStatement cstmt = null;
        int id = 0;
        try{
            System.out.println("attemptong method: subreturnID");
            
            cstmt = conn.prepareCall("{call ReturnWorkSubModelID(?)}");
            cstmt.setString(1, name);
            cstmt.execute();
            ResultSet rs = cstmt.getResultSet();
        
            if(rs.next()){
                System.out.println("This sub model name EXISTS in the table!");
                id = rs.getInt("WorkSubModel_ID");
            }else{
                System.out.println("subreturnID: this submodel name DOES NOT EXIST!!");
            }                      
        }catch(SQLException e) {
            System.out.println("subReturnID: ERRORRRRR!!");
            System.out.println("LINE NUMBER: " + getLineNumber());
            System.out.println(e.getMessage());
        }        
        return id;       
    }
    
    //return WorkTask_ID from WorkTask associated with name=WorkTaskName and modId=WorkModel_ID
    public static int subreturnTskID(Connection conn, String name, Integer modId){   
        CallableStatement cstmt = null;
        ResultSet rs = null;
        int id = 0;
        try {
            System.out.println("attemptong  method: subreturnTskID");
            cstmt = conn.prepareCall("{call ReturnWorkModelTaskID(?, ?)}");
            cstmt.setString(1, name);
            cstmt.setInt(2, modId);
            cstmt.execute();
            rs = cstmt.getResultSet();
            
            if(rs.next()){
                System.out.println("This task name EXISTS in the subModelTask table!");
                id = rs.getInt("WorkTask_ID");
            }else{
                System.out.println("subreturnTskID: task DOES NOT EXIST!!");
            } 
        } catch (Exception ex) {
            System.out.println("subreturnTskID SQL Eception: " + ex.getMessage());
        }
        return id;      
    }
    
    //return the resultset from WorkTask associated with id=WorkModel_ID
    //the reason we return the result set here is because there may be many tasks associated with the WorkModel_ID
    //and we wish to iterate through these tasks and for each one display the associated WorkTaskName and WorkModel_Ratio into the Gui tbl
    //see method used in AccountHomePage.java line 1235 in the subModelComboBoxItemStateChanged() class
    public static ResultSet checkWorkTask(Connection conn, Integer id){
        CallableStatement cstmt = null;
        ResultSet rs = null;
        try{
            System.out.println("attempting method: checkWorkTask");
            
            cstmt = conn.prepareCall("{call checkWorkTask(?)}");
            cstmt.setInt(1, id);
            cstmt.execute();
            rs = cstmt.getResultSet(); 
        }
        catch(SQLException e) {
            System.out.println("checkWorkTask: ERROR!");
            System.out.println("LINE NUMBER: " + getLineNumber());
            System.out.println(e.getMessage());
        }  
        
        return rs;
    }
    
    //return the result set which will contain WorkTask_IDs from the SubModelTask table associated will arg subId=WorkSubModel_ID
    //this is done so that all WorkTask_IDs can be used in the app
    //see line 1385 enterSubModNameButtonActionPerformed() in AccounHomePage
    public static ResultSet checkWorkSubTask(Connection conn, Integer subId){
        CallableStatement cstmt = null;
        ResultSet rs = null;
        try{
            System.out.println("attemptong method: checkWorkSubTask");
            
            cstmt = conn.prepareCall("{call checkWorkSubTask(?)}");
            cstmt.setInt(1, subId);
            cstmt.execute();
            rs = cstmt.getResultSet();             
        }catch(SQLException e) {
            System.out.println("checkWorkSubTask: ERROR!");
            System.out.println("LINE NUMBER: " + getLineNumber());
            System.out.println(e.getMessage());
        }  
        
        return rs;
    }
    
    //returns resultset associated with workTskId=WorkTask_ID
    //the reason we use is the result set is that we want to first check whether the task actually has any bands at all 
    //by returning the resultset, in AccountHomePage we can call rs.next() and if that isnt true that means that the task has no bands
    //if rs.next is true we can iterate through each band and return it to our GUI table
    //taskTableMouseClicked() line 1054 AccountHomePage.java
    public static ResultSet checkTaskBand(Connection conn, Integer workTskId){
        CallableStatement cstmt = null;
        ResultSet rs = null;
        try{
            System.out.println("attemptong method: checkTaskBand");
            
            cstmt = conn.prepareCall("{call checkTaskBand(?)}");
            cstmt.setInt(1, workTskId);
            cstmt.execute();
            rs = cstmt.getResultSet(); 
        }
        catch(SQLException e) {
            System.out.println("checkWorkTask: ERROR!");
            System.out.println("LINE NUMBER: " + getLineNumber());
            System.out.println(e.getMessage());
        }  
        
        return rs;
    }
    
    //return resultset associated with name=WorkTaskName and id=WorkModel_ID
    //see in AccountHomePage line 1305 in saveTaskChangesButtonActionPerformed()
    //I know that this method looks very similar to checkWorkTask() above, HOWEVER the reason this one is made is because we need to ensure
    //we do not save dublicate tasks to the WorkTaskTable. By calling this method we can use rs.next() to see if the exact task exists already
    //and if it does we will not insert it into the table.
    //Also note when we call checkWorkTask() in AccountHomePage() we don't know yet whether there are tasks in the WorkTask table and hence know
    //no WorkTaskNames
    public static ResultSet checkWorkTaskName(Connection conn, String workTaskName, Integer workModelId){
        CallableStatement cstmt = null;
        ResultSet rs = null;
        try{
            System.out.println("attemptong method: checkWorkTaskName");
            
            cstmt = conn.prepareCall("{call checkWorkTaskName(?, ?)}");
            cstmt.setString(1, workTaskName);
            cstmt.setInt(2, workModelId);
            cstmt.execute();
            rs = cstmt.getResultSet();          
        }catch(SQLException e) {
            System.out.println("checkWorkTaskName: ERROR!");
            System.out.println("LINE NUMBER: " + getLineNumber());
            System.out.println(e.getMessage());
        }  
        
        return rs;
    }
    
    public static ResultSet checkSubWorkTaskName(Connection conn, Integer subId, Integer taskId){
        CallableStatement cstmt = null;
        ResultSet rs = null;
        try{
            System.out.println("attemptong method: checkSubWorkTaskName"); 
                    
            cstmt = conn.prepareCall("{call CheckSubModelWorkTaskName(?, ?)}");
            cstmt.setInt(1, subId);
            cstmt.setInt(2, taskId);
            cstmt.executeQuery();
            
            rs = cstmt.getResultSet();
                       
        }catch(SQLException e) {
            System.out.println("checkSubWorkTaskName: ERROR!");
            System.out.println("LINE NUMBER: " + getLineNumber()); 
            System.out.println(e.getMessage());
        }  
        
        return rs;
    }

    public static ResultSet checkTaskBandName(Connection conn, Integer worktskID, String bandName, Float bandWeight){
        // checks if current band already exists for this task. 
        CallableStatement cstmt = null;
        ResultSet rs = null;
        try{
            System.out.println("attemptong method: checkTaskBandName");
            
            cstmt = conn.prepareCall("{call CheckTaskBandName(?, ?, ?)}");
            cstmt.setInt(1, worktskID);
            cstmt.setString(2, bandName);
            cstmt.setFloat(3, bandWeight);
            cstmt.executeQuery();
            
            rs = cstmt.getResultSet();
            
        }catch(SQLException e){
            System.out.println("checkTaskName: ERROR");
            System.out.println("LINE NUMBER: " + getLineNumber());
            System.out.println(e.getMessage());
        }        
        return rs;
    }
    
    //insert new WorkModel item in the WorkModel db table
    public static void insertWorkModelData(Connection conn, String name, String descr){
        // need to write test for this definitely to check that it inserted the correct data
        
        CallableStatement cstmt = null;
        try{
            System.out.println("attemptong method: insertWorkModelData");
            
            cstmt = conn.prepareCall("{call insertWorkModelData(?, ?)}");
            cstmt.setString(1, name);
            cstmt.setString(2, descr);
            int rowCount = cstmt.executeUpdate();
            // executeUpdate - returns an int for the update count. For stored procedures: Use when the stored procedure does not return a result set. https://www.qvera.com/kb/index.php/2256/calling-procedure-executeupdate-executequery-executebatch
            
            if(rowCount>0){     // this condition is not met. it does work though ? can delete this but woul dlike some way of chekcing row count or something
                System.out.println("Row updated");
            }
        }
        catch(SQLException e) {
            System.out.println("insertWorkModelData: ERROR!");
            System.out.println("LINE NUMBER: " + getLineNumber());
            System.out.println(e.getMessage());
        }  
    }
    
    //insert new task into the WorkTask table
    public static void insertIntoTaskTable(Connection conn, Integer workModelId, String taskName, String taskDescr, Float workModelRatio){
        CallableStatement cstmt = null;
        try{
            System.out.println("attemptong method: insertIntoTaskTable");
            
            cstmt = conn.prepareCall("{call insertTask(?, ?, ?, ?)}");
            cstmt.setInt(1, workModelId);
            cstmt.setString(2, taskName);
            cstmt.setString(3, taskDescr);
            cstmt.setFloat(4, workModelRatio);
            int rowCount = cstmt.executeUpdate();
            // executeUpdate - returns an int for the update count. For stored procedures: Use when the stored procedure does not return a result set. https://www.qvera.com/kb/index.php/2256/calling-procedure-executeupdate-executequery-executebatch
            
            if(rowCount>0){     // this condition is not met. it does work though ? can delete this but woul dlike some way of chekcing row count or something
                System.out.println("Row updated");
            }
            
        }catch(SQLException e) {
            System.out.println("insertIntoTaskTable: ERROR!");
            System.out.println("LINE NUMBER: " + getLineNumber());
            System.out.println(e.getMessage());
        }
    }
    
    public static void insertWorkSubModelData(Connection conn, Integer workSubModelId, String workSubModelName, String workSubModelDescr){
        CallableStatement cstmt = null;
        try {
            System.out.println("attemptong method: insertWorkSubModelData");
            
            cstmt = conn.prepareCall("{call InsertSubModelData(?, ?, ?)}");
            cstmt.setInt(1, workSubModelId);
            cstmt.setString(2, workSubModelName);
            cstmt.setString(3, workSubModelDescr);
            int rowCount = cstmt.executeUpdate();
            // executeUpdate - returns an int for the update count. For stored procedures: Use when the stored procedure does not return a result set. https://www.qvera.com/kb/index.php/2256/calling-procedure-executeupdate-executequery-executebatch
            
            if(rowCount>0){     // this condition is not met. it does work though ? can delete this but woul dlike some way of chekcing row count or something
                System.out.println("Row updated");
            }
            
        }catch(SQLException e) {
            System.out.println("insertWorkSubModelData: ERROR!");
            System.out.println("LINE NUMBER: " + getLineNumber());
            System.out.println(e.getMessage());
        }
        
    }
    
    //insert task info into the SubModelTask table
    public static void insertIntoSubTaskTable(Connection conn, Integer worksubModelId, Integer workTaskId){
        CallableStatement cstmt = null;
        try {
            System.out.println("attemptong method: insertIntoSubTaskTable");
            
            cstmt = conn.prepareCall("{call InsertSubModelTask(?, ?)}");
            cstmt.setInt(1, worksubModelId);
            cstmt.setInt(2, workTaskId);
            int rowCount = cstmt.executeUpdate();
            // executeUpdate - returns an int for the update count. For stored procedures: Use when the stored procedure does not return a result set. https://www.qvera.com/kb/index.php/2256/calling-procedure-executeupdate-executequery-executebatch
            
            if(rowCount>0){     // this condition is not met. it does work though ? can delete this but woul dlike some way of chekcing row count or something
                System.out.println("Row updated");
            }
        }catch(SQLException e) {
            System.out.println("insertIntoSubTaskTable: ERROR!");
            System.out.println("LINE NUMBER: " + getLineNumber());
            System.out.println(e.getMessage());
        }
    }
    
    //insert new band into the TaskBand table
    public static void insertIntoTaskBandTable(Connection conn, Integer workTskId, String taskBandName, String taskBandDescription, Float workTskWeight){
        CallableStatement cstmt = null;
        try{
            System.out.print("attempting method: insertIntoTaskBandTable");
            
            cstmt = conn.prepareCall("{call insertTaskBand(?, ?, ?, ?)}");
            cstmt.setInt(1, workTskId);
            cstmt.setString(2, taskBandName);
            cstmt.setString(3, taskBandDescription);
            cstmt.setFloat(4, workTskWeight);
            int rowCount = cstmt.executeUpdate();
            if(rowCount>0){     
                System.out.println("Row updated");
            }
        }catch(SQLException e){
            System.out.print("insertIntoTaskBandTable: Error: ");
            System.out.println("LINE NUMBER: " + getLineNumber());
            System.out.println(e.getMessage());            
        }
    }
    
    public static void insertNoWorkRequiredBand(Connection conn, Integer workTaskID) {
        CallableStatement cstmt = null;
        try{
            System.out.print("attempting method: insertNoWorkRequiredBand");
            
            cstmt = conn.prepareCall("{call InsertNoWorkRequiredBand(?)}");
            cstmt.setInt(1, workTaskID);
            int rowCount = cstmt.executeUpdate();
            if(rowCount>0){     
                System.out.println("Row updated");
            }
        }catch(SQLException e){
            System.out.print("insertNoWorkRequiredBand: Error: ");
            System.out.println("LINE NUMBER: " + getLineNumber());
            System.out.println(e.getMessage());            
        }
    }
    
    //if the taskName= name in the deletedTasks list exists in the WorkTask table, delete it from the WorkTask table
    public static void deleteTask(Connection conn, String taskName, Integer id){
        CallableStatement cstmt = null;
        try {
            System.out.println("attempting method: deleteTask");            
            cstmt = conn.prepareCall("{call DeleteTask(?, ?)}");
            cstmt.setString(1, taskName);
            cstmt.setInt(2, id);
            int rowCount = cstmt.executeUpdate();
            // executeUpdate - returns an int for the update count. For stored procedures: Use when the stored procedure does not return a result set. https://www.qvera.com/kb/index.php/2256/calling-procedure-executeupdate-executequery-executebatch
            
            if(rowCount>0){     // this condition is not met. it does work though ? can delete this but woul dlike some way of chekcing row count or something
                System.out.println("Row updated. task deleted");
            }
            else {
                System.out.println("0 rows updated. task did not exist in DB so did not need to be deleted.");
            }
                        
        }catch(SQLException e) {
            System.out.println("deleteTask: ERROR! A problem prevented deletion!");
            System.out.println("LINE NUMBER: " + getLineNumber());
            System.out.println(e.getMessage());
        }
    }
    
    //if the bandName= name in the deletedTasks list exists in the TaskBAnd table, delete it from the TaskBAnd table
    public static void deleteBand(Connection conn, String bandName, Integer taskId){
        CallableStatement cstmt = null;
        try {
            System.out.println("attempting method: deleteBand");
            
            cstmt = conn.prepareCall("{call DeleteBand(?, ?)}");
            cstmt.setString(1, bandName);
            cstmt.setInt(2, taskId);
            int rowCount = cstmt.executeUpdate();
            // executeUpdate - returns an int for the update count. For stored procedures: Use when the stored procedure does not return a result set. https://www.qvera.com/kb/index.php/2256/calling-procedure-executeupdate-executequery-executebatch
            
            if(rowCount>0){     // this condition is not met. it does work though ? can delete this but woul dlike some way of chekcing row count or something
                System.out.println("Row updated. band deleted: " + bandName);
            }
            else {
                System.out.println("0 rows updated. band did not exist in DB so did not need to be deleted.");
            }
                        
        }
        catch(SQLException e) {
            System.out.println("deleteBand: ERROR! A problem prevented deletion!");
            System.out.println("LINE NUMBER: " + getLineNumber());
            System.out.println(e.getMessage());
        }
    }
    
    //get WorkModelNames from WorkModel table
    public static ResultSet returnWorkModelNames(Connection conn){
        CallableStatement cstmt = null;
        ResultSet rs = null;
        try{
            System.out.println("attemptong method: returnWorkModelNames");
            
            cstmt = conn.prepareCall("{call ReturnWorkModelNames}");
            cstmt.execute();
            rs = cstmt.getResultSet(); 
        }
        catch(SQLException e) {
            System.out.println("returnWorkModelNames: ERROR!");
            System.out.println("LINE NUMBER: " + getLineNumber());
            System.out.println(e.getMessage());
        }  
        
        return rs;
    }
    
    public static ResultSet getStaffList(Connection conn) {
        CallableStatement cstmt = null;
        ResultSet rs = null;
        try {
            System.out.println("attempting method: getStaffList");
            
            cstmt = conn.prepareCall("{call getStaffList}");
            cstmt.execute();
            rs = cstmt.getResultSet();
        }
        catch (SQLException e) {
            System.out.println("getStaffList: ERROR!!");
            System.out.println("LINE NUMBER: " + getLineNumber());
            System.out.println(e.getMessage());
        }
       return rs;
    }
    
    public static String getStaffTypeName(Connection conn, Integer staffTypeID) {
        CallableStatement cstmt = null;
        ResultSet rs = null;
        String staffTypeName = "";
        try {
            System.out.println("attemting method: getStaffTypeName");
            
            cstmt = conn.prepareCall("{call GetStaffTypeName(?)}");
            cstmt.setInt(1, staffTypeID);
            cstmt.execute();
            rs = cstmt.getResultSet();
            while (rs.next()) {
                staffTypeName = rs.getString("StaffTypeName");
            }
            
            
        }
        catch(SQLException e) {
            System.out.println("getStaffTypeName: ERROR!!");
            System.out.println("LINE NUMBER: " + getLineNumber());
            System.out.println(e.getMessage());
        }
        return staffTypeName;
    }
    
    public static void updatePwForUser(String user, char [] newPw) {
        String newPass = "";
        for (int i = 0; i < newPw.length; i++) { 
            newPass += newPw[i]; 
        }
        
        CallableStatement cstmt = null;
        try {
            System.out.println("attempting method: updatePwForUser");
            
            cstmt = HomePage.conn.prepareCall("{call UpdatePwForUser(?, ?)}");
            cstmt.setString(1, user);
            cstmt.setString(2, newPass);
            cstmt.execute();
            
        }
        catch (SQLException e) {
            System.out.println(e.getMessage());
        }
    }

    
    
    
}
