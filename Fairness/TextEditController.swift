import UIKit

typealias TextChangeCallback = (String) -> ()

protocol TextEditControllerInterface: UITextFieldDelegate {

    func configureWithTextField(textField: UITextField, textChangeCallback: TextChangeCallback)
}

class TextEditController: NSObject, TextEditControllerInterface {

    private var textChangeCallbackOrNil: TextChangeCallback!

    func configureWithTextField(textField: UITextField, textChangeCallback: TextChangeCallback) {

        self.textChangeCallbackOrNil = textChangeCallback

        if (textField.text == "") {

            textField.delegate = self
            textField.becomeFirstResponder()
        }
    }

    func textFieldDidEndEditing(textField: UITextField) {

        textChangeCallbackOrNil(textField.text)
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {

        textField.resignFirstResponder()
        return false
    }
}
