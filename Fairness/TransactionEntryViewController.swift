import UIKit

class TransactionEntryViewController: UITableViewController {

    @IBOutlet var accessoryToolbar: UIToolbar!
    @IBOutlet var addParticipantButton: UIBarButtonItem!
    @IBOutlet weak var costTextField: UITextField!

    override func viewDidLoad() {

        super.viewDidLoad()
        costTextField.inputAccessoryView = accessoryToolbar
        navigationItem.rightBarButtonItem = editButtonItem()
    }

    override func setEditing(editing: Bool, animated: Bool) {

        super.setEditing(editing, animated: animated)
        navigationItem.leftBarButtonItem = editing ? addParticipantButton : nil
    }

    @IBAction func addParticipant() {


    }
}