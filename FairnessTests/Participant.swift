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

extension Participant: DebugPrintable {

    var debugDescription: String { return "name: \(nameOrNil), balance: \(balance) hash: \(hashValue)" }
}

extension Participant: Hashable, Equatable {

    var hashValue: Int {

        return ObjectIdentifier(self).hashValue
    }
}

func ==(lhs: Participant, rhs: Participant) -> Bool {

    return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
}