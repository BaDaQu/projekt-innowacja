public class FacilityMapHelper { 
    @AuraEnabled(cacheable=true)
    public static string getStreets(string name){
        Medical_Facility__c mf = new Medical_Facility__c();
        mf = [SELECT Address__c FROM Medical_Facility__c WHERE Medical_Facility_Name__c=:name];
        return mf.Address__c.getStreet();
    }
    @AuraEnabled(cacheable=true)
    public static string getCitys(string name){
        Medical_Facility__c mf = new Medical_Facility__c();
        mf = [SELECT Address__c FROM Medical_Facility__c WHERE Medical_Facility_Name__c=:name];
        return  mf.Address__c.getCity();
    }
    @AuraEnabled(cacheable=true)
    public static string getPostalCodes(string name){
        Medical_Facility__c mf = new Medical_Facility__c();
        mf = [SELECT Address__c FROM Medical_Facility__c WHERE Medical_Facility_Name__c=:name];
        return mf.Address__c.getPostalCode();
    }
    @AuraEnabled(cacheable=true)
    public static string getCountrys(string name){
        Medical_Facility__c mf = new Medical_Facility__c();
        mf = [SELECT Address__c FROM Medical_Facility__c WHERE Medical_Facility_Name__c=:name];
        return mf.Address__c.getCountry();
    }
}