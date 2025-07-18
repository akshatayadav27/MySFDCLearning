trigger OpportunityTrigger on Opportunity (before insert) 
{
	switch on Trigger.OperationType
	{
		when BEFORE_INSERT
		{
			OpportunityTriggerHandler.validateOppRecords(Trigger.new);		
		}
		
	}

}