import UIKit


enum TransactionStatusType {

    case None
    case Payee
    case Payer
    // TODO: is something like NS_OPTIONS appropriate here? http://natecook.com/blog/2014/07/swift-options-bitmask-generator/
    case PayerSharingCost
}


struct ParticipantViewModel {

    let amountString: String
    let balanceString: String
    let name: String
    let transactionStatus: TransactionStatusType = .None


    private let balanceFormatter = BalanceFormatter.sharedInstance


    init(participant: Participant, amount: Double, transactionStatus: TransactionStatusType) {

        amountString = balanceFormatter.stringFromNumber(amount) ?? ""
        balanceString = balanceFormatter.stringFromNumber(participant.balance) ?? ""
        name = participant.name
        self.transactionStatus = transactionStatus
    }
}


class Participant {

    var balance = 0.0
    var name: String

    
    init(name: String) {

        self.name = name
    }
}


// MARK: Hashable

extension Participant: Hashable {

    var hashValue: Int {

        return balance.hashValue ^ name.hashValue
    }
}


// MARK: Equatable

extension Participant: Equatable {}

func ==(lhs: Participant, rhs: Participant) -> Bool {

    return lhs.hashValue == rhs.hashValue
}
