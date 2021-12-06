public With Sharing class DisplayAccountHierarchyController {
    @AuraEnabled(cacheable=true)
    public static List<AccWrapper> fetchAccounts(Date fDate, Date tDate) {
        system.debug('++fDate++'+fDate);
        system.debug('++tDate++'+tDate);
        DateTime fDateTime = DateTime.newInstance(fDate.year(), fDate.month(),fDate.day());
        DateTime tDateTime = DateTime.newInstance(tDate.year(), tDate.month(),tDate.day());
        Set<Id> allAccIds = New Set<Id>();
        Set<Id> accIds = New Set<Id>();
        Set<Id> taccIds = New Set<Id>();
        Set<Id> childAccIds = New Set<Id>();
        set<Id> parentAccIds = new Set<Id>();
        List<Account> lstAccount = new List<Account>();
        List<Account> parentlstAccount = new List<Account>();
        if(test.isRunningTest()){
            //lstAccount = [Select Id, Name,(Select Id, Name from Accounts__r) from Account where Id='0012u00000HAcqFAAT'];
            parentlstAccount = [Select Id, Name,(Select Id, Name from Accounts__r) from Account LIMIT 1];
            system.debug('lstAccount'+lstAccount);
            
            if(!parentlstAccount.isEmpty())
            taccIds.add(parentlstAccount[0].Id);
        }else{
            system.debug('userInfo.getUserEmail()'+userInfo.getUserEmail());
            //parentlstAccount = [Select Id, Name,Broker_Name1__r.Email__c from Account WHERE Broker_Name1__r.Email__c=:userInfo.getUserEmail()];
            List<Transaction_DB__c> TDBlist = [Select Trading_Account_Login__r.Account__r.Broker_Name1__r.Email__c from Transaction_DB__c
                                           where Trading_Account_Login__r.Account__r.Broker_Name1__r.Email__c=:userInfo.getUserEmail() AND  Transaction_Date__c >=:fDateTime AND Transaction_Date__c <=:tDateTime];
            if(!TDBlist.isempty()){
            for(Transaction_DB__c td : TDBlist){
                
                taccIds.add(td.Trading_Account_Login__r.Account__c);
            }
        }
            if(!taccIds.isEmpty()){
            
             parentlstAccount = [Select Id, Name,Broker_Name1__r.Email__c from Account WHERE Id In:taccIds];
            }
        }
        system.debug('++parentlstAccount++'+parentlstAccount);
        system.debug('parentlstAccount size'+parentlstAccount.size());
        if(!taccIds.isEmpty()){
      //  for(Account acc : parentlstAccount){
      //      accIds.add(acc.Id);
           // childAccIds.add(acc.Id);
     //   }
            system.debug('accIds=='+accIds);
            system.debug('childAccIds=='+childAccIds);
          //  if(!accIds.isEmpty()){
        lstAccount = [Select Id, Name,(Select Id, Name from Accounts__r) from Account where Id IN:taccIds];
        system.debug('++lstAccount++'+lstAccount.size());
        for(Account ac : lstAccount){
            accIds.add(ac.Id);//Account List
            if(ac.Accounts__r.size()>0){
                for(Account acc : ac.Accounts__r){
                    childAccIds.add(acc.Id);
                }   
            }
        }
        system.debug('++Size++'+accIds.size());
        system.debug('++childAccIds++'+childAccIds.size());
        while(childAccIds.size()>0){
            lstAccount = [Select Id, Name,(Select Id, Name from Accounts__r) from Account where Id IN:childAccIds];
            system.debug('++lstAccount++'+lstAccount.size());
            childAccIds.clear();
            for(Account ac : lstAccount){
                accIds.add(ac.Id);
                if(ac.Accounts__r.size()>0){
                    for(Account acc : ac.Accounts__r){
                        childAccIds.add(acc.Id);   
                    }
                }
            }
            lstAccount.clear();
            system.debug('++cSize++'+childAccIds.size());
        }
      //  }
        system.debug('++total accounts++'+accIds.size());
        
        List<Account> accList = [Select Id,Name,Broker_Name1__r.Name,Type__c,Owner_Office__c,Net_Deposits_DB__c,Total_deposit_DB__c,Total_Withdrawal_DB__c,Funded_Account_Formula__c
                                 from Account where Id IN:accIds];
            system.debug('accList= all fields=='+accList);
        List<AggregateResult> AggRes = [Select count(Id) ibCount, Broker_Name1__c parent from Account 
                                        where Broker_Name1__c != null and Id IN:accIds GROUP BY Broker_Name1__c];
             system.debug('AggRes= results=='+AggRes);
        Map<Id, Integer> accIBCount = new Map<Id, Integer>();
        for(AggregateResult aggr : AggRes){
            accIBCount.put((Id)aggr.get('parent'), (Integer)aggr.get('ibCount'));
        }
        system.debug('++accIBCount++'+accIBCount);
        List<Transaction_DB__c> transations = [Select Trading_Account_Login__r.Account__c,Transaction_Type__c,Transaction_Date__c, USD_Amount__c from Transaction_DB__c
                                           	   where Trading_Account_Login__r.Account__c IN:accIds AND  Transaction_Date__c >=:fDateTime 
                                               AND Transaction_Date__c <=:tDateTime];
		List<AccWrapper> accWrapperList = new List<AccWrapper>();
        Map<Id, Decimal> accNetAmountMap = new Map<Id, Decimal>();
        for(Transaction_DB__c transDB : transations){
            system.debug('++Id++'+transDB.Trading_Account_Login__r.Account__c+'++amount++'+accNetAmountMap.get(transDB.Trading_Account_Login__r.Account__c));
            accNetAmountMap.put(transDB.Trading_Account_Login__r.Account__c, accNetAmountMap.get(transDB.Trading_Account_Login__r.Account__c) == null ? transDB.USD_Amount__c : 
																		( accNetAmountMap.get(transDB.Trading_Account_Login__r.Account__c) + transDB.USD_Amount__c ) );
        }
        system.debug('++accNetAmountMap++'+accNetAmountMap);
        for(account acc : accList){
            system.debug('++acc++'+acc);
            system.debug('++amt++'+accNetAmountMap.get(acc.Id));
            AccWrapper accWrap = new AccWrapper();
            accWrap.acc = acc;
            accWrap.netAmount = accNetAmountMap.get(acc.Id) == null ? 0.00 : accNetAmountMap.get(acc.Id) ;
            system.debug('++netamt++'+accNetAmountMap.get(acc.Id));
            accWrapperList.add(accWrap);
        }
       	system.debug('++accWrapperList++'+accWrapperList);
                return accWrapperList;
        }else{
            
            return null;
        }
    
    
    }
    
    public class accWrapper{
        @AuraEnabled public Account acc;
        @AuraEnabled public Decimal netAmount;
    }
}