public class MedicalAppointmentHandler {

    public static void handleAfterInsertAndUpdate(List<Medical_Appointment__c> newAppointments) {
        List<String> emailAddresses = new List<String>();
        Map<Id, String> patientEmailMap = new Map<Id, String>();
        Map<Id, Medical_Appointment__c> appointmentDetailsMap = new Map<Id, Medical_Appointment__c>();
        Set<Id> patientIds = new Set<Id>();

        // Zbierz ID pacjentów
        for (Medical_Appointment__c appointment : newAppointments) {
            if (appointment.Patient__c != null) {
                patientIds.add(appointment.Patient__c);
                appointmentDetailsMap.put(appointment.Id, appointment);
            }
        }

        // Bulkify zapytanie SOQL
        if (!patientIds.isEmpty()) {
            for (Person__c patient : [SELECT Id, Email__c FROM Person__c WHERE Id IN :patientIds]) {
                patientEmailMap.put(patient.Id, patient.Email__c);
            }

            for (Id appointmentId : appointmentDetailsMap.keySet()) {
                Medical_Appointment__c appointment = appointmentDetailsMap.get(appointmentId);
                if (patientEmailMap.containsKey(appointment.Patient__c)) {
                    emailAddresses.add(patientEmailMap.get(appointment.Patient__c));
                }
            }
        }

        if (!emailAddresses.isEmpty()) {
            List<Messaging.SingleEmailMessage> emailsToSend = createEmailMessages(appointmentDetailsMap, patientEmailMap);
            Messaging.sendEmail(emailsToSend);
        }
    }

    private static List<Messaging.SingleEmailMessage> createEmailMessages(Map<Id, Medical_Appointment__c> appointmentDetailsMap, Map<Id, String> patientEmailMap) {
        List<Messaging.SingleEmailMessage> emailsToSend = new List<Messaging.SingleEmailMessage>();

        for (Id appointmentId : appointmentDetailsMap.keySet()) {
            Medical_Appointment__c appointment = appointmentDetailsMap.get(appointmentId);

            String subject = 'Zmiana w Twojej wizycie lekarskiej';
            String body = 'Twoja wizyta lekarska została utworzona lub zmieniona:\n\n';
            body += 'Nazwa wizyty: ';

            if (appointment.Name != null) {
                body += appointment.Name + '\n';
            } else {
                body += 'Brak nazwy\n';
            }

            body += 'Data i godzina: ';
            if (appointment.Appointment_Time__c != null) {
                body += appointment.Appointment_Time__c + '\n\n';
            } else {
                body += 'Brak daty i godziny\n\n';
            }

            body += 'Prosimy o kontakt z placówką w celu potwierdzenia szczegółów.';

            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            if (appointment.Patient__c != null && patientEmailMap.containsKey(appointment.Patient__c)) {
                mail.setToAddresses(new List<String>{patientEmailMap.get(appointment.Patient__c)});
            } else {
                // Opcjonalnie: Dodaj logowanie lub obsłuż ten przypadek.
                System.debug('Brak adresu email dla pacjenta o ID: ' + appointment.Patient__c);
                continue; // Przejdź do kolejnej wizyty
            }
            mail.setSubject(subject);
            mail.setPlainTextBody(body);
            emailsToSend.add(mail);
        }

        return emailsToSend;
    }
}