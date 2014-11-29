protocol ParticipantsStoreInterface {

    var participantTransactionModels: [ParticipantTransactionModel] { get }

    func addParticipant()
    func applyAmounts(amounts: [Double])
    func removeParticipantAtIndex(index: Int)
}

class ParticipantsStore: ParticipantsStoreInterface {

    private var participants: [Participant] = []

    var participantTransactionModels: [ParticipantTransactionModel] {

        return participants.map { (participant: Participant) in

            ParticipantTransactionModel(participant: participant)
        }
    }

    convenience init() {

        self.init(participants: ["Siemen", "Shannon"].map { Participant(name: $0) })
    }

    init(participants: [Participant]) {

        self.participants = participants
    }

    func addParticipant() {

        participants.append(Participant())
        // persist
    }

    func applyAmounts(amounts: [Double]) {

        for (participant, amount) in Zip2(participants, amounts) {

            participant.balance += amount
        }
        // persist
    }

    func removeParticipantAtIndex(index: Int) {
        
        participants.removeAtIndex(index)
        // persist
    }
}