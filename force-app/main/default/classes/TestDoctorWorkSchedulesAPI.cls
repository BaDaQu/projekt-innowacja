@isTest
public class TestDoctorWorkSchedulesAPI 
{
    
	@isTest
    static void testValidResponse() 
    {
        final Id DOCTOR_RECORD_TYPE_ID = Schema.SObjectType.Person__c.getRecordTypeInfosByDeveloperName().get('Doctor').getRecordTypeId();
        
        String response = '[{"Schedule":{"Sunday":{"EndTime":"15:00","StartTime":"9:00"},"Saturday":{"EndTime":"17:00","StartTime":"11:00"},"Friday":{"EndTime":"15:00","StartTime":"8:00"},"Tuesday":{"EndTime":"13:00","StartTime":"8:00"}},"PESEL":"84053195285","LastName":"Zieliński","FirstName":"Tomasz","DoctorId":"D0000005"}]';         
        
        Test.startTest();
        DoctorWorkSchedulesAPI.parseAndUpsertResponse(response);
		Test.stopTest();
        
        List<Person__c> persons = [SELECT Id, Name, FirstName__c, LastName__c, RecordTypeId, Personal_ID_Number__c, Doctor_Work_Schedule__c, External_Id__c 
                                   FROM Person__c WHERE External_Id__c =: 'D0000005'];
        
        System.assertEquals(1, persons.size());
        System.assertEquals('Tomasz Zieliński', persons[0].Name);
        System.assertEquals('Tomasz', persons[0].FirstName__c);
        System.assertEquals('Zieliński', persons[0].LastName__c);
        System.assertEquals(DOCTOR_RECORD_TYPE_ID, persons[0].RecordTypeId);
        System.assertEquals('84053195285', persons[0].Personal_ID_Number__c);
        System.assertEquals('D0000005', persons[0].External_Id__c);

		String doctorWorkSchedules = 'Sunday: 9:00 - 15:00\nSaturday: 11:00 - 17:00\nFriday: 8:00 - 15:00\nTuesday: 8:00 - 13:00';
        
        System.assertEquals(doctorWorkSchedules, persons[0].Doctor_Work_Schedule__c);
        
    }
    
    @isTest
	static void testFailExecute() 
    {
		String mockResponse = '[{"Schedule":{"Sunday":{"EndTime":"15:00","StartTime":"9:00"},"Saturday":{"EndTime":"17:00","StartTime":"11:00"},"Friday":{"EndTime":"15:00","StartTime":"8:00"},"Tuesday":{"EndTime":"13:00","StartTime":"8:00"}},"PESEL":"84053195285","LastName":"Zieliński","FirstName":"Tomasz","DoctorId":"D0000005"}]';         
 
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse(401, mockResponse));
    
        Test.startTest();
        DoctorWorkSchedulesAPI api = new DoctorWorkSchedulesAPI();
        api.execute(null);
        Test.stopTest();
    
        List<Person__c> persons = [SELECT Id FROM Person__c WHERE External_Id__c = 'D0000005'];
        System.assertEquals(0, persons.size());
    }
        
   	@isTest
    static void testEmptyResponse() 
    {
        String response = '';
    
        Test.startTest();
        try
        {
			DoctorWorkSchedulesAPI.parseAndUpsertResponse(response);
        }
        catch(Exception e)
        {
            System.assertEquals('No content to map to Object due to end of input', e.getMessage());
        }
 
		Test.stopTest();
    
        List<Person__c> persons = [SELECT Id FROM Person__c];
        System.assertEquals(0, persons.size());
	}
    
    private class MockHttpResponse implements HttpCalloutMock
    {
        private Integer statusCode;
        private String body;
       
        MockHttpResponse(Integer code, String initBody)
        {
            statusCode = code;
            body = initBody;
        }
    
        public HTTPResponse respond(HTTPRequest req) 
        {
            HttpResponse res = new HttpResponse();
            res.setStatusCode(statusCode);
            res.setHeader('Content-Type', 'application/json');
            res.setBody(body);
            return res;
       	}
    }
}