public class Fitness {
    
    public Decimal calculateBMI(Decimal bodyWeightKg, Decimal heightInMeter){
        return bodyWeightKg/(heightInMeter*heightInMeter);        
    }
    
    public Decimal calculatePace(Decimal distanceInKm, Integer timeInMinutes){
        return (distanceInKm*60)/timeInMinutes;
    }
}