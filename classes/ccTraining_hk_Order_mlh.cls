/**
 * Created by Matthew Higel on 2/19/2018.
 */

global with sharing class ccTraining_hk_Order_mlh extends ccrz.cc_hk_Order {

    private void updateAccountCreditLimitForOrder(ccrz__E_Order__c currentOrder) {
        Account currentAccount = [SELECT CreditLimit__c FROM Account WHERE Id = :currentOrder.ccrz__Account__c];
        Double totalOrderAmount = [SELECT ccrz__TotalAmount__c FROM ccrz__E_Order__c WHERE Id = :currentOrder.Id].ccrz__TotalAmount__c;

        currentAccount.CreditLimit__c = totalOrderAmount;

        update currentAccount;
    }

    global override Map<String, Object> place(Map<String, Object> inputData) {
        String currentStep = (String)inputData.get(ccrz.cc_hk_Order.PARAM_PLACE_STEP);
        if (ccrz.cc_hk_Order.STEP_END.equals(currentStep)) {
            ccrz__E_Order__c currentOrder = (ccrz__E_Order__c) inputData.get(ccrz.cc_hk_Order.PARAM_ORDER);
            updateAccountCreditLimitForOrder(currentOrder);
        }

        return inputData;
    }
}