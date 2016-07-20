/*
 * Copyright IBM Corporation 2016
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import XCTest
import Foundation
import Kitura
import KituraNet

@testable import KituraCORS

#if os(Linux)
    import Glibc
#else
    import Darwin
#endif

class TestBasicCORS : XCTestCase {
    
    static var allTests : [(String, (TestBasicCORS) -> () throws -> Void)] {
        return [
            ("testSimple", testSimple),
            ("testPreflight", testPreflight),
        ]
    }
    
    override func tearDown() {
        doTearDown()
    }
    
    let router = TestBasicCORS.setupRouter()
    func testSimple() {
        performServerTest(router) { expectation in
            self.performRequest("get", path:"/cors", callback: {response in
                XCTAssertNotNil(response, "ERROR!!! ClientRequest response object was nil")
                guard (response != nil) else {
                    return
                }
                XCTAssertEqual(response!.statusCode, HTTPStatusCode.OK, "HTTP Status code was \(response!.statusCode)")
                XCTAssertNotNil(response!.headers["Access-Control-Allow-Origin"], "No allow origin header")
                guard let originHeader = response!.headers["Access-Control-Allow-Origin"]?.first else {
                    return
                }
                XCTAssertEqual(originHeader, "*")
                
                XCTAssertNil(response!.headers["Access-Control-Allow-Credentials"], "Allow credentials header shouldn't be set")

                do {
                    guard let body = try response!.readString() else {
                        XCTFail("No response body")
                        return
                    }
                    XCTAssertEqual(body, "Basic CORS")
                }
                catch{
                    XCTFail("No response body")
                }
                expectation.fulfill()
            }, headers: ["Origin" : "http://api.bob.com"])
        }
    }
    
    func testPreflight() {
        performServerTest(router) { expectation in
            self.performRequest("options", path:"/cors", callback: {response in
                XCTAssertNotNil(response, "ERROR!!! ClientRequest response object was nil")
                guard (response != nil) else {
                    return
                }
                XCTAssertEqual(response!.statusCode, HTTPStatusCode.noContent, "HTTP Status code was \(response!.statusCode)")
                // origin
                XCTAssertNotNil(response!.headers["Access-Control-Allow-Origin"], "No allow origin header")
                guard let originHeader = response!.headers["Access-Control-Allow-Origin"]?.first else {
                    return
                }
                XCTAssertEqual(originHeader, "*")
                
                // credentials
                XCTAssertNil(response!.headers["Access-Control-Allow-Credentials"], "Allow credentials header shouldn't be set")
                
                // methods
                XCTAssertNotNil(response!.headers["Access-Control-Allow-Methods"], "No allow methods header")
                guard let methods = response!.headers["Access-Control-Allow-Methods"]?.first else {
                    return
                }
                XCTAssertEqual(methods, "GET,HEAD,PUT,PATCH,POST,DELETE")
                
                //allow headers
                XCTAssertNotNil(response!.headers["Access-Control-Allow-Headers"], "No allow headers header")
                guard let headers = response!.headers["Access-Control-Allow-Headers"]?.first else {
                    return
                }
                XCTAssertEqual(headers, "X-Custom-Header")
                
                // maxAge
                XCTAssertNil(response!.headers["Access-Control-Max-Age"], "Max Age header shouldn't be set")
                // expose headers
                XCTAssertNil(response!.headers["Access-Control-Expose-Headers"], "Expose headers shouldn't be set")
                
                do {
                    if let _ = try response!.readString() {
                        XCTFail("Got response body for preflight")
                    }
                }
                catch{}
                expectation.fulfill()
            }, headers: ["Origin" : "http://api.bob.com", "Access-Control-Request-Method" : "PUT", "Access-Control-Request-Headers" : "X-Custom-Header"])
        }
    }

    
    static func setupRouter() -> Router {
        let router = Router()
        
        router.all(middleware: CORS(options: Options()))
        router.get("/cors") { _, response, next in
            do {
                try response.end("Basic CORS")
            }
            catch {}
            next()
        }
        
        return router
    }
 }
