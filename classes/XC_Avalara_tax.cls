public class XC_Avalara_tax {
 
     
    public static String avalara_customsetting  {get; set;}
    public static String avalara_password  {get; set;}
    public static String avalara_username  {get; set;}
    public static String avalara_endpoint {get; set;}
            
    //string variable to show api result
    public string result{get;set;}
    //string variable to hold amount of line item
    
    
    //string varriable to hold total amount
    public String total { get; set; }   
     
    public String amount { get; set; }
    //string varriable to hold quantity of line item
    public String count { get; set; }
    //line 1 of address
    public String Line1 { get; set; }
    //line 2 of address
    public String Line2 { get; set; }
    //string varriable to hold postal code of address
    public String PostalCode { get; set; }
    //PostalCode
    public String city { get; set; }
    //city
    public String state { get; set; }
    // country
    public String country { get; set; }  
    
    
    //string varriable to hold postal code of address
    public String from_PostalCode { get; set; }
    //  Line1
    public String from_Line1 { get; set; }
    // Line2
    public String from_Line2 { get; set; }
    // city
    public String from_city { get; set; }
    // state
    public String from_state { get; set; }
    // country
    public String from_country { get; set; }  
       
   
    
    public String getAvalaraTaxInfo(String xLine1, String xLine2, String xcity, String xstate, String xPostalCode, String xcountry, String xtotal ){
    system.debug('inside the generic tax =========> '+ Line1);    
        Line1 = xLine1;
        Line2 = xLine2;
        city = xcity;
        state = xstate;
        PostalCode = xPostalCode;
        country = xcountry;
        total = xtotal;
        
        //get the actual json body to be sent
       	String jsonInfo = createTexRequestBody2();
        
        system.debug('jsonInfo ======> ' + jsonInfo);
 
        //get the Avalara Account and endpoint information
        avalara_customsetting ='test1';
        avalara_username = AvalaraInfo__c.getInstance(avalara_customsetting).username__c;
        avalara_password = AvalaraInfo__c.getInstance(avalara_customsetting).password__c;
        avalara_endpoint = AvalaraInfo__c.getInstance(avalara_customsetting).dev_endpoint__c;
 
        
        system.debug('avalara_username ====> ' + avalara_username);
        system.debug('avalara_password ====> ' + avalara_password);
        
        Blob headerValue = Blob.valueOf( avalara_username +':'+ avalara_password );
        
        String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);

        
        system.debug('authorizationHeader ====> ' + authorizationHeader);
        
        system.debug('endpoint  ====> ' + avalara_endpoint + '/api/v2/transactions/create');
        
        
        //accessing end point for avalara request type
        
        Http h=new Http();
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');
        
        req.setHeader('Authorization', authorizationHeader);
        req.setEndPoint(avalara_endpoint + '/api/v2/transactions/create');
        req.setBody(jsonInfo);
       	

         
        HttpResponse res = h.send(req);
        result = res.getBody();
        
        system.debug('result ===> ' + result);
        
       // parse2(result);
        
        return result;
    }

    
   //method to create json string for rest request body        
    public String createTexRequestBody2(){
        
        
        /*
        Line1 = '123 Main Street';
        city = 'Irvine ';
        state = 'CA';
       	country = 'US';
        PostalCode = '92615';
        */
        
        
        
        from_Line1 = '14420 Myford Road';
        from_city = 'Irvine';
        from_state = 'CA';
       	from_country = 'US';
        from_PostalCode = '92606';
        
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
        requestString +=' \"amount\": ' + total +',';
        requestString +=' \"description\": \"Starry Night Mug\"';
        requestString +='} ';
        requestString +=']';
        requestString +='}';
        
        system.debug('requestString =====> ' + requestString );
        
        return requestString;
        
        
    }      
    
  public void parse2(String result) {
    Map<String, Object> root = (Map<String, Object>)JSON.deserializeUntyped(result);
   // System.debug('root aaaaaaaaaaaaa' + root);
    
    List<Object> items = (List<Object>)root.get('items');
  System.debug('items aaaaaaaaaaaaa' + items);
      
      
      
      /*for (Object item : items) {
        Map<String, Object> i = (Map<String, Object>)item;
        System.debug('111111111111' + i.get('id'));
   	 }*/

}

    public string getTaxAmount(string res){
        String fieldName;
        String fieldValue;  
         String fieldName2;
        String fieldValue2; 
  
        String Error = 'False';
       	String taxAmt='0';
        
        Map<String, String> dataMap = new Map<String, String>(); 
         
       
        
        JSONParser  parser = JSON.createParser(res);
        while (parser.nextToken() != null) {
            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME)){
                  fieldName = parser.getText();
                parser.nextToken();
                  fieldValue=parser.getText();
                
                //system.debug('fieldName 11111 ===> ' + fieldName);
                //system.debug('fieldValue 22222 ===> ' + fieldValue);
                
                if(fieldName == 'totalTax' ) {
                     system.debug('fieldName 11111 ===> ' + fieldName);
                    system.debug('fieldValue 22222 ===> ' + fieldValue);                    
                      break;
                }
                
            }
        }
   
        
         dataMap.put('Error', Error); 
        dataMap.put('taxAmt', fieldValue);        
       system.debug('serialized result: =====> '+ JSON.serialize(dataMap));
        
        return JSON.serialize(dataMap);
    }     
       
}