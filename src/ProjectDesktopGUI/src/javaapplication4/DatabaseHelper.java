/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package javaapplication4;

import java.sql.Statement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.sql.PreparedStatement;
import java.sql.SQLException;

/**
 *
 * @author Ruth Leavey
 */
public class DatabaseHelper {
    
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
    public static int returnID(String name){        
    //public static void returnIdFromName(String name, String tbl, String nameCol){    
        int id = 0;
        try{
            System.out.println("attemptong method: returnID");
            
            String SQL = "SELECT * FROM WorkModel WHERE WorkModelName='" + name + "'";
            //String SQL = "SELECT * FROM " + tbl + " WHERE " + nameCol + "='" + name + "'";
            Statement s = HomePage.conn.createStatement();
        
            ResultSet rs = s.executeQuery(SQL);
        
            if(rs.next()){
                System.out.println("This name EXISTS in the table!");
                id = rs.getInt("WorkModel_ID");
            }else{
                System.out.println("returnID: DOES NOT EXIST!!");
                id = 0;
            }            
//            connection.close();            
        }catch(SQLException e) {
            System.out.println("ERRORRRRR!!");
            System.out.println("LINE NUMBER: " + getLineNumber());
            System.out.println(e.getMessage());
        }        
        return id;       
    }
    
    //return the WorkSubModel_ID from the WorkSubModel table associated with the argument name=WorkSubModelName
    public static int subreturnID(String name){        
    //public static void returnIdFromName(String name, String tbl, String nameCol){    
        int id = 0;
        try{
            System.out.println("attemptong method: subreturnID");
            
            String SQL = "SELECT * FROM WorkSubModel WHERE WorkSubModelName='" + name + "'";
            //String SQL = "SELECT * FROM " + tbl + " WHERE " + nameCol + "='" + name + "'";
            Statement s = HomePage.conn.createStatement();
        
            ResultSet rs = s.executeQuery(SQL);
        
            if(rs.next()){
                System.out.println("This sub model name EXISTS in the table!");
                id = rs.getInt("WorkSubModel_ID");
            }else{
                System.out.println("subreturnID: DOES NOT EXIST!!");
                id = 0;
            }            
//            connection.close();            
        }catch(SQLException e) {
            System.out.println("ERRORRRRR!!");
            System.out.println("LINE NUMBER: " + getLineNumber());
            System.out.println(e.getMessage());
        }        
        return id;       
    }
    
    //return WorkTask_ID from WorkTask associated with name=WorkTaskName and modId=WorkModel_ID
    public static int subreturnTskID(String name, Integer modId){   
        int id = 0;
        try{
            System.out.println("attemptong method: subreturnTskID");
            
            String SQL = "SELECT * FROM WorkTask WHERE WorkTaskName='" + name + "' AND WorkModel_ID='" + modId +"'";
            Statement s = HomePage.conn.createStatement();
        
            ResultSet rs = s.executeQuery(SQL);
        
            if(rs.next()){
                System.out.println("This task name EXISTS in the subModelTask table!");
                id = rs.getInt("WorkTask_ID");
            }else{
                System.out.println("subreturnTskID: DOES NOT EXIST!!");
                id = 0;
            }            
        }catch(SQLException e) {
            System.out.println("subreturnTskID: ERROR!");
            System.out.println("LINE NUMBER: " + getLineNumber()); 
            System.out.println(e.getMessage());
        }        
        return id;       
    }
    
    //return the resultset from WorkTask associated with id=WorkModel_ID
    //the reason we return the result set here is because there may be many tasks associated with the WorkModel_ID
    //and we wish to iterate through these tasks and for each one display the associated WorkTaskName and WorkModel_Ratio into the Gui tbl
    //see method used in AccountHomePage.java line 1235 in the subModelComboBoxItemStateChanged() class
    public static ResultSet checkWorkTask(Integer id){
        ResultSet rs = null;
        try{
            System.out.println("attemptong method: checkWorkTask");
        
            String SQL = "SELECT WorkTask_ID, WorkTaskName, WorkModel_Ratio FROM WorkTask WHERE WorkModel_ID='" + id + "'";
            Statement s = HomePage.conn.createStatement();
            
            rs = s.executeQuery(SQL);  
        }catch(SQLException e) {
            System.out.println("checkWorkTask: ERROR!");
            System.out.println("LINE NUMBER: " + getLineNumber());
            System.out.println(e.getMessage());
        }  
        
        return rs;
    }
    
    //return the result set which will contain WorkTask_IDs from the SubModelTask table associated will arg subId=WorkSubModel_ID
    //this is done so that all WorkTask_IDs can be used in the app
    //see line 1385 enterSubModNameButtonActionPerformed() in AccounHomePage
    public static ResultSet checkWorkSubTask(Integer subId){
        ResultSet rs = null;
        try{
            System.out.println("attemptong method: checkWorkSubTask");
        
            String SQL = "SELECT WorkTask_ID FROM SubModelTask WHERE WorkSubModel_ID='" + subId + "'";
            Statement s = HomePage.conn.createStatement();
            
            rs = s.executeQuery(SQL);                  
//            connection.close();             
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
    public static ResultSet checkTaskBand(Integer workTskId){
        ResultSet rs = null;
        try{
            System.out.println("attemptong method: checkTaskBand");
            
            String SQL = "SELECT * FROM TaskBand WHERE WorkTask_ID='" + workTskId + "'";
            Statement s = HomePage.conn.createStatement();
            
            rs = s.executeQuery(SQL);
            
        }catch(SQLException e){
            System.out.println("checkTaskBand: ERROR!");
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
    public static ResultSet checkWorkTaskName(String name, Integer id){
        ResultSet rs = null;
        try{
            System.out.println("attemptong method: checkWorkTaskName");
        
            String SQL = "SELECT * FROM WorkTask WHERE WorkTaskName='" + name + "' AND WorkModel_ID='" + id +"'";
            Statement s = HomePage.conn.createStatement();
            
            rs = s.executeQuery(SQL);                  
//            connection.close();             
        }catch(SQLException e) {
            System.out.println("checkWorkTaskName: ERROR!");
            System.out.println("LINE NUMBER: " + getLineNumber());
            System.out.println(e.getMessage());
        }  
        
        return rs;
    }
    
    public static ResultSet checkSubWorkTaskName(Integer subId, Integer taskId){
        ResultSet rs = null;
        try{
            System.out.println("attemptong method: checkSubWorkTaskName");
        
            String SQL = "SELECT * FROM SubModelTask WHERE WorkSubModel_ID='" + subId + "' AND WorkTask_ID='" + taskId + "'";
            Statement s = HomePage.conn.createStatement();
            
            rs = s.executeQuery(SQL);                  
//            connection.close();             
        }catch(SQLException e) {
            System.out.println("checkSubWorkTaskName: ERROR!");
            System.out.println("LINE NUMBER: " + getLineNumber()); 
            System.out.println(e.getMessage());
        }  
        
        return rs;
    }

    public static ResultSet checkTaskBandName(Integer worktskID, String bandName, Float weight){
        ResultSet rs = null;
        try{
            System.out.println("attemptong method: checkTaskBandName");
            
            String SQL = "SELECT * FROM TaskBand WHERE WorkTask_ID='" + worktskID + "' AND TaskBandName='" + bandName + "' AND WorkTask_Weight='" + weight + "'";
            Statement s = HomePage.conn.createStatement();
            
            rs = s.executeQuery(SQL);
            
        }catch(SQLException e){
            System.out.println("checkTaskName: ERROR");
            System.out.println("LINE NUMBER: " + getLineNumber());
            System.out.println(e.getMessage());
        }        
        return rs;
    }
    
    //insert new WorkModel item in the WorkModel db table
    public static void insertWorkModelData(String name, String descr, Timestamp dtstamp){
        
        try {
            System.out.println("attemptong method: insertWorkModelData");
            
            PreparedStatement s = HomePage.conn.prepareStatement("INSERT INTO WorkModel(WorkModelName, WorkModelDescription, DTStamp) VALUES (?, ?, ?)");
            s.setString(1, name);
            s.setString(2, descr);
            s.setTimestamp(3, dtstamp);
            int a = s.executeUpdate();
            
            if(a>0){
                System.out.println("Row updated");
            }
            
//            HomePage.conn.close();
            
        }catch(SQLException e) {
            System.out.println("insertWorkModelData: ERRORRRRR!");
            System.out.println("LINE NUMBER: " + getLineNumber());
            System.out.println(e.getMessage());
        }
        
    }
    
    //insert new task into the WorkTask table
    public static void insertIntoTaskTable(Integer workModelId, String taskName, String taskDescr, Float workModelRatio, Timestamp dtstamp){
                
        try {
            System.out.println("attemptong method: insertIntoTaskTable");
            
            PreparedStatement s = HomePage.conn.prepareStatement("INSERT INTO WorkTask(WorkModel_ID, WorkTaskName, WorkTaskDescription, WorkModel_Ratio, DTStamp) VALUES (?, ?, ?, ?, ?)");
            s.setInt(1, workModelId);
            s.setString(2, taskName);
            s.setString(3, taskDescr);
            s.setFloat(4, workModelRatio);
            s.setTimestamp(5, dtstamp);
            int a = s.executeUpdate();
            
            if(a>0){
                System.out.println("Row updated");
            }
            
        }catch(SQLException e) {
            System.out.println("insertIntoTaskTable: ERROR!");
            System.out.println("LINE NUMBER: " + getLineNumber());
            System.out.println(e.getMessage());
        }
    }
    
    public static void insertWorkSubModelData(Integer id, String name, String descr, Timestamp dtstamp){
        
        try {
            System.out.println("attemptong method: insertWorkSubModelData");
            
            PreparedStatement s = HomePage.conn.prepareStatement("INSERT INTO WorkSubModel(WorkModel_ID, WorkSubModelName, WorkSubModelDescription, DTStamp) VALUES (?, ?, ?, ?)");
            s.setInt(1, id);
            s.setString(2, name);
            s.setString(3, descr);
            s.setTimestamp(4, dtstamp);
            int a = s.executeUpdate();
            
            if(a>0){
                System.out.println("Row updated");
            }
            
//            connection.close();
            
        }catch(SQLException e) {
            System.out.println("insertWorkSubModelData: ERROR!");
            System.out.println("LINE NUMBER: " + getLineNumber());
            System.out.println(e.getMessage());
        }
        
    }
    
    //insert task info into the SubModelTask table
    public static void insertIntoSubTaskTable(Integer worksubModelId, Integer workTaskId, Timestamp dtstamp){
                
        try {
            System.out.println("attemptong method: insertIntoSubTaskTable");
            
            PreparedStatement s = HomePage.conn.prepareStatement("INSERT INTO SubModelTask(WorkSubModel_ID, WorkTask_ID, DTStamp) VALUES (?, ?, ?)");
            s.setInt(1, worksubModelId);
            s.setInt(2, workTaskId);
            s.setTimestamp(3, dtstamp);
            int a = s.executeUpdate();
            
            if(a>0){
                System.out.println("Row updated");
            }
            
        }catch(SQLException e) {
            System.out.println("insertIntoSubTaskTable: ERROR!");
            System.out.println("LINE NUMBER: " + getLineNumber());
            System.out.println(e.getMessage());
        }
    }
    
    //insert new band into the TaskBand table
    public static void insertIntoTaskBandTable(Integer workTskBand, String taskBandName, Float workTskWeight, Timestamp dtStamp){
        try{
            System.out.print("attemptong method: insertIntoTaskBandTable");
            
            PreparedStatement ps = HomePage.conn.prepareStatement("INSERT INTO TaskBand (WorkTask_ID, TaskBandName, WorkTask_Weight, DTStamp) VALUES (?, ?, ?, ?)");
            ps.setInt(1, workTskBand);
            ps.setString(2, taskBandName);
            ps.setFloat(3, workTskWeight);
            ps.setTimestamp(4, dtStamp);
            
            int a = ps.executeUpdate();
            
            if (a>0){
                System.out.println("TaskBand row updated");
            }
            
        }catch(SQLException e){
            System.out.print("insertIntoTaskBandTable: Error: ");
            System.out.println("LINE NUMBER: " + getLineNumber());
            System.out.println(e.getMessage());            
        }
    }
    
    //if the taskName= name in the deletedTasks list exists in the WorkTask table, delete it from the WorkTask table
    public static void deleteTask(String taskName, Integer id){
        try {
            System.out.println("attemptong method: deleteTask");
            
            String SQL = "SELECT * FROM WorkTask WHERE WorkTaskName='" + taskName + "' AND WorkModel_ID='" + id + "'";
            String SQL1 = "DELETE FROM WorkTask WHERE WorkTaskName='" + taskName + "' AND WorkModel_ID='" + id + "'";
            Statement s = HomePage.conn.createStatement();
            
            ResultSet rs = s.executeQuery(SQL);
            if (rs.next()){
                Statement s2 = HomePage.conn.createStatement();
                boolean rs2 = s2.execute(SQL1);
                System.out.println("Deleted!");
            }else{
                System.out.println("deleteTask: Not Deleted as taskname does not exist in the db table!");
            }
                        
        }catch(SQLException e) {
            System.out.println("deleteTask: ERROR! A problem prevented deletion!");
            System.out.println("LINE NUMBER: " + getLineNumber());
            System.out.println(e.getMessage());
        }
    }
    
    //if the bandName= name in the deletedTasks list exists in the WorkTask table, delete it from the WorkTask table
    public static void deleteBand(String bandName, Integer taskId){
        try {
            System.out.println("attemptong method: deleteBand");
            
            String SQL = "SELECT * FROM TaskBand WHERE TaskBandName='" + bandName + "' AND WorkTask_ID='" + taskId + "'";
            String SQL1 = "DELETE FROM TaskBand WHERE TaskBandName='" + bandName + "' AND WorkTask_ID='" + taskId + "'";
            Statement s = HomePage.conn.createStatement();
            
            ResultSet rs = s.executeQuery(SQL);
            if (rs.next()){
                Statement s2 = HomePage.conn.createStatement();
                boolean rs2 = s2.execute(SQL1);
                System.out.println("Deleted!");
            }else{
                System.out.println("deleteBand: Not Deleted as the band does not exist in the db table!");
            }
                        
        }catch(SQLException e) {
            System.out.println("deleteBand: ERROR! A problem prevented deletion!");
            System.out.println("LINE NUMBER: " + getLineNumber());
            System.out.println(e.getMessage());
        }
    }
    
    //get WorkModelNames from WorkModel table
    public static ResultSet returnWorkModelNames(){
        ResultSet rs = null;
        try{
            System.out.println("attemptong method: returnWorkModelNames");
        
            String SQL = "SELECT WorkModelName FROM WorkModel";
            Statement s = HomePage.conn.createStatement();
            
            rs = s.executeQuery(SQL);
            
        }catch(SQLException e) {
            System.out.println("returnWorkModelNames: ERROR!");
            System.out.println("LINE NUMBER: " + getLineNumber());
            System.out.println(e.getMessage());
        }  
        
        return rs;
    }
    
    
}
