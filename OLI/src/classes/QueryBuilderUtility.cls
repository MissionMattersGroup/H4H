/*
 * This is a utility class that contains methods to build queries and other helper methods. All the methods in this 
 *  class are Static.
 *
 *      Author          Date (dd-mm-yyyy)           Version                 ChangeLog
 *      Siddharth P     06-02-2015                  1.0                     Initial Draft
 *      Siddharth P     20-05-2015                  1.1                     Added few more methods to check user 
 *                                                                          permissions
 *      Dhirendra       11-08-2015                  1.2                     Added method for Select Option for 
 *                                                                          Pagination
 */
public with sharing class QueryBuilderUtility{
    //Variables
    private static final String STR_REQUIRED_HIDDEN_FIELDS = Label.list_of_required_and_hidden_fields;
    private static final String SEL_OPT1 = '10';
    private static final String SEL_OPT2 = '25';
    private static final String SEL_OPT3 = '50';
    private static RequiredFields__c reqFields;
    private static final String STR_SPACE = ' ';
    private static final String STR_BLANK = '';
    private static final String STR_COMMA = ',';
    /*//Set to store the list of required fields in the custom settings
    public static  Set<String> setOfReqSobj1;
    public static  Set<String> setOfReqSobj2;
    public static  Set<String> setOfReqSobj3;
    public static  Set<String> setOfReqSobj4;
    //Set to store the list of hidden fields in the custom settings
    public static  Set<String> setOfHidSobj1;
    public static  Set<String> setOfHidSobj2;
    public static  Set<String> setOfHidSobj3;
    public static  Set<String> setOfHidSobj4;*/
    // A method is used to retrieve object fields ApiNames 
    public static List<String> retrieveDynamicFields (String sObjName, String fieldApiNames) {
        List<String> accessibleFields = new List<String> ();
        List<String> lstFieldApiNames = new List<String> ();
        if (fieldApiNames != null && fieldApiNames != '')
            lstFieldApiNames = QueryBuilderUtility.retriveFieldList (fieldApiNames);
            Map<String, Schema.SObjectField> fieldMap = retrieveSObjectFieldsMap (sObjName);
         /*   for (Schema.SObjectField schSobjField : retrieveSObjectFieldsMap (sObjName).values()) {
                fieldMap.put (schSobjField.getDescribe().getName(), schSobjField.getDescribe().getName());
            } */
            if (fieldMap != null) {
                System.debug ('Sid:::::: #29 fieldMap '+fieldMap);
                for (Integer i=0 ; i< lstFieldApiNames.size(); i++) {
                    String fieldLocalName = lstFieldApiNames.get (i).contains ('') ?
                                                        lstFieldApiNames.get (i).replaceFirst('', '') :
                                                        lstFieldApiNames.get (i);
                    if (fieldMap.containsKey((fieldLocalName.toLowerCase ())))
                        accessibleFields.add(fieldMap.get (fieldLocalName.toLowerCase ()).getDescribe().getName());
                } // End for
            } // End if
        return accessibleFields;
    } // End method
    
    // A method is used to retrieve sObject Fields Map
    public static Map<String, Schema.SObjectField> retrieveSObjectFieldsMap (String objName) {
        Map<String, Schema.SObjectField> fieldMap;
        if (objName != null && objName != '') {
            Schema.Describesobjectresult objectDescribe = Schema.getGlobalDescribe().get(objName).getDescribe();
            if (objectDescribe != null) {
                fieldMap = objectDescribe.fields.getMap();
            } // End if
        } // End if
        return fieldMap;
    } // End method

    // A method to convert a String into sObject Name
    public static sObject createObject (String objName) {
        Schema.SObjectType targetType = Schema.getGlobalDescribe().get(objName);
        if (targetType == null) {
           return null;
        }
        // Instantiate an sObject with the type passed in as an argument
        //  at run time.
        return targetType.newSObject();
    }

    //A Method return object labels 
    public static Map<String, String> retrievSobjectApiLabelMap() {
        Map<String,String> fieldApiNameLabelMap = new Map<String, String>();
        Map<String, Schema.SObjectType> globDescribeMap = Schema.getGlobalDescribe();
        for (String sObj : globDescribeMap.keySet()) {
            fieldApiNameLabelMap.put(globDescribeMap.get(sObj).getDescribe().getName(),
                                     globDescribeMap.get(sObj).getDescribe().label);
        }
        return fieldApiNameLabelMap;
    }
    
    // A method to convert a string into a list of String, separated by comma 
    public static List<String> retriveFieldList (String strField) {
        List<String> fieldList = new List<String> ();
        if (null != strField){
            for(String field : strField.split(',')){
                fieldList.add(field.trim());
            }
        }
        return fieldList;
    }

    // A method which construct the query based on the parameters
    //first paramter is object name and second is field names
    public static String constructQuery (String objName, String fieldNames) {
        String queryStr = '';
        if ((objName != null && objName != '') ||
            (fieldNames != null && fieldNames != '')) {
            queryStr = 'SELECT ' + fieldNames + ' FROM ' + objName;
        } // End if
        return queryStr;
    } // End method
    
    // A method that returns a string (child object raltionship name). Two parameters are required
    // 1) Child object name, 2) Parent object Name
    public static Schema.DescribeFieldResult getRelatedObjName (String childObjName, String parentObjName) {
        Schema.DescribeFieldResult relName;
            if (childObjName != null && parentObjName != null) {
                Map<String, Schema.SObjectField> sObjFieldMap =
                                                     QueryBuilderUtility.retrieveSObjectFieldsMap (childObjName);
                if (sObjFieldMap != null) {
                    for (Schema.SObjectField sObjField : sObjFieldMap.values()) {
                        relName = sObjField.getDescribe();
                        List<Schema.SobjectType> lstToken = relName.getReferenceTo();
                        if (!relName.isNamePointing() && lstToken.size() > 0 && 
                            lstToken.get(0) == createObject(parentObjName).getSobjectType()) {
                            return relName;
                        }
                    } // End for
                } // End if
            } // End if 
        return relName;
    } // End method
    
    // A method is used to construct query for sObject
    public static String constructQueryWithFKeys (String objName, String fielNames, String parentObjName) {
        String queryStr;
        if (objName != null && objName != '' && fielNames != null && fielNames != '') {
            Schema.Describefieldresult fieldDescribe = QueryBuilderUtility.getRelatedObjName(objName, parentObjName);
            if (fieldDescribe != null) {
                String refObjName = '';
                if (!fielNames.contains(fieldDescribe.getLocalName().toLowerCase()))
                    refObjName += ', ' + fieldDescribe.getName();
                    queryStr = ' SELECT ' + fielNames + refObjName +
                        ' FROM ' + objName;
            } // End if
        } // End if
        return queryStr;
    } // End method

    // A method that returns List of child sObjectTypes 
    public static List<Schema.sObjectType> getReferecedToObjs (Schema.SObjectField sObjFieldSchema) {
        if (sObjFieldSchema == null) {return null;} // if param is null, then return null
        return sObjFieldSchema.getDescribe().getReferenceTo();
    }

    // A method that fetches Object configuration's active record with all the fields.
    public static string getObjConfigurationQueryString(String objConfigId) {
        if (objConfigId== null) {return null;}
        return ' Select sObject_1__c, sObject_2__c, sObject_3__c, sObject_4__c,' +
               ' sObject_Field_1__c,sObject_Field_2__c, sObject_Field_3__c, ' +
               ' sObject_Field_4__c '+
               ' FROM Object_Configuration__c '+
               ' WHERE Active__c = true AND Id =\'' + objConfigId + '\' LIMIT 1 ';
    } // End method

    // A method that construct a query on permissino set
    public static String constructQueryOnPermissions (String loginUserId) {
        String queryStr;
        if (loginUserId != null) {
            queryStr = ' SELECT Id, SObjectType, PermissionsRead, PermissionsEdit, PermissionsCreate ' + 
                       ' FROM ObjectPermissions WHERE '+
                       ' (ParentId IN (SELECT PermissionSetId FROM PermissionSetAssignment' +
                       ' WHERE Assignee.Id =: loginUserId ))';
        } // End if 
        return queryStr;
    }

    // A method that returns a Map of sObjectType as a key and permission in the values.
    public static Map<String, sObject> retrieveObjPermissions (String loginUserId) {
        Map<String, sObject> objPermissionsMap = new Map<String, sObject> ();
        String queryStr = constructQueryOnPermissions (loginUserId);
        for (ObjectPermissions aObjPermission : Database.query(queryStr)) {
            objPermissionsMap.put (aObjPermission.SobjectType, aObjPermission);
        } // End for
        return objPermissionsMap;
    } // End method

    // This method is used to get object fields label
    public static Map<String, String> retrieveSObjectFieldsLabel (String objName) {
        Map<String,String> fieldApiLabelMap = new Map<String, String>();
        Map<String, Schema.SObjectField> fieldMap;
        if (objName != null && objName != '') {
            if (Schema.getGlobalDescribe().get(objName).getDescribe() != null) {
                fieldMap = Schema.getGlobalDescribe().get(objName).getDescribe().fields.getMap();
                for (String fieldName: fieldMap.keySet()) {
                    Schema.Describefieldresult fieldDescribe = fieldMap.get(fieldName).getDescribe();
                    if(fieldDescribe != null) {
                        fieldApiLabelMap.put(fieldDescribe.getName(), fieldDescribe.getLabel());
                    }// End if
                }// End for
            } // End if
        } // End if
        return fieldApiLabelMap;
    } // End method
    
    //Method to add options in the drop down to set limit according to the value selected list in pagination
    public static List<SelectOption> getSelectOptions(){
        List<SelectOption> optns = new List<Selectoption>();
           optns.add(new selectOption(SEL_OPT1 , SEL_OPT1));
           optns.add(new selectOption(SEL_OPT2 , SEL_OPT2));
           optns.add(new selectOption(SEL_OPT3 , SEL_OPT3));
        return optns;
    }// End method
    
    //Method to store the list of Field from the custom settings into the Set of string.
    public static Set<String> convertStrToSetStr(String custSettingFieldApi){
        List<String> lstReqFieldSetForSobj;
        //Set<String> setFieldApi = new Set<String>();
        if(String.isNotBlank(custSettingFieldApi)){
            String formatString = custSettingFieldApi.replaceAll (STR_SPACE,STR_BLANK);
                   formatString = formatString.toLowerCase();
                   lstReqFieldSetForSobj = formatString.split(STR_COMMA);
                //setFieldApi = new Set<String>(lstReqFieldSetForSobj);
        }
        return new Set<String>(lstReqFieldSetForSobj);
    }
    //Method is to display required fields
    public static Map<String, Boolean> showRequiredFields(Set<String> setOfReq , List<String> lstOfAccessibleField) {
        Map<String, Boolean>  mapOfAccessibleField = new Map<String, Boolean>();
        if(lstOfAccessibleField != null){
            for (String fieldName : lstOfAccessibleField) {
                    mapOfAccessibleField.put(fieldName, false);
                if (setOfReq.contains(fieldName.toLowerCase())){
                    mapOfAccessibleField.put (fieldName, true);
                    system.debug('mapOfAccessibleField**********'+mapOfAccessibleField);
                }
            }// End For
       }
       return mapOfAccessibleField;
    }
    //Method to remove hidden fields from a given list of fields
    public static List<String> removeHiddenFields(Set<String> setHiddenFields, List<String> lstFields){
        List<String> filteredList = new List<String>();
        if((setHiddenFields!=null || !setHiddenFields.isEmpty()) && 
                                                    (lstFields != null || !lstFields.isEmpty())){
            for(String objField : lstFields){
                if(!setHiddenFields.contains(objField.toLowerCase())){
                    filteredList.add(objField.toLowerCase());
                }
            }
        } else{return lstFields;}
    return filteredList;
    }//End Method
} // End class