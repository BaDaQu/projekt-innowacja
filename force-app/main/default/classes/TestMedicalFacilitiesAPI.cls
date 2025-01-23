@isTest
public class TestMedicalFacilitiesAPI 
{  

    @isTest
    static void testValidResponse() 
    {
        String response = '[{"Phone":"+48 123 456 780","OpeningHours":{"Niedziela":"8:00 - 18:00","Sobota":"8:00 - 16:00","Piątek":"10:00 - 16:00","Czwartek":"8:00 - 16:00","Środa":"8:00 - 18:00","Wtorek":"8:00 - 18:00","Poniedziałek":"9:00 - 18:00"},"Name":"Jeż Medyczny","Id":"AB123456","Email":"kontakt0@placowka.com","Address":{"Street":"Wiejska 1","PostalCode":"00-489","City":"Warszawa"}}]';
        
        Test.startTest();
        MedicalFacilitiesAPI.parseAndUpsertResponse(response);
		Test.stopTest();
        
        List<Medical_Facility__c> facilities = [SELECT Id, Name, Address__Street__s, Address__PostalCode__s, Address__City__s, Phone__c, Email__c, Opening_Hours__c, External_Id__c 
                                                FROM Medical_Facility__c WHERE External_Id__c =: 'AB123456'];
        
        System.assertEquals(1, facilities.size());
        System.assertEquals('Jeż Medyczny', facilities[0].Name);
        System.assertEquals('+48 123 456 780', facilities[0].Phone__c);
        System.assertEquals('kontakt0@placowka.com', facilities[0].Email__c);
        System.assertEquals('AB123456', facilities[0].External_Id__c);
        System.assertEquals('Wiejska 1', facilities[0].Address__Street__s);
        System.assertEquals('00-489', facilities[0].Address__PostalCode__s);
        System.assertEquals('Warszawa', facilities[0].Address__City__s);
        
        String expectedOpeningHours = 'Niedziela: 8:00 - 18:00\nSobota: 8:00 - 16:00\nPiątek: 10:00 - 16:00\nCzwartek: 8:00 - 16:00\nŚroda: 8:00 - 18:00\nWtorek: 8:00 - 18:00\nPoniedziałek: 9:00 - 18:00';
    	System.assertEquals(expectedOpeningHours, facilities[0].Opening_Hours__c);
        
    }
    
    @isTest
	static void testFailExecute() 
    {
        String mockResponse = '[{"Phone":"+48 123 456 780","OpeningHours":{"Niedziela":"10:00 - 16:00","Sobota":"8:00 - 17:00","Piątek":"10:00 - 18:00","Czwartek":"9:00 - 18:00","Środa":"10:00 - 16:00","Wtorek":"8:00 - 16:00","Poniedziałek":"9:00 - 16:00"},"Name":"Zebra Opieki Zdrowotnej","Id":"YZ345679"}]';

        Test.setMock(HttpCalloutMock.class, new MockHttpResponse(401, mockResponse));
    
        Test.startTest();
        MedicalFacilitiesAPI api = new MedicalFacilitiesAPI();
        api.execute(null);
        Test.stopTest();
    
        List<Medical_Facility__c> facilities = [SELECT Id FROM Medical_Facility__c WHERE External_Id__c = 'YZ345679'];
        System.assertEquals(0, facilities.size());
    }
        
   	@isTest
    static void testEmptyResponse() 
    {
        String response = '';
    
        Test.startTest();
        try
        {
            MedicalFacilitiesAPI.parseAndUpsertResponse(response);
        }
        catch(Exception e)
        {
            System.assertEquals('No content to map to Object due to end of input', e.getMessage());
        }
        
        Test.stopTest();
    
        List<Medical_Facility__c> facilities = [SELECT Id FROM Medical_Facility__c];
        System.assertEquals(0, facilities.size());
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