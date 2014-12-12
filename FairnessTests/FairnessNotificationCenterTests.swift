import XCTest
import Foundation

class FairnessNotificationCenterTests: XCTestCase {
    var sut: FairnessNotificationCenter!
    var foundationNotificationCenter: NSNotificationCenterForTesting!
    let notification = NSNotification(name: "", object: nil)
    var callback: CallbackWithoutNotification!
    var closureWasExecuted: Bool = false

    override func setUp() {
        closureWasExecuted = false
        callback = { self.closureWasExecuted = true }
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
}

extension FairnessNotificationCenterTests {
    func assertClosureWasExecuted() {
        foundationNotificationCenter.callback!(notification)
        XCTAssertTrue(closureWasExecuted)
    }

    func testObserveTransactionDidStart() {
        sut.observeTransactionDidStart(callback)
        assertClosureWasExecuted()
    }

    func testObserveTransactionDidEnd() {
        sut.observeTransactionDidEnd(callback)
        assertClosureWasExecuted()
    }

    func testObserveKeyboardWillHide() {
        sut.observeKeyboardWillHide(callback)
        assertClosureWasExecuted()
    }
}