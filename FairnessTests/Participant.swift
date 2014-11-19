import UIKit

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