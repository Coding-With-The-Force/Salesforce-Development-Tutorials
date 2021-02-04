public with sharing class Reddit_Post_Retriever {
    private static final String REDDIT_URL = 'https://www.reddit.com/r/salesforce/hot.json?limit=1';
    private static final String GET = 'GET';

    public static List<Salesforce_Reddit.Data> getRedditData(){
        List<Salesforce_Reddit.Data> redditData = new List<Salesforce_Reddit.Data>();
        
        Http httpCallout = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(REDDIT_URL);
        req.setMethod(GET);

        HttpResponse redditResponse = httpCallout.send(req);
        Salesforce_Reddit redditPostResponse = Salesforce_Reddit.parse(redditResponse.getBody());
        List<Salesforce_Reddit.Children> redditPosts = redditPostResponse.data.children;
        
        for(Salesforce_Reddit.Children child: redditPosts){
            redditData.add(child.data);
        }

        for(Salesforce_Reddit.Data data: redditData){
            System.debug(data.author);
            System.debug(data.title);
            System.debug(data.url);
        }

        return redditData;
    }
}
