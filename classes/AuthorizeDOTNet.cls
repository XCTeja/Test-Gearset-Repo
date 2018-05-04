public class AuthorizeDOTNet
{

    public PageReference result() {
       this.getRsHttpCall();
        PageReference newocp = new PageReference('/apex/AuthorizeDOTNet1');
        return newocp;
    }

     public AuthorizeDOTNet() 
    {
        //this.ord=(Order__c)controller.getRecord();
    

    }
    
    public String rsHttpCall='';

    public String getRsHttpCall()
    {
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
        soapXML+='<amount>5</amount>';
        soapXML+='<payment>';
        soapXML+='<creditCard>';
        soapXML+='<cardNumber>5424000000000015</cardNumber>';
        soapXML+='<expirationDate>1220</expirationDate>';
        soapXML+='<cardCode>999</cardCode>';
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
        soapXML+='<firstName>Ellen</firstName>';
        soapXML+='<lastName>Johnson</lastName>';
        soapXML+='<company>Souveniropolis</company>';
        soapXML+='<address>14 Main Street</address>';
        soapXML+='<city>Pecan Springs</city>';
        soapXML+='<state>TX</state>';
        soapXML+='<zip>44628</zip>';
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
        
        HttpResponse res=h.send(req);
        String xml=res.getBody();
        system.debug('Response from the Web Srevice Call: '+xml);
        Integer ixml=xml.indexOf('<transId>');
        Integer jxml=xml.indexOf('</transId>');
        xml=xml.substring(ixml+9,jxml);

        return xml;
    }
    
  
}