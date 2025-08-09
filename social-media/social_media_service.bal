import ballerina/http;
import ballerina/time;

type User record {
    string name;
    readonly int id;
    time:Date birthdate;
    string mobileNumber;
};

table<User> key(id) users = table [
    {name: "Minoka", id: 1, birthdate: {year: 1995, month: 5, day: 20}, mobileNumber: "0771234567"}
];
service /social\-media on new http:Listener(9090) {
    resource function get users() returns User[] | error{
        return users.toArray();
    }

    //resource function get users/[int id]() returns User|UserNotFound|error;
    //resource function post users(NewUser newUser) returns http:Created|error;
}

