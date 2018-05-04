global with sharing class cc_hex_3DController_ProcessCard {

    private Boolean cardStored;
    private String cartId;
    private String submissionId;
    private String token;
    private String transactionCode; //transaction key
    private String transactionSubcode; //err message
    
    public cc_hex_3DController_ProcessCard() {
        System.debug('3DSI Controller called');
        /*cartId = Apexpages.currentPage().getParameters().get('currentCartId'); //Id.valueOf('001xa000003DIlo');
        submissionId = '';//Apexpages.currentPage().getParameters().get('submissionId'); //'272C78636A5E3AB78741A33CD18C4FB5536DB8A424BEDA1988';
        cardStored = Boolean.valueOf(Apexpages.currentPage().getParameters().get('cardStored'));
        System.debug('!====================== ' + cardStored);
        System.debug('!====================== ' + cartId);
        System.debug('!====================== ' + submissionId);*/
    }
    
    public Boolean getCardStored() {
        return cardStored;
    }
    public String getCartId() {
        return cartId;
    }
    public String getSubmissionId() {
        return submissionId;
    }
    public String getToken() {
        return token;
    }
    public String getTransactionCode() {
        return transactionCode;
    }
    public String getTransactionSubcode() {
        return transactionSubcode;
    }
    
    @RemoteAction
    global static List<String> remoteInitAuth(String submissionId, String cartId, String cardStored) { //requires params submissionId, cardStored, cartId
        System.debug('X======================= ' + cardStored);
        System.debug('X======================= ' + cartId);
        System.debug('X======================= ' + submissionId);
        List<String> returnList = new List<String>();
        String authResult = '';
        Boolean bCardStored = Boolean.valueOf(cardStored);
        
        String token = '';
        String transactionCode = '';
        String transactionSubcode = '';
        /*

        transactionCode = cartId.substring(0,4) + generateRandomString(8);


        if (bCardStored) {
            System.debug(LoggingLevel.INFO,'Note: Card Stored');
        }
        else {
            System.debug(LoggingLevel.INFO,'Note: Card Not Stored');
        }
        //Grab a token from 3DSI if it's been created
        token = getToken(submissionId);
        if (token.equals('')) {
            transactionSubcode = 'Error - Get Token Failure';
        } 
        else if (token.contains('FAILURE')) {
            transactionSubcode = token;
        }
        else {
            authResult = authCard(token, transactionCode, cartId); //Check to see if we have the funds
            if (authResult == 'Approved') {
                System.debug(LoggingLevel.INFO, 'Authorization Success');
                //captureResult = captureFunds(token, cartId);
                //return captureResult;
                transactionSubcode = authResult;
            }
            else {
                System.debug(LoggingLevel.INFO, 'Authorization Failure');
                transactionSubcode = authResult;
            }
        }
        System.debug(LoggingLevel.INFO, 'X================== RESULT ' + transactionSubcode);
        returnList.add(token);
        returnList.add(transactionCode);
        returnList.add(transactionSubCode);*/
        returnList.add('abcd');
        returnList.add('1234');
        returnList.add('5678');
        return returnList;

    }
    
    global void initAuth() { //requires params submissionId, cardStored, cartId
        Boolean cardStored = Boolean.valueOf(Apexpages.currentPage().getParameters().get('cardStored'));
        String cartId = Apexpages.currentPage().getParameters().get('cartId');
        String submissionId = Apexpages.currentPage().getParameters().get('submissionId'); //'272C78636A5E3AB78741A33CD18C4FB5536DB8A424BEDA1988';
        System.debug('X======================= ' + cardStored);
        System.debug('X======================= ' + cartId);
        System.debug('X======================= ' + submissionId);
        transactionCode = cartId;
        
        String authResult = '';
    /*
        if (cardStored) {
            System.debug(LoggingLevel.INFO,'Note: Card Stored');
        }
        else {
            System.debug(LoggingLevel.INFO,'Note: Card Not Stored');
        }
        //Grab a token from 3DSI if it's been created
        token = 'abcdef';
        if (token.equals('')) {
            transactionSubcode = 'Error - Get Token Failure';
        } 
        else if (token.contains('FAILURE')) {
            transactionSubcode = token;
        }
        else {
            /authResult = authCard(token, transactionCode, cartId); //Check to see if we have the funds
            if (authResult == 'Approved') {
                System.debug(LoggingLevel.INFO, 'Authorization Success');
                //captureResult = captureFunds(token, cartId);
                //return captureResult;
                transactionSubcode = authResult;
            }
            else {
                System.debug(LoggingLevel.INFO, 'Authorization Failure');
                transactionSubcode = authResult;
            }
        }
        System.debug(LoggingLevel.INFO, 'X================== RESULT ' + transactionSubcode);*/
    }
    
    
}