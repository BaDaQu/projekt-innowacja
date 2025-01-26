@isTest
public class TestMedicalFacilitiesAPI 
{  

    @isTest
    static void testValidResponse() 
    {
		Test.startTest();
        String response = '[{"Phone":"+48 123 456 780","OpeningHours":{"Niedziela":"8:00 - 18:00","Sobota":"8:00 - 16:00","Piątek":"10:00 - 16:00","Czwartek":"8:00 - 16:00","Środa":"8:00 - 18:00","Wtorek":"8:00 - 18:00","Poniedziałek":"9:00 - 18:00"},"Name":"Jeż Medyczny","Id":"AB123456","Email":"kontakt0@placowka.com","Address":{"Street":"Wiejska 1","PostalCode":"00-489","City":"Warszawa"}}]';

        MedicalFacilitiesAPI.parseAndUpsertResponse(response);

        //insert data from endpoint
        
        List<Medical_Facility__c> facilities = [SELECT Id, Name, Address__Street__s, Address__PostalCode__s, Address__City__s, Phone__c, Email__c, External_Id__c 
                                                FROM Medical_Facility__c WHERE External_Id__c =: 'AB123456'];
        
        System.assertEquals(1, facilities.size());
        System.assertEquals('Jeż Medyczny', facilities[0].Name);
        System.assertEquals('+48 123 456 780', facilities[0].Phone__c);
        System.assertEquals('kontakt0@placowka.com', facilities[0].Email__c);
        System.assertEquals('AB123456', facilities[0].External_Id__c);
        System.assertEquals('Wiejska 1', facilities[0].Address__Street__s);
        System.assertEquals('00-489', facilities[0].Address__PostalCode__s);
        System.assertEquals('Warszawa', facilities[0].Address__City__s);
        
        List<Facility_Hours__c> facilityHours = [SELECT Id, Day_Of_Week__c, Opening_Time__c, Closing_Time__c, Is_Open__c 
                                                 FROM Facility_Hours__c WHERE Medical_Facility__c = :facilities[0].Id];
        
        List<String> days = new List<String>
        {
    		'Niedziela', 'Sobota', 'Piątek', 'Czwartek', 'Środa', 'Wtorek', 'Poniedziałek'
		};

        List<Time> openingHours = new List<Time>
        {
            Time.newInstance(8, 0, 0, 0),   // Niedziela
            Time.newInstance(8, 0, 0, 0),   // Sobota
            Time.newInstance(10, 0, 0, 0),  // Piątek
            Time.newInstance(8, 0, 0, 0),   // Czwartek
            Time.newInstance(8, 0, 0, 0),   // Środa
            Time.newInstance(8, 0, 0, 0),   // Wtorek
            Time.newInstance(9, 0, 0, 0)    // Poniedziałek
        };
        
        List<Time> closingHours = new List<Time>
        {
            Time.newInstance(18, 0, 0, 0),  // Niedziela
            Time.newInstance(16, 0, 0, 0),  // Sobota
            Time.newInstance(16, 0, 0, 0),  // Piątek
            Time.newInstance(16, 0, 0, 0),  // Czwartek
            Time.newInstance(18, 0, 0, 0),  // Środa
            Time.newInstance(18, 0, 0, 0),  // Wtorek
            Time.newInstance(18, 0, 0, 0)   // Poniedziałek
        };
            
		Set<Id> deletedFacilityHoursIds = new Set<Id>();
            
		for(Integer i = 0; i < days.size(); i++)
        {
            System.assertEquals(days[i], facilityHours[i].Day_Of_Week__c);
            System.assertEquals(openingHours[i], facilityHours[i].Opening_Time__c);
            System.assertEquals(closingHours[i], facilityHours[i].Closing_Time__c);
            deletedFacilityHoursIds.add(facilityHours[i].Id); //add ids of facility hours that will be deleted by updating the hours
        }
        
		String updatedResponse = '[{"Phone":"+48 123 456 789","OpeningHours":{"Niedziela":"10:00 - 18:00","Sobota":"10:00 - 16:00","Piątek":"12:00 - 16:00","Czwartek":"10:00 - 16:00","Środa":"10:00 - 18:00","Wtorek":"10:00 - 18:00","Poniedziałek":"11:00 - 18:00"},"Name":"Jeż Medyczny","Id":"AB123456","Email":"kontakt0@placowka.com","Address":{"Street":"Wiejska 1","PostalCode":"00-489","City":"Warszawa"}}]';
       
        //phone number and opening hours changed

        MedicalFacilitiesAPI.parseAndUpsertResponse(updatedResponse);
		
		List<Facility_Hours__c> deletedFacilityHours = [SELECT Id FROM Facility_Hours__c WHERE Id IN :deletedFacilityHoursIds];
        
        //check if old facility hours were deleted
        
        System.assertEquals(0, deletedFacilityHours.size());
        
		List<Medical_Facility__c> updatedFacilities = [SELECT Id, Name, Address__Street__s, Address__PostalCode__s, Address__City__s, Phone__c, Email__c, External_Id__c 
                                                FROM Medical_Facility__c WHERE External_Id__c =: 'AB123456'];
        
        System.assertEquals(1, updatedFacilities.size());
        System.assertEquals('Jeż Medyczny', updatedFacilities[0].Name);
        System.assertEquals('+48 123 456 789', updatedFacilities[0].Phone__c);
        System.assertEquals('kontakt0@placowka.com', updatedFacilities[0].Email__c);
        System.assertEquals('AB123456', updatedFacilities[0].External_Id__c);
        System.assertEquals('Wiejska 1', updatedFacilities[0].Address__Street__s);
        System.assertEquals('00-489', updatedFacilities[0].Address__PostalCode__s);
        System.assertEquals('Warszawa', updatedFacilities[0].Address__City__s);
        
        List<Facility_Hours__c> updatedFacilityHours = [SELECT Id, Day_Of_Week__c, Opening_Time__c, Closing_Time__c, Is_Open__c 
                                                 FROM Facility_Hours__c WHERE Medical_Facility__c = :facilities[0].Id];
        
        List<Time> updatedOpeningHours = new List<Time>
        {
            Time.newInstance(10, 0, 0, 0),   // Niedziela
            Time.newInstance(10, 0, 0, 0),   // Sobota
            Time.newInstance(12, 0, 0, 0),  // Piątek
            Time.newInstance(10, 0, 0, 0),   // Czwartek
            Time.newInstance(10, 0, 0, 0),   // Środa
            Time.newInstance(10, 0, 0, 0),   // Wtorek
            Time.newInstance(11, 0, 0, 0)    // Poniedziałek
        };
        
		System.assertEquals(7, updatedFacilityHours.size());
        
		for(Integer i = 0; i < days.size(); i++)
        {
            System.assertEquals(days[i], updatedFacilityHours[i].Day_Of_Week__c);
            System.assertEquals(updatedOpeningHours[i], updatedFacilityHours[i].Opening_Time__c);
            System.assertEquals(closingHours[i], updatedFacilityHours[i].Closing_Time__c);
        }
        
		Test.stopTest();
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