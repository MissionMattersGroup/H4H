public with sharing class DisplayPopupExt {

    //Variables
    public Boolean popupForgoals { get; set; }
    public Id dreamMapId         { get; set; }
    public String clientIdExt    { get; set; }
    
    public DisplayPopupExt(DreamMapDetailsController controller) {}
    public DisplayPopupExt(DynamicQueryForDreamMap controller) {}
    public DisplayPopupExt(DynamicQueryForContactGoalsController controller) {
        popupForgoals = false;
    }

    // Method to redirect the Add Goal and Objective Page so specific Dream Map
    public PageReference Cancel() {
        popupForgoals = false;
        if (clientIdExt != null && clientIdExt != '') {
            clientIdExt= clientIdExt.substring(0,15);
            PageReference reRend = Page.DynamicQueryForDreamMap;
            reRend.getParameters().put('clientid', clientIdExt);
            reRend.setRedirect(true);
            return reRend;
        }//End If
        return null;
    }//End of Method

    // Method to redirect the Add Goal and Objective Page so specific Dream Map
    public PageReference addGoalsAndObjectives()
    {
        if(String.isNotBlank(clientIdExt)){
            popupForgoals = true;
        }//End If
         return null;
    }//End of Method
}