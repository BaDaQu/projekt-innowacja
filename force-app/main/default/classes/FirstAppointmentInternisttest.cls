@isTest
public class FirstAppointmentInternisttest {
    @isTest   
    
    static void testFirstInternistVisitOnline() {
        
		final Id DOCTOR_RECORD_TYPE_ID = Schema.SObjectType.Person__c.getRecordTypeInfosByDeveloperName().get('Doctor').getRecordTypeId();
    
		final Id PATIENT_RECORD_TYPE_ID = Schema.SObjectType.Person__c.getRecordTypeInfosByDeveloperName().get('Patient').getRecordTypeId();
        
		RecordType onlineR = [SELECT RecordType.Name,id FROM RecordType WHERE SObjectType = 'Medical_Appointment__c' AND DeveloperName = 'Online' LIMIT 1];
        
        Person__c patient = new Person__c(FirstName__c='asd',LastName__c = 'John Doe',Personal_ID_Number__c='44051401458', RecordTypeId = PATIENT_RECORD_TYPE_ID);
        insert patient;

        Person__c doctor = new Person__c(FirstName__c='asd',LastName__c = 'Dr. Smith', Specialization__c = 'Internist',Personal_ID_Number__c='44051401458', RecordTypeId = DOCTOR_RECORD_TYPE_ID);
        insert doctor;

        Medical_Facility__c facility = new Medical_Facility__c(Name = 'Health Clinic',Insurence_Required__c=false);
        insert facility;

        //online
        Medical_Appointment__c appointment = new Medical_Appointment__c(
            Patient__c = patient.Id,
            Doctor__c = doctor.Id,
            Medical_Facility__c = facility.Id,
            RecordTypeId = onlineR.Id,
            Appointment_Time__c = System.now().addDays(1)
        );

        Test.startTest();
        try {
            insert appointment;
        } catch (DmlException e) {
            system.debug(e.getMessage());
            System.assert(e.getMessage().contains('The first appointment to the internist must be on site'));
        }
        Test.stopTest();
    }

    @isTest
    static void testFirstInternistVisitOnsite() {
        
        final Id DOCTOR_RECORD_TYPE_ID = Schema.SObjectType.Person__c.getRecordTypeInfosByDeveloperName().get('Doctor').getRecordTypeId();
    
		final Id PATIENT_RECORD_TYPE_ID = Schema.SObjectType.Person__c.getRecordTypeInfosByDeveloperName().get('Patient').getRecordTypeId();
        
		RecordType onsiteR = [SELECT RecordType.Name,id FROM RecordType WHERE SObjectType = 'Medical_Appointment__c' AND DeveloperName = 'On_Site' LIMIT 1];
        Person__c patient = new Person__c(FirstName__c='asd',LastName__c = 'Jane Doe',Personal_ID_Number__c='44051401458', RecordTypeId = PATIENT_RECORD_TYPE_ID);
        insert patient;

        Person__c doctor = new Person__c(FirstName__c='asd',LastName__c = 'Dr. Brown', Specialization__c = 'Internist',Personal_ID_Number__c='44051401458', RecordTypeId = DOCTOR_RECORD_TYPE_ID);
        insert doctor;

        Medical_Facility__c facility = new Medical_Facility__c(Name = 'City Hospital',Insurence_Required__c=false);
        insert facility;

        //onsite
        Medical_Appointment__c appointment = new Medical_Appointment__c(
            Patient__c = patient.Id,
            Doctor__c = doctor.Id,
            Medical_Facility__c = facility.Id,
            RecordTypeId = onsiteR.Id,
            Appointment_Time__c = System.now().addDays(1)
        );

        Test.startTest();
        insert appointment;
        Test.stopTest();

        Medical_Appointment__c result = [SELECT Id FROM Medical_Appointment__c WHERE Id = :appointment.Id];
        System.assertNotEquals(null, result, 'Wizyta powinna zostać zapisana.');
    }

    @isTest
    static void testSubsequentInternistVisitOnline() {
        
        final Id DOCTOR_RECORD_TYPE_ID = Schema.SObjectType.Person__c.getRecordTypeInfosByDeveloperName().get('Doctor').getRecordTypeId();
    
		final Id PATIENT_RECORD_TYPE_ID = Schema.SObjectType.Person__c.getRecordTypeInfosByDeveloperName().get('Patient').getRecordTypeId();
        
		RecordType onlineR = [SELECT RecordType.Name,id FROM RecordType WHERE SObjectType = 'Medical_Appointment__c' AND DeveloperName = 'Online' LIMIT 1];
		RecordType onsiteR = [SELECT RecordType.Name,id FROM RecordType WHERE SObjectType = 'Medical_Appointment__c' AND DeveloperName = 'On_Site' LIMIT 1];

        Person__c patient = new Person__c(FirstName__c='asd',LastName__c = 'Alice Green',Personal_ID_Number__c='44051401458', RecordTypeId = PATIENT_RECORD_TYPE_ID);
        insert patient;

        Person__c doctor = new Person__c(FirstName__c='asd',LastName__c = 'Dr. White', Specialization__c = 'Internist',Personal_ID_Number__c='44051401458', RecordTypeId = DOCTOR_RECORD_TYPE_ID);
        insert doctor;

        Medical_Facility__c facility = new Medical_Facility__c(Name = 'Downtown Clinic',Insurence_Required__c=false);
        insert facility;

        //onsite
        Medical_Appointment__c firstAppointment = new Medical_Appointment__c(
            Patient__c = patient.Id,
            Doctor__c = doctor.Id,
            Medical_Facility__c = facility.Id,
            RecordTypeId = onsiteR.Id,
            Appointment_Time__c = System.now().addDays(-10)
        );
        insert firstAppointment;

        //online
        Medical_Appointment__c secondAppointment = new Medical_Appointment__c(
            Patient__c = patient.Id,
            Doctor__c = doctor.Id,
            Medical_Facility__c = facility.Id,
            RecordTypeId = onlineR.Id,
            Appointment_Time__c = System.now().addDays(1)
        );

        Test.startTest();
        insert secondAppointment;
        Test.stopTest();

        Medical_Appointment__c result = [SELECT Id FROM Medical_Appointment__c WHERE Id = :secondAppointment.Id];
        System.assertNotEquals(null, result, 'Wizyta powinna zostać zapisana.');
    }
    @isTest
    static void testSubsequentvists2online() {
        
        final Id DOCTOR_RECORD_TYPE_ID = Schema.SObjectType.Person__c.getRecordTypeInfosByDeveloperName().get('Doctor').getRecordTypeId();
    
		final Id PATIENT_RECORD_TYPE_ID = Schema.SObjectType.Person__c.getRecordTypeInfosByDeveloperName().get('Patient').getRecordTypeId();
        
		RecordType onlineR = [SELECT RecordType.Name,id FROM RecordType WHERE SObjectType = 'Medical_Appointment__c' AND DeveloperName = 'Online' LIMIT 1];
		RecordType onsiteR = [SELECT RecordType.Name,id FROM RecordType WHERE SObjectType = 'Medical_Appointment__c' AND DeveloperName = 'On_Site' LIMIT 1];

        Person__c patient = new Person__c(FirstName__c='asd',LastName__c = 'Alice Green',Personal_ID_Number__c='44051401458', RecordTypeId = PATIENT_RECORD_TYPE_ID);
        insert patient;

        Person__c doctor = new Person__c(FirstName__c='asd',LastName__c = 'Dr. White', Specialization__c = 'Internist',Personal_ID_Number__c='44051401458', RecordTypeId = DOCTOR_RECORD_TYPE_ID);
        insert doctor;

        Medical_Facility__c facility = new Medical_Facility__c(Name = 'Downtown Clinic',Insurence_Required__c=false);
        insert facility;

        //online
        Medical_Appointment__c firstAppointment = new Medical_Appointment__c(
            Patient__c = patient.Id,
            Doctor__c = doctor.Id,
            Medical_Facility__c = facility.Id,
            RecordTypeId = onlineR.Id,
            Appointment_Time__c = System.now().addDays(2)
        );

        //online
        Medical_Appointment__c secondAppointment = new Medical_Appointment__c(
            Patient__c = patient.Id,
            Doctor__c = doctor.Id,
            Medical_Facility__c = facility.Id,
            RecordTypeId = onlineR.Id,
            Appointment_Time__c = System.now().addDays(3)
        );

          Test.startTest();
        try {
            insert firstAppointment;
        } catch (DmlException e) {
            system.debug(e.getMessage());
            System.assert(e.getMessage().contains('The first appointment to the internist must be on site'));
        }
        try {
            insert secondAppointment;
        } catch (DmlException e) {
            system.debug(e.getMessage());
            System.assert(e.getMessage().contains('The first appointment to the internist must be on site'));
        }
        Test.stopTest();
    }
}