@isTest
public class SalesforceAccountFromIntegrationTest {
    @isTest
	static void testGetAccount() {
    	// Create test data
    	List<Account> testAccounts = TestUtility.createTestAccount(10);
        insert testAccounts;
        
        RestRequest request = new RestRequest();
        request.requestUri = '/services/apexrest/Account/';
        request.httpMethod = 'GET';
  
        RestContext.request = request;
 
   		List<Account> results = SalesforceAccountFromIntegration.getAccount();      
        // Assert the results
        System.assert(results != null, 'Result should not be null');
        System.assertEquals(10, results.size(), 'Incorrect number of accounts returned');
	}
    
    @isTest
    static void testUpdateAccountPositive() {
        
        List<Account> testAccounts = TestUtility.createTestAccount(10);
        insert testAccounts;
        
        List<Account> accToUpdate = new List<Account>();
        
       for (Account acc : testAccounts) {
           Account updateAccount = new Account();
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
        
    	List<SalesforceAccountFromIntegration.ResponseWrapper> results = SalesforceAccountFromIntegration.updateAccount();
    	
        System.assert(results != null, 'Result should not be null');
        System.assertEquals(10, results.size(), 'Incorrect number of updates returned');
        for (SalesforceAccountFromIntegration.ResponseWrapper accUpdate : results) {
     	   System.assertEquals('1', accUpdate.success, 'All accounts should be successfully updated');
           System.assertEquals('Successfully updated 1 accounts.', accUpdate.message, 'Message is not correct');
  		}
    }
    
    @isTest 
    static void testUpdateAccountNegative() {
        List<Account> testAccounts = TestUtility.createTestAccount(10);
        insert testAccounts;
        
        List<Account> accToUpdate = new List<Account>(); 
        
        for (Account acc : testAccounts) {
            Account updateAccount = new Account();
           // updateAccount.Id = acc.Id;
            updateAccount.Type = 'InvalidType';
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
       
        List<SalesforceAccountFromIntegration.ResponseWrapper> results = SalesforceAccountFromIntegration.updateAccount();
        
       System.assert(results != null, 'Result should not be null');
   	   for (SalesforceAccountFromIntegration.ResponseWrapper accUpdate : results) {
         System.assertEquals('0', accUpdate.success, 'All accounts should be successfully updated');
    }
    }
    
}