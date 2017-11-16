import Foundation
import RxSwift

public protocol Expirable {
    var expiresAt: Date { get }

    /// If the token is going to expire in less than this, consider it expired and just get a new token
    var expirationMarginInterval: TimeInterval { get }
}

public extension Expirable {
    public var isValid: Bool { return expiresAt > Date() }

    public var isExpiredOrExpiringSoon: Bool {
        let expiresIn = expiresAt.timeIntervalSinceNow
        let expiredOrWillExpireSoon = expiresIn <= expirationMarginInterval

        return expiredOrWillExpireSoon
    }

    public var expiresSoon: Observable<Void> {
        let expiresSoonAt = expiresAt.timeIntervalSinceNow - expirationMarginInterval

        guard expiresSoonAt > 0 else {
            return .just(()) // fire now if it expiresSoonAlready
        }

        return Observable<Int>.timer(expiresSoonAt, scheduler: MainScheduler.instance).map { _ in }
    }
}
