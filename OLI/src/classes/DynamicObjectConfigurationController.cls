/* Descreption: This is a controller class to fetch all the active Object configuration records.
 *
 *      Author              Date (DD-MM-YYYY)       Version                 Change Log
 *      Siddharth Pandit    15/05/2015                1.0             Initial Draft
 *      Dhirendra Verma     22/05/2015                1.1             Removed the delete functionality and updated the 
 *                                                                    Object Config Id through url.
 *
 */
 
public with sharing class DynamicObjectConfigurationController{
	
	//Variables
	//stores name of selected ObjConfig
	public Id selectedObjConfig   { get; set; }
	public List<String> fieldList { get; set; }
    public String sectionHeader   { get; set; }
    public Map<String,String> mapApiNameLabel;
    
    private List<Object_Configuration__c> lstObjectConfig;
    private DM_Search_Setting__c objConfSetting;
    private List<sObject> lstsObject;
    
    // Constructor
    public DynamicObjectConfigurationController(){
        init();
    } // End constructor
    
    // A method to initialize custom setting values
    public void init() {
        if (dmSearchSettingValues() != null && dmSearchSettingValues().size() > 0) {
            objConfSetting = dmSearchSettingValues().get(0);
            sectionHeader = String.ValueOf(objConfSetting.get('Section_Header__c'));
            lstsObject = retrieveFields(objConfSetting);
            retrieveFieldsCommaSep(objConfSetting);
        }
    }
    
    // A method that retrieves values from custom settings
    public static List<DM_Search_Setting__c> dmSearchSettingValues(){
        return DM_Search_Setting__c.getAll().Values(); 
    }
    
    // A method that fetches field values from custom settings
    public static String dmSearchFieldQuery(String objName){
        String queryString;
        if (objName != null){
            queryString = 'Select Field_Api_Name__c, Field_Label__c, Colspan_Number__c, Order_Number__c';
            queryString += ' From ' + objName;
            queryString += ' Order By Order_Number__c';
        }
        return queryString;
    }// End Method
    
    // A method which calls other buildQuery method
    public static List<sObject> retrieveFields(sObject objConfSetting){
        List<sObject> lstFields;
        if(objConfSetting != null && objConfSetting.get('Field_CustomSetting_Api__c') != null){
            String queryStr = dmSearchFieldQuery(String.ValueOf(objConfSetting.get('Field_CustomSetting_Api__c')));
            if(queryStr != null){
                lstFields = Database.query(queryStr);
            }
        }
        return lstFields;
    }
    
    // A method to access the values of object through custom setting
    public String retrieveFieldsCommaSep(sObject objConfigSetting){
        if (objConfigSetting == null) {return null;}
        fieldList = new List<String> ();
        String queryStr = ' Select ';
        List<sObject> lstFields = retrieveFields(objConfigSetting);
        if(lstFields==null || lstFields.size()==0)  return null;
        for(Sobject instObj : lstFields){
            if(instObj.get('Field_Api_Name__c') != null){
                fieldList.add (String.valueOf (instObj.get('Field_Api_Name__c')));
                queryStr += instObj.get('Field_Api_Name__c')+','; 
            }
        } // End for
        queryStr = queryStr.removeEndIgnoreCase(',');
        queryStr += ' FROM ' + String.valueOf(objConfigSetting.get('Object_Api_Name__c'));
        return queryStr;
    }
    
    // A method that returns login user Id.
    public String getLoginUserId () {
        return UserInfo.getUserId();
    } // End method
    
    // A method that returns all active Object configuration records.
    public List<Sobject> getListObjConfigs () {
        Set<String> setObjApi = new Set<String>();
        if (fieldList != null && fieldList.size() > 0)
        setObjApi.addAll(fieldList);
        List<Sobject> lstActiveObjConfigs = new List<Sobject> ();
        Map<String, Sobject> mapObj_Permissions = QueryBuilderUtility.retrieveObjPermissions (getLoginUserId ());
        if (mapObj_Permissions != null && mapObj_Permissions.size() > 0) {
            String queryStr = retrieveFieldsCommaSep (objConfSetting);
            if (queryStr != null) {
                for (Sobject objInstance : Database.query (queryStr)) {
                    if(setObjApi.contains('sObject_1__c')){
                        if (objInstance.get ('sObject_1__c') != null && 
                            mapObj_Permissions.containsKey (String.valueOf (objInstance.get ('sObject_1__c'))) && 
                            mapObj_Permissions.get (String.valueOf (objInstance.get ('sObject_1__c'))).get ('PermissionsRead') == true) {
                            lstActiveObjConfigs.add (retrieveObjLables (objInstance));
                            system.debug('<<<<<<<<lstActiveObjConfigs'+lstActiveObjConfigs);
                        } // End if
                    }//End if
                } // End for
            } // End if
        } // End if
        return lstActiveObjConfigs;
    } // End method
    
    // A method that returns labels for object api names stored in the record
    public Sobject retrieveObjLables (Sobject objInstance) {
        mapApiNameLabel = new  Map<String,String>();
        mapApiNameLabel = QueryBuilderUtility.retrievSobjectApiLabelMap();
        if (objInstance != null && mapApiNameLabel != null) {
            if (mapApiNameLabel.containsKey (String.valueOf(objInstance.get ('sObject_1__c'))))
                objInstance.put ('sObject_1__c', mapApiNameLabel.get (String.valueOf(objInstance.get ('sObject_1__c'))));
            if (mapApiNameLabel.containsKey (String.valueOf(objInstance.get ('sObject_2__c'))))
                objInstance.put ('sObject_2__c', mapApiNameLabel.get (String.valueOf(objInstance.get ('sObject_2__c'))));
            if (mapApiNameLabel.containsKey (String.valueOf(objInstance.get ('sObject_3__c'))))
                objInstance.put ('sObject_3__c', mapApiNameLabel.get (String.valueOf(objInstance.get ('sObject_3__c'))));
            if (mapApiNameLabel.containsKey (String.valueOf(objInstance.get ('sObject_4__c'))))
                objInstance.put ('sObject_4__c', mapApiNameLabel.get (String.valueOf(objInstance.get ('sObject_4__c'))));
        } // End if
        return objInstance;
    } // End method

    /*
    * Method to redirect to Customer Search Page on selection of particular
    * record from Object Configuratuion
    */
    public PageReference redirectCustomerSearchPage() {
        if(String.isNotBlank(selectedObjConfig)){
            // Redirecting user to customer search page
            PageReference searchPg= Page.CustomerSearchPage;
            searchPg.getParameters().put('id', selectedObjConfig);
            searchPg.setRedirect(true);
            return searchPg;
        }else{
            ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.Warning, Label.ErrorWhenNoObjectConfigSelected));
            return null;
        }
    } // End method
} // End class