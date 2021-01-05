@isTest
public with sharing class Case_Service_Test {
    @isTest
    private static void doCaseUpdates_Test(){
        MockSObjectBuilder mockCase = new MockSObjectBuilder(Case.getSObjectType());
        Case caseRecord = (Case)mockCase.setId().setField('Subject', 'Hey Gurl').build();
        List<Case> returnedCases = new List<Case>{caseRecord};
        Set<Id> caseIds = new Set<Id>{caseRecord.Id};

        final String CASE_QUERY_METHOD = 'selectCases';
        final String CASE_DML_METHOD = 'updateCases';

        UniversalMocker caseDML_Mock = UniversalMocker.mock(DML_Cases.class);
        caseDML_Mock.when(CASE_DML_METHOD).withParamTypes(new List<Type>{List<Case>.class}).thenReturn(returnedCases);
        DML_Cases caseDML = (DML_Cases)caseDML_Mock.createStub();

        UniversalMocker caseQuery_Mock = UniversalMocker.mock(Query_Cases.class);
        caseQuery_Mock.when(CASE_QUERY_METHOD).withParamTypes(new List<Type>{Set<Id>.class}).thenReturn(returnedCases);
        Query_Cases caseQueries = (Query_Cases)caseQuery_Mock.createStub();

        Test.startTest();
            Case_Service caseService = new Case_Service(caseQueries, caseDML);
            caseService.doCaseUpdates(caseIds);
            caseDML_Mock.assertThat().method(CASE_DML_METHOD).withParamTypes(new List<Type>{List<Case>.class}).wasCalled(1, UniversalMocker.Times.EXACTLY);
            caseQuery_Mock.assertThat().method(CASE_QUERY_METHOD).withParamTypes(new List<Type>{Set<Id>.class}).wasCalled(1, UniversalMocker.Times.EXACTLY);
        Test.stopTest();
    }
}
