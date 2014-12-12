import XCTest

class NotificationCenterTests: XCTestCase {
    var sut: NotificationCenter!
    var foundationNotificationCenter: NSNotificationCenterForTesting!
    let notificationName = "notification"

    override func setUp() {
        foundationNotificationCenter = NSNotificationCenterForTesting()
        sut = NotificationCenter(foundationNotificationCenter: foundationNotificationCenter)
    }

    func testAddObserverForName() {
        var callbackWasCalled = false
        let callback: NSNotification -> () = { notification in callbackWasCalled = true }

        sut.observeNotificationWithName(notificationName, callback: callback)

        foundationNotificationCenter.callback?(NSNotification(name: notificationName, object: nil))
        XCTAssertTrue(callbackWasCalled)
        XCTAssertEqual(foundationNotificationCenter.notificationName, notificationName)
    }

    func testPostNotification() {
        sut.postNotificationWithName(notificationName)

        XCTAssertEqual(foundationNotificationCenter.notificationName, notificationName)
    }

    func testObserversAreRemoved() {
        sut.observeNotificationWithName(notificationName, callback: { notification in })
        sut = nil
        XCTAssertTrue(foundationNotificationCenter.removeObserverWasCalledSuccessfully)
    }
}