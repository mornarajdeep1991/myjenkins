@isTest
public class DisplayAccountHierarchyControllerTest {
   
        
         @testSetup static void setup() {
        Account acc1 = TestDataSetup.createAccount();
        insert acc1;
         Account acc2 = TestDataSetup.createAccount();
         acc2.Broker_Name1__c  = acc1.id;
          insert acc2;
         Contact con = TestDataSetup.createContact();
        con.AccountId = acc2.id;
        insert con;
        
        MT4_Accounts__c mt4Acc =  TestDataSetup.createMT4Account();
        mt4Acc.Account__c = acc2.Id;
        mt4Acc.Contact__c = con.Id;
        insert mt4acc;
        
        Transaction_DB__c transDB = TestDataSetup.createTransactionDB();
        transDB.Trading_Account_Login__c = mt4acc.Id;
        transDB.Transaction_Type__c = 'Deposit';
        insert transDB; 
         }
        
        static testMethod void testFetchAccounts(){
        test.startTest();
        List<DisplayAccountHierarchyController.accWrapper> accWrapperList = DisplayAccountHierarchyController.fetchAccounts( system.today().addDays(-30), system.today());
        test.stopTest();
    }
}