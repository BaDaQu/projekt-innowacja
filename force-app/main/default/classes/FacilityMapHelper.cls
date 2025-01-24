public class FacilityMapHelper {
    @AuraEnabled(cacheable=true)
    public static string getStreet(Id facID){
        Medical_Facility__c mf = new Medical_Facility__c();
        mf = [SELECT Address__c FROM Medical_Facility__c WHERE Medical_Facility__c.ID=:facID  LIMIT 1];
        return mf.Address__Street__s;
    }
    public static string getCity(Id facID){
        Medical_Facility__c mf = new Medical_Facility__c();
        mf = [SELECT Address__c FROM Medical_Facility__c WHERE Medical_Facility__c.ID=:facID  LIMIT 1];
        return mf.Address__City__s;
    }
    public static string getPostalCode(Id facID){
        Medical_Facility__c mf = new Medical_Facility__c();
        mf = [SELECT Address__c FROM Medical_Facility__c WHERE Medical_Facility__c.ID=:facID  LIMIT 1];
        return mf.Address__PostalCode__s;
    }
    public static string getCountry(Id facID){
        Medical_Facility__c mf = new Medical_Facility__c();
        mf = [SELECT Address__c FROM Medical_Facility__c WHERE Medical_Facility__c.ID=:facID  LIMIT 1]; 
        return mf.Address__CountryCode__s;
    }
}