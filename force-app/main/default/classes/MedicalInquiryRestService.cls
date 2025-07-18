@RestResource(urlMapping='/MedicalInquiry/*')
global class MedicalInquiryRestService 
{
    
    /* Web Service : GET
    * Retrieves the Medical Inquires records
    */
    @HTTPGet
    global static List<Medical_Inquiry__c> getMedicalInquires()
    {
        return [select Id,Name,Products__c,Physician__c,
                Questions__c, 
                Preferred_Response_Channel__c from Medical_Inquiry__c where Status__c != 'Closed'];   
    }
    
    /* Web Service : PUT
    * To update the status of Medical Inquires records
    */
    @HTTPPut
    global static void bulkUpdateMedicalInquiries() {
        try {
            
            //Get the request Body and convert to string
            String requestBody = RestContext.request.requestBody.toString();
            
            // deserialize the request Body
            List<Object> medicalInquiresList = (List<Object>) JSON.deserializeUntyped(requestBody);
            
            //New list for medical Inquires To Update
            List<Medical_Inquiry__c> medicalInquiresToUpdate = new List<Medical_Inquiry__c>();
            
            for(Object iterator : medicalInquiresList)
            {
                if( iterator instanceOf Map<String,Object> )
                {
                    Map<String,Object> medicalInquiry = (Map<String,Object>) iterator;
                    
                    Medical_Inquiry__c medicalInquiryRec = new Medical_Inquiry__c( 
                        Id= (String)medicalInquiry.get('Medical_Inquiry__c'),
                        Status__c = (String)medicalInquiry.get('Status__c'));
                    
                    medicalInquiresToUpdate.add(medicalInquiryRec);     
                }
            }
            
            Database.saveResult[] resultList = Database.update(medicalInquiresToUpdate,false);
            
            //Check for Exceptions
            List<Exception_Log__c> exceptionList = new List<Exception_Log__c>();
            
            for(Database.saveResult result : resultList)
            {
                for( Database.Error error : result.getErrors() )
                {
                    Exception_Log__c exceptionLog = new Exception_Log__c(Class_Name__c='MedicalInquiryRestService',
                                                                          Method_Name__c='bulkUpdateMedicalInquiries',
                                                                          Line_Number__c=49,
                                                                          Exception_Message__c=String.valueOf(error));
                    exceptionList.add(exceptionLog);
                    
                }   
            }
            
            //Log Exceptions
            insert exceptionList;
            
    } catch (Exception excp) {   
        ExceptionHandler.logException('MedicalInquiryRestService',
                                      'bulkUpdateMedicalInquiries',
                                       excp.getLineNumber(),
                                       excp.getMessage());
    }
 }
}