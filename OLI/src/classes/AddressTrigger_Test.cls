@isTest
public with sharing class AddressTrigger_Test {

	class TestFactory {

		Integer recordCount { get; set; }
		List<Address__c> testAddressList { get; set; }
		OLI_Client__c testClient { get; set; }

		TestFactory(Integer count) {
			recordCount = count;
			setTestAddressList();
		}

		public Map<Id, Address__c> getTestAddressMap() {
			insert testAddressList;
			return new Map<Id, Address__c>(testAddressList);
		}

		public List<Address__c> getTestAddressList() {
			return testAddressList;
		}

		public void setTestAddressList() {
			testClient = (OLI_Client__c)SmartFactory.createSobject('OLI_Client__c', false);
			insert testClient;
			testAddressList = (List<Address__c>)SmartFactory.createSObjectList('Address__c', false, recordCount);
			String addyString = 'abcdefghij';
			for(Integer i=0; i<testAddressList.size(); i++) {
				testAddressList[i].Client__c = testClient.Id;
				testAddressList[i].Current_Address__c = false;
				// testAddressList[i].City__c = addyString;
				// testAddressList[i].County__c = addyString;
				// testAddressList[i].State__c = addyString;
				// testAddressList[i].Street__c = String.valueOf(Math.round(Math.random())) + ' ' + addyString;
				// testAddressList[i].Zip__c = '2345' + String.valueOf(i);
			}
			testAddressList[0].Current_Address__c = true;
		}
	}

	@isTest
	static void testSetCurrentAddressFlag() {
		Test.startTest();
		TestFactory factory = new TestFactory(10);
		factory.getTestAddressMap();
		Address__c testAddress = (Address__c)SmartFactory.createSobject('Address__c', false);
		testAddress.Current_Address__c = true;
		testAddress.Client__c = factory.testClient.Id;
		insert testAddress;
		System.assertEquals(1, [SELECT count() FROM Address__c WHERE Current_Address__c = true AND Client__c = :factory.testClient.Id]);
		testAddress = [SELECT Id, Current_Address__c FROM Address__c WHERE Client__c = :factory.testClient.Id AND Current_Address__c = false LIMIT 1];
		testAddress.Current_Address__c = true;
		update testAddress;
		System.assertEquals(1, [SELECT count() FROM Address__c WHERE Current_Address__c = true AND Client__c = :factory.testClient.Id]);
		Test.stopTest();
	}
}
