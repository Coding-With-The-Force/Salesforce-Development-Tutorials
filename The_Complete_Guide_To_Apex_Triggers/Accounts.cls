/**
 * Created by gerry on 5/1/2021.
 */

public inherited sharing class Accounts extends DomainObject
{
	List<Account> accounts = new List<Account>();
	Map<Id, Account> oldAccountMap = new Map<Id, Account>();

	public Accounts(List<Account> acctRecords){
		super(acctRecords);
		super.setFilter(new Set<String>{'Kewl_Record_Type'}, accounts, oldAccountMap);
	}

	public class Constructor implements fflib_SObjectDomain.IConstructable{
		public fflib_SObjectDomain construct(List<SObject> sObjectList){
			return new Accounts(sObjectList);
		}
	}

	public override void onBeforeUpdate(Map<Id, SObject> oldRecords){
		if(accounts.isEmpty() ){
			System.debug('You had no matching records');
			return;
		}
		System.debug('You had matching records');
	}
}