/*
 *    This class is used to redirect to newly created Oliclient record from shelter call record
 *
 *      Author               Date (dd-mm-yyyy)           Version                    ChangeLog
 *    Anuradha Nimbalkar      09-011-2015                  1.0                     Initial Draft
 */
public with sharing class FinishLocationController{
	
	//Variables
    public List<OLI_Client__c> lstOLIClient { get; set; }
    private Id shelCallId;
    
    //Constructor
    public FinishLocationController() {}

    public pageReference getClientId(){
        PageReference reRedirect;
        lstOLIClient = new List<OLI_Client__c>();
        shelCallId = Apexpages.currentpage().getparameters().get('id');
        if (shelCallId != null) {
            lstOLIClient = [Select id, Shelter_Id__c 
                            From OLI_Client__c 
                            where RecordTypeId =: 
                            Schema.SObjectType.OLI_Client__c.RecordTypeInfosByName.get('Mother').RecordTypeId 
                            And Shelter_Id__c=: shelCallId LIMIT 1];
            if (!lstOLIClient.IsEmpty() && lstOLIClient != null) {
                reRedirect = new PageReference('/' + lstOLIClient[0].Id );
                reRedirect.setRedirect(false);
            }
            else {
            	reRedirect = new PageReference('/' + shelCallId );
                reRedirect.setRedirect(false);
            }
        }
        return reRedirect ;
    }
}