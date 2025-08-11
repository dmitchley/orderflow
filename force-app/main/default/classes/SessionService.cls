public with sharing class SessionService {
    @AuraEnabled(cacheable=true)
    public static List<Session__c> getSessionsByEvent(Id eventId) {
        return [
            SELECT Id,
                   Name,
                   Starting_Time__c,
                   Ending_Time__c,
                   Max_Capacity__c,
                   Location__r.Name,
                   Speaker__r.Name,
                   Event__r.Name
            FROM Session__c
            WHERE Event__c = :eventId
            ORDER BY Starting_Time__c ASC
        ];
    }
}