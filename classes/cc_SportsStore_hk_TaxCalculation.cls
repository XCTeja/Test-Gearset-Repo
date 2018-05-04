global with sharing class cc_SportsStore_hk_TaxCalculation extends ccrz.cc_hk_TaxCalculation {
 
    /**
     * The getTaxAmount method will only be executed if skipTaxCalculation method evaluates to false.
     * The skipTaxCalculation method returns the value of cc_api_User.getCurrentUser.Contact.Account.TaxExemptAccount__c.
     */
    global override Decimal getTaxAmount(Map<String, Object> inputData) {
        String integrationSettings = 'Default'; //default value
        CC_Avalara_Settings__c avaralaSettings = CC_Avalara_Settings__c.getValues(integrationSettings);
 
        Id cartId = (Id) inputData.get(ccrz.cc_hk_TaxCalculation.PARAM_CARTID);
        System.debug(LoggingLevel.INFO, 'Cart ID: ' + cartId);
 
        TaxSvc.TaxSvcSoap taxSvc = new TaxSvc.TaxSvcSoap(avaralaSettings.Avalara_URL__c);
        taxSvc.Security = new TaxSvc.Security();
        taxSvc.Security.UsernameToken.Username = avaralaSettings.Avalara_Username__c;
        taxSvc.Security.UsernameToken.Password = avaralaSettings.Avalara_Password__c;
        //taxSvc.Profile = new TaxSvc.Profile();
        //taxSvc.Profile.Client = 'GetTaxDemo,1,0';
        //taxSvc.Profile.Client = avaralaSettings.Avalara_Doc_Type__c;
        
        Blob authBlob = Blob.valueOf(avaralaSettings.Avalara_Username__c + ':' + avaralaSettings.Avalara_Password__c);            
        String encodedAuthString = EncodingUtil.base64Encode(authBlob);
        taxSvc.inputHttpHeaders_x = new Map<String,String>();
        taxSvc.inputHttpHeaders_x.put('Authorization', 'Basic ' + encodedAuthString);
 
        TaxSvc.GetTaxRequest gtreq = buildTaxRequest(cartId, avaralaSettings);
 
        TaxSvc.GetTaxResult gtres = null;
        System.debug(LoggingLevel.INFO, 'TaxSvc is :' + TaxSvc);
        try {
            gtres = taxSvc.GetTax(gtreq);
            if (gtres.TotalTax != 0) {
            /*
                //Grab list of cart items to attach individual tax to them
                list<ccrz__E_CartItem__c> cartItemList = new list<ccrz__E_CartItem__c>();
                for(integer i =0; i< gtres.TaxLines.TaxLine.size() ; i++){
                    ccrz__E_CartItem__c cartItem = new ccrz__E_CartItem__c();
                    cartItem.id = gtres.TaxLines.TaxLine[i].No;
                    cartItem.Avalara_Tax_Amount__c = gtres.TaxLines.TaxLine[i].Tax;
                    cartItemList.add(cartItem);
                }
                if(cartItemList != null && cartItemList.size()>0){
                    update cartItemList;
                }
             */
 
                return gtres.TotalTax;
            }
            else {
                return 0;
            }
        }
        catch (Exception ex) {
        TestObject2__c obj = new TestObject2__c();
        obj.Description2__c = ex.getMessage();
        insert obj;
            return 16;
        }
    }
 
 
    public TaxSvc.GetTaxRequest buildTaxRequest(Id cartId, CC_Avalara_Settings__c avaralaSettings) {
        TaxSvc.GetTaxRequest gtreq = new TaxSvc.GetTaxRequest();
 
        List<ccrz__E_Cart__c> carts = [select ccrz__Account__r.Name, ccrz__BillTo__R.ccrz__City__c, ccrz__BillTo__R.ccrz__AddressFirstLine__c, ccrz__BillTo__R.ccrz__StateISOCode__c, ccrz__BillTo__R.ccrz__PostalCode__c from ccrz__E_Cart__c where id = :cartId];
        if (carts.size() == 0) {
            return null;
        }
        // DocCode needs to be made unique for each transaction, Invoice Number
        gtreq.DocCode = '' + cartId + DateTime.now().getTime()/1000;
        // DocType options: SalesOrder, SalesInvoice, ReturnOrder, ReturnInvoice, PurchaseOrder, PurchaseInvoice
        gtreq.DocType = avaralaSettings.Avalara_Doc_Type__c;
        // CustomerCode: eg 'Customer Number One'
        gtreq.CustomerCode = carts.get(0).ccrz__Account__r.Name;
        // CompanyCode: Your Company Code Here
        gtreq.CompanyCode = avaralaSettings.Avalara_Company_Code__c;
        // DetailLevel options: Document (default), Line, Tax
        gtreq.DetailLevel = avaralaSettings.Avalara_Detail_Level__c;
 
        TaxSvc.BaseAddress orgAddr = new TaxSvc.BaseAddress();
        orgAddr.AddressCode = avaralaSettings.Avalara_Address_Code_Origin__c;
        orgAddr.Line1 = '700 Pike St';//senderInfo.Street_Name__c;
        orgAddr.City = 'Seattle';//senderInfo.City__c;
        orgAddr.Region = 'WA';//senderInfo.State_Code__c;
        orgAddr.PostalCode = '98101';//senderInfo.Postal_Code__c;
 
        TaxSvc.BaseAddress dstAddr = new TaxSvc.BaseAddress();
        dstAddr.AddressCode = avaralaSettings.Avalara_Address_Code_Destination__c;
        dstAddr.Line1 = carts.get(0).ccrz__BillTo__r.ccrz__AddressFirstLine__c;
        dstAddr.City = carts.get(0).ccrz__BillTo__r.ccrz__City__c;
        dstAddr.Region = carts.get(0).ccrz__BillTo__r.ccrz__StateISOCode__c;
        dstAddr.PostalCode = carts.get(0).ccrz__BillTo__r.ccrz__PostalCode__c;
 
        gtreq.Addresses = new TaxSvc.ArrayOfBaseAddress();
        gtreq.Addresses.BaseAddress = new TaxSvc.BaseAddress[2];
 
        gtreq.Addresses.BaseAddress[0] = orgAddr;
        gtreq.Addresses.BaseAddress[1] = dstAddr;
 
        gtreq.OriginCode = orgAddr.AddressCode;
        gtreq.DestinationCode = dstAddr.AddressCode;
 
 
        list<ccrz__E_CartItem__c> items = [Select c.ccrz__Price__c, c.ccrz__Quantity__c, c.ccrz__Product__r.ccrz__Taxable__c, c.ccrz__Product__r.ccrz__SKU__c, c.ccrz__Product__r.ccrz__TaxRateId__c, c.ccrz__Product__r.ccrz__ShortDesc__c, c.ccrz__Product__c, c.Id From ccrz__E_CartItem__c c where c.ccrz__Cart__c = :cartId ];
        gtreq.Lines = new TaxSvc.ArrayOfLine();
        gtreq.Lines.Line = new TaxSvc.Line[items.size()+1];
        Integer itr = 0;
        for(ccrz__E_CartItem__c item : items) {
            if (item.ccrz__Product__r.ccrz__Taxable__c) {
                /*
                http://developer.avalara.com/avatax/api-reference/tax/soap/#getTax
                Qty: Required. Item quantity. The tax engine does NOT use this as a multiplier with price to get the Amount.
                Amount: Total amount of item (extended amount, qty * unit price). If omitted, this value will default to 0
                */
                gtreq.Lines.Line[itr] = new TaxSvc.Line();
                gtreq.Lines.Line[itr].Amount = item.ccrz__Price__c * item.ccrz__Quantity__c;
                gtreq.Lines.Line[itr].Qty = item.ccrz__Quantity__c;
                gtreq.Lines.Line[itr].ItemCode = item.ccrz__Product__r.ccrz__SKU__c;
                gtreq.Lines.Line[itr].TaxCode = item.ccrz__Product__r.ccrz__TaxRateId__c;
                gtreq.Lines.Line[itr].Description = item.ccrz__Product__r.ccrz__ShortDesc__c;
                gtreq.Lines.Line[itr].No = item.id;
                itr++;
            }
        }
 
        gtreq.DocDate = Date.Today();
        gtreq.Commit_x=false;
        return gtreq;
    }
}