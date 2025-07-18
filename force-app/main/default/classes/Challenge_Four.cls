public class Challenge_Four 
{
    public static void fizzBuzz()
    {
        Integer myNum = 1;
        do
        {
            if( Math.mod(myNum,3) == 0 && Math.mod(myNum,5) == 0 ) 
            {
                system.debug('fizzbuzz');
            }else if( Math.mod(myNum,3) == 0 )
            {
                system.debug('fizz');
            }else if( Math.mod(myNum,5) == 0 )
            {
                system.debug('buzz');
            }else
            {
                system.debug(myNum);
            }
            myNum++;  
        }while(myNum<=100);
    }
}