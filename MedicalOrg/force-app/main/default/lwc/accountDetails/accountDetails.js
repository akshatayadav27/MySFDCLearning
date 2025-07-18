import { api, LightningElement,wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import getAccountDetails from '@salesforce/apex/AccountDetailsService.getAccountDetails';
const FIELDS = ["Interaction__c.Physician__c"];
export default class AccountDetails extends LightningElement 
{
    @api recordId;
    data;
    error;

    //Get details of current record
    @wire(getRecord, { recordId: '$recordId', fields: FIELDS }) 
    interactionRecord;

    // Pass the physicianId to Apex Method and get Account details
    @wire(getAccountDetails, { physicianId: '$interactionRecord.data.fields.Physician__c.value' })
    wiredRecordMethod({ error, data }) 
    {
        console.log('Hello' + JSON.stringify(data));
        if (data) 
            {
            this.data = data;
        } else if (error) 
            {
            this.error = error;
        }
    }
}