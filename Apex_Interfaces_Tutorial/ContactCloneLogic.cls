/**
 * Created by gerry on 9/28/2021.
 */

public with sharing class ContactCloneLogic implements Clone_Interface
{
	public void cloneRecord(Id recordId){
		System.debug('This is the contact clone logic running');
	}

	public void cloneRelatedRecords(Id recordId){
		System.debug('This is the contact clone related records logic running');
	}
}