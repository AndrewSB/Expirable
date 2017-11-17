# Expirable
A Swift µ-Library for modeling and reacting to values that expire


### Rationale 

I wrote this while dealing with a number of expiring values (nonces from a hardware device, OAuth tokens, command tokens to send to hardware) during my time at [Proxy](https://proxy.co).

It's a one-file dependency that exposes an `Expirable` protocol. Once implemented by a object that models some data that becomes stale at some point in the future, you get a number of convienient ways to deal with and react to said data expiring

### Installation

The package is available through
- Swift package manager
- Carthage
- Manual copying of the one file

### Sample usage

You can check out the [Example.playground](Example.playground) to see an example of the library in use. Make sure you `carthage bootstrap` and build the Expirable framework, the playground can't run without them.

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
