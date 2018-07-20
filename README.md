<p align="center">
    <a href="http://kitura.io/">
        <img src="https://raw.githubusercontent.com/IBM-Swift/Kitura/master/Sources/Kitura/resources/kitura-bird.svg?sanitize=true" height="100" alt="Kitura">
    </a>
</p>


<p align="center">
    <a href="https://ibm-swift.github.io/Kitura-CORS/index.html">
    <img src="https://img.shields.io/badge/apidoc-KituraCORS-1FBCE4.svg?style=flat" alt="APIDoc">
    </a>
    <a href="https://travis-ci.org/IBM-Swift/Kitura-CORS">
    <img src="https://travis-ci.org/IBM-Swift/Kitura-CORS.svg?branch=master" alt="Build Status - Master">
    </a>
    <img src="https://img.shields.io/badge/os-macOS-green.svg?style=flat" alt="macOS">
    <img src="https://img.shields.io/badge/os-linux-green.svg?style=flat" alt="Linux">
    <img src="https://img.shields.io/badge/license-Apache2-blue.svg?style=flat" alt="Apache 2">
    <a href="http://swift-at-ibm-slack.mybluemix.net/">
    <img src="http://swift-at-ibm-slack.mybluemix.net/badge.svg" alt="Slack Status">
    </a>
</p>

# Kitura-CORS
Kitura cross-origin resource sharing ([CORS](https://www.w3.org/TR/cors/)) middleware. A request for a resource (such as an image) outside of your origin (e.g. server) is known as a cross-origin request. CORS allows you to bypass the same-origin restriction, so that resources can be shared between different origins (i.e. servers).

## Swift version
The latest version of Kitura-CORS requires **Swift 4.1.2**. You can download this version of the Swift binaries by following this [link](https://swift.org/download/). Compatibility with other Swift versions is not guaranteed.

## Usage

#### Add dependencies

Add the `Kitura-CORS` package to the dependencies within your application’s `Package.swift` file. Substitute `"x.x.x"` with the latest `Kitura-CORS` [release](https://github.com/IBM-Swift/Kitura-CORS/releases).

```swift
.package(url: "https://github.com/IBM-Swift/Kitura-CORS.git", from: "x.x.x")
```

Add `KituraCORS` to your target's dependencies:

```swift
.target(name: "example", dependencies: ["KituraCORS"]),
```

#### Import package

```swift
import KituraCORS
```

### Using Kitura-CORS

To create an instance of Kitura-CORS middleware use:

```swift
public init(options : Options)
```
where possible `Options` are:
   - *allowedOrigin* - an enum that configures the `Access-Control-Allow-Origin` CORS server response header. Possible values are:
      - *all* - all origins are allowed. `Access-Control-Allow-Origin` will be set to `*`. This is the default.
      - *set* - a set of allowed origins.
      - *origin* - a single allowed origin.
      - *regex* - a regular expression that defines allowed origins.
   - *credentials* - a boolean value that indicates whether to set the `Access-Control-Allow-Credentials` CORS header. The header is set only if *credentials* is `true`, otherwise the header is not passed. Defaults to `false`.
   - *methods* - an array of methods to be passed in the `Access-Control-Allow-Methods` header. The default set of methods to be passed is `["GET","HEAD","PUT","PATCH","POST","DELETE"]`.
   - *allowedHeaders* - an array of allowed headers to configure the `Access-Control-Allow-Headers` CORS header. If not specified, the headers specified in the request's `Access-Control-Request-Headers` header are passed.
   - *maxAge* - an integer to set the `Access-Control-Allow-Max-Age` header. If not set, the header is omitted.
   - *exposedHeaders* - an array of exposed headers to configure the `Access-Control-Expose-Headers` header. If not set, the header is omitted.
   - *preflightContinue* - a boolean that defines whether to pass the CORS preflight response to the next handler. Defaults to `false`.

Please see the [CORS documentation](https://www.w3.org/TR/cors/) for more information about CORS.

### Example

First create an instance of `CORS`. In the following example, the resource author has a resource which they would like http://www.abc.com to be able to access. Only the methods *GET* and *PUT* can be used in the actual request, the response can be cached for 5 seconds and only the *Content-Type* header will be used in the actual request:

```swift
import Kitura
import KituraCORS

let options = Options(allowedOrigin: .origin("http://www.abc.com"),
                      methods: ["GET","PUT"],
                      allowedHeaders: ["Content-Type"],
                      maxAge: 5)

let cors = CORS(options: options)
```

Kitura-CORS implements the [RouterMiddleware](https://ibm-swift.github.io/Kitura/Protocols/RouterMiddleware.html) protocol; therefore to connect the middleware to your path you need to use one of the `Router` methods, for example:

```swift
let router = Router()
router.all("/cors", middleware: cors)
```

## API Documentation
For more information visit our [API reference](https://ibm-swift.github.io/Kitura-CORS/index.html).

## Community

We love to talk server-side Swift, and Kitura. Join our [Slack](http://swift-at-ibm-slack.mybluemix.net/) to meet the team!

## License
This library is licensed under Apache 2.0. Full license text is available in [LICENSE](https://github.com/IBM-Swift/Kitura-CORS/blob/master/LICENSE.txt).
