public class DemoClass 
{
    //Integer myNum = 'I am happy !!';  compilation error: Illegal assignment from String to Integer
    Static Integer myNum;
    class MyInnerClass{
        
    }
    class MyClass{
    }
    
    
    public void nonStaticMethod()
    {system.debug(String.valueOf(myNum));
     String myName = String.valueOf(myNum);
     myName.toUppercase();
     
        //writeMyCode();
        
    }
    
    public static void writeMyCode()
    {
        
        String myString = 'Hi';
        MyString = '   ';
        myString = null;
        /*
         * true as value is not assigned to variable and its defaulted to null
         */ 
        System.debug('isEmpty '+String.isEmpty(myString));
        System.debug('isEmpty '+String.isBlank(myString));  
        
        /*
         * Collections in apex
         */ 
        Set<Account> setAccounts = new Set<Account>();
        Account accRec = new Account(Name='ABC',Rating='Hot');
        setAccounts.add(accRec);
        setAccounts.add(new Account(Name='ABC',Rating='Hot',AccountSource='Web'));
        system.debug('Size of Set '+setAccounts.size());  
        system.debug(setAccounts);
        
        Account accRec3 = new Account(Name='TCS',Rating='Hot');
        setAccounts.add(accRec3);
        system.debug(setAccounts);
        setAccounts.add(null);
        system.debug(setAccounts);
        system.debug(setAccounts.size());
        
        Set<Account> accountSet = new Set<Account>([Select Id from Account where Name='Acme Inc']);
        system.debug(accountSet);
        for(Account acc : setAccounts)
        {
          system.debug('Account in Set '+acc);
        }
        system.debug(accountSet.size());
        //Set<Account> accSet =[Select Id from Account];
        
        Set<Account> accSet = new Set<Account>();
        accSet.size();
        
        Map<Integer,Account> accMap = new Map<Integer,Account>{1=>new Account(Name='TCS')};
            Map<Integer,Account> accMap1 = new Map<Integer,Account>{};
			system.debug(accMap1.equals(accMap)) ; 
        
        final Decimal PI = 3.14;
		Id myRecId = '001J400000LouwxIAB';        
        
        Integer[] myInt = new Integer[]{1,2,3};
            for(Integer iterator : myInt)
        {
			                
            }
            
        
       	
	}

}