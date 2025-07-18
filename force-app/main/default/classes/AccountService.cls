public class AccountService 
{
    // Solve using group by AggregateResult
    public static void updateCountOnAccount(Set<Id> accountIdsSet)
    {
        Map<Id,Account> accountsToUpdateMap = new Map<Id,Account>();
        
        /*
            This query will return null (no rows) if there are no active contacts associated to the respective account
			then the for loop will not execute for that particular account
			and active contacts will not be updated to zero
			To overcome this problem we are using Map<Id,Account>
        */
        List<AggregateResult> activeContacts = [SELECT Count(Id) ActiveContacts,AccountId FROM Contact WHERE AccountId IN:accountIdsSet AND Active__c = true GROUP BY AccountId];
        for(AggregateResult iterator : activeContacts)
        {
            Account accountObj = new Account(Id=(Id)iterator.get('AccountId'), Active_Contacts__c = (Decimal)iterator.get('ActiveContacts'));
            accountsToUpdateMap.put( (Id)iterator.get('AccountId'), accountObj );
        }
        
        /* Iterate over the set of Account Ids received from helper class 
         * check whether the map has that account Id if Map does not have the account Id then active contacts will be zero
         * for that particular account
		*/
        
        for( Id iterator : accountIdsSet )
        {
            if( !accountsToUpdateMap.containsKey(iterator) )
            {
                accountsToUpdateMap.put( iterator, new Account(Id=iterator,Active_Contacts__c = 0) );
            }
        }
        
        //Update the account values from the Map
        update( accountsToUpdateMap.values() );
    }
    
    public static void updateActiveContactOnAccount(Set<Id> accountIdsSet)
    {
        List<Account> accountsToUpdate =  new List<Account>();
        List<Account> accountsList = [ SELECT Id, (SELECT Id FROM Contacts WHERE Active__c=true ) FROM Account WHERE Id IN:accountIdsSet ];
        
        /*
          As this is parent child SOQL will need two for loops to iterate over it. 
		  First for loop for Account and second for loop for iterating on Contacts
		*/
        for( Account iterator : accountsList )
        {
            accountsToUpdate.add( new Account( Id=iterator.Id, Active_Contacts__c = iterator.Contacts.size() ) );
        }   
        update(accountsToUpdate);        
    }
}