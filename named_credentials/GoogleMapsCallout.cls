public class GoogleMapsCallout {
	
    private static final String GEOCODE_PATH = '/maps/api/geocode/json?';
    private static final String ADDRESS_VARIABLE = 'address=1600+Amphitheatre+Parkway+Mountain+View,+CA';
    private static final String KEY_VARIABLE = '&key=[your_google_api_key]';
    
    public static void callGoogleMaps()
    {
    	HttpRequest req = new HttpRequest();
        req.setEndpoint('https://maps.googleapis.com' + GEOCODE_PATH + ADDRESS_VARIABLE + KEY_VARIABLE);
        req.setMethod('GET');
        Http http = new Http();
        HTTPResponse res = http.send(req);
        System.debug(res.getBody());
    }
}