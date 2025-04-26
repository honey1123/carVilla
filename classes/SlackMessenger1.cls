// Apex code to notify a Slack user via DM and public channel using Slack's API
// via Salesforce Named Credential (External Credential: Slack)

public class SlackMessenger1 {
    public static void sendSlackNotifications(String email, String targetChannelName) {
        try {
            String userId = getSlackUserIdByEmail(email);
            if (String.isBlank(userId)) return;

            String dmChannelId = openDirectMessage(userId);
            if (String.isBlank(dmChannelId)) return;

            String channelId = getPublicChannelIdByName(targetChannelName);

            //sendMessage(dmChannelId, '👋 Hey Ranjeet, your test ride is ready in DM!');

            if (!String.isBlank(channelId)) {
                sendMessage(channelId, '📣 Public alert: Test ride ready for ');
            }

        } catch (Exception ex) {
            System.debug('❗ Exception occurred: ' + ex.getMessage());
        }
    }

    private static String getSlackUserIdByEmail(String email) {
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:Slack/users.lookupByEmail?email=' + email);
        req.setMethod('GET');
        req.setHeader('Content-Type', 'application/json');

        HttpResponse res = new Http().send(req);
        System.debug('📦 Step 1 Response Code: ' + res.getStatusCode());
        System.debug('📦 Step 1 Response Body: ' + res.getBody());

        if (res.getStatusCode() != 200 || String.isBlank(res.getBody())) {
            System.debug('❌ Slack lookup failed or empty response');
            return null;
        }

        Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
        if (!responseMap.containsKey('user')) return null;
        Map<String, Object> userMap = (Map<String, Object>) responseMap.get('user');
        return (String) userMap.get('id');
    }

    private static String openDirectMessage(String userId) {
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:Slack/conversations.open');
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');
        req.setBody(JSON.serialize(new Map<String, Object>{ 'users' => userId }));

        HttpResponse res = new Http().send(req);
        System.debug('📦 Step 2 Response Code: ' + res.getStatusCode());
        System.debug('📦 Step 2 Response Body: ' + res.getBody());

        if (String.isBlank(res.getBody())) return null;
        Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
        if (!responseMap.containsKey('channel')) return null;

        Map<String, Object> channelMap = (Map<String, Object>) responseMap.get('channel');
        return (String) channelMap.get('id');
    }

    private static String getPublicChannelIdByName(String channelName) {
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:Slack/conversations.list');
        req.setMethod('GET');
        req.setHeader('Content-Type', 'application/json');

        HttpResponse res = new Http().send(req);
        System.debug('📦 Channel List Response Code: ' + res.getStatusCode());
        System.debug('📦 Channel List Body: ' + res.getBody());

        if (res.getStatusCode() == 200 && !String.isBlank(res.getBody())) {
            Map<String, Object> chanMap = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
            if ((Boolean) chanMap.get('ok')) {
                List<Object> channels = (List<Object>) chanMap.get('channels');
                for (Object ch : channels) {
                    Map<String, Object> chMap = (Map<String, Object>) ch;
                    if ((String) chMap.get('name') == channelName) {
                        return (String) chMap.get('id');
                    }
                }
            } else {
                System.debug('❌ Slack API Error: ' + chanMap.get('error'));
            }
        }
        return null;
    }

    private static void sendMessage(String channelId, String message) {
        system.debug('Entered for '+channelId +', and message ='+ message);
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:Slack/chat.postMessage');
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');
        req.setBody(JSON.serialize(new Map<String, Object>{
            'channel' => channelId,
            'text' => message
        }));

        HttpResponse res = new Http().send(req);
        System.debug('📦 Message Response Code: ' + res.getStatusCode());
        System.debug('📦 Message Response Body: ' + res.getBody());
    }
}

// Example Usage:
// SlackMessenger1.sendSlackNotifications('jumeirahjaipur@gmail.com', 'test-ride');