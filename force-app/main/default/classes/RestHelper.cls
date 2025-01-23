public class RestHelper 
{
    public static String getAccessToken() 
    {
        String clientId = '3MVG9xqN3LZmHU7n7G0NHUYpNLMsh55X1HNRUcsBJ5Dtevv.S1jOSgyx3l3DQXqRc1md0qpR_l7ewk1oK4Oa9';
        String clientSecret = 'F5CF486958B3E03C7FEF2A26DDB959301FCD7CDF34F3736F51A409D5B378402F';
        String username = 'restuser@innowacja.rest.rest';
        String password = 'Haslo123!!7NNzLKGSAIj6gtkTJbRFAjUX'; // hasło + securityToken
        String endpoint = 'https://cw-inn--rest.sandbox.my.salesforce.com/services/oauth2/token';

        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endpoint);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/x-www-form-urlencoded');

        //key = value
        String requestBody = 'grant_type=password'
                           + '&client_id=' + EncodingUtil.urlEncode(clientId, 'UTF-8')
                           + '&client_secret=' + EncodingUtil.urlEncode(clientSecret, 'UTF-8')
                           + '&username=' + EncodingUtil.urlEncode(username, 'UTF-8')
                           + '&password=' + EncodingUtil.urlEncode(password, 'UTF-8');

        request.setBody(requestBody);

		HttpResponse response = http.send(request);
        
		if(response.getStatusCode() == 200) 
		{
			Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
			String accessToken = (String) responseMap.get('access_token');
			return accessToken;
		} 
		else 
		{
			System.debug('Failed to retrieve access token. Status: ' + response.getStatusCode());
			System.debug('Response: ' + response.getBody());
			return null;
		}
        
    }
    
    public static String getResponseBody(String accessToken, String endpoint) 
    {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://cw-inn--rest.sandbox.my.salesforce.com/services/apexrest/' + endpoint);
        request.setMethod('GET');
        request.setHeader('Authorization', 'Bearer ' + accessToken);
        
        HttpResponse response = http.send(request);

        String responseBody = response.getBody();
        
        if(response.getStatusCode() == 200)
      	{
			return responseBody;
		}
		else
		{
			System.debug('GET callout failed! Status code: ' + response.getStatusCode());
			System.debug('Response body: ' + responseBody);
			return null;
		}

    }

}