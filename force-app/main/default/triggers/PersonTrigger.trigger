trigger PersonTrigger on Person__c (before insert, before update) 
{   
    try
    {
		if(Trigger.isBefore)
    	{
            if(Trigger.isInsert)
            {
                PersonTriggerHandler.beforeInsert((List<Person__c>) Trigger.new);
            }
            
            if(Trigger.isUpdate)
            {
                PersonTriggerHandler.beforeUpdate((Map<Id, Person__c>)Trigger.oldMap, (List<Person__c>) Trigger.new);
            }
    	}
    }
    catch(Exception e)
    {
        NotifyAdmins.sendEmails('PersonTrigger error', e.getMessage());
    }


}