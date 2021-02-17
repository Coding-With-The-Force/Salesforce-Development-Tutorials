/**
 * Created by gerry on 2/16/2021.
 */
@RestResource(UrlMapping='/AccountDML/*')
global with sharing class REST_Service
{
	@HttpPost
	global static String insertAccount(Account acct){
		insert acct;
		return acct.Id;
	}
}