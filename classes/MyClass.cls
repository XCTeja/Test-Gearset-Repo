global class MyClass {
   
    global String dummy{get; set;}
    
    public MyClass()
    {
    
    }
    
    @RemoteAction
    global static List<String> remoteInitAuth(String submissionId, String cartId, String cardStored, String formData) { //requires params submissionId, cardStored, cartId
        
        Integer iCart=cartId.indexOf('cartID=');
        String cart=cartId.substring(iCart+7);
        Integer jCart=cart.indexOf(',');
        cart=cart.substring(0,jCart-1);        
        Integer iCard=formData.indexOf('accountNumber=');
        String cardNum=formData.substring(iCard+13);
        Integer jCard=cardNum.indexOf(',');
        cardNum=cardNum.substring(0,jCard);
        Integer iExp=formData.indexOf('expirationMonth=');
        String expNum=formData.substring(iExp+16);
        Integer jExp=expNum.indexOf(',');
        expNum=expNum.substring(0,jExp);
        Integer iExpYr=formData.indexOf('expirationYear=');
        String expYear=formData.substring(iExpYr+17);
        Integer jExpYr=expYear.indexOf(',');
        expyear=expyear.substring(0,jExpYr);
        Integer icardCode=formData.indexOf('cardCode=');
        String cardCode=formData.substring(icardCode+9);
        Integer jcardCode=cardCode.indexOf(',');
        cardCode=cardCode.substring(0,jcardCode);
        system.debug('cardNum****'+cardNum);
        system.debug('expNum****'+expNum);
        system.debug('expyear***'+expyear);
        system.debug('cardCode***'+cardCode);
        ccrz__E_Cart__c cData=[select ccrz__TotalAmount__c,ccrz__Account__r.id, ccrz__Account__r.name, ccrz__BillTo__r.ccrz__FirstName__c,  ccrz__BillTo__r.ccrz__LastName__c, ccrz__BillTo__r.ccrz__CompanyName__c, ccrz__BillTo__r.ccrz__AddressFirstline__c, ccrz__BillTo__r.ccrz__AddressSecondline__c, ccrz__BillTo__r.ccrz__AddressThirdline__c, ccrz__BillTo__r.ccrz__City__c, ccrz__BillTo__r.ccrz__StateISOCode__c, ccrz__BillTo__r.ccrz__PostalCode__c from ccrz__E_Cart__c where ccrz__EncryptedId__c=:cart];
        String fName=String.valueOf(cData.ccrz__BillTo__r.ccrz__FirstName__c);
        String lName=String.valueOf(cData.ccrz__BillTo__r.ccrz__LastName__c);
        String compName=String.valueOf(cData.ccrz__BillTo__r.ccrz__CompanyName__c);
        String add1=String.valueOf(cData.ccrz__BillTo__r.ccrz__AddressFirstline__c);
        String add2=String.valueOf(cData.ccrz__BillTo__r.ccrz__AddressSecondline__c);
        String city=String.valueOf(cData.ccrz__BillTo__r.ccrz__City__c);
        String state=String.valueOf(cData.ccrz__BillTo__r.ccrz__StateISOCode__c);
        String postal=String.valueOf(cData.ccrz__BillTo__r.ccrz__PostalCode__c);
        String totAmount=String.valueOf(cData.ccrz__TotalAmount__c);
        
        //HTTP request begins
                Http h=new Http();
                HttpRequest req=new HttpRequest();
                String url='https://apitest.authorize.net/xml/v1/request.api';
                String soapXML='<createTransactionRequest xmlns="AnetApi/xml/v1/schema/AnetApiSchema.xsd">';
                soapXML+='<merchantAuthentication>';
                soapXML+='<name>536xEv2FnF5z</name>';
                soapXML+='<transactionKey>96Bs3GULrd9s26sN</transactionKey>';
                soapXML+='</merchantAuthentication>';
                soapXML+='<refId>123456</refId>';
                soapXML+='<transactionRequest>';
                soapXML+='<transactionType>authCaptureTransaction</transactionType>';
                soapXML+='<amount>'+totAmount+'</amount>';
                soapXML+='<payment>';
                soapXML+='<creditCard>';
                soapXML+='<cardNumber>'+cardNum+'</cardNumber>';
                soapXML+='<expirationDate>'+expNum+expyear+'</expirationDate>';
                soapXML+='<cardCode>'+cardCode+'</cardCode>';
                soapXML+='</creditCard>';
                soapXML+='</payment>';
                soapXML+='<order>';
                soapXML+='<invoiceNumber>INV-12345</invoiceNumber>';
                soapXML+='<description>Product Description</description>';
                soapXML+='</order>';
                soapXML+='<lineItems>';
                soapXML+='<lineItem>';
                soapXML+='<itemId>1</itemId>';
                soapXML+='<name>vase</name>';
                soapXML+='<description>Cannes logo </description>';
                soapXML+='<quantity>18</quantity>';
                soapXML+='<unitPrice>45.00</unitPrice>';
                soapXML+='</lineItem>';
                soapXML+='</lineItems>';
                soapXML+='<tax>';
                soapXML+='<amount>4.26</amount>';
                soapXML+='<name>level2 tax name</name>';
                soapXML+='<description>level2 tax</description>';
                soapXML+='</tax>';
                soapXML+='<duty>';
                soapXML+='<amount>8.55</amount>';
                soapXML+='<name>duty name</name>';
                soapXML+='<description>duty description</description>';
                soapXML+='</duty>';
                soapXML+='<shipping>';
                soapXML+='<amount>4.26</amount>';
                soapXML+='<name>level2 tax name</name>';
                soapXML+='<description>level2 tax</description>';
                soapXML+='</shipping>';
                soapXML+='<poNumber>456654</poNumber>';
                soapXML+='<customer>';
                soapXML+='<id>99999456654</id>';
                soapXML+='</customer>';
                soapXML+='<billTo>';
                soapXML+='<firstName>'+fName+'</firstName>';
                soapXML+='<lastName>'+lName+'</lastName>';
                soapXML+='<company>'+compName+'</company>';
                soapXML+='<address>'+add1+'</address>';
                soapXML+='<city>'+city+'</city>';
                soapXML+='<state>'+state+'</state>';
                soapXML+='<zip>'+postal+'</zip>';
                soapXML+='<country>USA</country>';
                soapXML+='</billTo>';
                soapXML+='<shipTo>';
                soapXML+='<firstName>China</firstName>';
                soapXML+='<lastName>Bayles</lastName>';
                soapXML+='<company>Thyme for Tea</company>';
                soapXML+='<address>12 Main Street</address>';
                soapXML+='<city>Pecan Springs</city>';
                soapXML+='<state>TX</state>';
                soapXML+='<zip>44628</zip>';
                soapXML+='<country>USA</country>';
                soapXML+='</shipTo>';
                soapXML+='<customerIP>192.168.1.1</customerIP>';
                soapXML+='<!-- Uncomment this section for Card Present Sandbox Accounts -->';
                soapXML+='<!-- <retail><marketType>2</marketType><deviceType>1</deviceType></retail> -->';
                soapXML+='<transactionSettings>';
                soapXML+='<setting>';
                soapXML+='<settingName>testRequest</settingName>';
                soapXML+='<settingValue>false</settingValue>';
                soapXML+='</setting>';
                soapXML+='</transactionSettings>';
                soapXML+='<userFields>';
                soapXML+='<userField>';
                soapXML+='<name>MerchantDefinedFieldName1</name>';
                soapXML+='<value>MerchantDefinedFieldValue1</value>';
                soapXML+='</userField>';
                soapXML+='<userField>';
                soapXML+='<name>favorite_color</name>';
                soapXML+='<value>blue</value>';
                soapXML+='</userField>';
                soapXML+='</userFields>';
                soapXML+='</transactionRequest>';
                soapXML+='</createTransactionRequest>';
                
                
                req.setBody(soapXML);
                req.setEndpoint(url);
                req.setMethod('POST');
                req.setHeader('Content-Type', 'text/xml');
                
                HttpResponse resp=h.send(req);
                String xml=resp.getBody();
                system.debug('Response from the Web Srevice Call: '+xml);
                Integer ixml=xml.indexOf('<transId>');
                Integer jxml=xml.indexOf('</transId>');
                String transCode=xml.substring(ixml+9,jxml);//Transaction code
                Integer iToken=xml.indexOf('<code>');
                Integer jToken=xml.indexOf('</code>');
                String token=xml.substring(iToken+6,jToken);//token
                
                
        String accountNumber=String.valueOf(cData.ccrz__Account__r.id);//Accountnumber
        //String transactionCode = xml.substring(ixml+9,jxml);
              //HTTP request ends
        
        System.debug('X======================= ' + cardStored);
        System.debug('X======================= ' + cartId);
        System.debug('X======================= ' + submissionId);
        System.debug('X======================= ' + formData);
        System.debug('X======================= ' + xml);
        //String accountNumber = 'Succesful***';
        String accountType = 'abc***';
        String ammount = totAmount;
        String transactionType = 'Card';
        String paymentType = 'abc***';
        String storefront = 'defaultstore';
        String verificationCode = 'Succesful';
        //String accountName = 'abc***';
        String transactionSubcode = 'def***';
        //String token = 'Succesful***';
        String accountName=String.valueOf(cData.ccrz__Account__r.name);
        
        List<String> returnList = new List<String>();
        returnList.add(accountNumber);//0
        returnList.add(transCode);//1
        returnList.add(accountType);//2
        returnList.add(token);//3
        returnList.add(ammount);//4
        returnList.add(paymentType);//5
        returnList.add(storefront);//6
        returnList.add(verificationCode);//7
        returnList.add(accountName);//8
        returnList.add(transactionType);//9
        returnList.add(cart);//10
        returnList.add('Successful');//11
        returnList.add(expNum);//12
        returnList.add(expyear);//13
        system.debug('Paymentdata****'+returnList);
        return returnList;
    
    }
    
}