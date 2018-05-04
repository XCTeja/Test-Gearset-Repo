global class XCPayment {

    public XCPayment() {}
  
    public PageReference xCAction() {
      //boolean success = Site.forgotPassword(username);
      //PageReference pageRef = new PageReference('http://www.google.com');

      //pr.setRedirect(true);
      PageReference pageRef = ApexPages.currentPage();
      
      return pageRef;
    }
    
    /*
    global void xCAction()
    {
        system.debug('xCAction method?????'+'XCAction');
        ccrz.ccLog.log(System.LoggingLevel.DEBUG, 'XCAction***: ', 'Name has been read');
        /*Sample_Trtansaction__c stc=new Sample_Trtansaction__c();
        stc.name=name;
        stc.Card_Number__c='';
        stc.Payment_type__c=paymentType;
        stc.Expiration_month__c=expMonth;
        stc.Expiration_year__c=expYear;
        ccrz.ccLog.log(System.LoggingLevel.DEBUG, 'All the values stored***: ', stc);
        system.debug('xCAction method?????'+stc);
        //insert stc;
        PageReference pageRef = new PageReference('https://xccctraining-developer-edition.na30.force.com/DefaultStore/?cclog=abcd');
        //return pageRef;
    } 
    */
    public String cardNo{get; set;}
    /*
    public void setCardNo(String str)
    {
        cardNo=str;
        system.debug('Debug apex from set method cardNo??????'+str);
    }
    
    public String getCardNo()
    {
        system.debug('Debug apex from get method cardNo??????'+'cardNo has been read');
        return '123456789';
    }
    */
    public String name{get; set;}
    /*    
    public String getName()
    {
        ccrz.ccLog.log(System.LoggingLevel.DEBUG, 'getName of the card holder***: ', 'Name has been read');
        system.debug('Debug apex from get methodname??????'+'abcd');
        return 'abcdef2';
    }
    
    public void setName(String str)
    {
        name=str;
         ccrz.ccLog.log(System.LoggingLevel.DEBUG, 'Name of the card holder***: ', name);
         system.debug('Debug apex from set method name??????'+str);
    }
    */
    public String paymentType{get; set;}
    
    public String expMonth{get; set;}
    
    public String expYear{get; set;}
    
    
}