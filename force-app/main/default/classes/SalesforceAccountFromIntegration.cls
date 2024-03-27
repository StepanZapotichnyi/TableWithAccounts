@RestResource(urlMapping='/Account/*')
global class SalesforceAccountFromIntegration {
    
    @HttpGet
    global static List<Account> getAccount() {
        System.debug('GEt');
        system.debug([SELECT Id, Name,Type,AccountNumber,Rating,TickerSymbol FROM Account]);
        return [SELECT Id, Name,Type,AccountNumber,Rating,TickerSymbol FROM Account];
    }
    
    @HttpPatch
    global static List<ResponseWrapper> updateAccount() {
        
        List<ResponseWrapper> resAccList = new List<ResponseWrapper>(); 
        
        RestRequest accountRequest = RestContext.request;
        String requestBody = accountRequest.requestBody.toString();
    
        List<Account> accountsToUpdate = (List<Account>) JSON.deserialize(requestBody, List<Account>.class);
    
        List<Database.SaveResult> saveResults = Database.update(accountsToUpdate, false);
    
        for (Database.SaveResult sr : saveResults) {
            ResponseWrapper accw = new ResponseWrapper();
            if (sr.isSuccess()) {
                accw.success = '1';
                accw.message = 'Successfully updated 1 accounts.';
            }else{
            accw.success = '0';
            accw.message = 'Failed to update accounts. Error: ' + sr.getErrors();
            }
            resAccList.add(accw);
        }     
    return resAccList;    
    }
    
    global class ResponseWrapper {
        public String message;
        public String success;
    }
}