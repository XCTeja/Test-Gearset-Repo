global with sharing class cc_xc_CCPayment_Controller {
    
    
    
    
    global Boolean allowCC{get; set;}
    global Boolean showPO{get; set;}
    global Boolean error{get; set;}
    
    global String accountType1{get; set;}
    global String cartGUID{get; set;}
    global String cartGUID1{get; set;}
    global String accountNumber1{get; set;}
    global String paymentType1{get; set;}
    global String expirationMonth1{get; set;}
    global String expirationYear1{get; set;}
    
    global String PaymentTermName{get; set;}
    
    global cc_xc_CCPayment_Controller(){
         /*
        Map<String, Object> dataMapAcct = new Map<String, Object>();
        Account acct = [Select Id, Show_PO__c from Account where Id = :ccrz.cc_CallContext.currAccountId];
        
        dataMapAcct.put('AcctID', acct.ID);
        dataMapAcct.put('ShowPO', acct.Show_PO__c);
        */
        error = false;
        showPO = false;
        allowCC = true;
       
        ccrz.ccLog.log('Acct ID:: ===>' + ccrz.cc_CallContext.currAccountId); 
    }

       
    @RemoteAction
    global static ccrz.cc_RemoteActionResult doChargeCreditCard(final ccrz.cc_RemoteActionContext ctx, String actNum, String expYear, String expMonth, String pmntType, String acntType, String formCVV)
    {
        
        //this will hold all data we want to return
        Map<String, Object> dataMap = new Map<String, Object>();
        
        //populate default data
        dataMap.put('MSG', 'Default MSG');
        dataMap.put('theString', 'Default String');
        dataMap.put('CART', 'NULL');
        dataMap.put('STATUS', 'Failure');
        dataMap.put('DebugString', 'NULL');
        dataMap.put('transactionID', 'NULL');
                       
        
        //instantiate result
        //ccrz.cc_RemoteActionResult res = new ccrz.cc_RemoteActionResult();
         ccrz.cc_RemoteActionResult res = ccrz.cc_CallContext.init(ctx);
        res.success = false; 
        res.data = dataMap;
        
        

        CC_AuthorizeNet_Settings__c settings =  CC_AuthorizeNet_Settings__c.getInstance(ccrz.cc_CallContext.storefront);
        if (settings == null) {    
            dataMap.put('STATUS', 'EXCEPTION');
            dataMap.put('theString', 'Missing Custom Settings.  Please contact customer service.' );    
            res.success = false;
            return res;
        }
               
        try
        {
                
            String errorCode;
            String errorMsg;
            String error;
            String debugString;
                  
            
    
            String accountType1 = acntType;
            String accountType = accountType1.unescapeJava();
            
            String accountNumber1 = actNum;
            String accountNumber = accountNumber1.unescapeJava();
            
            String paymentType1 = pmntType;
            String paymentType = paymentType1.unescapeJava(); 
            
            String expirationMonth1 = expMonth;
            String expirationMonth = expirationMonth1.unescapeJava();       
            
            String expirationYear1 = expYear;
            String expirationYear = expirationYear1.unescapeJava();       
            
            
            
            //String amount = '$1.0';
            
            String cardmonth= expirationMonth;
            String cardyear= expirationYear;
            String cardtype= paymentType;
            //string scode= '333';
            String cardnumber= accountNumber;
            String CVV = formCVV;
            
            //will hold Chargent order id we need to use for auth
            String cOrderid;
            ID theID;
            String requestString = '';
            
            Map<String,String> queryParams = ctx.queryParams;
            String cartGUID = queryParams.get('cartID');
            ID contactID;
            
            //get the cart from the cartID from the remoteaction context
            ccrz__E_Cart__c cart = [Select 
                                    ccrz__Storefront__c, 
                                    ccrz__User__c, 
                                    ccrz__Contact__c, 
                                    ccrz__Account__c, 
                                    OwnerId, 
                                    Name, 
                                    Id, 
                                    ccrz__TotalAmount__c, 
                                    ccrz__EncryptedId__c
                                    From ccrz__E_Cart__c c
                                    Where 
                                    ccrz__EncryptedId__c = :cartGUID
                                    limit 1];    
                
                
                dataMap.put('CART', cart.ID);
                
                //if(cart.ccrz__Contact__c!= null)
                if (true)
                {
                
                    //from the cart record, get the Contact id for the user
                    contactID =  cart.ccrz__Contact__c;
                    dataMap.put('CONTACT', contactID);
                      
                    
                    
                    //if the account type is cc  then proceed
                    if(accountType=='cc')
                    {
                    
                    // start preparing to build Authorize.net request
                            
                            HttpRequest req1 = new HttpRequest();
req1.setMethod('POST');
req1.setEndpoint(settings.URL__c);
req1.setHeader('content-type', 'application/json');
/*
Sandbox URL: https://apitest.authorize.net/xml/v1/request.api
Production URL: https://api.authorize.net/xml/v1/request.api
 
XSD URL: https://api.authorize.net/xml/v1/schema/AnetApiSchema.xsd
*/
 
/*
string messageBody1 ='{"createTransactionRequest":{"merchantAuthentication":{"name":"'+settings.API_Login_Id__c+'","transactionKey":"'+settings.Transaction_Key__c+'"},'
+'"refId":" + cartGUID + '","transactionRequest":{"transactionType":"authCaptureTransaction","amount":"'+cart.ccrz__TotalAmount__c+'","payment":{"creditCard":'
+'{"cardNumber":"'+cardnumber+'","expirationDate":"'+ cardyear + '-' + cardmonth +'","cardCode":"'+CVV+'"}},'
+'"customer":{"id":"99999456654"},"billTo":{"firstName":"Ellen","lastName":"Johnson",'+
'"address":"14 Main Street","city":"Pecan Springs","state":"TX","zip":"44628","country":"USA"},'+
'}}}';
*/
String refId = String.valueOf(DateTime.now().getTime());
Decimal amount = cart.ccrz__TotalAmount__c;
//Decimal amount = 20;

string messageBody1 ='{"createTransactionRequest":{"merchantAuthentication":{"name":"'+settings.API_Login_Id__c+'","transactionKey":"'+settings.Transaction_Key__c+'"},'
+'"refId":"' + refId + '","transactionRequest":{"transactionType":"authCaptureTransaction","amount":"'+ amount +'","payment":{"creditCard":'
+'{"cardNumber":"'+cardnumber+'","expirationDate":"'+ cardyear + '-' + cardmonth +'","cardCode":"'+CVV+'"}},'
+''+
'}}}';
 
req1.setHeader('Content-length', String.valueOf(messageBody1.length()));
req1.setBody(messageBody1);
 
req1.setTimeout(60*1000);
Http h1 = new Http();
String resp1;
HttpResponse res1 = h1.send(req1);
resp1 = res1.getBody();
Map<String,object> responseMap =(Map<String,object>)JSON.deserializeUntyped(res1.getBody().substring(1,res1.getBody().length())) ;

//if (responseMap.get()
for(string keyStr : responseMap.keyset())
system.debug(keyStr+'-----------Response------------------>>>>'+responseMap.get(keyStr));

 //parse the result we got back from Authorize.net
 AuthResult authResult = (AuthResult)JSON.deserialize(resp1.substring(1,resp1.length()), AuthResult .class);

 if (authResult.messages != null && authResult.messages.resultCode == 'Ok' && authResult.transactionResponse != null && authResult.transactionResponse.responseCode == '1') {
    dataMap.put('STATUS', 'Approved');
    dataMap.put('transactionID', authResult.transactionResponse.transId);
    res.success = true; 

    //store transaction data so CC can save this data
                            ccrz.cc_hk_Payment.TransactionPaymentParams transact = new ccrz.cc_hk_Payment.TransactionPaymentParams();
                            transact.subAccountNumber = accountNumber.substring(accountNumber.length()-4);
                            transact.accountNumber = transact.subAccountNumber;
                            transact.paymentType = 'Credit Card';
                            transact.accountType = 'Credit Card';
                            transact.transactionCode = authResult.transactionResponse.transId;
                            transact.expirationMonth = Decimal.valueOf(expirationMonth);
                            transact.expirationYear = Decimal.valueOf(expirationYear);
                            
                            transact.amount = amount;
                            transact.requestAmount = transact.amount;
                            transact.storefront = ccrz.cc_CallContext.storefront;
                            dataMap.put('txObject', transact);
                            
                        //end of transaction status=approved if
                        /*
                            Decimal creditCardAdjustment = cart.ccrz__TotalAmount__c * 0.03;
                            cart.ccrz__AdjustmentAmount__c = creditCardAdjustment;
                            cart.ccrz__AdjustmentReason__c = 'CreditCardProcessingFee';
                            update cart;
                            */
 }
 else if (authResult.messages != null && authResult.messages.message != null && authResult.messages.message.size() > 0) {
    // do failed transaction handling
    dataMap.put('STATUS', 'Failure');
    dataMap.put('theString', authResult.messages.message[0].text);

 }
 else {
    // error handling
    dataMap.put('STATUS', 'Failure');
    dataMap.put('theString', 'Unknown Error');
    system.debug('Auth Response:' + resp1);
 }
                            
                /*          
                            
                        //get the actual order
                        ChargentOrders__ChargentOrder__c theOrder = cOrder.get(0);
                        
                                                
                        //get the order id
                        cOrderid = theOrder.id;
                        
                        theID = Id.valueof(cOrderid) ;
                        //construct the request string for Chargent request
                        requestString +='{';
                        requestString +='\"ObjectId\":\"' + theID +'\", ';
                        requestString +='\"CardMonth\":\"' + cardmonth +'\", ';
                        requestString +='\"CardYear\":\"' + cardyear +'\",  ';
                        requestString +='\"PaymentMethod\":\"Credit Card\", ';
                        requestString +='\"CardType\":\"' + cardtype +'\", ';
                        requestString +='\"CardSecurity\":\"' + CVV +'\",  ';
                        requestString +='\"CardNumber\":\"' + cardnumber +'\", ';
                        requestString +='\"RegisterTokenOnly\":\"TRUE\",';
                        requestString +='\"ChargeAmount\": 1.00'    ;
                        requestString +='}';
                        
                                 

                        ChargentOrders.TChargentOperations.TChargentResult  chargentResult =  ChargentOrders.TChargentOperations.AuthorizeOrder_ClickJSON(requestString);       
                         
                        string transactionStatus ='';
                        string transactionMsg ='';
                        string transactionID='';
                    
                        List<String> tmp = chargentResult.Message.split('\r\n');
                        dataMap.put('CHARGENT RESULT', chargentResult.Message);

                        if(tmp.size() == 3){
                            transactionStatus = tmp[1].substring(tmp[1].indexOf('"') + 1,tmp[1].length() -1);
                            transactionMsg = tmp[2].substring(tmp[2].indexOf('"') + 1,tmp[2].length() -1);
                            //transactionID = tmp[0].mid(tmp[0].indexOf('(')+1,tmp[0].indexOf(')') - tmp[0].indexOf('(')-1);
                        }
                        else{
                            transactionStatus = 'UNKNOWN';
                            transactionMsg = 'UNKNOWN Response';
                        }

                        transactionID = chargentResult.TransactID;
                        debugString = chargentResult.DebugString ;                                     
                        errorCode= debugString.substringBetween('<code>', '</code>');
                        errorMsg=debugString.substringBetween('<text>', '</text>');
                        error = errorCode + ': ' + errorMsg;                                  
                            
                        //the status code from the chargent/authorize.net response
                        dataMap.put('theString', error);                
                        dataMap.put('DebugString', chargentResult.DebugString);
                        
                        if (transactionStatus=='Approved')
                        {
                                                 
                            dataMap.put('STATUS', transactionStatus);
                            dataMap.put('transactionID', transactionID);
                            res.success = true;   
                            
                            //store transaction data so CC can save this data
                            ccrz.cc_hk_Payment.TransactionPaymentParams transact = new ccrz.cc_hk_Payment.TransactionPaymentParams();
                            transact.subAccountNumber = accountNumber.substring(accountNumber.length()-4);
                            transact.accountNumber = transact.subAccountNumber;
                            transact.paymentType = 'Credit Card';
                            transact.accountType = 'Credit Card';
                            transact.transactionCode = cOrderid;
                            transact.expirationMonth = Decimal.valueOf(expirationMonth);
                            transact.expirationYear = Decimal.valueOf(expirationYear);
                            
                            transact.amount = 1.00; //Decimal.valueOf(amount);
                            transact.requestAmount = transact.amount;
                            transact.storefront = 'DefaultStore';
                            dataMap.put('txObject', transact);
                        //end of transaction status=approved if
                            Decimal creditCardAdjustment = cart.ccrz__TotalAmount__c * 0.03;
                            cart.ccrz__AdjustmentAmount__c = creditCardAdjustment;
                            cart.ccrz__AdjustmentReason__c = 'CreditCardProcessingFee';
                            update cart;
                            
                        }
                        else
                        {
                            dataMap.put('STATUS', 'Failure');
                            res.success = false;   
                        //end of transaction status=approved if else                    
                        }
                                        
                        dataMap.put('MSG', chargentResult);
                        dataMap.put('transactionStatus', transactionStatus);
                        */
                    //end of  if(accountType=='cc' && !cOrder.isEmpty())
                    }  
                    else
                    {
                        dataMap.put('MSG', 'we are not getting correct contact order for logged in user');
                         dataMap.put('theString', 'we are not getting correct contact order for logged in user'); 
                    }
                    
                //end of if(cart.ccrz__Contact__c!= null)
                }
                       
        //end of try         
         }
         catch(Exception e)
         {
 
             //System.debug('\n\n ------------ InException Block: ---------------------: ' + e);
             dataMap.put('STATUS', 'EXCEPTION');
             //dataMap.put('MSG', e);
             dataMap.put('theString', 'There has been an error.  Please contact customer service.' );    
             res.success = false;
        }
        finally
        {
            // return a map with result of the call
            res.data = dataMap;
        }
        
        //
        return res;
    }

  //Start of classes to handle the response from authorize.net
    public class Message {
        public String code {get; set;}
        public String text {get; set;}
    }
    public class Messages {
        public String resultCode {get; set;}
        public List<Message> message {get; set;}

    }

    public class Error {
        public String errorCode {get; set;}
        public String errorText {get; set;}
    }

    public class TransactionResponse {
        public String responseCode {get; set;}
        public String transId {get; set;}
        public List<Error> errors {get; set;}
    }

    public class AuthResult {
        public Messages messages {get; set;}
        public TransactionResponse transactionResponse {get; set;}
    }
     // End of classes to handle the response from authorize.net

 
}