public class MedicalAppointmentTriggerHandler
{
    
    public void beforeInsert(List<Medical_Appointment__c> appointments)
    {
        AppointmentNameClass.AppointmentName(appointments);
        FirstAppointmentInternistClass.FirstAppointmentInternist(appointments);
    }
    
    public void beforeUpdate(List<Medical_Appointment__c> oldAppointments, List<Medical_Appointment__c> newAppointments)
    {
        List<Medical_Appointment__c> changedRecords = getOnlyChangedRecords(oldAppointments, newAppointments);
        
        AppointmentNameClass.AppointmentName(changedRecords);
        
		FirstAppointmentInternistClass.FirstAppointmentInternist(newAppointments);
    }
    
    public void afterInsert(List<Medical_Appointment__c> appointments)
    {
        MedicalAppointmentHandler.handleAppointments(appointments);
    }
    
    public void afterUpdate(List<Medical_Appointment__c> appointments)
    {
        MedicalAppointmentHandler.handleAppointments(appointments);
    }
    
    private List<Medical_Appointment__c> getOnlyChangedRecords(List<Medical_Appointment__c> oldAppointments, List<Medical_Appointment__c> newAppointments)
    {
		List<Medical_Appointment__c> changedRecords = new List<Medical_Appointment__c>();
        
        for(Integer i = 0; i < oldAppointments.size(); i++)
        {
            if(checkRecord(oldAppointments[i], newAppointments[i]))
            {
                changedRecords.add(newAppointments[i]);
            }
        }
        
        return changedRecords;
    }

    private Boolean checkRecord(Medical_Appointment__c oldAppointment, Medical_Appointment__c newAppointment)
    {
        if(oldAppointment.Name != newAppointment.Name ||
           oldAppointment.Appointment_Time__c != newAppointment.Appointment_Time__c)
        {
            return true;
        }
        
        return false;
    }
}