public class Challenge_Two 
{
    
    public static void splitBill()
    {
        Integer sliceRossOrdered = 3;
        Integer sliceChandlerOrdered = 1;
        Integer sliceJoeyOrdered = 4;
        
        Integer totalSliceOrdered = ( sliceRossOrdered + sliceChandlerOrdered + sliceJoeyOrdered ) ;
        
        Integer totalBill = totalSliceOrdered * 6;
        Integer splitBill = ( totalBill/3 );
        
        system.debug('Split Bill : '+splitBill);
            
    }
}