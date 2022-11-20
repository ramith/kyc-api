import ballerina/http;
import ballerina/regex;

type KycDocument record {
    int fileId;
    string 'type;
    string state;
    string rejectReason;
    string createTime;
};
type KycInfo record {
    string accountId;
    string state;
    KycDocument[] supportingDocuments;
    record {
        string first;
        string last;
    } legalName;
};

# A service representing a network-accessible API
# bound to port `9090`.
service / on new http:Listener(9090) {

    # Validates a kyc information
    # + accountId - account id to validate
    # + return - HTTP Ok if the kyc is found, otherwise HTTP Not found
    resource function post maps/kyc/[string accountId]() returns KycInfo|error? {
        KycInfo kycInfo;
        if regex:matches(accountId, "[A-Za-z ]+") {
            kycInfo = {
                accountId: accountId,
                state: "rejected",
                supportingDocuments: [
                    {
                        fileId: 5678,
                        'type: "social_security_card",
                        state: "rejected",
                        rejectReason: "illegible",
                        createTime: "1480700500000"
                    },
                    {
                        fileId: 1234,
                        'type: "social_security_card",
                        state: "rejected",
                        rejectReason: "illegible",
                        createTime: "1480700611000"
                    },
                    {
                        fileId: 9101,
                        'type: "current_utility_bill",
                        state: "rejected",
                        rejectReason: "illegible",
                        createTime: "1480700611000"
                    }

                ],
                legalName: {first: "Sophia", last: "Ran"}
            };
        } else {
            kycInfo = {
                accountId: accountId,
                state: "verified",
                supportingDocuments: [
                    {
                        fileId: 5678,
                        'type: "social_security_card",
                        state: "rejected",
                        rejectReason: "illegible",
                        createTime: "1480700500000"
                    },
                    {
                        fileId: 1234,
                        'type: "social_security_card",
                        state: "verified",
                        rejectReason: "",
                        createTime: "1480700611000"
                    },
                    {
                        fileId: 9101,
                        'type: "current_utility_bill",
                        state: "verified",
                        rejectReason: "",
                        createTime: "1480700611000"
                    }

                ],
                legalName: {first: "John", last: "Smith"}
            };
        }

        return kycInfo;
    }
}
