import UIKit

class PayViewController: UITableViewController {

    let transaction = Transaction()

    @IBOutlet var accessoryToolbar: UIToolbar!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var doneBarButtonItem: UIBarButtonItem!

    func updateTransaction() {

        transaction.update()
        tableView.reloadData()
        self.doneBarButtonItem.enabled = transaction.isValid
    }

    func reset() {

        amountTextField.resignFirstResponder()
        amountTextField.text = ""
        transaction.resetTransaction()
        tableView.reloadData()
    }

    // MARK: UIViewController

    override func viewDidLoad() {

        super.viewDidLoad()

        amountTextField.inputAccessoryView = accessoryToolbar
    }

    // MARK: UITableViewDataSource

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return transaction.numberOfParticipants
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier("Participant", forIndexPath: indexPath) as ParticipantCell

        cell.configure(participantViewModel: transaction.participantViewModelAtIndex(indexPath.row))

        return cell
    }

    // MARK: UITableViewDelegate

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        let index = indexPath.row

        if !transaction.hasPayer {

            transaction.togglePayerAtIndex(index)
            amountTextField.userInteractionEnabled = true
            amountTextField.becomeFirstResponder()
        }
        else {

            transaction.togglePayeeAtIndex(index)
        }

        updateTransaction()
    }

    // MARK: Actions

    @IBAction func amountDidChange() {

        transaction.cost = (amountTextField.text as NSString).doubleValue
        updateTransaction()
    }

    @IBAction func didTapCancelButton(sender: AnyObject) {

        reset()
    }

    @IBAction func didTapDoneButton(sender: AnyObject) {

        transaction.apply()
        reset()
    }
}