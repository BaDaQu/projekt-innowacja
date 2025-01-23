public class MedicalAppointmentHandler {

    public static void handleAppointments(List<Medical_Appointment__c> appointments) {
        Set<Id> patientIds = new Set<Id>();
        for (Medical_Appointment__c appointment : appointments) {
            if (appointment.Patient__c != null) {
                patientIds.add(appointment.Patient__c);
            }
        }
    
        // Bulk SOQL Query: Retrieve all Person__c records at once.
        Map<Id, Person__c> patientMap = new Map<Id, Person__c>([SELECT Id, Email__c FROM Person__c WHERE Id IN :patientIds]);
    
        List<Messaging.SingleEmailMessage> emailsToSend = new List<Messaging.SingleEmailMessage>();
    
        for (Medical_Appointment__c appointment : appointments) {
            if (appointment.Patient__c != null && patientMap.containsKey(appointment.Patient__c)) {
                Person__c patient = patientMap.get(appointment.Patient__c);
    
                String subject = 'Zmiana w Twojej wizycie lekarskiej';
                String body = 'Twoja wizyta lekarska została utworzona lub zmieniona:\n\n';
                body += 'Nazwa wizyty: ' + appointment.Name + '\n';
                body += 'Data i godzina: ' + appointment.Appointment_Time__c + '\n\n';
                body += 'Prosimy o kontakt z placówką w celu potwierdzenia szczegółów.';
    
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setToAddresses(new List<String>{patient.Email__c});
                mail.setSubject(subject);
                mail.setPlainTextBody(body);
                emailsToSend.add(mail);
    
    
            } else {
                System.debug('Patient not found for Appointment: ' + appointment.Id);
            }
        }
    
        try{
            Messaging.sendEmail(emailsToSend);
        } catch(Exception e){
            System.debug('Error sending email: ' + e.getMessage());
            //Handle Email sending error appropriately, consider a retry mechanism.
        }
	}
}