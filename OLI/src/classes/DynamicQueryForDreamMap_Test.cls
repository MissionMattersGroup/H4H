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
 *
 *      Author              Date (DD-MM-YYYY)       Version           Change Log
 *      Siddharth Pandit    18/02/2015                1.0             Initial Draft
 *      Dhirendra Verma     02/07/2015                1.1             Improved the test class according to changes 
 *                                                                    in Dynamic Dream  GoalDetail Method 
 *
 */
@isTest
    private class DynamicQueryForDreamMap_Test {
        static testMethod void DynamicQueryForDreamMap() {
            //inserting test data
            Object_Configuration__c objConfigurationQuery = new Object_Configuration__c();
            String finalQuery='';
            objConfigurationQuery.sObject_1__c = 'Client__c';
            objConfigurationQuery.sObject_2__c = 'Dream_Map__c';
            objConfigurationQuery.sObject_3__c = 'Goals__c';
            objConfigurationQuery.sObject_4__c = 'Objectives__c';
            objConfigurationQuery.sObject_Field_1__c = 'first_name__c, last_name__c,'
                                                             +'email__c, address__c';
            objConfigurationQuery.sObject_Field_2__c = 'agency_name__c, email__c,'+
                                                              'contact_name__c';
            objConfigurationQuery.sObject_Field_3__c = 'completion_date__c, '+
                                                              'description_of_goal__c, '+
                                                              'discontinued_date__c,'+
                                                              'goal_type__c, objective_count__c,'+
                                                              'status__c';
            objConfigurationQuery.sObject_Field_4__c = 'describe_Objectives__c, '+
                                                              'potential_barrier__c, '+
                                                              'potential_strength__c, service_needed__c,'+
                                                              'target_date__c, start_date__c';
            insert objConfigurationQuery;
            system.assert (objConfigurationQuery.Id != null , 'Configuration Record Created'); 

            ComapanyLogo__c objCompanyLogo = new ComapanyLogo__c();
            objCompanyLogo.Name = 'Test Logo';
            objCompanyLogo.height__c = '15%';
            objCompanyLogo.imgLogo__c = 'http://www.google.com';
            objCompanyLogo.width__c = '10%';
            insert objCompanyLogo;
            system.assert(objCompanyLogo.Id != null , 'Company Logo Created'); 

            ColorCodeForPdf__c objColorCode = new  ColorCodeForPdf__c(Name='Test Setting',
            PdfBackgroundColour__c = 'RED',
            tdBgColorGoal__c = 'RED', 
            tdBgColorObjective__c = 'RED', 
            trBgColorGoal__c = 'RED', 
            trBgColorObjective__c = 'RED');
            insert objColorCode;
            system.assert(objColorCode.Id != null , 'Color code Record Created'); 

            Client__c client = new Client__c(Last_Name__c='Lee');
            insert client;
            system.debug('client.Id**************'+client.Id);
            system.assert(client.Id != null , 'Client Record Created'); 

            Dream_Map__c dreammap=new Dream_Map__c();
            dreammap.Agency_Name__c='test';
            dreammap.Client__c = client.Id;
            dreammap.isActive__c=true;
            insert dreammap;
            system.assert(dreammap.Id != null , 'Dream Map Record Created'); 

            Goals__c goal= new Goals__c(Dream_Map__c=dreammap.id);
            insert goal;
            system.assert(goal.Id != null , 'Goal Record Created');

            Objectives__c objObjective = new Objectives__c(Goal__c=goal.id);
            insert objObjective;
            system.assert(objObjective.Id != null , 'Objective Record Created'); 

            List<String> lstFields = new List<String>();
            Set<String>  setHiddenFields = new set<String>();

            // inserting custom settings
            CheckboxObject__c objCheckboxObject = 
                              new CheckboxObject__c (Name='CheckBox', FieldName__c='isActive__c');
            insert objCheckboxObject;
            
            StatusObject__c s = new StatusObject__c(FieldName__c = 'Status__c', Name = 'Status');
            insert s;
            system.assert(s.Id != null , 'Custom Setting Record Created'); 

            RequiredFields__c reqFields = 
                                        new RequiredFields__c (Name = Label.List_Of_Required_and_Hidden_Fields);
            reqFields.RequiredFieldsForsObject1__c = 'first_name__c';
            reqFields.RequiredFieldsForsObject2__c ='Contact_Name__c';
            reqFields.RequiredFieldsForsObject3__c
                                                  ='Completion_Date__c ,Status__c , Goal_Type__c';
            reqFields.RequiredFieldsForsObject4__c
                                                  ='describe_Objectives__c , Potential_Barrier__c';
            reqFields.HiddenFieldsForsObject3__c = 'status__c';
            reqFields.HiddenFieldsForsObject4__c = 'start_date__c';
            insert reqFields;

            StatusObject__c statusApiName = new StatusObject__c (Name='objectFilter');
            statusApiName.FieldName__c = 'status__c';
           
            insert statusApiName;
            
             CheckboxObject__c checkBoxActive = new CheckboxObject__c(Name = 'CheckBox');
            checkBoxActive.ObjectName__c = 'Dream_Map__c';
            checkBoxActive.FieldName__c='isActive__c';
            insert checkBoxActive;

            System.Test.setCurrentPage(Page.DynamicQueryForDreamMap);
            Apexpages.currentPage().getParameters().put('clientId', client.Id);
            Apexpages.currentPage().getParameters().put('objConfigId', objConfigurationQuery.Id);
            Apexpages.currentPage().getParameters().put('dreamMapDetails', dreammap.Id);
            Apexpages.currentPage().getParameters().put('goalSortField', 'Description_of_Goal__c');
            Apexpages.currentPage().getParameters().put('goalSortingDirection','false');
            Apexpages.currentPage().getParameters().put('selectedGoal',goal.id);
            Apexpages.currentPage().getParameters().put('objectiveSortingField','Describe_Objectives__c');
            Apexpages.currentPage().getParameters().put('objectiveSortingDirection','false');
            DynamicQueryForDreamMap objController = new DynamicQueryForDreamMap();
            //objController.strClientId = client.Id;
            objController.objConId    = objConfigurationQuery.Id;
            DisplayPopupExt extPopup  = new DisplayPopupExt(objController);
            extPopup.clientIdExt      = client.Id;
            extPopup.Cancel();
            extPopup.addGoalsAndObjectives();

            objController.strDreamGoalId=Apexpages.currentPage().getParameters().put('dreamMapDetails', dreammap.Id);
            objController.goalSortField=Apexpages.currentPage().
                                               getParameters().put('goalSortField', 'Description_of_Goal__c');
            objController.operatorSymbol='equals';
            objController.statusSelectedValue='New';
            objController.init();
            objController.detailDreamMap();
            objController.sortObjectives ();
            objController.goalIds();
            objController.goalDetailsList();
            objController.getItems();
            QueryBuilderUtility.createObject('Goals__c');
            objController.getitemsStatus();
            objController.filterList();
           // objController.retriveGoalDetails( DynamicQueryForDreamMap.getLstSobject(queryString));
            DynamicQueryForDreamMap.filterResult('equals','allStatus');
            DynamicQueryForDreamMap.filterResult('not equals','allStatus');
            DynamicQueryForDreamMap.filterResult('not equals',' ');
            DynamicQueryForDreamMap.filterResult('equals','new');
            DynamicQueryForDreamMap.filterResult('not equals','in progress');
            finalQuery=objController.getQueryParam( DynamicQueryForDreamMap.filterResult('equals','new'));
            //objController.incorrectFilter();
            objController.operatorSymbol=null;
            //objController.incorrectFilter();
            QueryBuilderUtility.constructQueryWithFKeys (objConfigurationQuery.sObject_4__c, 
                                                        objConfigurationQuery.sObject_Field_4__c,
                                                        objConfigurationQuery.sObject_3__c);
            
            objController.saveGoalDetails();
            objController.cancelDreamMap();
            objController.clearObjId_ToDisplayLstMap ();
            objController.addGoalsAndObjectives();
            objController.addDreamMap();
            objController.objectiveDetailstoAddRow();
            objController.removeRow();
            objController.goalSortField='Status__c';
            objController.sortGoals();
            objController.deleteObjective();
            objController.saveObjetives();
            objController.addRow();
            objController.firstPage();
            objController.previous();
            objController.next();
            objController.lastPage();
            objController.getprev();
            objController.getNext();
            objController.getSelectOptionsForPagination();
            //objController.objectiveDetailsList ('\''+ goal.Id +'\'');
            
            //objController.viewAsPDF();
            objController.editDreamMap();
            objController.saveDreamMaps();
            objController.getAllRecords();
            objController.showPopup();
            objController.closePopupGoals();
            objController.closePopup();
            //objController.viewAsPDF();    
            objController.showBtnOnEdit();
            objController.showPopup();  
            objController.saveObjectiveForEditLink();                             
           // objController.retriveGoalDetails( DynamicQueryForDreamMap.getLstSobject(queryString));
            objController.saveGoalFromLink();
            objController.deleteGoal();
            QueryBuilderUtility.removeHiddenFields(setHiddenFields,lstFields);
            Apexpages.currentPage().getParameters().put('dreamMapToDel',dreammap.id);
            objController.deleteDreamMaplst();
        }
     }