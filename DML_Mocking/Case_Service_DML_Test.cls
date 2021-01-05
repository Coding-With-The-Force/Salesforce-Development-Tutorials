@isTest
public with sharing class Case_Service_DML_Test {
    @isTest
    private static void doCaseUpdates_NoMocking_Test(){
        Case newCase = new Case(Subject = 'Taco Bell');
        insert newCase;

        Set<Id> caseIds = new Set<Id>{newCase.Id};

        Test.startTest();
            Case_Service caseUpdater = new Case_Service();
            caseUpdater.doCaseUpdates(caseIds);
        Test.stopTest();
    }
}
