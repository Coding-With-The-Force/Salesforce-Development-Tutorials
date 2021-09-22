/**
 * Created by gerry on 9/21/2021.
 */

public with sharing class PartitionCacheExampleController
{
	@AuraEnabled
	public static void storeDataController(){
		Contact cont = [SELECT Id, FirstName, LastName, AccountId FROM Contact WHERE Id = '0034R00003oGP8PQAW' LIMIT 1];
		Cache.Session.put('ContactFound', cont);
		Cache.Session.put('local.TacoCat.ContactFound', cont);
	}

	@AuraEnabled
	public static Contact retrieveDataCacheController(){
		return (Contact) Cache.Session.get('ContactFound');
	}

	@AuraEnabled
	public static Contact retrieveDataSOQLController(){
		return [SELECT Id, FirstName, LastName, AccountId FROM Contact WHERE Id = '0034R00003oGP8PQAW' LIMIT 1];
	}
}