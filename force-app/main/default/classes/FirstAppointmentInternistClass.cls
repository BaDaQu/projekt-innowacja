public class FirstAppointmentInternistClass 
{
    public static void firstAppointmentInternist(List<Medical_Appointment__c> appointments) 
    {
        Set<Id> patientIds = new Set<Id>();
        for (Medical_Appointment__c app : appointments) {
            patientIds.add(app.Patient__c);
        }
        
            
        Map<Id, Medical_Appointment__c> all_app_int = new Map<Id, Medical_Appointment__c>([SELECT Id, Patient__c
                                           FROM Medical_Appointment__c 
                                           WHERE Patient__c IN :patientIds AND Doctor__r.Specialization__c = 'Internist']);
    Map<Id, Person__c> listint = new Map<Id, Person__c>([SELECT Id,Specialization__c FROM Person__c WHERE Specialization__c = 'Internist']);

    final Id OnlineR = Schema.SObjectType.Medical_Appointment__c.getRecordTypeInfosByDeveloperName().get('Online').getRecordTypeId();

        for (Medical_Appointment__c app : appointments) {
             if (!all_app_int.containsKey(app.Patient__c) && listint.containsKey(app.Doctor__c) && listint.get(app.Doctor__c).Specialization__c!=null) {
                if (listint.get(app.Doctor__c).Specialization__c == 'Internist' && app.RecordTypeId == OnlineR) {
                    app.addError('The first appointment to the internist must be on site');
                }
            }
    	}
    }
}