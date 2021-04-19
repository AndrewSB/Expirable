import Foundation
import Combine

public protocol Expirable {
  var expiresAt: Date { get }

  /// If the token is going to expire in less than this, consider it expired and just get a new token
  var expirationMarginInterval: TimeInterval { get }
}

public extension Expirable {
  var isValid: Bool { return expiresAt > Date() }

  var isExpiredOrExpiringSoon: Bool {
    let expiresIn = expiresAt.timeIntervalSinceNow
    let expiredOrWillExpireSoon = expiresIn <= expirationMarginInterval

    return expiredOrWillExpireSoon
  }

  var expiresSoon: AnyPublisher<Void, Never> {
    let expiresSoonAt = expiresAt.timeIntervalSinceNow - expirationMarginInterval

    guard expiresSoonAt > 0 else {
      return Just(()).eraseToAnyPublisher()
    }

    return Timer.publish(every: expiresSoonAt, on: .main, in: .default)
      .autoconnect()
      .map { _ in }
      .eraseToAnyPublisher()
  }

}
