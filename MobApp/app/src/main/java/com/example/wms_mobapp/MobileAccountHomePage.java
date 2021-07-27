package com.example.wms_mobapp;

import android.annotation.SuppressLint;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.graphics.Color;
import android.os.Bundle;
import android.view.Gravity;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.Spinner;
import android.widget.TableLayout;
import android.widget.TableRow;
import android.widget.TextView;

import androidx.appcompat.app.AlertDialog;
import androidx.appcompat.app.AppCompatActivity;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class MobileAccountHomePage extends AppCompatActivity implements AdapterView.OnItemSelectedListener {

    //creating static variables so they can be accessed if i use another activity
    public static Integer subModelId, wardId, clickedPatEpMovId, staffId;
            //workModelId;
    public static String clickedPatFName, clickedPatLName;

    TableLayout wardTbl;
    TableRow wardTblRow;

//    TextView tv1, tv2, tv3, tv4, tv5, tv6;
//    TextView bandTv1, bandTv2, bandTv3;
//    private List tasks;
//    private List ratios;
//    private List ids;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_mobile_account_home_page);
        getSupportActionBar().setTitle("Wards & Patients");

        Spinner wardsSpinner = findViewById(R.id.wardSpinner);
        wardsSpinner.setOnItemSelectedListener(this);
        fillWardSpinner(wardsSpinner);

        //****** NEEDS TO BE SET TO STAFF ID WHO SIGNED IN *******
        staffId = MainActivity.staffId;

        subModelId = null;
        wardId = null;
        wardTbl = findViewById(R.id.wardTableLayout);
        clickedPatFName = null;
        clickedPatLName = null;
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu){
        MenuInflater inflater = getMenuInflater();
        inflater.inflate(R.menu.main_menu, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        if (item.getItemId() == R.id.logout) {
            logoutUser();
            return true;
        }

        return super.onOptionsItemSelected(item);
    }

    public void logoutUser(){
        new AlertDialog.Builder(this)
                .setMessage("Are you sure you want to logout?")
                .setCancelable(false)
                .setPositiveButton("Yes", new DialogInterface.OnClickListener() {
                    public void onClick(DialogInterface dialog, int id) {
                        staffId = 0;
                        Intent intent = new Intent(MobileAccountHomePage.this, MainActivity.class);
                        startActivity(intent);
                    }
                })
                .setNegativeButton("No", null)
                .show();              
    }

    public void fillWardSpinner(Spinner spinner) {
        List<String> wards = new ArrayList<>();
        wards.add("Select Ward");
        ResultSet rs = DatabaseHelper.returnWardNames();
        try{
            while(rs.next()){
                String wardName = rs.getString("WardName");
                wards.add(wardName);
            }

        }catch(SQLException e){
            System.out.println("Error: " + e);
        }

        ArrayAdapter<String> adapter = new ArrayAdapter<>(this, android.R.layout.simple_spinner_item, wards);
        adapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
        spinner.setAdapter(adapter);
    }

    @Override
    public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
        //clear table
        int count = wardTbl.getChildCount();
        System.out.println("Count: " + count);
        //index out of bounds error sometimes happens -NEED TO FIX **** FIXED BY -1
        if(count>1){
            wardTbl.removeViews(1, count-1);
        }
        String wardName = parent.getItemAtPosition(position).toString();
        if(!wardName.equals("Select Ward")){
            subModelId = DatabaseHelper.returnWardSubModId(wardName);
            wardId = DatabaseHelper.returnWardId(wardName);
            ResultSet rs = DatabaseHelper.returnPatientInfoOnWard(wardId);
            fillPatientTable(rs);
        }
    }

    @Override
    public void onNothingSelected(AdapterView<?> parent) {

    }

    private void fillPatientTable(ResultSet patientInfo){
        int rowId = 0;
        try{
            while(patientInfo.next()){
                String firstName = patientInfo.getString("PatFirstName");
                String lastName = patientInfo.getString("PatLastName");
                String bedName = patientInfo.getString("BedName");
                int epMovId = patientInfo.getInt("EpisodeMove_ID");
                String epMovIdStr = Integer.toString(epMovId);
                int bedId = patientInfo.getInt("Bed_ID");
                String bedIdStr = Integer.toString(bedId);
                int patId = patientInfo.getInt("Pat_ID");
                String patIdStr = Integer.toString(patId);

                addRowToTable(firstName, lastName, bedName, epMovIdStr, bedIdStr, patIdStr, rowId);
                rowId = rowId + 1;
            }
        }catch(SQLException e){
            System.out.println("Problem filling patient info: (see fillPatientList line 375)"+e);
        }
    }

    private void addRowToTable(String fn, String ln, String bed, String epMov, String bId, String patId, Integer rowId){
        System.out.println("Row Id: " + rowId);
        wardTblRow = new TableRow(this);
        wardTblRow.setId(rowId);
        TableRow.LayoutParams params = new TableRow.LayoutParams(0, TableRow.LayoutParams.MATCH_PARENT, 3.3f);
        params.height = 100;
        TableRow.LayoutParams params2 = new TableRow.LayoutParams(0, TableRow.LayoutParams.MATCH_PARENT, 0);
        params2.height = 100;

        addViewToRow(wardTblRow, fn, params, this);
        addViewToRow(wardTblRow, ln, params, this);
        addViewToRow(wardTblRow, bed, params, this);
        addViewToRow(wardTblRow, epMov, params2, this);
        addViewToRow(wardTblRow, bId, params2, this);
        addViewToRow(wardTblRow, patId, params2, this);

        setPatientTableClickListener(wardTblRow);

        wardTbl.addView(wardTblRow);
    }

    public void setPatientTableClickListener(TableRow wardRow){
        wardRow.setClickable(true);
        wardRow.setOnClickListener(new View.OnClickListener() {
            @SuppressLint("ResourceAsColor")
            @Override
            public void onClick(View v) {
                v.setBackgroundColor(R.color.bluePrimary);
                TableRow tr=(TableRow)v;
                int id = tr.getId();
                TextView t1 = (TextView)tr.getChildAt(0);
                clickedPatFName = t1.getText().toString();
                TextView t2 = (TextView)tr.getChildAt(1);
                clickedPatLName = t2.getText().toString();
                TextView t4 = (TextView)tr.getChildAt(3);
                String epMovStr = t4.getText().toString();
                clickedPatEpMovId = Integer.parseInt(epMovStr);
                TextView t5 = (TextView)tr.getChildAt(4);
                String bedIdStr = t5.getText().toString();
                int bedId = Integer.parseInt(bedIdStr);
                System.out.println("ROW CLICKED : " + clickedPatFName + " AND ID: " + id + " AND EPMOV: " + clickedPatEpMovId + "AND BEDID: " + bedId);
                goToPatientPieChartActivity();

            }
        });
    }

    public void goToPatientPieChartActivity(){
        Intent intent = new Intent(MobileAccountHomePage.this, PieChartActivity.class);
        startActivity(intent);
    }

    public static void addViewToRow(TableRow row, String viewText, TableRow.LayoutParams p, Context context){
        TextView tv = new TextView(context);
        tv.setText(viewText);
        tv.setTextSize(16);
        tv.setTextColor(Color.BLACK);
        tv.setGravity(Gravity.CENTER);
        tv.setLayoutParams(p);
        row.addView(tv);
    }

}
