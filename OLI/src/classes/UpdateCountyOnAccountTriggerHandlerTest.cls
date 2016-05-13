@isTest
private class UpdateCountyOnAccountTriggerHandlerTest {

    static testMethod void updateAccountWithCounty() {
        // Test Data for Zip Codes
        ZipCode__c zipIns = new ZipCode__c();
        ZipCode__c zipInst = new ZipCode__c();
        zipInst.Name = '10011';
        zipInst.County__c = 'US';
        zipIns.Name = '63001';
        zipIns.County__c = 'India';
        insert zipIns;
        insert zipInst;
        
        // Test Data for Account
        List<Account> lstAccount = new List<Account>();
        List<Account> lstToUpdateAcc = new List<Account>();
        Account objAccount = new Account();
        Account objAcc = new Account();
        objAccount.Name = 'Test Account';
        objAccount.BillingPostalCode = '63001';
        objAccount.RecordTypeId =
        Schema.SObjectType.Account.getRecordTypeInfosByName().get('Organization').getRecordTypeId();
        objAcc.Name = 'Test Account 1';
        objAcc.BillingPostalCode = '';
        objAcc.RecordTypeId = 
        Schema.SObjectType.Account.getRecordTypeInfosByName().get('Organization').getRecordTypeId();
        lstAccount.add(objAccount);
        lstAccount.add(objAcc);
        Test.startTest();
        insert lstAccount;
        Test.stopTest();
        
        objAcc.Type = 'Other';
        lstToUpdateAcc.add(objAcc);
        update lstToUpdateAcc;
        
        for(Account objAc : [SELECT Id, Name, BillingPostalCode, County_Billing__c
                                      FROM Account]){
            if(objAc.BillingPostalCode == '63001'){
                System.assertEquals(objAc.County_Billing__c, zipIns.County__c);
            }
            if(objAc.BillingPostalCode == null){
                System.assertEquals(objAc.County_Billing__c, null);
            }
        }
    }
}