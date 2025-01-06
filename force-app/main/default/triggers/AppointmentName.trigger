trigger AppointmentName on Medical_Appointment__c (before insert,before update) {
    for(Medical_Appointment__c m : Trigger.new){
        String name='';
        if(m.Medical_Facility__r!=null && m.Medical_Facility__r.Name!=null){        
            name+='[' + m.Medical_Facility__r.Name + ']-';
        }else{
            name+='[??]-';
        }
        
         if (m.Doctor__r != null && m.Doctor__r.LastName__c != null) {
            name += '[' + m.Doctor__r.LastName__c + ']-';
        } else {
            name += '[??]-';
        }

        if (m.Patient__r != null && m.Patient__r.LastName__c != null) {
            name += '[' + m.Patient__r.LastName__c + ']-';
        } else {
            name += '[??]-';
        }

        if(m.Appointment_Time__c!=null){
            name+= '[' + m.Appointment_Time__c.format('dd-MM-yyyy') + ']';
        }else{
            name+='[??]';
        }
        m.Name=name;
    }
}