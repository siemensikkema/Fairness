import UIKit


struct TransactionItem  {

    var amount = 0.0
    var isPayee, isPayer: Bool
}


struct ParticipantViewModel {

    let amountString: String
    let balanceString: String
    let name: String
    let isPayee, isPayer: Bool


    private let balanceFormatter = BalanceFormatter.sharedInstance


    init(participant: Participant, transactionItem: TransactionItem) {

        amountString = balanceFormatter.stringFromNumber(transactionItem.amount) ?? ""
        balanceString = balanceFormatter.stringFromNumber(participant.balance) ?? ""
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