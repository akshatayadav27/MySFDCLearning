public class CTPeopleTracingDataCleanupBatch implements Database.Batchable<Sobject>
{

    public Database.QueryLocator Start(Database.BatchableContext bc)
    {
        return Database.getQueryLocator('SELECT Id FROM People_Tracing__c WHERE Contact_Date__c < LAST_N_DAYS:30');
    }
    
    public void execute(Database.BatchableContext bc, List<People_Tracing__c> scope)
    {
		delete scope;        
    } 
    
    public void finish(Database.BatchableContext bc)
    {
        
    }
    
}