@isTest(seeAllData=false)
public class CS_AccountRelatedContactsTrigger_Test {
 
    //test method
    public static testmethod void addAccountRelatedContact() {        
        //Create test records
       	List<AccountContactRelation> accconList = new List<AccountContactRelation>();
        List<Account> accList = new List<Account>();
        for(Integer i=0;i<10;i++){
            Account newAcc = new Account();
            newAcc.Name = 'TestAccount'+i;
			accList.add(newAcc);         
        }
        Test.StartTest();
        insert accList;
        
        accconList = [select id,accountid from AccountContactRelation];
        system.assert(accconList.size()==0);
        
        List<Contact> conList = new List<Contact>();
        for(Account acc:accList){
            for(Integer i=1;i<10;i++){ 
                Contact newCon = new Contact();
                newCon.LastName = 'TestContact'+i;
                newCon.Email = 'contact'+i+'@test.com';
                newCon.AccountId = acc.Id;
                conList.add(newCon);                
            }
        }
        insert conList;
        
        accconList = [select id,accountid from AccountContactRelation];
		system.assert(accconList.size()>0);
        Test.StopTest();        
    }
    
    public static testmethod void deleteAccountRelatedContact() {        
        //Create test records
       	List<AccountContactRelation> accconList = new List<AccountContactRelation>();
        List<Account> accList = new List<Account>();
        for(Integer i=0;i<10;i++){
            Account newAcc = new Account();
            newAcc.Name = 'TestAccount'+i;
			accList.add(newAcc);         
        }        
        Test.StartTest();
        insert accList;
        
        accconList = [select id,accountid from AccountContactRelation];
		system.assert(accconList.size()==0);
        
        List<Contact> conList = new List<Contact>();
        for(Account acc:accList){
            for(Integer i=1;i<10;i++){ 
                Contact newCon = new Contact();
                newCon.LastName = 'TestContact'+i;
                newCon.Email = 'contact'+i+'@test.com';
                newCon.AccountId = acc.Id;
                conList.add(newCon);                
            }
        }
        insert conList;
        accconList = [select id,accountid from AccountContactRelation];
		system.assert(accconList.size()>0);
        Test.StopTest();
        
        Account acc0 = [Select Id, Name from Account where Name = 'TestAccount0'];        
        List<AccountContactRelation> acr = [select id,accountid from AccountContactRelation where accountid =: acc0.id];
        
        try
        {
            delete acr;
            // should throw exception, so fail test if get this far
            System.assert(false, 'Exception expected');
        }
        catch (Exception e)
        {
            // expected exception
        }
               
    }
}