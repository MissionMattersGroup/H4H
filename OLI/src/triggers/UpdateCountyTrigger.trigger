/*
 * Description : Shelter Call Trigger to update the county on insert or update the zip 
 * Version               Author            Date (MM-DD-YYYY)           Change Log
 * 1.1                   Siddharth P       09/9/2015                   Initial Draft
*/
trigger UpdateCountyTrigger on Shelter_Call__c (before insert, before update) {
	// Before Insert and Update Trigger
	if(Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)){
        UpdateCountyTriggerHandler.updateSheter(trigger.new);
	}

}