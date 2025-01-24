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
            console.log('dzialam !!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
            console.log('dzialam !!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
            const address = data.fields.Address__c.value;
            const facilityName = data.fields.Medical_Facility_Name__c.value;
            this.mapMarkers = [
                {
                    location: {
                        Street: address.street,
                        City: address.city,
                        State: address.state,
                        PostalCode: address.postalCode,
                        Country: address.country,
                    },
                    title: facilityName,
                }
            ];
            this.center = {
                    location: {
                        Street: address.street,
                        City: address.city,
                        State: address.state,
                        PostalCode: address.postalCode,
                        Country: address.country,
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
