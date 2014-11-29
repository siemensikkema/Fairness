import UIKit

typealias ParticipantTransactionModelDataSource = TableViewDataSource<ParticipantTransactionModel, ParticipantCell>

typealias ParticipantTransactionModelUpdateCallback = ([ParticipantTransactionModel]) -> ()

@objc protocol ParticipantsControllerInterface: class {

    var participantTransactionModelUpdateCallbackOrNil: ParticipantTransactionModelUpdateCallback? { get set }
    func applyAmounts(amounts: [Double])
}

class ParticipantsController: NSObject, ParticipantsControllerInterface {

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

    private let participantsStore: ParticipantsStoreInterface

    override convenience init() {

        self.init(participantsStore: ParticipantsStore())
    }

    init(participantsStore: ParticipantsStoreInterface) {

        self.participantsStore = participantsStore

        super.init()

        participantTransactionModelDataSource.deletionCallback = { [unowned self] index in

            participantsStore.removeParticipantAtIndex(index)
            self.participantsDidUpdate(shouldUpdateDataSource: false)
        }
    }

    @IBAction func addParticipant() {

        participantsStore.addParticipant()
        participantsDidUpdate(shouldUpdateDataSource: true)
    }

    func applyAmounts(amounts: [Double]) {

        participantsStore.applyAmounts(amounts)
    }

    private func participantsDidUpdate(#shouldUpdateDataSource: Bool) {

        let participantTransactionModels = participantsStore.participantTransactionModels
        participantTransactionModelUpdateCallbackOrNil?(participantTransactionModels)
        if shouldUpdateDataSource {

            participantTransactionModelDataSource.items = participantTransactionModels
            tableView?.reloadData()
        }
    }
}