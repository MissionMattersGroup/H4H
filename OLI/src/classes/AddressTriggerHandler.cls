public with sharing class AddressTriggerHandler {

	public void onAfterInsert(List<Address__c> newList) {
		setCurrentAddressFlag(newList);
	}

	public void onAfterUpdate(List<Address__c> newList) {
		setCurrentAddressFlag(newList);
	}

	private void setCurrentAddressFlag(List<Address__c> newList) {
		Set<Id> clientIdSet = new Set<Id>();
		Set<Id> currentAddressIdSet = new Set<Id>();
		for(Address__c a : newList) {
			if(a.Current_Address__c) {
				currentAddressIdSet.add(a.Id);
				clientIdSet.add(a.Client__c);
			}
		}
		if(!currentAddressIdSet.isEmpty()) {
			List<Address__c> addressUpdateList = new List<Address__c>();
			for(Address__c a : [SELECT Id, Current_Address__c FROM Address__c WHERE Current_Address__c = true AND Client__c IN :clientIdSet AND Id NOT IN :currentAddressIdSet]) {
				a.Current_Address__c = false;
				addressUpdateList.add(a);
			}
			if(!addressUpdateList.isEmpty()) {
				update addressUpdateList;
			}
		}
	}
}
