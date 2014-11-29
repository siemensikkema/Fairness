import Foundation

protocol ParticipantTransactionViewModelInterface {

    var amountString: String { get }
    var isPayee: Bool { get }
    var isPayer: Bool { get }
    var nameOrNil: String? { get }
}

class ParticipantTransactionModel: DataSourceItem, ParticipantTransactionViewModelInterface {

    let balanceFormatter = BalanceFormatter.sharedInstance

    var isPayee: Bool
    var isPayer: Bool
    var amountOrNil: Double?
    var amountString: String {

        var amountString = balanceFormatter.stringFromNumber(participant.balance) ?? ""

        if let amount = amountOrNil {

            let transactionAmountString = balanceFormatter.stringFromNumber(amount) ?? ""
            let transactionAmountPrefix = amount > 0 ? "+" : ""
            amountString = "\(amountString) \(transactionAmountPrefix)\(transactionAmountString)"
        }

        return amountString
    }

    var nameOrNil: String? {

        get { return participant.nameOrNil }
        set { participant.nameOrNil = newValue }
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
}

extension ParticipantTransactionModel: DebugPrintable {

    var debugDescription: String { return "name: \(nameOrNil), amount: \(amountOrNil), id: \(ObjectIdentifier(self).hashValue)" }
}