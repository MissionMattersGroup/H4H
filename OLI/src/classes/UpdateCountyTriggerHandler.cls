/*
 * Description : This handler will update the county when the shelter call will insert / update the zip code               
 * Version               Author            Date (MM-DD-YYYY)           Change Log
 * 1.1                   Siddharth P       09/9/2015                   Initial Draft
 */
public with sharing class UpdateCountyTriggerHandler {
    
    // A method to update county on insert or update zipcode for Shelter Object
    public static void updateSheter(List<Shelter_Call__c> lstShelter){
        Set<String> zipSet = new Set<String>();
        Map<String, String> zipToCountyMap = new Map<String, String>();
        for(Shelter_Call__c sheltIns : lstShelter){
            zipSet.add(sheltIns.Current_Zip__c);
            zipSet.add(sheltIns.X90_Nights_Zip__c);
        }
        zipToCountyMap = QueryUtil.retrieveCounty(zipSet);
        for(Shelter_Call__c shelInstance : lstShelter){
            if(zipToCountyMap.containsKey(shelInstance.Current_Zip__c)){
                shelInstance.Current_County__c = zipToCountyMap.get(shelInstance.Current_Zip__c);
            }
            if(zipToCountyMap.containsKey(shelInstance.X90_Nights_Zip__c)){
                shelInstance.X90_Nights_County__c = zipToCountyMap.get(shelInstance.X90_Nights_Zip__c);
            }
        }
    }
    
    // A method to update county on insert or update zipcode for Address Object
    public static void updateAddress(List<Address__c> lstAddress){
        Set<String> zipSet = new Set<String>();
        Map<String, String> zipToCountyMap = new Map<String, String>();
        for(Address__c addIns : lstAddress){
            zipSet.add(addIns.Zip__c);
        }
        zipToCountyMap = QueryUtil.retrieveCounty(zipSet);
        for(Address__c addInstance : lstAddress){
            if(zipToCountyMap.containsKey(addInstance.Zip__c)){
                addInstance.County__c = zipToCountyMap.get(addInstance.Zip__c);
            }
        }
    }
}