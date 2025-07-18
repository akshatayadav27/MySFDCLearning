trigger ContactTrigger on Contact (before insert,after insert,before update,after update,before delete,after delete,after undelete) 
{
    switch on Trigger.operationType
    {
        when BEFORE_INSERT
        {
            ContactTriggerHandler.beforeInsertHandler(Trigger.new);
        }
        
        when AFTER_INSERT
        {
            ContactTriggerHandler.afterInsertHandler(Trigger.new);
        }
        when BEFORE_UPDATE{}
        
        when AFTER_UPDATE
        {
            ContactTriggerHandler.afterUpdateHandler(Trigger.new,Trigger.oldMap);
        }
        when BEFORE_DELETE{}
        
        when AFTER_DELETE
        {
            ContactTriggerHandler.afterDeleteHandler(Trigger.old);
        }
        when AFTER_UNDELETE
        {
            ContactTriggerHandler.afterUndeleteHandler(Trigger.new);
        }
    }
}