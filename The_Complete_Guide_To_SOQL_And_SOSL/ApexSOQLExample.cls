public class ApexSOQLExample {
    public static void queryForAccounts(){
        Integer minimumAnnualRevenue = 5000;
        Set<String> accountTypes = new Set<String>{'Customer - Direct', 'Customer - Channel'};
        List<Account> acctList = [SELECT Id, Name, Type FROM Account WHERE Type IN :accountTypes];
        Map<Id, Account> acctMap = 
            new Map<Id, Account>([SELECT Id, Name, Type FROM Account WHERE Type IN :accountTypes]);
        System.debug('This is my list ::: ' + acctMap.values());
    }
    
    public static void dynamicAccountQuery(){
        Set<String> accountTypes = new Set<String>{'Customer - Direct', 'Customer - Channel'};
        String queryString = 'SELECT Id, Name FROM Account WHERE Type IN :accountTypes';
        List<Account> acctList = Database.query(queryString);
        System.debug('This is my list ::: ' + acctList);
    }
    
    public static void queryBenchmarkingExample(){
        System.debug('CPU Time 1 ::: ' + Limits.getCpuTime());
        List<Account> acctList = [SELECT Id, Name FROM Account WHERE Name = 'Taco'];
        System.debug('CPU Time 2 ::: ' + Limits.getCpuTime());
        for(Account acct: acctList){
            acct.Name = 'Bob';
        }
        System.debug('CPU Time 3 ::: ' + Limits.getCpuTime());
    }
}