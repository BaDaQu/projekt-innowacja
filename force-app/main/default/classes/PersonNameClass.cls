public class PersonNameClass 
{
    public static void PersonName(List<Person__c> persons)
    {
        for (Person__c person : persons) {
            if (person.FirstName__c != null && person.LastName__c != null) {
              person.Name = person.FirstName__c + ' ' + person.LastName__c;
            }
        
    	}
    }
}