public class GithubOAuthCallout {
    
    public static void callGitHub()
    {
    	HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:GitHub_OAuth' + '/users/Coding-With-The-Force/repos');
        req.setMethod('GET');
        req.setHeader('Accept', 'application/json');
        req.setHeader('Content-Type', 'application/json');
        Http http = new Http();
        HTTPResponse res = http.send(req);
        System.debug(res.getBody());
    }
}