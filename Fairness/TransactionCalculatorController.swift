import UIKit

class TransactionCalculatorController: NSObject {

    typealias ParticipantDataSource = TableViewDataSource<ParticipantTransactionModel, ParticipantCell>

    @IBOutlet var costTextFieldController: CostTextFieldController! {

        didSet {

            costTextFieldController.costDidChangeCallback = { [unowned self] cost in

                self.transactionCalculator.cost = cost
                self.updateTransaction()
            }
        }
    }
    @IBOutlet var tableViewDelegateSplitter: TableViewDelegateSplitter!
    @IBOutlet weak var doneBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var participantController: ParticipantController! {

        didSet {

            // TODO: self.tableViewDelegateSplitter.editingDelegate = participantController
            participantController.participantUpdateCallback = { [unowned self] participants in

                let participantTransactionModels = participants.map { (participant: Participant) in

                    ParticipantTransactionModel(participant: participant)
                }
                self.participantDataSource.items = participantTransactionModels
                self.transactionCalculator.participantTransactionModels = participantTransactionModels
            }
        }
    }
    @IBOutlet weak var tableView: UITableView! {

        didSet {

            tableView.dataSource = participantDataSource.toObjC
        }
    }

    private let participantDataSource: ParticipantDataSource
    private let transactionCalculator: TransactionCalculator

    override convenience init() {

        let participantDataSource = ParticipantDataSource { (participantTransactionModel, cell) in

            cell.configure(participantTransactionViewModel: participantTransactionModel.toViewModel())
        }
        self.init(transactionCalculator: TransactionCalculator(), participantDataSource: participantDataSource)
    }

    init(transactionCalculator: TransactionCalculator, participantDataSource: ParticipantDataSource) {

        self.transactionCalculator = transactionCalculator
        self.participantDataSource = participantDataSource
    }

    private func updateTransaction() {

        tableView.reloadData()
        doneBarButtonItem.enabled = transactionCalculator.isValid
    }
}

extension TransactionCalculatorController {

    @IBAction func reset() {

        costTextFieldController.reset()
        transactionCalculator.reset()
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
            costTextFieldController.transactionDidStart()
        }
        
        updateTransaction()
    }
}