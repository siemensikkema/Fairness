import UIKit

class TransactionCalculatorController: NSObject {

    typealias ParticipantDataSource = TableViewDataSource<ParticipantTransactionModel, ParticipantCell>

    @IBOutlet var costTextFieldController: CostTextFieldController!
    @IBOutlet var tableViewDelegateSplitter: TableViewDelegateSplitter!
    @IBOutlet weak var doneBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var participantController: ParticipantController!
    @IBOutlet weak var tableView: UITableView! {

        didSet {

            tableView.dataSource = participantDataSource.toObjC
        }
    }

    var participantDataSource: ParticipantDataSource!
    var transactionCalculator: TransactionCalculator!

    override func awakeFromNib() {

        super.awakeFromNib()

        transactionCalculator = TransactionCalculator()
        participantDataSource = ParticipantDataSource { (participantTransactionModel, cell) in

            cell.configure(participantTransactionViewModel: participantTransactionModel.toViewModel())
        }

        // TODO: self.tableViewDelegateSplitter.editingDelegate = participantController
        participantController.participantUpdateCallback = { [unowned self] participants in

            let participantTransactionModels = participants.map { (participant: Participant) in

                ParticipantTransactionModel(participant: participant)
            }
            self.participantDataSource.items = participantTransactionModels
            self.transactionCalculator.participantTransactionModels = participantTransactionModels
        }

        costTextFieldController.costDidChangeCallback = { [unowned self] cost in

            self.transactionCalculator.cost = cost
            self.updateTransaction()
        }
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