/* Descreption: This is class to dynamically add the Dream Map on button click as per the Sobject Selected.
 *
 *      Author              Date (DD-MM-YYYY)       Version           Change Log
 *      Dhirendra Verma                               1.0             Initial Draft
 *      Dhirendra Verma     22/05/2015                1.1             Removed the delete functionality and updated the 
 *                                                                    Object Config Id through url.
 *      Dhirendra Verma     25/05/2015                1.2             Change the redirection method on click of save 
 *                                                                    goals and objectives
 *      Dhirendra Verma     31/08/2015                1.3             Optimized the code for set of required and hidden
 *                                                                    field for Dream Map.
 *      Dhirendra Verma     31/08/2015                1.4             Optimized the code for set of required and hidden
 *                                                                    field for Dream Map and called through 
 *                                                                    Query Builder.
 *
 */
 
public with sharing class DreamMapDetailsController {
    
    public Object_Configuration__c objConfigurationQuery { get; set; }
    public String popupForgoals                                 { get; set; }
    public sObject objDreamMap                                  { get; set; }
    public Map<String,String> mapApiNameLabel                   { get; set; }
    public string strClientId                                   { get; set; }
    public String objDreamMapName                               { get; set; }
    public List<String> accessibleFieldsForDreamMap             { get; set; }
    public Id dreamMapIdForPopUp                                { get; set; }
    public Map<String, Boolean> accessFieldsDreamMap            { get; set; }
    public Boolean showSave                                     { get; set; }
    
    private static final String strRequiredHiddenFields = Label.list_of_required_and_hidden_fields;
    private String lookupToPrimary;
    RequiredFields__c reqFields;
    private String objConId;
    
    //Constructor
    public DreamMapDetailsController()
    {
        mapApiNameLabel = new  Map<String,String>();
        mapApiNameLabel = QueryBuilderUtility.retrievSobjectApiLabelMap();
        objConId = ApexPages.currentPage().getParameters().get('objConfigId');
        if (String.isNotBlank(objConId )) {
            String queryStr = QueryBuilderUtility.getObjConfigurationQueryString(objConId);
            objConfigurationQuery = Database.query(queryStr);
            accessFieldsDreamMap = new Map<String, Boolean> ();
            if(String.isNotBlank(strRequiredHiddenFields)){
                reqFields = RequiredFields__c.getValues(strRequiredHiddenFields);
            }// End If
            init();
        }// End If
        
    }   
    //Method the intialize the list,Sobject
    public void init()
    {
        accessibleFieldsForDreamMap = 
                    QueryBuilderUtility.RetrieveDynamicFields(objConfigurationQuery.sObject_2__c, 
                                                              objConfigurationQuery.sObject_Field_2__c);
        if(String.isNotBlank(Apexpages.currentPage().getParameters().get('clientId')) && 
                                                Apexpages.currentPage().getParameters().get('clientId')!='null'){
                strClientId = Apexpages.currentPage().getParameters().get('clientId');
        }// End If
        try{
        if(objConfigurationQuery != null  && objConfigurationQuery.sObject_2__c != null)
           objDreamMapName=objConfigurationQuery.sObject_2__c;
           objDreamMap = QueryBuilderUtility.createObject(objDreamMapName);
        } catch (Exception e){
            ApexPages.Message showMsg = new ApexPages.Message(ApexPages.Severity.ERROR,
                                                                                   label.Error_msg_for_create_object);
            ApexPages.addMessage(showMsg);
       }
       try{
        lookupToPrimary= QueryBuilderUtility.getRelatedObjName(objConfigurationQuery.sObject_2__c,
                                                        objConfigurationQuery.sObject_1__c).getName();
        system.debug('lookupToPrimary***********'+lookupToPrimary);
        showSave=true;
        }catch(Exception errMsgForLookup){
             ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 
                                                                    label.ErrorLookupBetweenPrimaryChildObj1);
             ApexPages.addMessage(errMsg);
             showSave=false;
        }
        getListDreamMaps();
    }
   
   //Method to remove the Lookup field from the page and make the fields required
    public void getListDreamMaps() 
    {
        if(accessibleFieldsForDreamMap !=null && !accessibleFieldsForDreamMap.isEmpty()) {
            for (String fieldName : accessibleFieldsForDreamMap) {
                 accessFieldsDreamMap.put(fieldName, FALSE);
            }// End For
        }//End If
        //To remove the hidden fields for Dream Map List on Dream Map Page
        if(reqFields != null) {
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
    
    // Method to save the record inserted on click of Dream Map
    public PageReference saveDreamMap() {
            //Insert the Dream Map
            if(objDreamMap !=  null && strClientId!=null && strClientId != '')
            {
                if(lookupToPrimary!= null ) {
                	try{
                    	objDreamMap.put(lookupToPrimary,strClientId);
                	}
                	catch(Exception errMsgForLookup){
			             ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 
			                                                                    label.ErrorLookupBetweenPrimaryChildObj1);
			             ApexPages.addMessage(errMsg);
			             showSave=true;
			             return null;
			        }
                }// End If
                try{
                    insert objDreamMap;
                    dreamMapIdForPopUp = objDreamMap.Id;
                }
                catch(Exception errMsg){
                    ApexPages.addMessages(errMsg);
                }
            }//End of If
            else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,label.ErrorMsgForDreamMapDeatils));
            }
            return null;
    }//End of Method
    
    //Method to  redirect to the previous page on click of Cancel
    public PageReference CancelDreamMap()
    {
        // Redirecting user to DynamicQueryForDreamMap page
            PageReference reRend= Page.DynamicQueryForDreamMap;
            reRend.getParameters().put('clientId', strClientId);
            reRend.getParameters().put('objConfigId', objConId);
            reRend.setRedirect(true);
            return reRend;
    }//End of Method
}