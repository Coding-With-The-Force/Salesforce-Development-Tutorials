/**
 * Created by gerry on 9/6/2022.
 */

public with sharing class Accounts_Marketing extends DomainObject
{
	List<Account> accounts = new List<Account>();
	Map<Id, Account> oldAccountMap = new Map<Id, Account>();

	public Accounts_Marketing(List<Account> acctRecords){
		super(acctRecords);
		super.setFilter(new Set<String>{'NonKewl_Record_Type'}, accounts, oldAccountMap);
	}

	public class Constructor implements fflib_SObjectDomain.IConstructable{
		public fflib_SObjectDomain construct(List<SObject> sObjectList){
			return new Accounts_Marketing(sObjectList);
		}
	}

	public override void onBeforeUpdate(Map<Id, SObject> oldRecords){
		if(accounts.isEmpty() ){
			System.debug('You had no matching records non kewl');
			return;
		}
		System.debug('You had matching records non kewl');
	}
}