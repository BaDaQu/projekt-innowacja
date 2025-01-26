public class MedicalAppointmentHandler {

    public static void handleAppointments(Map<Id, Medical_Appointment__c> oldMapAppointments, List<Medical_Appointment__c> newAppointments) {
        List<Messaging.SingleEmailMessage> emailsToSend = new List<Messaging.SingleEmailMessage>();
        Map<Id, String> patientEmailMap = new Map<Id, String>();
        Map<Id, Medical_Appointment__c> appointmentDetailsMap = new Map<Id, Medical_Appointment__c>();
        Set<Id> patientIds = new Set<Id>();
        Set<Id> appointmentsToProcess = new Set<Id>(); // Dodajemy Set do przechowywania ID wizyt, które uległy zmianie

        // Zbierz ID pacjentów i sprawdź, czy wizyta uległa zmianie
        for (Medical_Appointment__c newAppointment : newAppointments) {
            Medical_Appointment__c oldAppointment = oldMapAppointments != null ? oldMapAppointments.get(newAppointment.Id) : null;

           if (oldAppointment == null || hasAppointmentChanged(oldAppointment, newAppointment)) {
                if (newAppointment.Patient__c != null) {
                     patientIds.add(newAppointment.Patient__c);
                    appointmentDetailsMap.put(newAppointment.Id, newAppointment);
                     appointmentsToProcess.add(newAppointment.Id); // Dodajemy ID wizyty do zbioru, jeśli zaszła zmiana
                }
           }
        }

        // Bulkify zapytanie SOQL
        if (!patientIds.isEmpty()) {
            for (Person__c patient : [SELECT Id, Email__c FROM Person__c WHERE Id IN :patientIds]) {
                patientEmailMap.put(patient.Id, patient.Email__c);
            }
        }

        if (!appointmentsToProcess.isEmpty()) {
           emailsToSend = createEmailMessages(appointmentDetailsMap, patientEmailMap, appointmentsToProcess);
           if(!emailsToSend.isEmpty()){
             Messaging.sendEmail(emailsToSend);
            }
        }
    }

    private static Boolean hasAppointmentChanged(Medical_Appointment__c oldAppointment, Medical_Appointment__c newAppointment) {
        if (oldAppointment == null) return true; // Nowy rekord, więc na pewno zaszła zmiana
         // Sprawdzamy czy zmienily sie istotne pola, ktore generuja maila
        return oldAppointment.Name != newAppointment.Name ||
               oldAppointment.Appointment_Time__c != newAppointment.Appointment_Time__c;
    }


 private static List<Messaging.SingleEmailMessage> createEmailMessages(Map<Id, Medical_Appointment__c> appointmentDetailsMap, Map<Id, String> patientEmailMap, Set<Id> appointmentsToProcess) {
        List<Messaging.SingleEmailMessage> emailsToSend = new List<Messaging.SingleEmailMessage>();

        for (Id appointmentId : appointmentsToProcess) {
            Medical_Appointment__c appointment = appointmentDetailsMap.get(appointmentId);
            if(appointment == null){
               continue;
            }

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