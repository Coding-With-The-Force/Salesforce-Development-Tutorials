public with sharing class ContactGrabber {
    @AuraEnabled
    public static List<Contact> getAllRelatedContacts(Id acctId){
        return [SELECT Id, FirstName, LastName FROM Contact WHERE AccountId = :acctId];
    }
}
