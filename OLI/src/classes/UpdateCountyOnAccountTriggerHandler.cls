/*
 * Description : This handler will update the county when the Account will insert / update the zip code               
 * Version               Author            Date (MM-DD-YYYY)           Change Log
 * 1.1                 Anuradha N           10/13/2015                   Initial Draft
 */
public with sharing class UpdateCountyOnAccountTriggerHandler {
    
    // A method to update county on insert or update zipcode for Account Object
    public static void updateCountyOnAccount(List<Account> lstAccount){
        Set<String> zipSet = new Set<String>();
        Map<String, String> zipToCountyMap = new Map<String, String>();
        Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Organization').getRecordTypeId();
        for(Account objAccount : lstAccount){
        	if(objAccount.RecordTypeId == accRecordTypeId) {
            	zipSet.add(objAccount.BillingPostalCode);
        	}
        }
        zipToCountyMap = QueryUtil.retrieveCounty(zipSet);
        for(Account objAcc : lstAccount){
            if(zipToCountyMap.containsKey(objAcc.BillingPostalCode)){
                objAcc.County_Billing__c = zipToCountyMap.get(objAcc.BillingPostalCode);
            }
        }
    }
}