/*
 * This class is used to create mutiple selfSufficiency Evaluation records related to mother OLI Client based on Domain 
 * type picklist values
 *      Author             Date (dd-mm-yyyy)            Version                    ChangeLog
 *   Anuradha Nimbalkar       07-10-2015                  1.0                     Initial Draft
 */
global class CreateSelfSufficiencyEvaluation {
	
	static final String STR_HYPHEN = '-';
    static final Id oliRecordTypeId = 
    Schema.SObjectType.OLI_Client__c.getRecordTypeInfosByName().get('Mother').getRecordTypeId();
    
    //This method will accept oliclient id form visual flow and create SelfSufficiencyEvaluation records
	@InvocableMethod
    public static void getOliCLientId(List<Id> lstClientId) {
    	//Invocable method does not allow single instance it only allow list
        List<String> lstDomainType = new List<String>();
		Schema.DescribeFieldResult fieldResult = SelfSufficiency_Evaluation__c.Domain_Type__c.getDescribe();
		List<Schema.PicklistEntry> objDomainTypeValue = fieldResult.getPicklistValues();
		for( Schema.PicklistEntry objPicklistEntry : objDomainTypeValue) {
		    lstDomainType.add(objPicklistEntry.getLabel());
		}
        List<SelfSufficiency_Evaluation__c> lstSelf = new List<SelfSufficiency_Evaluation__c>();
        if(!lstClientId.IsEmpty()) {
	        for (OLI_Client__c objClient : [SELECT Id, Name, RecordTypeId FROM OLI_Client__c 
	                                        WHERE Id IN: lstClientId And RecordTypeId =: oliRecordTypeId]) {
	            for (String typeName : lstDomainType) {
	            	SelfSufficiency_Evaluation__c objSelf = new SelfSufficiency_Evaluation__c();
	            	objSelf.Name = typeName + STR_HYPHEN + objClient.Name;
	            	objSelf.Domain_Type__c = typeName;
	            	objSelf.OLI_Client__c = objClient.Id;
	            	lstSelf.add(objSelf);
	            }
	        }
	        if(!lstSelf.isEmpty()) {
	        	try {
	        		Database.insert(lstSelf,false);
	        	}
	        	catch(Exception e) {
		    		System.debug('The following exception has occurred: ' + e.getMessage());
		    	}
	        }
        }
    }
}