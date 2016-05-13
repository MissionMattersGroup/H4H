/* Descreption: This is class for Dynamically Fetching the objects from the setup and display the Dream Map,
 *              Goal and objective records accordingly.
 *      Author              Date (DD-MM-YYYY)       Version         Change Log
 *      Siddharth Pandit    18/02/2015                1.0           Initial Draft
 *      Dhirendra Verma     22/05/2015                1.1           Removed the delete functionality and updated the 
 *                                                                  Object Config Id through url.
 *      Dhirendra Verma     24/06/2015                1.2           Optimized the code to resolve Error CPU time limit
 *                                                                  in goalDetailsList method
 *      Siddharth Pandit    28/07/2015                1.3           Optimizing the class to replace hard coded values 
 *                                                                  with constants
 *      Siddharth Pandit    12/08/2015                1.4           Removed the extra functions and applied pagination
 *                                                                  for the table
 *      Siddharth Pandit    12/08/2015                1.5           Added the functionality for required field for all 
 *                                                                  the Sobjects.
 *      Dhirendra Verma     28/08/2015                1.6           Added the functionality for hidden fields for all 
 *                                                                  Sobject and added null check for objList.Sobject.
 *      Dhirendra Verma     31/08/2015                1.7           Move the method  requiredHiddenFields &
 *                                                                  convertStrToSetStrto QueryBuilder Class.
 *      Dhirendra Verma     21/09/2015                1.7           Resolve the filter issue where on search it should
 *                                                                  kfilter acording to the criteria
 *      Anuradha Nimbalkar  4/11/2015                 1.8           Custom settings to show signature
 *      Twinkle Panjabi     4/11/2015                 1.9           Added a lines to check for mod condition in LastPage()
 */
public with sharing class DynamicQueryForDreamMap {

    // Variables
    private static final String STR_REQUIRED_HIDDEN_FIELDS = Label.list_of_required_and_hidden_fields;
    private static final String STR_CHECKBOX_VAL = Label.ActiveCheckBoxForDM;
    private static final String STR_STATUS_VAl = Label.ObjectNameAndFieldNameCustomSetting;
    private static final String STR_NO = Label.Error_Message_No;
    private static final String STR_REC_FND = Label.Error_Message_Record_Not_Found;
    private static final String STR_OBJ_CONFIG_ID = 'objConfigId';
    private static final String STR_CLIENT_ID = 'clientId';
    private static final String STR_DREAM_MAP_DETAILS = 'dreamMapDetails';
    private static final String STR_EQUALS = 'equals';
    private static final String STR_NOT_EQUALS = 'not equals';
    private static final String STR_ALL_STATUS_VAL = 'allStatus';
    private static final String STR_GOAL_SORT_FIELD = 'goalSortField';
    private static final String STR_GOAL_SRT_DIRECT = 'goalSortingDirection';
    private static final String STR_OBJ_SRT_FIELD = 'objectiveSortingField';
    private static final String STR_OBJ_SRT_DIR = 'objectiveSortingDirection';
    private static final String STR_SELECTED_GOAL = 'selectedGoal';
    private static final String STR_DMAP_TO_DEL = 'dreamMapToDel';
    private static final String STR_GOAL_ID = 'goalId';
    private static final String STR_OBJ_ID = 'ObjectiveId';
    private static final String STR_ALL_STATUS = 'All Status';
    private static final String STR_WHERE = 'WHERE';
    private static final String STR_ID = 'Id';
    private static final String STR_OPR_EQL = '=';
    private static final String STR_AND = 'AND';
    private static final String STR_TRUE = 'true';
    private static final String STR_SPACE = ' ';
    private static final String STR_BLANK = '';
    private static final String STR_LIMIT_ZERO = 'LIMIT 0';
    private static final String STR_ORDER_BY = 'ORDER BY';
    private static final String STR_FALSE = 'false';
    private static final String STR_DESC_NUL_LST = ' DESC NULLS LAST ';
    private static final String STR_ASC_NUL_FST = 'ASC NULLS FIRST';
    private static final String STR_COMMA = ',';
    private static final String STR_SINGLE_QUOTE = '\'';
    private static final String STR_NOT_EQU = '!=';
    private static final String STR_LIMIT = 'LIMIT';
    private static final String STR_OFFSET = 'OFFSET';
    private static final String STR_TEXTAREA = 'textarea';
    private static final String FORWARD_SLASH = '/';
    private static final String STR_IN = 'IN';
    private static final String STR_OPENPAR = '(';
    private static final String STR_CLOSEPAR = ')';
    private static final String STR_RENDER_AS_PDF = 'renderAsPDF';
    private static final String STR_TRUE_VAL = 'true';
    public Object_Configuration__c objConfigList         { get; set; }
    public List<String> accessibleFieldsForClient        { get; set; }
    public List<String> accessibleFieldsForDreamMap      { get; set; }
    public List<String> accessibleFieldsForGoals         { get; set; }
    public List<String> accessibleFieldsForObjectives    { get; set; }
    public Map<String, Boolean> accessFieldsObjectives   { get; set; }
    public Map<String, Boolean> accessFieldsDreamMap     { get; set; }
    public Map<String, Boolean> accessFieldsGoals        { get; set; }
    public Integer firstGoalColumnWidthConstant          { get; set; }
    public Integer firstObjectiveColumnWidthConstant     { get; set; }
    public sObject objectFromSetup                       { get; set; }
    public String clientsid                              { get; set; }
    public String editableDreamMap                       { get; set; }
    public List<sObject> clientDetails                   { get; set; }
    public List<sObject> dreamMapDetails                 { get; set; }
    public String dreamMapId                             { get; set; }
    public List<sObject> dreamMapDetailsSelectedId       { get; set; }
    public String objName                                { get; set; }
    public String objDreamMapName                        { get; set; }
    public String objGoalName                            { get; set; }
    public String objObjectiveName                       { get; set; }
    public Boolean showBtn                               { get; set; }
    public Boolean editBtn                               { get; set; }
    public String strClientId                            { get; set; }
    public String strDreamGoalId                         { get; set; }
    public String dreamMapField                          { get; set; }
    public String goalField                              { get; set; }
    public String goalId                                 { get; set; }
    public String objectiveId                            { get; set; }
    public Boolean canEdit                               { get; set; }
    public List<toDisplay> lstToDisplayForObjective      { get; set; }
    public Boolean displayPopup                          { get; set; }
    public Boolean popupForObjectives                    { get; set; }
    public List<toDisplay> todisplayList                 { get; set; }
    public List<ComapanyLogo__c> imgLogoList             { get; set; }
    public String tdBgColorGoal                          { get; set; }
    public String tdBgColorObjective                     { get; set; }
    public String trBgColorGoal                          { get; set; }
    public String trBgColorObjective                     { get; set; }
    public String logoUrl                                { get; set; }
    public String widthImg                               { get; set; }
    public String heightImg                              { get; set; }
    public String PdfBackgroundColour                    { get; set; }
    public string dynamicLabel                           { get; set; }
    public String operatorSymbol                         { get; set; }
    public String statusSelectedValue                    { get; set; }
    public Map<String,String> mapApiNameLabel            { get; set; }
    public String goalSortField                          { get; set; }
    public String objectiveSortField                     { get; set; }
    public Boolean goalSortingDirection                  { get; set; }
    public Boolean objectiveSortingDirection             { get; set; }
    public String selectedGoal                           { get; set; }
    public String objConId                               { get; set; }
    public Boolean sortError                             { get; set; }
    public integer offsetSize                            { get; set; }
    public integer totalRecs                             { get; set; }
    public integer limitSize                             { get; set; }
    public String selectedVal                            { get; set; }
    public List<Allow_Signature__c> signatureList        { get; set; }
    public integer accessFieldsObjectivesSize {
        get {
            return accessFieldsObjectives.size();
        }
    }
    //private static final String STR_STATUS = SobjectType.Goals__c.Fields.Status__c.Name;
    private static String strStatusField;
    private List<ColorCodeForPdf__c> colorCodeList;
    private String queryStrForDreamMap;
    private String finalQuery;
    private String strDreamIdToDel;
    private String parentObjectName;
    private String lookupPrimaryObject;
    private String lookupDreamMapName;
    private String lookupGoalName;
    private String strGoalId ;
    private RequiredFields__c reqFields;
    private CheckboxObject__c checkboxApiName;
    private List<String> accessibleSelectedFieldsForDreamMap;
    private String lastGoalSortField;
    private String lastObjectiveSortField;
    private Integer count = 1;
    private Map<String, toDisplay> mapObjId_TodispayList;
    private String goalStrIds; // this string will be comma separated Goal ids to filter objectives
    //Constructor 
    public DynamicQueryForDreamMap () {
        strStatusField = '';
        sortError=false;
        objConId = ApexPages.currentPage().getParameters().get(STR_OBJ_CONFIG_ID);
        if (String.isNotBlank(objConId )) {
            String queryStr = QueryBuilderUtility.getObjConfigurationQueryString(objConId);
            objConfigList = Database.query(queryStr);
        }
        mapApiNameLabel = new  Map<String,String>();
        mapApiNameLabel = QueryBuilderUtility.retrievSobjectApiLabelMap();
        accessFieldsObjectives = new Map<String, Boolean> ();
        accessFieldsDreammap   = new Map<String, Boolean> ();
        accessFieldsGoals      = new Map<String, Boolean> ();
        if (mapObjId_TodispayList == null) {
            init();
            showRecords();
            //Details displayed on load if one dream map present
            goalDetailsList();
            showImgLogo();
        } // End if
    }//End Method

    //Method to Intialize Map,List,Sobject
    public void init()
    {
    	if(Allow_Signature__c.getall().values() != null) {
    		signatureList = Allow_Signature__c.getall().values(); 
    	}
        mapObjId_TodispayList = new Map<String, toDisplay> ();
        lstToDisplayForObjective = new List <toDisplay> ();
        strClientId = Apexpages.currentPage().getParameters().get(STR_CLIENT_ID);
        todisplayList = new List<toDisplay> ();
        accessibleFieldsForClient = new List<String> ();
        clientDetails = new  List<sObject>();
        dreamMapDetails = new  List<sObject>();
        //accessibleFieldsForDreamMap = new List<String> ();
        editBtn = false;
        showBtn = false;
        popupForObjectives = false;
        canEdit = true;
        accessibleSelectedFieldsForDreamMap = new List<String> ();
        goalSortingDirection = false;objectiveSortingDirection = false;selectedGoal = STR_BLANK;
        goalSortField = STR_BLANK;objectiveSortField = STR_BLANK;
        lastGoalSortField = STR_BLANK;
        lastObjectiveSortField = STR_BLANK;
        finalQuery = STR_BLANK;
        lookupPrimaryObject = STR_BLANK;
        offsetSize = 0;
        totalRecs = 0;
        limitSize = 5; //Integer.valueOf(selectedVal);
        reqFields = RequiredFields__c.getValues(STR_REQUIRED_HIDDEN_FIELDS);
        // Methods
        retrieveFieldsDynamically();
        requiredHiddenFields();
        detailDreamMap();
        getListDreamMaps();
    }//End Method

    //Method to show Image Logo and colour code from custom setting
    public void showImgLogo() {
        imgLogoList = ComapanyLogo__c.getall().values(); 
            if(imgLogoList != null && imgLogoList.size()>0){
                logoUrl = imgLogoList[0].imgLogo__c;
                widthImg = imgLogoList[0].width__c;
                heightImg = imgLogoList[0].height__c;
             }  // End if
            colorCodeList =  ColorCodeForPdf__c.getall().values();
            if(colorCodeList != null && colorCodeList.size()>0){
                for(ColorCodeForPdf__c colorpdf : colorCodeList){
                    tdBgColorGoal = colorpdf.tdBgColorGoal__c;
                    tdBgColorObjective = colorpdf.tdBgColorObjective__c;
                    trBgColorGoal = colorpdf.trBgColorGoal__c;
                    trBgColorObjective = colorpdf.trBgColorObjective__c;
                    PdfBackgroundColour = colorpdf.PdfBackgroundColour__c;
                } // End for
            } // End if
    }
    
    // method to retrieve fields from Object configuration object
    public void retrieveFieldsDynamically() {
        if (String.isNotBlank(objConId )) {
            dreamMapField = QueryBuilderUtility.getRelatedObjName (objConfigList.sObject_3__c,
                                                            objConfigList.sObject_2__c).getLabel();
            if(objConfigList.sObject_2__c != null && objConfigList.sObject_Field_2__c != null) {
                accessibleFieldsForDreamMap = 
                    QueryBuilderUtility.retrieveDynamicFields(objConfigList.sObject_2__c,
                                                                objConfigList.sObject_Field_2__c);
            }
            objGoalName = objConfigList.sObject_3__c;
            if(mapApiNameLabel.get(objConfigList.sObject_3__c) !=null) {
                firstGoalColumnWidthConstant = 
                                        mapApiNameLabel.get(objConfigList.sObject_3__c).length()/2;
            }
            if(mapApiNameLabel.get(objConfigList.sObject_4__c) !=null) {
                firstObjectiveColumnWidthConstant = 
                                        mapApiNameLabel.get(objConfigList.sObject_4__c).length()/2;
            }
        } // End if
    }
    
    // Method to make field required and check active record to display
    public void requiredHiddenFields() {
        if(String.isNotBlank(STR_CHECKBOX_VAL)){
            checkboxApiName = CheckboxObject__c.getValues(STR_CHECKBOX_VAL);
            if(checkboxApiName != null && String.isNotBlank(checkboxApiName.ObjectName__c )
                                && objConfigList != null && objConfigList.sObject_2__c != null) {
                if(!checkboxApiName.ObjectName__c.equalsIgnoreCase(objConfigList.sObject_2__c) )
                    checkboxApiName=null;
            }
        }
    }

    //Method to rerender the outpanel on click of edit link
    public PageReference showBtnOnEdit() {
        return null;
    }//End Method

    //Hide the Popup for goals
    public void  closePopupGoals() {
        popupForObjectives = false;
        displayPopup = false; 
        lstToDisplayForObjective.clear();
    }//End Method

    //Hide the Popup
    public void  closePopup() {
        popupForObjectives=false;
        displayPopup = false; 
        refresh();
        lstToDisplayForObjective.clear();
    }//End Method

    //Show the Popup
    public void showPopup() {
        displayPopup = true; 
        showBtn = false;
    }//End Method

    //Details of Client and Dream Map
    public void detailDreamMap() {
        try{
            accessibleFieldsForClient = 
                            QueryBuilderUtility.retrieveDynamicFields(objConfigList.sObject_1__c,
                                                                 objConfigList.sObject_Field_1__c);
            //To remove the hidden fields for Client List on Dream Map Page
            if(reqFields != null && reqFields.HiddenFieldsForsObject1__c != null)
            {
                Set<String> setOfHidForSobj1 = 
                                QueryBuilderUtility.convertStrToSetStr(reqFields.HiddenFieldsForsObject1__c);
                accessibleFieldsForClient = 
                              QueryBuilderUtility.removeHiddenFields(setOfHidForSobj1,
                                                                      accessibleFieldsForClient);
            }
            objName = objConfigList.sObject_1__c;
            String queryStr =
                    QueryBuilderUtility.constructQuery (objConfigList.sObject_1__c,
                                                        objConfigList.sObject_Field_1__c);
            queryStr += STR_SPACE + STR_WHERE + STR_SPACE + STR_ID + STR_SPACE + STR_OPR_EQL + 
                        STR_SPACE + STR_SINGLE_QUOTE + strClientId + STR_SINGLE_QUOTE;
            clientDetails = Database.query(queryStr);
            if (clientDetails == null || clientDetails.size() == 0) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,
                                    STR_NO + STR_SPACE + 
                                    mapApiNameLabel.get(objConfigList.sObject_1__c) + 
                                    STR_REC_FND));
                editBtn = true;
            }
            
            
        }catch(Exception e) {
            ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.FATAL, 
                                                                Label.ErrorMsgForDreamMapDeatils));
        }
    }

    //Method for Dream Map related Object Details
     public void getListDreamMaps(){
        try{
            if(objConfigList.sObject_2__c != null && objConfigList.sObject_Field_2__c != null) {
                objDreamMapName = objConfigList.sObject_2__c;
                Schema.Describefieldresult referenceFieldDescribe =
                            QueryBuilderUtility.getRelatedObjName (objConfigList.sObject_2__c,
                                                                    objConfigList.sObject_1__c);
                if(referenceFieldDescribe != null)
                    lookupPrimaryObject = referenceFieldDescribe.getName();
                else{
                    ApexPages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR,
                                                                Label.NoSecondaryToPrimaryLookup));
                    editBtn = true;
                    return;
                }
                if(checkboxApiName != null && String.isNotBlank(checkboxApiName.FieldName__c)){
                    for(Integer i = 0; i < accessibleFieldsForDreamMap.size(); i++ ) {
                        if (accessibleFieldsForDreamMap.get(i)
                                        .equalsIgnoreCase(checkboxApiName.FieldName__c)){
                            accessibleFieldsForDreamMap.remove(i);
                            i--;
                        }
                    }
                }
            }
            if(accessibleFieldsForDreamMap !=null && !accessibleFieldsForDreamMap.isEmpty()) {
            for (String fieldName : accessibleFieldsForDreamMap) {
                 accessFieldsDreamMap.put(fieldName, FALSE);
            	}// End For
        	}//End If
            //To remove the hidden fields for Dream Map List on Dream Map Page
            if(reqFields != null){
	            if(reqFields.HiddenFieldsForsObject2__c != null){
		            Set<String> setOfHidForSobj2 = 
		                          QueryBuilderUtility.convertStrToSetStr(reqFields.HiddenFieldsForsObject2__c);
		            accessibleFieldsForDreamMap = 
		                          QueryBuilderUtility.removeHiddenFields(setOfHidForSobj2,
		                                                                  accessibleFieldsForDreamMap);
		            
	            }
	            if(reqFields.RequiredFieldsForsObject2__c != null){
	             Set<String> setOfReqForSobj2 = 
                                QueryBuilderUtility.convertStrToSetStr(reqFields.RequiredFieldsForsObject2__c);
                 // Make the fields required for Dream Map which are added in custom settings
                 accessFieldsDreamMap = 
                                QueryBuilderUtility.showRequiredFields(setOfReqForSobj2, accessibleFieldsForDreamMap);
	            }
            }
        }
        catch(exception e){
             ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.FATAL,
                                                                Label.ErrorMsgForDreamMapDeatils));
        }
    }//End Method
    
    //Method is to display Active records from the object
    public void showRecords() {
        dreamMapDetails = new List<sObject> ();
        if (String.isNotBlank(strClientId) && String.isNotBlank(objConId )) {
            queryStrForDreamMap =  QueryBuilderUtility.constructQuery (objConfigList.sObject_2__c,
                                                                objConfigList.sObject_Field_2__c);
    
            if (String.isNotBlank(queryStrForDreamMap) && checkboxApiName != null &&
                    String.isNotBlank(checkboxApiName.FieldName__c) && lookupPrimaryObject != null){
                queryStrForDreamMap += STR_SPACE + STR_WHERE + STR_SPACE + lookupPrimaryObject +
                                        STR_SPACE + STR_OPR_EQL + STR_SINGLE_QUOTE + strClientId +
                                        STR_SINGLE_QUOTE +STR_SPACE+ STR_AND + STR_SPACE +
                                        checkboxApiName.FieldName__c + STR_SPACE + STR_OPR_EQL + 
                                        STR_TRUE;
            } else if (lookupPrimaryObject != null) {
                queryStrForDreamMap += STR_SPACE + STR_WHERE + STR_SPACE + lookupPrimaryObject +
                                        STR_SPACE + STR_OPR_EQL + STR_SPACE + STR_SINGLE_QUOTE +
                                        strClientId + STR_SINGLE_QUOTE;
            }
            try { // this try has tobe removed -Sid
                if (String.isNotBlank(queryStrForDreamMap)) {
                    dreamMapDetails = Database.query(queryStrForDreamMap);
                }
            } catch (Exception e ) {
            }
            objGoalName = objConfigList.sObject_3__c;
        }
        
    }//End Method

    //Method is to display the filters Equals or Not Equals
    public List<SelectOption> getItems() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption(STR_EQUALS, STR_EQUALS));
        options.add(new SelectOption(STR_NOT_EQUALS, STR_NOT_EQUALS));
        return options;
    }//End Method

    //Method to display the Status Values for filtering table. 
    public List<SelectOption> getitemsStatus() {
        list<SelectOption> optionsList = new list<SelectOption>();
        optionsList.add(new SelectOption(STR_ALL_STATUS_VAL, STR_ALL_STATUS)); // defult value
        String fieldName; // status field apiName for filtering
        StatusObject__c statusApiName = StatusObject__c.getValues(STR_STATUS_VAl);
        if (statusApiName != null && statusApiName.FieldName__c != null) {
            
            if (statusApiName != null && String.isNotBlank(statusApiName.FieldName__c)) {
                strStatusField = statusApiName.FieldName__c;
                    // Get the object type of the SObject.
                if(String.isNotBlank(objGoalName)){
                    map<String, Schema.SObjectField> fieldMap = 
                        Schema.getGlobalDescribe().get(objGoalName).getDescribe().fields.getMap();
                    for (Schema.SObjectField sObjField : fieldMap.values()) {
                            if (sObjField.getDescribe().getName() != null &&
                                    sObjField.getDescribe().getName().equalsIgnoreCase (statusApiName.FieldName__c)) {
                                list<Schema.PicklistEntry> lstOfPicklistValue =
                                                        sObjField.getDescribe().getPickListValues();
                                // Add these values to the selectoption list.
                                for (Schema.PicklistEntry pickListValue : lstOfPicklistValue) { 
                                        optionsList.add(new SelectOption(pickListValue.getLabel(),
                                                            pickListValue.getValue()));
                                } // End for
                                break;
                            } // End if
                    } // End for
                } // End if
            } // End if
        }
        return optionsList;
    }//End Method

    //Method to display Goal details according to filter criteria.
    public static String filterResult (String opr, String stVal) {
        String whereCond;
        if(opr == null){return whereCond;}
        if (opr.equalsIgnoreCase(STR_EQUALS) && stVal.equalsIgnoreCase(STR_ALL_STATUS_VAL))
            whereCond = STR_BLANK;
        if (opr.equalsIgnoreCase(STR_NOT_EQUALS) && stVal.equalsIgnoreCase(STR_ALL_STATUS_VAL))
            whereCond = STR_SPACE + STR_LIMIT_ZERO + STR_SPACE; // No records to be displayed
        if (opr.equalsIgnoreCase(STR_EQUALS) && !stVal.equalsIgnoreCase(STR_ALL_STATUS_VAl) && 
           String.isNotBlank(strStatusField))
            whereCond = STR_SPACE + STR_AND + STR_SPACE + strStatusField + STR_OPR_EQL + 
                        STR_SINGLE_QUOTE + stVal + STR_SINGLE_QUOTE;
        if (opr.equalsIgnoreCase(STR_NOT_EQUALS) && !stVal.equalsIgnoreCase(STR_ALL_STATUS_VAl) && 
            String.isNotBlank(strStatusField))
            whereCond = STR_SPACE + STR_AND + STR_SPACE + strStatusField + STR_NOT_EQU + 
                        STR_SINGLE_QUOTE  +stVal + STR_SINGLE_QUOTE;
        return whereCond;
    }//End Method

    //Method to retrieve the goal Id 
    public String goalIds(){
        String urlDreamMapId = Apexpages.currentPage().getParameters().get(STR_DREAM_MAP_DETAILS);
        if (( dreamMapDetails != null ) && ( dreamMapDetails.size() == 1) ) {
            return dreamMapDetails[0].Id;
        } else {
            return urlDreamMapId;
        }
        return null;
    }//End Method
    
    //Method Retrieves all goal Records related to DreampMap
     public void goalDetailsList(){
        if (String.isBlank(strDreamGoalId)){
            strDreamGoalId = goalIds();
        }
        sortError = false;
        dreamMapDetailsSelectedId = new List<sObject>();
        if (String.isNotBlank(objConId) && String.isNotBlank (strDreamGoalId)) {
            objDreamMapName = objConfigList.sObject_2__c;
            queryStrForDreamMap = QueryBuilderUtility.constructQuery (objConfigList.sObject_2__c, objConfigList.sObject_Field_2__c);
            queryStrForDreamMap += STR_SPACE + STR_WHERE + STR_SPACE + STR_SPACE + STR_ID + STR_SPACE + STR_OPR_EQL + STR_SINGLE_QUOTE + strDreamGoalId + STR_SINGLE_QUOTE;
            dreamMapDetailsSelectedId = Database.query(queryStrForDreamMap);
            dreammapid = strDreamGoalId;
            if(strDreamGoalId != null ) {
                finalQuery = getQueryParam(null);
                String orderBy = ''; //goalObjectiveSort(); This has to be fix - Sid
                if (String.isNotBlank(orderBy)) {
                    finalQuery += orderBy;
                }
                List<Sobject> goalObjList = getLstSobject(finalQuery);
                retriveGoalDetails(goalObjList);
            }
           // sortObjectives();
        }
       // return null;
    }//End Method
    
   /* //Method to assign sorting functionality to Goals and Objectives
   public static String goalObjectiveSort() {
        String orderByClause;
        String goalSorting = Apexpages.currentPage().getParameters().get(STR_GOAL_SORT_FIELD);
        String goalSortDirection = Apexpages.currentPage().getParameters().get(STR_GOAL_SRT_DIRECT);
      /*  if (goalSorting != null && !String.isBlank(goalSorting)) {
            orderByClause = STR_SPACE + STR_ORDER_BY + STR_SPACE + goalSorting;
            if  (goalSortDirection != null && goalSortDirection.equalsIgnoreCase (STR_FALSE)) {
                orderByClause += STR_SPACE + STR_DESC_NUL_LST + STR_SPACE;
            } else {
                orderByClause += STR_SPACE + STR_ASC_NUL_FST + STR_SPACE;
            }
            
        } // End if 
        return orderByClause;
    }*/
    //Method to clear mapObjId_TodispayList
    public void clearObjId_ToDisplayLstMap () {
        if (mapObjId_TodispayList != null && mapObjId_TodispayList.size() > 0)
            mapObjId_TodispayList.clear();
    }

    //Method to show the list of goals according  to the filter criteria.
    public PageReference filterList() {
        offsetSize = 0;
        totalRecs = 0;
        if (strDreamGoalId != null ) {
            finalQuery = getQueryParam (filterResult(operatorSymbol, statusSelectedValue));
            system.debug('finalQuery**************'+finalQuery);
            retriveGoalDetails(getLstSobject(finalQuery));
            goalSortField = STR_BLANK;
            objectiveSortField = STR_BLANK;
            selectedGoal = STR_BLANK;
        }
        return null;
    }//End Method

    //Sorting of Goals
    public Pagereference sortGoals(){
        if (dreamMapId != null ) {
            finalQuery = getQueryParam (filterResult(operatorSymbol, statusSelectedValue));
            if (goalSortField != lastgoalSortField)
                goalSortingDirection = false;
            if(String.isNotBlank(goalSortField)){
                Schema.DisplayType objDisplayType = checkFieldType(objGoalName, goalSortField);
                if(string.valueOf(objDisplayType).equalsIgnorecase(STR_TEXTAREA)) {
                    sortError = true;
                }
                else {
                    sortError = false;
                  /*finalQuery += STR_SPACE + STR_ORDER_BY + STR_SPACE;
                    finalQuery += goalSortField;
                    finalQuery += goalSortingDirection == true? STR_SPACE + STR_DESC_NUL_LST + 
                                    STR_SPACE: STR_SPACE + STR_ASC_NUL_FST;
                    goalSortingDirection = !goalSortingDirection; */
                    lastGoalSortField = goalSortField;
                    List<Sobject> goalList = getLstSobject(finalQuery);
                    if(goalList != null){
                        totalRecs = goalList.size();
                    }
                    retriveGoalDetails(goalList);
                }
            }
        }
        return null;
    }//End Method

    //Sorting of objectives
    public Pagereference sortObjectives () {
       // QueryBuilderUtility.checkFieldType(objObjectiveName);
		/* This has to be fix in later release - Sid
	 String objectiveSortingFieldVal = 
                                    Apexpages.currentPage().getParameters().get(STR_OBJ_SRT_FIELD);
        String objectiveSortingFieldDirectionVal =
                                    Apexpages.currentPage().getParameters().get(STR_OBJ_SRT_DIR);
        objectiveSortField = objectiveSortingFieldVal == null ? STR_BLANK : objectiveSortingFieldVal;
        objectiveSortingDirection = (objectiveSortingFieldDirectionVal != null &&
                                    objectiveSortingFieldDirectionVal.equalsIgnoreCase (STR_FALSE)) ?
                                    true : false;
                                    
        selectedGoal = Apexpages.currentPage().getParameters().get(STR_SELECTED_GOAL);
        if(String.isNotBlank (selectedGoal) && String.isNotBlank (goalStrIds)){
            String objectiveQuery = objectivesWithWhereClause (goalStrIds);
            if (String.isNotBlank(lastObjectiveSortField) && 
                                                    objectiveSortField != lastObjectiveSortField){
                objectiveSortingDirection = false;
            }
            if(String.isNotBlank(objectiveSortField)){
                Schema.DisplayType objDisplayType = 
                                                checkFieldType(objObjectiveName, objectiveSortField);
                if(string.valueOf(objDisplayType).equalsIgnorecase(STR_TEXTAREA)) {
                    sortError=true;
                }
                else{
                    sortError=false; */
                /*    objectiveQuery += STR_SPACE + STR_ORDER_BY + STR_SPACE;
                    objectiveQuery += objectiveSortField;
                    objectiveQuery += objectiveSortingDirection == true? STR_SPACE + STR_DESC_NUL_LST +
                                        + STR_SPACE : STR_SPACE + STR_ASC_NUL_FST + STR_SPACE ; */
                  //  lastObjectiveSortField = objectiveSortField;
                 //   if (mapObjId_TodispayList.containsKey (selectedGoal)) {
                  //      mapObjId_TodispayList.get (selectedGoal).children = new List<toDisplay>();
                  //  System.debug ('Sid::::::: #574 objectiveQuery '+objectiveQuery);
                  //     retrieveObjectives (objectiveQuery);
                 //   }
                   // objectiveSortingDirection =! objectiveSortingDirection;
                //}
            //}
        //} 
        return null;
    }//End Method
    
    public String objectivesWithWhereClause (String pGoalIds) {
        selectedGoal = Apexpages.currentPage().getParameters().get(STR_SELECTED_GOAL);
        String queryStr;
            if(String.isNotBlank (pGoalIds)){
                String goaldIds = pGoalIds.removeEndIgnoreCase (', ');
                queryStr = 
                        QueryBuilderUtility.constructQueryWithFKeys (objConfigList.sObject_4__c,
                                                                    objConfigList.sObject_Field_4__c,
                                                                    objConfigList.sObject_3__c);
                Schema.Describefieldresult referenceFieldDescribe = 
                                        QueryBuilderUtility.getRelatedObjName(objObjectiveName, 
                                                                                objGoalName);
                    if(referenceFieldDescribe != null && String.isNotBlank (goaldIds)){
                        lookupGoalName = referenceFieldDescribe.getName();
                        queryStr += STR_SPACE + STR_WHERE + STR_SPACE + lookupGoalName + STR_SPACE +
                                        STR_IN + STR_OPENPAR +goaldIds+ STR_CLOSEPAR;
                    }
                }
        return queryStr;
    }
    //Method to retrieve a result list of Sobjects for the query passed as parameter
    public static List<Sobject> getLstSobject (String queryStr) {
        try {
            return (database.query(queryStr));
        } catch (exception e) {ApexPages.addMessages(e);}
        return null;
    }//End Method

    public String getQueryParam (String queryParm) {
        String whereStr;
        if (queryParm == null) {queryParm = STR_BLANK;}
        
         //Get accessible fields for Goals Sobject
        if(objConfigList.sObject_3__c != null && objConfigList.sObject_Field_3__c != null )
        accessibleFieldsForGoals = 
                        QueryBuilderUtility.retrieveDynamicFields (objConfigList.sObject_3__c,
                                                                    objConfigList.sObject_Field_3__c);
        //Fill the map for goal details
        if(accessibleFieldsForGoals != null){
            for (String fieldName : accessibleFieldsForGoals) {
                accessFieldsGoals.put(fieldName, false);
            }// End For
       }
        //To remove the hidden fields for Goal List on Dream Map Page
        if(reqFields != null){
	        if(reqFields.HiddenFieldsForsObject3__c != null ){
	                Set<String> setOfHidForSobj3 = 
	                                QueryBuilderUtility.convertStrToSetStr(reqFields.HiddenFieldsForsObject3__c);
	                
	                accessibleFieldsForGoals = 
	                              QueryBuilderUtility.removeHiddenFields(setOfHidForSobj3,
	                                                                      accessibleFieldsForGoals);
	        }
	        if(reqFields.RequiredFieldsForsObject3__c != null){
	            Set<String> setOfReqForSobj3 = 
                                QueryBuilderUtility.convertStrToSetStr(reqFields.RequiredFieldsForsObject3__c);
                // Make the fields required for Goals which are added in custom settings
                accessFieldsGoals = 
                                QueryBuilderUtility.showRequiredFields(setOfReqForSobj3, accessibleFieldsForGoals);
	        }
        }
        Schema.Describefieldresult referenceFieldDescribe =
                                QueryBuilderUtility.getRelatedObjName(objGoalName, objDreamMapName);
        if(referenceFieldDescribe != null){
            //Get the LookUp Field for Goal Object related to Dream Map
            lookupDreamMapName = referenceFieldDescribe.getName();
        }
        if (String.isNotBlank(lookupDreamMapName)) {
            //Query on Goal Details
            offsetSize = limitSize > totalRecs ? 0 : OffsetSize;
            whereStr = QueryBuilderUtility.constructQueryWithFKeys (objConfigList.sObject_3__c,
                                                                    objConfigList.sObject_Field_3__c,
                                                                    objConfigList.sObject_2__c); 
            whereStr += getTheFilterList(queryParm);
            String strWhereForFilter = filterResult(operatorSymbol, statusSelectedValue);
            if(String.isBlank(strWhereForFilter)){
                strWhereForFilter = '';
            }
            totalRecs =  Database.countQuery (' SELECT count() FROM '+ objConfigList.sObject_3__c +
                            STR_SPACE + STR_WHERE + STR_SPACE + lookupDreamMapName + STR_SPACE +
                            STR_OPR_EQL + STR_SINGLE_QUOTE + strDreamGoalId + STR_SINGLE_QUOTE + strWhereForFilter);
                            
        }
        //showRequiredFieldsForGoals();
        return whereStr;
    }//End Method
    //Method to add filter if  render as pdf  display all the goals and details else add pagination
    public String getTheFilterList(String queryParm){
            String strWhereClause = '';
            String strPDF = Apexpages.currentPage().getParameters().get(STR_RENDER_AS_PDF);
            if(String.isNotBlank(strPDF) && strPDF.equalsIgnoreCase(STR_TRUE_VAL)){
             strWhereClause+= STR_SPACE + STR_WHERE + STR_SPACE + lookupDreamMapName + STR_SPACE +
                              STR_OPR_EQL + STR_SINGLE_QUOTE + strDreamGoalId + STR_SINGLE_QUOTE + 
                              queryParm;
            system.debug('strWhereClause************'+strWhereClause);
            }
            else{
            strWhereClause +=  STR_SPACE + STR_WHERE + STR_SPACE + lookupDreamMapName + STR_SPACE +
                               STR_OPR_EQL + STR_SINGLE_QUOTE + strDreamGoalId + STR_SINGLE_QUOTE + 
                               queryParm + STR_SPACE + STR_LIMIT + STR_SPACE + limitSize + 
                               STR_SPACE+ STR_OFFSET + STR_SPACE + offsetSize;
            }
            return strWhereClause;
    }
    //Method to display Goal details of the related DremMap
    public void retriveGoalDetails(List<sObject> lstSobject) {
        mapObjId_TodispayList = new Map<String, toDisplay> ();
        todisplayList = new List<toDisplay>();
        showBtn=true;
        goalStrIds = '';
        //If Goal Details list is empty display popup
        if (lstSobject != null && lstSobject.size() > 0) {
            for (sObject sObj : lstSobject) {
                    toDisplay td = new toDisplay ();
                    td.isFirstObj = true;
                    td.sObj = sObj;
                    td.objId = sObj.id;
                    td.children = new List<toDisplay> ();
                    todisplayList.add (td);
                    mapObjId_TodispayList.put(String.ValueOf(sObj.id), td);
                    goalStrIds += '\''+ sObj.id +'\'' + ', ';
            } // End for 
        }
        objectiveDetailsList (goalStrIds);
    }//End Method

    // Method to fetch and put objective records on the query parameter
    public void retrieveObjectives (String strQuery) {
        if (strQuery != null) {
            List<Sobject> lstObjective = getLstSobject (strQuery);//Database.query(strQuery);
            if(lstObjective != null){
			    for (sObject sObj : lstObjective) {
			        toDisplay td = new toDisplay ();
			        td.isFirstObj = false;
			        td.sObj = sObj;
			        td.objId = sObj.id;
			        td.children = new List<toDisplay> ();
			        Schema.Describefieldresult referenceFieldDescribe =
			                    QueryBuilderUtility.getRelatedObjName (objConfigList.sObject_4__c,
			                                                            objConfigList.sObject_3__c);
			        if (referenceFieldDescribe != null) {
			            if (mapObjId_TodispayList.containsKey(
			                    String.ValueOf (sObj.get(referenceFieldDescribe.getSobjectField()))
			                    )
			                ) {
			                mapObjId_TodispayList.get(String.ValueOf(
			                                    sObj.get(referenceFieldDescribe.getSobjectField()))
			                                    ).children.add(td);
			            }
			        }
			    }
           }//End If
        }
    }//End Method
    
    //Method to refresh the table
    public PageReference refresh(){
        retriveGoalDetails(getLstSobject(finalQuery));
        if(todisplayList.size() == 0){
        	firstPage();
        }
        return null;
    }//End Method

    //Method to display the Objectives List
    public void objectiveDetailsList (String goalIds) {
		if (String.isNotBlank (goalIds)) {
			objObjectiveName = objConfigList.sObject_4__c;
			String objectiveQuery = objectivesWithWhereClause (goalIds);
			retrieveObjectives (objectiveQuery);
			if(objConfigList.sObject_4__c != null && objConfigList.sObject_Field_4__c!= null)
			accessibleFieldsForObjectives =  
						QueryBuilderUtility.retrieveDynamicFields (objConfigList.sObject_4__c,
																	objConfigList.sObject_Field_4__c);
		        if(accessibleFieldsForObjectives != null){
			            for (String fieldName : accessibleFieldsForObjectives) {
			                accessFieldsObjectives.put(fieldName, false);
			            }// End For
                }

			    //To remove the hidden fields for Objectives List on Dream Map Page
				if(reqFields != null){
					if(reqFields.HiddenFieldsForsObject4__c != null)
	                {
	                Set<String> setOfHidForSobj4 = 
	                                QueryBuilderUtility.convertStrToSetStr(reqFields.HiddenFieldsForsObject4__c);
	                
	                accessibleFieldsForObjectives = 
	                              QueryBuilderUtility.removeHiddenFields(setOfHidForSobj4,
	                                                                      accessibleFieldsForObjectives);
	                
	                }
	                if(reqFields.RequiredFieldsForsObject4__c != null){
	                    Set<String> setOfReqForSobj4 = 
                                 QueryBuilderUtility.convertStrToSetStr(reqFields.RequiredFieldsForsObject4__c);
                        accessFieldsObjectives = 
                               QueryBuilderUtility.showRequiredFields(setOfReqForSobj4, accessibleFieldsForObjectives);
	                    
	                }
				}
			    goalField = QueryBuilderUtility.getRelatedObjName (objConfigList.sObject_4__c,
																   objConfigList.sObject_3__c).getLabel();
			}
    }//End Method

    // Method to display the List of Goals and Objectives
    public List<toDisplay> getAllRecords() {
        return todisplayList;
    }//End Method
    
    //Method to Edit Dream Map
    public void editDreamMap(){
        editBtn = true;
    }//End Method

    //Method to Save the updated Dream Map
    public void saveDreamMaps()
    {
        if(!dreamMapDetails.isEmpty()){
            update dreamMapDetails;
            editBtn = false;
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,
                                                System.Label.SucessMsgForDynamicQueryForDreamMap));
        }else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,
                                                System.Label.ErrorMsgForDynamicQueryForDreamMap));
        }
    }//End Method

    // Method to redirect the Add Dream Map page
    public PageReference addDreamMap(){
        PageReference reRend = Page.DreamMapDetails;
        reRend.getParameters().put(STR_CLIENT_ID, strClientId);
        reRend.getParameters().put(STR_OBJ_CONFIG_ID, objConId);
        reRend.setRedirect(true);
        return reRend;
    }//End Method

    // Method to redirect the Add Goal and Objective Page so specific Dream Map
    public PageReference addGoalsAndObjectives(){
        PageReference reRend = Page.DynamicQueryForContactGoalsPage;
        reRend.getParameters().put(STR_DREAM_MAP_DETAILS, strDreamGoalId);
        reRend.getParameters().put(STR_CLIENT_ID, strClientId);
        reRend.setRedirect(true);
        return reRend;
    }//End Method

    //Method to save the details
    public void saveGoalDetails(){
        editBtn = true;
    }//End Method

    //Method to redirect on click on Cancel Button on Dream Map
    public void cancelDreamMap(){
        editBtn = false;
    }//End Method

    //Method to delete the dream Map row on click od Delete Command Link
    public void deleteDreamMaplst() {
        String dreamMapDelId = Apexpages.currentPage().getParameters().get(STR_DMAP_TO_DEL);
        List<SObject> lstDreamMapToDelete = new List<SObject>();
        if (dreamMapDelId != null && dreamMapDelId != STR_BLANK) {
            for(Integer i=0; i<dreamMapDetails.size(); i++) {
                if(dreamMapDetails[i].Id == dreamMapDelId) {
                    lstDreamMapToDelete.add(dreamMapDetails[i]);
                }
            }
            if(!lstDreamMapToDelete.isEmpty()){
                delete lstDreamMapToDelete;
                todisplayList.clear();
            }
        }
        showRecords ();
    }//End Method

    //Method to get the objective id on click on Add Objectives Button
    public void objectiveDetailstoAddRow(){
        getAllSchedules();
        popupForObjectives=true;
        strGoalId = Apexpages.currentPage().getParameters().get(STR_GOAL_ID);
    }


    //Method to get the intial row for objectives
    public List<toDisplay> getAllSchedules() {
        toDisplay td = new toDisplay ();
        td.sObj = QueryBuilderUtility.createObject (objConfigList.sObject_4__c);
        lstToDisplayForObjective.add(td);
        return lstToDisplayForObjective;
    }

    //Method to add row on click of add Objective popup
    public void addRow(){
        count ++;
        getAllSchedules();
    }

     //Method to remove row on click of Remove row button on Objective popup
    public void removeRow(){
        if(lstToDisplayForObjective.size() == 1){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,
                                                            System.Label.InfoMessageOneObjective);
            ApexPages.addMessage(myMsg);
        }
        if(lstToDisplayForObjective.size()>1 && !lstToDisplayForObjective.isEmpty()){
            count --;
            lstToDisplayForObjective.remove(count);
        }
    }

    //Method to check the fields are not null
    public List<sObject> checkBlankFields()
    {
        String parentName=QueryBuilderUtility.getRelatedObjName(objConfigList.sObject_4__c,
                                                                objConfigList.sObject_3__c).getName();
        List<sObject> lstSobject = new List<sObject>();
        for(toDisplay sobjRec : lstToDisplayForObjective) {
            sobjRec.sobj.put(parentName,strGoalId); 
            lstSobject.add(sobjRec.sobj);
        } // End for
        return lstSobject;
    }

    //Method to save objectives on Objective Popup
    public void saveObjetives(){
         List<Sobject> lstSobject = checkBlankFields();
         if(lstSobject != null && !lstSobject.isEmpty())
         {
            try{insert lstSobject;}catch(System.DmlException se){}
            popupForObjectives = false;
            lstToDisplayForObjective.clear(); 
            refresh();
         }
    }

    //Method to save Goal on link click
    public void saveGoalFromLink(){
        try {
            toDisplay selGoal = mapObjId_TodispayList.get(goalId);
            if(selGoal != null){
                update selGoal.sObj;
            }
        }catch(Exception e) {
         ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.FATAL, STR_BLANK));
        }
    }

    //Method to delete Goals from link click
    public void deleteGoal(){
        try {
            String goalId= Apexpages.currentPage().getParameters().get(STR_GOAL_ID);
            toDisplay selGoal = mapObjId_TodispayList.get(goalId);
            if(selGoal!=null){
                delete selGoal.sObj;
                retriveGoalDetails(getLstSobject(finalQuery));
        }
        }catch(System.Exception se) {
            ApexPages.addMessages(se); 
        }
    }

    //Method to save objectives on link click
    public void saveObjectiveForEditLink(){
         try {
             List<toDisplay>  lstObjectives = mapObjId_TodispayList.get(goalId).children;
            for(toDisplay objective : lstObjectives) {
                if(objective.objId == objectiveId)
                update objective.sObj;
            }
          }catch(System.NullPointerException se) {
      }
    }

    //Method to delete objectives on link click
    public void deleteObjective(){
        try {
            String goalId= Apexpages.currentPage().getParameters().get(STR_GOAL_ID);
            String ObjectiveId= Apexpages.currentPage().getParameters().get(STR_OBJ_ID);
            List<toDisplay>  lstObjectives = mapObjId_TodispayList.get(goalId).children;
            for(toDisplay objective : lstObjectives)
                if(objective.objId == objectiveId){
                    delete objective.sObj;
                    retriveGoalDetails(getLstSobject(finalQuery));
                }
        }catch(System.Exception se) {
            ApexPages.addMessages(se);
        }
    }

    // Redirects to Parent record
    public Pagereference redirectToParent(){
        PageReference pageRef = new PageReference(FORWARD_SLASH+strClientId);
        pageRef.setRedirect(true);
        return pageRef;
    }
 //Method to check the datatype of fields
    public Schema.DisplayType checkFieldType(String objName,String pFieldName){
        Map<String, Schema.SObjectType> schemaMapForSObj = Schema.getGlobalDescribe();
        Schema.SObjectType schemaType = schemaMapForSObj.get(objName);
        Map<String, Schema.SObjectField> fieldMap = schemaType.getDescribe().fields.getMap();
        Schema.DisplayType fielddataType = fieldMap.get(pfieldName).getDescribe().getType();
        return fielddataType;
    }

    // Following are pagination methods
    // There are multiple methods and also find comments on each of them
    // Added later on with ----------------Jira-MMGDM-4
    
    //This method used to show the data on first Page from Search Records
    public void firstPage(){
        offsetSize = 0;
        goalDetailsList();
    }
    //This method used to show the data on Previous Page from the Current Search Records 
    public void previous() {
        offsetSize = offsetSize - LimitSize;
         goalDetailsList();
    }
    //This method used to show the data on Next Page from the Current Search Records 
    public void next() {
        offsetSize = offsetSize + LimitSize;
        goalDetailsList();
    }
    //This method used to show the data on last Page from Search Records
    public void lastPage(){
        //offsetSize = totalrecs - math.mod(totalRecs,LimitSize);
        if(math.mod(totalRecs,LimitSize) == 0){
    		offsetSize = totalRecs - limitSize;
    	}
    	else{
    		offsetSize = totalRecs - math.mod(totalRecs,LimitSize);
    	}
        goalDetailsList();
    }
    //Set the boolean to true if the Offset is greater than zero
    public Boolean getprev(){
        if(offsetSize == 0)
            return true;
        else
            return false;
    }
    //Set the boolean to true if the Offset and limit is greater than total Count
    public Boolean getNext(){
        if((OffsetSize + LimitSize) > totalRecs || totalRecs <= 0 || (OffsetSize + LimitSize) == totalRecs)
            return true;
        else
            return false;
    }
    
    //Method to add options in the drop down to set limit according to the value selected
    public List<SelectOption> getSelectOptionsForPagination(){
        return QueryBuilderUtility.getSelectOptions();
    }

    // Wrapper class to display the Goal and Objectives
    public class toDisplay {
        public Boolean isFirstObj       { get; set; }
        public sObject sObj             { get; set; }
        public String objId             { get; set; }
        public List<toDisplay> children { get; set; }
        public Boolean toggleEditSave   { get; set; }
    } // End wrapper class
}