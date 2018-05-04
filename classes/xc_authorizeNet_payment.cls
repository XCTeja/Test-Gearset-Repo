global with sharing class xc_authorizeNet_payment extends ccrz.cc_hk_Payment
{
    xc_authorizeNet_payment authPayment;
    /*
    //Method 1
    global override static Map<String, Object> convertStoredPaymentToMap(ccrz__E_StoredPayment__c payment)
    {
        ccrz.ccLog.log(System.LoggingLevel.DEBUG, 'D:Payment data received in convertStoredPaymentToMap***: ', payment.ccrz__Name__c);
        
        return (null == payment) ? null : new Map<String,Object>{
        'sfid' => payment.Id
            ,'name' => payment.ccrz__Name__c
            ,'displayName' => payment.ccrz__DisplayName__c
            ,'accountNumber' => payment.ccrz__AccountNumber__c
            ,'subaccountNumber' => payment.ccrz__SubaccountNumber__c
            ,'accountType' => payment.ccrz__AccountType__c
            ,'isDefault' => payment.ccrz__Default__c
            ,'isEnabled' => payment.ccrz__Enabled__c
            ,'expirationMonth' => payment.ccrz__ExpMonth__c
            ,'expirationYear' => payment.ccrz__ExpYear__c
            ,'paymentType' => payment.ccrz__PaymentType__c
            ,'readOnly' => payment.ccrz__ReadOnly__c
            ,'sequence' => payment.ccrz__Sequence__c
            ,'token' => payment.ccrz__Token__c
        };
    }
    */
    
    //Method 5
    global override Map<String,Object> createStoredPayment(Map<String,Object> inputData)
     {
        TransactionPaymentParams formData = deserializeTransactionParams((String)inputData.get(ccrz.cc_hk_Payment.PARAM_TRANSACTION_DATA));
 
        ccrz__E_StoredPayment__c pmt = new ccrz__E_StoredPayment__c(
            ccrz__Account__c = ccrz.cc_CallContext.effAccountId,
            ccrz__User__c = ccrz.cc_CallContext.currUserId,
            ccrz__Storefront__c = ccrz.cc_CallContext.storefront,
            ccrz__AccountNumber__c = formData.accountNumber,
            ccrz__AccountType__c = formData.accountType,
            ccrz__DisplayName__c =  formData.displayName,
            ccrz__PaymentType__c = formData.paymentType,
            ccrz__SubaccountNumber__c = formData.subAccountNumber,
            ccrz__Token__c = formData.token
        ); 
        pmt.ccrz__Enabled__c = formData.isEnabled != null ? formData.isEnabled : true; // default to true
        if(formData.expirationMonth != null) {pmt.ccrz__ExpMonth__c = formData.expirationMonth;}
        if(formData.expirationYear != null) {pmt.ccrz__ExpYear__c = formData.expirationYear;}
        ccrz.ccLog.log(System.LoggingLevel.DEBUG, 'D:InputData received in createStoredPayment***: ', pmt);
        return inputData;
    }
    
   
       // Method 6
    global override Map<String,Object> fetchPaymentTypes(Map<String,Object> inputData)
     {
        ccrz.ccLog.log(System.LoggingLevel.DEBUG, 'D:InputData received in fetchPaymentTypes***: ', inputData.values());
        return inputData;
    }
    
    //Method 7
    global override Map<String,Object> fetchStoredPayments(Map<String,Object> inputData)
     {
        ccrz.ccLog.log(System.LoggingLevel.DEBUG, 'D:InputData received in fetchStoredPayments***: ', inputData.values());
        return inputData;
    }
    
    //Method 8
    global override Map<String,Object> fetchTransactionPayment(Map<String,Object> inputData)
     {
        ccrz.ccLog.log(System.LoggingLevel.DEBUG, 'D:InputData received in fetchTransactionPayment***: ', inputData.values());
        return inputData;
    }
    
    // Method 9
   global override Map<String,Object> getApplicablePaymentTypes(Map<String,Object> inputData)
    {
    /**
    * write code to debug what we are getting as input
    *cc_hk_Payment.PARAM_APPL_PAYMENT_TYPES
    * return string "po,cc"
    */
        ccrz.ccLog.log(System.LoggingLevel.DEBUG, 'D:InputData received in getApplicablePaymentTypes***: ', inputData.values());
        return inputData;
    }
    
       //Method 10
    global override Map<String,Object> processPayment(Map<String,Object> inputData)
    {
        /**
        * write code to debug what we are getting as input
        * hardcode amount to be changes to $200 and add to the ccrz.cc_hk_Payment.PARAM_TRANSACTION_DATA
        * create an instance of ccrz.ccPaymentProcessor and return ccrz.cc_hk_Payment.PARAM_PAYMENT_PROCESSOR
        */
        system.debug('The input data received ***: '+inputData);
        ccrz.ccLog.log(System.LoggingLevel.DEBUG, 'D:InputData received in payment process***: ', inputData.values());
        return inputData;
    }
    
    // Method 11
    global override Map<String,Object> removeStoredPayment(Map<String,Object> inputData) 
     {
        return inputData;
    }
    
    
       
    
}