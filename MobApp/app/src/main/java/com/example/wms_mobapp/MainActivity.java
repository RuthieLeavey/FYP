package com.example.wms_mobapp;

import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;

import java.sql.*;
import java.util.*;

public class MainActivity extends AppCompatActivity {

    public static Connection conn;
    public static Integer staffId;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        ConnectionHelper conHelper = new ConnectionHelper();
        conn = conHelper.connectionclass();
        getSupportActionBar().setTitle("WMS");

        clickListenerLoginButton();
    }

    public void clickListenerLoginButton(){
        Button loginButton = findViewById(R.id.loginButton);
        loginButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                EditText userET = findViewById(R.id.usernameEditText);
                EditText passwordET = findViewById(R.id.passwordEditText);

                String username = userET.getText().toString();
                char[] pass = (passwordET.getText().toString()).toCharArray();
                System.out.println("Pass array: " + passwordET.getText().toString() + "  END");

                //check if username and password are empty
                ensureNoEmptyFields(username, pass);
                //check if password is correct
                checkForCorrectPassword(username, pass);
                //
                Arrays.fill(pass, '0');

            }
        });
    }

    public void ensureNoEmptyFields(String user, char[] pass){
        if(user.isEmpty() || pass.length == 0) {
            Toast.makeText(this, "Please enter a username and password!", Toast.LENGTH_SHORT).show();
        }
    }

    public void checkForCorrectPassword(String user, char[] pass){
        if(isPasswordCorrect(conn, user, pass)){
            Toast.makeText(this, "You typed the correct username and password!", Toast.LENGTH_SHORT).show();
            staffId = getStaffId(conn, user);
            Intent intent = new Intent(this, MobileAccountHomePage.class);
            startActivity(intent);
        }else{
            Toast.makeText(this, "Invalid username/password.\n Please try again!", Toast.LENGTH_LONG).show();
        }
    }

    public static boolean isPasswordCorrect(Connection conn, String user, char[] input) {     // https://docs.oracle.com/javase/tutorial/uiswing/components/passwordfield.html
        boolean isCorrect;
        String password = getPassword(conn, user);

        char[] correctPassword = new char[password.length()];   // user entered pw is array so we create array of DB gathered pw to compare
        for (int i = 0; i < password.length(); i++) {
            correctPassword[i] = password.charAt(i);
        }
        isCorrect = Arrays.equals (input, correctPassword);     // bool isCorrect = are they identical
        Arrays.fill(correctPassword,'0');   // zero out password so java code not storing it in variable
        System.out.println("isCorrect = " + isCorrect);
        return isCorrect;
    }

    public static String getPassword(Connection conn, String user) {
        String password = "";
        try {
            Statement selectPasswordStmt = conn.createStatement();     // initialize statement
            ResultSet rs = selectPasswordStmt.executeQuery(String.format("SELECT Password FROM Staff WHERE Unique_ID = '%s'", user));
            while (rs.next()) {
                password = rs.getString(1);
                System.out.println("password: " + password);
            }
        }
        catch (SQLException e) {
            System.out.println("SQL Exception caught: " + e.getMessage());
        }
        return password;
    }

    public static Integer getStaffId(Connection conn, String user){
        int id = 0;
        try{
            Statement selectStaffTypeStmt = conn.createStatement();     // initialize statement
            ResultSet rs = selectStaffTypeStmt.executeQuery(String.format("SELECT Staff_ID FROM Staff WHERE Unique_ID = '%s'", user));     // use statement to execute query (get staff id of username entered)
            while (rs.next()) {
                id = rs.getInt(1);
                System.out.println("staffID: " + id);
            }
        } catch (SQLException e) {
            System.out.println("SQL Exception caught in getStaffId: " + e.getMessage());
        }
        return id;
    }
}