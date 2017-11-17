import Foundation
import PlaygroundSupport
import Expirable
import RxSwift

PlaygroundPage.current.needsIndefiniteExecution = true

//So I've got a model type that expires some time in the future, probably that I just pulled down from a server. It looks like
struct AuthToken {
    let token: String
    let refreshToken: String
    let expiry: Date
}

// To use Expirable to monitor and respond to the token's expiry, one simply conforms the object to `Expirable`
extension AuthToken: Expirable {
    var expiresAt: Date { return expiry }
    // I like 30 seconds, because I feel pretty comfortable that my client will be able to request a new token from the server and switch it out in that much time
    var expirationMarginInterval: TimeInterval { return 30 }
}

// And then you can use it like so
class AnApp {
    private let disposeBag = DisposeBag()
    let dummyToken = BehaviorSubject<AuthToken>(value: AuthToken(token: "nope", refreshToken: "magical refresh", expiry: Date(timeIntervalSinceNow: 35)))

    init() {
        print("\(Date()) the playground started running")
        dummyToken
            .flatMap { token in token.expiresSoon }
            .do(onNext: requestNewToken)
            .subscribe(onNext: {
                print("\(Date()) this will execute every 5 seconds after the playground starts running")
        }).disposed(by: self.disposeBag)
    }

    //
    func requestNewToken() {
        self.dummyToken.onNext(AuthToken(token: "another fake one", refreshToken: "lol lolnoway works to refresh", expiry: Date(timeIntervalSinceNow: 35)))
    }
}

let instance = AnApp()
