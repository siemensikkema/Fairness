class Transaction {

    let participantStore = ParticipantStore()

    var cost: Double = 0.0 {

        didSet { update() }
    }

    var participantTransactionModels = [ParticipantTransactionModel]()

    var hasPayer: Bool {

        for participantViewModel in participantTransactionModels {

            if participantViewModel.isPayer { return true }
        }

        return false
    }

    var isValid: Bool {

        return cost > 0 && participantTransactionModels.filter { $0.isPayer || $0.isPayee }.count > 1
    }

    init() {

        reset()
    }

    func apply() {

        for (index, participant) in enumerate(participantStore.participants) {

            participant.balance += participantTransactionModels[index].maybeAmount ?? 0
        }

        reset()
    }

    func reset() {

        cost = 0.0

        participantTransactionModels = participantStore.participants.map { (participant: Participant) in

            ParticipantTransactionModel(participant: participant, amount: nil, isPayee: false, isPayer: false)
        }
    }

    func togglePayeeAtIndex(index: Int) {

        participantTransactionModels[index].isPayee = !participantTransactionModels[index].isPayee
        update()
    }

    func togglePayerAtIndex(index: Int) {

        participantTransactionModels[index].isPayer = !participantTransactionModels[index].isPayer
        update()
    }

    private func update() {

        let numberOfPayees = Double(participantTransactionModels.reduce(0) { $0 + ($1.isPayee ? 1 : 0) })

        for index in 0..<participantTransactionModels.count {

            var maybeAmount: Double?

            if (self.isValid) {

                let participantTransactionModel = participantTransactionModels[index]

                if participantTransactionModel.isPayee {

                    maybeAmount = -self.cost/numberOfPayees
                }

                if participantTransactionModel.isPayer {

                    maybeAmount = (maybeAmount ?? 0) + self.cost
                }

            }

            participantTransactionModels[index].maybeAmount = maybeAmount
        }
    }
}