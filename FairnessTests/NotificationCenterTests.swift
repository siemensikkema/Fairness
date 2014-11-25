import XCTest

class NotificationCenter {

    private var foundationNotificationCenter = NSNotificationCenter.defaultCenter()

    private var observers: [NSObjectProtocol] = []

    convenience init(foundationNotificationCenter: NSNotificationCenter) {

        self.init()
        self.foundationNotificationCenter = foundationNotificationCenter
    }

    deinit {

        for observer in observers {

            foundationNotificationCenter.removeObserver(observer)
        }
    }

    func addObserverForName(name: String, callback: NSNotification -> ()) {

        observers.append(foundationNotificationCenter.addObserverForName(name, object: nil, queue: nil, usingBlock: { notification in callback(notification) }))
    }

    func postNotificationWithName(name: String) {

        foundationNotificationCenter.postNotificationName(name, object: nil)
    }
}

class NotificationCenterTests: XCTestCase {

    class NSNotificationCenterForTesting: NSNotificationCenter {

        typealias NotificationBlock = (NSNotification!) -> Void

        var notificationName: String!
        var callback: NotificationBlock?
        var removeObserverWasCalledSuccessfully = false
        let fakeObserver = "fakeObserver"

        override func addObserverForName(name: String?, object obj: AnyObject?, queue: NSOperationQueue?, usingBlock block: NotificationBlock) -> NSObjectProtocol {

            notificationName = name
            callback = block
            return fakeObserver
        }

        override func postNotificationName(aName: String, object anObject: AnyObject?) {

            notificationName = aName
        }

        override func removeObserver(observer: AnyObject) {

            removeObserverWasCalledSuccessfully = observer as NSString == fakeObserver
        }
    }

    var sut: NotificationCenter!
    var foundationNotificationCenter: NSNotificationCenterForTesting!
    let notificationName = "noticiation"

    override func setUp() {

        foundationNotificationCenter = NSNotificationCenterForTesting()
        sut = NotificationCenter(foundationNotificationCenter: foundationNotificationCenter)
    }

    func testAddObserverForName() {

        var callbackWasCalled = false
        let callback: NSNotification -> () = { notification in callbackWasCalled = true }

        sut.addObserverForName(notificationName, callback: callback)

        foundationNotificationCenter.callback?(NSNotification(name: notificationName, object: nil))
        XCTAssertTrue(callbackWasCalled)
        XCTAssertEqual(foundationNotificationCenter.notificationName, notificationName)
    }

    func testPostNotification() {

        sut.postNotificationWithName(notificationName)

        XCTAssertEqual(foundationNotificationCenter.notificationName, notificationName)
    }

    func testObserversAreRemoved() {

        sut.addObserverForName(notificationName, callback: { notification in })
        sut = nil
        XCTAssertTrue(foundationNotificationCenter.removeObserverWasCalledSuccessfully)
    }
}