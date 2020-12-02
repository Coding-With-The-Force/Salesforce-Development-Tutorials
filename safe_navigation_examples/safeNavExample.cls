public with sharing class safeNavExample {

    public static void noSafeNav(){
        List<Account> acctList = [SELECT Id, Name FROM Account WHERE Name = 'Kevin' LIMIT 1];
        if(!acctList.isEmpty()){
            String acctName = acctList[0].Name;
        }
        System.debug('This is the account name ::: ' + acctList.size());
    }

    public static void safeNav(){
        String acctName = [SELECT Id, Name FROM Account WHERE Name = 'Kevin' LIMIT 1]?.Name;
        System.debug('This is the account name ::: ' + acctName);
    }

    public static void safeNavMap(){
        Map<Id, Account> acctMap = new Map<Id, Account>([SELECT Id, Name FROM Account WHERE Name = 'sForce' LIMIT 1]);
        List<Account> acctList = [SELECT Id, Name FROM Account];

        for(Account acct: acctList){
            String acctFoundName = acctMap.get(acct.Id)?.Name;
            System.debug('This is the name of the account ::: ' + acctFoundName);
        }
    }

    public static void noSafeNavMap(){
        Map<Id, Account> acctMap = new Map<Id, Account>([SELECT Id, Name FROM Account WHERE Name = 'sForce' LIMIT 1]);
        List<Account> acctList = [SELECT Id, Name FROM Account];

        for(Account acct: acctList){
            Account acctFound = acctMap.get(acct.Id);
            if(acctFound != null){
                String acctFoundName = acctFound.Name;
                System.debug('This is the name of the account ::: ' + acctFoundName);
            }
            
        }
    }
}
