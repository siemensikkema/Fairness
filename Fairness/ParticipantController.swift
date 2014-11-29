import UIKit

typealias ParticipantTransactionModelDataSource = TableViewDataSource<ParticipantTransactionModel, ParticipantCell>
typealias ParticipantTransactionModelUpdateCallback = ([ParticipantTransactionModel]) -> ()

@objc protocol ParticipantControllerInterface: class {

    var participantTransactionModelUpdateCallbackOrNil: ParticipantTransactionModelUpdateCallback? { get set }
    func applyAmounts(amounts: [Double])
}

class ParticipantController: NSObject, ParticipantControllerInterface {

    @IBOutlet weak var tableView: UITableView! {

        didSet { tableView.dataSource = participantTransactionModelDataSource.toObjC }
    }

    var participantTransactionModelUpdateCallbackOrNil: ParticipantTransactionModelUpdateCallback? {

        didSet { self.participantsDidUpdate(shouldUpdateDataSource: true) }
    }

    private let participantTransactionModelDataSource = ParticipantTransactionModelDataSource { (participantTransactionModel, cell) in

        cell.configureWithParticipantTransactionViewModel(participantTransactionModel) { name in

            participantTransactionModel.nameOrNil = name
        }
    }

    private var participants: [Participant]
    private var participantTransactionModels: [ParticipantTransactionModel] {

        return participants.map { (participant: Participant) in

            ParticipantTransactionModel(participant: participant)
        }
    }

    override convenience init() {

        self.init(participants: ["Siemen", "Shannon"].map { Participant(name: $0) })
    }

    init(participants: [Participant]) {

        self.participants = participants
        super.init()
        participantTransactionModelDataSource.deletionCallback = { [unowned self] index in

            self.removeParticipantAtIndex(index)
        }
    }

    @IBAction func addParticipant() {

        participants.append(Participant())
        participantsDidUpdate(shouldUpdateDataSource: true)
    }

    func applyAmounts(amounts: [Double]) {

        for (participant, amount) in Zip2(participants, amounts) {

            participant.balance += amount
        }
    }

    private func participantsDidUpdate(#shouldUpdateDataSource: Bool) {

        participantTransactionModelUpdateCallbackOrNil?(participantTransactionModels)
        if shouldUpdateDataSource {

            participantTransactionModelDataSource.items = participantTransactionModels
            tableView?.reloadData()
        }
    }

    private func removeParticipantAtIndex(index: Int) {

        self.participants.removeAtIndex(index)
        participantsDidUpdate(shouldUpdateDataSource: false)
    }
}