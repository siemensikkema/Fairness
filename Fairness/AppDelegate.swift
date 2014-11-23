import UIKit

func isRunningTests() -> Bool {

    return NSProcessInfo.processInfo().environment["XCInjectBundle"] != nil
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {

        println("is running tests? \(isRunningTests())")
        return true
    }
}