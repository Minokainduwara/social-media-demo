import ballerina/log;
import ballerinax/jaeger as _;
import ballerinax/nats;
import ballerinax/twilio;

configurable string natsUrl = ?;

type TwilioConfig record {|
    string accountSid;
    string authToken;
    string messageSenderId;
|};
configurable TwilioConfig twilioConfig = ?;
final twilio:Client twilioClient = check new (config = {
    twilioAuth: {
        accountSId: twilioConfig.accountSid,
        authToken: twilioConfig.authToken
    }
});

type SmsSendEvent record {|
    int leaderId;
    string[] followerNumbers;
|};

service "ballerina.social.media" on new nats:Listener(natsUrl) {
    public function init() returns error? {
        log:printInfo("SMS sender service started");
    }

    remote function onMessage(SmsSendEvent event) returns error? {
        check sendSms(event);
    }
}

function sendSms(SmsSendEvent event) returns error? {
    string message = string `User ${event.leaderId} has a new post.`;
    string messageSenderId = twilioConfig.messageSenderId;
    foreach string mobileNumber in event.followerNumbers {
        _ = check twilioClient->sendSms(messageSenderId, mobileNumber, message);
    }
}
