@isTest
public class TestDataSetup {
    
    public static User createactiveUser(){
    String orgId = UserInfo.getOrganizationId();
    String dateString =  String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
    Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
    String uniqueName = orgId + dateString + randomInt;
    Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
    User u = new User(Alias = 'standt', Email='testmultibank@testorg.com', 
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName=uniqueName + '@test' + orgId + '.org');
    return u;
}

    public static Account createAccount(){
        Account acc1 = new Account();
        acc1.Name = 'brokername';
        acc1.Email__c='dhananjay.misal@multibankfx.com';
        insert acc1;
       Account acc = new Account();
       acc.name = 'Test Account1';
        acc.Broker_Name1__c=acc1.Id;
       return acc;
}
        public static Contact createContact(){
        Contact con = new Contact();
        con.LastName = 'test';
        return con;
}
        public static MT4_Accounts__c createMT4Account(){
        MT4_Accounts__c mt4Acc = new MT4_Accounts__c();
        mt4Acc.Name = '13439029';
        return mt4Acc;
}
        public static Transaction_DB__c createTransactionDB(){
        Transaction_DB__c transDB = new Transaction_DB__c();
        transDB.Transaction_Date__c = system.today();
        transDB.USD_Amount__c = 5000.00;
        return transDB;
}
      public static Lead createLead(){
       Lead Ld = new Lead();
       Ld.Lastname = 'Test Lead';
       return Ld;
}
  

}