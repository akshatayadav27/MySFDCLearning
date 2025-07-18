public class OpportunityTriggerHandler 
{
    public static void validateOppRecords(List<Opportunity> oppRecords)
	{
		Set<Id> accId = new Set<Id>();
		
		Map<Id,Integer> opportunityCountMap = new Map<Id,Integer>();
		
		for(Opportunity iterator : oppRecords)
		{
			if(iterator.AccountId != NULL)
			{
				accId.add(iterator.AccountId);			
				
			}	
		}
		
		for(AggregateResult iterator : [Select Count(Id) OpportunityCount,AccountId from Opportunity where AccountId IN: accId group by AccountId])
		{
			opportunityCountMap.put((Id)iterator.get('AccountId'),Integer.valueOf(iterator.get('OpportunityCount')));	
		}
		
		for(Opportunity iterator : oppRecords)
		{
			if(opportunityCountMap.get(iterator.AccountId) > 4)
			{
				iterator.addError('Opportunity Cannot Be Inserted');
			}
			
		}
		
	}

}