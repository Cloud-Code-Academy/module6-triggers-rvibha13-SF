trigger AccOppTrigger on Account (before insert, after insert) {

        if(Trigger.isInsert && Trigger.isBefore){
          for(Account acc : Trigger.new){
                 if( acc.Type == null){
                       acc.Type = 'Prospect';
                 }
          }
        }   
     
    
    if(Trigger.isInsert && Trigger.isBefore){
            
           for( Account acc : Trigger.new){
                 
                  if( acc.ShippingStreet != null || 
                      acc.ShippingCity  != null ||
                      acc.ShippingState != null ||
                      acc.ShippingPostalCode != null ||
                      acc.ShippingCountry != null )  

                  {
                         acc.BillingStreet = acc.ShippingStreet;
                         acc.BillingCity = acc.ShippingCity;
                         acc.BillingState = acc.ShippingState;
                         acc.BillingPostalCode = acc.ShippingPostalCode;
                         acc.BillingCountry = acc.ShippingCountry;
                  }
           }
    }

               
       if(Trigger.isBefore && Trigger.isInsert) { 
  
              for( Account acc : Trigger.new ){
  
                if( acc.Phone != null &&
                    acc.website != null &&
                    acc.Fax != null ) {
                      
                      acc.Rating = 'Hot';
                    }
              }
            
       }
                    
  
        if(Trigger.isAfter && Trigger.isInsert){
                  
            List<Contact>  newCont = new List<Contact>(); 

             for( Account acc : Trigger.new) {
            
                           Contact c = new Contact
                           
                           (
                                AccountId = acc.Id,
                                LastName = 'DefaultContact',
                                Email = 'default@email.com'
                           );

                           newCont.add(c);
             }

                 insert newCont;

        }


}