public class AccountIntegrationController {
    public static String ACCOUNTS_ENDPOINT = '/services/apexrest/Account';

    @AuraEnabled
    public static List<Account> getDetails() {
        String method = 'GET';
        String body = '';
        List<Account> accounts = new List<Account>();

        Map<Integer, String> response = AccountCallouts.executeHttpRequest(ACCOUNTS_ENDPOINT, method, body, false);
         if(response.containsKey(200)) {
            String responseBody = response.get(200);
            List<Object> listAccounts = (List<Object>) JSON.DeserializeUntyped(responseBody);
             for (object acc : listAccounts) {
                Map<String, Object> accountMap = (Map<String, Object>)acc;
                Account account = new Account();
                account.Id = (Id) accountMap.get('Id');
                account.Name = (String) accountMap.get('Name');
                account.AccountNumber = (String) accountMap.get('AccountNumber');
                account.Rating = (String) accountMap.get('Rating');
                account.TickerSymbol = (String) accountMap.get('TickerSymbol');
                account.Type = (String) accountMap.get('Type');

                accounts.add(account);
             }    
        }else{
            throw new CalloutException('Error: HTTP request failed with status code ' + response.keySet());
        } 
        return accounts;
    }
        
    @AuraEnabled
    public static String patchDetails(String accData) {
        String method = 'PATCH';
        String body = accData;
        Map<Integer, String> response = AccountCallouts.executeHttpRequest(ACCOUNTS_ENDPOINT, method, body, true);

        if(response.containsKey(200)) {
            System.debug('response: ' + response.keySet());
            System.debug('response: ' +  response.get(200));
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

