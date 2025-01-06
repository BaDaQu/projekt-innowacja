trigger validatePersonalID on Person__c (before insert, before update) 
{
    for(Person__c person : Trigger.new)
    {
        string pesel = person.Personal_ID_Number__c;

        if(pesel == null || pesel.length() != 11)
        {
            person.addError('Personal ID Number should be 11 digits long!');
            continue;
        }

        final integer[] multipliers = new integer[]{1, 3, 7, 9, 1, 3, 7, 9, 1, 3};

        integer sum = 0;

        for(integer i = 0; i < pesel.length() - 1; i++)
        {
            integer temp = integer.valueOf(pesel.substring(i, i + 1)); 
            sum += temp * multipliers[i];
        }

        integer remainder = math.mod(sum, 10);

        integer lastDigit = 0;

        if(remainder != 0)
        {
            lastDigit = 10 - remainder;
        }
        
        if(integer.valueOf(pesel.substring(10, 11)) != lastDigit) 
        {
            person.addError('Last digit of Personal ID Number is wrong!');
        }

    }
}