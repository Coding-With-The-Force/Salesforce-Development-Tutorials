/**
 * Created by gerry on 2/16/2021.
 */

public with sharing class POST_Example
{
	public void sendPOSTReq(){
		HttpRequest req = new HttpRequest();
		req.setEndpoint('callout:SalesforcePOST');
		req.setMethod('POST');
		req.setHeader('Content-Type', 'application/json');
		String acctToPass = JSON.serialize(wrapAccount(generateAccount()));
		System.debug('This is the account JSON ::: ' + acctToPass);
		req.setBody(acctToPass);
		Http http = new Http();
		HttpResponse res = http.send(req);
		System.debug(res.getBody());
	}

	private Account generateAccount(){
		Account acct = new Account();
		acct.Name = 'Hi';
		acct.Phone = '8162221111';
		return acct;
	}

	private AccountWrapper wrapAccount(Account acct){
		AccountWrapper wrapper = new AccountWrapper();
		wrapper.acct = acct;
		return wrapper;
	}
}