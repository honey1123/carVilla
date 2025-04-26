public with sharing class MessagingSessionService {
    @AuraEnabled
    public static MessagingSession getActiveSession(String sessionKey) {
        return [
            SELECT Id, Conversation.ConversationIdentifier, Status 
            FROM MessagingSession 
            WHERE SessionKey = :sessionKey 
            AND Status = 'Active' 
            AND AuthSessionId__c = NULL
            LIMIT 1
        ];
    }
}