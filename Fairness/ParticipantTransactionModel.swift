struct ParticipantTransactionModel {

    var isPayee: Bool
    var isPayer: Bool
    var maybeAmount: Double?

    var amountString: String {

        var amountString = balanceFormatter.stringFromNumber(participant.balance) ?? ""

        if let amount = maybeAmount {

            let transactionAmountString = balanceFormatter.stringFromNumber(amount) ?? ""
            let transactionAmountPrefix = amount > 0 ? "+" : ""
            amountString = "\(amountString) \(transactionAmountPrefix)\(transactionAmountString)"
        }

        return amountString
    }

    var name: String {

        return participant.name
    }

    private let participant: Participant
    private let balanceFormatter = BalanceFormatter.sharedInstance

    init(participant: Participant, amount maybeAmount: Double?, isPayee: Bool, isPayer: Bool) {

        self.isPayee = isPayee
        self.isPayer = isPayer
        self.maybeAmount = maybeAmount
        self.participant = participant
    }
}