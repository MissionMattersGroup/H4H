@isTest
private class DynamicObjectConfiguration_Test {

    static testMethod void DynamicObjectConfiguration() {
        Object_Configuration__c objConfig=new Object_Configuration__c();
        objConfig.sObject_1__c = 'Client__c';
        objConfig.sObject_2__c = 'Dream_Map__c';
        objConfig.sObject_3__c = 'Goals__c';
        objConfig.sObject_4__c = 'Objectives__c';
        objConfig.sObject_Field_1__c = 'first_name__c, last_name__c, email__c, address__c';
        objConfig.sObject_Field_2__c = 'agency_name__c, record_id__c, primary_object_name__c, email__c, contact_name__c';
        objConfig.sObject_Field_3__c = 'name, completion_date__c, description_of_goal__c, discontinued_date__c, goal_type__c, objective_count__c, status__c';
        objConfig.sObject_Field_4__c = 'describe_objectives__c, potential_barrier__c, potential_strength__c, service_needed__c, target_date__c, start_date__c';
        insert objConfig;
        
        client__c client=new client__c(Last_Name__c='Lee');
        insert client;

        Dream_Map__c dreammap=new Dream_Map__c();
        dreammap.Agency_Name__c='test';
        insert dreammap;
        
        DM_Search_Setting__c objSearchSetting = new DM_Search_Setting__c();
        objSearchSetting.Name='Test';
        objSearchSetting.Object_Api_Name__c = 'Object_Configuration__c';
        objSearchSetting.Section_Header__c = 'Dynamic Header';
        objSearchSetting.Field_CustomSetting_Api__c = 'DM_Search_Field_Setting__c';
        insert objSearchSetting; 
        
        DM_Search_Field_Setting__c objSearchFieldSetting = new  DM_Search_Field_Setting__c();
        objSearchFieldSetting.Name = 'Test';
        objSearchFieldSetting.Colspan_Number__c= 2;
        objSearchFieldSetting.Field_Api_Name__c = 'sObject_1__c';
        objSearchFieldSetting.Field_Label__c = 'sobject 1';
        objSearchFieldSetting.Order_Number__c = 2 ;
        insert objSearchFieldSetting;
        
        
        DynamicObjectConfigurationController objController = new DynamicObjectConfigurationController();
        objController.redirectCustomerSearchPage();
        objController.getListObjConfigs();
        objController.getLoginUserId();
    }
}