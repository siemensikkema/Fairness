import UIKit

class TransactionViewController: UITableViewController {

    @IBOutlet var accessoryToolbar: UIToolbar!
    @IBOutlet weak var costTextField: UITextField!

    override func viewDidLoad() {

        super.viewDidLoad()
        costTextField.inputAccessoryView = accessoryToolbar
    }
}