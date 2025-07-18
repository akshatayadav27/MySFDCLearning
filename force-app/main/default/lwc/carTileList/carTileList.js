import { LightningElement, wire } from 'lwc';
import getCars from '@salesforce/apex/CarController.getCars'

//import Message Channel
import { subscribe, MessageContext,publish,unsubscribe } from 'lightning/messageService';
import CARS_FILTERED_MESSAGE from '@salesforce/messageChannel/CarsFiltered__c'
import CAR_SELECTED_MESSAGE from '@salesforce/messageChannel/CarSelected__c'

export default class CarTileList extends LightningElement {

    cars=[]
    error
    filters = {}
    carFilterSubscription

    
    //Load context for LMS
    @wire(MessageContext)
    messageContext

    @wire( getCars, {filters: '$filters'} )
    wired_getCars({data,error}){
        if(data){
            this.cars  = data
            console.log(data)
        }
        if(error){
            this.error = error
            console.error(error)
        }
    }

    //subscribe the message
    connectedCallback(){
        this.subscribeHandler()
    }

    subscribeHandler(){
        this.carFilterSubscription = subscribe(this.messageContext,
                  CARS_FILTERED_MESSAGE, 
                  (message)=>this.handleFilterChanges(message)
                 )
    }

    handleFilterChanges(message){
        console.log(message.filters)
        this.filters = {...message.filters}
    }

    handleCarSelected(event){
        publish(this.messageContext,CAR_SELECTED_MESSAGE,{carId:event.detail})
    }

    disconnectedCallback(){
        unsubscribe(this.carFilterSubscription);
        this.carFilterSubscription = null;
    }
}