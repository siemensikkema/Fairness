import Foundation

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