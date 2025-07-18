public class CTLocationTracingTriggerHandler 
{
    public static void beforeInsertHandler(List<Location_Tracing__c> newRecordsList)
    {
        CTLocationTracingTriggerHelper.beforeInsertHelper(newRecordsList);
    }
    public static void afterInsertHandler(){}
}