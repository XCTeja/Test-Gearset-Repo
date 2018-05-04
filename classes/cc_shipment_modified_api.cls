global with sharing class cc_shipment_modified_api extends ccrz.cc_api_ShippingAndHandling
{
     /*
     public List<String> serviceList()
     {
         List<String> services=new List<String>();
         services.add('FIRST_OVERNIGHT');
         services.add('PRIORITY_OVERNIGHT');
         services.add('STANDARD_OVERNIGHT');
         services.add('FEDEX_2_DAY');
         services.add('FEDEX_EXPRESS_SAVER');
         services.add('FEDEX_GROUND');
         return services;
     }
     
     public override List<ccrz.cc_ctrl_hlpr_ShippingOption> getShippingOptions(String zipCode, String stateCode, String countryCode, Id cartId, String storeName)
     {
         system.debug('This method is being called ***:');
         List<ccrz.cc_ctrl_hlpr_ShippingOption> chsList=new List<ccrz.cc_ctrl_hlpr_ShippingOption>();
         
         for(Integer i=0; i<this.serviceList().size();i++)
         {
             ccrz.cc_ctrl_hlpr_ShippingOption chs=new ccrz.cc_ctrl_hlpr_ShippingOption();         
             
             chs.discount=0;
             chs.discountedShipCost=0;
             chs.price=Decimal.valueOf(this.getRsHttpCall(zipCode, stateCode, countryCode, serviceList().get(i)));
             chs.provider='FEDEX';
             chs.serviceName=serviceList().get(i);
             chs.systemReference=String.valueOf(i);
             chs.uid=String.valueOf(10+i);
             chs.uniqueId=String.valueOf(100+i);
             chsList.add(chs);             
         }
         return chsList;
     }
      
      
      */
     public List<String> getRsHttpCall()
    {
        Http h=new Http();
        HttpRequest req=new HttpRequest();
        String url='https://wsbeta.fedex.com:443/web-services';
        String soapXML='<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:v6="http://fedex.com/ws/rate/v6">';
        soapXML+='<soapenv:Header/>';
        soapXML+='<soapenv:Body>';
        soapXML+='<v6:RateRequest>';
        soapXML+='<v6:WebAuthenticationDetail>';
        soapXML+='<v6:UserCredential> ';
        soapXML+='<v6:Key>hAjxo2WcGoHDWZf7</v6:Key>';
        soapXML+='<v6:Password>a6KMHwB3Rmp37LmZC556DsIk3</v6:Password>';
        soapXML+=' </v6:UserCredential>';
        soapXML+='</v6:WebAuthenticationDetail>';
        soapXML+='<v6:ClientDetail>';
        soapXML+=' <v6:AccountNumber>510087887</v6:AccountNumber>';
        soapXML+=' <v6:MeterNumber>118721382</v6:MeterNumber>';
        soapXML+=' </v6:ClientDetail>';
        soapXML+=' <v6:Version>';
        soapXML+=' <v6:ServiceId>crs</v6:ServiceId>';
        soapXML+=' <v6:Major>6</v6:Major>';
        soapXML+=' <v6:Intermediate>0</v6:Intermediate>';
        soapXML+=' <v6:Minor>0</v6:Minor>';
        soapXML+=' </v6:Version>';
        soapXML+=' <v6:RequestedShipment>';
        soapXML+='<v6:ServiceType>FEDEX_2_DAY</v6:ServiceType>';
        soapXML+=' <v6:Shipper>';
        soapXML+=' <v6:AccountNumber>510087887</v6:AccountNumber>';
        soapXML+=' <v6:Contact>';
        soapXML+=' <v6:CompanyName>Xcentium</v6:CompanyName>';
        soapXML+=' <v6:PhoneNumber>4695001548</v6:PhoneNumber>';
        soapXML+=' </v6:Contact>';
        soapXML+=' <v6:Address>';
        soapXML+=' <v6:StreetLines>9221 newport ln</v6:StreetLines>';
        soapXML+=' <v6:StreetLines></v6:StreetLines>';
        soapXML+=' <v6:City>Mckinney</v6:City>';
        soapXML+=' <v6:PostalCode>75071</v6:PostalCode>';
        soapXML+=' <v6:CountryCode>US</v6:CountryCode>';
        soapXML+=' </v6:Address>';
        soapXML+=' </v6:Shipper>';
        soapXML+=' <v6:Recipient>';
        soapXML+=' <v6:Contact>';
        soapXML+=' <v6:PersonName>Sandeep Medikonda</v6:PersonName>';
        soapXML+=' <v6:CompanyName>Xcentium</v6:CompanyName>';
        soapXML+=' <v6:PhoneNumber>4695001548</v6:PhoneNumber>';
        soapXML+=' </v6:Contact>';
        soapXML+=' <v6:Address>';
        soapXML+=' <v6:StreetLines></v6:StreetLines>';
        soapXML+=' <v6:StreetLines></v6:StreetLines>';
        soapXML+=' <v6:City></v6:City>';
        soapXML+=' <v6:StateOrProvinceCode></v6:StateOrProvinceCode>';
        soapXML+=' <v6:PostalCode>75071</v6:PostalCode>';
        soapXML+=' <v6:CountryCode>US</v6:CountryCode>';
        soapXML+=' </v6:Address>';
        soapXML+=' </v6:Recipient>';
        soapXML+=' <v6:RateRequestTypes>LIST</v6:RateRequestTypes>';
        soapXML+=' <v6:PackageCount>1</v6:PackageCount>';
        soapXML+=' <v6:PackageDetail>INDIVIDUAL_PACKAGES</v6:PackageDetail>';
        soapXML+=' <v6:RequestedPackages>';
        soapXML+=' <v6:SequenceNumber>1</v6:SequenceNumber>';
        soapXML+=' <v6:InsuredValue>';
        soapXML+=' <v6:Currency>USD</v6:Currency>';
        soapXML+=' <v6:Amount>0</v6:Amount>';
        soapXML+=' </v6:InsuredValue>';
        soapXML+=' <v6:Weight>';
        soapXML+=' <v6:Units>KG</v6:Units>';
        soapXML+=' <v6:Value>2.0</v6:Value>';
        soapXML+=' </v6:Weight>';
        soapXML+=' <v6:Dimensions>';
        soapXML+=' <v6:Length>22</v6:Length>';
        soapXML+=' <v6:Width>16</v6:Width>';
        soapXML+=' <v6:Height>17</v6:Height>';
        soapXML+=' <v6:Units>CM</v6:Units>';
        soapXML+=' </v6:Dimensions>';
        soapXML+=' </v6:RequestedPackages>';
        soapXML+=' </v6:RequestedShipment>';
        soapXML+=' </v6:RateRequest>';
        soapXML+=' </soapenv:Body>';
        soapXML+='</soapenv:Envelope>';
        
        
        req.setBody(soapXML);
        req.setEndpoint(url);
        req.setMethod('POST');
        req.setHeader('Content-length', '1753');
        req.setHeader('Content-Type', 'text/xml;charset=UTF-8');
        req.setHeader('SOAPAction','getRates');
        
        HttpResponse res=h.send(req);
        /*
        String xml=res.getBody();
        system.debug('Response from the Web Srevice Call: '+xml);
        Integer ixml=xml.indexOf('FIRST_OVERNIGHT');
        xml= xml.substring(ixml);
        ixml=xml.indexOf('TotalNetCharge');
        xml= xml.substring(ixml);
        Integer jxml=xml.indexOf('</Amount>');
        ixml=xml.indexOf('<Amount>');
        xml=xml.substring(ixml+8,jxml);
        */
        /*
        Dom.Document doc = res.getBodyDocument();
        //dom.XmlNode node1= new dom.XmlNode();
        //node1[2];
        List<String> xmlList=new List<String>();
        //dom.XmlNode node1 = doc.getRootElement().getChildElements();
        
        for(dom.XmlNode node : doc.getRootElement().getChildElements())        
        {
            if(node.getName()=='Body')
            {
                system.debug('node name: ***'+node);
               //node1=node.getChildren();
               system.debug('doc children: ***'+doc);
               system.debug('Node children: ***'+node.ChildElements());
            }
            system.debug('outside if statement node name: ***'+node);
                
        }
        */
        DOM.Document doc = res.getBodyDocument();  
          {
            //doc.load(res.getBody());    
            DOM.XMLNode root = doc.getRootElement();
            parsing(root);
            return strList;
            
          } 
          
        //return xmlList;//+' TotalNetCharge***: '+totalNetCharge+' Amount***: '+amount;
    }
    
    public List<String> strList=new List<String>();
    
    public String parsing(DOM.XMLNode node)
    {
        String result='\n';
        system.debug('Node of child elements: ***'+node.getChildElements());
        system.debug('Node of child elements: ***'+node.getChildElement('ServiceType','Dom'));
        
        //result=parsing();
        //if (node.getAttributeCount() > 0) {
        //if()
        {
        
        }
            for (Dom.XMLNode child: node.getChildren()) {
            
            if(child.getName()=='Body')
            {
                system.debug('Child service type name: ***'+child.getName());
                result += parsing(child);
            }
            if(child.getName()=='RateReply')
            {
                system.debug('Child service type name: ***'+child.getName());
                result += parsing(child);
            }
            if(child.getName()=='ServiceType')
            {
                system.debug('Child service type name: ***'+child.getName());
                system.debug('Child service type name: ***'+child.getText());
                strList.add(child.getText());
                result += parsing(child);
            }
            
            if(child.getName()=='RateReplyDetails')
            {
            system.debug('Child service type name: ***'+child.getName());
            result += parsing(child);
            }
           
              
            }
            return result;
        //}
        return result;
        
    }
}