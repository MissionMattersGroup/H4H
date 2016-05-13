/*
 * Description : This Page Retrieve Records from Object Configuration Objects based on Search Criteria
 *
 * Version               Author            Date (DD-MM-YYYY)           Change Log
 * 1.1                   Siddharth P                                   Initial Draft
 * 1.2                   Sourabh Tayal     20/5/2015                   Changes for Passing Object Configuration 
 *                                                                     id in Url
 * 1.3                   Dhirendra Verma   27/07/2015                  Add pagination functionality to avoid view state
 *                                                                     error.
 * 1.4                   Twinkle Panjabi   4/11/2015                   Added a lines to check for mod condition in LastPage()              
 */
public class CustomerSearchController
{
    //variables
    public List<Object_Configuration__c> objConLst        { get; set; }
    public Map<String,String> mapApiNameLabel             { get; set; }
    public List<sobject> SobjectList                      { get; set; }
    public String objName                                 { get; set; }
    public String inputText                               { get; set; }
    public String sortExpression                          { get; set; }
    public String operatorSymbol                          { get; set; }
    public String searchTextValue                         { get; set; }
    public String[] fieldValue                            { get; set; }
    public integer offsetSize                             { get; set; }
    public integer totalRecs                              { get; set; }
    public integer limitSize                              { get; set; }
    //Holding selected values.
    public String selectedVal                             { get; set; }
    public string objConId;
    public String sObjectField                            { get; set; }
    //public sObject objectName                             { get; set; }
    
    private String strDreampMapclientId;
    private Object_Configuration__c objConfig;
    private String fieldName ;
    private String queryString;
    private String sortDirection = 'ASC';
    private String sortExp = 'last_name__c';
    private String setNull= 'NULLS LAST';
    private String objConQuery;
    private string countQuery;
    
    //Store labels value in a particular string
    String ErrorMsgForCustomerSearchPageForSearchWithBlank_Value = 
                                                    System.Label.ErrorMsgForCustomerSearchPageForSearchWithBlank_Value;
    String ErrorMsgForCustomerSearchPageForRecordNotFound = 
                                                    System.Label.ErrorMsgForCustomerSearchPageForRecordNotFound;

    //Constructor
    public  CustomerSearchController() {
        init();
    }
    
    //Method to Intialize List
    public Void init() {
        offsetSize = 0;
        limitSize = 0;
        totalRecs = 0;
        mapApiNameLabel = new  Map<String,String>();
        mapApiNameLabel = QueryBuilderUtility.retrievSobjectApiLabelMap();
        objConId = ApexPages.currentPage().getParameters().get('id');
        objConLst = new List<Object_Configuration__c>();
        countQuery='';
        SobjectList=new List<sobject>();
        if(ObjConId != null && ObjConId != 'null') {
            objConQuery = QueryBuilderUtility.getObjConfigurationQueryString(ObjConId);
        }
        if(objConQuery != null) {
            objConLst= Database.query(objConQuery);
        }
        if(!objConLst.isEmpty() && objConLst != null) {
            if(objConLst[0].sObject_1__c != null && objConLst[0].sObject_Field_1__c != null 
                                                        && objConLst[0].sObject_2__c != null) {
                objName=objConLst[0].sObject_1__c;
                fieldName=objConLst[0].sObject_Field_1__c;
                fieldValue = objConLst[0].sObject_Field_1__c.trim().split(', ');
            }
        }
        else {
            ApexPages.Message showMsg = new ApexPages.Message(ApexPages.Severity.ERROR, label.Error_Msg_For_Invalid_Id);
            ApexPages.addMessage(showMsg);
        }
        if(sortDirection == 'ASC') {
            setNull =' NULLS LAST';
        }   
        else {
            setNull =' NULLS FIRST';
        }
    }
    
    // Populate Operator Symbol into List 
    public List<SelectOption> getoperator() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('---SELECT OPERATOR---','---SELECT OPERATOR---'));
        options.add(new SelectOption('=','equals'));
        options.add(new SelectOption('!=','not equals'));
        options.add(new SelectOption('LIKE','contains'));
        options.add(new SelectOption('NOT LIKE','does not contain'));
        return options;
    }
    
    // To Get Sorting Direction of Records
    public String getSortDirection() {
        //if not column is selected 
        if (sortExpression == null || sortExpression == '')
            return 'ASC';
        else
            return sortDirection;
    }
    
    // Populate Field Name into List 
    public List<SelectOption> getfieldNames() {
        try{
            List<Schema.DescribeSObjectResult> describeSobjectsResult = 
                                                                    Schema.describeSObjects(new List<String>{objName});
            Map<String, Schema.SObjectField> allFields = describeSobjectsResult[0].fields.getMap();
            String fieldLabel = '';
            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('---SELECT FIELDS---','---SELECT FIELDS---'));
            for(String getfield:fieldValue) {
                if (allFields != null){
                    for (Schema.SObjectField schSobjField : allFields.values()) {
                        if (schSobjField.getDescribe().getName().equalsIgnoreCase(getfield)){
                            fieldLabel = schSobjField.getDescribe().getLabel();
                            options.add(new selectoption(getfield,fieldLabel));
                        }
                    }
                }
                
            }
            return options;
         } catch (exception e) {
              ApexPages.Message showMsg = 
                                new ApexPages.Message(ApexPages.Severity.ERROR, label.Error_msg_for_create_object);
              ApexPages.addMessage(showMsg);
         }
         return null;
    }

    //This method Create Dynamic Query
    public String dynamicQuery (String query) {
        String returnQuery='';
        if (query != null && query != '') {
            String queryStr = QueryBuilderUtility.constructQuery(objName,fieldName);
            returnQuery = queryStr+ ' where ' + query;
            countQuery = 'SELECT COUNT() FROM ' + objName;
            countQuery += ' WHERE ' + query;
        }
        return returnQuery;
    }
    
    //This method Sets Records Display Order
    public void setSortDirection(String value) {  
        sortDirection = value;
    }
     
    //This method Sorting Records 
    public String sorting(String sortFullExp) {
        String query='';
        if(operatorsymbol == '=' || operatorsymbol == '!=') {
            query = + searchTextValue+' '+operatorsymbol+'\''
                    +String.escapeSingleQuotes(inputText)+'\' order by ' +sortFullExp + setNull;
        }
        if(operatorsymbol=='LIKE') {
            query =+searchTextValue+  ' LIKE '+ '\''+'%'+inputText+'%'+'\'order by ' +sortFullExp + setNull;
        }
        if(operatorsymbol=='NOT LIKE') {
            query = 'NOT ' +searchTextValue+  ' LIKE '+ '\''+'%'+inputText+'%'+'\'order by ' +sortFullExp + setNull;
        }
        return query;
    }
    
    //This method checks for 'order by' in query string
    public string checkCountQuery(String countQuery){
    	if(countQuery.containsIgnoreCase('order by')){
        	countQuery = countQuery.substringBefore('order by');
        }
        return countQuery;
    }
    
    //This method used for Final Results
    public void getSearchResult () {
        //limitSize = Integer.valueOf(selectedVal);
        if(Test.isRunningTest()){
            limitSize = 5;
        }
        else{limitSize = Integer.valueOf(selectedVal);}
        //Applied the condition to set Offset Size zero to display all the records when count is less then the limitSize
        offsetSize = limitSize > totalRecs ? 0 : offsetSize;
        string receiveQuery = dynamicQuery (queryString) +' LIMIT  ' + limitSize + ' OFFSET ' + offsetSize;
        countQuery = checkCountQuery(countQuery);
        totalRecs = Database.countQuery(countQuery);
        system.debug('#####receiveQuery ='+receiveQuery);
        system.debug('#####totalRecs ='+totalRecs);
        if(sortDirection=='ASC'){sortDirection='DESC';setNull =' NULLS FIRST';}
        else {sortDirection='ASC';setNull =' NULLS LAST';}        
        try{
            SobjectList=database.query(receiveQuery);            
            if(SobjectList.size()==0) {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,
                                                ErrorMsgForCustomerSearchPageForRecordNotFound));
            }
        }
        catch (QueryException e) {
        }
        //selectedVal='';  
    }
    
    //This method Filtering Records
    public String filterRecords() {
        if(operatorsymbol=='=' || operatorsymbol=='!=') {
            queryString =+ searchTextValue+' '+operatorsymbol+'\''+String.escapeSingleQuotes(inputText)+'\'';
        }
        if(operatorsymbol=='LIKE') {
            queryString =+searchTextValue+' '+operatorsymbol+'\''+'%'+inputText+'%'+'\'';
        }
        if(operatorsymbol=='NOT LIKE'){
            queryString ='NOT ' +searchTextValue+' LIKE '+'\''+'%'+inputText+'%'+'\'';
        }
        return queryString;
    }
    
    //This Method is to redirect to dream map page
    public PageReference showDreamMap() {
         strDreampMapclientId = Apexpages.currentPage().getParameters().get('dreamMapDetails');
         PageReference reRend= Page.DynamicQueryForDreamMap;
         reRend.getParameters().put('clientId', strDreampMapclientId);
         reRend.getParameters().put('objConfigId', objConId);
         reRend.setRedirect(true);
         return reRend; 
    }
    
    //check whether the field selected is sortable
    public boolean checkFieldIsSortable(){
    	if(String.isNotBlank(objName)){
    		List<Schema.DescribeSObjectResult> describeSobjectsResult = Schema.describeSObjects(new List<String>{objName});
	        Map<String, Schema.SObjectField> allFields = describeSobjectsResult[0].fields.getMap();
	        if(allFields.get(sObjectField) != null){
	        	return allFields.get(sObjectField).getDescribe().isSortable();
	        }
	        
    	}
    	return false;
    }
    
    //This method used for Sorting Records
    public void sortingRecords() { 
        String sortFullExp = sortExpression  + ' ' + sortDirection;  
        system.debug('###sortFullExp'+sortFullExp);
        queryString = Sorting(sortFullExp);
        if(checkFieldIsSortable()){
        	try{
            	getSearchResult();
            }
            catch(Exception e){
            	ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,
                                                        Label.ErrorMsgForCustomerSearchPageForSearchForErrorInQuerying));
                SobjectList.clear();                               
            }  
        }
        else{
        	ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,
                                                        Label.ErrorMsgForCustomerSearchPageForSearchForErrorInSorting));
        }
    }
    
    //This method used for Searching Records
    public void searchingRecords() { 
        String sortFullExp = sortExpression  + ' ' + sortDirection;
        if(searchTextValue=='---SELECT FIELDS---'){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,Label.ErrorForIncorrectField));
            SobjectList.clear();
        }else if(operatorSymbol=='---SELECT OPERATOR---'){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,Label.ErrorForIncorrectOperator));
            SobjectList.clear();
        }else if(String.isBlank(inputText)){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,
                                                        ErrorMsgForCustomerSearchPageForSearchWithBlank_Value));
            SobjectList.clear();
        }else{
            queryString = filterrecords();
            try{
            	getSearchResult();
            }
            catch(Exception e){
            	ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,
                                                        Label.ErrorMsgForCustomerSearchPageForSearchForErrorInQuerying));
                SobjectList.clear();
                offsetSize = 0;
		        limitSize = 0;
		        totalRecs = 0; 
            }
        }
    }
    //This method used to show the data on first Page from Search Records
    public void FirstPage(){
        offsetSize = 0;
        if(!checkFieldIsSortable()){        	
        	queryString = Sorting('Name ');        	
        }
        getSearchResult ();
    }
    //This method used to show the data on Previous Page from the Current Search Records 
    public void previous() {
        offsetSize = offsetSize - limitSize;
        if(!checkFieldIsSortable()){
        	
        	queryString = Sorting('Name ');
        	
        }
        getSearchResult ();
    }
    //This method used to show the data on Next Page from the Current Search Records 
    public void next() {
        offsetSize = offsetSize + limitSize;
        if(!checkFieldIsSortable()){        	
        	queryString = Sorting('Name ');
        }
        system.debug('%%%%%%next prev offsetSize'+offsetSize);
        system.debug('%%%%%%next prev limitSize'+limitSize);
        system.debug('%%%%%%next offsetSize'+offsetSize);
        getSearchResult ();
        system.debug('$$$$Snext sobjectList size$$$$'+SobjectList.size()); 
    }
    //This method used to show the data on last Page from Search Records
    public void LastPage(){
        //offsetSize = totalrecs - math.mod(totalRecs,limitSize);
        if(math.mod(totalRecs,limitSize) == 0){
    		offsetSize = totalrecs - limitSize;
    	}
    	else{
    		offsetSize = totalrecs - math.mod(totalRecs,limitSize);
    	}
    	system.debug('%%%%%%LastPage prev totalrecs'+totalrecs);
    	system.debug('%%%%%%LastPage prev offsetSize'+limitSize);
    	system.debug('%%%%%%LastPage offsetSize'+offsetSize);
        if(!checkFieldIsSortable()){
        	queryString = Sorting('Name ');
        }
        getSearchResult ();
        system.debug('$$$$SLastPage sobjectList size$$$$'+SobjectList.size());  
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
        if((offsetSize + limitSize) > totalRecs || totalRecs <= 0 || SobjectList.size() < 0 || (OffsetSize + LimitSize) == totalRecs)
            return true;
        else
            return false;
    }
    //Method to add options in the drop down to set limit according to the value selected
    public List<SelectOption> getSelectOptionsForPagination(){
        return QueryBuilderUtility.getSelectOptions();
    }
}