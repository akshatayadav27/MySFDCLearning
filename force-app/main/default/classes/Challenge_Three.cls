public class Challenge_Three 
{
    public static void findLeapYear()
    {
        Integer leapYear = 1100;
        
        do{
            if (Math.mod(leapYear,4) == 0 )
            {
                if( Math.mod(leapYear,100) == 0 )
                {
                    if( Math.mod(leapYear,400) == 0)
                    {
                        system.debug(leapYear+' leap year');
                    }
                }else
                {
                    system.debug(leapYear+' Its a leap year');
                }
            }
            leapYear++;
            
        }while(leapYear<=2000);
    }
}