public with sharing class HttpCallouts {
    
    public class HttpResponseWrapper {
        public Integer statusCode;
        public String responseBody;
    
        public HttpResponseWrapper(Integer code, String body) {
            statusCode = code;
            responseBody = body;
        }
    }
    
    public static HttpResponseWrapper executeHttpRequest(String endpoint, String method, String bodyData) {
        
        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:ReturnContact' + endpoint);
        request.setHeader('content-type', 'application/json; charset=UTF-8');
        request.setHeader('Accept', 'application/json'); 
        if(String.isNotBlank(bodyData)){
            request.setBody(bodyData);
        }
        request.setMethod(method);
        Http http = new Http();
        HttpResponse response =  http.send(request);

        return new HttpResponseWrapper(response.getStatusCode(), response.getBody());
    }
}