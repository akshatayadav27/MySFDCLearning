public class LeadTriggerHandler
{
	public static void validateLeadRecords(List<Lead> leadRecords)
	{
		for(Lead iterator : leadRecords)
		{
			if(iterator.LeadSource == 'Web' && String.isBlank(iterator.Email))
			{
				iterator.Email.addError('Email cannot be blank');
			}			
		}
    }
    
    public static void shareLeadRecords(List<Lead> leadRecords)
	{
		List<LeadShare> recordsToShare = new List<LeadShare>();
		
		User userId = [select Id From User where Name = 'Viviane Boudin' Limit 1];
		for(Lead iterator : leadRecords)
		{
			LeadShare shareRec = new LeadShare();
			shareRec.RowCause = 'Manual';
			shareRec.LeadAccessLevel = 'Read';
			shareRec.LeadId = iterator.Id;
			shareRec.UserOrGroupId = userId.Id;	
			
			recordsToShare.add(shareRec);	
		}
		insert recordsToShare;			
	}
}