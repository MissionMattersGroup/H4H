/**
 * Auto Generated and Deployed by the Declarative Lookup Rollup Summaries Tool package (dlrs)
 **/
@IsTest
private class dlrs_OLI_ClientTest
{
    private static testmethod void testTrigger()
    {
        // Force the dlrs_OLI_ClientTrigger to be invoked, fails the test if org config or other Apex code prevents this.
        dlrs.RollupService.testHandler(new OLI_Client__c());
    }
}