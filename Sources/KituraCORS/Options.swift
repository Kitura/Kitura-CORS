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

public struct Options {
    public var allowedOrigin : AllowedOrigins
    public var credentials : Bool
    public var methods : [String]
    public var allowedHeaders : [String]?
    public var maxAge : Int?
    public var exposedHeaders : [String]?
    
    public var preflightContinue : Bool
    
    public init(allowedOrigin: AllowedOrigins = .all, credentials: Bool = false, methods: [String] = ["GET","HEAD","PUT","PATCH","POST","DELETE"], allowedHeaders: [String]?=nil, maxAge: Int?=nil, exposedHeaders: [String]?=nil, preflightContinue: Bool = false) {
        self.allowedOrigin = allowedOrigin
        self.credentials = credentials
        self.methods = methods
        self.allowedHeaders = allowedHeaders
        self.maxAge = maxAge
        self.exposedHeaders = exposedHeaders
        self.preflightContinue = preflightContinue
    }
}
