trigger PersonNameTrigger on Person__c (before insert, before update) {
    for (Person__c person : Trigger.new) {
        if (person.FirstName__c != null && person.LastName__c != null) {
          person.Name = person.FirstName__c + ' ' + person.LastName__c;
        }
        
    }
   
}