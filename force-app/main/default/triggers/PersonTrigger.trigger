trigger PersonTrigger on Person__c (before insert, before update) 
{
    PersonTriggerHandler handler = new PersonTriggerHandler();
    
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
    }
    catch(Exception e)
    {
        NotifyAdmins.sendEmails('PersonTrigger error', e.getMessage());
    }


}