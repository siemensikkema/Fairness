import Foundation

class ParticipantController: NSObject {

    private var participants: [Participant] = [Participant(name: "Siemen"), Participant(name: "Willem")]

    var participantUpdateCallbackOrNil: (([Participant]) -> ())? {

        didSet {

            sendParticipantUpdate()
        }
    }

    private func sendParticipantUpdate() {

        participantUpdateCallbackOrNil?(participants)
    }

    @IBAction func addParticipant() {

        participants.append(Participant())
        sendParticipantUpdate()
    }

    func applyAmounts(amounts: [Double]) {

        for (participant, amount) in Zip2(participants, amounts) {

            participant.balance += amount
        }
    }
}