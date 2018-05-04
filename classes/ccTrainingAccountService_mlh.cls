/**
 * Created by Matthew Higel on 2/19/2018.
 */

global with sharing class ccTrainingAccountService_mlh extends ccrz.ccServiceAccount {

    global virtual override Map<String, Object> getFieldsMap(Map<String, Object> inputData) {
        inputData = super.getFieldsMap(inputData);
        String objectFields = (String) inputData.get(ccrz.ccService.OBJECTFIELDS);
        objectFields += ',RestrictedMaterial__c';
        return new Map <String, Object>{
                ccrz.ccService.OBJECTFIELDS => objectFields
        };
    }
}