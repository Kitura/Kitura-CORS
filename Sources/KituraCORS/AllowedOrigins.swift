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

import Foundation

// MARK AllowedOrigins

/// Type alias for `AllowedOrigins.regex`.
#if os(Linux)
#if swift(>=3.1)
    public typealias AllowedOriginsRegExType = NSRegularExpression
    #else
    public typealias AllowedOriginsRegExType = RegularExpression
#endif
#else
    public typealias AllowedOriginsRegExType = NSRegularExpression
#endif

/// A configuration of the Access-Control-Allow-Origin CORS response header.
public enum AllowedOrigins {
    /// All origins are allowed. Access-Control-Allow-Origin will be set to *.
    case all

    /// A set of allowed origins.
    case set(Set<String>)

    /// A single allowed origin.
    case origin(String)

    /// A regular expression that defines allowed origins.
    case regex(AllowedOriginsRegExType)
}
