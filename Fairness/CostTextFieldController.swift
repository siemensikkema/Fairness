import UIKit

class CostTextFieldController: NSObject {

    @IBOutlet weak var costTextField: UITextField!
    @IBOutlet weak var transactionCalculatorController: TransactionCalculatorController!

    @IBAction func costDidChange() {

        transactionCalculatorController.cost = (costTextField.text as NSString).doubleValue
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