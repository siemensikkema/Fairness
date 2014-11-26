import Foundation

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