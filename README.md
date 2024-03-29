# OAuth Kit



## About
Imperial is a Federated Login service, allowing you to easily integrate your Vapor applications with OAuth providers to handle your apps authentication.


## Usage
Define your service within your configuration and register it to your application and access them comfortably from `Request`
```swift
// configuration.swift

app.oauthservices.register(.google) { req in 
  let cacheGrantor = CacheGrantable<<#T##GoogleAccessToken#>>()
  let authorizationHandler = {(<#T##Request#>, <#T##GoogleAuthorizationToken#>) 
    cacheGrantor.approve(<#T##GoogleAuthoriztationToken#>) }
  let authorizationGrant = AuthorizationGrant<<#T##GoogleAuthorizationPayload#>, <#T##GoogleAuthorizationToken#>>(
    name: "authorize",
    scheme: "https",
    host: "google.com",
    path: "hasdas",
    handler: authorizationHandler )

  let googleService = GoogleService(
	  req: <#T##Request#>, 
    grantor:  <#T##any Grantor#>,
    grants: <#T##Dictionary<String, any ImperialGrantable>#>
  )
  return googleService
}
```



## Links
- Heavily Inspired by: https://github.com/vapor-community/Imperial

