import Foundation

class ParticipantTransactionModel: DataSourceItem {

    var isPayee: Bool
    var isPayer: Bool
    var maybeAmount: Double?

    private let participant: Participant

    init(participant: Participant) {

        isPayee = false
        isPayer = false
        self.participant = participant
    }

    func reset() {

        isPayee = false
        isPayer = false
        maybeAmount = nil
    }

    func toViewModel() -> ParticipantTransactionViewModel {

        return ParticipantTransactionViewModel(participantTransactionModel: self)
    }
}

struct ParticipantTransactionViewModel {

    let amountString: String
    let isPayee: Bool
    let isPayer: Bool
    let name: String

    init(participantTransactionModel: ParticipantTransactionModel) {

        let balanceFormatter = BalanceFormatter.sharedInstance

        amountString = balanceFormatter.stringFromNumber(participantTransactionModel.participant.balance) ?? ""

        if let amount = participantTransactionModel.maybeAmount {

            let transactionAmountString = balanceFormatter.stringFromNumber(amount) ?? ""
            let transactionAmountPrefix = amount > 0 ? "+" : ""
            amountString = "\(amountString) \(transactionAmountPrefix)\(transactionAmountString)"
        }

        isPayee = participantTransactionModel.isPayee
        isPayer = participantTransactionModel.isPayer

        name = participantTransactionModel.participant.name
    }
}