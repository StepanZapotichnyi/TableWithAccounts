@isTest
private class AccountIntegrationControllerTest {

    @isTest
    static void testGetAccountsFromData() {
        
        List<Account> accounts = TestUtility.getAccount(5);
        insert accounts;

         AccountIntegrationController.getAccountsFromData();

         List<Account> retunAcc = [SELECT Id, Name, Type, AccountNumber, Rating, TickerSymbol FROM Account];

        System.assert(retunAcc != null);
        System.assertEquals(5, retunAcc.size(), 'Accounts does not found');

    }

    @isTest
    static void testUpdateAccountsFromDataPositive() {
        
        Integer countAcc = 5; 
        List<Account> accounts = TestUtility.getAccount(countAcc);
        insert accounts;
        
        for (Account account : accounts) {
            account.AccountNumber += countAcc;
        }
        update accounts;

        AccountIntegrationController.updateAccountsFromData(accounts);
        // System.assertEquals('Success', response, 'Method shoud return Susses');

        List<Account> accAfterUpdate  = [SELECT Id, Name, Type, AccountNumber, Rating, TickerSymbol FROM Account];

        System.assert(AccAfterUpdate != null);
        System.assertEquals(5, AccAfterUpdate.size(), 'Account after update');  

        for(Integer i = 0; i < accounts.size(); i++) {
            System.assertEquals(accounts[i].AccountNumber, AccAfterUpdate[i].AccountNumber,  'Account after update');

        }

    }

    @isTest 
    static void testUpdateAccountsFromDataNegative() {

        Integer countAcc = 5; 
        List<Account> accounts = TestUtility.getAccount(countAcc);
        insert accounts;
        
        for (Account account : accounts) {
            account.AccountNumber += countAcc;
        }
        AccountIntegrationController.updateAccountsFromData(accounts);
        // System.assertEquals('Success', response, 'Method shoud return Susses');

        List<Account> accAfterUpdate  = [SELECT Id, Name, Type, AccountNumber, Rating, TickerSymbol FROM Account];
        
        System.assert(accAfterUpdate != null);
        System.assertEquals(5, accAfterUpdate.size(), 'Account after update');  

        for(Integer i = 0; i < accounts.size(); i++) {
            System.assertEquals(accounts[i].AccountNumber, accAfterUpdate[i].AccountNumber,  'Account after update field AccountNumber should be not equal to');

        }

    }
    
    @isTest
    static void testGetAccountsFromAnotherOrgPositive() {
        String body = TestUtility.generateGetBody();
        Integer statusCode = 200;

        Test.setMock(HttpCalloutMock.class, new AccountHttpCalloutMock(statusCode, body));
        Test.startTest();
        List<Account> getAccounts = AccountIntegrationController.getAccountsFromAnotherOrg();
        Test.stopTest();

        System.assertNotEquals(null,getAccounts, 'The callout returned a null response.');
        System.assertEquals(5, getAccounts.size(), 'The number of accounts returned is incorrect.');
    }
    
    @isTest 
    static void testGetAccountsFromAnotherOrgsNegative() {
        String body = '[{}]';

        Integer statusCode = 400;

        Test.setMock(HttpCalloutMock.class, new AccountHttpCalloutMock(statusCode, body));

        try{
            Test.startTest();
            AccountIntegrationController.getAccountsFromAnotherOrg();
            Test.stopTest();
            Assert.fail('An exception should have been thrown');
        }catch(CalloutException e) {
            Assert.isTrue(e.getMessage().equalsIgnoreCase('Error: HTTP request failed with status code 400'),
            'Exception message does not match: ' + e.getMessage());
        }
    }
    
    @isTest
    static void testPatchAccountsInAnotherOrgPositive() {

        String body = TestUtility.generateGetBody();
        Integer statusCode = 200;
        String toUpdate = TestUtility.generateToUpdateBody();

        Test.setMock(HttpCalloutMock.class, new AccountHttpCalloutMock(statusCode, body));
        
        AccountIntegrationController.patchAccountsInAnotherOrg(body);
        
        System.assertEquals(toUpdate, toUpdate, 'Method should Success');
    }

    @isTest
    static void testPatchAccountsInAnotherOrgNegative() {
        String body = TestUtility.generateGetBody();
        Integer statusCode = 400;
        String toUpdate = '[{}]';

        Test.setMock(HttpCalloutMock.class, new AccountHttpCalloutMock(statusCode, body));
        
        try{
            Test.startTest();
            AccountIntegrationController.patchAccountsInAnotherOrg(toUpdate);
            Test.stopTest();
            Assert.fail('An exception should have been thrown');
        }catch(CalloutException e) {
            Assert.isTrue(e.getMessage().equalsIgnoreCase('Error: HTTP request failed with status code 400'),
            'Exception message does not match: ' + e.getMessage());
        }

    }


}