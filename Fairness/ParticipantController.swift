import Foundation

class ParticipantController: NSObject {

    private let participantStore = ParticipantStore()

    var participantUpdateCallback: (([Participant]) -> ())? {

        didSet {

            sendParticipantUpdate()
        }
    }

    func sendParticipantUpdate() {

        participantUpdateCallback?(participantStore.participants)
    }

    @IBAction func addParticipant() {

        sendParticipantUpdate()
    }

    func applyAmounts(amounts: [Double]) {

        for (participant, amount) in Zip2(participantStore.participants, amounts) {

            participant.balance += amount
        }
    }
}