public class AccountIntegrationController {
    @AuraEnabled
    // @future(callout=true)
    public static List<Account> getDetails() {

        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:ReturnContact/services/apexrest/Account');
        req.setHeader('content-type', 'aplication/json; charset=UTF-8');
        req.setHeader('Accept', 'application/json');
        req.setMethod('GET');
        Http http = new Http();
        HttpResponse respon =  http.send(req);
        
        System.debug('response---Code------' + respon.getStatusCode());
        System.debug('response---body------' + respon.getBody());
        List<Account> accounts = new List<Account>();

        if(respon.getStatusCode() == 200) {
            List<Object> jsonResults = (List<Object>) JSON.DeserializeUntyped(respon.getBody());
            System.debug('jsonResults'+jsonResults);
             for (object ac : jsonResults) {
                Map<String, Object> acMap = (Map<String, Object>)ac;
                Account account = new Account();
                account.Id = (Id) acMap.get('Id');
                account.Name = (String) acMap.get('Name');
                account.AccountNumber = (String) acMap.get('AccountNumber');
                account.Rating = (String) acMap.get('Rating');
                account.TickerSymbol = (String) acMap.get('TickerSymbol');
                account.Type = (String) acMap.get('Type');

                accounts.add(account);
             }
            
        }else {
            System.debug('Error: HTTP request failed with status code ' + respon.getStatusCode());
            throw new CalloutException('Error: HTTP request failed with status code ' + respon.getStatusCode());
        }  
            System.debug('List accounts++++' + accounts);
            return accounts;
    }
    
    @AuraEnabled
    public static List<Account> returnAccounts() {
        System.debug('return' + [SELECT Id, Name, Type, AccountNumber, Rating, TickerSymbol FROM Account]);
        return [SELECT Id, Name, Type, AccountNumber, Rating, TickerSymbol FROM Account];
    }
}