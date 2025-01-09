@isTest
private class testValidatePersonalID
{
    @isTest
    static void testValidPESEL()
    {
        
        Person__c person = new Person__c
        (
        	Personal_ID_Number__c = '44051401359'        
        );
        
        try
        {
            insert person;
            Assert.areEqual(person.Personal_ID_Number__c, '44051401359', 'Something wrong happened!');
        }
        catch(DmlException e)
        {
            System.assert(false, 'Record should be inserted succesfully!');
        }
        
    }
    
    @isTest
    static void testInvalidLength()
    {
        Person__c person = new Person__c
        (
        	Personal_ID_Number__c = '4405140135'        
        );
        
        try 
        {
            insert person;
            System.assert(false, 'Record should not be inserted due to invalid Personal ID Number length!');
        } 
        catch (DmlException e) 
        {
            System.assert(e.getMessage().contains('Personal ID Number should be 11 digits long!'), 
                          'Expected validation error for invalid Personal ID Number length!');
        }
        
    }
    
    @isTest
    static void testInvalidLastDigit() 
    {
       
        Person__c person = new Person__c
        (
        	Personal_ID_Number__c = '44051401350'        
        );

        try 
        {
            insert person;
            System.assert(false, 'Record should not be inserted due to invalid last digit of Personal ID Number!');
        } 
        catch (DmlException e) 
        {
            System.assert(e.getMessage().contains('Last digit of Personal ID Number is wrong!'), 
                          'Expected validation error for invalid last digit of Personal ID Number!');
        }
    }
}