class FairnessNotificationCenterForTesting: FairnessNotificationCenter {

    var didCallTransactionDidEnd = false
    var didCallTransactionDidStart = false

    var transactionDidEndCallback: NotificationCenter.CallbackWithoutNotification?
    var transactionDidStartCallback: NotificationCenter.CallbackWithoutNotification?

    init() {}

    func transactionDidEnd() {

        didCallTransactionDidEnd = true
    }

    func transactionDidStart() {

        didCallTransactionDidStart = true
    }

    func observeTransactionDidEnd(callback: NotificationCenter.CallbackWithoutNotification) {

        transactionDidEndCallback = callback
    }

    func observeTransactionDidStart(callback: NotificationCenter.CallbackWithoutNotification) {

        transactionDidStartCallback = callback
    }
}