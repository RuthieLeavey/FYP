/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package javaapplication4;

import java.awt.BorderLayout;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;
import javax.swing.JFrame;
import org.jfree.chart.ChartFactory;
import org.jfree.chart.ChartPanel;
import org.jfree.chart.JFreeChart;
import org.jfree.chart.plot.PiePlot;
import org.jfree.data.general.DefaultPieDataset;
import java.sql.*;
import java.sql.Date;
import java.time.LocalDate;
import java.util.*;
import javax.swing.JOptionPane;
import javax.swing.table.DefaultTableModel;
import org.jfree.chart.ChartMouseEvent;
import org.jfree.chart.ChartMouseListener;

/**
 *
 * @author leaveyr2
 */
public class NurseWorkLoggingAcc extends javax.swing.JFrame {
    
    DefaultTableModel wardTblModel;
    DefaultTableModel bandTblMod;
    
    JFrame bandFrame;
    
    String fName;
    String lName;
    String clickedTaskName;
        
    Integer wardId;
    Integer subModId;
    Integer patEpId;
    Integer patBedId;
    Integer patEpMovId;
    Integer patId;
    Integer workModId;
    Integer workShiftId;
    Integer epMoveId;
    Integer staffId;
    Integer clickedTaskId;

    Float clickedTaskRatio;
       
    /**
     * Creates new form NurseWorkLoggingAcc
     */
    public NurseWorkLoggingAcc() {
        initComponents();
        // fill the combo box with the wards so the user can select one
        fillWardComboBox();
        
        fName = null;
        lName= null;
        bandJP.setVisible(false);
        wardTblModel = new DefaultTableModel();  
        bandTblMod = new DefaultTableModel();        
        wardId = null;
        subModId = null;
        workModId = null;
        clickedTaskRatio = null;
        clickedTaskName = "";
        clickedTaskId = null;
        bandFrame= new JFrame();
        workShiftId = null;
        epMoveId = null;
               
        //just let staff id = 1 but need to change that to whoever is logged in***
        //***** FIXED **** NOW TAKES STAFF ID FROM HOMEPAGE.JAVA
        staffId = HomePage.staffId;
        
    }

    /**
     * This method is called from within the constructor to initialize the form.
     * WARNING: Do NOT modify this code. The content of this method is always
     * regenerated by the Form Editor.
     */
    @SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        jPanel1 = new javax.swing.JPanel();
        myAccountLabel = new javax.swing.JLabel();
        logOutButton = new javax.swing.JButton();
        selectWardJP = new javax.swing.JPanel();
        jLabel1 = new javax.swing.JLabel();
        wardJComboBox = new javax.swing.JComboBox<>();
        patientDisplayJP = new javax.swing.JPanel();
        jScrollPane1 = new javax.swing.JScrollPane();
        patientTable = new javax.swing.JTable();
        pieChartDisplayJP = new javax.swing.JPanel();
        bandJP = new javax.swing.JPanel();
        jScrollPane2 = new javax.swing.JScrollPane();
        bandTable = new javax.swing.JTable();

        setDefaultCloseOperation(javax.swing.WindowConstants.EXIT_ON_CLOSE);
        setPreferredSize(new java.awt.Dimension(1500, 800));

        jPanel1.setBackground(new java.awt.Color(45, 118, 232));

        myAccountLabel.setFont(new java.awt.Font("Segoe UI", 1, 24)); // NOI18N
        myAccountLabel.setForeground(new java.awt.Color(255, 255, 255));
        myAccountLabel.setIcon(new javax.swing.ImageIcon(getClass().getResource("/javaapplication4/images/icons8_male_user_32px.png"))); // NOI18N
        myAccountLabel.setText("My Account");

        logOutButton.setText("Log Out");
        logOutButton.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                logOutButtonActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout jPanel1Layout = new javax.swing.GroupLayout(jPanel1);
        jPanel1.setLayout(jPanel1Layout);
        jPanel1Layout.setHorizontalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel1Layout.createSequentialGroup()
                .addGap(50, 50, 50)
                .addComponent(myAccountLabel)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                .addComponent(logOutButton)
                .addGap(24, 24, 24))
        );
        jPanel1Layout.setVerticalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel1Layout.createSequentialGroup()
                .addGap(30, 30, 30)
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(myAccountLabel)
                    .addComponent(logOutButton))
                .addContainerGap(38, Short.MAX_VALUE))
        );

        jLabel1.setText("Ward: ");

        wardJComboBox.setModel(new javax.swing.DefaultComboBoxModel<>(new String[] { "Select Ward" }));
        wardJComboBox.addItemListener(new java.awt.event.ItemListener() {
            public void itemStateChanged(java.awt.event.ItemEvent evt) {
                wardJComboBoxItemStateChanged(evt);
            }
        });

        javax.swing.GroupLayout selectWardJPLayout = new javax.swing.GroupLayout(selectWardJP);
        selectWardJP.setLayout(selectWardJPLayout);
        selectWardJPLayout.setHorizontalGroup(
            selectWardJPLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(selectWardJPLayout.createSequentialGroup()
                .addGap(30, 30, 30)
                .addComponent(jLabel1)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(wardJComboBox, javax.swing.GroupLayout.PREFERRED_SIZE, 190, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(0, 0, Short.MAX_VALUE))
        );
        selectWardJPLayout.setVerticalGroup(
            selectWardJPLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(selectWardJPLayout.createSequentialGroup()
                .addGap(35, 35, 35)
                .addGroup(selectWardJPLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel1)
                    .addComponent(wardJComboBox, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addGap(0, 48, Short.MAX_VALUE))
        );

        patientTable.setModel(new javax.swing.table.DefaultTableModel(
            new Object [][] {

            },
            new String [] {
                "First Name", "Last Name", "Bed", "Bed_ID", "EpMove_ID", "Ep_ID", "Pat_ID"
            }
        ) {
            boolean[] canEdit = new boolean [] {
                false, false, false, false, false, true, true
            };

            public boolean isCellEditable(int rowIndex, int columnIndex) {
                return canEdit [columnIndex];
            }
        });
        patientTable.getTableHeader().setReorderingAllowed(false);
        patientTable.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                patientTableMouseClicked(evt);
            }
        });
        jScrollPane1.setViewportView(patientTable);
        if (patientTable.getColumnModel().getColumnCount() > 0) {
            patientTable.getColumnModel().getColumn(3).setMinWidth(0);
            patientTable.getColumnModel().getColumn(3).setPreferredWidth(0);
            patientTable.getColumnModel().getColumn(3).setMaxWidth(0);
            patientTable.getColumnModel().getColumn(4).setMinWidth(0);
            patientTable.getColumnModel().getColumn(4).setPreferredWidth(0);
            patientTable.getColumnModel().getColumn(4).setMaxWidth(0);
            patientTable.getColumnModel().getColumn(5).setMinWidth(0);
            patientTable.getColumnModel().getColumn(5).setPreferredWidth(0);
            patientTable.getColumnModel().getColumn(5).setMaxWidth(0);
            patientTable.getColumnModel().getColumn(6).setMinWidth(0);
            patientTable.getColumnModel().getColumn(6).setPreferredWidth(0);
            patientTable.getColumnModel().getColumn(6).setMaxWidth(0);
        }

        javax.swing.GroupLayout patientDisplayJPLayout = new javax.swing.GroupLayout(patientDisplayJP);
        patientDisplayJP.setLayout(patientDisplayJPLayout);
        patientDisplayJPLayout.setHorizontalGroup(
            patientDisplayJPLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(patientDisplayJPLayout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jScrollPane1, javax.swing.GroupLayout.DEFAULT_SIZE, 510, Short.MAX_VALUE)
                .addContainerGap())
        );
        patientDisplayJPLayout.setVerticalGroup(
            patientDisplayJPLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(patientDisplayJPLayout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jScrollPane1, javax.swing.GroupLayout.PREFERRED_SIZE, 390, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
        );

        pieChartDisplayJP.setPreferredSize(new java.awt.Dimension(852, 617));
        pieChartDisplayJP.setLayout(new java.awt.BorderLayout());

        bandJP.setMaximumSize(new java.awt.Dimension(300, 300));
        bandJP.setPreferredSize(new java.awt.Dimension(300, 300));
        bandJP.setLayout(new java.awt.BorderLayout());

        bandTable.setModel(new javax.swing.table.DefaultTableModel(
            new Object [][] {

            },
            new String [] {
                "Band", "Band_ID", "Task_ID"
            }
        ) {
            boolean[] canEdit = new boolean [] {
                false, false, false
            };

            public boolean isCellEditable(int rowIndex, int columnIndex) {
                return canEdit [columnIndex];
            }
        });
        bandTable.setRowHeight(40);
        bandTable.getTableHeader().setReorderingAllowed(false);
        bandTable.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                bandTableMouseClicked(evt);
            }
        });
        jScrollPane2.setViewportView(bandTable);
        if (bandTable.getColumnModel().getColumnCount() > 0) {
            bandTable.getColumnModel().getColumn(1).setMinWidth(0);
            bandTable.getColumnModel().getColumn(1).setPreferredWidth(0);
            bandTable.getColumnModel().getColumn(1).setMaxWidth(0);
            bandTable.getColumnModel().getColumn(2).setMinWidth(0);
            bandTable.getColumnModel().getColumn(2).setPreferredWidth(0);
            bandTable.getColumnModel().getColumn(2).setMaxWidth(0);
        }

        bandJP.add(jScrollPane2, java.awt.BorderLayout.CENTER);

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(getContentPane());
        getContentPane().setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jPanel1, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
            .addGroup(layout.createSequentialGroup()
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                    .addComponent(selectWardJP, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addComponent(patientDisplayJP, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(pieChartDisplayJP, javax.swing.GroupLayout.DEFAULT_SIZE, 859, Short.MAX_VALUE))
            .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                .addGroup(layout.createSequentialGroup()
                    .addGap(0, 0, Short.MAX_VALUE)
                    .addComponent(bandJP, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addGap(0, 0, Short.MAX_VALUE)))
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addComponent(jPanel1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(layout.createSequentialGroup()
                        .addComponent(selectWardJP, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(patientDisplayJP, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                    .addComponent(pieChartDisplayJP, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)))
            .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                .addGroup(layout.createSequentialGroup()
                    .addGap(0, 211, Short.MAX_VALUE)
                    .addComponent(bandJP, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addGap(0, 212, Short.MAX_VALUE)))
        );

        pack();
    }// </editor-fold>//GEN-END:initComponents

    private void wardJComboBoxItemStateChanged(java.awt.event.ItemEvent evt) {//GEN-FIRST:event_wardJComboBoxItemStateChanged
        //if the size of the combobox >1, when the state is changed get the selected ward and display the patients in that ward
        wardTblModel = (DefaultTableModel)patientTable.getModel();
        wardTblModel.setRowCount(0);
        
        if (wardJComboBox.getItemCount()>1){
            String wardName = wardJComboBox.getSelectedItem().toString();
            //we need sub model id and ward id for further queries
            subModId = DatabaseHelperWorkLog.returnWardSubModId(wardName);
            subModId = DatabaseHelperWorkLog.returnWardSubModId(wardName);
            wardId = DatabaseHelperWorkLog.returnWardId(wardName);
            System.out.println("ward id: " + wardId);
            // DatabaseHelperWorkLog line 79
            //use view in dbhelper so that now we get a resultset of patients instead of beds
            ResultSet rs = DatabaseHelperWorkLog.returnPatientsOnWard(wardId);
            //changes made to fillPatientList to accomodate views
            fillPatientList(rs);
            //clear the jPanel which displays the pie chart
            pieChartDisplayJP.removeAll();
            pieChartDisplayJP.revalidate();
            pieChartDisplayJP.repaint();
        }else{
            JOptionPane.showMessageDialog(this, "There are no wards!");

        }
    }//GEN-LAST:event_wardJComboBoxItemStateChanged

    private void patientTableMouseClicked(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_patientTableMouseClicked
        //Lists made to store all task info, will be used when creating the pie chart for display
        List taskNames = new ArrayList<String>();
        List taskRatios = new ArrayList<String>();
        List taskIds = new ArrayList<Integer>();

        //get the patients first,last name, bed id, episode move id, episode id and patient id
        //columns 3-6 added to patientTable and hidden so that patient info can be stored easier for further use
        fName = (String)wardTblModel.getValueAt(patientTable.getSelectedRow(), 0);
        lName = (String)wardTblModel.getValueAt(patientTable.getSelectedRow(), 1);
        patBedId = (Integer)wardTblModel.getValueAt(patientTable.getSelectedRow(), 3);
        patEpMovId = (Integer)wardTblModel.getValueAt(patientTable.getSelectedRow(), 4);
        patEpId = (Integer)wardTblModel.getValueAt(patientTable.getSelectedRow(), 5);
        patId = (Integer)wardTblModel.getValueAt(patientTable.getSelectedRow(), 6);
        
        //call new dbhelper method ResultSet rs = DatabaseHelper2.returnPatientPie(subModId) to return pie info
        ResultSet rs = DatabaseHelperWorkLog.returnPatientPieInfo(subModId);
        //make new method storeTaskInfoInLists(rs, taskNames, taskRatios, taskIds) for adding pie info to lists to be used later in pie chart
        storeTaskInfoInLists(rs, taskNames, taskRatios, taskIds);
        //call changes method displayPieAndRespondToClick(taskNames, updatedTaskRatios); to accomodate views
        displayPieAndRespondToClick(taskNames, taskRatios, taskIds);
    }//GEN-LAST:event_patientTableMouseClicked

    private void bandTableMouseClicked(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_bandTableMouseClicked
        //get band name selected 
        String band = (String)bandTable.getValueAt(bandTable.getSelectedRow(), 0);
        //added more hidden cols to give the following info:
        Integer bandId = (Integer)bandTable.getValueAt(bandTable.getSelectedRow(), 1);
        Integer taskId = (Integer)bandTable.getValueAt(bandTable.getSelectedRow(), 2);
        
//        if(confirmBandLog(band)){        
            //we need to set the row count to 0 and dispose the window so
            //1. the band table clears and 2. the band table exits after use
            bandTblMod.setRowCount(0);
            bandFrame.dispose();
            bandFrame.setVisible(false);
            //we need the current shift of when the task is being logged
            workShiftId = getWorkShiftId();
            //have epMovId from patientTableClicked() above
            //subModId already have from jComboBoxItemChanged above
            //isOutlier DONT HAVE!!!
            Integer isOutlier = 0;
            Date workShiftDate = Date.valueOf(LocalDate.now());
            DatabaseHelperWorkLog.insertIntoWorkTable(patEpMovId, workShiftDate, workShiftId, subModId, taskId, isOutlier, bandId, staffId);
            //confirmation message to the user
            JOptionPane.showMessageDialog(pieChartDisplayJP, band + " has been logged for " + fName);
//        }
    }//GEN-LAST:event_bandTableMouseClicked

    private void logOutButtonActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_logOutButtonActionPerformed
        new HomePage().setVisible(true);
        dispose();
    }//GEN-LAST:event_logOutButtonActionPerformed
        
    public void fillWardComboBox(){
        //fill the combo box with ward names --> Ward table
        ResultSet rs = DatabaseHelperWorkLog.returnWardNames();
        System.out.println("returnWardNames " + rs);
        try{
            while(rs.next()){
                    String wardName = rs.getString("WardName");
                    wardJComboBox.addItem(wardName);
                }            
        }catch(SQLException e){
            System.out.println(e);
        }
    
    }
    
    //we need to return any patient names on the ward selected
    //Add all patient info to the table to use at later stages
    public void fillPatientList(ResultSet rs){
        try{
            while(rs.next()){
                String firstName = rs.getString("PatFirstName");
                String lastName = rs.getString("PatLastName");
                String bedName = rs.getString("BedName");
                int bedId = rs.getInt("Bed_ID");
                int episodeMoveId = rs.getInt("EpisodeMove_ID");
                int episodeId = rs.getInt("Episode_ID");
                int patId = rs.getInt("Pat_ID");                
                
                Object data[] = {firstName, lastName, bedName, bedId, episodeMoveId, episodeId, patId};
                wardTblModel.addRow(data);
            }
        }catch(SQLException e){
            System.out.println("Problem filling patient info: (see fillPatientList line 375)"+e);
        }
    }
    
    //adds the task names, ratios and ids to lists to later be used when a task is selected from the pie chart
    public void storeTaskInfoInLists(ResultSet rs, List names, List ratios, List ids){
        try{
            while(rs.next()){
                    String taskName = rs.getString("WorkTaskName");
                    names.add(taskName);
                    Float taskRatio = rs.getFloat("TaskSubModelRatio");
                    ratios.add(taskRatio);
                    Integer taskId = rs.getInt("WorkTask_ID");
                    ids.add(taskId);
                    workModId = rs.getInt("WorkModel_ID");
                }            
        }catch(SQLException e){
            System.out.println(e);
        }
    }
    
    //this method could possibly be split up further?
    //It displays the pie chart to the user and it also creates the pie chart listener for when user selects
    //a task from the pie chart and returns the bands of that task in a table
    public void displayPieAndRespondToClick(List names, List ratios, List ids){
        //these three lines are needed to clear the jpanel BEFORE display a new pie each time a new patient is clicked
        pieChartDisplayJP.removeAll();
        pieChartDisplayJP.revalidate();
        pieChartDisplayJP.repaint();
        //display pie
        DefaultPieDataset pieDataset = new DefaultPieDataset();
        fillPieDataSet(names, ratios, pieDataset);
        bandTblMod = (DefaultTableModel)bandTable.getModel();
        ChartPanel chartPanel = getPieChartPanel(fName, pieDataset);
        pieChartDisplayJP.add(chartPanel, BorderLayout.CENTER);
        chartPanel.addChartMouseListener(new ChartMouseListener(){
            @Override
            public void chartMouseClicked(ChartMouseEvent e) {
                //get the taskName that was clicked
                String ent = e.getEntity().toString();
                //call taskClicked method to concatenate the entity which contains the task name
                clickedTaskName = taskClicked(ent);
                //check for the name and it's corresponding ratio from the lists
                clickedTaskRatio = returnClickedTaskRatio(clickedTaskName, names, ratios);
                clickedTaskId = returnClickedTaskId(clickedTaskName, names, ids);
                System.out.println(clickedTaskName);
                System.out.println("Task ratio for above task: " + clickedTaskRatio);
                //get the weight of the task clicked
                //we should have sub id
                int subId = subModId;
                //return bands into list -- changes made in dbhelper to use view
                ResultSet rs = DatabaseHelperWorkLog.returnTaskBands(clickedTaskId, wardId);
                addBandsToTbl(rs);
                displayBandFrame(bandFrame);
//                clearBandTableAndExitWhenAsked();
            }
            public void chartMouseMoved(ChartMouseEvent e) {}
        });
    }
    
    //we need to fill the pie dataset with the task names and their ratios
    public void fillPieDataSet(List names, List ratios, DefaultPieDataset pieDataset){
        for(int i = 0; i<names.size(); i++){
                String tsk = (String)names.get(i);
                float rtio = (Float)ratios.get(i);
                pieDataset.setValue(tsk,  rtio);
            }
    }
    
    //we create the pie chart display panel 
    //We might want to change the args in createPieChart() if we wish for certain things to be omitted
    public ChartPanel getPieChartPanel(String name, DefaultPieDataset pieDataset){
        JFreeChart chart = ChartFactory.createPieChart(name, pieDataset, true, true, false);
        PiePlot p = (PiePlot)chart.getPlot();

        ChartPanel chartPanel = new ChartPanel(chart);
        return chartPanel;
    }
    
    //we know that the task name is wrapped by paretheses
    //therefore we find the task name by concatenating the letters between a ( and a )
    public String taskClicked(String entity){
        String taskName = "";
        int startIndex = entity.indexOf("(");
        int endIndex = entity.indexOf(")");
        ArrayList taskNameL = new ArrayList<String>();
        for(int i=startIndex + 1; i<endIndex; i++){
            taskNameL.add(entity.charAt(i));
        }
        for(int j = 0; j<taskNameL.size(); j++){
            taskName = taskName.concat(taskNameL.get(j).toString());
        }
        System.out.println(clickedTaskName);
        return taskName;
    }
    
    //check the name and ratio lists and return appropriate result
    public float returnClickedTaskRatio(String name, List namesList, List ratioList){
        for(int i=0; i<namesList.size(); i++){
            if (name.equals(namesList.get(i).toString())){
                clickedTaskRatio = Float.parseFloat(ratioList.get(i).toString());
            }
        }        
        return clickedTaskRatio;
    }
    
    //check the name and id of the task selected
    public int returnClickedTaskId(String name, List namesList, List taskIds){
        for(int i=0; i<namesList.size(); i++){
            if (name.equals(namesList.get(i).toString())){
                clickedTaskId = Integer.parseInt(taskIds.get(i).toString());
            }
        }        
        return clickedTaskId;
    }
    
    //Add the band name, the band id and the task id to the band table
    //Note: the columns band id and task id are hidden in display
    public void addBandsToTbl(ResultSet rs){
        //BUG *********************** SOME TASK BANDS ARE BEING ADDED TWICE
        try{
            while(rs.next()){
                String bandName = rs.getString("TaskBandName");
                System.out.println("band is: " + bandName);
                Integer bandId = rs.getInt("TaskBand_ID");
                System.out.println("band id is: " + bandId);
                Object[] newRow = {bandName, bandId, clickedTaskId};
                bandTblMod.addRow(newRow);
            }
        }catch(SQLException ex){
        }
    }
    
    //create a jFrame for the bands when a task is selected
    //and display
    public void displayBandFrame(JFrame bandFrame){
        bandFrame.setSize(300, 300);
        bandFrame.setLayout(new BorderLayout());
        bandFrame.setTitle("Bands");
        bandFrame.add(bandJP, BorderLayout.CENTER);
        bandJP.setVisible(true);
        bandFrame.setLocationRelativeTo(pieChartDisplayJP);
        bandFrame.setVisible(true);
        clearBandTableWhenExited();
    }
    
    public void clearBandTableWhenExited(){
        bandFrame.addWindowListener(new WindowAdapter() {
            public void windowClosing(WindowEvent we) {
                bandFrame.dispose();
                bandTblMod.setRowCount(0);
            }
        });
    }
    
    //add confirm window so user ensures they log the correct task band
//    public boolean confirmBandLog(String bandName){
//        return JOptionPane.showConfirmDialog(bandFrame,"Are you sure you want to log" + bandName + " for " + clickedTaskName, "Log task?", JOptionPane.YES_NO_OPTION,JOptionPane.QUESTION_MESSAGE) == JOptionPane.YES_OPTION;
//    }
    
    //we need the current work shift when the task is being logged
    public int getWorkShiftId(){
        //dbhelper changed to use view GetAllWardsWithCurrentWorkShift
        Integer shiftId = DatabaseHelperWorkLog.returnCurrentShiftId(wardId);
        return shiftId;    
    }
    
    /**
     * @param args the command line arguments
     */
    public static void main(String args[]) {
        /* Set the Nimbus look and feel */
        //<editor-fold defaultstate="collapsed" desc=" Look and feel setting code (optional) ">
        /* If Nimbus (introduced in Java SE 6) is not available, stay with the default look and feel.
         * For details see http://download.oracle.com/javase/tutorial/uiswing/lookandfeel/plaf.html 
         */
        try {
            for (javax.swing.UIManager.LookAndFeelInfo info : javax.swing.UIManager.getInstalledLookAndFeels()) {
                if ("Nimbus".equals(info.getName())) {
                    javax.swing.UIManager.setLookAndFeel(info.getClassName());
                    break;
                }
            }
        } catch (ClassNotFoundException ex) {
            java.util.logging.Logger.getLogger(NurseWorkLoggingAcc.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (InstantiationException ex) {
            java.util.logging.Logger.getLogger(NurseWorkLoggingAcc.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (IllegalAccessException ex) {
            java.util.logging.Logger.getLogger(NurseWorkLoggingAcc.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (javax.swing.UnsupportedLookAndFeelException ex) {
            java.util.logging.Logger.getLogger(NurseWorkLoggingAcc.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        }
        //</editor-fold>

        /* Create and display the form */
        java.awt.EventQueue.invokeLater(new Runnable() {
            public void run() {
                new NurseWorkLoggingAcc().setVisible(true);
            }
        });
    }

    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JPanel bandJP;
    private javax.swing.JTable bandTable;
    private javax.swing.JLabel jLabel1;
    private javax.swing.JPanel jPanel1;
    private javax.swing.JScrollPane jScrollPane1;
    private javax.swing.JScrollPane jScrollPane2;
    private javax.swing.JButton logOutButton;
    private javax.swing.JLabel myAccountLabel;
    private javax.swing.JPanel patientDisplayJP;
    private javax.swing.JTable patientTable;
    private javax.swing.JPanel pieChartDisplayJP;
    private javax.swing.JPanel selectWardJP;
    private javax.swing.JComboBox<String> wardJComboBox;
    // End of variables declaration//GEN-END:variables
}
