/**
 * Created by gerry on 9/28/2021.
 */

public with sharing class CloneRecords_Service
{
	private Clone_Interface cloneLogic;
	public CloneRecords_Service(Clone_Interface cloneClass){
		this.cloneLogic = cloneClass;
	}

	public void cloneRecord(Id recordId){
		cloneLogic.cloneRecord(recordId);
	}

	public void cloneRelatedRecords(Id recordId){
		cloneLogic.cloneRelatedRecords(recordId);
	}
}