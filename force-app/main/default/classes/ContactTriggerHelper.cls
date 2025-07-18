public class ContactTriggerHelper
{
    public static void beforeInsertHelper(List<Contact> contactListToInsert)
    {
        Set<Id> accId = new Set<Id>();
		for(Contact iterator : contactListToInsert)
		{
			accId.add(iterator.AccountId);			
		}
		
		Map<Id,Integer> contactCountMap = new Map<Id,Integer>();
		
		for(AggregateResult iterator : [Select Count(Id) ContactCount,AccountId from Contact where AccountId IN: accId group by AccountId])
		{
			contactCountMap.put((Id)iterator.get('AccountId'),Integer.valueOf(iterator.get('ContactCount')) );			
		}
		
		for(Contact iterator : contactListToInsert)
		{
			if( contactCountMap.get(iterator.AccountId) >= 2 )
			{
				iterator.addError('Contact Cannot Be Inserted');
			}
		}

    }
    
    
    public static void afterInsertHelper(List<Contact> newContactRecords)
    {
        Set<Id> accountIdsSet = new Set<Id>();
        for(Contact iterator : newContactRecords)
        {
            if( String.isNotBlank(iterator.AccountId) )
            {
                accountIdsSet.add(iterator.AccountId);
            }
        }
        
        //call to Service class
        if( !accountIdsSet.isEmpty() )
        {
            AccountService.updateActiveContactOnAccount(accountIdsSet);
        }
    }
    
    public static void afterUpdateHelper(List<Contact> newContactRecords, Map<Id,Contact> oldContactsMap)
    {
        Set<Id> accountIdsSet = new Set<Id>();
        for(Contact iterator : newContactRecords)
        {
            //Capture the account Id if active checkbox is flipped
            if( String.isNotBlank(iterator.AccountId) && iterator.Active__c != oldContactsMap.get(iterator.Id).Active__c )
            {
               accountIdsSet.add(iterator.AccountId);   
            }
            
            // Capture the account Id if lookup for Account is changed on contact. Capture the new Account Id and old account Id
            else if( iterator.AccountId != oldContactsMap.get(iterator.Id).AccountId )
            {
                accountIdsSet.add(iterator.AccountId);
                accountIdsSet.add(oldContactsMap.get(iterator.Id).AccountId);
            }
        }
        
        //call to Service class
        if( !accountIdsSet.isEmpty() )
        {
            AccountService.updateActiveContactOnAccount(accountIdsSet);
        }

    }
}