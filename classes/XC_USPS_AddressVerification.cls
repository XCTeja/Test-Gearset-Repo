public class XC_USPS_AddressVerification {
     
    public AddressObj CurrentAddress {get; set;}
    public AddressObj ReturnedAddress {get; set;}    
    
    public static String USPS_customsetting  {get; set;}
    public static String USPS_username  {get; set;}
    public static String USPS_endpoint {get; set;}
    
    
    public Map<String, String> USPSResult  {get; set;}
    public string ErrorMsg {get; set;}
    
    private boolean isValid  ;
    


    public Map<String, String>   validateUSPSAddress(string address1, string city, string state, string zip5   ) {
        
 system.debug('inside is ====> ' );

        //Store the passed in values in the object properties;
        
        AddressObj CurrentAddress = new AddressObj () ;
        CurrentAddress.Address1 = address1;
        //CurrentAddress.Address2 = address2;
        CurrentAddress.city = city;
        CurrentAddress.state = state;
        CurrentAddress.zip5 = zip5;
        //CurrentAddress.zip4 = zip4;
        
        system.debug('CurrentAddress is ====> ' + CurrentAddress);

        //get the USPS Account and endpoint information
        USPS_customsetting ='test1';
        USPS_username = Address_Verification__c.getInstance(USPS_customsetting).USPS_UserName__c;
        USPS_endpoint = Address_Verification__c.getInstance(USPS_customsetting).Endpoint__c  ;
         system.debug('USPS_username is ====> ' + USPS_username);
        
        USPSResult = VerifyAddress (CurrentAddress);
        return USPSResult;
    }
    
    public void Test1(){
    	
        system.debug('inside test1');
        
    } 
    
    
    public  Map<String, String> VerifyAddress (AddressObj CurrentAddress ) {
         system.debug('CurrentAddress2222222222 is ====> ' + CurrentAddress);
        string requestString = '<AddressValidateRequest USERID="' + USPS_username + '">' ;       
        requestString += '<Address>';
        requestString += '<Address1>' + CurrentAddress.Address1 + '</Address1>';
        requestString += '<Address2>' + CurrentAddress.Address2 + '</Address2>';
        requestString += '<City>' + CurrentAddress.City + '</City>';
        requestString += '<State>' + CurrentAddress.State + '</State>';
        requestString += '<Zip5>' + CurrentAddress.Zip5 + '</Zip5>';
        requestString += '<Zip4>' + CurrentAddress.Zip4 + '</Zip4>';
        requestString += '</Address>';
        requestString += '</AddressValidateRequest>';
        
        string ENDPOINT = USPS_endpoint + '/ShippingAPI.dll?API=Verify&XML=' ;
        
        system.debug('endpoint is this: ====> ' + ENDPOINT);
       
        Http h = new http();
        HttpRequest req = new HttpRequest();
         system.debug('endpoint is this: ====> ' + ENDPOINT + EncodingUtil.urlEncode(requestString , 'UTF-8'));
        req.setEndpoint(ENDPOINT + EncodingUtil.urlEncode(requestString , 'UTF-8') );
        req.setMethod('GET');
        HttpResponse res = h.send(req);
        AddressObj returnedAddress = new AddressObj();
        System.debug(res.getBody() ) ;
        isValid = false;
        if (!isError (res.getBodyDocument())) {
            USPSResult = GetValidAddress(res.getBodyDocument() );
            isValid = true;
        }
        
         system.debug('returnedAddress is this: ====> ' + returnedAddress);
        
        
       return USPSResult  ;
        
        
    }
    
    private boolean isError (Dom.Document doc) {
        
        boolean retVal = false;
        
        dom.XmlNode rootEL = doc.getRootElement();
        
        for (Dom.XMLNode child : rootEL.getChildElements()) {
            
            for (Dom.XMLNode node : child.getChildElements()) {
                if ( node.getName() == 'Error' ) {
                    retVal = true;
                    for (Dom.XMLNode node2 : node.getChildElements()) {
                        if ( node2.getName() == 'Description' )
                            ErrorMsg =  node2.getText();
                    }
                }
                
            }
            
        }
        
        return retVal;
    }
    
    
    
    private  Map<String, String> GetValidAddress (Dom.Document doc) {
        AddressObj retObj = new AddressObj ();
  		 Map<String, String> localResponseMap = new Map<String, String>();
        
        dom.XmlNode rootEL = doc.getRootElement();
        
        for (Dom.XMLNode child : rootEL.getChildElements()) {
            
            for (Dom.XMLNode node : child.getChildElements()) {
                
                if ( node.getName() == 'Address1' ){
                      retObj.Address1 = node.getText();
                	localResponseMap.put('Address1', node.getText());                  
                }

                if ( node.getName() == 'Address2' ){
                     retObj.Address2 = node.getText();
                	localResponseMap.put('Address2', node.getText());                   
                }

                if ( node.getName() == 'City' ){
                     retObj.City = node.getText();
                	localResponseMap.put('City', node.getText());                   
                }

                if ( node.getName() == 'State' ){
                    retObj.State = node.getText();
                	localResponseMap.put('State', node.getText());                    
                }

                if ( node.getName() == 'Zip5' ){
                     retObj.Zip5 = node.getText();
                	localResponseMap.put('Zip5', node.getText());                   
                }

                if ( node.getName() == 'Zip4' ){
                      retObj.Zip4 = node.getText();
                	localResponseMap.put('Zip4', node.getText());                  
                }

            }
            
        }
        
        return localResponseMap;
        
        
    }
    
    public class AddressObj {
        public string Address1 {get; set;}
        public string Address2 {get; set;}
        public string City {get; set;}
        public string State {get; set;}
        public string Zip5 {get; set;}
        public string Zip4 {get; set;}
    }        
}