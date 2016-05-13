public with sharing class ObjectConfigurationController {
   
    // variables
    public List<SelectOption> firstObjFields  { get; set; }
    public List<SelectOption> secondObjFields { get; set; }
    public List<SelectOption> thirdObjFields  { get; set; }
    public List<SelectOption> forthObjFields  { get; set; }
    public String firstLvlChildObj            { get; set; }
    public String primaryObj                  { get; set; }
    public String thirdLvlChildObj            { get; set; }
    public String secondLvlChildObj           { get; set; }
    public boolean showFieldsOne              { get; set; }
    public boolean showFieldsSecond           { get; set; }
    public boolean showFieldsThird            { get; set; }
    public boolean showFieldsForth            { get; set; }
    public boolean isDisableFirstChObj        { get; set; }
    public boolean isDisableSecChObj          { get; set; }
    public boolean isDisableThirdChObj        { get; set; }
    public boolean isFromLink                 { get; set; }
    public Boolean showMessage = false;
    
    private static list<IgnoreObjects__c> lstIgnoreObjects = new list<IgnoreObjects__c>(); 
    private Boolean tempVar = false;
    Map<String, Map<String, Schema.SObjectType>> objApiName_lable_mainMap;

    // constructor
    public ObjectConfigurationController () {
       isDisableFirstChObj = true;
       isDisableSecChObj = true;
       isDisableThirdChObj = true;
       objApiName_lable_mainMap = new Map<String, Map<String, Schema.SObjectType>> ();
       showFieldsOne = false; showFieldsSecond = false;
       showFieldsThird = false; showFieldsForth = false;
       firstObjFields = new List<SelectOption> ();
       secondObjFields = new List<SelectOption> ();
       thirdObjFields = new List<SelectOption> ();
       forthObjFields = new List<SelectOption> (); 
    }
    
    // This set is used to ignore object that are not needed in list
    public static Set<String> ignoreObj () {
        set<String> objToIgnore = new set<String>();
        string objName;
        lstIgnoreObjects = IgnoreObjects__c.getAll().values();
        for (IgnoreObjects__c objIgnore : lstIgnoreObjects ) {
            objName += objIgnore.Objects_Name__c;
        }
        if(objName != null){
            string[] str = objName.split(', ');
            objToIgnore = new Set<String>(str);
        }
        return objToIgnore;
    }
    
    //To get all object
     public List<SelectOption> getAllObjects () {
        List<SelectOption> objList = new List<SelectOption> ();
        objList.add(new SelectOption('' ,'-- Select Primary Object --'));
        Set<String> uniqueValueCheck = new Set<String> ();
        Map<String, Schema.SObjectType> objApiName_label = new Map<String, Schema.SObjectType> ();
        Map<String, Schema.SObjectType> globDescribeMap = Schema.getGlobalDescribe();
        for (String sObj : globDescribeMap.keySet()) {
            if (globDescribeMap.get(sObj ).getDescribe().isSearchable() 
                && globDescribeMap.get(sObj ).getDescribe().isDeletable()) {
                if (!uniqueValueCheck.contains(sObj) && !ignoreObj().contains(globDescribeMap.get(sObj).getDescribe().getName()))
                    objList.add(new SelectOption(globDescribeMap.get(sObj).getDescribe().getName() , globDescribeMap.get(sObj).getDescribe().label));
                uniqueValueCheck.add(sObj);
                objApiName_label.put(sObj , globDescribeMap.get(sObj));
                objApiName_lable_mainMap.put ('primaryObject', objApiName_label);
            } // End if

        } // End for
        objList.sort();
        return objList;
    }

    // To show selected first object field
    public PageReference disFirstObjFields() {
        if (isFromLink == false) { 
            if(firstObjFields != null || secondObjFields != null || thirdObjFields != null || forthObjFields!= null) {
                clearSelectedFields(firstObjFields);
                clearSelectedFields(secondObjFields);
                clearSelectedFields(thirdObjFields);
                clearSelectedFields(forthObjFields);
                isDisableSecChObj=true;
                isDisableThirdChObj=true;
            }
        }
        showFieldsForth = false; showFieldsOne = true; showFieldsSecond = false; showFieldsThird = false;
        return null;
    }

    // To show selected second object field
    public PageReference disSecObjFields() {
        if (isFromLink == false) {
            if(secondObjFields != null || thirdObjFields != null || forthObjFields!= null) {
                clearSelectedFields(secondObjFields);
                clearSelectedFields(thirdObjFields);
                clearSelectedFields(forthObjFields);
                isDisableThirdChObj=true;
            }
        }
        showFieldsForth = false; showFieldsOne = false; showFieldsSecond = true; showFieldsThird = false;
        return null;
    }

    // To show selected third object field
    public PageReference disThirdObjFields() {
        if (isFromLink == false) {
            if(thirdObjFields != null || forthObjFields!= null) {
                clearSelectedFields(thirdObjFields);
                clearSelectedFields(forthObjFields);
            }
        }
        showFieldsForth = false; showFieldsOne = false; showFieldsSecond = false; showFieldsThird = true;
        return null;
    }

    // To show selected fourth object field
    public PageReference disForthObjFields() {
        if (isFromLink == false) {
            if(forthObjFields != null) {
                clearSelectedFields(forthObjFields);
            }
        }
        showFieldsForth = true; showFieldsOne = false; showFieldsSecond = false; showFieldsThird = false;
        return null;
    }

    // To store all the fields in a string separated by comma
    public string selectedFields(list<SelectOption> objectSelectedFields) {
        String firstJoined = '';
        Boolean firstItem = true;
        for (SelectOption sOption : objectSelectedFields) {
            if(null != sOption) {
                if(firstItem){ firstItem = false; }
                else { firstJoined += ', '; }
                firstJoined += sOption.getValue();
            }
        }
        return firstJoined;
    }

    // List to show all first child object
    public List<SelectOption> getFirstLvlChildObjects () {
        tempVar = true;
        List<SelectOption> objList = getChildObjectsNew(primaryObj); 
        return objList;
    } // End method

    // List to show all second child object
    public List<SelectOption> getSecLvlChildObjects () { 
        List<SelectOption> objList = getChildObjectsNew(firstLvlChildObj);
        return objList;
    } // End method  

    // List to show all third child object
    public List<SelectOption> getThirdLvlChildObjects () { 
        List<SelectOption> objList = getChildObjectsNew(secondLvlChildObj); 
        return objList;
    } // End method  


    // To get the fields of primary object
    public List<SelectOption> getPrimaryObjFields () {
        isDisableFirstChObj = false;
        List<SelectOption> fieldList = getObjFields(primaryObj,getFieldSet(firstObjFields));
        fieldList.sort();
        return fieldList;
    } // End method

     // To get the fields of first child object
    public List<SelectOption> getFirtChildObjFields () {
        isDisableSecChObj = false;
        List<SelectOption> fieldList = getObjFields(firstLvlChildObj, getFieldSet(secondObjFields));
        fieldList.sort();
        return fieldList;
    } // End method

    // To get the fields of second child object
    public List<SelectOption> getSecChildObjFields () {
        isDisableThirdChObj = false;
        List<SelectOption> fieldList = getObjFields(secondLvlChildObj, getFieldSet(thirdObjFields));
        fieldList.sort();
        return fieldList;
    } // End method

    //To get the fields of third child object
    public List<SelectOption> getThirdChildObjFields () { 
        List<SelectOption> fieldList = getObjFields(thirdLvlChildObj, getFieldSet(forthObjFields));
        fieldList.sort();
        return fieldList;
    } // End method

    // To get a set of fieldnames from a selectoption list
    public static Set<String> getFieldSet(List<SelectOption> options){
        Set<String> fieldSet = new Set<String>();
        for(SelectOption option : options){
            fieldSet.add(option.getValue());
        }
        return fieldSet;
    }
    
    // To get the fields of selected object from object name and a set of selected fields
    public List<SelectOption> getObjFields(String sObjName, Set<String> selectedFields) {
        List<SelectOption> fieldList = new List<SelectOption> (); 
        if (sObjName != null && sObjName != '') {
            Set<String> uniqueValueCheck = new Set<String> ();
            Map<String, Schema.SObjectType> globDescribeMap = Schema.getGlobalDescribe();
            Map<String, Schema.SobjectField> objFields = globDescribeMap.get(sObjName).getDescribe().fields.getMap(); 
            for (Schema.SObjectField sObField : objFields.values()) {
                if (sObField != null 
                    && sObField.getDescribe().isAccessible()
                    && sObField.getDescribe().isCreateable()
                    && sObField.getDescribe().getType().name() != 'reference') {
                        if (!selectedFields.contains(sObField.getDescribe().getName()))
                            fieldList.add (new SelectOption (sObField.getDescribe().getName(), sObField.getDescribe().label));
                            uniqueValueCheck.add(sObField.getDescribe().getName());
                } // End if
            } // End for
        } // End if
        return fieldList;
    }

    // To get the child object of the parent object
    public List<SelectOption> getChildObjectsNew (String selectedObj) {
        Set<String> uniqueValueCheck = new Set<String> ();
        List<SelectOption> objList = new List<SelectOption> ();
        objList.add(new SelectOption('' ,'-- Child Objects --'));
        if (tempVar) {
            objList.add(new SelectOption('Dream_Map__c' ,'Dream Map'));
            uniqueValueCheck.add('Dream_Map__c');
            tempVar = false;
        }
        if (selectedObj != null && selectedObj != '') {
            List<Schema.ChildRelationship> childObjList = ObjectConfigurationController.getChildObjects (selectedObj);
            for (Integer i =0; i<childObjList.size(); i++) {
                if (childObjList.get(i).getChildSObject().getDescribe().isSearchable() ) {
                    //converting object name to lower case beacuse string is case sensitive 
                    if (!uniqueValueCheck.contains (string.ValueOf(childObjList.get(i).getChildSObject())) 
                        && !ignoreObj().contains(string.ValueOf(childObjList.get(i).getChildSObject())))
                        objList.add(new SelectOption(string.ValueOf(childObjList.get(i).getChildSObject().getDescribe().getName()), 
                        string.ValueOf(childObjList.get(i).getChildSObject().getDescribe().label)));
                        uniqueValueCheck.add(string.ValueOf(childObjList.get(i).getChildSObject()));
                } // End if
            } // End for
        } // End if
        return objList;
    }
    
    public static List<Schema.ChildRelationship> getChildObjects (String objName) {
        List<Schema.ChildRelationship> childObjList = new List<Schema.ChildRelationship> ();
            if (objName != null && objName != '') {
                Map<String, Schema.SObjectType> globDescribeMap = Schema.getGlobalDescribe();
                Schema.DescribeSObjectResult desRes = globDescribeMap.get(objName).getDescribe();
                childObjList = desRes.getChildRelationships(); 
            }
        return childObjList;
    }

    // To clear the selected field if we changes the selected object
    public void clearSelectedFields (list<SelectOption> selectedFields) {
        if (null != selectedFields)
            selectedFields.clear();
    }

    // To show error message
    public void nullCheck() {
        if (primaryObj == null || primaryObj == '' || firstLvlChildObj == null || firstLvlChildObj =='' || 
            secondLvlChildObj == null || secondLvlChildObj == '' || thirdLvlChildObj == null || thirdLvlChildObj == '') {
            ApexPages.Message showMsg = new ApexPages.Message(ApexPages.Severity.ERROR, label.Error_msg_for_object);
            ApexPages.addMessage(showMsg);
            showMessage = true;
        }
        if (firstObjFields.size()== 0 || secondObjFields.size()== 0 || thirdObjFields.size()== 0 ||forthObjFields.size()== 0) {
            ApexPages.Message showMsg = new ApexPages.Message(ApexPages.Severity.ERROR, label.Error_Msg_For_Field);
            ApexPages.addMessage(showMsg);
            showMessage = true;
        }
    }

    // To save the Object configuration information
    public PageReference customSave() {
        nullCheck();
        if (showMessage == true) {
                showMessage = false;
            return null;
        } else {
                Object_Configuration__c objCon = new Object_Configuration__c();
            objCon.sObject_1__c = primaryObj;
            objCon.sObject_2__c = firstLvlChildObj;
            objCon.sObject_3__c = secondLvlChildObj;
            objCon.sObject_4__c = thirdLvlChildObj;
            objCon.sObject_Field_1__c= selectedFields(firstObjFields);
            objCon.sObject_Field_2__c = selectedFields(secondObjFields);
            objCon.sObject_Field_3__c = selectedFields(thirdObjFields);
            objCon.sObject_Field_4__c = selectedFields(forthObjFields);
            insert objCon;
            PageReference pageRef = new Pagereference(Label.Object_Configurations_Prefix +objCon.Id);
            return pageRef;
        }
        return null;
    } // End of Method

    public PageReference refresh(){
        if(showFieldsOne==true)
           showFieldsOne = false;
        if(showFieldsSecond==true)
           showFieldsSecond = false;
        if(showFieldsThird==true)
           showFieldsThird = false;
        if(showFieldsForth==true)
           showFieldsForth = false;
        return null;
    } // End of Method
}