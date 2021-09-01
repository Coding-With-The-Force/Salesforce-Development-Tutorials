/**
 * Created by gerry on 8/31/2021.
 */
@RestResource(UrlMapping='/Users/*')
global with sharing class Users_Rest_Resource
{
	@HttpGet
	global static List<User> getUsers(){
		RestRequest req = RestContext.request;
		System.debug(req.params);
		List<User> users = [SELECT Id, FirstName, LastName FROM User LIMIT 10];
		return users;
	}

	@HttpPost
	global static String insertUser(User newUser){
		System.debug('This is a user ::: ' + newUser);
		insert newUser;
		return newUser.Id;
	}
}