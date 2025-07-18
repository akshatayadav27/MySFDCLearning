/* Write below functions in CPeopleTracing Controller Class: 
 * • getTraces (String recordld) Query People Tracing records matching "recordld" value Sort 
 * by "Contact Date" in descending order Return List of People Tracing records back to caller 
 * • checkDuplicates (List<People_Tracing-_c> peopleTraces) Query existing records from People Tracing object Find duplicate 
 * records by matching peopletraces list 
 * and existing records Return List of duplicate People Tracing records back to caller
 */ 

public class CTPeopleTracingController {
    
    public static People_Tracing__c getTraces(String personId)
    {
        return [ SELECT Id, Contact_Date__c, Contact_Type__c, Person_1__c, 
                Person_2__c, Name,Person_1__r.Health_Status__c,
                Person_1__r.Token__c,Person_2__r.Health_Status__c,Person_2__r.Token__c 
                FROM People_Tracing__c 
                WHERE Person_1__c =:personId OR Person_2__c =:personId 
                ORDER BY Contact_Date__c DESC];
            
    }
        
    public static List<People_Tracing__c> checkDuplicates(List<People_Tracing__c> peopleTraces)
    {
        
        List<People_Tracing__c> peopleTracingRecords = new List<People_Tracing__c>();
        
        /* Form the list of existing People_Tracing__c records without containing the Ids so that 
         * we can use contains or indexOf methods of List class to check for person_1 and person_2 Ids
         */ 
        for( People_Tracing__c iterator : [ SELECT Person_1__c, Person_2__c FROM People_Tracing__c ] )
        {
         	peopleTracingRecords.add( new People_Tracing__c(Person_1__c=iterator.Person_1__c, Person_2__c=iterator.Person_2__c) );
        }
        
        List<People_Tracing__c> duplicateTraces = new List<People_Tracing__c>();
        
        /* Iterate on the new list of records peopleTraces to find duplicates and return the duplicate records from peopleTraces
         */ 
        for(People_Tracing__c iterator : peopleTraces )
        {
            if( peopleTracingRecords.contains( new People_Tracing__c(Person_1__c=iterator.Person_1__c, Person_2__c=iterator.Person_2__c) ) ||
                peopleTracingRecords.contains( new People_Tracing__c(Person_1__c=iterator.Person_2__c, Person_2__c=iterator.Person_1__c) ) )
            {
                duplicateTraces.add(iterator);
            }
        }
        return !duplicateTraces.isEmpty() ? duplicateTraces : null;
    }

}