public with sharing class MessagingSessionUpdater {
    @AuraEnabled
    public static void updateAuthSession(String sessionKey) {
        // Fetch the active messaging session
        MessagingSession ms = MessagingSessionService.getActiveSession(sessionKey);
        if (ms != null) {
            // Retrieve current session ID
            String sessionId = Auth.SessionManagement.getCurrentSession().get('SessionId');

            // Fetch user details
            User authUser = [
                SELECT Id, ContactId, AccountId FROM User WHERE Id = :UserInfo.getUserId()
            ];

            // Update MessagingSession fields
            ms.AuthSessionId__c = sessionId;
            ms.AccountId__c = authUser.AccountId;
            ms.ContactId__c = authUser.ContactId;

            update ms;
        }
    }
}