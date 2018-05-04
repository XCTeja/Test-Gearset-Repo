@isTest
class AccountTriggerTest {

    @testSetup
    static void setup() {
        Account a = new Account(
                Name = 'AccountTriggerTest',
                BillingStreet = '123 AccountTriggerTest',
                BillingCity = 'Los Angeles',
                BillingState = 'CA',
                BillingPostalCode = '90210'
        );
        insert a;

        Contact c = new Contact(
                FirstName = 'Test',
                LastName = 'AccountTriggerTest',
                AccountId = a.Id,
                MailingStreet = '123 AccountTriggerTest',
                MailingCity = 'Los Angeles',
                MailingState = 'CA',
                MailingPostalCode = '90210'
        );
        insert c;
    }

    @isTest
    static void testSyncAddress() {
        Test.startTest();
        Account a = [
                SELECT Id, BillingStreet, BillingCity, BillingState, BillingPostalCode
                FROM Account
                LIMIT 1
        ];

        a.BillingStreet = '719 Wisconsin St';
        a.BillingCity = 'Cawker';
        a.BillingState = 'KS';
        a.BillingPostalCode = '67430';
        update a;
        Test.stopTest();

        Contact c = [
                SELECT Id, MailingStreet, MailingCity, MailingState, MailingPostalCode
                FROM Contact
                WHERE AccountId = :a.Id
                LIMIT 1
        ];

        System.assertEquals(a.BillingStreet, c.MailingStreet);
        System.assertEquals(a.BillingCity, c.MailingCity);
        System.assertEquals(a.BillingState, c.MailingState);
        System.assertEquals(a.BillingPostalCode, c.MailingPostalCode);

    }
}