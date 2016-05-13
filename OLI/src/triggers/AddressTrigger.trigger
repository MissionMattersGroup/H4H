trigger AddressTrigger on Address__c (before insert, before update, after insert, after update) {

	AddressTriggerHandler handler = new AddressTriggerHandler();

    if (Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)) {
        UpdateCountyTriggerHandler.updateAddress(Trigger.new);
    } else if (Trigger.isAfter) {
		if(Trigger.isInsert) {
			handler.onAfterInsert(Trigger.new);
		} else if (Trigger.isUpdate) {
			handler.onAfterUpdate(Trigger.new);
		}
	}
}
