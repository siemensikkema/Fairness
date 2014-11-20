import UIKit

class TransactionCalculatorController: NSObject {

    typealias ParticipantDataSource = TableViewDataSource<ParticipantTransactionModel, ParticipantCell>

    @IBOutlet weak var costTextFieldController: CostTextFieldController!
    @IBOutlet weak var doneBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView! {

        didSet { tableView.dataSource = participantDataSource.toObjC }
    }

    private let participantDataSource: ParticipantDataSource
    private let transactionCalculator: TransactionCalculator

    var cost: Double = 0.0 {

        didSet {

            transactionCalculator.cost = cost
            updateTransaction()
        }
    }

    override init() {

        let dataSource = ParticipantDataSource { (participantTransactionModel, cell) in

            cell.configure(participantTransactionViewModel: participantTransactionModel.toViewModel())
        }

        transactionCalculator = TransactionCalculator { participantTransactionViewModels in

            dataSource.items = participantTransactionViewModels
        }

        participantDataSource = dataSource
    }

    private func updateTransaction() {

        tableView.reloadData()
        doneBarButtonItem.enabled = transactionCalculator.isValid
    }

    @IBAction func reset() {

        costTextFieldController.reset()
        transactionCalculator.reset()
        participantDataSource.items = transactionCalculator.participantTransactionModels
        tableView.reloadData()
    }
    
    @IBAction func apply() {
        
        transactionCalculator.apply()
        reset()
    }
}

extension TransactionCalculatorController: UITableViewDelegate {

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        let index = indexPath.row

        if !transactionCalculator.hasPayer {

            transactionCalculator.togglePayerAtIndex(index)
            costTextFieldController.transactionDidStart()
        }
        else {

            transactionCalculator.togglePayeeAtIndex(index)
        }
        
        updateTransaction()
    }
}