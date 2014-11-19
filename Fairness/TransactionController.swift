import UIKit

class TransactionController: NSObject, UITableViewDelegate {

    typealias ParticipantDataSource = TableViewDataSource<ParticipantTransactionModel, ParticipantCell>

    @IBOutlet weak var costTextFieldController: CostTextFieldController!
    @IBOutlet weak var doneBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView! {

        didSet {

            tableView.dataSource = participantDataSource.toObjC
        }
    }

    let participantDataSource: ParticipantDataSource

    private let transaction = Transaction()

    override init() {

        participantDataSource = ParticipantDataSource { (participantTransactionModel, cell) in

            cell.configure(participantTransactionViewModel: participantTransactionModel.toViewModel())
        }

        participantDataSource.items = transaction.participantTransactionModels
    }

    var cost: Double = 0.0 {

        didSet {

            transaction.cost = cost
            updateTransaction()
        }
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        let index = indexPath.row

        if !transaction.hasPayer {

            transaction.togglePayerAtIndex(index)
            costTextFieldController.transactionDidStart()
        }
        else {

            transaction.togglePayeeAtIndex(index)
        }

        updateTransaction()
    }

    private func updateTransaction() {

        tableView.reloadData()
        doneBarButtonItem.enabled = transaction.isValid
    }

    @IBAction func reset() {

        costTextFieldController.reset()
        transaction.reset()
        participantDataSource.items = transaction.participantTransactionModels
        tableView.reloadData()
    }
    
    @IBAction func apply() {
        
        transaction.apply()
        reset()
    }
}