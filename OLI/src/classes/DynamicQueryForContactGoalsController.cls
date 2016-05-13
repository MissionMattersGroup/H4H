/* Descreption: This Controller Creates new Goals and related Objectives.
 *
 *      Author              Date (DD-MM-YYYY)       Version           Change Log
 *      Siddharth Pandit    28/02/2015                1.0             Initial Draft
 *                                                                    field for Dream Map.
 *      Dhirendra Verma     02/09/2015                1.1             Optimized the code for set of required and hidden
 *                                                                    field for Dream Map and called through 
 *                                                                    Query Builder.
 *
 */   
public with sharing class DynamicQueryForContactGoalsController{

    /*Variables And List Declaration*/
    public integer accessFieldsObjectivesSize { get { return accessFieldsObjectives.size( ); } }
    public sObject objGoal                                 { get; set; }
    public List<sObject> lstForthObj                       { get; set; }
    public sObject objDetails                              { get; set; }
    public String objGoalName                              { get; set; }
    public String objObjectiveName                         { get; set; }
    public Map<String, Boolean> accessibleFieldsGoals      { get; set; }
    public Map<String, Boolean> accessFieldsObjectives     { get; set; }
    public List<String> accessibleFieldsForDreammap        { get; set; }
    public Map<String,String> mapApiNameLabel              { get; set; }
    public Boolean flag                                    { get; set; }
    public boolean isEmpty                                 { get; set; }
    public Integer checkSize                               { get; set; }
    public String objectiveField                           { get; set; }
    public String goalField                                { get; set; }
    public String dreamMapIdOnGoal                         { get; set; }
    public String goalIdOnObjective                        { get; set; }
    public Object_Configuration__c objconfiguration { get; set; }
    public String strClientId                              { get; set; }
    public String strDreamGoalId                           { get; set; }
    public List<String> accessibleFieldsForGoals           { get; set; }
    public List<String> accessibleFieldsForObjectives      { get; set; }
    
    private String apiNameOnGoal;
    private String apiNameOnObjective;
    private Integer count = 1;
    private String objConId;
    private static final String strRequiredHiddenFields = Label.list_of_required_and_hidden_fields;
    RequiredFields__c reqFields;
    private static final String strCheckBoxValue = Label.ActiveCheckBoxForDM;
    private CheckboxObject__c activeFieldSetting;

    Set<String> referenceFields = new Set<String>();

    // Constructor 
    public DynamicQueryForContactGoalsController() {
        mapApiNameLabel = new  Map<String,String>();
        mapApiNameLabel = QueryBuilderUtility.retrievSobjectApiLabelMap();
        objConId = ApexPages.currentPage().getParameters().get('objConfigId');
        if (String.isNotBlank(objConId )) {
            String queryStr = QueryBuilderUtility.getObjConfigurationQueryString(objConId);
            objconfiguration = Database.query(queryStr);
        } // End if
        flag = false;
        isEmpty=false; 
        checkSize = 1;
        accessibleFieldsGoals = new Map<String, Boolean>();
        accessFieldsObjectives = new Map<String, Boolean> ();
        if(objconfiguration != null) {
            
            if(String.isNotBlank(strRequiredHiddenFields)){
                reqFields = RequiredFields__c.getValues(strRequiredHiddenFields);
            }// End if
            displayGoalsFields();
            fillMap ();
            strClientId = '';
            strClientId = Apexpages.currentPage().getParameters().get('clientId');
            if(Apexpages.currentPage().getParameters().get('dreamMapDetails')!=null)
                strDreamGoalId= Apexpages.currentPage().getParameters().get('dreamMapDetails');
            if(String.isNotBlank(strCheckBoxValue)){
                activeFieldSetting = CheckboxObject__c.getValues(strCheckBoxValue);
                if(activeFieldSetting!= null && String.isNotBlank(activeFieldSetting.ObjectName__c)){
                    if(!activeFieldSetting.ObjectName__c.equalsIgnoreCase(objconfiguration.sObject_2__c))
                        activeFieldSetting=null;
                }
            }// End if
        }// End if
        else{
            ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.FATAL, Label.Error_Msg_For_Providing_Id));
        } // End Else
    } //End of Constructor

    //Add the rows in Objective popup
    public pageReference addObjectiveSection () {
        lstForthObj.add(QueryBuilderUtility.createObject(objconfiguration.sObject_4__c));
        count ++;
        return null;
    }
        
    // This Method remove Row for objectives popup
    public pageReference addRemoveObjectiveSection() {
        try{
            if(lstForthObj.size()==1){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,
                                                                            System.Label.InfoMessageOneObjective);
                ApexPages.addMessage(myMsg);
                return null;
            }// End if
            if(lstForthObj.size() > 1 && !lstForthObj.isEmpty() ){
                count --;
                lstForthObj.remove(count);
            }// End if
        }
        catch(Exception e){System.debug(e);}
        return null;     
    }// End of Method

    // This Method Fetches the fields from sObj2,sObj3,sObj4 
    public void accessibleFieldsToDisplay(){
        accessibleFieldsForDreammap = 
                                  QueryBuilderUtility.retrieveDynamicFields(objconfiguration.sObject_2__c, 
                                                                           objconfiguration.sObject_Field_2__c);
        accessibleFieldsForGoals = 
                                  QueryBuilderUtility.retrieveDynamicFields(objconfiguration.sObject_3__c, 
                                                                            objconfiguration.sObject_Field_3__c);
        accessibleFieldsForObjectives = 
                                  QueryBuilderUtility.retrieveDynamicFields(objconfiguration.sObject_4__c, 
                                                                            objconfiguration.sObject_Field_4__c);
        if(reqFields != null){
            if(reqFields.HiddenFieldsForsObject3__c != null ){
                    Set<String> setOfHidForSobj3 = 
                                    QueryBuilderUtility.convertStrToSetStr(reqFields.HiddenFieldsForsObject3__c);
                    
                    accessibleFieldsForGoals = 
                                  QueryBuilderUtility.removeHiddenFields(setOfHidForSobj3,
                                                                          accessibleFieldsForGoals);
            }
            if(reqFields.HiddenFieldsForsObject4__c != null ){
                    Set<String> setOfHidForSobj4 = 
                                    QueryBuilderUtility.convertStrToSetStr(reqFields.HiddenFieldsForsObject4__c);
                    
                    accessibleFieldsForObjectives = 
                                  QueryBuilderUtility.removeHiddenFields(setOfHidForSobj4,
                                                                          accessibleFieldsForObjectives);
            }
        }
        
        objectiveField = 
                        QueryBuilderUtility.getRelatedObjName (objconfiguration.sObject_4__c,
                                                               objconfiguration.sObject_3__c).getLabel();
        goalField = 
                        QueryBuilderUtility.getRelatedObjName(objconfiguration.sObject_3__c,
                                                              objconfiguration.sObject_2__c).getLabel();
        dreamMapIdOnGoal = 
                        QueryBuilderUtility.getRelatedObjName(objconfiguration.sObject_3__c,
                                                               objconfiguration.sObject_2__c).getName();
        goalIdOnObjective = 
                        QueryBuilderUtility.getRelatedObjName(objconfiguration.sObject_4__c,
                                                                objconfiguration.sObject_3__c).getName();
        referenceFields.add(dreamMapIdOnGoal);
        referenceFields.add(goalIdOnObjective);
    }// End Method

    // This Method retrieves the Api name of object and Fields from Object Config
    public void displayGoalsFields(){
        lstForthObj = new List<sObject> ();
        accessibleFieldsToDisplay();
        objObjectiveName = objconfiguration.sObject_4__c;
        objGoalName = objconfiguration.sObject_3__c;
        if(objconfiguration.sObject_2__c != null && objconfiguration.sObject_2__c != null){ 
            objDetails  = QueryBuilderUtility.createObject(objconfiguration.sObject_2__c);
        }// End if
        if(objconfiguration.sObject_3__c != null && objconfiguration.sObject_3__c != null ){ 
            objGoal = QueryBuilderUtility.createObject(objconfiguration.sObject_3__c);
        }// End if
        if(objconfiguration.sObject_4__c != null && objconfiguration.sObject_4__c != null ){
            sObject sObjectFourth = QueryBuilderUtility.createObject(objconfiguration.sObject_4__c);
            if(sObjectFourth != null){
                lstForthObj.add (sObjectFourth);
            }// End if
        }// End if
        Schema.DescribeFieldResult lookupFieldDesc = 
                            QueryBuilderUtility.getRelatedObjName(objconfiguration.sObject_3__c,
                                                                  objconfiguration.sObject_2__c);
        if( lookupFieldDesc != null)
        {//Get the LookUp Field for Objective related to Goals
            apiNameOnGoal =  lookupFieldDesc.getName();
        }// End if
        Schema.DescribeFieldResult lookupFieldDescribe = 
                            QueryBuilderUtility.getRelatedObjName(objconfiguration.sObject_4__c,
                                                                  objconfiguration.sObject_3__c);
        if(lookupFieldDescribe != null){
            apiNameOnObjective =  lookupFieldDescribe.getName();
        }// End if
    }// End Method

    //Method to make field required which are present in the custom setting
    public void fillMap () {
         if (!accessibleFieldsForGoals.isEmpty()) {
            for (String fieldName : accessibleFieldsForGoals) {
                accessibleFieldsGoals.put(fieldName, FALSE);
            }// End For
        }// End if
        if(!accessibleFieldsForObjectives.isEmpty()) {
            for (String fieldName : accessibleFieldsForObjectives) {
                accessFieldsObjectives.put(fieldName, FALSE);
            }// End For
        }// End if
        if(reqFields != null){
	        if(reqFields.RequiredFieldsForsObject3__c != null){
	                Set<String> setOfReqForSobj3 = 
	                             QueryBuilderUtility.convertStrToSetStr(reqFields.RequiredFieldsForsObject3__c);
	                // Make the fields required for Goals which are added in custom settings
	                accessibleFieldsGoals = 
	                                QueryBuilderUtility.showRequiredFields(setOfReqForSobj3, accessibleFieldsForGoals);
	       }
	       if(reqFields.RequiredFieldsForsObject4__c != null){
                    Set<String> setOfReqForSobj4 = 
                                 QueryBuilderUtility.convertStrToSetStr(reqFields.RequiredFieldsForsObject4__c);
                    // Make the fields required for Objectives which are added in custom settings
                    accessFieldsObjectives = 
                               QueryBuilderUtility.showRequiredFields(setOfReqForSobj4, accessibleFieldsForObjectives);
           }
       }
    }// End Method

    // This Method inserts Goals 
    public PageReference saveGoal(){
        List<sObject> goalList = new List<sObject> ();
        if (objGoal !=  null){
            goalList.add (objGoal);
            if(String.isBlank(strDreamGoalId)){
                if(String.isNotBlank(Apexpages.currentPage().getParameters().get('dreamMapDetails')))
                    strDreamGoalId=Apexpages.currentPage().getParameters().get('dreamMapDetails');
            } // End if
            if(String.isNotBlank(strDreamGoalId)) {
                try{
                    objGoal.put(apiNameOnGoal,strDreamGoalId);
                    insert objGoal;
                    insertObjectives();
                    if(activeFieldSetting!=null && String.isNotBlank(activeFieldSetting.FieldName__c)){
                        String query = 'SELECT ' + activeFieldSetting.FieldName__c +
                        ' FROM ' + objconfiguration.sObject_2__c + ' WHERE Id = \'' + strDreamGoalId 
                        + '\' LIMIT 1';
                        objDetails = Database.query(query)[0];
                        if(objDetails.get(activeFieldSetting.FieldName__c)==false){
                            PageReference reRend = Page.DynamicQueryForDreamMap;
                            reRend.getParameters().put('clientId', strClientId);
                            reRend.getParameters().put('objConfigId', objConId);
                            reRend.setRedirect(true);
                            return reRend;
                        } // End if
                    } // End if
                    PageReference reRend = Page.DynamicQueryForDreamMap;
                    reRend.getParameters().put('clientId', strClientId);
                    reRend.getParameters().put('dreamMapDetails', strDreamGoalId);
                    reRend.getParameters().put('objConfigId', objConId);
                    reRend.setRedirect(true);
                    return reRend;
                }catch(Exception e){
                    Apexpages.addMessages(e);
                } // End catch
            }// End if
        }// End if
        return null;
    }// End Method

    // This Method checks the field on objective is blank
    public Boolean checkEmpltyFields (List<sObject> sobjList, List<String> accessibleFields) {
        Boolean isEmptyField = false;
        for(sobject sobjInstance : sobjList){
            for(String checkfield : accessibleFields){
                if (referenceFields != null &&  
                                            !referenceFields.contains(string.valueOf(sobjInstance.get(checkfield)))) {
                    if((sobjInstance.get(checkfield) == '' || sobjInstance.get(checkfield) == null)){
                        isEmptyField = true;
                    } // End if
                } // End if
            }// End For
        }// End For
        return false;
    } // End Method

    // This Method inserts Objectives for respective Goal
    public PageReference insertObjectives () {
        List<sObject> lstObjsToInsert = new List<sObject> ();
        if(!lstForthObj.isEmpty()){
            for (sObject aObjective: lstForthObj) {
                aObjective.put(apiNameOnObjective,objGoal.id);
                lstObjsToInsert.add (aObjective);
            }// End For
        try{
            insert lstObjsToInsert;
            PageReference reRend = Page.DynamicQueryForDreamMap;
            reRend.getParameters().put('clientId', strClientId);
            reRend.getParameters().put('dreamMapDetails', strDreamGoalId);
            reRend.setRedirect(true);
            return reRend;
        } // End try
        catch(Exception e){}
        }// End Catch
        return null;
    }// End Method
    
    // This method is redirecting user to dream map detail page
    public PageReference cancelFromController(){
        strDreamGoalId=Apexpages.currentPage().getParameters().get('dreamMapDetails');
        PageReference reRend = Page.DynamicQueryForDreamMap;
        reRend.getParameters().put('clientId', strClientId);
        reRend.getParameters().put('dreamMapDetails', strDreamGoalId);
        reRend.getParameters().put('objConfigId', objConId);
        reRend.setRedirect(true);
        return reRend;
    }// End Metod
}