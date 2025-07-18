public class CTPeopleTracingTriggerHelper 
{
    public static void beforeInsertHelper(List<People_Tracing__c> newRecordsList)
    {
        List<People_Tracing__c> duplicateTraces = CTPeopleTracingController.checkDuplicates(newRecordsList);
        
        if( duplicateTraces != null )
        {
            for( People_Tracing__c iterator : duplicateTraces )
            {
                iterator.addError('Duplicate Record Found '+ 'Person 1 '+iterator.Person_1__c+ ' Person 2 '+iterator.Person_2__c);
            }
        }
        
    }
    public static void afterInsertHelper(){}
}