public class PersonTriggerHandler 
{
    public static void beforeInsert(List<Person__c> persons)
    {
        PersonNameClass.personName(null, persons);
		ValidatePersonalIdClass.validatePersonalId(null, persons);   
    }
    
    public static void beforeUpdate(Map<Id, Person__c> oldMapPersons, List<Person__c> newPersons)
    {
        PersonNameClass.personName(oldMapPersons, newPersons);
		ValidatePersonalIdClass.validatePersonalId(oldMapPersons, newPersons); 
    }
    
}