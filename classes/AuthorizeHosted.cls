global class AuthorizeHosted {

    

    public String postUrl { set; }
    
    public String getPostUrl()
    {
        system.debug('getPostUrl*****');
        return 'https://test.authorize.net/gateway/transact.dll';
    }
    
    public String cartId;
    
    public AuthorizeHosted()
    {
        cartId=Apexpages.currentPage().getParameters().get('cartID');
        system.debug('CartID*****'+cartId);
    }

    public String dummy { get; set; }
    
    public String tmpStmp;
    
    public String getTmpStmp() { 
    
        return String.valueOf(DateTime.now().getTime()/1000);
    }
    
     @RemoteAction
    global static String remoteInitAuth(String crtId) { 
        
        ccrz__E_Cart__c cData=[select id, ccrz__TotalAmount__c from ccrz__E_Cart__c limit 1];
        String amt='200';//String.valueOf(cData.ccrz__TotalAmount__c);
        system.debug('Remote action CartID****'+crtId);
        String amount = '200';
        system.debug('remoteInitAuth*****'+amt);
        return amt;
    }
    
     @RemoteAction
    global static String fPrint(String crtId, String randomNum) { 
        
        ccrz__E_Cart__c cData=[select id, ccrz__TotalAmount__c from ccrz__E_Cart__c limit 1];
        String amt='200.00';//String.valueOf(cData.ccrz__TotalAmount__c);
        String transId='779X2cLc7M3f8uy8';
        String apiLogin='4pHq23dNxG';
        String timeStamp=String.valueOf(DateTime.now().getTime()/1000);
        Integer i=Integer.valueOf(randomNum);
        String fingersource=apiLogin+'^'+i+'^'+timeStamp+'^'+amt+'^';
        blob hmacmd5=crypto.generateMac('hmacMD5', blob.valueOf(fingersource), blob.valueOf(transId));
        system.debug('FingerPrint******'+EncodingUtil.convertToHex(hmacmd5));
        system.debug('FingerPrint******'+hmacmd5);
        system.debug('FingerPrint******'+'hmacMD5'+blob.valueOf(fingersource)+ blob.valueOf(transId));
        system.debug('FingerSOURCE******'+fingersource);
        system.debug('timeStamp******'+timeStamp);
        //String str=setAmt(cartId);
        //system.debug('FingerPrint cartID******'+str);
        List<String> returnList = new List<String>();
        String str=EncodingUtil.convertToHex(hmacmd5);
        returnList.add(str);
        system.debug('fPrint*****'+str);
        return str;
    }
        
}