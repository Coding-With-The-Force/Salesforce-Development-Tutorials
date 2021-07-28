/**
 * Created by gerry on 7/24/2021.
 */

public with sharing class NebulaComponent_Controller
{
	private static String nebulaId;

	@AuraEnabled
	public static void setupCache(){
		Cache.Session.put('IsNewLoad', true);
	}

	@AuraEnabled
	public static void logWarning(Id recordId){
		System.debug('This is a warning debug log');
		Logger.warn('This is a warning debug log');
		LogEntryEventBuilder logEvent = Logger.warn('This is a wanrning debug log for a record', recordId);
		Logger.error('This is an error', recordId);
		logEvent.setTopics(new List<String>{'WARNING'});
		Logger.saveLog();
		//saveNebulaLog();
	}

	@AuraEnabled
	public static void logDebug(Id recordId){
		Logger.debug('This is a regular debug log');
		LogEntryEventBuilder logEvent = Logger.debug('This is a regular debug log for a record');
		logEvent.setRecord(recordId);
		logEvent.setTopics(new List<String>{'DANGER'});
		Logger.saveLog();
		//saveNebulaLog();
	}

	private static void saveNebulaLog(){
		Boolean isNewLoad = (Boolean)Cache.Session.get('IsNewLoad');
		if(isNewLoad){
			nebulaId = Logger.getTransactionId();
			Cache.Session.put('nebulaId', Logger.getTransactionId());
			Cache.Session.put('IsNewLoad', false);
			Logger.saveLog();
			saveAccount();
		}
		else{
			String parentNebulaId = (String)Cache.Session.get('nebulaId');
			Logger.debug('This is the static id : ' + nebulaId + ' : This is the cached Id : ' + parentNebulaId);
			Logger.setParentLogTransactionId(parentNebulaId);
			Logger.saveLog();
			saveAccount();
		}
	}

	private static void saveAccount(){
		Account acct = new Account(Name='Kewl Account');
		insert acct;
	}
}