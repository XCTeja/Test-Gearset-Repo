public with sharing class AccountTriggerHandler {

    static Map<String, String> fieldSyncMap {
        get {
            return new Map<String, String>{
                    'BillingStreet'=>'MailingStreet',
                    'BillingCity'=>'MailingCity',
                    'BillingState'=>'MailingState',
                    'BillingPostalCode'=>'MailingPostalCode'};
        }
    }

    public static void onAfterUpdate(Map<Id, Account> newMap, Map<Id, Account> oldMap) {
        Map<Id, Account> accountAddressChangedMap = new Map<Id, Account>();
        for (String diffField : fieldSyncMap.keySet()) {
            String newMapJson = JSON.serialize(newMap);
            String oldMapJson = JSON.serialize(oldMap);
            for (Account a : (List<Account>) TriggerUtility.getDiffSObjectList(newMapJson, oldMapJson, diffField)) {
                accountAddressChangedMap.put(a.Id, a);
            }
        }

        if(!accountAddressChangedMap.isEmpty()) {
            syncAccountContactAddresses(accountAddressChangedMap);
        }
    }

    static void syncAccountContactAddresses(Map<Id, Account> accountAddressChangedMap) {
        List<Contact> contactList = [
                SELECT Id, MailingStreet, MailingCity, MailingState, MailingPostalCode, AccountId
                FROM Contact
                WHERE AccountId IN :accountAddressChangedMap.keySet()
        ];

        for (Contact c : contactList) {
            Account a = accountAddressChangedMap.get(c.AccountId);

            for (String aField : fieldSyncMap.keySet()) {
                String cField = fieldSyncMap.get(aField);
                c.put(cField, a.get(aField));
            }
        }

        update contactList;
    }

}