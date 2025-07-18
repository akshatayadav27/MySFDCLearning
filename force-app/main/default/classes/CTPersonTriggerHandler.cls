public class CTPersonTriggerHandler 
{
    public static void beforeInsertHandler(List<Person__c> newRecordsList)
    {
        CTPersonTriggerHelper.beforeInsertHelper(newRecordsList);
    }
    public static void afterInsertHandler(Map<Id,Person__c> newRecordsMap){}
    
    public static void beforeUpdateHandler(List<Person__c> newRecordsList, Map<Id,Person__c> oldRecordsMap)
    {
        CTPersonTriggerHelper.beforeUpdateHelper(newRecordsList, oldRecordsMap);
    }
    
    public static void afterUpdateHandler(List<Person__c> newRecordsList, Map<Id,Person__c> oldRecordsMap)
    {
        CTPersonTriggerHelper.afterUpdateHelper(newRecordsList, oldRecordsMap);
    }
}