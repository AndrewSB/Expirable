# Expirable
A Swift µ-Library for modeling and reacting to values that expire


### Rationale 

I wrote this while dealing with a number of expiring values (nonces from a hardware device, OAuth tokens, command tokens to send to hardware) during my time at [Proxy](https://proxy.co).

It's a one-file dependency that exposes an `Expirable` protocol. Once implemented by a object that models some data that becomes stale at some point in the future, you get a number of convienient ways to deal with and react to said data expiring

### Sample usage

```swift 
struct OAuthToken: Exiprable {
  let token: String
  let refreshToken: String
  
  let expiresAt: Date
  var expirationMarginInterval: TimeInterval { return 30 }
}
```
I'd fill in the `token`, `refreshToken`, and `expiresAt` from my server response. The `expirationMarginInterval` is an interval before the expiry date at which one can (pre-)fetch a new auth token, to try to make it so the system always has a valid auth token. I'd use it like so:

```swift
class APIProvider {
  init() {
    // ...
    self.authToken.expiresSoon.flatMap(requestNewAuthTokenAndSaveIt).disposed(by: self.disposeBag)
    // ...
  }
}
```

The `expiresSoon` Observable is the real meat of this micro library. It hoists the syncronous "have I expired yet" checks one could make when making a server request into the Rx world, to optimistically refresh early 😊

### API

##### `Expirable` 

The protocol exposed in this micro library, it expects two pieces of data

###### `expiresAt: Date` the date at which the data expires

###### `expirationMarginInterval: TimeInterval` an interval preceeding the expiry used to send a message of impending expiry 

##### `isValid: Bool`

syncronous access to whether the object has expired

##### `isExpiredOrExpiringSoon: Bool`

syncronous access to whether the object has expired or is about to expire, based on subtracting the `expirationMarginInterval` from the `expiresAt` date

##### `expiresSoon: Observable<Void>`

an observable that will fire as soon as the current date is greater than `expiresAt - expirationMarginInterval`.
