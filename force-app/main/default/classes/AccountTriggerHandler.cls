public class AccountTriggerHandler {
    
    public static void updateAccountRecords(List<Account> accountRecords)
    {
        for(Account iterator : accountRecords)
        {
            iterator.Rating = 'Hot';
            iterator.Phone='040-3245';  
        }
    }
    
    public static void createRelatedRecords(Map<Id,Account> accRecords)
	{
		List<Opportunity> oppsToInsert = new List<Opportunity>();
		for(Account iterator : accRecords.values())
		{
			if(iterator.Rating == 'Hot')
			{
				Opportunity oppRec = new Opportunity(Name=iterator.Name+ ' Opportunity',CloseDate=System.today()+30,StageName='Qualification',AccountId=iterator.Id);
				oppsToInsert.add(oppRec);			
			}
			
		}
		insert oppsToInsert;		
	}

}