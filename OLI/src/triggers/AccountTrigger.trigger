/*
 * Description : Account Trigger to update the county on insert or update the zip 
 * Version               Author            Date (MM-DD-YYYY)           Change Log
 * 1.1                 Anuradha N            10/13/2015                   Initial Draft
*/
trigger AccountTrigger on Account (before insert, before update) {
    
    // Before Insert and Update Trigger
    if(Trigger.isBefore && Trigger.isInsert){
        UpdateCountyOnAccountTriggerHandler.updateCountyOnAccount(trigger.new);
    }
    if(Trigger.isBefore && Trigger.isUpdate){
        UpdateCountyOnAccountTriggerHandler.updateCountyOnAccount(trigger.new);
    }
}