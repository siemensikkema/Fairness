import UIKit
import Tools

class CostTextFieldDelegate: NSObject, UITextFieldDelegate {

    private var balanceFormatter: BalanceFormatter = BalanceFormatter()

    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {

        let text = textField.text ?? ""

        // compute the result of the pending change
        let changedText = text.stringByReplacingCharactersInRange(range.toRange(text), withString: string)

        // set up the regular expression for checking valid entries
        let decimalSeparator = balanceFormatter.decimalSeparator!
        let regex = "^(0?(?=(\\\(decimalSeparator)|$))|[1-9][0-9]*?)(\\\(decimalSeparator)\\d{0,2}|$)"

        // determine whether the pending change is valid
        if let range = changedText.rangeOfString(regex, options: .RegularExpressionSearch) {

            return range.endIndex == changedText.endIndex
        }

        return false
    }

    func textFieldDidEndEditing(textField: UITextField) {

        // format the amount when editing did end
        textField.text = balanceFormatter.stringFromNumber((textField.text as NSString).doubleValue)
    }
}

extension CostTextFieldDelegate {

    convenience init(balanceFormatter: BalanceFormatter) {

        self.init()
        self.balanceFormatter = balanceFormatter
    }
}