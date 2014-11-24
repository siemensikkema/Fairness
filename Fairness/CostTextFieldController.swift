import UIKit

class CostTextFieldController: NSObject {

    @IBOutlet weak var costTextField: UITextField!

    var costDidChangeCallback: ((Double) -> ())?

    @IBAction func costDidChange() {

        costDidChangeCallback?((costTextField.text as NSString).doubleValue)
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