import XCTest
import Foundation

class FairnessNotificationCenterTests: XCTestCase {

    var sut: FairnessNotificationCenter!
    var foundationNotificationCenter: NSNotificationCenterForTesting!
    let notification = NSNotification(name: "", object: nil)
    var closureWasExecuted: Bool!

    override func setUp() {

        closureWasExecuted = false
        foundationNotificationCenter = NSNotificationCenterForTesting()
        sut = NotificationCenter(foundationNotificationCenter: foundationNotificationCenter)
    }

    func testTransactionDidStart() {

        sut.transactionDidStart()
        XCTAssertEqual(foundationNotificationCenter.notificationName, "Transaction Did Start")
    }

    func testTransactionDidEnd() {

        sut.transactionDidEnd()
        XCTAssertEqual(foundationNotificationCenter.notificationName, "Transaction Did End")
    }

    func testObserveTransactionDidStart() {

        sut.observeTransactionDidStart { self.closureWasExecuted = true }
        foundationNotificationCenter.callback!(notification)
    }

    func testObserveTransactionDidEnd() {

        sut.observeTransactionDidEnd { self.closureWasExecuted = true }
        foundationNotificationCenter.callback!(notification)
    }
}