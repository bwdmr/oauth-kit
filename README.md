<h2 align="center">OAuth Kit</h2>


## About
The goal is to extend this library gradually and cover most popular cases manually.

OAuthKit has capabilities to store multiple Services. (ex.: Google, Facebook, etc...)
each holding claims, representing values to be requested as well as retrieved.

Helper Functions, to facilitate custom Services and give a guideline to construct them.

Each Service is preconstructed, to be found within the folder Vendor and consits of 
  - an identifier for recognition purposes.
  - a token, construct and store the Response Type.
  - a redirectURI, the configured redirect onto your server.
  - a function to construct the authenticationURL, 
      the oauth authentication endpoint from the third party provider.
  - a function to construct the tokenURL, 
      the token endpoint from the third party provider.
  - a function to construct the request body data for the specified vendor queryitemBuffer.
  

### See more:
- https://github.com/bwdmr/oauth


