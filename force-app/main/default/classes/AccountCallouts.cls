public with sharing class AccountCallouts {
    
    public static Map<Integer, String> executeHttpRequest(String endpoint, String method,String bodyData, Boolean hasBody) {
        
        Map<Integer, String> responseMap = new Map<Integer, String>();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:ReturnContact' + endpoint);
        request.setHeader('content-type', 'application/json; charset=UTF-8');
        request.setHeader('Accept', 'application/json'); 
        if(hasBody){
            request.setBody(bodyData);
        }
        request.setMethod(method);
        Http http = new Http();
        HttpResponse response =  http.send(request);
        
        if(response.getStatusCode() == 200) {
            responseMap.put(response.getStatusCode(),response.getBody());
            return responseMap;
        }else{
            responseMap.put(response.getStatusCode(),response.getBody());
            return responseMap;
        }
    }
  
}