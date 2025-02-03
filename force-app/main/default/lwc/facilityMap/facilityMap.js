import { LightningElement, api, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
const FIELD = ['Medical_Facility__c.Medical_Facility_Name__c'];
import getAddress from '@salesforce/apex/FacilityMapHelper.getAddress';



export default class FacilityMap extends LightningElement {
    @api recordId;
    Address;
    mapMarkers = [];
    center = {};
    error;

    @wire(getRecord, { recordId: '$recordId', fields: FIELD })
    async loadFacilityLocation({ error, data }) {
        if (data) {
            const facilityName = data.fields.Medical_Facility_Name__c;
            const res =await getAddress({name: data.fields.Medical_Facility_Name__c.value});
            this.Address = JSON.parse(res);
            console.log('adres:',res);
            this.mapMarkers = [
                {
                    location: {
                        City: this.Address.city,
                        Country: this.Address.country,
                        PostalCode: this.Address.postalCode,
                        Street: this.Address.street,
                    },
                    value: 'location001',
                    title: facilityName.value,
                }
            ];
            this.center = {
                    location: {
                        City: this.Address.city,
                        Country: this.Address.country,
                        PostalCode: this.Address.postalCode,
                        Street: this.Address.street,
                }
            };
            this.error = undefined;
        } else if (error) {
            console.log('!!!!!!!nie dzialam!!!!!!!!!!!!!!!', error);
            this.error = error;
            this.mapMarkers = [];
            this.center = {};
        }
    }
}