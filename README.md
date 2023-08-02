![Platforms](https://img.shields.io/badge/Platforms-iOS,%20iPadOS,%20tvOS%20&%20macOS-blue)
![Platforms](https://img.shields.io/badge/Swift-5.7.1-orange)
![Actions Status](https://img.shields.io/github/actions/workflow/status/ssh88/feather/tests.yml?label=Unit%20%26%20UI%20Tests)

<p align="center">
<img src="/Sources/Resources/feather-title-logo.png" alt="logo" height="300">
</p>

Feather is a simple lightweight solution to enable mocking in UI tests for Swift projects.

Mocking is an important part of testing. However, unlike unit tests, mocking is harder to achieve in UI tests as we do not import the main app into the UITest target. This means we do not have access to the underlying code, such as objects and functions, to use techniques like DI to inject mocks.

Feather enables mocking by spinning up a temporary local server on-device, giving you full control to map mock responses for API calls without having an intrusive footprint in your code.
 
## Features

- 💉 Simple API to inject mock API responses into UI Tests with minimum effort and footprint!

- 📱 Spins up a local server on-device/simulator and tears down once UITest Target has stopped running!

- 🚀 Dynamically update mock responses at run time!

- 🤸 Flexible API allowing various ways to provide mock responses!

- 👨‍💻 Written in 100% Swift using Swift Vapor

## Installation

### Swift Package Manager

There are two steps needed for Feather to work in your UITest target.

#### 1. Add Package to project
 
- From Xcode, select File > Add Packages
- Enter the Feather repo URL https://github.com/ssh88/Feather.git
- Select Add Package

#### 2. Add Feather to UITest Target

SPM does not automatically add Feather to your UITest target, so the below steps have to be done manually from Xcode:
- Select your UITest target
- Select the Build Phases tab
- Add Feather in the "Link Binary With Libraries" section using the + button

<p align="center">
<img src="/Sources/Resources/link-binary-test-target.png" alt="logo" height="300">
</p>

You should now be able to import Feather into your UITest target.

## Usage

### Mock Routes

Before understanding how Feather's mock server is configured, a key concept of Feather to understand is the `MockRoute` object. A mock route declares the following information:

- The HTTP method the route will use
- The endpoint to which the route will be mapped to
- The status code to return for the response
- A JSON string to be used as the mock response
  - As shown below, there are various ways of providing the JSON response 

All API requests for a given UITest need to be mapped to a mock route. Feather achieves this mapping by injecting these routes from the UITest target into the mock server.

### Declaring Mock Routes

You can declare routes in 3 ways as shown below, each with a different way of providing the mock response:

#### Using a JSON file
```swift
MockRoute(method: .get,
          endpoint: "user",
          code: 200,
          filename: "get_user_200")
```
#### Using an Encodable object

```swift
MockRoute(method: .get,
          endpoint: "user",
          code: 200,
          object: User.mock())
```
#### Using a JSON String

```swift
let jsonString = """
{
 "name": "John Doe",
 "username": "JohnD",
 "email": "john.doe@email.com"
}
"""
   
MockRoute(method: .get,
          endpoint: "user",
          code: 200,
          json: jsonString)
```

### Configuring the Mock Server

#### Starting the Server

The server can be created via the following initializer:
```swift
Feather(host: "localhost", port: 8080)
```
The above example will create the server at the address `http://localhost:8080` when started.

**Note** that the `host` parameter is optional, by default the host will be set to "localhost".

Once configured, the server is started by calling the `startServer(with:)` function, passing in an array of `MockRoute`'s

#### Stopping the Server

The server can be stopped by calling the `pluck()` function.

### Setting the base URL

The final step to ensure your app correctly points to Feather's mock server is to update the base URL used to make API calls.

The simplest approach is to set the base URL inside the `launchEnvironment` dictionary on the `XCUIApplication` before you launch the UITest target as shown below:

```swift
app.launchEnvironment["baseUrl"] = feather.baseUrl
```

Your main app target will then receive the base URL as an environment argument. Depending on your app architecture you can then use this to prefix your API calls accordingly.

An example of this is shown below

```swift
 private var baseUrl: String {
  return ProcessInfo.processInfo.environment["baseUrl"] ?? "https://api.myCompany.com"
 }
```

### Example 

A typical setup for a UITest using Feather is shown below:

```swift
import XCTest
import Feather

final class ExampleUITests: XCTestCase {
   
  var app: XCUIApplication!
  var feather: Feather!
   
  override func setUp() {
    super.setUp()
    feather = Feather(port: 8080)
    app = XCUIApplication()
    app.launchEnvironment["baseUrl"] = feather.baseUrl
  }
   
  override func tearDown() {
    feather.pluck()
    feather = nil
    app = nil
    super.tearDown()
  }
   
  func test_example() {
    let routes: [MockRoute] = [.init(method: .get,
                                     endpoint: "user",
                                     code: 200,
                                     object: User.mock())]
     
    feather.startServer(with: routes)
    app.launch()
     
    // Test Assertions
    ...
    ...
  }
}

```

### Dynamic Routes

Sometimes a response for a given endpoint may need to be changed at runtime. 

For example, if you are testing adding items to a basket, your test may need to assert against a response that reflects an empty state, and then another response with items added.

To modify responses you can call one of the three ```updateRoute``` functions, passing in the updated JSON response, as well as the HTTP method and endpoint parameters which are used to identify the mock route to update.

```Swift
feather.updateRoute(method: .get, endpoint: "user", object: User.mock(username: "Jane"))
```

## Demo App

The repo contains a simple demo app that gives an example of how to use Feather in your UITest target, with various UI tests to demonstrate the different functions of Feather.
<p align="center">
<img src="/Sources/Resources/demo-app.png" alt="logo" height="500">
</p>

## Limitations

Feather was created as a bare-bones solution for a specific project, as a result, it is currently limited in scope.
Below are some note worthy limitations that we aim to address in the future:

- Our mock routes are very basic, we do not support query params, timeouts, or redirects
- Unable to support test parralisation. This will be spported shortly by dynamically setting the server port to one that is available, meaning multiple servers can be spun up in parrallel.

For a more mature solution check our [Shock](https://github.com/justeat/Shock) by the team over at [Just Eat Takeaway](https://github.com/justeat).

## Contributions

If you feel you have a valuable feature to add or fix a bug, feel free to raise a PR.

## License
Feather is available under Apache License 2.0. See the LICENSE file for more info.
