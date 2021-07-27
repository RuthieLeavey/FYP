package com.example.wms_mobapp;

import androidx.appcompat.app.AppCompatActivity;

import android.annotation.SuppressLint;
import android.content.Intent;
import android.graphics.Color;
import android.os.Bundle;
import android.widget.TextView;

import com.github.mikephil.charting.charts.PieChart;
import com.github.mikephil.charting.data.Entry;
import com.github.mikephil.charting.data.PieData;
import com.github.mikephil.charting.data.PieDataSet;
import com.github.mikephil.charting.data.PieEntry;
import com.github.mikephil.charting.highlight.Highlight;
import com.github.mikephil.charting.listener.OnChartValueSelectedListener;
import com.github.mikephil.charting.utils.ColorTemplate;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class PieChartActivity extends AppCompatActivity {

    Integer subModelId, workModelId;
    String clickedPatFName, clickedPatLName;
    public static String clickedTaskName;
    public static Float clickedTaskRatio;
    public static Integer clickedTaskId;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_pie_chart);
        getSupportActionBar().setTitle("Patient Tasks");
        getSupportActionBar().setDisplayHomeAsUpEnabled(true);

        subModelId = MobileAccountHomePage.subModelId;
        System.out.println("sub model id from previous activity is: " + subModelId);
        workModelId = null;
        clickedPatFName = MobileAccountHomePage.clickedPatFName;
        System.out.println("Patient name from previous activity is: " + clickedPatFName);
        clickedPatLName = MobileAccountHomePage.clickedPatLName;

        List<String> taskNames = new ArrayList<>();
        List<Float> taskRatios = new ArrayList<>();
        List<Integer> taskIds = new ArrayList<>();

        ResultSet rs = DatabaseHelper.returnPatientPieInfo(subModelId);
        storeTaskInfoInLists(rs, taskNames, taskRatios, taskIds);

        displayPie(taskNames, taskRatios, taskIds);

    }

    private void storeTaskInfoInLists(ResultSet rs, List<String> tasks, List<Float> ratios, List<Integer> ids){
        try{
            while(rs.next()){
                String taskName = rs.getString("WorkTaskName");
                tasks.add(taskName);
                Float taskRatio = rs.getFloat("TaskSubModelRatio");
                ratios.add(taskRatio);
                Integer taskId = rs.getInt("WorkTask_ID");
                ids.add(taskId);
                workModelId = rs.getInt("WorkModel_ID");
            }
        }catch(SQLException e){
            System.out.println("Error: " + e);
        }
    }

    //for line 291 - KNOW WHY ****
    @SuppressLint("SetTextI18n")
    private void displayPie(final List<String> tasks, List<Float> ratios, final List<Integer> ids){
        TextView patientNameTv = findViewById(R.id.patientPieNameTextView);
        patientNameTv.setText("Patient: " + clickedPatFName + " " + clickedPatLName);

        PieChart patientPie = findViewById(R.id.patientPie);
        ArrayList<PieEntry> pieTasks = new ArrayList<>();
        for(int i=0; i<tasks.size(); i++){
            pieTasks.add(new PieEntry((Float)ratios.get(i), (String)tasks.get(i)));
        }

        PieDataSet pieDataSet = new PieDataSet((pieTasks), "Tasks");
        pieDataSet.setColors(ColorTemplate.COLORFUL_COLORS);
        pieDataSet.setValueTextColor(Color.BLACK);
        pieDataSet.setValueTextSize(16f);

        PieData data = new PieData(pieDataSet);

        patientPie.setData(data);
        patientPie.getDescription().setEnabled(false);
        patientPie.setDrawHoleEnabled(false);
        //**** only show task names not values

        patientPie.setOnChartValueSelectedListener(new OnChartValueSelectedListener() {
            @Override
            public void onValueSelected(Entry e, Highlight h) {
                PieEntry pe = (PieEntry)e;
                clickedTaskName = pe.getLabel();
                clickedTaskRatio = pe.getValue();
                System.out.println("Clicked name: " + clickedTaskName);
                System.out.println("Clicked ratio : " + clickedTaskRatio);
                clickedTaskId = returnClickedTaskId(clickedTaskName, tasks, ids);
                System.out.println("Clicked task id : " + clickedTaskId);

                //go to band activity
                Intent intent = new Intent(PieChartActivity.this, TaskBandActivity.class);
                startActivity(intent);
            }

            @Override
            public void onNothingSelected() {

            }
        });
    }

    public int returnClickedTaskId(String name, List<String> namesList, List<Integer> taskIds){
        for(int i=0; i<namesList.size(); i++){
            if (name.equals(namesList.get(i).toString()))
                clickedTaskId = Integer.parseInt(taskIds.get(i).toString());
        }
        return clickedTaskId;
    }
}