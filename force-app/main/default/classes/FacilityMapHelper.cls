public class FacilityMapHelper { 
    @AuraEnabled(cacheable=true)
    public static string getAddress(string name){
        Medical_Facility__c mf = new Medical_Facility__c();
        mf = [SELECT Address__c FROM Medical_Facility__c WHERE Medical_Facility_Name__c=:name];
        return JSON.serializepretty(mf.Address__c);
    }
}