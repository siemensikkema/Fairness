class Transaction {

    let participantStore = ParticipantStore()

    var cost = 0.0
    var transactionItems = [TransactionItem]()

    var hasPayer: Bool {

        for transactionItem in transactionItems {

            if transactionItem.isPayer { return true }
        }

        return false
    }

    var numberOfParticipants: Int {

        return participantStore.participants.count
    }

    var isValid: Bool {

        return cost > 0 && transactionItems.filter { $0.isPayer || $0.isPayee }.count > 1
    }

    init() {

        resetTransaction()
    }

    func apply() {

        for (index, participant) in enumerate(participantStore.participants) {

            participant.balance += transactionItems[index].amount ?? 0
        }

        resetTransaction()
    }

    func participantViewModelAtIndex(index: Int) -> ParticipantViewModel {

        return ParticipantViewModel(participant: participantStore.participants[index], transactionItem:transactionItems[index])
    }

    func resetTransaction() {

        cost = 0.0
        transactionItems = [TransactionItem](count: numberOfParticipants, repeatedValue: TransactionItem(amount: nil, isPayee: false, isPayer: false))
    }

    func togglePayeeAtIndex(index: Int) {

        transactionItems[index].isPayee = !transactionItems[index].isPayee
    }

    func togglePayerAtIndex(index: Int) {

        transactionItems[index].isPayer = !transactionItems[index].isPayer
    }

    func update() {

        let numberOfPayees = Double(transactionItems.reduce(0) { $0 + ($1.isPayee ? 1 : 0) })

        transactionItems = transactionItems.map { (var transactionItem: TransactionItem) in

            var amount: Double?

            if (!self.isValid) {

                return transactionItem
            }

            if transactionItem.isPayee {

                amount = -self.cost/numberOfPayees
            }

            if transactionItem.isPayer {

                amount = (amount ?? 0) + self.cost
            }

            return TransactionItem(amount: amount, isPayee: transactionItem.isPayee, isPayer: transactionItem.isPayer)
        }
    }
}