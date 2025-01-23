public class PersonTriggerHandler 
{
    public void beforeInsert(List<Person__c> persons)
    {
        PersonNameClass.PersonName(persons);
		ValidatePersonalIdClass.ValidatePersonalId(persons);   
    }
    
    public void beforeUpdate(List<Person__c> oldPersons, List<Person__c> newPersons)
    {
        List<Person__c> changedRecords = getOnlyChangedRecords(oldPersons, newPersons);
        
        PersonNameClass.PersonName(changedRecords);
		ValidatePersonalIdClass.ValidatePersonalId(changedRecords); 
    }
    
    private List<Person__c> getOnlyChangedRecords(List<Person__c> oldPersons, List<Person__c> newPersons)
    {
        List<Person__c> changedRecords = new List<Person__c>();
        
        for(Integer i = 0; i < oldPersons.size(); i++)
        {
            if(checkRecord(oldPersons[i], newPersons[i]))
            {
                changedRecords.add(newPersons[i]);
            }
        }
        
        return changedRecords;
    }
    
    private Boolean checkRecord(Person__c oldPerson, Person__c newPerson)
    {
        if(oldPerson.Personal_ID_Number__c != newPerson.Personal_ID_Number__c ||
           oldPerson.Name != newPerson.Name ||
           oldPerson.FirstName__c != newPerson.FirstName__c ||
           oldPerson.LastName__c != newPerson.LastName__c)
		{
			return true;
		}
            
        
        return false;
    }
}