public with sharing class Query_Cases {

    public List<Case> selectCases(set<Id> caseIds){
        return [SELECT Id, Subject FROM Case WHERE Id IN: caseIds];
    } 
}
