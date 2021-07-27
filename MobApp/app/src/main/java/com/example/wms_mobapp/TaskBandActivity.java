package com.example.wms_mobapp;

import androidx.annotation.RequiresApi;
import androidx.appcompat.app.AppCompatActivity;

import android.annotation.SuppressLint;
import android.content.Intent;
import android.os.Build;
import android.os.Bundle;
import android.view.View;
import android.widget.TableLayout;
import android.widget.TableRow;
import android.widget.TextView;
import android.widget.Toast;

import java.sql.Date;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;

public class TaskBandActivity extends AppCompatActivity {

    TableLayout bandTbl;
    TableRow bandTblRow;

    String clickedTaskName, clickedBandName, clickedPatFName;
    Integer workShiftId, clickedPatEpMovId, subModelId, staffId, wardId, clickedTaskId;
    Float clickedTaskRatio;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_task_band);
        getSupportActionBar().setTitle("Task Bands");
        getSupportActionBar().setDisplayHomeAsUpEnabled(true);

        bandTbl = findViewById(R.id.bandTblLayout);

        staffId = MainActivity.staffId;
        clickedTaskName = PieChartActivity.clickedTaskName;
        System.out.println("Task name clicked from previous activity: " + clickedPatFName);
        subModelId = MobileAccountHomePage.subModelId;
        wardId = MobileAccountHomePage.wardId;
        clickedPatEpMovId = MobileAccountHomePage.clickedPatEpMovId;
        clickedPatFName = MobileAccountHomePage.clickedPatFName;
        clickedTaskRatio = PieChartActivity.clickedTaskRatio;
        System.out.println("Task ratio clicked from previous activity: " + clickedTaskRatio);
        clickedTaskId = PieChartActivity.clickedTaskId;
        System.out.println("Task id clicked from previous activity: " + clickedTaskId);

        showBands(clickedTaskId);
    }

    //added for line 344 *****
    @SuppressLint("SetTextI18n")
    private void showBands(Integer clickedTaskId){
        TextView taskNameTv = findViewById(R.id.taskNameTextView);
        System.out.println("Task name to put into text view:::::::: " + clickedTaskName);
        taskNameTv.setText("Task:" + clickedTaskName);
        //needs to be here to avoid nullPointer error
        bandTbl = findViewById(R.id.bandTblLayout);
        int count = bandTbl.getChildCount();
        System.out.println("Count: " + count);
        //index out of bounds error sometimes happens -NEED TO FIX
        if(count>1) {
            bandTbl.removeViews(1, count - 1);
        }
        //***Added ward id
        ResultSet rs = DatabaseHelper.returnTaskBands(clickedTaskId, wardId);
        try{
            int bandRowId = 0;
            while(rs.next()){
                String bandName = rs.getString("TaskBandName");
                System.out.println("band is: " + bandName);
                int bandId = rs.getInt("TaskBand_ID");
                String bandIdStr = Integer.toString(bandId);
                //don't necessarily need to add clicked Task Id to table - revisit
                String clickedTaskIdStr = Integer.toString(clickedTaskId);

                addRowToBandTable(bandName, bandIdStr, clickedTaskIdStr, bandRowId);
                bandRowId = bandRowId + 1;

//                Object[] newRow = {bandName, bandId, clickedTaskId};
//                bandTblMod.addRow(newRow);
            }
        }catch(SQLException ex){
            System.out.println(getString(R.string.bandRetrivalStringProb) + ex);
        }
    }

    private void addRowToBandTable(String name, String bandId, String taskId, Integer rowId){
        bandTblRow = new TableRow(this);
        bandTblRow.setId(rowId);
        TableRow.LayoutParams params = new TableRow.LayoutParams(0, TableRow.LayoutParams.MATCH_PARENT, 10f);
        params.height = 100;
        TableRow.LayoutParams params2 = new TableRow.LayoutParams(0, TableRow.LayoutParams.MATCH_PARENT, 0f);
        params2.height = 100;

        MobileAccountHomePage.addViewToRow(bandTblRow, name, params, this);
        MobileAccountHomePage.addViewToRow(bandTblRow, bandId, params2, this);
        MobileAccountHomePage.addViewToRow(bandTblRow, taskId, params2, this);

        bandTbl.addView(bandTblRow);

        //add click listener
        bandTblRow.setClickable(true);
        bandTblRow.setOnClickListener(new View.OnClickListener() {
            @RequiresApi(api = Build.VERSION_CODES.O)
            @Override
            public void onClick(View v) {
                TableRow tr=(TableRow)v;
                TextView t1 = (TextView)tr.getChildAt(0);
                clickedBandName = t1.getText().toString();
                System.out.println(clickedBandName);
                TextView t2 = (TextView)tr.getChildAt(1);
                Integer bandId = Integer.parseInt(t2.getText().toString());
                System.out.println(bandId);
                TextView t3 = (TextView)tr.getChildAt(2);
                Integer taskId = Integer.parseInt(t3.getText().toString());
                System.out.println(taskId);

                logWork(bandId, taskId);
                //clear band table
                int count = bandTbl.getChildCount();
                System.out.println("Count: " + count);
                //index out of bounds error sometimes happens -NEED TO FIX
                if(count>1) {
                    bandTbl.removeViews(1, count - 1);
                }
            }
        });

    }

    @RequiresApi(api = Build.VERSION_CODES.O)
    private void logWork(Integer bandId, Integer taskId){
        //add work
        workShiftId = getWorkShiftId();
        //isOutlier DONT HAVE!!! **************************
        Integer isOutlier = 0;
        Date workShiftDate = Date.valueOf(LocalDate.now().toString());
        DatabaseHelper.insertIntoWorkTable(clickedPatEpMovId, workShiftDate, workShiftId, subModelId, taskId, isOutlier, bandId, staffId);

        //go back to pie activity******************************************************
        Intent intent = new Intent(TaskBandActivity.this, PieChartActivity.class);
        startActivity(intent);
        //toast not working properly only showing some text *************************
        Toast toast = Toast.makeText(getApplicationContext(), clickedBandName + " was logged for "  + clickedTaskName + " for "
                + clickedPatFName, Toast.LENGTH_LONG);
        toast.show();
        System.out.println("Band Name clicked: " + clickedBandName);
        System.out.println("Task Name clicked: " + clickedTaskName);
        System.out.println("Patient Name: " + clickedPatFName);
    }

    private int getWorkShiftId(){
        //dbhelper changed to use view GetAllWardsWithCurrentWorkShift
        return DatabaseHelper.returnCurrentShiftId(wardId);
    }
}