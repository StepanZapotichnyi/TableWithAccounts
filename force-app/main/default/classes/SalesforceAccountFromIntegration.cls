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
        
        RestRequest accountRequest = RestContext.request;
        String requestBody = accountRequest.requestBody.toString();
        System.debug('requestBody' + requestBody);
      
        List<AccountWrapper> accountsToUpdate = (List<AccountWrapper>) JSON.deserialize(requestBody, List<AccountWrapper>.class);
        
        
         System.debug('to ' + accountsToUpdate);
        Map<Id, AccountWrapper> accountMap = new Map<Id, AccountWrapper>();
        for(AccountWrapper wrapper : accountsToUpdate){
            accountMap.put(wrapper.Id, wrapper);
        }
         List<Account> updateListAcc = [SELECT Id, Type, AccountNumber, Rating, TickerSymbol FROM Account WHERE Id IN  :accountMap.keySet()];
        
        for(Account acc : updateListAcc) {
		   AccountWrapper accWrapper = accountMap.get(acc.Id);
            if(accWrapper != null) {
            	acc.Type = accWrapper.Type != null ? accWrapper.Type : acc.Type;
            	acc.AccountNumber = accWrapper.AccountNumber != null ? accWrapper.AccountNumber : acc.AccountNumber;
            	acc.Rating = accWrapper.Rating != null ? accWrapper.Rating : acc.Rating;
            	acc.TickerSymbol = accWrapper.TickerSymbol != null ? accWrapper.TickerSymbol : acc.TickerSymbol;
            	accUpdateCount++;
        	}
 		}
        
        List<Database.SaveResult> saveResults = Database.update(updateListAcc, false);
        for (Database.SaveResult sr : saveResults) {
     		AccountWrapper accw = new AccountWrapper();
            if (sr.isSuccess()) {
                accw.success = accUpdateCount.toString();
                accw.message = 'Successfully updated ' + accUpdateCount.toString()  + ' accounts.';
                System.debug('success' + accw.success);
                System.debug('message' + accw.message);
                
            }else{
               accw.success = '0';
           	   accw.message = 'Failed to update accounts. Error: ' + sr.getErrors();
            }
            resAccList.add(accw);
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
      
// }   Set<Id> accountIds = new Set<Id>();
// for(AccountWrapper aU : accountsToUpdate) {
//     accountIds.add(aU.Id);
// } 

// for(Account acc : [SELECT Id, Type, AccountNumber, Rating, TickerSymbol FROM Account WHERE Id IN  :accountIds]) {
//     for(AccountWrapper accUp : accountsToUpdate) {
//         if(acc.Id == accUp.Id) {
//             acc.Type = (accUp.Type != null) ? accUp.Type : acc.Type;
//             acc.AccountNumber = (accUp.AccountNumber != null) ? accUp.AccountNumber :  acc.AccountNumber;
//               acc.Rating = (accUp.Rating != null) ? accUp.Rating : acc.Rating;
//             acc.TickerSymbol = (accUp.TickerSymbol != null) ? accUp.TickerSymbol : acc.TickerSymbol;
//             updateListAcc.add(acc);
            
//         }
//     }
// }

// // if(!updateListAcc.isEmpty()){
// //	update updateListAcc;
// //}

// List<Database.SaveResult> saveResults = Database.update(updateListAcc, false);

// for (Database.SaveResult sr : saveResults) {
//         accUpdateCount++;
//     AccountWrapper accw = new AccountWrapper();
//     if (sr.isSuccess()) {
//       accw.success = accUpdateCount.toString();
//       accw.message = 'Successfully updated ' + accUpdateCount.toString()  + ' accounts.';
//       resAccList.add(accw); 
//       System.debug('Secces'+resAccList);  
//   }else {               
//         for(Database.Error err : sr.getErrors()) {	                
//          accw.success = 'false';
//           accw.message = 'Failed to update accounts. Error! ' + sr.getErrors();
//          resAccList.add(accw); 
//           System.debug('error'+resAccList);
//     }
//   }
// }     
// return resAccList;     
// }