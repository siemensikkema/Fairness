class FairnessNotificationCenterForTesting: FairnessNotificationCenter {
    var didCallTransactionDidEnd = false
    var didCallTransactionDidStart = false

    var keyboardWillHideCallback: CallbackWithoutNotification?
    var transactionDidEndCallback: CallbackWithoutNotification?
    var transactionDidStartCallback: CallbackWithoutNotification?

    init() {}

    func transactionDidEnd() {
        didCallTransactionDidEnd = true
    }

    func transactionDidStart() {
        didCallTransactionDidStart = true
    }

    func observeTransactionDidEnd(callback: CallbackWithoutNotification) {
        transactionDidEndCallback = callback
    }

    func observeTransactionDidStart(callback: CallbackWithoutNotification) {
        transactionDidStartCallback = callback
    }

    func observeKeyboardWillHide(callback: CallbackWithoutNotification) {
        keyboardWillHideCallback = callback
    }
}