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
        if (m.Medical_Facility__c != null && facilityMap.containsKey(m.Medical_Facility__c)) {
            if(facilityMap.get(m.Medical_Facility__c).Medical_Facility_Name__c!=null){
            	name += '[' + facilityMap.get(m.Medical_Facility__c).Medical_Facility_Name__c + ']-';
            }else{
            	name += '[??]-';
            }
        } else {
            name += '[??]-';
        }
        if (m.Doctor__c != null && doctorMap.containsKey(m.Doctor__c)) {
            if(doctorMap.get(m.Doctor__c).LastName__c!=null){
           		 name += '[' + doctorMap.get(m.Doctor__c).LastName__c + ']-';     
            }else{
                 name += '[??]-';
            }
        } else {
            name += '[??]-';
        }
        if (m.Patient__c != null && patientMap.containsKey(m.Patient__c)) {
            if(patientMap.get(m.Patient__c).LastName__c!=null){
            	name += '[' + patientMap.get(m.Patient__c).LastName__c + ']-';
            }else{
                name += '[??]-';
            }
        } else {
            name += '[??]-';
        }
        if (m.Appointment_Time__c != null) {
            name += '[' + m.Appointment_Time__c.format('dd-MM-yyyy') + ']';
        } else {
            name += '[??]';
        }
        m.Medical_Appointment_Name__c = name;
    }
}