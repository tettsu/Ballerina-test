import ballerina/config;
import ballerina/http;
import wso2/twitter;

twitter:Client twitterClient = new({
   clientId: config:getAsString("consumerKey"),
   clientSecret: config:getAsString("consumerSecret"),
   accessToken: config:getAsString("accessToken"),
   accessTokenSecret: config:getAsString("accessTokenSecret")
});

@http:ServiceConfig {
   basePath: "/"
}
service hello on new http:Listener(9090) {
    @http:ResourceConfig {
        methods: ["POST"],
        path: "/"
    }
    resource function sayHello(http:Caller caller, http:Request request) returns error? {
        string status = check request.getTextPayload();
        twitter:Status st = check twitterClient->tweet(status);
        http:Response response = new;
        response.setTextPayload("ID:" + string.convert(untaint st.id) + "\n");

        _ = caller -> respond(response);
        return ();
    }
}