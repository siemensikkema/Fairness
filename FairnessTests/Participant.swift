import UIKit

struct TransactionItem  {

    let amount: Double?
    var isPayee, isPayer: Bool
}

struct ParticipantViewModel {

    let amountString: String
    let name: String
    let isPayee, isPayer: Bool

    private let balanceFormatter = BalanceFormatter.sharedInstance

    init(participant: Participant, transactionItem: TransactionItem) {

        amountString = balanceFormatter.stringFromNumber(participant.balance) ?? ""

        if let amount = transactionItem.amount {

            let transactionAmountString = balanceFormatter.stringFromNumber(amount) ?? ""
            let transactionAmountPrefix = amount > 0 ? "+" : ""
            amountString = "\(amountString) \(transactionAmountPrefix)\(transactionAmountString)"
        }

        name = participant.name
        isPayee = transactionItem.isPayee
        isPayer = transactionItem.isPayer
    }
}

class Participant {

    var balance = 0.0
    var name: String

    init(name: String) {

        self.name = name
    }
}

extension Participant: Hashable {

    var hashValue: Int {

        return balance.hashValue ^ name.hashValue
    }
}

extension Participant: Equatable {}

func ==(lhs: Participant, rhs: Participant) -> Bool {

    return lhs.hashValue == rhs.hashValue
}