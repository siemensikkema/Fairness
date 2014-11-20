import UIKit

class TransactionEntryViewController: UITableViewController {

    @IBOutlet var accessoryToolbar: UIToolbar!
    @IBOutlet weak var costTextField: UITextField!

    override func viewDidLoad() {

        super.viewDidLoad()
        costTextField.inputAccessoryView = accessoryToolbar
    }
}