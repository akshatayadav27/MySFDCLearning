/*/*  Create Apex Trigger for Location__c object. 
 *  > The trigger should accept all events. 
 *  > Make sure the Location status is Green while inserting record 
 *  > When health status updates, update the "Status_Update_Date__c" date field.
 * 
 */ 
trigger CTLocationTrigger on Location__c (before insert,after insert,before update,after update,before delete,after delete,after undelete) 
{
    switch on Trigger.operationType
    {
        when BEFORE_INSERT 
        {
            CTLocationTriggerHandler.beforeInsertHandler(Trigger.new);
        }
        when AFTER_INSERT {}
        when BEFORE_UPDATE 
        {
            CTLocationTriggerHandler.beforeUpdateHandler(Trigger.new, Trigger.oldMap);
        }
        when AFTER_UPDATE 
        {
            CTLocationTriggerHandler.afterUpdateHandler(Trigger.new, Trigger.oldMap);
        }
        when BEFORE_DELETE {}
        when AFTER_DELETE {}
        when AFTER_UNDELETE {}
    }
}