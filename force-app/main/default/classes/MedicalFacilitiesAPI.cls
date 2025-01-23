public class MedicalFacilitiesAPI implements Schedulable
{
    private String endpoint = 'MedicalFacilities';
    
    public void execute(SchedulableContext context)
    {
        String accessToken = RestHelper.getAccessToken();
        if(accessToken == null)
        {
			System.debug('MedicalFacilitiesAPI job failed - could not get the access token.');
			return;
        }
        
        String response = RestHelper.getResponseBody(accessToken, endpoint);
        if(response == null)
        {
            System.debug('MedicalFacilitiesAPI job failed - could not get the response body.');
            return;
        }
   		
        parseAndUpsertResponse(response);
        
    }
    
    public static void parseAndUpsertResponse(String response) 
    {
        List<Medical_Facility__c> facilities = new List<Medical_Facility__c>();
        
        List<MedicalFacilityClass> facilityInstances;
        
		facilityInstances = (List<MedicalFacilityClass>) JSON.deserialize(response, List<MedicalFacilityClass>.class);    
        
        for(MedicalFacilityClass facilityInstance : facilityInstances) 
        {
            Medical_Facility__c facility = new Medical_Facility__c();
            facility.Name = facilityInstance.Name;
            facility.Phone__c = facilityInstance.Phone;
            facility.Email__c = facilityInstance.Email;
            facility.Address__Street__s = facilityInstance.Address.Street;
            facility.Address__PostalCode__s = facilityInstance.Address.PostalCode;
            facility.Address__City__s = facilityInstance.Address.City;
            facility.External_Id__c = facilityInstance.Id;
            
            String openingHoursInstance = parseOpeningHours(facilityInstance);
            if(openingHoursInstance != null)
            {
                facility.Opening_Hours__c = openingHoursInstance;
            }
            
            facilities.add(facility); 
        }
        
        Database.UpsertResult[] result = Database.upsert(facilities, Medical_Facility__c.Fields.External_Id__c, false);
        
        for(Integer i = 0; i < result.size(); i++)
        {
            if(!result[i].isSuccess())
            {
                System.debug('Nie udało się upsertować rekordu: ' + facilities[i]);
                System.debug('Błąd: ' + result[i].getErrors()[0].getMessage());
            }
        }
        
    }
    
    public static String parseOpeningHours(MedicalFacilityClass facilityInstance)
    {
        if(facilityInstance.OpeningHours != null)
        {
            String openingHoursInstance = '';
            for(String day : facilityInstance.OpeningHours.keySet())
            {
                String hours = facilityInstance.OpeningHours.get(day);
                openingHoursInstance += day + ': ' + hours + '\n';
            }
            
            return openingHoursInstance;
        }
        
        return null;
    }
    
    public class MedicalFacilityClass
	{
    	public String Name;
        public String Phone;
        public String Email;
        public String Id;
        public AddressClass Address;
        public Map<String, String> OpeningHours;
	}
    
    public class AddressClass
    {
        public String Street;
        public String PostalCode;
        public String City;
    }

}