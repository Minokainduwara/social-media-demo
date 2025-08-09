import ballerina/http;
import ballerina/time;

type User record {
    string name;
    readonly int id;
    time:Date birthdate;
    string mobileNumber;
};

table<User> key(id) users = table [
    {name: "Minoka", id: 1, birthdate: {year: 2002, month: 5, day: 20}, mobileNumber: "0771234567"}
];
type ErrorDetails record {
    string message;
    string details;
    time:Utc timestamp;
};

type UserNotFound record {|
    *http:NotFound;
    ErrorDetails body;
|};

service /social\-media on new http:Listener(9090) {
    resource function get users() returns User[] | error{
        return users.toArray();
    }

    resource function get users/[int id]() returns User|UserNotFound|error{
        User? user = users[id];
        if user is (){
            UserNotFound userNotFound = {
                body: {message: string `id: ${id} not found`, details: "User with the given ID does not exist", timestamp: time:utcNow()}
            };
            return userNotFound;
        }
        return user;
    }
    //resource function post users(NewUser newUser) returns http:Created|error;
}

