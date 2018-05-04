global class cc_SportsStore_api_CartExtension extends ccrz.cc_api_CartExtension {
    private boolean isValidated = false;
    private boolean isAllowCheckout = false;
    private final List<ccrz.cc_bean_Message> retMessages = new List<ccrz.cc_bean_Message>();
    
    
    global override boolean allowCheckout(Map<String, Object> inputData){
        validate((ccrz.cc_bean_CartSummary)inputData.get(ccrz.cc_api_CartExtension.PARAM_CARTBEAN));
        return isAllowCheckout;
    }
    
    global override List<ccrz.cc_bean_Message> getCartMessages(Map<String, Object> inputData){
        retMessages.addAll(super.getCartMessages(inputData));
        validate((ccrz.cc_bean_CartSummary)inputData.get(ccrz.cc_api_CartExtension.PARAM_CARTBEAN));
        return retMessages;
    }
    
    private void validate(final ccrz.cc_bean_CartSummary cartBean){
        if(!isValidated){
            Id accountId =  ccrz.cc_CallContext.currAccountId;
            Account acc = [SELECT Id, CreditLimit__c FROM Account WHERE Id = :accountId];
            ccrz__E_Cart__c cart = [SELECT Id, Credit_Override__c FROM ccrz__E_Cart__c WHERE Id = :cartBean.sfId];
            if ((acc.CreditLimit__c != null && acc.CreditLimit__c >= cartBean.subTotal) || (cart.Credit_Override__c != null && cart.Credit_Override__c >= cartBean.subTotal)) {
                isAllowCheckout = true;
            }
            if (!isAllowCheckout) {
                retMessages.add(new ccrz.cc_bean_Message('You cannot checkout as your credit limit is low.', ccrz.cc_bean_Message.MessageType.ALERT));
            }
            
        }
        isValidated = true;
    }

}