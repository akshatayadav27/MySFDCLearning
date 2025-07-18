public class CTPersonTriggerHelper 
{
    public static void beforeInsertHelper(List<Person__c> newRecordsList)
    {
        for(Person__c iterator : newRecordsList) 
        {
            iterator.Health_Status__c = 'Green';
            iterator.Token__c = CTPersonController.getToken(iterator.Mobile__c);
        }
    }
    public static void afterInsertHelper(Map<Id,Person__c> newRecordsMap){}
    
    public static void beforeUpdateHelper(List<Person__c> newRecordsList, Map<Id,Person__c> oldRecordsMap)
    {
        for( Person__c iterator : newRecordsList )
        {
            if( iterator.Health_Status__c != oldRecordsMap.get(iterator.Id).Health_Status__c )
            {
                iterator.Status_Update_Date__c = Date.today();
            }
        }
    }
    
    public static void afterUpdateHelper(List<Person__c> newRecordsList, Map<Id,Person__c> oldRecordsMap)
    {
        Set<Id> statusChange = new Set<Id>();
        Set<Id> redStatusChange = new Set<Id>();
        
        for( Person__c iterator : newRecordsList )
        {
            // Check for health status change
            if( iterator.Health_Status__c != oldRecordsMap.get(iterator.Id).Health_Status__c )
            {
               statusChange.add(iterator.Id);
            }
            
            // Check for health status change specific to 'Red'
            if(iterator.Health_Status__c == 'Red' && oldRecordsMap.get(iterator.Id).Health_Status__c != 'Red')
            {
                redStatusChange.add(iterator.Id);
            }
        }

		/* Set of Ids to maintain the records which are already processed by the previous methods If a persons records is updated by
		 * getCohabitants and marked to Orange then the next methods should not override the status of the record
		 * Create a set passing the redStatusChange Ids
		 */ 
        
        Set<Id> processedRecords = new Set<Id>(redStatusChange);
        
        Set<Id> orangeStatus = new Set<Id>();
        Set<Id> yellowStatus = new Set<Id>();
        
        // Get the "Cohabitants" to mark as Orange pass the red Status Ids
        orangeStatus.addAll(CTPersonController.getCohabitants(redStatusChange,processedRecords));
		
        // Get the primary contacts to mark as Orange pass the red Status Ids
        Set<Id> primaryContacts = CTPersonController.getPrimaryContacts(redStatusChange,processedRecords);
        orangeStatus.addAll(primaryContacts);
        
        // Get the "Neighbours" to mark as Yellow pass the red Status Ids
        yellowStatus.addAll(CTPersonController.getNeighbours(redStatusChange,processedRecords));
        
        // Get the "Secondary Contacts" to mark as Yellow pass the red Status Ids In order to get Secondary contacts pass the primary contacts
        yellowStatus.addAll(CTPersonController.getSecondaryContacts(primaryContacts,processedRecords));
        
        List<Person__c> personsToUpdate = new List<Person__c>();
        
        for(Id iterator : orangeStatus)
        {
            personsToUpdate.add(new Person__c(Id=iterator, Health_Status__c = 'Orange'));
        }
        
        for(Id iterator : yellowStatus)
        {
            personsToUpdate.add(new Person__c(Id=iterator, Health_Status__c = 'Yellow'));
        }
        
        if( !personsToUpdate.isEmpty() )
        {
            update personsToUpdate;
        }
        
        List<Location_Tracing__c> locationTraces = CTLocationTracingController.getLocationsByPersonIds(statusChange);
        Set<Id> locationIds = new Set<Id>();
        for(Location_Tracing__c iterator : locationTraces)
        {
            locationIds.add(iterator.Location__c);
        }
        
        // Update Red Score
        CTLocationController.updateRedScore(locationIds);
    }
    
}