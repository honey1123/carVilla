public with sharing class SlackController {
/*
Slack Webhooks can only post messages to a channel, not directly to a user’s DM.

You can mention a user using <@USER_ID> but the user must be in the channel.

To send a direct message (DM) to a user, use the Slack API (chat.postMessage) with OAuth authentication.
*/    
 	@RemoteAction  // This makes the method accessible from the VF page
    @future(callout=true)
    public static void sendMessage(String message) {
        String webhookUrl = 'https://hooks.slack.com/services/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'; // Replace with actual Slack Webhook
        HttpRequest req = new HttpRequest();
        req.setEndpoint(webhookUrl);
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');
        req.setBody('{"text": "' + message + '"}');
        Http http = new Http();
        HttpResponse res = http.send(req);
        system.debug( res.getBody());
        return;
    }
 	@RemoteAction  // This makes the method accessible from the VF page
    @future(callout=true)
    public static void sendAPIMessage(String message) {
        //Template for Slack-API
    }
}