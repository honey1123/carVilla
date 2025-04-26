public with sharing class AuthSessionHandler {
    @AuraEnabled
    public static String generateAuthURL(String sessionKey) {
        // Construct the Experience Cloud authentication URL
        String baseUrl = 'https://yourdomain.force.com/authenticate';
        return baseUrl + '?sessionKey=' + EncodingUtil.urlEncode(sessionKey, 'UTF-8');
    }
}