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

// MARK Options

/// The options for configuration of `CORS`.
/// See [CORS manual](https://www.w3.org/TR/cors/) for more details.
public struct Options {

    /// A configuration of the Access-Control-Allow-Origin response header.
    public var allowedOrigin: AllowedOrigins
    
    /// An indication as to whether to set the Access-Control-Allow-Credentials header.
    public var credentials: Bool
    
    /// An array of methods to be passed in the Access-Control-Allow-Methods header.
    public var methods: [String]
    
    /// An array of allowed headers to configure the Access-Control-Allow-Headers header.
    /// If not specified, the headers specified in the request's Access-Control-Request-Headers
    /// header are passed.
    public var allowedHeaders: [String]?
    
    /// An integer to set the Access-Control-Allow-Max-Age header. If not set, the header is omitted.
    public var maxAge: Int?
    
    /// An array of exposed headers to configure the Access-Control-Expose-Headers header.
    /// If not set, the header is omitted.
    public var exposedHeaders: [String]?
    
    /// A boolean that defines whether or not to pass the CORS preflight response to the next handler.
    public var preflightContinue: Bool
    
    /// Initialize an instance of `Options`.
    ///
    /// - Parameter allowedOrigin: A configuration of the Access-Control-Allow-Origin response header.
    /// - Parameter credentials: An indication as to whether to set the 
    ///                         Access-Control-Allow-Credentials header.
    /// - Parameter methods: An array of methods to be passed in the Access-Control-Allow-Methods header.
    /// - Parameter allowedHeaders: An array of allowed headers to configure the 
    ///                         Access-Control-Allow-Headers header.
    /// - Parameter maxAge: An integer to set the Access-Control-Allow-Max-Age header.
    /// - Parameter exposedHeaders: An array of exposed headers to configure the 
    ///                         Access-Control-Expose-Headers header.
    /// - Parameter preflightContinue: A boolean that defines whether to pass the CORS 
    ///                         preflight response to the next handler.
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
