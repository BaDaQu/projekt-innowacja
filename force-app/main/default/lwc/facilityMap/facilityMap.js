import { LightningElement, api, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
const FIELD = ['Medical_Facility__c.Medical_Facility_Name__c'];
import getStreets from '@salesforce/apex/FacilityMapHelper.getStreets';
import getCitys from '@salesforce/apex/FacilityMapHelper.getCitys';
import getCountrys from '@salesforce/apex/FacilityMapHelper.getCountrys';
import getPostalCodes from '@salesforce/apex/FacilityMapHelper.getPostalCodes';



export default class FacilityMap extends LightningElement {
    @api recordId;

    mapMarkers = [];
    center = {};
    error;

    @wire(getRecord, { recordId: '$recordId', fields: FIELD })
    async loadFacilityLocation({ error, data }) {
        if (data) {
            const facilityName = data.fields.Medical_Facility_Name__c;
            const street =await getStreets({name: data.fields.Medical_Facility_Name__c.value});
            const city =await  getCitys({name: data.fields.Medical_Facility_Name__c.value});
            const code =await  getPostalCodes({name: data.fields.Medical_Facility_Name__c.value});
            const country =await  getCountrys({name: data.fields.Medical_Facility_Name__c.value});
            console.log('street: ',street,',city: ',city,',code: ',code,',country: ',country,',facility name: ',facilityName);
            this.mapMarkers = [
                {
                    location: {
                        City: String(city),
                        Country: String(country),
                        PostalCode: String(code),
                        Street: String(street),
                    },
                    value: 'location001',
                    title: facilityName.value,
                }
            ];
            console.log('Full Map Markers:', JSON.stringify(this.mapMarkers, null, 2));
            this.center = {
                    location: {
                        City: String(city),
                        Country: String(country),
                        PostalCode: String(code),
                        Street: String(street),
                }
            };
            console.log('Full Center:', JSON.stringify(this.center, null, 2));

            this.error = undefined;
        } else if (error) {
            console.log('!!!!!!!nie dzialam!!!!!!!!!!!!!!!', error);
            this.error = error;
            this.mapMarkers = [];
            this.center = {};
        }
    }
}