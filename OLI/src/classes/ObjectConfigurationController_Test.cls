@isTest
private class ObjectConfigurationController_Test {

    static testMethod void testObjectConfigurationController() {
        //inserting test data
        Object_Configuration__c objCon = new Object_Configuration__c();
        objCon.sObject_1__c = 'Event';
        objCon.sObject_2__c = 'Dream_Map__c';
        objCon.sObject_3__c = 'Objectives__c';
        objCon.sObject_4__c = 'Goals__c';
        objCon.sObject_Field_1__c = 'Test field1';
        objCon.sObject_Field_2__c = 'Test field2';
        objCon.sObject_Field_3__c = 'Test field3';
        objCon.sObject_Field_4__c = 'Test field4';
        insert objCon;
        system.assert(objCon.Id != null , 'Configuration Record Created'); 

        //inserting custom settings
        IgnoreObjects__c objIgnore = new IgnoreObjects__c();
        objIgnore.Name = 'ignoreObject';
        objIgnore.Objects_Name__c = 'Test, Test1';
        insert objIgnore;
        system.assert(objIgnore.Id != null , 'Ignore Objects Record Created');

        //testing class functionality
        ObjectConfigurationController objController = new ObjectConfigurationController();
        objController.primaryObj = 'Account';
        objController.getAllObjects();
        objController.getFirstLvlChildObjects ();
        objController.isFromLink=false; 
        objController.disForthObjFields();
        objController.firstLvlChildObj = 'Account';
        objController.isFromLink=false; 
        objController.disSecObjFields();
        objController.disThirdObjFields();
        objController.disFirstObjFields();
        objController.getSecLvlChildObjects();
        objController.getPrimaryObjFields();
        objController.getFirtChildObjFields();
        objController.getSecChildObjFields();
        objController.getThirdChildObjFields();
        objController.getThirdLvlChildObjects();
        objController.clearSelectedFields(objController.firstObjFields);
        ObjectConfigurationController.getChildObjects('Account');
        objController.getFirstLvlChildObjects();
        objController.selectedFields(objController.getObjFields(objController.firstLvlChildObj, ObjectConfigurationController.getFieldSet(objController.secondObjFields)));
        objController.customSave();
        objController.showMessage = false;
        objController.customSave();
        objController.showFieldsSecond=false;
        objController.refresh();
        objController.nullCheck();
        objController.showFieldsSecond=true;
        objController.showFieldsThird=true;
        objController.showFieldsForth=true;
        objController.refresh();
    }
}