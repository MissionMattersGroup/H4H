@isTest
    private class DreamMapDetailsController_Test {
        static testMethod void DreamMapDetailsController() {
        // inseting test data
        Object_Configuration__c objConfig=new Object_Configuration__c();
        objConfig.sObject_1__c = 'Client__c';
        objConfig.sObject_2__c = 'Dream_Map__c';
        objConfig.sObject_3__c = 'Goals__c';
        objConfig.sObject_4__c = 'Objectives__c';
        objConfig.sObject_Field_1__c = 'first_name__c, last_name__c, email__c, address__c';
        objConfig.sObject_Field_2__c = 'agency_name__c, email__c, contact_name__c';
        objConfig.sObject_Field_3__c = 'name, completion_date__c, description_of_goal__c, discontinued_date__c, goal_type__c, objective_count__c, status__c';
        objConfig.sObject_Field_4__c = 'describe_Objectives__c, potential_barrier__c, potential_strength__c, service_needed__c, target_date__c, start_date__c';
        insert objConfig;
       
        client__c client=new client__c(Last_Name__c='Lee');
        insert client;
        system.assert(client.Id != null , 'Client Record Created'); 
       
        // insert the custom settings
        RequiredFields__c reqFields = new RequiredFields__c (Name = Label.List_Of_Required_and_Hidden_Fields);
        reqFields.RequiredFieldsForsObject1__c = 'first_name__c';
        reqFields.RequiredFieldsForsObject2__c='Contact_Name__c';
        reqFields.RequiredFieldsForsObject3__c='Completion_Date__c ,Status__c , Goal_Type__c';
        reqFields.RequiredFieldsForsObject4__c='describe_Objectives__c , Potential_Barrier__c';
        reqFields.HiddenFieldsForsObject2__c='Agency_Name__c';
        reqFields.HiddenFieldsForsObject3__c='status__c';
        reqFields.HiddenFieldsForsObject4__c='start_date__c';
        insert reqFields;

        StatusObject__c statusApiName = new StatusObject__c (Name='objectFilter');
        statusApiName.FieldName__c = 'status__c';
     
        insert statusApiName;

        // testing class
        Test.setCurrentPage(Page.DreamMapDetails);
        ApexPages.currentPage().getParameters().put('clientId',client.Id);
        ApexPages.currentPage().getParameters().put('objConfigId',objConfig.Id);
        DreamMapDetailsController objController = new DreamMapDetailsController();
        objController.strClientId=reqFields.Id;
        DisplayPopupExt objDisplay = new DisplayPopupExt(objController);
        QueryBuilderUtility.RetrieveDynamicFields(objConfig.sObject_2__c, objConfig.sObject_Field_2__c);
        objConfig.sObject_2__c='rrrr';
        QueryBuilderUtility.createObject('sss');
        objController.init();
        //objController.getFieldsToDis();
        objController.saveDreamMap();
        objController.CancelDreamMap();
        }
      }