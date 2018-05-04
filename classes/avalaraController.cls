public class avalaraController
{
     
    public static String avalara_customsetting  {get; set;}
    public static String avalara_password  {get; set;}
    public static String avalara_accountnumber  {get; set;}
    public static String avalara_endpoint {get; set;}
        
    //string variable to show api result
    public string result{get;set;}
    //string variable to hold amount of line item
    public String amount { get; set; }
    //string varriable to hold quantity of line item
    public String count { get; set; }
    
    //string varriable to hold total amount
    public String total { get; set; }  
    //string varriable to hold postal code of address
    public String PostalCode { get; set; }
    //line 1 of address
    public String Line1 { get; set; }
    //line 2 of address
    public String Line2 { get; set; }
    //line 1 of address
    public String city { get; set; }
    //line 2 of address
    public String state { get; set; }
    
    public String country { get; set; }  
    
 
     //string varriable to hold postal code of address
    public String from_PostalCode { get; set; }
   
    
    //line 1 of address
    public String from_Line1 { get; set; }
    //line 2 of address
    public String from_Line2 { get; set; }
    //line 1 of address
    public String from_city { get; set; }
    //line 2 of address
    public String from_state { get; set; }
    
    public String from_country { get; set; }  
       
    
    
    
    
    //method to get tex value from avalara tex api    
    public String RestRequest(String body,String endPoint,String method){
 String test1 = createTexRequestBody2();
        
          
        //get the Avalara Account and endpoint information
        avalara_customsetting ='test1';
        avalara_accountnumber = AvalaraInfo__c.getInstance(avalara_customsetting).accountnumber__c;
        avalara_password = AvalaraInfo__c.getInstance(avalara_customsetting).password__c;
        avalara_endpoint = AvalaraInfo__c.getInstance(avalara_customsetting).dev_endpoint__c;
 
        Blob headerValue = Blob.valueOf( avalara_accountnumber +':'+ avalara_password );
        
        String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
        
        String endPoint2 = 'https://sandbox-rest.avatax.com/api/v2/companies';
        
        
        //accessing end point for avalara request type
        
        Http h=new Http();
        HttpRequest req = new HttpRequest();
        req.setMethod(method);
        
        req.setHeader('Authorization', authorizationHeader);
        req.setEndPoint(endPoint2);
        req.setBody(body);
        
       // system.debug('endpoint ===> ' + endPoint);
       // system.debug('body ===> ' + body);
        
        HttpResponse res = h.send(req);
        result = res.getBody();
        
        system.debug('result at 333333333 ====> ' + result);
         parse2( result);
        return result;
        
        
        
    }
 
   
 /*
      //method to get tex value from avalara tex api    
    public String RestRequest(String body,String endPoint,String method){
 
        
          
        //get the Avalara Account and endpoint information
        avalara_customsetting ='test1';
        avalara_accountnumber = AvalaraInfo__c.getInstance(avalara_customsetting).accountnumber__c;
        avalara_password = AvalaraInfo__c.getInstance(avalara_customsetting).password__c;
        avalara_endpoint = AvalaraInfo__c.getInstance(avalara_customsetting).dev_endpoint__c;
 
        Blob headerValue = Blob.valueOf( avalara_accountnumber +':'+ avalara_password );
        
        String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
        
        //accessing end point for avalara request type
        
        Http h=new Http();
        HttpRequest req = new HttpRequest();
        req.setMethod(method);
        
        req.setHeader('Authorization', authorizationHeader);
        req.setEndPoint(endPoint);
        req.setBody(body);
        
       // system.debug('endpoint ===> ' + endPoint);
       // system.debug('body ===> ' + body);
        
        HttpResponse res = h.send(req);
        result = res.getBody();
        
        system.debug('result at 333333333 ====> ' + result);
         parse2( result);
        return result;
        
        
        
    }
 
    
    
 */   
  public void parse2(String result) {
    Map<String, Object> root = (Map<String, Object>)JSON.deserializeUntyped(result);
    System.debug('root aaaaaaaaaaaaa' + root);
    
    List<Object> items = (List<Object>)root.get('items');
 System.debug('items aaaaaaaaaaaaa' + items);
      
      
      
      /*for (Object item : items) {
        Map<String, Object> i = (Map<String, Object>)item;
        System.debug('111111111111' + i.get('id'));
   	 }*/

}

      
    
    
    //method to get Text
    public void getTex(){
        //calling method to create json body for request body from user provided data
        
        String texString = createTexRequestBody();
        RestRequest(texString ,'https://development.avalara.net/1.0/tax/get' ,'POST');
    }
    
    
    //method to validate address             
    public void validateAddress() {
        
       String endpoint = 'https://development.avalara.net/1.0/address/validate?Line1='+EncodingUtil.urlEncode(Line1+Line2,'UTF-8')+'&PostalCode='+EncodingUtil.urlEncode(PostalCode,'UTF-8');
        RestRequest('' , endPoint ,'GET');
    }
                   
    //method to create json string for rest request body        
    public String createTexRequestBody2(){
        
        
        
        Line1 = '123 Main Street';
        city = 'Irvine ';
        state = 'CA';
       	country = 'US';
        PostalCode = '92615';
         
        from_Line1 = '9419 Sharpview';
        from_city = 'Houston';
        from_state = 'TX';
       	from_country = 'US';
        from_PostalCode = '77036';
        
        DateTime dt = DateTime.now();
        String formattedDt = dt.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');        
        
        
        String requestString = '';
        requestString +='{';
        requestString +='\"companyCode\": \"CanCorp\",';
        requestString +='\"type\": \"SalesOrder\",';
        requestString +='\"code\": \"20160830-001\",';
        requestString +='\"customerCode\": \"OnlineCustomer\",';
        requestString +='\"date\": \"' + formattedDt +'\",';
        requestString +='\"addresses\": {';
        requestString +='\"ShipFrom\": {';
        requestString +=' \"line1\": \"' + from_Line1 +'\",';
        requestString +=' \"city\": \"' + from_city +'\",';
        requestString +=' \"region\": \"' + from_state +'\",';
        requestString +=' \"country\": \"' + from_country +'\",';
        requestString +=' \"postalCode\": \"' + from_PostalCode +'\"';
        requestString += '},';
        requestString +=' \"ShipTo\": {';
        requestString +=' \"line1\": \"' + Line1 +'\",';
        requestString +=' \"city\": \"' + city +'\",';
        requestString +=' \"region\": \"' + state +'\",';
        requestString +='  \"country\": \"' + country +'\",';
        requestString +='  \"postalCode\": \"' + PostalCode +'\"';
        requestString +='}';
        requestString +=' },';
        requestString +='\"lines\": [';
        requestString +='{';
        requestString +='  \"number\": \"1\",';
        requestString +='  \"quantity\": 2,';
        requestString +=' \"amount\": 100.00,';
        requestString +=' \"description\": \"Starry Night Mug\"';
        requestString +='} ';
        requestString +=']';
        requestString +='}';
        
        system.debug('requestString =====> ' + requestString );
        
        return 'blah';
        
        
    }   
    
    //method to create json string for rest request body        
    public String createTexRequestBody(){
        
        
        JSONGenerator gen= JSON.createGenerator(true);
        gen.writeStartObject();
        gen.writeStringField('DocDate', '2013-06-19');
        gen.writeStringField('CustomerCode', 'CUST1');
        gen.writeFieldName('Addresses');
        gen.writeStartArray();
        gen.writeStartObject();
        gen.writeStringField('AddressCode', '1');
        gen.writeStringField('Line1',Line1 );
        gen.writeStringField('Line2', Line2 );
        
        gen.writeStringField('PostalCode',PostalCode);
        gen.writeEndObject();
        gen.writeEndArray();
        gen.writeFieldName('Lines');
        gen.writeStartArray();
        gen.writeStartObject();
        gen.writeStringField('LineNo', '1');
        gen.writeStringField('DestinationCode', '1');
        gen.writeStringField('OriginCode', '1');
        gen.writeNumberField('Qty',Integer.valueOf(count));
        gen.writeNumberField('Amount',Double.valueOf(amount));
        
        gen.writeEndObject();
        gen.writeEndArray();
        gen.writeEndObject();
       // system.debug('json string just after creation ====> ' + gen.getAsString());
        return gen.getAsString();
        
        
    }
                    
}