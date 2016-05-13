@isTest
    private class DynamicQueryForContactGoals_Test {
        static testMethod void DynamicQueryForContactGoalsController() {
        //Entering test data
        Object_Configuration__c objConfig=new Object_Configuration__c();
        objConfig.sObject_1__c = 'Client__c';
        objConfig.sObject_2__c = 'dream_map__c';
        objConfig.sObject_3__c = 'Goals__c';
        objConfig.sObject_4__c = 'Objectives__c';
        objConfig.sObject_Field_1__c = 'first_name__c, last_name__c, email__c, address__c';
        objConfig.sObject_Field_2__c = 'agency_name__c, record_id__c, primary_object_name__c, email__c, contact_name__c';
        objConfig.sObject_Field_3__c = 'name, completion_date__c, description_of_goal__c, discontinued_date__c, goal_type__c, objective_count__c, status__c';
        objConfig.sObject_Field_4__c = 'describe_objectives__c, potential_barrier__c, potential_strength__c, service_needed__c, target_date__c, start_date__c';
        insert objConfig;
        system.assert(objConfig.Id != null , 'Configuration Record Created'); 

        client__c client=new client__c(Last_Name__c='Lee');
        insert client;
        system.assert(client.Id != null , 'Client Record Created'); 

        Dream_Map__c dreammap=new Dream_Map__c();
        dreammap.Agency_Name__c='test';
        insert dreammap;
        system.assert(dreammap.Id != null , 'Dream Map Record Created'); 

        //Entering custom settings
        RequiredFields__c reqFields = new RequiredFields__c (Name = Label.List_Of_Required_and_Hidden_Fields);
        reqFields.RequiredFieldsForsObject1__c = 'first_name__c';
        reqFields.RequiredFieldsForsObject2__c='Contact_Name__c';
        reqFields.RequiredFieldsForsObject3__c='Completion_Date__c , Status__c , Goal_Type__c';
        reqFields.RequiredFieldsForsObject4__c='Describe_objectives__c , Potential_Barrier__c';
        reqFields.HiddenFieldsForsObject3__c='status__c';
        reqFields.HiddenFieldsForsObject4__c='start_date__c';
        insert reqFields;

        StatusObject__c statusApiName = new StatusObject__c (Name='objectFilter');
        statusApiName.FieldName__c = 'status__c';
        statusApiName.ObjectName__c = 'Goals__c';
        insert statusApiName;
        
        CheckboxObject__c checkBoxActive = new CheckboxObject__c(Name = 'CheckBox');
        checkBoxActive.ObjectName__c = 'Dream_Map__c';
        checkBoxActive.FieldName__c='isActive__c';
        insert checkBoxActive;
        
        //Testing class 
        Test.setCurrentPage(Page.DynamicQueryForContactGoalsPage);
        ApexPages.currentPage().getParameters().put('objConfigId',objConfig.Id);
        DynamicQueryForContactGoalsController objController = new DynamicQueryForContactGoalsController();
        DisplayPopupExt extPopup = new DisplayPopupExt(objController);
        objController.objGoal = client;
        objController.addRemoveObjectiveSection();
        Apexpages.currentPage().getParameters().put('dreamMapDetails', dreammap.Id);
        QueryBuilderUtility.createObject(objConfig.sObject_4__c);
        objController.addObjectiveSection();
        objController.addRemoveObjectiveSection();
        objController.accessibleFieldsToDisplay();
        objController.displayGoalsFields();
        objController.strDreamGoalId=dreammap.id;
        objController.saveGoal();
        objController.insertObjectives();
        List<Sobject> rtype = new List<Sobject>();
        rtype=[Select name From Objectives__c];
        List<String> EmptyFields = new List<String>();
        objController.checkEmpltyFields (rtype,EmptyFields); 
        objController.cancelFromController();
        }
      }