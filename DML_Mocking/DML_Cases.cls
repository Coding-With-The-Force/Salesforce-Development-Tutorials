public with sharing class DML_Cases {
    public List<Case> updateCases(List<Case> caseList){
        database.update(caseList);
        return caseList;
    }
}
