# Imperial



## About
Imperial is a Federated Login service, allowing you to easily integrate your Vapor applications with OAuth providers to handle your apps authentication.


## Usage
Define your service within your configuration and register it to your application and access them comfortably from `Request`
```swift
// configuration.swift

app.imperialservices.register(.google) { req in 

    let googleService = GoogleService(
  	req: <#T##Request#>, 
	authURL: <#T##URL#>, 
	flowURL: <#T##URL#>, 
	clientID: <#T##String#>, 
	clientSecret: <#T##String#>, 
	redirectURI: <#T##String#>, 
	callback: <#T##(Request, ImperialBody) -> Void#>
    )
    return googleService
}
```



## Links
- Heavily Inspired by: https://github.com/vapor-community/Imperial

