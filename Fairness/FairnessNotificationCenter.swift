import UIKit

protocol FairnessNotificationCenter {
    func transactionDidStart()
    func observeTransactionDidStart(callback: CallbackWithoutNotification)
    func transactionDidEnd()
    func observeTransactionDidEnd(callback: CallbackWithoutNotification)
    func observeKeyboardWillHide(callback: CallbackWithoutNotification)
}

extension NotificationCenter: FairnessNotificationCenter {
    private enum FairnessNotification: String, NotificationEnum {
        case TransactionDidEnd = "Transaction Did End"
        case TransactionDidStart = "Transaction Did Start"
    }

    func transactionDidStart() {
        postNotification(FairnessNotification.TransactionDidStart)
    }

    func observeTransactionDidStart(callback: CallbackWithoutNotification) {
        observeNotification(FairnessNotification.TransactionDidStart, { _ in callback() })
    }

    func transactionDidEnd() {
        postNotification(FairnessNotification.TransactionDidEnd)
    }

    func observeTransactionDidEnd(callback: CallbackWithoutNotification) {
        observeNotification(FairnessNotification.TransactionDidEnd, { _ in callback() })
    }

    func observeKeyboardWillHide(callback: CallbackWithoutNotification) {
        observeNotificationWithName(UIKeyboardWillHideNotification, callback: { _ in callback() })
    }
}