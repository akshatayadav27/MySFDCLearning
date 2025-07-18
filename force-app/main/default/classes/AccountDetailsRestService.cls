@RestResource(urlMapping='/AccountDetails/*')
global class AccountDetailsRestService 
{
    /* Web Service : GET
    * Retrieves the Account(Physician) Details
    */
    
    @HTTPGet
    global static Account getAccountDetails()
    {
        //Get the request
        RestRequest req = RestContext.request; 
        
        // Extract the Physician Id from the URL
        String accountId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        
        return [select Id,Name,Phone from Account where Id =:accountId ];   
    }
}