import Foundation

protocol ParticipantsStoreInterface {
    var participantTransactionModels: [ParticipantTransactionModel] { get }

    func addParticipant()
    func applyAmounts(amounts: [Double])
    func removeParticipantAtIndex(index: Int)
}

class ParticipantsStore: ParticipantsStoreInterface {
    private let balancesKey = "balances"
    private let namesKey = "names"
    private let userDefaults = NSUserDefaults.standardUserDefaults()
    private var participants: [Participant]

    var participantTransactionModels: [ParticipantTransactionModel] {
        return participants.map { ParticipantTransactionModel(participant: $0) }
    }

    convenience init() {
        self.init(participants: [])

        // untested
        let names = userDefaults.stringArrayForKey(namesKey) as? [String] ?? []
        let balances = userDefaults.arrayForKey(balancesKey) as? [Double] ?? []

        participants = Array(Zip2(names, balances)).map {
            Participant(name: $0.0, nameChangeCallback: { self.persist() }, balance: $0.1)
        }
    }

    init(participants: [Participant]) {
        self.participants = participants
    }

    func addParticipant() {
        participants.append(Participant(nameChangeCallback: { self.persist() }))
    }

    func applyAmounts(amounts: [Double]) {
        for (participant, amount) in Zip2(participants, amounts) {
            participant.balance += amount
        }
        // untested
        persist()
    }

    func removeParticipantAtIndex(index: Int) {
        participants.removeAtIndex(index)
        // untested
        persist()
    }

    // untested
    func persist() {
        let namedParticipants = participants.filter { $0.nameOrNil != nil }

        userDefaults.setObject(namedParticipants.map { $0.balance }, forKey: balancesKey)
        userDefaults.setObject(namedParticipants.map { $0.nameOrNil! }, forKey: namesKey)
        userDefaults.synchronize()
    }
}