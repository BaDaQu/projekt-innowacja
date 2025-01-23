@isTest
public class AppointmentNameTriggerTest {
    @isTest
    static void testTriggerWithAllFieldsPopulated() {
        
        final Id DOCTOR_RECORD_TYPE_ID = Schema.SObjectType.Person__c.getRecordTypeInfosByDeveloperName().get('Doctor').getRecordTypeId();
    
		final Id PATIENT_RECORD_TYPE_ID = Schema.SObjectType.Person__c.getRecordTypeInfosByDeveloperName().get('Patient').getRecordTypeId();
        
        Medical_Facility__c facility = new Medical_Facility__c(Medical_Facility_Name__c = 'City Hospital na ulicy jana pawla 3 123424632hnirenfbivfdinvi nwefij ije rivneixn',Insurence_Required__c=false);
        insert facility;

        Person__c doctor = new Person__c(FirstName__c='Adam',LastName__c = 'Smith',Personal_ID_Number__c = '44051401458', RecordTypeId = DOCTOR_RECORD_TYPE_ID);
        insert doctor;

        Person__c patient = new Person__c(FirstName__c='Adaam',LastName__c = 'Johnson',Personal_ID_Number__c = '44051401458', RecordTypeId = PATIENT_RECORD_TYPE_ID);
        insert patient;

        Medical_Appointment__c appointment = new Medical_Appointment__c(
            Medical_Facility__c = facility.Id,
            Doctor__c = doctor.Id,
            Patient__c = patient.Id,
            Appointment_Time__c = System.now()
        );

        insert appointment;

        appointment = [SELECT Medical_Appointment_Name__c FROM Medical_Appointment__c WHERE Id = :appointment.Id];
        system.Debug(appointment.Medical_Appointment_Name__c);
        String name1='[City Hospital na ulicy jana pawla 3 123424632hnirenfbivfdinvi nwefij ije rivneixn]-[Smith]-[Johnson]-[' + (System.now()).format('dd-MM-yyyy') + ']';
        System.assertEquals(name1,
            appointment.Medical_Appointment_Name__c
        );
    }
    @isTest
    static void testTriggerWithMissingFields() {
        
        final Id DOCTOR_RECORD_TYPE_ID = Schema.SObjectType.Person__c.getRecordTypeInfosByDeveloperName().get('Doctor').getRecordTypeId();
    
		final Id PATIENT_RECORD_TYPE_ID = Schema.SObjectType.Person__c.getRecordTypeInfosByDeveloperName().get('Patient').getRecordTypeId();
        
        Person__c patient = new Person__c(LastName__c = 'Smiwh',FirstName__c='Aaaadam',Personal_ID_Number__c = '44051401458', RecordTypeId = PATIENT_RECORD_TYPE_ID);
        insert patient;
        Person__c doctor = new Person__c(LastName__c = 'Smitasfh',FirstName__c='Asasadam',Personal_ID_Number__c = '44051401458', RecordTypeId = DOCTOR_RECORD_TYPE_ID);
        insert doctor;

        Medical_Appointment__c appointment = new Medical_Appointment__c(
            Doctor__c = doctor.Id,
            Patient__c=patient.Id,
            Appointment_Time__c = System.now()
        );

        insert appointment;

        appointment = [SELECT Medical_Appointment_Name__c FROM Medical_Appointment__c WHERE Id = :appointment.Id];
        system.Debug(appointment.Medical_Appointment_Name__c);
        System.assertEquals(
            '[??]-[Smitasfh]-[Smiwh]-[' + (System.now()).format('dd-MM-yyyy') + ']',
            appointment.Medical_Appointment_Name__c
        );
    }
}