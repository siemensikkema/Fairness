protocol ParticipantsStoreInterface {

    var participantTransactionModels: [ParticipantTransactionModel] { get }

    func addParticipant()
    func applyAmounts(amounts: [Double])
    func removeParticipantAtIndex(index: Int)
}

class ParticipantsStore: ParticipantsStoreInterface {

    private var participants: [Participant] = []

    var participantTransactionModels: [ParticipantTransactionModel] {

        return participants.map { ParticipantTransactionModel(participant: $0) }
    }

    convenience init() {

        self.init(participants: ["EP", "Marco", "Daan", "Niels", "Stijn", "Siemen", "Sander", "Elwin"].map { Participant(name: $0) })
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