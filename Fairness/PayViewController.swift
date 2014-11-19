import UIKit

class CostTextFieldController: NSObject {

    @IBOutlet weak var costTextField: UITextField!
    @IBOutlet weak var transactionController: TransactionController!

    @IBAction func costDidChange() {

        transactionController.cost = (costTextField.text as NSString).doubleValue
    }

    func transactionDidStart() {

        costTextField.userInteractionEnabled = true
        costTextField.becomeFirstResponder()
    }

    func reset() {

        costTextField.userInteractionEnabled = false
        costTextField.resignFirstResponder()
        costTextField.text = ""
    }
}

class TransactionController: NSObject, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var costTextFieldController: CostTextFieldController!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var doneBarButtonItem: UIBarButtonItem!

    private let transaction = Transaction()

    var cost: Double = 0.0 {

        didSet {

            transaction.cost = cost
            updateTransaction()
        }
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return transaction.numberOfParticipants
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier("Participant", forIndexPath: indexPath) as ParticipantCell

        cell.configure(participantViewModel: transaction.participantViewModelAtIndex(indexPath.row))

        return cell
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

        transaction.update()
        tableView.reloadData()
        self.doneBarButtonItem.enabled = transaction.isValid
    }

    @IBAction func reset() {

        costTextFieldController.reset()
        transaction.reset()
        tableView.reloadData()
    }

    @IBAction func apply() {

        transaction.apply()
        reset()
    }
}

class PayViewController: UITableViewController {

    @IBOutlet var accessoryToolbar: UIToolbar!
    @IBOutlet weak var costTextField: UITextField!

    override func viewDidLoad() {

        super.viewDidLoad()
        costTextField.inputAccessoryView = accessoryToolbar
    }
}