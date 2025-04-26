public class SlackServices1 {
    private static final String NAMED_CREDENTIAL = 'Slack'; // Matches your Named Credential label

    public class SlackResponse {
        public Boolean ok;
        public String error;
        public String channel;
        public String ts;
    }

    public static void sendMessage(String channelId, String message, List<Object> blocksOptional) {
        try {
            HttpRequest req = new HttpRequest();
            req.setEndpoint('callout:' + NAMED_CREDENTIAL + '/api/chat.postMessage');
            req.setMethod('POST');
            req.setHeader('Content-Type', 'application/json');

            Map<String, Object> payload = new Map<String, Object>{
                'channel' => channelId,
                'text' => message
            };

            if (blocksOptional != null && !blocksOptional.isEmpty()) {
                payload.put('blocks', blocksOptional);
            }

            req.setBody(JSON.serialize(payload));

            Http http = new Http();
            HttpResponse res = http.send(req);

            SlackResponse slackRes = (SlackResponse)JSON.deserialize(res.getBody(), SlackResponse.class);

            if (!slackRes.ok) {
                System.debug('❌ Slack API error: ' + slackRes.error);
            } else {
                System.debug('✅ Slack message sent to ' + slackRes.channel + ' at ' + slackRes.ts);
            }
        } catch (Exception e) {
            System.debug('❌ Exception while posting to Slack: ' + e.getMessage());
        }
    }
}