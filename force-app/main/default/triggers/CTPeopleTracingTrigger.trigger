trigger CTPeopleTracingTrigger on People_Tracing__c (before insert,after insert) 
{
    switch on Trigger.operationType
    {
        when BEFORE_INSERT 
        {
            CTPeopleTracingTriggerHandler.beforeInsertHandler(Trigger.new);
        }
        when AFTER_INSERT 
        {
            
        }
    }
}