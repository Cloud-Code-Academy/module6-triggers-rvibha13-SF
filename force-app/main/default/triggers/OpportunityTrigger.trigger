trigger OpportunityTrigger on Opportunity (before Update, before delete) {

         if(Trigger.isUpdate && Trigger.isBefore){
 
             for ( Opportunity opp : Trigger.new){
                       
                   if( opp.Amount == null || opp.Amount < 5000) {
 
                          opp.addError('Opportunity amount must be greater than 5000');
                   }

             }
         }

/*
     * Question 6
	 * Opportunity Trigger
	 * When an opportunity is deleted prevent the deletion of a closed won opportunity if the account industry is 'Banking'.
	 * Error Message: 'Cannot delete closed opportunity for a banking account that is won'
	 * Trigger should only fire on delete.
	 */


          
        if(Trigger.isBefore && Trigger.isDelete){

         //Collect all Account Ids of opportunities where opportunity's Stage name is Closed Won        

            Set<Id> accountIds = new Set<Id>();
                
              for ( Opportunity opp : Trigger.old){
                       
                    if( opp.StageName == 'Closed Won' && opp.AccountId != null){
                            
                           accountIds.add(opp.AccountId);
                    }

              }
             
           // Query for only Banking Accounts from the Account Ids we got from previous step


           Map <Id, Account>  bankingAccts = new Map <Id, Account> 
                                ([SELECT Id FROM Account WHERE Id IN: accountIds AND Industry = 'Banking']);



            // Check for the conditions and display error if conditions are met

                    for( Opportunity opp : Trigger.old) { 

                          if( opp.StageName == 'Closed Won' &&  bankingAccts.containsKey(opp.AccountId) ) {
                                   
                            opp.addError('Cannot delete closed opportunity for a banking account that is won');

                          }

                    }
        }

    /*
    * Question 7
    * Opportunity Trigger
    * When an opportunity is updated set the primary contact on the opportunity to the contact on the same account with the title of 'CEO'.
    * Trigger should only fire on update.
    */

    if(Trigger.isUpdate && Trigger.isBefore){
   
        //Set to hold the AccountIds of the opportunities that are being updated
           Set<Id> setOfAccounts = new Set<Id>(); 


         // Loop through every opportunity in Trigger.new and add their Account Ids to the set  
        for(Opportunity opps: Trigger.new)
        {
                if(opps.AccountId != null) {
                       setOfAccounts.add(opps.AccountId);

                }
        }
            
             if(setOfAccounts.isEmpty()){
                     return;
             }

            Map<Id,Contact> accountIdsToContact = new Map<Id,Contact>();

             for ( Contact c : [SELECT Id, AccountId FROM Contact WHERE AccountId IN :setOfAccounts AND Title = 'CEO'] ) {

                           accountIdsToContact.put(c.AccountId, c);


             }


         //assign the CEO to each opportunity

         for( Opportunity opps : Trigger.new) {
           
            Contact ceoContact = accountIdsToContact.get(opps.AccountId);

            if(ceoContact != null){
                opps.Primary_Contact__c = ceoContact.Id;
            }

         }


     }
}