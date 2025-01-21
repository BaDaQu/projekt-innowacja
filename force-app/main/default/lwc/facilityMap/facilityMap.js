import { LightningElement, api, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';

const FIELDS = ['Medical_Facility__c.Facility_GeoLocation__Latitude__s', 'Medical_Facility__c.Facility_GeoLocation__Longitude__s'];

export default class FacilityMap extends LightningElement {
    @api facilityId;

    mapMarkers = [];
    center = {};
    error;

    @wire(getRecord, { recordId: '$recordId', fields: FIELDS })
    loadFacilityLocation({ error, data }) {
        if (data) {
            const latitude = data.fields.Facility_GeoLocation__Latitude__s.value;
            const longitude = data.fields.Facility_GeoLocation__Longitude__s.value;

            this.mapMarkers = [
                {
                    location: { Latitude: latitude, Longitude: longitude },
                    title: 'Medical Facility',
                    description: 'Here is the facility location.'
                }
            ];
            this.center = { Latitude: latitude, Longitude: longitude };
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.mapMarkers = [];
            this.center = {};
        }
    }
}