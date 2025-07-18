trigger AccountTrigger on Account (before insert,after insert) 
{
    switch on Trigger.OperationType
    {
        when BEFORE_INSERT
        {
            AccountTriggerHandler.updateAccountRecords(Trigger.new);
        }
        when AFTER_INSERT
        {
            AccountTriggerHandler.createRelatedRecords(Trigger.NewMap);
        } 
    }    
}
/*Review the errors on this page.
* List<Account> accList = new List<Account>();
for (Account iterator : trigger.new)
{
Account acc = new Account();
acc.rating='Hot';
accList.add(iterator);

}
update accList;
* 
accountTrigger: execution of AfterInsert caused by: System.FinalException: Record is read-only Trigger.accountTrigger: line 6, column 1
* 
* 
* 
*/