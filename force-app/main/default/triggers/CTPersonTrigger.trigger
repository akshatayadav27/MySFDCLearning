/*  Create Apex Trigger for Person object. 
 *  > The trigger should accept all events. 
 *  > Make sure the person's health status is Green while inserting record 
 *  > Generate a unique token for the person when a new record is inserted. 
 *  > When health status updates, update the "Status_Update_Date__c" date field.
 * 
 *  2nd Problem:
 *  If a person's Health Status changes Update the Red Score and Status of all the locations they visited in last 10 days 
 *  If a person's Health Status updates to Red 
 *  • Mark all people "Cohabitants" Orange - Except the Red and Orange ones --> Get all the cohabitants first 
 *  • Mark all primary contacts Orange - Except the Red and Orange ones 
 *  • Mark all people "Neighbours" Yellow - Except the Red, Orange and Yellow ones 
 *  • Mark all secondary contacts Yellow - Except the Red and Orange ones Update the Red Score and Status of all the 
 *    locations they visited in last 10 days
 *   Here we are modifying other person records based on the health status of one person. Since we are not talking about the same record 
 *   we are going to use after update event here 
 */ 

trigger CTPersonTrigger on Person__c (before insert,after insert,before update,after update,before delete,after delete,after undelete) 
{
    switch on Trigger.operationType
    {
        when BEFORE_INSERT
        {
            CTPersonTriggerHandler.beforeInsertHandler(Trigger.new);
        }
        when AFTER_INSERT{}
        when BEFORE_UPDATE
        {
            CTPersonTriggerHandler.beforeUpdateHandler(Trigger.new, Trigger.oldMap);
        }
        when AFTER_UPDATE
        {
            CTPersonTriggerHandler.afterUpdateHandler(Trigger.new, Trigger.oldMap);
        }
        when BEFORE_DELETE{}
        when AFTER_DELETE{}
        when AFTER_UNDELETE{}
    }
}