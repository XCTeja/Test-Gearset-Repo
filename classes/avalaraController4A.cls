global class avalaraController4A {

 
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
    
    
 
public String callingAvatax(){

        
        XC_Avalara_tax xAva = new XC_Avalara_tax( );
        String result = xAva.getAvalaraTaxInfo(Line1, Line2, city, state, PostalCode, country, total);
    
    	system.debug('result inside RestRequest2()  =====> ' + result);
    
        return result;



}
    
    
 
     @RemoteAction
     global static  String getAVATAXReply(string xLine1 , string xLine2, string xcity, string xstate,  string xPostalCode, string xcountry, string xtotal) {
        

        //Store the passed in values in the object properties;
        XC_Avalara_tax xAva = new XC_Avalara_tax( );
        String results = xAva.getAvalaraTaxInfo(xLine1, xLine2, xcity, xstate, xPostalCode, xcountry, xtotal);
    	String results_final= xAva.getTaxAmount(results);
 
        return JSON.serialize(results_final);
    }
 
 
 
    global void Test1(String res){
        
       system.debug(res); 
    }
    
     
 

//method to get tex value from avalara tex api    
public String RestRequest(String body,String endPoint,String method){
        string username = 'tnguyen@candelacorp.com';
    	string password = 'C@nd3l@1234';
    
         Blob headerValue = Blob.valueOf(username+ ':' + password);
         String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
                
         //accessing end point for avalara request type
        
         Http h=new Http();
         HttpRequest req = new HttpRequest();
         req.setMethod(method);
  		 req.setHeader('Content-Type', 'application/json');
         req.setHeader('Authorization', authorizationHeader);
         req.setEndPoint(endPoint);
         req.setBody(body);
         HttpResponse res = h.send(req);
    	
    	system.debug('getStatusCode() ===> ' + res.getStatusCode());
    
         result = res.getBody();
    parseresult(result);
         return result;



}

    public void parseresult(string res){
        
        
        JSONParser  parser = JSON.createParser(res);
        while (parser.nextToken() != null) {
            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME)){
                String fieldName = parser.getText();
                parser.nextToken();
                String fieldValue=parser.getText();
                
                //system.debug('fieldName 11111 ===> ' + fieldName);
                 //system.debug('fieldValue 22222 ===> ' + fieldValue);
                
                   if(fieldName == 'totalTax' ) {
                    //parser.nextToken();
                       
                         String fieldName2 = parser.getText();
                        parser.nextToken();
                        String fieldValue2=parser.getText();
                        
                
                 system.debug('fieldName 11111 ===> ' + fieldName);
                 system.debug('fieldValue 22222 ===> ' + fieldValue);                    
                       
                   /* if(parser.getText()=='id'){
                        parser.nextToken();
                        //SessionId= parser.getText();
                        break;
                    }*/
                        break;
                }
				 
            }
        }
        
        
    }   
    
    
//method to get Text
   public void getTex(){
//calling method to create json body for request body from user provided data
    
     String texString = createTexRequestBody();
     RestRequest(texString , 'https://sandbox-rest.avatax.com/api/v2/transactions/create' ,'POST');
    system.debug('right before RestRequest2()  ==================================================  '  );       
    //RestRequest2();
	//callingAvatax();
 }
 
 //method to create json string for rest request body        
      public String createTexRequestBody(){
 
        
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
        requestString +=' \"line1\": \"123 Main Street\",';
        requestString +=' \"city\": \"Irvine\",';
        requestString +=' \"region\": \"CA\",';
        requestString +=' \"country\": \"US\",';
        requestString +=' \"postalCode\": \"92615\"';
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

}

/*
 public String callingAvatax(){

        
        XC_Avalara_tax xAva = new XC_Avalara_tax( );
        String result = xAva.getAvalaraTaxInfo(Line1, Line2, city, state, PostalCode, country, total);
    
    	system.debug('result inside RestRequest2()  =====> ' + result);
    
        return result;



}
*/