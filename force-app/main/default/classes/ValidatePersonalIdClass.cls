public class ValidatePersonalIdClass 
{
	public static void ValidatePersonalId(List<Person__c> persons)
    {
        final Integer[] MULTIPLIERS = new integer[]{1, 3, 7, 9, 1, 3, 7, 9, 1, 3};
            
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
}