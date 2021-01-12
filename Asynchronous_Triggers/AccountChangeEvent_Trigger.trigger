//If you want to debug this you need to put a log on the Automated System User. It is the only way to debug these triggers.
trigger AccountChangeEvent_Trigger on AccountChangeEvent (after insert) {
    System.debug('This is the Account Change Event Trigger Size ::: ' + trigger.new.size());

    //Everything you really care about in the ChangeEvent objects are in the ChangeEventHeader. Make sure to
    //pull your data from the ChangeEvent header to do what you need to do.
    for(AccountChangeEvent ace: trigger.new){
        EventBus.ChangeEventHeader aceHeader = ace.ChangeEventHeader;
        List<String> acctIds = aceHeader.getRecordIds();
        String userId = aceHeader.getCommitUser();
        
    }
}