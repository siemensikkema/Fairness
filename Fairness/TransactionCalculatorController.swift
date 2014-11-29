import UIKit

class TransactionCalculatorController: NSObject {

    @IBOutlet var costTextFieldController: CostTextFieldController! {

        didSet {

            costTextFieldController.costDidChangeCallbackOrNil = { [unowned self] cost in

                self.transactionCalculator.cost = cost
                self.updateTransaction()
            }
        }
    }
    @IBOutlet weak var doneBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var participantController: ParticipantControllerInterface! {

        didSet {

            participantController.participantTransactionModelUpdateCallbackOrNil = { participantTransactionModels in

                self.transactionCalculator.participantTransactionModels = participantTransactionModels
            }
        }
    }
    @IBOutlet weak var tableView: UITableView!

    private let notificationCenter: FairnessNotificationCenter
    private let transactionCalculator: TransactionCalculatorInterface

    override convenience init() {

        self.init(notificationCenter: NotificationCenter(), transactionCalculator: TransactionCalculator())
    }

    init(notificationCenter: FairnessNotificationCenter, transactionCalculator: TransactionCalculatorInterface) {

        self.notificationCenter = notificationCenter
        self.transactionCalculator = transactionCalculator
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

extension TransactionCalculatorController: UITableViewDelegate {

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