@isTest
public class RestHelperTest 
{
    @isTest
    static void testGetAccessToken()
    {
		Test.setMock(HttpCalloutMock.class, new TokenMock());
    
		Test.startTest();
		String accessToken = RestHelper.getAccessToken();
		Test.stopTest();

		System.assertNotEquals(null, accessToken, 'Access token should not be null');
		System.assertEquals('mock_access_token', accessToken, 'Access token should match the mocked value');
	}
    
    @isTest
    static void testGetResponseBody()
    {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(200));
        
        Test.startTest();
        String response = RestHelper.getResponseBody('mock_access_token', 'MedicalFacilities');
        Test.stopTest();
        
        System.assertEquals('[{"Name":"Test Facility","Id":"123","Email":"test@facility.com","Phone":"+48 123 456 789"}]', response, 'Result should be null');
    }
    
    @isTest
    static void testFailureGetResponseBody()
    {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(401));
        
        Test.startTest();
        String response = RestHelper.getResponseBody('mock_access_token', 'MedicalFacilities');
        Test.stopTest();
        
        System.assertEquals(null, response, 'Result should be null');
    }
        
    
    public class TokenMock implements HttpCalloutMock 
	{
        public HTTPResponse respond(HTTPRequest req)
        {
            HttpResponse res = new HttpResponse();
            res.setStatusCode(200);
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"access_token":"mock_access_token","token_type":"Bearer","issued_at":"1672531200000"}');
            return res;
        }
    }
    
    private class MockHttpResponseGenerator implements HttpCalloutMock 
    {
        private Integer statusCode;
       
        MockHttpResponseGenerator(Integer code)
        {
            statusCode = code;
        }
    
        public HTTPResponse respond(HTTPRequest req) 
        {
            HttpResponse res = new HttpResponse();
            res.setStatusCode(statusCode);
            res.setHeader('Content-Type', 'application/json');
            res.setBody('[{"Name":"Test Facility","Id":"123","Email":"test@facility.com","Phone":"+48 123 456 789"}]');
            return res;
       	}
    }

}