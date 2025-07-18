/*Write below functions in CLocationTracingController Class: 
 * • getVisitors (String locationld) 
 * Query Location Tracing records matching "locationld" value Sort by "Visit Date" in descending order Return List of Location 
 * Tracing records back to caller 
 * • getLocationsByPersonIds (Set<ld> personlds) Query Location Tracing records where Person matches 
 * the "personlds" Only retrieve records where Visit Date is in last 10 days 
 * • Return List of Location Tracing records back to caller
 * • getLocationsByLocationids (Set<ld> locationids) Query Location Tracing records where 
 * Location matches the "locationids" and Person health is "Green" Only retrieve records where Visit Date is in last 10 days
 * Return List of Location facing records back to caller 
 * 
 */ 
public class CTLocationTracingController {
    
    public static List<Location_Tracing__c> getVisitors(String locationId){
        return [ SELECT Id, Name, Person__c, Location__c, Visit_Date__c FROM Location_Tracing__c WHERE Id =:locationId ORDER BY Visit_Date__c DESC NULLS LAST ];
    }
    
    public static List<Location_Tracing__c> getLocationsByPersonIds(Set<Id> personIds){
        return [ SELECT Id, Name, Person__c, Location__c, Visit_Date__c FROM Location_Tracing__c WHERE Person__r.Id IN :personIds AND Visit_Date__c =LAST_N_DAYS:10 ];
    }
    
    public static List<Location_Tracing__c> getLocationsByLocationIds(Set<Id> locationIds){
        return [ SELECT Id, Name, Person__c, Location__c, Visit_Date__c FROM Location_Tracing__c WHERE Location__r.Id IN :locationIds AND Person__r.Health_Status__c = 'Green' ];
    }
    
    /* Write below functions in CLocationTracingController Class: 
     * • checkDuplicates (List<Location_Tracing-_c> locationTraces) 
     * • Query existing records from Location Tracing object Find duplicate records by matching locationTraces list 
     * and existing records Return List of duplicate Location Tracing records back to caller
     */ 
    
    public static List<Location_Tracing__c> checkDuplicates(List<Location_Tracing__c> locationTraces){
        
        List<Location_Tracing__c> locationTracesRecords = new List<Location_Tracing__c>();
        
        
        /* Form the list of existing Location_Tracing__c records without containing the Ids so that 
         * we can use contains or indexOf methods of List class to check for Location__c and Person__c Ids
         */ 
        
        for(Location_Tracing__c iterator : [ SELECT Person__c, Location__c FROM Location_Tracing__c ])
        {
            locationTracesRecords.add( new Location_Tracing__c(Location__c=iterator.Location__c,Person__c=iterator.Person__c) );
        }
        
        List<Location_Tracing__c> locationTracesDuplicates = new List<Location_Tracing__c>();
        for( Location_Tracing__c iterator : locationTraces )
        {
            /*
             * The query will return Id field by default so create new object of location tracing with person and location fields 
             * and use contains or indexOf methods of List class to find the duplicate records
             */
            Location_Tracing__c trace = new Location_Tracing__c(Location__c=iterator.Location__c,Person__c=iterator.Person__c);
            
            /* Using index of to find the index of specified element
            if( locationTracesRecords.indexOf(trace) != -1 )
            {
            locationTracesDuplicates.add(iterator);
            }
            */
            
            if(locationTracesRecords.contains(trace))
            {
                locationTracesDuplicates.add(iterator);
            }
        }
        return locationTracesDuplicates;
    }
}