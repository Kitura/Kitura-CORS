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

import Kitura
import Foundation

// MARK CORS

/// Cross-Origin Resource Sharing [CORS](https://www.w3.org/TR/cors/) middleware.
public class CORS: RouterMiddleware {
    
    private let options: Options
    
    /// Initialize an instance of `CORS`.
    ///
    /// - Parameter options: The options to configure CORS.
    public init(options: Options) {
        self.options = options
    }
    
    /// Handle an incoming request by setting the CORS headers in the response.
    ///
    /// - Parameter request: The `RouterRequest` object used to get information
    ///                     about the request.
    /// - Parameter response: The `RouterResponse` object used to respond to the
    ///                       request.
    /// - Parameter next: The closure to invoke to enable the Router to check for
    ///                  other handlers or middleware to work with this request.
    ///
    /// - Throws: Any `ErrorType`. If an error is thrown, processing of the request
    ///          is stopped, the error handlers, if any are defined, will be invoked,
    ///          and the user will get a response with a status code of 500.
    public func handle(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
        guard let _ = request.headers["Origin"] else {
            next()
            return
        }
        if (request.method == .options) {
            setAllowOriginHeader(request: request, response: response)
            setAllowCredentialsHeader(request: request, response: response)
            setAllowMethodsHeader(request: request, response: response)
            setAllowHeadersHeader(request: request, response: response)
            setMaxAgeHeader(request: request, response: response)
            setExposeHeadersHeader(request: request, response: response)
            
            if (options.preflightContinue) {
                next()
            }
            else {
                try response.status(.noContent).end()
            }
        }
        else {
            setAllowOriginHeader(request: request, response: response)
            setAllowCredentialsHeader(request: request, response: response)
            setExposeHeadersHeader(request: request, response: response)
            next()
        }
    }
    
    private func setAllowOriginHeader(request: RouterRequest, response: RouterResponse) {
        let requestOrigin = request.headers["Origin"]!
        var headerValue : String
        
        switch options.allowedOrigin {
        case .all:
            headerValue = "*"
        case .set, .origin, .regex:
            if isAllowed(origin: requestOrigin) {
                headerValue = requestOrigin
            }
            else {
                headerValue = "false"
            }
        }
        response.headers.append("Access-Control-Allow-Origin", value: headerValue)
    }
    
    private func isAllowed(origin: String) -> Bool {
        var allowed = false
        switch options.allowedOrigin {
        case .set(let set):
            if set.contains(origin) {
                allowed = true
            }
        case .origin(let allowedOrigin):
            if origin == allowedOrigin {
                allowed = true
            }
        case .regex(let regex):
            if regex.numberOfMatches(in: origin, options: [], range: NSRange(location: 0, length: origin.count)) == 1 {
                allowed = true
            }
        default: break
        }
        return allowed
    }
    
    private func setAllowCredentialsHeader(request: RouterRequest, response: RouterResponse) {
        if options.credentials == true {
            response.headers.append("Access-Control-Allow-Credentials", value: "true")
        }
    }
    
    private func setAllowMethodsHeader(request: RouterRequest, response: RouterResponse) {
        response.headers.append("Access-Control-Allow-Methods", value: options.methods.joined(separator: ","))
    }
    
    private func setAllowHeadersHeader(request: RouterRequest, response: RouterResponse) {
        if let headers = options.allowedHeaders {
            response.headers.append("Access-Control-Allow-Headers", value: headers.joined(separator: ","))
        }
        else if let headers = request.headers["Access-Control-Request-Headers"] {
            response.headers.append("Access-Control-Allow-Headers", value: headers)
        }
    }
    
    private func setMaxAgeHeader(request: RouterRequest, response: RouterResponse) {
        if let maxAge = options.maxAge {
            response.headers.append("Access-Control-Max-Age", value: String(maxAge))
        }
     }
    
    private func setExposeHeadersHeader(request: RouterRequest, response: RouterResponse) {
        if let headers = options.exposedHeaders {
            response.headers.append("Access-Control-Expose-Headers", value: headers.joined(separator: ","))
        }
    }
}
