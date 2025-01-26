import { LightningElement, api, wire } from 'lwc';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import { getRelatedListRecords } from 'lightning/uiRelatedListApi';
import FACILITY_HOURS_OBJECT from '@salesforce/schema/Facility_Hours__c';
import { NavigationMixin } from 'lightning/navigation';

const COLUMNS = [
    { label: 'Day of Week', fieldName: 'Day_of_Week__c', type: 'text' },
    { label: 'Opening Time', fieldName: 'Opening_Time__c', type: 'text' },
    { label: 'Closing Time', fieldName: 'Closing_Time__c', type: 'text' }
];

export default class FacilityHoursComponent extends NavigationMixin(LightningElement) {
    @api recordId;
    @api objectApiName;
    facilityHoursData;
    columns = COLUMNS;

    @wire(getObjectInfo, { objectApiName: FACILITY_HOURS_OBJECT })
        objectInfo;


      @wire(getRelatedListRecords, {
        parentRecordId: '$recordId',
        relatedListId: 'Facility_Hours__r',
        fields: [
            'Facility_Hours__c.Id',
            'Facility_Hours__c.Day_of_Week__c',
            'Facility_Hours__c.Opening_Time__c',
            'Facility_Hours__c.Closing_Time__c'
            ]
      })
      wiredFacilityHours({ data, error }) {
          if (data) {
            this.facilityHoursData = data.records.map(record => {
              const openingTime = record.fields.Opening_Time__c.value;
              const closingTime = record.fields.Closing_Time__c.value;

              return {
                  Id: record.fields.Id.value,
                  Day_of_Week__c: record.fields.Day_of_Week__c.value,
                  formattedOpeningTime: this.formatTime(openingTime),
                  formattedClosingTime: this.formatTime(closingTime)
              }
             });
          } else if (error) {
              console.error('Error loading facility hours:', error);
              this.facilityHoursData = null;
          }
      }


      formatTime(timeString) {
          if (!timeString) return '';
           const [hours, minutes] = timeString.split(':');
          return `${hours}:${minutes}`;
    }
}