// Copyright (c) 2020-2024, WSO2 LLC. (https://www.wso2.com).
//
// WSO2 LLC. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/io;
import ballerina/sql;
import ballerina/test;

import ballerinax/java.jdbc;

string xaDatasourceName = "org.h2.jdbcx.JdbcDataSource";

@test:Config {
}
function testXATransactions() returns error? {
    string str = "";
    io:println("start");

    jdbc:Client dbClient1 = check new (url = "jdbc:h2:file:./xa-stransactions/testdb1",
        user = "test", password = "test", options = {datasourceName: xaDatasourceName}
    );

    io:println("db1 inited");
    jdbc:Client dbClient2 = check new (url = "jdbc:h2:file:./xa-stransactions/testdb2",
        user = "test", password = "test", options = {datasourceName: xaDatasourceName}
    );

    io:println("db2 inited");
    sql:ExecutionResult|sql:Error createResult1 = dbClient1->execute(`CREATE TABLE IF NOT EXISTS EMPLOYEE (ID INT, NAME VARCHAR(30))`);

    sql:ExecutionResult|sql:Error createResult2 = dbClient2->execute(`CREATE TABLE IF NOT EXISTS SALARY (ID INT, VALUE FLOAT)`);

    transaction {
        str += "transaction started";
        io:println("transaction started");

        sql:ParameterizedQuery updateQuery1 = `INSERT INTO EMPLOYEE(NAME) VALUES ('Anne')`;
        sql:ExecutionResult|sql:Error updateResult1 = check dbClient1->execute(updateQuery1);

        sql:ParameterizedQuery updateQuery2 = `INSERT INTO SALARY VALUES (1, 25000.00)`;
        sql:ExecutionResult|sql:Error updateResult2 = check dbClient2->execute(updateQuery2);

        var commitResult = commit;
        if commitResult is () {
            str += " -> transaction committed";
        } else {
            str += " -> transaction failed";
        }
        str += " -> transaction ended.";
    }
    test:assertEquals("transaction started -> transaction committed -> transaction ended.", str);

    checkpanic dbClient1.close();
    checkpanic dbClient2.close();
}
