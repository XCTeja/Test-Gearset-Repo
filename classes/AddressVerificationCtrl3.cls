public  with sharing class AddressVerificationCtrl3 {
 
  private string objectId ;
   // public AddressObj CurrentAddress {get; set;}
public AddressObj ReturnedAddress {get; set;}
  public string ErrorMsg {get; set;}
  //public string AccountSelect {get; set;}

  //private sObject sObj ;
  //private enum  objType {ACCOUNT , CONTACT, LEAD}
  //private objType oType {get;set;}
  //private boolean isValid  ;

        
        public string address1 {get; set;}
        public string address2 {get; set;}
        public string city {get; set;}
        public string state {get; set;}
        public string zip4 {get; set;}
        public string zip5 {get; set;}
            
        
        public Map<String, String> USPSResult  {get; set;}    
    
    
    
  public void Init () {

 

  }

  public void CheckAddress () {
    	ReturnedAddress  =  VerifyAddress2 () ;
      system.debug('ReturnedAddress inside original ' + ReturnedAddress);
  }
  public PageReference Cancel () {
    PageReference pgRef = new PageReference('/' + objectId) ;
    pgRef.setRedirect(true);
    return pgRef;
  }

        
        public AddressObj VerifyAddress2 () {
            
            
            system.debug('address1 ====> ' +  address1);
            //system.debug('address2 ====> ' +  address2);
            system.debug('city ====> ' +  city);
            system.debug('state ====> ' +  state);
          //  system.debug('zip4 ====> ' +  zip4);
            system.debug('zip5 ====> ' + zip5 );
            
            
            XC_USPS_AddressVerification xcusps = new XC_USPS_AddressVerification();
            USPSResult  =  xcusps.validateUSPSAddress(address1,  city, state,  zip5 );
            
            system.debug('USPSResult inside the addressverificationcontroller2 ======> ' + USPSResult);
            
            AddressObj ReturnedAddress = new AddressObj ();
            
            ReturnedAddress.Address =  USPSResult.get('Address2');   
            ReturnedAddress.City = USPSResult.get('City');  
            ReturnedAddress.State = USPSResult.get('State');  
            ReturnedAddress.Zip5 = USPSResult.get('Zip5');  
            ReturnedAddress.Zip4 = USPSResult.get('Zip4');            
             
            system.debug('ReturnedAddress inside the addressverificationcontroller2 ======> ' + ReturnedAddress);
     
            return ReturnedAddress;
        }
    
    
  /*  
  private AddressObj VerifyAddress () {

    ErrorMsg = '';

      List<Address_Verification__c> mcs = Address_Verification__c.getall().values();
 
    //string requestString = '<AddressValidateRequest USERID="' + Address_Verification__c.getValues('USPS UserName').Value__c + '">' ;
  
      string requestString = '<AddressValidateRequest USERID="' + Address_Verification__c.getInstance('test1').USPS_UserName__c + '">' ;       
      requestString += '<Address>';
      requestString += '<Address1></Address1>';
      requestString += '<Address2>' + CurrentAddress.Address + '</Address2>';
      requestString += '<City>' + CurrentAddress.City + '</City>';
      requestString += '<State>' + CurrentAddress.State + '</State>';
      requestString += '<Zip5>' + CurrentAddress.Zip5 + '</Zip5>';
      requestString += '<Zip4></Zip4>';
      requestString += '</Address>';
      requestString += '</AddressValidateRequest>';

    //string ENDPOINT = Address_Verification__c.getValues('EndPoint').Value__c + '/ShippingAPI.dll?API=Verify&XML=' ;
    string ENDPOINT =  Address_Verification__c.getInstance('test1').Endpoint__c + '/ShippingAPI.dll?API=Verify&XML=' ;

    system.debug('endpoint is this: ====> ' + ENDPOINT);
      
    Http h = new http();
    HttpRequest req = new HttpRequest();

    req.setEndpoint(ENDPOINT + EncodingUtil.urlEncode(requestString , 'UTF-8') );
    req.setMethod('GET');
    HttpResponse res = h.send(req);
    AddressObj returnedAddress = new AddressObj();
    System.debug(res.getBody() ) ;
    isValid = false;
    if (!isError (res.getBodyDocument())) {
      returnedAddress = GetValidAddress(res.getBodyDocument() );
      isValid = true;
    }




    return returnedAddress  ;


  }
*/
    
    /*
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
*/
    
  /*  
  private AddressObj GetValidAddress (Dom.Document doc) {
    AddressObj retObj = new AddressObj ();
    dom.XmlNode rootEL = doc.getRootElement();

    for (Dom.XMLNode child : rootEL.getChildElements()) {

      for (Dom.XMLNode node : child.getChildElements()) {
        if ( node.getName() == 'Address2' )
          retObj.Address = node.getText();
        if ( node.getName() == 'City' )
          retObj.City = node.getText();
        if ( node.getName() == 'State' )
          retObj.State = node.getText();
        if ( node.getName() == 'Zip5' )
          retObj.Zip5 = node.getText();
        if ( node.getName() == 'Zip4' )
          retObj.Zip4 = node.getText();
      }

    }

    return retObj;


  }*/

  public class AddressObj {
    public string Address {get; set;}
    public string City {get; set;}
    public string State {get; set;}
    public string Zip5 {get; set;}
    public string Zip4 {get; set;}
  }
    
    
    
    /*
  public PageReference SaveAddress () {

    if (!isValid ) {
      ErrorMsg =  'Address has not been validated' ;
      return null;
    }
    if (oType == objType.ACCOUNT ) {
      if (AccountSelect == 'Billing') {
        sObj.put('BillingStreet' , ReturnedAddress.Address );
        sObj.put('BillingCity' , ReturnedAddress.City );
        sObj.put('BillingState' , ReturnedAddress.State );
        sObj.put('BillingPostalCode' , ReturnedAddress.Zip5 );
      }
      if (AccountSelect == 'Shipping') {
        sObj.put('ShippingStreet' , ReturnedAddress.Address );
        sObj.put('ShippingCity' , ReturnedAddress.City );
        sObj.put('ShippingState' , ReturnedAddress.State );
        sObj.put('ShippingPostalCode' , ReturnedAddress.Zip5 );
      }
    }
    if (oType == objType.CONTACT ) {
      sObj.put('MailingStreet' , ReturnedAddress.Address );
      sObj.put('MailingCity' , ReturnedAddress.City );
      sObj.put('MailingState' , ReturnedAddress.State );
      sObj.put('MailingPostalCode' , ReturnedAddress.Zip5 );
    }
    if (oType == objType.LEAD ) {
      sObj.put('Street' , ReturnedAddress.Address );
      sObj.put('City' , ReturnedAddress.City );
      sObj.put('State' , ReturnedAddress.State );
      sObj.put('PostalCode' , ReturnedAddress.Zip5 );
    }
    update sObj;
      
    return null;
    //return Cancel();
  }*/
  /*
  public void SetData () {
    ErrorMsg = '';
    
    if (oType == objType.ACCOUNT ) {
      sObj = [select BillingStreet, BillingCity, BillingState, BillingPostalCode, ShippingStreet, ShippingCity, ShippingState, ShippingPostalCode from Account where id = :objectId] ;
      CurrentAddress = new AddressObj () ;

      if (AccountSelect == 'Billing') {
        CurrentAddress.Address = String.ValueOf(sObj.get('BillingStreet') );
        CurrentAddress.City = String.ValueOf(sObj.get('BillingCity')) ;
        CurrentAddress.State = String.ValueOf(sObj.get('BillingState')) ;
        CurrentAddress.Zip5 = String.ValueOf(sObj.get('BillingPostalCode')) ;
      }
      if (AccountSelect == 'Shipping') {
        CurrentAddress.Address = String.ValueOf(sObj.get('ShippingStreet') );
        CurrentAddress.City = String.ValueOf(sObj.get('ShippingCity')) ;
        CurrentAddress.State = String.ValueOf(sObj.get('ShippingState')) ;
        CurrentAddress.Zip5 = String.ValueOf(sObj.get('ShippingPostalCode')) ;
      }
    }
    if (oType == objType.CONTACT ) {
      sObj = [select MailingStreet, MailingCity, MailingState, MailingPostalCode from Contact where id = :objectId] ;
      CurrentAddress = new AddressObj () ;
      CurrentAddress.Address = String.ValueOf(sObj.get('MailingStreet') );
      CurrentAddress.City = String.ValueOf(sObj.get('MailingCity')) ;
      CurrentAddress.State = String.ValueOf(sObj.get('MailingState')) ;
      CurrentAddress.Zip5 = String.ValueOf(sObj.get('MailingPostalCode')) ;
    }
    if (oType == objType.LEAD ) {
      sObj = [select Street, City, State, PostalCode from Lead where id = :objectId] ;
      CurrentAddress = new AddressObj () ;
      CurrentAddress.Address = String.ValueOf(sObj.get('Street') );
      CurrentAddress.City = String.ValueOf(sObj.get('City')) ;
      CurrentAddress.State = String.ValueOf(sObj.get('State')) ;
      CurrentAddress.Zip5 = String.ValueOf(sObj.get('PostalCode')) ;
    }

    isValid  = false;
  }
   	*/ 
    
     /*
  public boolean getIsAccount () { 
    boolean retVal = false;
    if (oType == objType.ACCOUNT)
      retVal = true;
    return retVal;
  }
*/
}