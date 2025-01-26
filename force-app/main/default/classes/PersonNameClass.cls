public class PersonNameClass 
{
    public static void personName(Map<Id, Person__c> oldMapPersons, List<Person__c> newPersons)
    {
        List<Person__c> persons = (oldMapPersons != null && !oldMapPersons.isEmpty()) ? getChangedRecords(oldMapPersons, newPersons) : newPersons;
        
        for (Person__c person : persons) {
            if (person.FirstName__c != null && person.LastName__c != null) {
              person.Name = person.FirstName__c + ' ' + person.LastName__c;
            }
        
    	}
    }
    
    private static List<Person__c> getChangedRecords(Map<Id, Person__c> oldMapPersons, List<Person__c> newPersons)
    {
        List<Person__c> changedRecords = new List<Person__c>();
        for(Person__c person : newPersons)
        {
            Person__c oldPerson = oldMapPersons.get(person.Id);
            if(person.Name != oldPerson.Name ||
               person.FirstName__c != oldPerson.FirstName__c ||
               person.LastName__c != oldPerson.LastName__c)
            {
                changedRecords.add(person);
            }
        }
        return changedRecords;
    }
}