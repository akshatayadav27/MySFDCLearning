public class CTDataCleanupSchedule implements Schedulable 
{
    public static final String CRON_EXPRESSION = '0 0 2 * * ?';
    public void execute(SchedulableContext sc)
    {
		CTPeopleTracingDataCleanupBatch batchObj =  new CTPeopleTracingDataCleanupBatch();
        Database.executeBatch(batchObj,2000);
    }
}