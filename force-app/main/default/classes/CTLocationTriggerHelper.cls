public class CTLocationTriggerHelper 
{
    /* Make sure the Location status is Green while inserting record 
     */ 
    public static void beforeInsertHelper(List<Location__c> newRecordsList)
    {
        for( Location__c iterator : newRecordsList )
        {
            iterator.Status__c = 'Green';
        }
    }
    
     /* When Location status updates, update the "Status_Update_Date__c" date field
     */ 
    public static void beforeUpdateHelper(List<Location__c> newRecordsList, Map<Id,Location__c> oldRecordsMap)
    {
        for(Location__c iterator : newRecordsList)
        {
            if( iterator.Status__c != oldRecordsMap.get(iterator.Id).Status__c )
            {
                iterator.Status_Update_Date__c = Date.today();
            }
        }
    }
    
    public static void afterUpdateHelper(List<Location__c> newRecordsList, Map<Id,Location__c> oldRecordsMap)
    {
        Set<Id> locationIds = new Set<Id>();
        for(Location__c iterator : newRecordsList)
        {
            if( iterator.Status__c == 'Red' && oldRecordsMap.get(iterator.Id).Status__c != 'Red' )
            {
                locationIds.add(iterator.Id);
            }
        }
        
        List<Person__c> personsList = new List<Person__c>();
        for( Location_Tracing__c iterator : [ SELECT Person__c, Location__c, Visit_Date__c 
                                             FROM Location_Tracing__c WHERE Location__r.Id IN :locationIds 
                                             AND Visit_Date__c =LAST_N_DAYS:10
                                             AND Person__r.Health_Status__c NOT IN ('Red','Orange') ] )
        {
            
            Person__c personObj = new Person__c(Id=iterator.Person__c, Health_Status__c = 'Yellow');

            /* check for duplicates
             * If a persons record is already present in List avoid it if its not there then 
             * only add it the list
             */ 
            if( ! personsList.contains(personObj) )
            {
                personsList.add(personObj);
            }
        }
        
        if( !personsList.isEmpty() )
        {
          update personsList;
        } 
    }
}