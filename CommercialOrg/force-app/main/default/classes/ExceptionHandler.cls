public class ExceptionHandler {
    
    /* Generic Method to log exceptions
    */
    
    public static void logException(String className,String methodName, Integer lineNumber, String exceptionMessage)
    {
        Exception_Log__c exceptionLog = new Exception_Log__c (Class_Name__c=className,
                                                             Method_Name__c=methodName,
                                                             Line_Number__c=lineNumber,
                                                             Exception_Message__c=exceptionMessage);
        insert exceptionLog;   
    }

}