public class NotifyAdmins 
{
    public static void sendEmails(String subject, String body)
    {
        NotifyAdminsEmails__c adminList = NotifyAdminsEmails__c.getValues('AdminEmailsList');    
                  
		if(adminList == null || String.isBlank(adminList.AdminEmails__c)) 
        {
            System.debug('AdminEmailList is not configured in Custom Settings.');
            return;
        }
        
        List<String> admins = adminList.AdminEmails__c.split(',');
        
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
        for(String admin : admins) 
        {
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(new String[] { admin.trim() });
            mail.setSubject(subject);
            mail.setPlainTextBody(body);
            
            emails.add(mail);
        }
                
		Messaging.sendEmail(emails);
        
    }
}