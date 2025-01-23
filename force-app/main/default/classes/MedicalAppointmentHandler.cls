public class MedicalAppointmentHandler {

    public static void handleAppointments(List<Medical_Appointment__c> appointments) {
        List<String> emailAddresses = new List<String>();
        Map<Id, String> patientEmailMap = new Map<Id, String>();
        Map<Id, Medical_Appointment__c> appointmentDetailsMap = new Map<Id, Medical_Appointment__c>();

        for (Medical_Appointment__c appointment : appointments) {
            if (appointment.Patient__c != null) {
                if (!patientEmailMap.containsKey(appointment.Patient__c)) {
                    Person__c patient = [SELECT Email__c FROM Person__c WHERE Id = :appointment.Patient__c];
                    patientEmailMap.put(appointment.Patient__c, patient.Email__c);
                }
                emailAddresses.add(patientEmailMap.get(appointment.Patient__c));
                appointmentDetailsMap.put(appointment.Id, appointment);
            }
        }

        if (!emailAddresses.isEmpty()) {
            List<Messaging.SingleEmailMessage> emailsToSend = new List<Messaging.SingleEmailMessage>();

            for (Id appointmentId : appointmentDetailsMap.keySet()) {
                Medical_Appointment__c appointment = appointmentDetailsMap.get(appointmentId);

                String subject = 'Zmiana w Twojej wizycie lekarskiej';
                String body = 'Twoja wizyta lekarska została utworzona lub zmieniona:\n\n';
                body += 'Nazwa wizyty: ' + appointment.Name + '\n';
                body += 'Data i godzina: ' + appointment.Appointment_Time__c + '\n\n';
                body += 'Prosimy o kontakt z placówką w celu potwierdzenia szczegółów.';

                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setToAddresses(new List<String>{patientEmailMap.get(appointment.Patient__c)});
                mail.setSubject(subject);
                mail.setPlainTextBody(body);
                emailsToSend.add(mail);
            }

            Messaging.sendEmail(emailsToSend);
        }
    }
}