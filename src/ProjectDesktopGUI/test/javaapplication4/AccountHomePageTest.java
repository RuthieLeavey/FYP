/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package javaapplication4;

import java.sql.ResultSet;
import org.jfree.data.general.DefaultPieDataset;
import org.junit.After;
import org.junit.AfterClass;
import org.junit.Before;
import org.junit.BeforeClass;
import org.junit.Test;
import static org.junit.Assert.*;

/**
 *
 * @author harle
 */
public class AccountHomePageTest {
    
    public AccountHomePageTest() {
    }
    
    @BeforeClass
    public static void setUpClass() {
    }
    
    @AfterClass
    public static void tearDownClass() {
    }
    
    @Before
    public void setUp() {
    }
    
    @After
    public void tearDown() {
    }

    /**
     * Test of addWorkModelsToComboBox method, of class AccountHomePage.
     */
    @Test
    public void testAddWorkModelsToComboBox() {
        System.out.println("addWorkModelsToComboBox");
        ResultSet rs = null;
        AccountHomePage instance = new AccountHomePage();
        instance.addWorkModelsToComboBox(rs);
        // TODO review the generated test code and remove the default call to fail.
        fail("The test case is a prototype.");
    }

    /**
     * Test of doesTaskExist method, of class AccountHomePage.
     */
    @Test
    public void testDoesTaskExist() {
        System.out.println("doesTaskExist");
        AccountHomePage instance = new AccountHomePage();
        boolean expResult = false;
        boolean result = instance.doesTaskExist();
        assertEquals(expResult, result);
        // TODO review the generated test code and remove the default call to fail.
        fail("The test case is a prototype.");
    }

    /**
     * Test of displayExistingTaskBands method, of class AccountHomePage.
     */
    @Test
    public void testDisplayExistingTaskBands() {
        System.out.println("displayExistingTaskBands");
        ResultSet rs = null;
        AccountHomePage instance = new AccountHomePage();
        instance.displayExistingTaskBands(rs);
        // TODO review the generated test code and remove the default call to fail.
        fail("The test case is a prototype.");
    }

    /**
     * Test of displayExistingPieChartTasks method, of class AccountHomePage.
     */
    @Test
    public void testDisplayExistingPieChartTasks() {
        System.out.println("displayExistingPieChartTasks");
        Integer id = null;
        AccountHomePage instance = new AccountHomePage();
        instance.displayExistingPieChartTasks(id);
        // TODO review the generated test code and remove the default call to fail.
        fail("The test case is a prototype.");
    }

    /**
     * Test of prepareGUITableForNewModel method, of class AccountHomePage.
     */
    @Test
    public void testPrepareGUITableForNewModel() {
        System.out.println("prepareGUITableForNewModel");
        String pieChartName = "";
        String workModelDesc = "";
        AccountHomePage instance = new AccountHomePage();
        instance.prepareGUITableForNewModel(pieChartName, workModelDesc);
        // TODO review the generated test code and remove the default call to fail.
        fail("The test case is a prototype.");
    }

    /**
     * Test of getSumAllTasks method, of class AccountHomePage.
     */
    @Test
    public void testGetSumAllTasks() {
        System.out.println("getSumAllTasks");
        AccountHomePage instance = new AccountHomePage();
        float expResult = 0.0F;
        float result = instance.getSumAllTasks();
        assertEquals(expResult, result, 0.0);
        // TODO review the generated test code and remove the default call to fail.
        fail("The test case is a prototype.");
    }

    /**
     * Test of addTableValuesToDataset method, of class AccountHomePage.
     */
    @Test
    public void testAddTableValuesToDataset() {
        System.out.println("addTableValuesToDataset");
        DefaultPieDataset pieDataset = null;
        AccountHomePage instance = new AccountHomePage();
        instance.addTableValuesToDataset(pieDataset);
        // TODO review the generated test code and remove the default call to fail.
        fail("The test case is a prototype.");
    }

    /**
     * Test of displayPieChart method, of class AccountHomePage.
     */
    @Test
    public void testDisplayPieChart() {
        System.out.println("displayPieChart");
        DefaultPieDataset pieDataset = null;
        AccountHomePage instance = new AccountHomePage();
        instance.displayPieChart(pieDataset);
        // TODO review the generated test code and remove the default call to fail.
        fail("The test case is a prototype.");
    }

    /**
     * Test of doesBandExist method, of class AccountHomePage.
     */
    @Test
    public void testDoesBandExist() {
        System.out.println("doesBandExist");
        AccountHomePage instance = new AccountHomePage();
        boolean expResult = false;
        boolean result = instance.doesBandExist();
        assertEquals(expResult, result);
        // TODO review the generated test code and remove the default call to fail.
        fail("The test case is a prototype.");
    }

    /**
     * Test of getSumAllBands method, of class AccountHomePage.
     */
    @Test
    public void testGetSumAllBands() {
        System.out.println("getSumAllBands");
        AccountHomePage instance = new AccountHomePage();
        float expResult = 0.0F;
        float result = instance.getSumAllBands();
        assertEquals(expResult, result, 0.0);
        // TODO review the generated test code and remove the default call to fail.
        fail("The test case is a prototype.");
    }

    /**
     * Test of addNewTaskBand method, of class AccountHomePage.
     */
    @Test
    public void testAddNewTaskBand() {
        System.out.println("addNewTaskBand");
        String bandName = "";
        Float bandWeight = null;
        String bandDesc = "";
        AccountHomePage instance = new AccountHomePage();
        instance.addNewTaskBand(bandName, bandWeight, bandDesc);
        // TODO review the generated test code and remove the default call to fail.
        fail("The test case is a prototype.");
    }

    /**
     * Test of saveBandChanges method, of class AccountHomePage.
     */
    @Test
    public void testSaveBandChanges() {
        System.out.println("saveBandChanges");
        AccountHomePage instance = new AccountHomePage();
        instance.saveBandChanges();
        // TODO review the generated test code and remove the default call to fail.
        fail("The test case is a prototype.");
    }

    /**
     * Test of deleteBandsInDeletedList method, of class AccountHomePage.
     */
    @Test
    public void testDeleteBandsInDeletedList() {
        System.out.println("deleteBandsInDeletedList");
        AccountHomePage instance = new AccountHomePage();
        instance.deleteBandsInDeletedList();
        // TODO review the generated test code and remove the default call to fail.
        fail("The test case is a prototype.");
    }

    /**
     * Test of displayTasksForSelectedWorkModel method, of class AccountHomePage.
     */
    @Test
    public void testDisplayTasksForSelectedWorkModel() {
        System.out.println("displayTasksForSelectedWorkModel");
        AccountHomePage instance = new AccountHomePage();
        instance.displayTasksForSelectedWorkModel();
        // TODO review the generated test code and remove the default call to fail.
        fail("The test case is a prototype.");
    }

    /**
     * Test of deleteTaskThatUserEntered method, of class AccountHomePage.
     */
    @Test
    public void testDeleteTaskThatUserEntered() {
        System.out.println("deleteTaskThatUserEntered");
        String taskToDelete = "";
        AccountHomePage instance = new AccountHomePage();
        instance.deleteTaskThatUserEntered(taskToDelete);
        // TODO review the generated test code and remove the default call to fail.
        fail("The test case is a prototype.");
    }

    /**
     * Test of addNewTask method, of class AccountHomePage.
     */
    @Test
    public void testAddNewTask() {
        System.out.println("addNewTask");
        String taskName = "";
        Float taskWeight = null;
        String taskDesc = "description";
        AccountHomePage instance = new AccountHomePage();
        instance.addNewTask(taskName, taskWeight, taskDesc);
        // TODO review the generated test code and remove the default call to fail.
        fail("The test case is a prototype.");
    }

    /**
     * Test of saveTaskChanges method, of class AccountHomePage.
     */
    @Test
    public void testSaveTaskChanges() {
        System.out.println("saveTaskChanges");
        AccountHomePage instance = new AccountHomePage();
        instance.saveTaskChanges();
        // TODO review the generated test code and remove the default call to fail.
        fail("The test case is a prototype.");
    }

    /**
     * Test of deleteTasksInDeletedList method, of class AccountHomePage.
     */
    @Test
    public void testDeleteTasksInDeletedList() {
        System.out.println("deleteTasksInDeletedList");
        AccountHomePage instance = new AccountHomePage();
        instance.deleteTasksInDeletedList();
        // TODO review the generated test code and remove the default call to fail.
        fail("The test case is a prototype.");
    }

    /**
     * Test of displaySubModelTaskAndWeight method, of class AccountHomePage.
     */
    @Test
    public void testDisplaySubModelTaskAndWeight() {
        System.out.println("displaySubModelTaskAndWeight");
        Integer taskId = null;
        AccountHomePage instance = new AccountHomePage();
        instance.displaySubModelTaskAndWeight(taskId);
        // TODO review the generated test code and remove the default call to fail.
        fail("The test case is a prototype.");
    }

    /**
     * Test of displayExistingSubModelTasks method, of class AccountHomePage.
     */
    @Test
    public void testDisplayExistingSubModelTasks() {
        System.out.println("displayExistingSubModelTasks");
        Integer subId = null;
        AccountHomePage instance = new AccountHomePage();
        instance.displayExistingSubModelTasks(subId);
        // TODO review the generated test code and remove the default call to fail.
        fail("The test case is a prototype.");
    }

    /**
     * Test of prepareGUITableForNewSubModel method, of class AccountHomePage.
     */
    @Test
    public void testPrepareGUITableForNewSubModel() {
        System.out.println("prepareGUITableForNewSubModel");
        String subName = "";
        String subDesc = "";
        AccountHomePage instance = new AccountHomePage();
        instance.prepareGUITableForNewSubModel(subName, subDesc);
        // TODO review the generated test code and remove the default call to fail.
        fail("The test case is a prototype.");
    }

    /**
     * Test of doestaskExistinSub method, of class AccountHomePage.
     */
    @Test
    public void testDoestaskExistinSub() {
        System.out.println("doestaskExistinSub");
        String tsk = "";
        AccountHomePage instance = new AccountHomePage();
        boolean expResult = false;
        boolean result = instance.doestaskExistinSub(tsk);
        assertEquals(expResult, result);
        // TODO review the generated test code and remove the default call to fail.
        fail("The test case is a prototype.");
    }

    /**
     * Test of getSumAllSubModelTaskRatios method, of class AccountHomePage.
     */
    @Test
    public void testGetSumAllSubModelTaskRatios() {
        System.out.println("getSumAllSubModelTaskRatios");
        AccountHomePage instance = new AccountHomePage();
        float expResult = 0.0F;
        float result = instance.getSumAllSubModelTaskRatios();
        assertEquals(expResult, result, 0.0);
        // TODO review the generated test code and remove the default call to fail.
        fail("The test case is a prototype.");
    }

    /**
     * Test of saveSubModelChanges method, of class AccountHomePage.
     */
    @Test
    public void testSaveSubModelChanges() {
        System.out.println("saveSubModelChanges");
        Integer wrkTskId = null;
        AccountHomePage instance = new AccountHomePage();
        instance.saveSubModelChanges(wrkTskId);
        // TODO review the generated test code and remove the default call to fail.
        fail("The test case is a prototype.");
    }

    /**
     * Test of main method, of class AccountHomePage.
     */
    @Test
    public void testMain() {
        System.out.println("main");
        String[] args = null;
        AccountHomePage.main(args);
        // TODO review the generated test code and remove the default call to fail.
        fail("The test case is a prototype.");
    }
    
}
