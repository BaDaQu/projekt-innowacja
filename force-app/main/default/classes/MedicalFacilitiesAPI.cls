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
            
            facilities.add(facility); 
        }
        
        Database.UpsertResult[] upsertResult = Database.upsert(facilities, Medical_Facility__c.Fields.External_Id__c, false);
        
        Set<Id> facilitiesIds = new Set<Id>();
        
        for(Integer i = 0; i < upsertResult.size(); i++)
        {
            if(!upsertResult[i].isSuccess())
            {
                System.debug('Failed to upsert Medical_Facility__c record: ' + facilities[i]);
                System.debug('Error: ' + upsertResult[i].getErrors()[0].getMessage());
                facilityInstances.remove(i);
                facilities.remove(i);
            }
            else if(facilityInstances[i].OpeningHours != null)
            {
                facilitiesIds.add(upsertResult[i].getId());
            }
        }
        
        clearOpeningHours(facilitiesIds);
        
        List<Facility_Hours__c> facilityHours = parseOpeningHours(facilityInstances, facilities);
        
        Database.SaveResult[] insertResult = Database.insert(facilityHours, false);
        
        for(Integer i = 0; i < insertResult.size(); i++)
        {
            if(!insertResult[i].isSuccess())
            {
                System.debug('Failed to insert Facility_Hours__c record: ' + facilityHours[i]);
                System.debug('Error: ' + insertResult[i].getErrors()[0].getMessage());
            }
        }
        
    }
    
    public static void clearOpeningHours(Set<Id> facilitiesIds)
    {
        List<Facility_Hours__c> facilityHoursRecords = [SELECT Id FROM Facility_Hours__c WHERE Medical_Facility__c IN :facilitiesIds];
        
        List<Id> facilityHoursToDelete = new List<Id>();
        
        for(Facility_Hours__c facilityHours : facilityHoursRecords)
        {
            facilityHoursToDelete.add(facilityHours.Id);
        }
        
        Database.DeleteResult[] deleteResult = Database.delete(facilityHoursToDelete, false);
        
        for(Integer i = 0; i < deleteResult.size(); i++)
        {
			if(!deleteResult[i].isSuccess())
            {
                System.debug('Failed to delete Facility_Hours__c record: ' + facilityHoursRecords[i]);
                System.debug('Error: ' + deleteResult[i].getErrors()[0].getMessage());
            }
        }
    }
    
    public static List<Facility_Hours__c> parseOpeningHours(List<MedicalFacilityClass> facilityInstances, List<Medical_Facility__c> facilities)
    {
        List<Facility_Hours__c> facilityHoursList = new List<Facility_Hours__c>();
        
        for(Integer i = 0; i < facilityInstances.size(); i++)
        {
            if(facilityInstances[i].OpeningHours != null)
            {
                for(String day : facilityInstances[i].OpeningHours.keySet())
                {
                    Facility_Hours__c facilityHoursInstance = new Facility_Hours__c();
                    String hoursUnparsed = facilityInstances[i].OpeningHours.get(day);
                    List<String> hoursList = hoursUnparsed.split('-');
                    facilityHoursInstance.Day_of_Week__c = day;
					facilityHoursInstance.Opening_Time__c = parseTime(hoursList[0].trim());
                    facilityHoursInstance.Closing_Time__c = parseTime(hoursList[1].trim());
                    facilityHoursInstance.Medical_Facility__c = facilities[i].Id;
                    
                    facilityHoursList.add(facilityHoursInstance);
                }
                
            }
        }
        
        return facilityHoursList;
    }
    
    public static Time parseTime(String hoursString)
    {
        List<String> openingTimeParts = hoursString.split(':');
		Time timeValue = Time.newInstance
		(
			Integer.valueOf(openingTimeParts[0]),
			Integer.valueOf(openingTimeParts[1]),
			0,
			0
		);
        
        return timeValue;
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