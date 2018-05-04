global with sharing class cc_xc_shipping_fedex extends ccrz.cc_api_ShippingAndHandling{
    //ccLog=abcd12345efg
    public List<fedexQuoteRates.RateReplyDetail> rateQuotes {get; set;}
    
    global override List<ccrz.cc_ctrl_hlpr_ShippingOption> getShippingOptions(String zipCode, String stateCode, String countryCode, Id cartId, String storeName) {
        
        
        ccrz.ccLog.log(System.LoggingLevel.DEBUG, 'in ccrz.cc_api_ShippingAndHandling getShippingOptions cartId ======> ~~~~~~~~~~~~~~~~~~~~~~~~: ', cartId);  
        
        //get the ccrz__E_Cart__c for this cart; the reason of which is to get the ContactID
        list<ccrz__E_Cart__c> items = [Select ccrz__Contact__c, 
                                           ccrz__Contact__r.id, 
                                           ccrz__Contact__r.firstname, 
                                           ccrz__Contact__r.lastname, 
                                       	   ccrz__ShipTo__r.ccrz__AddressFirstline__c,
                                       	   ccrz__ShipTo__r.ccrz__AddressSecondline__c,
                                       		ccrz__ShipTo__r.ccrz__City__c,
                                       		ccrz__ShipTo__r.ccrz__StateISOCode__c,
                                       		ccrz__ShipTo__r.ccrz__Country__c,
                                       		ccrz__ShipTo__r.ccrz__PostalCode__c,
                                       		ccrz__Account__r.id ,
                                           c.Id 
                                           From ccrz__E_Cart__c c 
                                           where Id = :cartId limit 1];   
        list<ccrz__E_CartItem__c> cartItems = [Select ccrz__OriginalQuantity__c, ccrz__Product__c from ccrz__E_CartItem__c 
                                               Where ccrz__Cart__c = :cartId];
        Decimal totalweight = 0.0;
        Integer totalQty = 0;
        
        for(ccrz__E_CartItem__c c: cartItems){
            totalQty += (Integer)c.ccrz__OriginalQuantity__c;
            ccrz__E_Product__c product = [Select ccrz__ProductWeight__c from ccrz__E_Product__c where Id =: c.ccrz__Product__c];
            totalweight += product.ccrz__ProductWeight__c;
        }
        
        ccrz__E_Cart__c currentCart = items.get(0);
            
       
        
        /*
         * we will provide different shipping options based on total cart value and service providers
         * if account has freight terms then thats provided as-well
         */
        
        List<ccrz.cc_ctrl_hlpr_ShippingOption> shipOptions = new List<ccrz.cc_ctrl_hlpr_ShippingOption>();
        //fedexQuoteRates.RateReply rates = getRates('','','','','',currentcart.ccrz__ShipTo__r.ccrz__AddressFirstline__c,currentcart.ccrz__ShipTo__r.ccrz__AddressSecondline__c,currentcart.ccrz__ShipTo__r.ccrz__City__c,currentcart.ccrz__ShipTo__r.ccrz__StateISOCode__c,currentcart.ccrz__ShipTo__r.ccrz__PostalCode__c,currentcart.ccrz__ShipTo__r.ccrz__Country__c,totalQty,totalweight);
        fedexQuoteRates.RateReply rates = getRates('','','','','','','','','','','',totalQty,totalweight);

        for(fedexQuoteRates.RateReplyDetail item: rates.RateReplyDetails){
            ccrz.ccLog.log(item.ServiceType);
            ccrz.ccLog.log(item.RatedShipmentDetails[0].ShipmentRateDetail.TotalNetCharge.Amount);
            
            ccrz.cc_ctrl_hlpr_ShippingOption shipOption = new ccrz.cc_ctrl_hlpr_ShippingOption();
            shipOption.uniqueId = item.ServiceType;
            shipOption.provider = 'Fedex';
            shipOption.serviceName = item.ServiceType.replace('_',' ');
        	shipOption.price = (integer)item.RatedShipmentDetails[0].ShipmentRateDetail.TotalNetCharge.Amount;
            shipOptions.add(shipOption);
        }
               
        return shipOptions;
    }
    
    public fedexQuoteRates.RateReply getRates(
                                String senderAddr1,
                                String senderCity,
                                String senderState,
                                String senderZip,
                                String senderCountry,
                                String receiverAddr1,
                                String receiverAddr2,
                                String receiverCity,
                                String receiverState,
                                String receiverZip,
                                String receiverCountry,
        						Integer Qty,
        						Decimal totalWeight
        ){
      

                                String sAddr1 = !String.isBlank(senderAddr1) ? senderAddr1 : '1004 Orchard Oriole Lane';
                                String sAddr2 = ''; 
                                String sCity = !String.isBlank(senderCity) ? senderCity : 'Durham';
                                String sState = !String.isBlank(senderState) ? senderState : 'NC'; 
                                String sZip = !String.isBlank(senderZip) ? senderZip : '27713';
                                String sCountry = !String.isBlank(senderCountry) ? senderCountry : 'US'; 
                                String rAddr1 = !String.isBlank(receiverAddr1) ? receiverAddr1 : '300 Seven Springs Way'; 
                                String rAddr2 = !String.isBlank(receiverAddr2) ? receiverAddr2 : ''; 
                                String rCity = !String.isBlank(receiverCity) ? receiverCity : 'Murfreesboro';
                                String rState = !String.isBlank(receiverState) ? receiverState : 'TN';
                                String rZip = !String.isBlank(receiverZip) ? receiverZip : '37127';
                                String rCountry = !String.isBlank(receiverCountry) ? receiverCountry : 'US';
        System.debug('==========================================================================');        
        
        //Variable Initialization
        fedexQuoteRates.WebAuthenticationDetail webAuthDetail2 = new fedexQuoteRates.WebAuthenticationDetail();
        fedexQuoteRates.ClientDetail clientDetail = new fedexQuoteRates.ClientDetail();
        fedexQuoteRates.TransactionDetail transcDetails = new fedexQuoteRates.TransactionDetail();
        fedexQuoteRates.VersionId verID = new fedexQuoteRates.VersionId();
        Boolean returnTransit = true;
        String [] CarrierCodes = new String []{};
        String [] VariableOptions = new String []{};
        fedexQuoteRates.ConsolidationKey consolKey = new fedexQuoteRates.ConsolidationKey();
        fedexQuoteRates.RequestedShipment shipmentDetails = new fedexQuoteRates.RequestedShipment();
        fedexQuoteRates.Party Sender = new fedexQuoteRates.Party();
        fedexQuoteRates.Party Receiver = new fedexQuoteRates.Party();
        fedexQuoteRates.RateServicePort port = new fedexQuoteRates.RateServicePort();
            
        //Auth Credentials
        fedexQuoteRates.WebAuthenticationCredential usercreds = new fedexQuoteRates.WebAuthenticationCredential();
        usercreds.Key = 'Uplrr8v8ZmGwvF52';
        usercreds.Password = 'Q83debhmAOScCzhxshpEHkRDZ';
        
        webAuthDetail2.UserCredential = usercreds;
        
        //ClientDetails
        clientDetail.AccountNumber = '510087720';
        clientDetail.MeterNumber = '118972358';
        
        shipmentDetails.PackageCount = Qty;
        fedexQuoteRates.RequestedPackageLineItem requestedPackageLineItem  = new fedexQuoteRates.RequestedPackageLineItem ();
		requestedPackageLineItem.SequenceNumber = 1;
		requestedPackageLineItem.GroupPackageCount = 1;
		fedexQuoteRates.Weight weight = new fedexQuoteRates.Weight();
		weight.Units = 'LB';
		weight.Value = totalWeight;
		requestedPackageLineItem.Weight = weight;
		fedexQuoteRates.Dimensions dimensions = new fedexQuoteRates.Dimensions();
		dimensions.Length = 12;
		dimensions.Width = 9;
		dimensions.Height = 1;
		dimensions.Units = 'IN';
		requestedPackageLineItem.Dimensions = dimensions;
		fedexQuoteRates.RequestedPackageLineItem[] requestedPackageLineItems = new fedexQuoteRates.RequestedPackageLineItem[]{};
		requestedPackageLineItems.add(requestedPackageLineItem);
		shipmentDetails.RequestedPackageLineItems = requestedPackageLineItems;
        
        //Sender Address
        fedexQuoteRates.Address sendAddr = new fedexQuoteRates.Address();
        String[] SenderStreet = new String[]{sAddr1 , sAddr2};
        sendAddr.StreetLines = SenderStreet;
        sendAddr.city = sCity;
        sendAddr.StateOrProvinceCode = sState;
        sendAddr.PostalCode = sZip;
        sendAddr.countrycode = sCountry;
        Sender.Address = sendAddr;
        shipmentDetails.Shipper = Sender;
        
        //Receiver Address
        fedexQuoteRates.Address rcvrAddr = new fedexQuoteRates.Address();
        String[] ReceiverStreet = new String[]{rAddr1, rAddr2};
        rcvrAddr.StreetLines = ReceiverStreet;
        rcvrAddr.city = rCity;
        rcvrAddr.StateOrProvinceCode = rState;
        rcvrAddr.PostalCode = rZip;
        rcvrAddr.countrycode = rCountry;
        Receiver.Address = rcvrAddr;
        ShipmentDetails.Recipient = Receiver;

		//Version ID
		verID.ServiceId = 'crs';
		verID.Major  = 22;
		verID.Intermediate  = 0;
		verID.Minor  = 0;
                
        port.endpoint_x = 'https://wsbeta.fedex.com:443/web-services/rate';
        fedexQuoteRates.RateReply response = port.getRates(webAuthDetail2, clientDetail, transcDetails,  verID, returnTransit, CarrierCodes, VariableOptions,  consolkey,  shipmentDetails);
        
        return response;
    }
}