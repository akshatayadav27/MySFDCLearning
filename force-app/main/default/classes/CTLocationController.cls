/* Write below functions in CLocationController Class: 
 * • getRecentStatusChanges) Query Location records /all fields). 
 * Limit the result to 100. Sort by "Status Update Date" in descending order Return List of Location records back to caller 
 * • searchLocations (String searchTerm) Query Location records lall fields/ where either "Name", "PinCode" or "Address" matches the search term. 
 * Sort by "Status Update Date" in descending order 
 * Return List of Location records back to caller getLocationByld (String  locationld) Query a Location record lall fields) 
 * where Id matches the "locationd" parameter value Return the Location record back to caller
 * 
 */

public class CTLocationController {
    
    public static List<Location__c> getRecentStatusChanges(){
        return [ SELECT Id, Name, Address__c, Pincode__c, Red_Score__c, Status_Update_Date__c, Status__c 
                FROM Location__c ORDER BY Status_Update_Date__c DESC NULLS LAST LIMIT 100 ];
    }
    
    public static List<Location__c> searchLocations(String searchTerm){
        Map<String,Object> params = new Map<String,Object>{ 'Name'    => searchTerm + '%',
                                                            'Pincode' => searchTerm + '%',
                                                            'Address' => searchTerm + '%'
            											   };
        List<Location__c> locationsList = Database.queryWithBinds('SELECT Id, Name, Address__c, Pincode__c, Red_Score__c, Status_Update_Date__c, Status__c FROM Location__c WHERE Name LIKE :Name OR Pincode__c LIKE :Pincode OR Address__c LIKE :Address ORDER BY Status_Update_Date__c DESC NULLS LAST LIMIT 100',
                                                                 params,
                                                                 AccessLevel.USER_MODE);
        return locationsList;
    }
    
    public static Location__c getLocationById(String locationId)
    {
        List<Location__c> locationsList = [ SELECT Id, Name, Address__c, Pincode__c, Red_Score__c, 
                                           Status_Update_Date__c, Status__c FROM Location__c WHERE Id=:locationId];
        return !locationsList.isEmpty() ? locationsList[0] : null ;
    }
    
    
    /* Write below functions in CLocationController Class: 
     * • getStatusCountO Query Location records to find Number of Locations in each Health Status Build a Map<String, Integer› 
     * to map count of location with each status Return the Map back to caller 
     */
    
    public static Map<String,Integer> getStatusCount()
    {
        Map<String,Integer> statusCount = new Map<String,Integer>();
        for( AggregateResult iterator : [ SELECT Count(Id) total, Status__c 
                                          FROM Location__c GROUP BY Status__c ] )
        {
            statusCount.put((String)iterator.get('Status__c'),(Integer)iterator.get('total'));
        }
        return statusCount;
    }
    
    /* If a person's Health Status changes Update the Red Score and Status of all the locations they visited in last 10 days 
     */ 
    public static void updateRedScore(Set<Id> locationIds)
    {
        List<Location__c> locationsToUpdate = new List<Location__c>();
        AggregateResult[] redPeopleCountPerLocation = [ SELECT Location__c, Count(Id) total FROM Location_Tracing__c 
                                                        WHERE Location__c IN:locationIds AND 
                                                        Person__r.Health_Status__c = 'Red' 
                                                        AND Visit_Date__c=LAST_N_DAYS:10 
                                                        GROUP BY Location__c];
        
        for(AggregateResult iterator : redPeopleCountPerLocation)
        {
            Integer redScore = (Integer)iterator.get('total');
            locationsToUpdate.add(new Location__c( Id=(String)iterator.get('Location__c'), 
                                                   Red_Score__c = redScore, 
                                                   Status__c = getStatus(redScore)
                                                  )
                                 );
        }
        
        if( !locationsToUpdate.isEmpty() )
        {
            update locationsToUpdate;
        }
      
    }
    
    private static String getStatus(Integer redScore)
    {
        if( redScore == 0 )
        {
            return 'Green';
        }
        else if( redScore <=5 )
        {
            return 'Yellow';
        }
        else if( redScore <=10 )
        {
            return 'Orange';
        }
        else
        {
            return 'Red';
        }
    }
    
}