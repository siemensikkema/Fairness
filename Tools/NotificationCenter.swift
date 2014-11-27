import UIKit

typealias NotificationCallback = NSNotification -> ()
typealias CallbackWithoutNotification = () -> ()

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

    func observeNotificationWithName(name: String, callback: NotificationCallback) {

        observers.append(foundationNotificationCenter.addObserverForName(name, object: nil, queue: nil, usingBlock: { notification in callback(notification) }))
    }

    func postNotificationWithName(name: String) {

        foundationNotificationCenter.postNotificationName(name, object: nil)
    }
}

protocol NotificationEnum {

    var rawValue: String { get }
}

extension NotificationCenter {

    func postNotification(notification: NotificationEnum) {

        postNotificationWithName(notification.rawValue)
    }

    func observeNotification(notification: NotificationEnum, callback: NotificationCallback) {

        observeNotificationWithName(notification.rawValue, callback: callback)
    }
}