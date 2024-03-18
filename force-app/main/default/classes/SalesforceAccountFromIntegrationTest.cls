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
        
        List<SalesforceAccountFromIntegration.AccountWrapper> accToUpdate = new List<SalesforceAccountFromIntegration.AccountWrapper>();
        
       for (Account acc : testAccounts) {
           SalesforceAccountFromIntegration.AccountWrapper updateAccount = new SalesforceAccountFromIntegration.AccountWrapper();
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
        
    	List<SalesforceAccountFromIntegration.AccountWrapper> results = SalesforceAccountFromIntegration.updateAccount();
    	
        System.assert(results != null, 'Result should not be null');
        System.assertEquals(10, results.size(), 'Incorrect number of updates returned');
        for (SalesforceAccountFromIntegration.AccountWrapper accUpdate : results) {
     	   System.assertEquals('10', accUpdate.success, 'All accounts should be successfully updated');
           System.assertEquals('Successfully updated 10 accounts.', accUpdate.message, 'Message is not correct');
  		}
    }
    
    @isTest 
    static void testUpdateAccountNegative() {
       List<Account> testAccounts = TestUtility.createTestAccount(10);
       insert testAccounts;
        
       List<SalesforceAccountFromIntegration.AccountWrapper> accToUpdate = new List<SalesforceAccountFromIntegration.AccountWrapper>();
        	
       for (Account acc : testAccounts) {
           SalesforceAccountFromIntegration.AccountWrapper updateAccount = new SalesforceAccountFromIntegration.AccountWrapper();
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
      
   		List<SalesforceAccountFromIntegration.AccountWrapper> results = SalesforceAccountFromIntegration.updateAccount();
        
        System.assert(results != null, 'Result should not be null');
        for (SalesforceAccountFromIntegration.AccountWrapper accUpdate : results) {
     	   System.assertEquals('Null', accUpdate.success, 'All accounts should be not updated');
           System.assertEquals('Failed to update accounts. Error!', accUpdate.message, 'Message is not correct');
  		}
    }
    
}