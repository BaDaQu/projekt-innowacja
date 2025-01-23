public class MedicalAppointmentHandler {

    public static void handleAppointments(List<Medical_Appointment__c> newAppointments) {
        Set<Id> patientIds = new Set<Id>();
        for (Medical_Appointment__c appointment : newAppointments) {
            if (appointment.Patient__c != null) {
                patientIds.add(appointment.Patient__c);
            }
        }

        if (patientIds.isEmpty()) return;

        Map<Id, Person__c> patients = new Map<Id, Person__c>([SELECT Id, Email__c FROM Person__c WHERE Id IN :patientIds]);
        List<Messaging.SingleEmailMessage> emailsToSend = new List<Messaging.SingleEmailMessage>();
        
        for (Medical_Appointment__c appointment : newAppointments) {
            if (appointment.Patient__c != null && patients.containsKey(appointment.Patient__c)) {
               Person__c patient = patients.get(appointment.Patient__c);
                if (patient != null && String.isNotBlank(patient.Email__c)) {
                    String subject = 'Zmiana w Twojej wizycie lekarskiej';
                    String body = 'Twoja wizyta lekarska została utworzona lub zmieniona:\n\n';
                    body += 'Nazwa wizyty: ' + (String.isNotBlank(appointment.Name) ? appointment.Name : 'Brak nazwy') + '\n';
                     body += 'Data i godzina: ' + (appointment.Appointment_Time__c != null ? String.valueOf(appointment.Appointment_Time__c) : 'Brak daty i godziny') + '\n\n';
                    body += 'Prosimy o kontakt z placówką w celu potwierdzenia szczegółów.';
            
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    mail.setToAddresses(new List<String>{patient.Email__c});
                    mail.setSubject(subject);
                    mail.setPlainTextBody(body);
                    emailsToSend.add(mail);
                }
            }
        }

        if (!emailsToSend.isEmpty()) {
            Messaging.sendEmail(emailsToSend);
        }
    }
}