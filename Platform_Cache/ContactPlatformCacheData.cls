/**
 * Created by gerry on 9/21/2021.
 */

public with sharing class ContactPlatformCacheData implements Cache.CacheBuilder
{
	public Object doLoad(String contactId){
		Contact cont = [SELECT Id, FirstName, LastName, AccountId FROM Contact WHERE Id = :contactId LIMIT 1];
		return cont;
	}
}