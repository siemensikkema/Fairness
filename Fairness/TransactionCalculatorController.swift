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

    convenience override init() {

        let participantDataSource = ParticipantDataSource { (participantTransactionModel, cell) in

            cell.configure(participantTransactionViewModel: participantTransactionModel.toViewModel())
        }

        let transactionCalculator = TransactionCalculator { participantTransactionViewModels in

            participantDataSource.items = participantTransactionViewModels
        }

        self.init(participantDataSource: participantDataSource, transactionCalculator: transactionCalculator)
    }

    init(participantDataSource: ParticipantDataSource, transactionCalculator: TransactionCalculator) {

        self.participantDataSource = participantDataSource
        self.transactionCalculator = transactionCalculator
    }

    private func updateTransaction() {

        tableView.reloadData()
        doneBarButtonItem.enabled = transactionCalculator.isValid
    }

    @IBAction func reset() {

        costTextFieldController.reset()
        transactionCalculator.reset()
        tableView.reloadData()
    }
    
    @IBAction func apply() {
        
        transactionCalculator.apply()
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