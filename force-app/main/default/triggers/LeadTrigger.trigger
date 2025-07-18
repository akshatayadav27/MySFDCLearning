trigger LeadTrigger on Lead(before insert,before update)
{
	switch on Trigger.OperationType
	{
		when BEFORE_INSERT,BEFORE_UPDATE
		{
			LeadTriggerHandler.validateLeadRecords(Trigger.new);
		}
        when AFTER_INSERT
		{
			LeadTriggerHandler.shareLeadRecords(Trigger.new);		
		}	
	}
}