global with sharing class cc_xc_ProductService extends ccrz.ccServiceProduct{
    
	global virtual override Map<String, Object> getFieldsMap(Map<String, Object> inputData)
    {
        inputData = super.getFieldsMap(inputData);
        String objectFields = (String)inputData.get(ccrz.ccService.OBJECTFIELDS);
        objectFields += ',Search_Keywords__c';
        ccrz.ccLog.log(System.LoggingLevel.DEBUG, 'cc_Example_ProductService getFieldsMap fields are ' + objectFields);
               
        return new Map<String, Object> {
                ccrz.ccService.OBJECTFIELDS => objectFields
        };
		
    }
}