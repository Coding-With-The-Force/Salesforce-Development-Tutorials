public class GitHubAuthCallout_NoCredential {
    
    public static void callGitHub()
    {
    	HttpRequest req = new HttpRequest();
        req.setEndpoint('https://api.github.com/users/Coding-With-The-Force/repos');
        req.setMethod('GET');
        req.setHeader('Authorization', 'token [your_github_token]');
        req.setHeader('Accept', 'application/json');
        req.setHeader('Content-Type', 'application/json');
        Http http = new Http();
        HTTPResponse res = http.send(req);
        System.debug(res.getBody());
    }

}