import UIKit

class CostTextFieldController: NSObject {

    @IBOutlet weak var costTextField: UITextField!

    var costDidChangeCallback: ((Double) -> ())?
    let notificationCenter: FairnessNotificationCenter

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

        costDidChangeCallback?((costTextField.text as NSString).doubleValue)
    }
}