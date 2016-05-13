@isTest
private class CreateSelfSufficiencyEvaluationTest {

    static testMethod void createSelfSufficiencyRecords() {
    	
        list<OLI_Client__c> lstOLIClient = new list<OLI_Client__c>();
        for(Integer i = 0; i < 10; i++) {
	        OLI_Client__c objClient = new OLI_Client__c();
	        objClient.Name = 'Test Mother Client'+ i;
	        objClient.RecordTypeId = 
	        Schema.SObjectType.OLI_Client__c.getRecordTypeInfosByName().get('Mother').getRecordTypeId();
	        lstOLIClient.add(objClient);
        }
        Test.startTest();
        insert lstOLIClient;
        Test.stopTest();
        
        list<SelfSufficiency_Evaluation__c> lstSelf = [Select Id, OLI_Client__c 
                                                       from SelfSufficiency_Evaluation__c 
                                                       where OLI_Client__c =: lstOLIClient[0].Id];
        System.assertEquals(lstOLIClient[0].Id, lstSelf[0].OLI_Client__c);
        System.assertEquals(true, lstSelf.size() > 0);
    }
}