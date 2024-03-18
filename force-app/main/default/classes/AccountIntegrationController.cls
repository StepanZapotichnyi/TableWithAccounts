public class AccountIntegrationController {
    public static String ACCOUNTS_ENDPOINT = '/services/apexrest/Account';

    @AuraEnabled
    public static List<Account> getDetails() {
        String method = 'GET';
        String body = '';
        List<Account> accounts = new List<Account>();

        HttpCallouts.HttpResponseWrapper response = HttpCallouts.executeHttpRequest(ACCOUNTS_ENDPOINT, method, body);

        if(response.statusCode == 200 &&  response.statusCode < 300) {
            accounts = (List<Account>) JSON.deserialize(response.responseBody, List<Account>.class);
        }else{
            throw new CalloutException('Error: HTTP request failed with status code ' + response.statusCode);
        }
        return accounts;
    }
        
    @AuraEnabled
    public static String patchDetails(String accData) {
        String method = 'PATCH';
        String body = accData;
        
        HttpCallouts.HttpResponseWrapper response = HttpCallouts.executeHttpRequest(ACCOUNTS_ENDPOINT, method, body);
        System.debug(response);
        if(response.statusCode == 200 &&  response.statusCode < 300) {
            System.debug('response: ' + response.statusCode);
            System.debug('response: ' +  response.responseBody);
            return 'Success';
        }
        return 'Failed';
        
    }
    
    @AuraEnabled
    public static List<Account> returnAccounts() {
        return [SELECT Id, Name, Type, AccountNumber, Rating, TickerSymbol FROM Account];
    }

    @AuraEnabled
    public static String updateReturnAccounts(Object accountData){
        
        List<Account> accountList = (List<Account>) JSON.deserialize(JSON.serialize(accountData), List<Account>.class);
        
        if(!accountList.isEmpty()) {
            update accountList;
            return 'Success';
        }

        return 'Failed';
    }
}

