global with sharing class SportsStore_ctrl_CartInclude {
    @RemoteAction
    global static ccrz.cc_RemoteActionResult createCreditCase(final ccrz.cc_RemoteActionContext ctx, final String cartId) {
        //ccrz.cc_CallContext.initRemoteContext(ctx);
        //ccrz.cc_RemoteActionResult res = new ccrz.cc_RemoteActionResult();
        ccrz.cc_RemoteActionResult res = ccrz.cc_CallContext.init(ctx);
        res.success = false;
        try {
            List<ccrz__E_Cart__c> listCart = [SELECT Id FROM ccrz__E_Cart__c WHERE ccrz__EncryptedId__c = :cartId];
            if (listCart.size() == 0) {
                res.data = 'Cart not found';
            }
            else {
                Case c = new Case(Subject = 'Request Credit Override', 
                                    AccountId = ccrz.cc_CallContext.currAccountId, 
                                    ContactId = ccrz.cc_CallContext.currContact.Id, 
                                    Source_Cart__c = listCart[0].Id);
                insert c;
                res.success = true;
            }
        }catch(Exception e) {
            res.data = e;
            System.debug(System.LoggingLevel.ERROR, e.getMessage());
            System.debug(System.LoggingLevel.ERROR, e.getStackTraceString());
        }
        return res;
    }

}