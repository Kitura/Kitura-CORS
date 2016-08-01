# Kitura-CORS
Kitura CORS middleware

[![Build Status - Master](https://travis-ci.org/IBM-Swift/Kitura.svg?branch=master)](https://travis-ci.org/IBM-Swift/Kitura-CORS)
![Mac OS X](https://img.shields.io/badge/os-Mac%20OS%20X-green.svg?style=flat)
![Linux](https://img.shields.io/badge/os-linux-green.svg?style=flat)
![Apache 2](https://img.shields.io/badge/license-Apache2-blue.svg?style=flat)

## Summary
Kitura [CORS](https://www.w3.org/TR/cors/) middleware.

## API

To create an instance of Kitura-CORS middleware use:

```swift
public init(options : Options)
```
where possible `Options` are:
   - *allowedOrigin* - an enum that configures the `Access-Control-Allow-Origin` CORS server response header. Possible values:
    - *all* - all origins are allowed. `Access-Control-Allow-Origin` will be set to `*`. This is the default.
    - *set* - a set of allowed origins.
    - *origin* - single allowed origin.
    - *regex* - a regular expression that defines allowed origins.
   - *credentials* - a boolean value that configures the `Access-Control-Allow-Credentials` CORS header. Is set only if equals to `true`, otherwise the header is not passed. Defaults to `false`.
   - *methods* - an array of methods to be passed in `Access-Control-Allow-Methods` header. The default is `["GET","HEAD","PUT","PATCH","POST","DELETE"]`.
   - *allowedHeaders* - an array of allowed headers to configure the `Access-Control-Allow-Headers` CORS header. If not specified, the headers specified in the request's `Access-Control-Request-Headers` header are passed.
   - *maxAge* - an integer to set the `Access-Control-Allow-Max-Age` header. If not set, the header is omitted.
   - *exposedHeaders* - an array of exposed headers to configure the `Access-Control-Expose-Headers` header. If not set, the header is omitted.
   - *preflightContinue* - a boolean that defines whether to pass the CORS preflight response to the next handler. Defaults to `false`.

Please see [CORS documentation](https://www.w3.org/TR/cors/) for details.

### Example

First create an instance of `CORS`:

```swift
import KituraCORS

let options = Options(allowedOrigin: .origin("www.abc.com"), methods: ["GET","PUT"], allowedHeaders: ["Content-Type"], maxAge: 5)
let cors = CORS(options: options)
```
Kitura-CORS is `RouterMiddleware`. To connect it to the desired path use one of the `Router` methods:

```swift
router.all("/cors", middleware: cors)
```
## License
This library is licensed under Apache 2.0. Full license text is available in [LICENSE](LICENSE.txt).
