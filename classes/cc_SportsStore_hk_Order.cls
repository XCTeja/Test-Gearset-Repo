global class cc_SportsStore_hk_Order extends ccrz.cc_hk_Order {
    global override Map<String,Object> place(Map<String,Object> inputData) {
        // let CC do its work;
        Map<String,Object> outputData = super.place(inputData);     
        
        // If its the last step of the order.
        if ((String)inputData.get(ccrz.cc_hk_Order.PARAM_PLACE_STEP) == ccrz.cc_hk_Order.STEP_END) {
            // get the Account
            Id accountId =  ccrz.cc_CallContext.currAccountId;
            Account acc = [SELECT Id, CreditLimit__c FROM Account WHERE Id = :accountId];
            if (acc.CreditLimit__c != null) {
                // get the order
                ccrz__E_Cart__c cart = (ccrz__E_Cart__c)inputData.get(ccrz.cc_hk_Order.PARAM_CART);
                // decrease credit limit and update account
                acc.CreditLimit__c -= cart.ccrz__TotalAmount__c;
                update acc;
            }
        }
        return outputData;
    }
}