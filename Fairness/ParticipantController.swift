import Foundation

class ParticipantController: NSObject {

    private var participants: [Participant] = [Participant(name: "Siemen"), Participant(name: "Willem")]

    var participantUpdateCallback: (([Participant]) -> ())? {

        didSet {

            sendParticipantUpdate()
        }
    }

    private func sendParticipantUpdate() {

        participantUpdateCallback?(participants)
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