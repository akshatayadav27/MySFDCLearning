/* Create a method "getToken)" in CTPersonController class. 
 * This method should Accept a String parameter (Mobile No.) Generate a secure token using MD5 hashing Return the secure token back to caller
 * Write below functions in CTPersonController Class: 
 * • getRecentHealthChanges () Query Person records /all fields). Limit the result to 100. Sort by "Status Update Date" in descending order 
 * Return List of Person records back to caller 
 * • searchPeople (String searchTerm) Query Person records lall fields' where either "Name". "Mobile" or "Token" matches the search term. 
 * Sort by "Status Update Date" in descending order Return List of Person records back to caller 
 * • getPersonByld (String personld) Query a Person record lall fields/ where. ne "personld" parameter value Return the Person record back to caller
 */ 
public class CTPersonController {
    
    /* This method is used to generate a unique token based on the MD5 algorithm
     */
    public static String getToken(String mobileNo)
    {
        Blob hash = Crypto.generateDigest('MD5',Blob.valueOf(mobileNo));
        
        // Get the string value of Hash Blob
        return EncodingUtil.base64Encode(hash);
    }
    
    /* Write below functions in CTPersonController Class: 
     * • getHealthStatusCount) 
     * • Query Person records to find Number of People in each Health Status Build a Map<String, Integer› 
     * to map count of people with each status Return the Map back to caller
     * 
     */ 
    
    public static List<Person__c> getRecentHealthChanges()
    {
        return [SELECT Id,Name,Token__c,Status_Update_Date__c,Health_Status__c,Mobile__c 
                FROM Person__c ORDER BY Status_Update_Date__c DESC NULLS LAST LIMIT 100];
    }
    
    public static List<Person__c> searchPeople(String searchTerm)
    {
        Map<String,Object> bindVariables = new Map<String,Object>{ 'Name'   => searchTerm + '%',
                                                                   'Mobile' => searchTerm + '%',
                                                                   'Token'  => searchTerm + '%'
            													  };
        List<Person__c> personsList = Database.queryWithBinds( 'SELECT Id,Name,Token__c,Status_Update_Date__c,Health_Status__c,Mobile__c'
                                                               + ' FROM Person__c WHERE Name like :Name OR Mobile__c like :Mobile'
                                                               + ' OR Token__c like :Token ORDER BY Status_Update_Date__c DESC NULLS LAST',
                                                               bindVariables,
                                                               AccessLevel.USER_MODE);
        return personsList;
    }     
    
    public static Person__c getPersonById(String personId)
    {
        List<Person__c> peopleList = [ SELECT Id,Name,Token__c,Status_Update_Date__c,Health_Status__c,Mobile__c 
                                      FROM Person__c WHERE Id=:personId ];
        return !peopleList.isEmpty() ?  peopleList[0] : null;
    }
    
    public static Map<String,Integer> getHealthStatusCount(){
        Map<String,Integer> statusCount = new Map<String,Integer>();
        for( AggregateResult iterator : [ SELECT Count(Id) StatusCount, Health_Status__c 
                                          FROM Person__c GROUP BY Health_Status__c ] )
        {
            statusCount.put( String.valueOf(iterator.get('Health_Status__c')),Integer.valueOf(iterator.get('StatusCount')) );
        }
        return statusCount; 
    }
    
    /*  Mark all people "Cohabitants" Orange - Except the Red and Orange ones --> Get all the cohabitants first 
     */ 
    
    public static Set<Id> getCohabitants(Set<Id> personIds, Set<Id> processedRecords)
    {
        Map<String,Object> params = new Map<String,Object>{ 'personIds'      => personIds,
            												'healthStatuses' => new List<String>{'Green','Yellow'},
                                                            'contactType'    => 'Cohabitant'
                                                          };
        List<People_Tracing__c> traces = Database.queryWithBinds
                                        (  'SELECT Id,Person_1__c, Person_2__c FROM People_Tracing__c'
                                           + ' WHERE (Person_1__c IN :personIds OR Person_2__c IN :personIds)'
                                           + ' AND Contact_Type__c =:contactType'
                                           + ' AND (Person_1__r.Health_Status__c IN :healthStatuses OR Person_2__r.Health_Status__c IN :healthStatuses)',
                                           params,
                                           AccessLevel.USER_MODE);         
        
        /* Skip the original person records (Set<Id> personIds) for whom we are finding the Cohabitants
         */ 
        
        Set<Id> cohabitants = new Set<Id>();
        for(People_Tracing__c iterator : traces)
        {
            if( !processedRecords.contains(iterator.Person_1__c) )
            {
                cohabitants.add(iterator.Person_1__c);
                processedRecords.add(iterator.Person_1__c);
            }
            if( !processedRecords.contains(iterator.Person_2__c) )
            {
                cohabitants.add(iterator.Person_2__c);
                processedRecords.add(iterator.Person_2__c);
            }
        }
        return cohabitants;
    }   
    
    /* Mark all people "Neighbours" Yellow - Except the Red, Orange and Yellow ones 
     */
    
    public static Set<Id> getNeighbours(Set<Id> personIds, Set<Id> processedRecords)
    {
        Map<String,Object> params = new Map<String,Object>{ 'personIds'      => personIds,
            												'healthStatus'   => 'Green',
                                                            'contactType'    => 'Neighbour'
                                                          };
        List<People_Tracing__c> traces = Database.queryWithBinds
                                        (  'SELECT Id,Person_1__c, Person_2__c FROM People_Tracing__c'
                                           + ' WHERE (Person_1__c IN :personIds OR Person_2__c IN :personIds)'
                                           + ' AND Contact_Type__c =:contactType'
                                           + ' AND (Person_1__r.Health_Status__c =:healthStatus OR Person_2__r.Health_Status__c =:healthStatus)',
                                           params,
                                           AccessLevel.USER_MODE);         
        
        /* Skip the original person records (Set<Id> personIds) for whom we are finding the Neighbours
         */ 
        
        Set<Id> neighbours = new Set<Id>();
        for(People_Tracing__c iterator : traces)
        {
            if( !processedRecords.contains(iterator.Person_1__c) )
            {
                neighbours.add(iterator.Person_1__c);
                processedRecords.add(iterator.Person_1__c);
            }
            if( !processedRecords.contains(iterator.Person_2__c) )
            {
                neighbours.add(iterator.Person_2__c);
                processedRecords.add(iterator.Person_2__c);
            }
        }
        return neighbours;
    }   
    
    /* Mark all primary contacts Orange - Except the Red and Orange ones 
     */ 
    
    public static Set<Id> getPrimaryContacts(Set<Id> personIds, Set<Id> processedRecords)
    {
        Map<String,Object> params = new Map<String,Object>{ 'personIds'      => personIds,
            												'healthStatuses' => new List<String>{'Green','Yellow'},
                                                            'contactType'    => 'Other'
                                                          };
        List<People_Tracing__c> traces = Database.queryWithBinds
                                        (  'SELECT Id,Person_1__c, Person_2__c FROM People_Tracing__c'
                                           + ' WHERE (Person_1__c IN :personIds OR Person_2__c IN :personIds)'
                                           + ' AND Contact_Type__c =:contactType'
                                           + ' AND (Person_1__r.Health_Status__c IN :healthStatuses OR Person_2__r.Health_Status__c IN :healthStatuses)'
                                           + ' AND Contact_Date__c =LAST_N_DAYS:10',
                                           params,
                                           AccessLevel.USER_MODE);         
        
        /* Skip the original person records (Set<Id> personIds) for whom we are finding the Neighbours
         */ 
        
        Set<Id> primaryContacts = new Set<Id>();
        for(People_Tracing__c iterator : traces)
        {
            if( !processedRecords.contains(iterator.Person_1__c) )
            {
                primaryContacts.add(iterator.Person_1__c);
                processedRecords.add(iterator.Person_1__c);
            }
            if( !processedRecords.contains(iterator.Person_2__c) )
            {
                primaryContacts.add(iterator.Person_2__c);
                processedRecords.add(iterator.Person_2__c);
            }
        }
        return primaryContacts;
    }   
    
    /* Mark all secondary contacts Yellow - Except the Red and Orange ones Update the Red Score and Status of all the 
     */ 
    
    public static Set<Id> getSecondaryContacts(Set<Id> primaryContacts, Set<Id> processedRecords)
    {
        Map<String,Object> params = new Map<String,Object>{ 'primaryContacts'  => primaryContacts,
            												'healthStatuses'   => new List<String>{'Green','Yellow'},
                                                            'contactType'      => 'Other'
                                                          };
        List<People_Tracing__c> traces = Database.queryWithBinds
                                        (  'SELECT Id,Person_1__c, Person_2__c FROM People_Tracing__c'
                                           + ' WHERE (Person_1__c IN :primaryContacts OR Person_2__c IN :primaryContacts)'
                                           + ' AND Contact_Type__c =:contactType'
                                           + ' AND (Person_1__r.Health_Status__c IN :healthStatuses OR Person_2__r.Health_Status__c IN :healthStatuses)'
                                           + ' AND Contact_Date__c =LAST_N_DAYS:10',
                                           params,
                                           AccessLevel.USER_MODE);         
        
        /* Skip the original person records (Set<Id> personIds) for whom we are finding the Neighbours
         */ 
        
        Set<Id> secondaryContacts = new Set<Id>();
        for(People_Tracing__c iterator : traces)
        {
            if( !processedRecords.contains(iterator.Person_1__c) )
            {
                secondaryContacts.add(iterator.Person_1__c);
                processedRecords.add(iterator.Person_1__c);
            }
            if( !processedRecords.contains(iterator.Person_2__c) )
            {
                secondaryContacts.add(iterator.Person_2__c);
                processedRecords.add(iterator.Person_2__c);
            }
        }
        return secondaryContacts;
    }   
    
}