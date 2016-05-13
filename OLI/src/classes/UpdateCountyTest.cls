/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class UpdateCountyTest {

    static testMethod void myUnitTest() {
        // Test Data for Zip Codes
        ZipCode__c zipIns = new ZipCode__c();
        ZipCode__c zipInst = new ZipCode__c();
        zipInst.Name = '10011';
        zipInst.County__c = 'US';
        zipIns.Name = '63001';
        zipIns.County__c = 'India';
        insert zipIns;
        insert zipInst;
        
        // Test Data for Shelter
        List<Shelter_Call__c> lstShel = new List<Shelter_Call__c>();
        Shelter_Call__c shelInstance = new Shelter_Call__c();
        Shelter_Call__c shelInst = new Shelter_Call__c();
        shelInstance.Current_Zip__c = '63001';
        shelInstance.X90_Nights_Zip__c = '10011';
        shelInst.Current_Zip__c = '';
        shelInst.X90_Nights_Zip__c = '';
        lstShel.add(shelInstance);
        lstShel.add(shelInst);
        insert lstShel;
        
        //Test Data for OLI Client
        OLI_Client__c oliInst = new OLI_Client__c();
        oliInst.Name = 'Test';
        insert oliInst;
        
        // Test Data For Addredd
        Address__c addInstance = new Address__c();
        addInstance.Zip__c = '63001';
        addInstance.Client__c = oliInst.Id;
        insert addInstance;
        addInstance = [SELECT Id, Zip__c, County__c
                       FROM Address__c];
        if(addInstance.Zip__c == '63001'){
            System.assertEquals(addInstance.County__c, zipIns.County__c);
        }
        
        for(Shelter_Call__c sheIns : [SELECT Id, X90_Nights_Zip__c, X90_Nights_County__c,
                                             Current_Zip__c, Current_County__c 
                                      FROM Shelter_Call__c]){
            if(sheIns.Current_Zip__c == '63001'){
                System.assertEquals(sheIns.Current_County__c, zipIns.County__c);
            }
            if(sheIns.Current_Zip__c == null){
                System.assertEquals(sheIns.Current_County__c, null);
            }
            if(sheIns.X90_Nights_Zip__c == '63001'){
                System.assertEquals(sheIns.X90_Nights_County__c, zipIns.County__c);
            }
            if(sheIns.X90_Nights_Zip__c == null){
                System.assertEquals(sheIns.X90_Nights_County__c, null);
            }                              
            
        }
     }
 }