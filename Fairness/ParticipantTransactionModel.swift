import Foundation

class ParticipantTransactionModel: DataSourceItem {

    var isPayee: Bool
    var isPayer: Bool
    var amountOrNil: Double?
    var nameOrNil: String? {

        get { return participant.nameOrNil }
        set { participant.nameOrNil = nameOrNil }
    }

    private let participant: Participant

    init(participant: Participant) {

        isPayee = false
        isPayer = false
        self.participant = participant
    }

    func reset() {

        isPayee = false
        isPayer = false
        amountOrNil = nil
    }

    func toViewModel() -> ParticipantTransactionViewModelInterface {

        return ParticipantTransactionViewModel(participantTransactionModel: self)
    }
}

protocol ParticipantTransactionViewModelInterface {

    var amountString: String { get }
    var isPayee: Bool { get }
    var isPayer: Bool { get }
    var nameOrNil: String? { get }
}

struct ParticipantTransactionViewModel: ParticipantTransactionViewModelInterface {

    let amountString: String
    let isPayee: Bool
    let isPayer: Bool
    let nameOrNil: String?

    init(participantTransactionModel: ParticipantTransactionModel) {

        let balanceFormatter = BalanceFormatter.sharedInstance

        amountString = balanceFormatter.stringFromNumber(participantTransactionModel.participant.balance) ?? ""

        if let amount = participantTransactionModel.amountOrNil {

            let transactionAmountString = balanceFormatter.stringFromNumber(amount) ?? ""
            let transactionAmountPrefix = amount > 0 ? "+" : ""
            amountString = "\(amountString) \(transactionAmountPrefix)\(transactionAmountString)"
        }

        isPayee = participantTransactionModel.isPayee
        isPayer = participantTransactionModel.isPayer

        nameOrNil = participantTransactionModel.nameOrNil
    }
}