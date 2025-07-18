public class CTLocationTriggerHandler 
{
    public static void beforeInsertHandler(List<Location__c> newRecordsList)
    {
        CTLocationTriggerHelper.beforeInsertHelper(newRecordsList);
    }
    
    public static void beforeUpdateHandler(List<Location__c> newRecordsList, Map<Id,Location__c> oldRecordsMap)
    {
        CTLocationTriggerHelper.beforeUpdateHelper(newRecordsList, oldRecordsMap);
    }

    public static void afterUpdateHandler(List<Location__c> newRecordsList, Map<Id,Location__c> oldRecordsMap)
    {
        CTLocationTriggerHelper.afterUpdateHelper(newRecordsList, oldRecordsMap);
    }
}