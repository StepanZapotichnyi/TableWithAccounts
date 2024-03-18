public with sharing class TestUtility {
    
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

    public static String generateGetBody() {
        String body = '[{"Id":"0010600002Ai0ivAAB","Name":"Edge Communications","Type":"Customer - Direct","AccountNumber":"1уа","Rating":"Hot","TickerSymbol":"EDGE55"},{"Id":"0010600002Ai0iwAAB","Name":"Burlington Textiles Corp of America","Type":"Customer - Direct","AccountNumber":"C16","Rating":"Warm","TickerSymbol":"BTXT"},{"Id":"0010600002Ai0ixAAB","Name":"Pyramid Construction Inc.","Type":"Customer - Channel","AccountNumber":"66","Rating":"Hot","TickerSymbol":"PYR"},{"Id":"0010600002Ai0iyAAB","Name":"Dickenson plc","Type":"Customer - Channel","AccountNumber":"C5","Rating":"Hot","TickerSymbol":"55"},{"Id":"0010600002Ai0izAAB","Name":"Grand Hotels & Resorts Ltd","Type":"Customer - Direct","AccountNumber":"6","Rating":"Warm","TickerSymbol":"G655"}]';
        return body;
    }

    public static String generateToUpdateBody() {
        String toUpdateBody = '[{"Id":"0010600002Ai0ivAAB","Name":"Edge Communications","Type":"Direct","AccountNumber":"CC","Rating":"Hot","TickerSymbol":"EDGE55"}]';
        return toUpdateBody;
    }
}