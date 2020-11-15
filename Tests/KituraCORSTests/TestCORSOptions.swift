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

class TestCORSOptions : XCTestCase {

    static var allTests : [(String, (TestCORSOptions) -> () throws -> Void)] {
        return [
            ("testSimple", testSimple),
            ("testPreflight", testPreflight),
            ("testSimpleWithRegEx", testSimpleWithRegEx),
            ("testSimpleWithSet", testSimpleWithSet),
        ]
    }

    override func tearDown() {
        doTearDown()
    }

    let router = TestCORSOptions.setupRouter()
    func testSimple() {
        performServerTest(router) { expectation in
            self.performRequest("get", path:"/cors", callback: {response in
                XCTAssertNotNil(response, "ERROR!!! ClientRequest response object was nil")
                guard (response != nil) else {
                    return
                }
                //origin
                XCTAssertEqual(response!.statusCode, HTTPStatusCode.OK, "HTTP Status code was \(response!.statusCode)")
                XCTAssertNotNil(response!.headers["Access-Control-Allow-Origin"], "No allow origin header")
                guard let originHeader = response!.headers["Access-Control-Allow-Origin"]?.first else {
                    return
                }
                XCTAssertEqual(originHeader, "http://api.bob.com")

                //credentials
                XCTAssertNotNil(response!.headers["Access-Control-Allow-Credentials"], "No allow credentials header")
                guard let credentials = response!.headers["Access-Control-Allow-Credentials"]?.first else {
                    return
                }
                XCTAssertEqual(credentials, "true")

                do {
                    guard let body = try response!.readString() else {
                        XCTFail("No response body")
                        return
                    }
                    XCTAssertEqual(body, "CORS with options")
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
                XCTAssertEqual(originHeader, "http://api.bob.com")

                // credentials
                XCTAssertNotNil(response!.headers["Access-Control-Allow-Credentials"], "No allow credentials header")
                guard let credentials = response!.headers["Access-Control-Allow-Credentials"]?.first else {
                    return
                }
                XCTAssertEqual(credentials, "true")

                // methods
                XCTAssertNotNil(response!.headers["Access-Control-Allow-Methods"], "No allow methods header")
                guard let methods = response!.headers["Access-Control-Allow-Methods"]?.first else {
                    return
                }
                XCTAssertEqual(methods, "GET,PUT")

                //allow headers
                XCTAssertNotNil(response!.headers["Access-Control-Allow-Headers"], "No allow headers header")
                guard let headers = response!.headers["Access-Control-Allow-Headers"]?.first else {
                    return
                }
                XCTAssertEqual(headers, "Content-Type")

                // maxAge
                XCTAssertNotNil(response!.headers["Access-Control-Max-Age"], "No Max Age header")
                guard let maxAge = response!.headers["Access-Control-Max-Age"]?.first else {
                    return
                }
                XCTAssertEqual(maxAge, "10")

                // expose headers
                XCTAssertNotNil(response!.headers["Access-Control-Expose-Headers"], "No expose headers header")
                guard let exposeHeaders = response!.headers["Access-Control-Expose-Headers"]?.first else {
                    return
                }
                XCTAssertEqual(exposeHeaders, "Content-Type,X-Custom-Header")

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


    func testSimpleWithRegEx() {
        performServerTest(router) { expectation in
            self.performRequest("get", path:"/regex", callback: {response in
                XCTAssertNotNil(response, "ERROR!!! ClientRequest response object was nil")
                guard (response != nil) else {
                    return
                }
                //origin
                XCTAssertEqual(response!.statusCode, HTTPStatusCode.OK, "HTTP Status code was \(response!.statusCode)")
                XCTAssertNotNil(response!.headers["Access-Control-Allow-Origin"], "No allow origin header")
                guard let originHeader = response!.headers["Access-Control-Allow-Origin"]?.first else {
                    return
                }
                XCTAssertEqual(originHeader, "http://api.bob.com")

                //credentials
                XCTAssertNil(response!.headers["Access-Control-Allow-Credentials"], "Allow credentials header shouldn't be set")

                do {
                    guard let body = try response!.readString() else {
                        XCTFail("No response body")
                        return
                    }
                    XCTAssertEqual(body, "CORS with options")
                }
                catch{
                    XCTFail("No response body")
                }
                expectation.fulfill()
            }, headers: ["Origin" : "http://api.bob.com"])
        }
    }

    func testSimpleWithSet() {
        performServerTest(router) { expectation in
            self.performRequest("get", path:"/set", callback: {response in
                XCTAssertNotNil(response, "ERROR!!! ClientRequest response object was nil")
                guard (response != nil) else {
                    return
                }
                //origin
                XCTAssertEqual(response!.statusCode, HTTPStatusCode.OK, "HTTP Status code was \(response!.statusCode)")
                XCTAssertNotNil(response!.headers["Access-Control-Allow-Origin"], "No allow origin header")
                guard let originHeader = response!.headers["Access-Control-Allow-Origin"]?.first else {
                    return
                }
                XCTAssertEqual(originHeader, "http://api.bob.com")

                //credentials
                XCTAssertNil(response!.headers["Access-Control-Allow-Credentials"], "Allow credentials header shouldn't be set")

                do {
                    guard let body = try response!.readString() else {
                        XCTFail("No response body")
                        return
                    }
                    XCTAssertEqual(body, "CORS with options")
                }
                catch{
                    XCTFail("No response body")
                }
                expectation.fulfill()
            }, headers: ["Origin" : "http://api.bob.com"])
        }
    }
    
    func testSimpleWithSameAsOrigin() {
        let origin = "http://api.bob.com"
        performServerTest(router) { expectation in
            self.performRequest("get", path:"/same", callback: { response in
                XCTAssertNotNil(response, "ERROR!!! ClientRequest response object was nil")
                guard let response = response else {
                    return
                }
                let expectedValue = origin
                var resolvedValue: String
                
                //origin
                XCTAssertEqual(response.statusCode, HTTPStatusCode.OK, "HTTP Status code was \(response.statusCode)")
                XCTAssertNotNil(response.headers["Access-Control-Allow-Origin"], "No allow origin header")
                guard let originHeader = response.headers["Access-Control-Allow-Origin"]?.first else {
                    return
                }
                resolvedValue = originHeader
                XCTAssertEqual(resolvedValue, expectedValue, "Access-Control-Allow-Origin header should be equal to Origin")

                //credentials
                XCTAssertNil(response.headers["Access-Control-Allow-Credentials"], "Allow credentials header shouldn't be set")

                do {
                    guard let body = try response.readString() else {
                        XCTFail("No response body")
                        return
                    }
                    XCTAssertEqual(body, "CORS with options")
                }
                catch{
                    XCTFail("No response body")
                }
                expectation.fulfill()
            }, headers: ["Origin" : origin])
        }
    }

    static func setupRouter() -> Router {
        let router = Router()

        let options1 = Options(allowedOrigin: .origin("http://api.bob.com"), credentials: true, methods: ["GET","PUT"], allowedHeaders: ["Content-Type"], maxAge: 10, exposedHeaders: ["Content-Type","X-Custom-Header"])
        router.all("/cors", middleware: CORS(options: options1))
        router.get("/cors") { _, response, next in
            do {
                try response.send("CORS with options").end()
            }
            catch {}
            next()
        }

        let pattern = "http?://([-\\w\\.]+)+(:\\d+)?(/([\\w/_\\.]*(\\?\\S+)?)?)?"
        do {
            let regex = try AllowedOriginsRegExType(pattern: pattern, options: [])

            let options2 = Options(allowedOrigin: .regex(regex), credentials: false, methods: ["GET,PUT"], allowedHeaders: ["Content-Type"])
            router.get("/regex", middleware: CORS(options: options2))
        }
        catch {}
        router.get("/regex") { _, response, next in
            do {
                try response.send("CORS with options").end()
            }
            catch {}
            next()
        }

        let origins : Set = ["http://api.bob.com", "http://www.ibm.com"]
        let options3 = Options(allowedOrigin: .set(origins))
        router.all("/set", middleware: CORS(options: options3))
        router.get("/set") { _, response, next in
            do {
                try response.send("CORS with options").end()
            }
            catch {}
            next()
        }
        
        let options4 = Options(allowedOrigin: .sameAsOrigin)
        router.all("/same", middleware: CORS(options: options4))
        router.get("/same") { _, response, next in
            do {
                try response.send("CORS with options").end()
            }
            catch {}
            next()
        }

        return router
    }
}
