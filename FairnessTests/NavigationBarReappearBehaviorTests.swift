import XCTest
import UIKit

class NavigationBarReappearBehaviorTests: XCTestCase {

    class UINavigationControllerForTesting: UINavigationController {

        var navigationBarIsShown = false

        override func setNavigationBarHidden(hidden: Bool, animated: Bool) {

            navigationBarIsShown = hidden == false && animated == true
        }
    }

    var sut: NavigationBarReappearBehavior!
    var notificationCenter: FairnessNotificationCenterForTesting!
    var navigationController: UINavigationControllerForTesting!

    override func setUp() {

        navigationController = UINavigationControllerForTesting()
        notificationCenter = FairnessNotificationCenterForTesting()

        sut = NavigationBarReappearBehavior(notificationCenter: notificationCenter)
        sut.navigationController = navigationController
    }

    func testNavigationBarIsShownWhenTransactionEnds() {

        notificationCenter.keyboardWillHideCallback?()
        XCTAssertTrue(navigationController.navigationBarIsShown)
    }
}