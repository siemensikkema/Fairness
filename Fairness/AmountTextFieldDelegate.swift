import UIKit
import Tools


class AmountTextFieldDelegate: NSObject, UITextFieldDelegate {

    var balanceFormatter: BalanceFormatter!

    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {

        let text = textField.text ?? ""

        let changedText = text.stringByReplacingCharactersInRange(range.toRange(text), withString: string)

        let decimalSeparator = balanceFormatter.decimalSeparator!

        let regex = "^(0?(?=(\\\(decimalSeparator)|$))|[1-9][0-9]*?)(\\\(decimalSeparator)\\d{0,2}|$)"

        println(regex)

        if let range = changedText.rangeOfString(regex, options: .RegularExpressionSearch) {

            return range.endIndex == changedText.endIndex
        }

        return false
    }

    func textFieldDidEndEditing(textField: UITextField) {

        textField.text = balanceFormatter.stringFromNumber((textField.text as NSString).doubleValue)
    }
}
