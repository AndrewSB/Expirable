import Foundation
import Combine

public protocol Expirable {
  var expiresAt: Date { get }

  /// If the token is going to expire in less than this, consider it expired and just get a new token
  var expirationMarginInterval: TimeInterval { get }

  /// a current time provider, for when using a network synced clock or the like
  var now: Date { get }
}

extension Expirable {
  var now: Date { Date() }
}

public extension Expirable {
  var isValid: Bool { return expiresAt > now }

  var isExpiredOrExpiringSoon: Bool {
    let expiresIn = expiresAt.timeIntervalSince(now)
    let expiredOrWillExpireSoon = expiresIn <= expirationMarginInterval

    return expiredOrWillExpireSoon
  }

  var expiresSoon: AnyPublisher<Void, Never> {
    let expiresSoonAt = expiresAt.timeIntervalSince(now) - expirationMarginInterval

    guard expiresSoonAt > 0 else {
      return Just(()).eraseToAnyPublisher()
    }

    return Timer.publish(every: expiresSoonAt, on: .main, in: .default)
      .autoconnect()
      .map { _ in }
      .first()
      .eraseToAnyPublisher()
  }

}
