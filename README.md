<h2 align="center">OAuth Kit</h2>


## About
The goal is to cover most popular cases.

OAuthKit has capabilities to store multiple Services. (ex.: Google, Facebook, etc...)
each holding claims representative for a value. 

Helper Functions, to facilitate custom Services and give a guideline to construct them.

Each Service is preconstructed, to be found within the folder Vendor and consits of 
  - an identifier for recognition purposes.
  - a token, construct and store the `Access-Token`.
  - a `redirectURI`, the configured redirect onto your server after authentication Response.
  - a function to construct the authenticationURL.
      the oauth authentication endpoint from the third party provider.
      Including but not exclusive to the optionals.
  - a function to construct the tokenURL.
      the oauth token endpoint from the third party provider.
      Customizable to cache additional entries.
  - a function to construct the request body data for the specified vendor `queryitemBuffer`.
  

### See more:
- https://github.com/bwdmr/oauth


