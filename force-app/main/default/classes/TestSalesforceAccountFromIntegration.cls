@isTest
public class TestSalesforceAccountFromIntegration {
	
    public static List<Account> createTestAccount(Integer numAccounts) {
        List<Account> accs = new List<Account>();
        for(Integer i = 0; i < numAccounts; i++) {
            Account acc = new Account();
            acc.Name = 'Test account' +i;
            acc.Type = 'Prospect';
            acc.AccountNumber = 'CD' + i ;
            acc.Rating = 'Hot Test';
            acc.TickerSymbol = 'Ticker';
            accs.add(acc);
        }
        return accs;
    }
    
    @isTest
	static void testGetAccount() {
    	
    	List<Account> testAccounts = createTestAccount(10);
        insert testAccounts;
        
        RestRequest request = new RestRequest();
        request.requestUri = '/services/apexrest/Account/';
        request.httpMethod = 'GET';
  
        RestContext.request = request;
 
   		List<Account> results = SalesforceAccountFromIntegration.getAccount();      

        System.assert(results != null, 'Result should not be null');
        System.assertEquals(10, results.size(), 'Incorrect number of accounts returned');
	}
    
    @isTest
    static void testUpdateAccountPositive() {
        
        List<Account> testAccounts = createTestAccount(10);
        insert testAccounts;
        
        List<SalesforceAccountFromIntegration.AccountUpdate> accToUpdate = new List<SalesforceAccountFromIntegration.AccountUpdate>();
        
       for (Account acc : testAccounts) {
           SalesforceAccountFromIntegration.AccountUpdate updateAccount = new SalesforceAccountFromIntegration.AccountUpdate();
       		 updateAccount.Id = acc.Id;
           	 updateAccount.Type = 'Partner';
			 updateAccount.AccountNumber = 'New Account Number';
           	 updateAccount.Rating = 'New Rating';
           	 updateAccount.TickerSymbol = 'New TiketrSybol';
           	 accToUpdate.add(updateAccount);
        }
         
        RestRequest request = new RestRequest();
        request.requestUri = '/services/apexrest/Account/';
        request.httpMethod = 'PATCH';
        request.requestBody = Blob.valueOf(JSON.serialize(accToUpdate));
        RestContext.request = request;
        
    	List<SalesforceAccountFromIntegration.AccountUpdate> results = SalesforceAccountFromIntegration.updateAccount();
    	
        System.assert(results != null, 'Result should not be null');
        System.assertEquals(10, results.size(), 'Incorrect number of updates returned');
        for (SalesforceAccountFromIntegration.AccountUpdate accUpdate : results) {
     	   System.assertEquals('10', accUpdate.success, 'All accounts should be successfully updated');
           System.assertEquals('Successfully updated 10 accounts.', accUpdate.message, 'Message is not correct');
  		}
    }
    
    @isTest 
    static void testUpdateAccountNegative() {
       List<Account> testAccounts = createTestAccount(10);
       insert testAccounts;
        
       List<SalesforceAccountFromIntegration.AccountUpdate> accToUpdate = new List<SalesforceAccountFromIntegration.AccountUpdate>();
        	
       for (Account acc : testAccounts) {
           SalesforceAccountFromIntegration.AccountUpdate updateAccount = new SalesforceAccountFromIntegration.AccountUpdate();
       		 updateAccount.Id = null;
           	 updateAccount.Type = null;
			 updateAccount.AccountNumber = null;
           	 updateAccount.Rating = null;
           	 updateAccount.TickerSymbol = null;
           	 accToUpdate.add(updateAccount);
        }
         
        RestRequest request = new RestRequest();
        request.requestUri = '/services/apexrest/Account/';
        request.httpMethod = 'PATCH';
        request.requestBody = Blob.valueOf(JSON.serialize(accToUpdate));
        RestContext.request = request;
      
   		List<SalesforceAccountFromIntegration.AccountUpdate> results = SalesforceAccountFromIntegration.updateAccount();
        
        System.assert(results != null, 'Result should not be null');
        for (SalesforceAccountFromIntegration.AccountUpdate accUpdate : results) {
     	   System.assertEquals('Null', accUpdate.success, 'All accounts should be not updated');
           System.assertEquals('Failed to update accounts. Error!', accUpdate.message, 'Message is not correct');
  		}
    }
    
}