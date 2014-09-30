import UIKit


private let sharedBalanceFormatter = BalanceFormatter()


class BalanceFormatter: NSNumberFormatter {

    class var sharedInstance: BalanceFormatter {

        return sharedBalanceFormatter
    }

    override init() {

        super.init()
        numberStyle = .CurrencyStyle
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class ParticipantViewModel {

    let name: String
    let balanceString: String
    let balanceFormatter = BalanceFormatter.sharedInstance


    init(participant: Participant) {

        name = participant.name
        balanceString = balanceFormatter.stringFromNumber(participant.balance)!
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
