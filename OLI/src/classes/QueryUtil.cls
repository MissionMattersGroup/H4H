/*
 * Description : Utility class which returns map of zip and county           
 * Version               Author            Date (MM-DD-YYYY)           Change Log
 * 1.1                   Siddharth P       09/9/2015                   Initial Draft
 */
public with sharing class QueryUtil {
    // A method which returns Countys
    public static map<String, String> retrieveCounty(Set<String> zipCodes){
        Map<String, String> mapToUpdateCounty = new Map<String, String>(); 
        for(ZipCode__c zipIns : [Select Id, Name, County__c
                                 From ZipCode__c 
                                 Where Name IN: zipCodes]){
            mapToUpdateCounty.put(zipIns.Name, zipIns.County__c);
        }
        return  mapToUpdateCounty;
    }
}