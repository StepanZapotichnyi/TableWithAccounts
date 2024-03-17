@isTest
private class TestAccountIntegrationController {
    
    public static List<Account> getAccount(Integer numAccounts) {
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
    static void testReturnAccounts() {
        
        List<Account> accounts = getAccount(5);
        insert accounts;

         AccountIntegrationController.returnAccounts();

         List<Account> retunAcc = [SELECT Id, Name, Type, AccountNumber, Rating, TickerSymbol FROM Account];

        System.assert(retunAcc != null);
        System.assertEquals(5, retunAcc.size(), 'Accounts does not found');

    }

    @isTest
    static void test_PositiveUpdateReturnAccounts() {
        
        Integer countAcc = 5; 
        List<Account> accounts = getAccount(countAcc);
        insert accounts;
        
        for (Account account : accounts) {
            account.AccountNumber += countAcc;
        }
        update accounts;

        String resultMethod = AccountIntegrationController.updateReturnAccounts(accounts);
        System.assertEquals('Success', resultMethod, 'Method shoud return Susses');

        List<Account> AccAfterUpdate  = [SELECT Id, Name, Type, AccountNumber, Rating, TickerSymbol FROM Account];

        System.assert(AccAfterUpdate != null);
        System.assertEquals(5, AccAfterUpdate.size(), 'Account after update');  

        for(Integer i = 0; i < accounts.size(); i++) {
            System.assertEquals(accounts[i].AccountNumber, AccAfterUpdate[i].AccountNumber,  'Обліковий запис після оновлення');

        }

    }

    @isTest 
    static void test_NegativeUpdateReturnAccounts() {

        String resultMethod = AccountIntegrationController.updateReturnAccounts(new List<Account>());
        System.assertEquals('Failed', resultMethod, 'Methode should return Failed');


    }
    
    @isTest
    static void testGetDetailsPositive() {
        String body = '[{"Id":"0010600002Ai0ivAAB","Name":"Edge Communications","Type":"Customer - Direct","AccountNumber":"1уа","Rating":"Hot","TickerSymbol":"EDGE55"},{"Id":"0010600002Ai0iwAAB","Name":"Burlington Textiles Corp of America","Type":"Customer - Direct","AccountNumber":"C16","Rating":"Warm","TickerSymbol":"BTXT"},{"Id":"0010600002Ai0ixAAB","Name":"Pyramid Construction Inc.","Type":"Customer - Channel","AccountNumber":"66","Rating":"Hot","TickerSymbol":"PYR"},{"Id":"0010600002Ai0iyAAB","Name":"Dickenson plc","Type":"Customer - Channel","AccountNumber":"C5","Rating":"Hot","TickerSymbol":"55"},{"Id":"0010600002Ai0izAAB","Name":"Grand Hotels & Resorts Ltd","Type":"Customer - Direct","AccountNumber":"6","Rating":"Warm","TickerSymbol":"G655"}]';
        Integer statusCode = 200;
        // String headerKey = 'Accept';
        // String headerValue = 'application/json';

        Test.setMock(HttpCalloutMock.class, new AccountHttpCalloutMock(statusCode, body));
        Test.startTest();
        List<Account> getAccounts = AccountIntegrationController.getDetails();
        Test.stopTest();

        System.assertNotEquals(null,getAccounts, 'The callout returned a null response.');
        System.assertEquals(5, getAccounts.size(), 'The number of accounts returned is incorrect.');
        // System.assertEquals(200, getAccounts.getStatusCode(), 'The status code is not 200.');
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
        String body = '[{"Id":"0010600002Ai0ivAAB","Name":"Edge Communications","Type":"Customer - Direct","AccountNumber":"1уа","Rating":"Hot","TickerSymbol":"EDGE55"},{"Id":"0010600002Ai0iwAAB","Name":"Burlington Textiles Corp of America","Type":"Customer - Direct","AccountNumber":"C16","Rating":"Warm","TickerSymbol":"BTXT"},{"Id":"0010600002Ai0ixAAB","Name":"Pyramid Construction Inc.","Type":"Customer - Channel","AccountNumber":"66","Rating":"Hot","TickerSymbol":"PYR"},{"Id":"0010600002Ai0iyAAB","Name":"Dickenson plc","Type":"Customer - Channel","AccountNumber":"C5","Rating":"Hot","TickerSymbol":"55"},{"Id":"0010600002Ai0izAAB","Name":"Grand Hotels & Resorts Ltd","Type":"Customer - Direct","AccountNumber":"6","Rating":"Warm","TickerSymbol":"G655"}]';
        Integer statusCode = 200;
        String toUpdate = '[{"Id":"0010600002Ai0ivAAB","Name":"Edge Communications","Type":"Direct","AccountNumber":"CC","Rating":"Hot","TickerSymbol":"EDGE55"}]';

        Test.setMock(HttpCalloutMock.class, new AccountHttpCalloutMock(statusCode, body));

        Test.startTest();
        String result =  AccountIntegrationController.patchDetails(toUpdate);
        Test.stopTest();

        System.assertNotEquals(null, result,'The callout returned a null response');
        System.assertEquals('Success',result, 'Method should return Success');
    }

    @isTest
    static void testPatchDetailsNegative() {
        String body = '[{"Id":"0010600002Ai0ivAAB","Name":"Edge Communications","Type":"Customer - Direct","AccountNumber":"1уа","Rating":"Hot","TickerSymbol":"EDGE55"},{"Id":"0010600002Ai0iwAAB","Name":"Burlington Textiles Corp of America","Type":"Customer - Direct","AccountNumber":"C16","Rating":"Warm","TickerSymbol":"BTXT"},{"Id":"0010600002Ai0ixAAB","Name":"Pyramid Construction Inc.","Type":"Customer - Channel","AccountNumber":"66","Rating":"Hot","TickerSymbol":"PYR"},{"Id":"0010600002Ai0iyAAB","Name":"Dickenson plc","Type":"Customer - Channel","AccountNumber":"C5","Rating":"Hot","TickerSymbol":"55"},{"Id":"0010600002Ai0izAAB","Name":"Grand Hotels & Resorts Ltd","Type":"Customer - Direct","AccountNumber":"6","Rating":"Warm","TickerSymbol":"G655"}]';
        Integer statusCode = 400;
        String toUpdate = '[{}]';

        Test.setMock(HttpCalloutMock.class, new AccountHttpCalloutMock(statusCode, body));

        Test.startTest();
        String result =  AccountIntegrationController.patchDetails(toUpdate);
        Test.stopTest();

        System.assertEquals('Failed', result,'Methode shoul d return Failed');

    }


}