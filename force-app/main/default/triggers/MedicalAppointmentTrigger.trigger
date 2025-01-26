trigger MedicalAppointmentTrigger on Medical_Appointment__c (before insert, before update, after insert, after update) 
{ 
    try
    {
		if(Trigger.isBefore)
    	{
            if(Trigger.isInsert)
            {
                MedicalAppointmentTriggerHandler.beforeInsert((List<Medical_Appointment__c>) Trigger.new);
            }
            
            if(Trigger.isUpdate)
            {
                MedicalAppointmentTriggerHandler.beforeUpdate((Map<Id, Medical_Appointment__c>) Trigger.oldMap, (List<Medical_Appointment__c>) Trigger.new);
            }
    	}
        if(Trigger.isAfter)
        {
            if(Trigger.isInsert)
            {
                MedicalAppointmentTriggerHandler.afterInsert((List<Medical_Appointment__c>)Trigger.new);
            }
            
            if(Trigger.isUpdate)
            {
                MedicalAppointmentTriggerHandler.afterUpdate((Map<Id, Medical_Appointment__c>) Trigger.oldMap, (List<Medical_Appointment__c>) Trigger.new);
            }
        }
    }
    catch(Exception e)
    {
       NotifyAdmins.sendEmails('MedicalAppointmentTrigger error', e.getMessage());
    }

}