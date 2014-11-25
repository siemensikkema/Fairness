import UIKit

class Participant {

    var balance = 0.0
    var name: String?

    convenience init(name: String) {

        self.init()
        self.name = name
    }

    init() {}
}

extension Participant: Hashable, Equatable {

    var hashValue: Int {

        return balance.hashValue ^ (name?.hashValue ?? 0)
    }
}

func ==(lhs: Participant, rhs: Participant) -> Bool {

    return lhs.name == rhs.name && lhs.balance == rhs.balance
}