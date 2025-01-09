trigger UpdateFirstAppointment on Medical_Appointment__c (before update) {
    DateTime datetoday=System.now();
    Set<Id> doc_id = new Set<Id>();
    for (Medical_Appointment__c m : Trigger.new) {
        doc_id.add(m.Doctor__c);
    }
	Map<Id, Person__c> int_docs = new Map<Id, Person__c>([SELECT Id, Specialization__c FROM Person__c WHERE Id IN :doc_id]);
     for (Medical_Appointment__c m : Trigger.new) {
        if (m.Doctor__c != null && int_docs.containsKey(m.Doctor__c)) {
            if (m.First_Appointment__c == true && m.Appointment_Time__c <= datetoday) {
                m.First_Appointment__c = false;
            }
        }
    }
}