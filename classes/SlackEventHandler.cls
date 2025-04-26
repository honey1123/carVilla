@RestResource(urlMapping='/slack/events')
global with sharing class SlackEventHandler {
    @HttpPost
    global static void handleSlackEvent() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;

        String body = req.requestBody.toString();
        Map<String, Object> payload = (Map<String, Object>) JSON.deserializeUntyped(body);

        if (payload.containsKey('type') && payload.get('type') == 'url_verification') {
            // Respond to Slack's verification challenge
            res.responseBody = Blob.valueOf('{ "challenge": "' + (String) payload.get('challenge') + '" }');
            res.statusCode = 200;
            return;
        }

        if (payload.containsKey('event')) {
            Map<String, Object> event = (Map<String, Object>) payload.get('event');

            if ((String) event.get('type') == 'app_home_opened') {
                String userId = (String) event.get('user');
                System.debug('Slack App Home opened by user: ' + userId);
                sendWelcomeMessage(userId);
            }
        }

        res.statusCode = 200;
    }

    private static void sendWelcomeMessage(String userId) {
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:Slack/api/chat.postMessage');
        req.setMethod('POST');
        req.setHeader('Authorization', 'Bearer xoxb-your-token-here'); // Replace this securely later
        req.setHeader('Content-Type', 'application/json');

        String message = '👋 Welcome to the Test Ride Agent!';
        Map<String, Object> msg = new Map<String, Object>{
            'channel' => userId,
            'text' => message
        };

        req.setBody(JSON.serialize(msg));

        Http http = new Http();
        HttpResponse res = http.send(req);

        System.debug('Slack response: ' + res.getBody());
    }
}