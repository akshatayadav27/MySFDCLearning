import { LightningElement, wire } from 'lwc';
import { getObjectInfo, getPicklistValues } from 'lightning/uiObjectInfoApi';
import CAR_OBJECT from '@salesforce/schema/Car__c'
import CATEGORY_FIELD from '@salesforce/schema/Car__c.Category__c'
import MAKE_FIELD from '@salesforce/schema/Car__c.Make__c'

//import Message Channel
import { publish, MessageContext } from 'lightning/messageService';
import CARS_FILTERED_MESSAGE from '@salesforce/messageChannel/CarsFiltered__c'

const CATEGORY_ERROR = 'Error while loading categories'
const MAKETYPE_ERROR = 'Error while loading make type'

export default class CarFilter extends LightningElement {

    timer;
    filters = {
        searchKey: '',
        maxPrice: 999999
    }

    categoryError = CATEGORY_ERROR;
    makeTypeError = MAKETYPE_ERROR


    //Load context for LMS
    @wire(MessageContext)
    messageContext


    //Fetching record type Id
    @wire(getObjectInfo, { objectApiName: CAR_OBJECT })
    carObjectInfo


    //Fetching category picklist values
    @wire(getPicklistValues,
        {
            recordTypeId: '$carObjectInfo.data.defaultRecordTypeId',
            fieldApiName: CATEGORY_FIELD
        }
    ) categories


    //Fetching make picklist values
    @wire(getPicklistValues,
        {
            recordTypeId: '$carObjectInfo.data.defaultRecordTypeId',
            fieldApiName: MAKE_FIELD
        }
    ) makeType


    //Search Key Handler
    handleSearchKeyChange(event) {
        console.log(event.target.value)
        this.filters = {...this.filters,"searchKey":event.target.value} 
        this.sendDataToCarList();
    }

    //Max Price Handler
    handleMaxPriceChange(event) {
        console.log(event.target.value)
        this.filters = {...this.filters,"maxPrice":event.target.value} 
        this.sendDataToCarList();
    }


    //Checkbox Handler
    handleCheckbox(event){

        if(!this.filters.categories)
        {
            const categories = this.categories.data.values.map(item=>item.value)
            const makeType = this.makeType.data.values.map(item=>item.value)
            this.filters = {...this.filters,categories,makeType}
        }
        const {name,value} = event.target.dataset
        
        if(event.target.checked)
        {
            if(!this.filters[name].includes(value)){
                this.filters[name] = {...this.filters[name],value}
            }
        }else{
            this.filters[name] = this.filters[name].filter(item=>item !== value)
        }
        this.sendDataToCarList()
    }

    /* publish the LMS service and this method is called whenever the search key , 
        max price, categories or 
        make type is changed. At this change we will call publish methode and send the filters
        to the car Tile list 
    */
    sendDataToCarList(){
        window.clearTimeout(this.timer)
        this.timer = window.setTimeout( ()=>{
            publish(this.messageContext,CARS_FILTERED_MESSAGE, 
                {filters:this.filters}   
           )
        },400 ) 
    }

}