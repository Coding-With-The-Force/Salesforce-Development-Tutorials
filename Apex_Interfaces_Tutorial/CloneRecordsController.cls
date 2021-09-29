/**
 * Created by gerry on 9/28/2021.
 */

public with sharing class CloneRecordsController
{
	@AuraEnabled
	public static void cloneRecords(Id recordId, String className){
		Type cloneInterfaceType = Type.forName(className);
		Clone_Interface cloneInterfaceInstance = (Clone_Interface)cloneInterfaceType.newInstance();
		CloneRecords_Service cloneRecords = new CloneRecords_Service(cloneInterfaceInstance);
		cloneRecords.cloneRecord(recordId);
	}

	@AuraEnabled
	public static void cloneRelatedRecords(Id recordId, String className){
		Type cloneInterfaceType = Type.forName(className);
		Clone_Interface cloneInterfaceInstance = (Clone_Interface)cloneInterfaceType.newInstance();
		CloneRecords_Service cloneRecords = new CloneRecords_Service(cloneInterfaceInstance);
		cloneRecords.cloneRelatedRecords(recordId);
	}
}