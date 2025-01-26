public class ValidatePersonalIdClass 
{
    private static final Integer[] MULTIPLIERS = new integer[]{1, 3, 7, 9, 1, 3, 7, 9, 1, 3};
    
	public static void validatePersonalId(Map<Id, Person__c> oldMapPersons, List<Person__c> newPersons)
    {
        List<Person__c> persons = (oldMapPersons != null && !oldMapPersons.isEmpty()) ? getChangedRecords(oldMapPersons, newPersons) : newPersons;
                        
		for(Person__c person : persons)
		{
			String pesel = person.Personal_ID_Number__c;
        
			if(pesel.length() != 11)
			{
				person.addError('Personal ID Number should be 11 digits long!');
                continue;
			}
        
			Integer sum = 0;
        
			for(Integer i = 0; i < pesel.length() - 1; i++)
			{
				Integer temp = Integer.valueOf(pesel.substring(i, i + 1)); 
				sum += temp * MULTIPLIERS[i];
			}
        
			Integer remainder = math.mod(sum, 10);
        
			Integer lastDigit = 0;
        
			if(remainder != 0)
			{
				lastDigit = 10 - remainder;
			}
                
			if(Integer.valueOf(pesel.substring(10, 11)) != lastDigit) 
			{
				person.addError('Personal ID Number is incorrect!');
			}

		}
    }
    
    private static List<Person__c> getChangedRecords(Map<Id, Person__c> oldMapPersons, List<Person__c> newPersons)
    {
        List<Person__c> changedRecords = new List<Person__c>();
        for(Person__c person : newPersons)
        {
            Person__c oldPerson = oldMapPersons.get(person.Id);
            if(person.Personal_ID_Number__c != oldPerson.Personal_ID_Number__c)
            {
                changedRecords.add(person);
            }
        }
        return changedRecords;
    }
}