import UIKit

class CostTextFieldController: NSObject {
    @IBOutlet weak var costTextField: UITextField!

    var costDidChangeCallbackOrNil: ((Double) -> ())?
    private let notificationCenter: FairnessNotificationCenter

    override convenience init() {
        self.init(notificationCenter: NotificationCenter())
    }

    init(notificationCenter: FairnessNotificationCenter) {
        self.notificationCenter = notificationCenter
        super.init()
        notificationCenter.observeTransactionDidStart {
            self.costTextField.userInteractionEnabled = true
            self.costTextField.becomeFirstResponder()
        }
        notificationCenter.observeTransactionDidEnd {
            self.costTextField.userInteractionEnabled = false
            self.costTextField.resignFirstResponder()
            self.costTextField.text = ""
        }
    }

    @IBAction func costDidChange() {
        // untested
        let balanceFormatter = BalanceFormatter.sharedInstance
        balanceFormatter.numberFromString(costTextField.text)
        let cost = balanceFormatter.numberFromString(costTextField.text)?.doubleValue

        costDidChangeCallbackOrNil?(cost ?? 0)
    }
}