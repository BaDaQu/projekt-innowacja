import { LightningElement, api, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
const FIELDS = ['Medical_Facility__c.Medical_Facility_Name__c', 'Medical_Facility__c.Address__c'];

export default class FacilityMap extends LightningElement {
    @api facilityId;

    mapMarkers = [];
    center = {};
    error;

    @wire(getRecord, { recordId: '$recordId', fields: FIELDS })
    loadFacilityLocation({ error, data }) {
        if (data) {
            this.mapMarkers = [
                {
                    location: {
                        Street: data.fields.Street.value,
                        City: data.fields.City.value,
                        Country: data.fields.Country.value,
                },
                    title: data.fields.Medical_Facility_Name__c.value,
                }
            ];
            this.center = { location: { Street: data.fields.Street, City: data.fields.City, Country: data.fields.Country }, };
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.mapMarkers = [];
            this.center = {};
        }
    }
}