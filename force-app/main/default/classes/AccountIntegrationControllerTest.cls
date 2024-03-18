@isTest
private class AccountIntegrationControllerTest {

    @isTest
    static void testReturnAccounts() {
        
        List<Account> accounts = TestUtility.getAccount(5);
        insert accounts;

         AccountIntegrationController.returnAccounts();

         List<Account> retunAcc = [SELECT Id, Name, Type, AccountNumber, Rating, TickerSymbol FROM Account];

        System.assert(retunAcc != null);
        System.assertEquals(5, retunAcc.size(), 'Accounts does not found');

    }

    @isTest
    static void testPositiveUpdateReturnAccounts() {
        
        Integer countAcc = 5; 
        List<Account> accounts = TestUtility.getAccount(countAcc);
        insert accounts;
        
        for (Account account : accounts) {
            account.AccountNumber += countAcc;
        }
        update accounts;

        String response = AccountIntegrationController.updateReturnAccounts(accounts);
        System.assertEquals('Success', response, 'Method shoud return Susses');

        List<Account> accAfterUpdate  = [SELECT Id, Name, Type, AccountNumber, Rating, TickerSymbol FROM Account];

        System.assert(AccAfterUpdate != null);
        System.assertEquals(5, AccAfterUpdate.size(), 'Account after update');  

        for(Integer i = 0; i < accounts.size(); i++) {
            System.assertEquals(accounts[i].AccountNumber, AccAfterUpdate[i].AccountNumber,  'Обліковий запис після оновлення');

        }

    }

    @isTest 
    static void testNegativeUpdateReturnAccounts() {

        String response = AccountIntegrationController.updateReturnAccounts(new List<Account>());
        System.assertEquals('Failed', response, 'Methode should return Failed');


    }
    
    @isTest
    static void testGetDetailsPositive() {
        String body = TestUtility.generateGetBody();
        Integer statusCode = 200;

        Test.setMock(HttpCalloutMock.class, new AccountHttpCalloutMock(statusCode, body));
        Test.startTest();
        List<Account> getAccounts = AccountIntegrationController.getDetails();
        Test.stopTest();

        System.assertNotEquals(null,getAccounts, 'The callout returned a null response.');
        System.assertEquals(5, getAccounts.size(), 'The number of accounts returned is incorrect.');
    }
    
    @isTest 
    static void testGetDetailsNegative() {
        String body = '[{}]';
        Integer statusCode = 400;

        Test.setMock(HttpCalloutMock.class, new AccountHttpCalloutMock(statusCode, body));
        
        Test.startTest();
        List<Account> getAccounts;
        try{
            getAccounts = AccountIntegrationController.getDetails();
        }catch(CalloutException e) {
            getAccounts = new List<Account>();
        }
        Test.stopTest();

        System.assertEquals(0, getAccounts.size(), 'Acounts not returned is incorrect.');
    }
    
    @isTest
    static void testPatchDetailsPositive() {
        String body = TestUtility.generateGetBody();
        Integer statusCode = 200;
        String toUpdate = TestUtility.generateToUpdateBody();

        Test.setMock(HttpCalloutMock.class, new AccountHttpCalloutMock(statusCode, body));

        Test.startTest();
        String result =  AccountIntegrationController.patchDetails(toUpdate);
        Test.stopTest();

        System.assertNotEquals(null, result,'The callout returned a null response');
        System.assertEquals('Success',result, 'Method should return Success');
    }

    @isTest
    static void testPatchDetailsNegative() {
        String body = TestUtility.generateGetBody();
        Integer statusCode = 400;
        String toUpdate = '[{}]';

        Test.setMock(HttpCalloutMock.class, new AccountHttpCalloutMock(statusCode, body));

        Test.startTest();
        String result =  AccountIntegrationController.patchDetails(toUpdate);
        Test.stopTest();

        System.assertEquals('Failed', result,'Methode shoul d return Failed');

    }


}