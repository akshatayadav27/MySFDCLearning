public class CTPeopleTracingTriggerHandler 
{
    public static void beforeInsertHandler(List<People_Tracing__c> newRecordsList)
    {
        CTPeopleTracingTriggerHelper.beforeInsertHelper(newRecordsList);
    }
    public static void afterInsertHandler(){}
}