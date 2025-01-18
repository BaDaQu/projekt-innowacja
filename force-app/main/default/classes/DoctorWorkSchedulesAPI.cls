public class DoctorWorkSchedulesAPI implements Schedulable
{
    //dociagnac pozniej layouty bo zmienione na doctorze by bylo widac godziny
    
    private String endpoint = 'DoctorWorkSchedules';
    
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
    
    public static void parseAndUpsertResponse(String Response)
    {
        List<Person__c> persons = new List<Person__c>();
        
        List<DoctorClass> doctors;
        
        try
        {
			doctors = (List<DoctorClass>) JSON.deserialize(response, List<DoctorClass>.class);    
        }
        catch(Exception e)
        {
            System.debug('Error parsing JSON response: ' + e.getMessage());
            return;
        }
        
        final Id DOCTOR_RECORD_TYPE_ID = Schema.SObjectType.Person__c.getRecordTypeInfosByDeveloperName().get('Doctor').getRecordTypeId();
        
        for(DoctorClass doctor : doctors)
        {
            Person__c person = new Person__c();
            person.FirstName__c = doctor.FirstName;
            person.LastName__c = doctor.LastName;
            person.Name = doctor.FirstName + ' ' + doctor.LastName;
            person.RecordTypeId = DOCTOR_RECORD_TYPE_ID;
            person.Personal_ID_Number__c = doctor.PESEL;
            person.External_Id__c = doctor.DoctorId;
            
            persons.add(person);
        }
        
        parseDoctorWorkSchedules(persons, doctors);
        
        try
        {
            upsert persons External_Id__c;
        }
        catch(Exception e)
        {
            System.debug('Error upserting Medical Facilities: ' + e.getMessage());
            return;
        }
        
    }
    
    public static void parseDoctorWorkSchedules(List<Person__c> persons, List<DoctorClass> doctors)
    {
        for(Integer i = 0; i < persons.size(); i++)
        {
            Person__c person = persons[i]; // needed for linking the relationship
            DoctorClass doctor = doctors[i];
            
            if(doctor.Schedule != null)
            {
                person.Doctor_Work_Schedule__c = '';
                for(String day : doctor.Schedule.keySet())
                {
                    ScheduleClass hours = doctor.Schedule.get(day);
					
                    person.Doctor_Work_Schedule__c += day + ': ' + hours.StartTime + ' - ' + hours.EndTime + '\n';
                }
            }
        }
    }
    
    public class DoctorClass
    {
        String FirstName;
        String LastName;
        String DoctorId;
        String PESEL;
        Map<String, ScheduleClass> Schedule;
    }
    
    public class ScheduleClass
    {
        public String EndTime;
        public String StartTime;
    }

}