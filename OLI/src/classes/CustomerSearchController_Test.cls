@isTest
    private class CustomerSearchController_Test {
        static testMethod void CustomerSearchController() {
        //Test Data insertion
        //String query='last_name__c!=';
        //String queryString=query;//+'Data';
        String sortFullExp='last_name__c'; 
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
        system.assert(objConfig.Id != null , 'Configuration Record Created'); 

        //Testing class
        Test.setCurrentPage(Page.CustomerSearchPage);
        ApexPages.currentPage().getParameters().put('id',objConfig.Id);
        CustomerSearchController objController = new CustomerSearchController();
        objController.searchTextValue='last_name__c';
        objController.sortExpression='last_name__c';
        objController.setSortDirection('ASC');
        objController.operatorsymbol='!=';
        objController.inputText ='Data';
        objController.getfieldNames();
        objController.getoperator();
        objController.getSortDirection();
        objController.selectedVal = '1';
        objController.searchingRecords();
        objController.filterrecords();
        objController.getSearchResult();
        //objController.dynamicQuery(querystring);
        QueryBuilderUtility.constructQuery(objConfig.sObject_1__c,objConfig.sObject_Field_1__c);
        objController.showDreamMap();
        
        CustomerSearchController objController1 = new CustomerSearchController();
        objController1.sortExpression='test';
        objController.searchTextValue='last_name__c';
        objController.operatorsymbol=' LIKE ';
        objController.inputText ='a';
        objController.getfieldNames();
        objController.getoperator();
        objController.searchingRecords();
        objController.sorting(sortFullExp);
        objController.filterrecords();
        objController.getSearchResult();
        //objController.dynamicQuery(querystring);
        QueryBuilderUtility.constructQuery(objConfig.sObject_1__c,objConfig.sObject_Field_1__c);
        objController.inputText ='';
        objController.getfieldNames();
        objController.operatorsymbol='===';
        objController.getoperator();
        objController.searchingRecords();
        objController.sorting(sortFullExp);
        objController.filterrecords();
        objController.getSearchResult();
        //objController.dynamicQuery(querystring);
        QueryBuilderUtility.constructQuery(objConfig.sObject_1__c,objConfig.sObject_Field_1__c);

        objController.operatorsymbol=' NOT LIKE ';
        objController.inputText ='Data';
        objController.getfieldNames();
        objController.getoperator();
        objController.searchingRecords();
        objController.sorting(sortFullExp);
        objController.filterrecords();
        objController.getSearchResult();
        //objController.dynamicQuery(querystring);
        QueryBuilderUtility.constructQuery(objConfig.sObject_1__c,objConfig.sObject_Field_1__c);

        objController.fieldValue.add('');
        objController.operatorsymbol='=';
        objController.inputText ='';
        objController.getfieldNames();
        objController.getoperator();
        objController.searchingRecords();
        objController.sorting(sortFullExp);
        objController.filterrecords();
        objController.getSearchResult();
        //objController.dynamicQuery(querystring);
        //objController.sortingRecords();
        QueryBuilderUtility.constructQuery(objConfig.sObject_1__c,objConfig.sObject_Field_1__c);
        objController.operatorsymbol=' NOT LIKE ';
        objController.filterrecords();
        objController.sortingRecords();
        objController.FirstPage();
        objController.previous();
        objController.next();
        objController.LastPage();
        objController.getprev();
        objController.getNext();
        objController.getSelectOptionsForPagination();
        }
    }