
protocol FairnessNotificationCenter {

    func transactionDidStart()
    func observeTransactionDidStart(callback: NotificationCenter.CallbackWithoutNotification)
    func transactionDidEnd()
    func observeTransactionDidEnd(callback: NotificationCenter.CallbackWithoutNotification)
}

extension NotificationCenter: FairnessNotificationCenter {

    typealias CallbackWithoutNotification = () -> ()

    private enum FairnessNotification: String {

        case TransactionDidEnd = "Transaction Did End"
        case TransactionDidStart = "Transaction Did Start"
    }

    private func postFairnessNotification(fairnessNotification: FairnessNotification) {

        postNotificationWithName(fairnessNotification.rawValue)
    }

    private func observeFairnessNotification(fairnessNotification: FairnessNotification, callback: NotificationCallback) {

        addObserverForName(fairnessNotification.rawValue, callback: callback)
    }

    func transactionDidStart() {

        postFairnessNotification(.TransactionDidStart)
    }

    func observeTransactionDidStart(callback: CallbackWithoutNotification) {

        observeFairnessNotification(.TransactionDidStart, { _ in callback() })
    }

    func transactionDidEnd() {

        postFairnessNotification(.TransactionDidEnd)
    }

    func observeTransactionDidEnd(callback: CallbackWithoutNotification) {

        observeFairnessNotification(.TransactionDidEnd, { _ in callback() })
    }
}