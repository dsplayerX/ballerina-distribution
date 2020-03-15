import ballerina/test;

any[] outputs = [];
int counter = 0;

// This is the mock function which will replace the real function
@test:Mock {
    moduleName: "ballerina/io",
    functionName: "println"
}
public function mockPrint(any... s) {
    string outstr = "";
    foreach var str in s {
        outstr = outstr + str.toString();
    }
    outputs[counter] = outstr;
    counter += 1;
}

@test:Config {}
function testFunc() {
    // Invoking the main function
    main();
    test:assertEquals(outputs[0], "Reason String: Sample Error");
    test:assertEquals(outputs[1], "Info: Detail Msg");
    test:assertEquals(outputs[2], "Fatal: true");
    test:assertEquals(outputs[3], "Reason String: Sample Error");
    test:assertEquals(outputs[4], "Detail Mapping: info=Detail Msg fatal=true");
    test:assertEquals(outputs[5], "Detail Mapping: fatal=true");
    test:assertEquals(outputs[6], "Detail Message: Failed Message");
}
