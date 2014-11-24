import UIKit

func isRunningTests() -> Bool {

    return NSProcessInfo.processInfo().environment["XCInjectBundle"] != nil
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
}