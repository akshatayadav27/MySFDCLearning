trigger CTLocationTracingTrigger on Location_Tracing__c (before insert,after insert) 
{
    switch on Trigger.operationType
    {
        when BEFORE_INSERT 
        {
            CTLocationTracingTriggerHandler.beforeInsertHandler(Trigger.new);
        }
        when AFTER_INSERT {}
    }
    
}