trigger AppointmentName on Medical_Appointment__c (before insert, before update) {
    Set<Id> facilityIds = new Set<Id>();
    Set<Id> personIds = new Set<Id>();
    for (Medical_Appointment__c m : Trigger.new) {
        if (m.Medical_Facility__c != null) {
            facilityIds.add(m.Medical_Facility__c);
        }
        if (m.Doctor__c != null || m.Patient__c != null) {
            personIds.add(m.Doctor__c);
            personIds.add(m.Patient__c);
        }
    }
    Map<Id, Medical_Facility__c> facilityMap = new Map<Id, Medical_Facility__c>(
        [SELECT Id, Medical_Facility_Name__c FROM Medical_Facility__c WHERE Id IN :facilityIds]
    );

    Map<Id, Person__c> personMap = new Map<Id, Person__c>(
        [SELECT Id, LastName__c FROM Person__c WHERE Id IN :personIds]
    );

    for (Medical_Appointment__c m : Trigger.new) {
	m.Medical_Appointment_Name__c='';
        String facility='[??]-';
        if(m.Medical_Facility__c != null) {
            facility = '[' + facilityMap.get(m.Medical_Facility__c).Medical_Facility_Name__c+']-';
        }

        m.Medical_Appointment_Name__c = facility + '[' + personMap.get(m.Doctor__c).LastName__c + ']-' +
            '[' + personMap.get(m.Patient__c).LastName__c + ']-' + '[' + m.Appointment_Time__c.format('dd-MM-yyyy') + ']';
    }
}
