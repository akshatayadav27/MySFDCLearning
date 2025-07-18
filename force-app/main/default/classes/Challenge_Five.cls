public class Challenge_Five 
{
    public static void fibonacciSeries()
    {
      
        Integer currentValue;
        Integer previousValue = 1;
        Integer beforePreviousValue = 0;
        Integer counter = 0;
        system.debug(beforePreviousValue);
        system.debug(previousValue);
        while( counter < 18 )
        {
            currentValue =  beforePreviousValue + previousValue;
            system.debug(currentValue);
            
             
            beforePreviousValue = previousValue;
            previousValue = currentValue;
           
            counter++;
        }
    }
}