import ballerina/io;

type SampleErrorData record {|
    int code;
    string reason;
|};

type SampleError error<SampleErrorData>;

public function main() {
    // The value of the error message is ignored using `_`.
    // The value of the error cause is set to `cause` variable.
    // The values in the error detail mapping is set to `code` and `reason` variables.
    var error(_, cause, code = code, reason = reason) = getSampleError();
    io:println("Cause: ", cause);
    io:println("Info: ", code);
    io:println("Fatal: ", reason);

    // The values in the cause and detail mapping is ignored in this binding.
    SampleError error(message2) = getSampleError();
    io:println("Message: ", message2);

    error? errorCause;
    int errorCode;

    // The error value is destructured and assigned to variable references.
    // The values of error cause and `code` are assigned to `errorCause` and `errorCode` variables.
    // The error message and the `reason` field in the detail mapping are ignored.
    error(_, errorCause, code = errorCode) = getSampleError();
    io:println("Cause: ", errorCause);
    io:println("Code: ", errorCode);
}

function getSampleError() returns SampleError {
    return error("Transaction Failure", error("Database Error"), code = 20,
                            reason = "deadlock condition");
}
