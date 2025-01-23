trigger MedicalAppointmentTrigger on Medical_Appointment__c (before insert, before update) 
{
    MedicalAppointmentTriggerHandler handler = new MedicalAppointmentTriggerHandler();
    
    try
    {
		if(Trigger.isBefore)
    	{
            if(Trigger.isInsert)
            {
                handler.beforeInsert(Trigger.new);
            }
            
            if(Trigger.isUpdate)
            {
                handler.beforeUpdate(Trigger.old, Trigger.new);
            }
    	}
        if(Trigger.isAfter)
        {
            if(Trigger.isInsert)
            {
                handler.afterInsert(Trigger.new);
            }
            
            if(Trigger.isUpdate)
            {
                handler.afterUpdate(Trigger.new);
            }
        }
    }
    catch(Exception e)
    {
       NotifyAdmins.sendEmails('MedicalAppointmentTrigger error', e.getMessage());
    }

}