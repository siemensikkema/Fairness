import UIKit

class TransactionEntryViewController: UITableViewController {

    @IBOutlet var addParticipantButton: UIBarButtonItem!
    // the transactionCalculatorController outlet is used for access in tests
    @IBOutlet var transactionCalculatorController: TransactionCalculatorController!
    @IBOutlet weak var accessoryToolbar: UIToolbar!
    @IBOutlet weak var costTextField: UITextField!

    override func viewDidLoad() {

        super.viewDidLoad()

        navigationItem.leftBarButtonItem = editButtonItem()
        costTextField.inputAccessoryView = accessoryToolbar
    }

    override func setEditing(editing: Bool, animated: Bool) {

        super.setEditing(editing, animated: animated)
        navigationItem.rightBarButtonItem = editing ? addParticipantButton : nil
    }
}