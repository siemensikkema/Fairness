import UIKit

class ParticipantNameTextField: UITextField {

    override func becomeFirstResponder() -> Bool {

        userInteractionEnabled = true
        borderStyle = .RoundedRect
        return super.becomeFirstResponder()
    }

    override func resignFirstResponder() -> Bool {

        userInteractionEnabled = false
        borderStyle = .None
        return super.resignFirstResponder()
    }
}