public class ContactTriggerHandler 
{
    public static void beforeInsertHandler(List<Contact> newContactRecords)
    {
        ContactTriggerHelper.beforeInsertHelper(newContactRecords);
    }
    
    public static void afterInsertHandler(List<Contact> newContactRecords)
    {
       ContactTriggerHelper.afterInsertHelper(newContactRecords);
    }
    public static void afterUpdateHandler(List<Contact> newContactRecords, Map<Id,Contact> oldContactsMap)
    {
       ContactTriggerHelper.afterUpdateHelper(newContactRecords,oldContactsMap);
    }
     public static void afterDeleteHandler(List<Contact> newContactRecords)
    {
       ContactTriggerHelper.afterInsertHelper(newContactRecords);
    }
     public static void afterUndeleteHandler(List<Contact> newContactRecords)
    {
       ContactTriggerHelper.afterInsertHelper(newContactRecords);
    }
}