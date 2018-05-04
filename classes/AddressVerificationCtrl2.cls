public class AddressVerificationCtrl2 {
        
        private string objectId ;
        public AddressObj CurrentAddress {get; set;}
        public AddressObj ReturnedAddress {get; set;}
        
        public Map<String, String> USPSResult  {get; set;}
        
        public string ErrorMsg {get; set;}
        
        public string address1 {get; set;}
        public string address2 {get; set;}
        public string city {get; set;}
        public string state {get; set;}
        public string zip4 {get; set;}
        public string zip5 {get; set;}
        
        Public string myInput{get;set;}
        Public string myoutput{get;set;}
        
        
        
        private boolean isValid  ;
        
        public void Init () {
            
            
        }
        
        
        public void CheckAddress () {
            
            
            system.debug('address1 ====> ' +  address1);
            system.debug('address2 ====> ' +  address2);
            system.debug('city ====> ' +  city);
            system.debug('state ====> ' +  state);
            system.debug('zip4 ====> ' +  zip4);
            system.debug('zip5 ====> ' + zip5 );
            
            
            XC_USPS_AddressVerification xcusps = new XC_USPS_AddressVerification();
            USPSResult  =  xcusps.validateUSPSAddress(address1, address2, city, state,  zip5, zip4);
            
            system.debug('USPSResult inside the addressverificationcontroller2 ======> ' + USPSResult);
            
            AddressObj ReturnedAddress = new AddressObj ();
            
            ReturnedAddress.Address =  USPSResult.get('Address2');   
            ReturnedAddress.City = USPSResult.get('City');  
            ReturnedAddress.State = USPSResult.get('State');  
            ReturnedAddress.Zip5 = USPSResult.get('Zip5');  
            ReturnedAddress.Zip4 = USPSResult.get('Zip4');            
             
            system.debug('ReturnedAddress inside the addressverificationcontroller2 ======> ' + ReturnedAddress);
     
            
        }
   
        
              
        private void VerifyAddress () {
            
     
            
            
            // return returnedAddress  ;
            
            
        }
     
        public PageReference Cancel () {
            PageReference pgRef = new PageReference('/' + objectId) ;
            pgRef.setRedirect(true);
            return pgRef;
        }
        

       
        public class AddressObj {
            public string Address {get; set;}
            public string City {get; set;}
            public string State {get; set;}
            public string Zip5 {get; set;}
            public string Zip4 {get; set;}
        }
        
    }