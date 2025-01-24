public class FacilityMapHelper {
    @AuraEnabled(cacheable=true)
    public static string getStreets(string name){
        system.debug('street   '+name);
        Medical_Facility__c mf = new Medical_Facility__c();
        mf = [SELECT Address__c FROM Medical_Facility__c WHERE Medical_Facility_Name__c=:name];
        system.debug(mf.Address__c.getStreet());
        string s = mf.Address__c.getStreet();
        return s;
    }
    @AuraEnabled(cacheable=true)
    public static string getCitys(string name){
        system.debug('city   '+name);
        Medical_Facility__c mf = new Medical_Facility__c();
        mf = [SELECT Address__c FROM Medical_Facility__c WHERE Medical_Facility_Name__c=:name];
        system.debug(mf.Address__c.getCity());
		string s = mf.Address__c.getCity();
        return s;
    }
    @AuraEnabled(cacheable=true)
    public static string getPostalCodes(string name){
        system.debug('code   '+name);
        Medical_Facility__c mf = new Medical_Facility__c();
        mf = [SELECT Address__c FROM Medical_Facility__c WHERE Medical_Facility_Name__c=:name];
        system.debug(mf.Address__c.getPostalCode());
		string s = mf.Address__c.getPostalCode();
        return s;
    }
    @AuraEnabled(cacheable=true)
    public static string getCountrys(string name){
        system.debug('country   '+name);
        Medical_Facility__c mf = new Medical_Facility__c();
        mf = [SELECT Address__c FROM Medical_Facility__c WHERE Medical_Facility_Name__c=:name];
        system.debug(mf.Address__c.getCountry());
		string s = mf.Address__c.getCountry();
        return s;
    }
}