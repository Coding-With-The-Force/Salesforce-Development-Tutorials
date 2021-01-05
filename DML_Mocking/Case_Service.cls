public with sharing class Case_Service {
    private Query_Cases caseQuery;
    private DML_Cases caseDML;

    public Case_Service() {
        this(new Query_Cases(), new DML_Cases());
    }

    @testVisible
    private Case_Service(Query_Cases caseQuery, DML_Cases caseDML){
        this.caseQuery = caseQuery;
        this.caseDML = caseDML;
    }

    public void doCaseUpdates(Set<Id> caseIds){
        List<Case> caseList = caseQuery.selectCases(caseIds);
        caseDML.updateCases(caseList);
    }
}
