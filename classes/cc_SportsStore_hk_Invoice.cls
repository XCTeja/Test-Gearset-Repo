global class cc_SportsStore_hk_Invoice extends ccrz.cc_hk_Invoice {

    global override Map<String,Object> applyPayment(Map<String,Object> inputData) {
        Map<String,Object> retData = super.applyPayment(inputData);
        Id accountId =  ccrz.cc_CallContext.currAccountId;
        Account acc = [SELECT Id, CreditLimit__c FROM Account WHERE Id = :accountId];
        /*acc.CreditLimit__c = 0;
        update acc;
        
        ccrz.cc_hk_Payment.TransactionPaymentParams payments = (ccrz.cc_hk_Payment.TransactionPaymentParams)inputData.get(ccrz.cc_hk_Invoice.PARAM_PAYMENT);
        if (acc.CreditLimit__c != null && payments.requestAmount > 0) {
            // increase credit limit and update account
            acc.CreditLimit__c +=  payments.requestAmount;
            update acc;
        }
        */
        Map<String,Object> mapPaymentsAmount = (Map<String,Object>)inputData.get(ccrz.cc_hk_Invoice.PARAM_INVOICE_PAYMENTS);
        Decimal amountToAdd = 0;
        for(Object objAmt : mapPaymentsAmount.values()) {
            amountToAdd += Decimal.valueOf((String)objAmt); 
        }
        if (acc.CreditLimit__c != null && amountToAdd > 0) {
            // increase credit limit and update account
            acc.CreditLimit__c += amountToAdd;
            update acc;
        }
        
        /*
        Map<Id,ccrz__E_Invoice__c> mapInvoices = (Map<Id,ccrz__E_Invoice__c>)inputData.get(ccrz.cc_hk_Invoice.PARAM_INVOICES);
        Decimal amountToAdd = 0;
        for(ccrz__E_Invoice__c invoice : mapInvoices.values()) {
            amountToAdd += (invoice.ccrz__OriginalAmount__c - invoice.ccrz__RemainingAmount__c); 
        }
        if (acc.CreditLimit__c != null && amountToAdd > 0) {
            // increase credit limit and update account
            acc.CreditLimit__c += amountToAdd;
            update acc;
        }
        */
        
        
        return retData;
    }
}