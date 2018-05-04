/**
 * Created by Matthew Higel
 */

global with sharing class ccTrainingProductService_mlh extends ccrz.ccServiceProduct {

    global virtual override Map<String, Object> getFieldsMap(Map<String, Object> inputData) {
        inputData = super.getFieldsMap(inputData);
        String objectFields = (String) inputData.get(ccrz.ccService.OBJECTFIELDS);
        objectFields += ',Brand__c,Material__c' ;
        return new Map <String, Object>{
                ccrz.ccService.OBJECTFIELDS => objectFields
        };
    }
}