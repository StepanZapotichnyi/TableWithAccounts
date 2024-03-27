global with sharing class AccountHttpCalloutMock implements HttpCalloutMock{
    global Integer statusCode;
    global String body;
    
    global AccountHttpCalloutMock(Integer statusCode, String body) {
        this.statusCode = statusCode;
        this.body = body;

    }

    global HttpResponse respond(HttpRequest req) {
        System.assertNotEquals(null, req.getEndpoint(), 'Endpoint should not be null');

        HttpResponse res = new HttpResponse();
        res.setStatusCode(statusCode);
        res.setHeader('content-type', 'application/json; charset=UTF-8');
        res.setHeader('Accept', 'application/json');
        res.setbody(body);
        
        return res;
    }
}