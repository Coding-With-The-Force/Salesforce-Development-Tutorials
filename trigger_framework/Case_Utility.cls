public with sharing class Case_Utility 
{
    private static final String HANDLER_NAME = 'Case_Trigger_Handler';

    public static void updateCaseSubject(List<Case> caseList)
    {
        for(Case cs: caseList)
        {
            cs.Subject = 'Kewl New Subject';
        }
    }
    
    public static void createCase()
    {
        TriggerHandler.bypass(HANDLER_NAME);

        Case newCase = new Case();
        newCase.Subject = 'Awesome Case';
        insert newCase;

        TriggerHandler.clearBypass(HANDLER_NAME);

    }
}
