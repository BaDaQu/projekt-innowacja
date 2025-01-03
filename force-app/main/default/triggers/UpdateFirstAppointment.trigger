trigger UpdateFirstAppointment on Medical_Appointment__c (before update) {
    DateTime datetoday=System.now();
    for(Medical_Appointment__c m : Trigger.new){
        if (m.First_Appointment__c == true && m.Appointment_Time__c <= datetoday){
            m.First_Appointment__c = false;
        }
    }

}