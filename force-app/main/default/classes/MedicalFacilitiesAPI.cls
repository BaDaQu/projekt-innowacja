public class MedicalFacilitiesAPI implements Schedulable
{
    private String endpoint = 'MedicalFacilities';
    
    public void execute(SchedulableContext context)
    {
        String accessToken = RestHelper.getAccessToken();
        if(accessToken == null)
        {
           return;
        }
        
        String response = RestHelper.getResponseBody(accessToken, endpoint);
        if(response == null)
        {
            return;
        }
   		
        parseAndUpsertResponse(response);
        
    }
    
    public static void parseAndUpsertResponse(String response) 
    {
        List<Medical_Facility__c> facilities = new List<Medical_Facility__c>();
        
        List<MedicalFacilityClass> facilityInstances;
        
        try
        {
			facilityInstances = (List<MedicalFacilityClass>) JSON.deserialize(response, List<MedicalFacilityClass>.class);    
        }
        catch(Exception e)
        {
            System.debug('Error parsing JSON response: ' + e.getMessage());
            return;
        }
        
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
            
            facilities.add(facility); 
        }

        parseOpeningHours(facilities, facilityInstances);
        
		try
        {
            upsert facilities External_Id__c;
        }
        catch(Exception e)
        {
            System.debug('Error upserting Medical Facilities: ' + e.getMessage());
            return;
        }
        
    }
    
    public static void parseOpeningHours(List<Medical_Facility__c> facilities, List<MedicalFacilityClass> facilityInstances)
    {
        for(Integer i = 0; i < facilities.size(); i++) 
        {
            Medical_Facility__c facility = facilities[i];
            MedicalFacilityClass facilityInstance = facilityInstances[i];
    
            if(facilityInstance.OpeningHours != null) 
            {
                facility.Opening_Hours__c = '';
                for(String day : facilityInstance.OpeningHours.keySet()) 
                {
                    String hours = facilityInstance.OpeningHours.get(day);
    				facility.Opening_Hours__c += day + ': ' + hours + '\n';
                }
            }
    	}
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