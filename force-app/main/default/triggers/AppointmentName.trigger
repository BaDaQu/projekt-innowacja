trigger AppointmentName on Medical_Appointment__c (before insert, before update) {
    Set<Id> facilityIds = new Set<Id>();
    Set<Id> doctorIds = new Set<Id>();
    Set<Id> patientIds = new Set<Id>();
    for (Medical_Appointment__c m : Trigger.new) {
        if (m.Medical_Facility__c != null) {
            facilityIds.add(m.Medical_Facility__c);
        }
        if (m.Doctor__c != null) {
            doctorIds.add(m.Doctor__c);
        }
        if (m.Patient__c != null) {
            patientIds.add(m.Patient__c);
        }
    }
    Map<Id, Medical_Facility__c> facilityMap = new Map<Id, Medical_Facility__c>(
        [SELECT Id, Medical_Facility_Name__c FROM Medical_Facility__c WHERE Id IN :facilityIds]
    );

    Map<Id, Person__c> doctorMap = new Map<Id, Person__c>(
        [SELECT Id, LastName__c FROM Person__c WHERE Id IN :doctorIds]
    );

    Map<Id, Person__c> patientMap = new Map<Id, Person__c>(
        [SELECT Id, LastName__c FROM Person__c WHERE Id IN :patientIds]
    );
    for (Medical_Appointment__c m : Trigger.new) {
        String name = '';
        String facility=null;
        String doc=null;
        String patient=null;
        if(m.Medical_Facility__c != null) facility = '[' + facilityMap.get(m.Medical_Facility__c).Medical_Facility_Name__c+']-';
        if(m.Doctor__c!=null) 				doc = '[' + doctorMap.get(m.Doctor__c).LastName__c + ']-';
        if(m.Patient__c!=null)			 patient = '[' + patientMap.get(m.Patient__c).LastName__c + ']-';
        if(facility==null) facility = '[??]-';
        if(doc==null) 		doc = '[??]-';
        if(patient==null) patient = '[??]-';

		name = facility + doc + patient;
		name +=  '[' + m.Appointment_Time__c.format('dd-MM-yyyy') + ']';
        m.Medical_Appointment_Name__c = name;
    }
}