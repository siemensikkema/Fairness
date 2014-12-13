import UIKit

typealias NameChangeCallback = () -> ()

class Participant {
    var balance = 0.0
    var nameOrNil: String? {
        didSet {
            nameChangeCallback?()
        }
    }

    var nameChangeCallback: NameChangeCallback?

    init(name: String? = nil, nameChangeCallback: NameChangeCallback? = nil, balance: Double = 0.0) {
        self.balance = balance
        self.nameOrNil = name
        self.nameChangeCallback = nameChangeCallback
    }
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