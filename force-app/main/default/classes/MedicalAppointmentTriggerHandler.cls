public class MedicalAppointmentTriggerHandler
{
    
    public static void beforeInsert(List<Medical_Appointment__c> appointments)
    {
        AppointmentNameClass.appointmentName(null, appointments);
        FirstAppointmentInternistClass.firstAppointmentInternist(appointments);
    }
    
    public static void beforeUpdate(Map<Id, Medical_Appointment__c> oldMapAppointments, List<Medical_Appointment__c> newAppointments)
    {   
        AppointmentNameClass.appointmentName(oldMapAppointments, newAppointments);
        
		FirstAppointmentInternistClass.firstAppointmentInternist(newAppointments);
    }
    
    public static void afterInsert(List<Medical_Appointment__c> appointments)
    {
        MedicalAppointmentHandler.handleAppointments(null, appointments);
    }
    
    public static void afterUpdate(Map<Id, Medical_Appointment__c> oldMapAppointments, List<Medical_Appointment__c> appointments)
    {
        MedicalAppointmentHandler.handleAppointments(oldMapAppointments, appointments);
    }
    
}