@RestResource(urlMapping='/Account/*')
global class SalesforceAccountFromIntegration {
    
    @HttpGet
    global static List<Account> getAccount() {
        System.debug('GEt');
        system.debug([SELECT Id, Name,Type,AccountNumber,Rating,TickerSymbol FROM Account]);
        return [SELECT Id, Name,Type,AccountNumber,Rating,TickerSymbol FROM Account];
    }
   	
    @HttpPatch
    global static List<AccountWrapper> updateAccount() {
        
        System.debug('Patch');
        Integer accUpdateCount = 0;
        List<AccountWrapper> resAccList = new List<AccountWrapper>();
        List<Account> updateListAcc = new List<Account>();
        
        RestRequest accountRequest = RestContext.request;
        String requestBody = accountRequest.requestBody.toString();
        System.debug('requestBody' + requestBody); 
        
        List<AccountWrapper> accountsToUpdate = (List<AccountWrapper>) JSON.deserialize(requestBody, List<AccountWrapper>.class);
         System.debug('to ' + accountsToUpdate);
        
        Set<Id> accountIds = new Set<Id>();
        for(AccountWrapper aU : accountsToUpdate) {
            accountIds.add(aU.Id);
        }
        System.debug(accountIds);
        
        List<Account> thisAccList = [
            SELECT 
            	Id, Type, AccountNumber, Rating, TickerSymbol
            FROM
            	Account
            WHERE
            	Id IN  :accountIds
        
        ];
        System.debug(thisAccList);
        for(Account acc : thisAccList) {
            
            for(AccountWrapper accUp : accountsToUpdate) {
                if(acc.Id == accUp.Id) {
                    if (accUp.Type != null) {
                    acc.Type = accUp.Type;
             	   	}
                    System.debug(accUp.AccountNumber);
                	if (accUp.AccountNumber != null) {
                    acc.AccountNumber = accUp.AccountNumber;
               		}
                	if (accUp.Rating != null) {
                    acc.Rating = accUp.Rating;
                	}
                	if (accUp.TickerSymbol != null) {
                    acc.TickerSymbol = accUp.TickerSymbol;
                	}
                    updateListAcc.add(acc);
                    accUpdateCount++;
                }
            }
        }  
    	System.debug('result' + updateListAcc);
        if(!updateListAcc.isEmpty()){
        	update updateListAcc;
             for (AccountWrapper accUpdate : accountsToUpdate) {
                accUpdate.success = accUpdateCount.toString();
                accUpdate.message = 'Successfully updated ' + accUpdateCount + ' accounts.';
                resAccList.add(accUpdate);
            }
        }else{
             for (AccountWrapper accUpdate : accountsToUpdate) {
            	accUpdate.success = 'Null';
            	accUpdate.message = 'Failed to update accounts. Error!' ;
            	resAccList.add(accUpdate);
       		 }
        }
       return resAccList;
    }
    
    
    global class AccountWrapper {
    	public ID Id;
        public String Type;
       	public String AccountNumber;
        public String Rating;
        public String TickerSymbol;
        public String message;
        public String success;
	}
      
}