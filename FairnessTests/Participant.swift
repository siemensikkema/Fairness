import UIKit

class Participant {

    var balance = 0.0
    var name: String

    init(name: String) {

        self.name = name
    }
}

extension Participant: Hashable, Equatable {

    var hashValue: Int {

        return balance.hashValue ^ name.hashValue
    }
}

func ==(lhs: Participant, rhs: Participant) -> Bool {

    return lhs.name == rhs.name && lhs.balance == rhs.balance
}