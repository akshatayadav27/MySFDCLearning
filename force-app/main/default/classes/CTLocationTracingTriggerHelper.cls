public class CTLocationTracingTriggerHelper 
{
    public static void beforeInsertHelper(List<Location_Tracing__c> newRecordsList)
    {
        for( Location_Tracing__c iterator : CTLocationTracingController.checkDuplicates(newRecordsList))
        {
            iterator.addError('Duplicate Record Found '+'Location '+iterator.Location__c+' Person '+iterator.Person__c);
        }
    }
    public static void afterInsertHelper(){}
}