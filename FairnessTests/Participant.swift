import UIKit


class ParticipantViewModel {

    let amountString: String
    let balanceString: String
    let name: String

    private let balanceFormatter = BalanceFormatter.sharedInstance

    init(participant: Participant, amount: Double) {

        amountString = balanceFormatter.stringFromNumber(amount)!
        balanceString = balanceFormatter.stringFromNumber(participant.balance)!
        name = participant.name
    }
}

class Participant {

    var balance = 0.0
    var name: String

    
    init(name: String) {

        self.name = name
    }

    func pay(amount: Double, forParticipants participants: [Participant]) {

        balance += amount
        let amountPerParticipant = amount/Double(participants.count)
        participants.map { $0.balance -= amountPerParticipant }
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
