@isTest
private class FinishLocationControllerTest {

    static testMethod void redirectToOLIClient() {
    	
    	Shelter_Call__c objShelter = new Shelter_Call__c();
    	objShelter.First_Name__c = 'Test Name';
    	insert objShelter;
    	
    	OLI_Client__c objOLIClient = new OLI_Client__c();
    	objOLIClient.Shelter_Id__c = objShelter.id;
    	objOLIClient.Name = 'Test Data';
    	objOLIClient.RecordTypeId = Schema.SObjectType.OLI_Client__c.RecordTypeInfosByName.get('Mother').RecordTypeId;
    	insert objOLIClient;
    	
    	Apexpages.currentpage().getparameters().put('id',objShelter.id);
        FinishLocationController objFinishLocation = new FinishLocationController();
        objFinishLocation.getClientId();
        System.assertEquals(objFinishLocation.lstOLIClient[0].id, objOLIClient.id);
    }
}