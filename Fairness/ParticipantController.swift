import Foundation

typealias ParticipantUpdateCallback = ([Participant]) -> ()

@objc protocol ParticipantControllerInterface: class {

    var participantUpdateCallbackOrNil: ParticipantUpdateCallback? { get set }
    func applyAmounts(amounts: [Double])
    func deleteParticipantAtIndex(index: Int)
}

class ParticipantController: NSObject, ParticipantControllerInterface {

    private var participants: [Participant] = [Participant(name: "Siemen"), Participant(name: "Willem")]

    var participantUpdateCallbackOrNil: ParticipantUpdateCallback? {

        didSet { sendParticipantUpdate() }
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

    func deleteParticipantAtIndex(index: Int) {

        participants.removeAtIndex(index)
    }
}