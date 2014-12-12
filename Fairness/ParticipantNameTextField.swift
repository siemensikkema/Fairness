import UIKit

class ParticipantNameTextField: UITextField {
    func enableEditing(editing: Bool) {
        userInteractionEnabled = editing
        borderStyle = editing ? .RoundedRect : .None
    }
}