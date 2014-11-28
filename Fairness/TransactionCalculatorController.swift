import UIKit

typealias ParticipantDataSource = TableViewDataSource<ParticipantTransactionModel, ParticipantCell>

class TransactionCalculatorController: NSObject {

    @IBOutlet var costTextFieldController: CostTextFieldController! {

        didSet {

            costTextFieldController.costDidChangeCallbackOrNil = { [unowned self] cost in

                self.transactionCalculator.cost = cost
                self.updateTransaction()
            }
        }
    }
    @IBOutlet var tableViewDelegateSplitter: TableViewDelegateSplitter!
    @IBOutlet weak var doneBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var participantController: ParticipantControllerInterface! {

        didSet {

            participantController.participantUpdateCallbackOrNil = { [unowned self] participants in

                let participantTransactionModels = participants.map { (participant: Participant) in

                    ParticipantTransactionModel(participant: participant)
                }
                self.participantDataSource.items = participantTransactionModels
                self.transactionCalculator.participantTransactionModels = participantTransactionModels
                // the tableView outlet is not guaranteed to be set at this stage, hence the '?'
                self.tableView?.reloadData()
            }
        }
    }
    @IBOutlet weak var tableView: UITableView! {

        didSet {

            tableView.dataSource = participantDataSource.toObjC
        }
    }

    private let participantDataSource: ParticipantDataSource
    private let transactionCalculator: TransactionCalculatorInterface
    private let notificationCenter: FairnessNotificationCenter

    override convenience init() {

        let participantDataSource = ParticipantDataSource { (participantTransactionModel, cell) in

            cell.configureWithParticipantTransactionViewModel(participantTransactionModel) { name in

                participantTransactionModel.nameOrNil = name
            }
        }
        self.init(notificationCenter: NotificationCenter(), participantDataSource: participantDataSource, transactionCalculator: TransactionCalculator())
    }

    init(notificationCenter: FairnessNotificationCenter, participantDataSource: ParticipantDataSource, transactionCalculator: TransactionCalculatorInterface) {

        self.notificationCenter = notificationCenter
        self.participantDataSource = participantDataSource
        self.transactionCalculator = transactionCalculator

        super.init()
        
        participantDataSource.deletionCallback = { index in

            self.participantController.deleteParticipantAtIndex(index)
        }
    }

    private func updateTransaction() {

        tableView.reloadData()
        doneBarButtonItem.enabled = transactionCalculator.isValid
    }
}

extension TransactionCalculatorController {

    @IBAction func reset() {

        notificationCenter.transactionDidEnd()
        tableView.reloadData()
    }

    @IBAction func apply() {

        participantController.applyAmounts(transactionCalculator.amounts)
        reset()
    }
}

extension TransactionCalculatorController: TableViewSelectionDelegate {

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        let index = indexPath.row

        if transactionCalculator.hasPayer {

            transactionCalculator.togglePayeeAtIndex(index)
        }
        else {
            
            transactionCalculator.togglePayerAtIndex(index)
            notificationCenter.transactionDidStart()
        }
        
        updateTransaction()
    }
}