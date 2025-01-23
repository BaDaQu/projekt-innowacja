trigger FirstAppointmentInternist on Medical_Appointment__c (before insert, before update) {
    Set<Id> patientIds = new Set<Id>();
    for (Medical_Appointment__c app : Trigger.new) {
        patientIds.add(app.Patient__c);
    }
	
        
    Map<Id, Medical_Appointment__c> all_app_int = new Map<Id, Medical_Appointment__c>([SELECT Id, Patient__c
                                       FROM Medical_Appointment__c 
                                       WHERE Patient__c IN :patientIds AND Doctor__r.Specialization__c = 'Internist']);

    for (Medical_Appointment__c app : Trigger.new) {
        if (app.Doctor__r != null && app.Doctor__r.Specialization__c == 'Internist') {
            if (!all_app_int.containsKey(app.Patient__c) && app.RecordType.Name =='Online') {
                app.addError('The first appointment to the internist must be on site');
            }
        }
    }
}