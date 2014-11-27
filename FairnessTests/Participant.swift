import UIKit

class Participant {

    var balance = 0.0
    var nameOrNil: String?

    convenience init(name: String) {

        self.init()
        nameOrNil = name
    }

    init() {}
}

extension Participant: Hashable, Equatable {

    var hashValue: Int {

        return balance.hashValue ^ (nameOrNil?.hashValue ?? 0)
    }
}

func ==(lhs: Participant, rhs: Participant) -> Bool {

    return lhs.nameOrNil == rhs.nameOrNil && lhs.balance == rhs.balance
}