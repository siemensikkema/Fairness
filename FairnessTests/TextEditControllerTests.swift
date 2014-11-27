import XCTest
import UIKit

class TextEditControllerTests: XCTestCase {

    class UITextFieldForTesting: UITextField {

        var didCallBecomeFirstResponder = false
        var didCallResignFirstResponder = false

        override func becomeFirstResponder() -> Bool {

            didCallBecomeFirstResponder = true
            return true
        }

        override func resignFirstResponder() -> Bool {

            didCallResignFirstResponder = true
            return true
        }
    }

    var sut: TextEditController!
    var textField: UITextFieldForTesting!
    var textChangeCallback: TextChangeCallback!
    var text = ""

    override func setUp() {

        textField = UITextFieldForTesting()
        textChangeCallback = { text in self.text = text }
        sut = TextEditController()
        sut.configureWithTextField(textField, textChangeCallback: textChangeCallback)
    }

    func testTextFieldBecomesFirstResponder() {

        XCTAssertTrue(textField.didCallBecomeFirstResponder)
    }

    func testTextFieldResignsFirstResponderAfterReturn() {

        XCTAssertFalse(sut.textFieldShouldReturn(textField))
        XCTAssertTrue(textField.didCallResignFirstResponder)
    }

    func testCallbackIsCalledWithChangedText() {

        textField.text = "changed"
        sut.textFieldDidEndEditing(textField)
        XCTAssertEqual(text, textField.text)
    }
}