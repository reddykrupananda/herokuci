trigger CS_AccountContactRelation on AccountContactRelation (After Insert,Before Delete,After Delete) {
	Set<Id> accIdSet = new Set<Id>();    
    if(trigger.isAfter && trigger.isInsert){
        for(AccountContactRelation acr: trigger.new){
            accIdSet.add(acr.accountid);
        }
        List<Account> lst_AccountsToUpdate = new List<Account>();
        Map<Id,Integer> map_AcctCount = new Map<Id,Integer>();
        for(AggregateResult ar : [SELECT Count(ContactId),AccountId FROM AccountContactRelation WHERE AccountId IN :accIdSet GROUP BY Accountid]){
            map_AcctCount.put((ID)ar.get('AccountId'), (Integer)ar.get('expr0'));
        }
        if(map_AcctCount.size() > 0){
            for(Account objAcct : [SELECT Id,No_of_Stakeholder_Contacts__c FROM Account WHERE Id IN :accIdSet]){
                if(map_AcctCount.get(objAcct.Id) > 0){
                    objAcct.No_of_Stakeholder_Contacts__c = String.valueOf(map_AcctCount.get(objAcct.Id));
                    lst_AccountsToUpdate.add(objAcct);
                }      
            }
        }
        try{
            update lst_AccountsToUpdate;
        }catch(Exception Ex){
            //Catch block
        }
    }
}