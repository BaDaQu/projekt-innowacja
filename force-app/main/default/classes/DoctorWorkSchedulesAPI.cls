public class DoctorWorkSchedulesAPI implements Schedulable
{
    private String endpoint = 'DoctorWorkSchedules';
    
    public void execute(SchedulableContext context)
    {
        String accessToken = RestHelper.getAccessToken();
        if(accessToken == null)
        {
            System.debug('DoctorWorkSchedulesAPI job failed - could not get the access token.');
			return;
        }
        
        String response = RestHelper.getResponseBody(accessToken, endpoint);
        if(response == null)
        {
            System.debug('DoctorWorkSchedulesAPI job failed - could not get the response body.');
            return;
        }
   		
        parseAndUpsertResponse(response);
        
    }
    
    public static void parseAndUpsertResponse(String Response)
    {
        List<Person__c> persons = new List<Person__c>();
        
        List<DoctorClass> doctors;
        
		doctors = (List<DoctorClass>) JSON.deserialize(response, List<DoctorClass>.class);    
        
        final Id DOCTOR_RECORD_TYPE_ID = Schema.SObjectType.Person__c.getRecordTypeInfosByDeveloperName().get('Doctor').getRecordTypeId();
        
        for(DoctorClass doctor : doctors)
        {
            Person__c person = new Person__c();
            person.FirstName__c = doctor.FirstName;
            person.LastName__c = doctor.LastName;
            person.RecordTypeId = DOCTOR_RECORD_TYPE_ID;
            person.Personal_ID_Number__c = doctor.PESEL;
            person.External_Id__c = doctor.DoctorId;
            
            String schedule = parseDoctorWorkSchedules(doctor);
            if(schedule != null)
            {
                person.Doctor_Work_Schedule__c = schedule;
            }
            
            persons.add(person);
        }
        
        Database.UpsertResult[] result = Database.upsert(persons, Person__c.Fields.External_Id__c, false);
        
        for(Integer i = 0; i < result.size(); i++)
        {
            if(!result[i].isSuccess())
            {
                System.debug('Nie udało się upsertować rekordu: ' + persons[i]);
                System.debug('Błąd: ' + result[i].getErrors()[0].getMessage());
            }
        }
        
    }
    
    public static String parseDoctorWorkSchedules(DoctorClass doctor)
    {
        if(doctor.Schedule != null)
        {
            String schedule = '';
            for(String day : doctor.Schedule.keySet())
            {
                ScheduleClass hours = doctor.Schedule.get(day);
				schedule += day + ': ' + hours.StartTime + ' - ' + hours.EndTime + '\n';
            }
            return schedule;
        }
        
        return null;
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