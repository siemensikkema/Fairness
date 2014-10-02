import UIKit
import XCTest
import Tools

class TwoParticipantTransactionTests: XCTestCase {

    var participants: [Participant]!

    override func setUp() {

        participants = [Participant(name: ""), Participant(name: "")]
    }
    
    func testSharedPaymentFromA() {

        participants[0].pay(10, forParticipants: participants)
        XCTAssertEqual(participants.map { $0.balance }, [5, -5])
    }

    func testPaymentToSelf() {

        participants[0].pay(10, forParticipants: [participants[0]])
        XCTAssertEqual(participants[0].balance, 0)
    }
}


class AmountEntryTests: XCTestCase {

    var balanceFormatter: BalanceFormatter!
    var textFieldDelegate: TextFieldDelegate!
    var textField: UITextField!

    override func setUp() {

        balanceFormatter = BalanceFormatter()
        balanceFormatter.decimalSeparator = "."

        textFieldDelegate = TextFieldDelegate()
        textFieldDelegate.balanceFormatter = balanceFormatter
        textField = UITextField()
    }

    class TextFieldDelegate: NSObject, UITextFieldDelegate {

        var balanceFormatter: BalanceFormatter!

        func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {

            let text = textField.text ?? ""

            let changedText = text.stringByReplacingCharactersInRange(range.toRange(text), withString: string)

            if let range = changedText.rangeOfString("^(\\.|0(?=\\.)|0(?=$)|[1-9]*)(\\.\\d{0,2}|$)", options: .RegularExpressionSearch) {

                return range.endIndex == changedText.endIndex
            }

            return false
        }

        func textFieldDidEndEditing(textField: UITextField) {

            textField.text = balanceFormatter.stringFromNumber((textField.text as NSString).doubleValue)
        }
    }

    func testEnteringOneDigit() {

        XCTAssertTrue(textFieldDelegate.textField(textField, shouldChangeCharactersInRange: NSRange(location: 0, length: 0), replacementString: "1"))
    }

    func testNumberIsFormattedWhenEditingDidEnd() {

        textField.text = "1"
        textFieldDelegate.textFieldDidEndEditing(textField)
        XCTAssertEqual(textField.text, balanceFormatter.stringFromNumber(1)!)
    }

    func testEnteringSecondFractionalDigitIsAllowed() {

        textField.text = "1.0"
        XCTAssertTrue(textFieldDelegate.textField(textField, shouldChangeCharactersInRange: NSRange(location: 3, length: 0), replacementString: "0"))
    }

    func testEnteringThirdFractionalDigitIsNotAllowed() {

        textField.text = "1.00"
        XCTAssertFalse(textFieldDelegate.textField(textField, shouldChangeCharactersInRange: NSRange(location: 4, length: 0), replacementString: "0"))
    }

    func testZeroFollowedByDigitIsNotAllowed() {

        textField.text = "0"
        XCTAssertFalse(textFieldDelegate.textField(textField, shouldChangeCharactersInRange: NSRange(location: 1, length: 0), replacementString: "1"))
    }

    func testZeroFollowedByDecimalSeparatorIsAllowed() {

        textField.text = "0"
        XCTAssertTrue(textFieldDelegate.textField(textField, shouldChangeCharactersInRange: NSRange(location: 1, length: 0), replacementString: balanceFormatter.decimalSeparator!))
    }

    func testInsertingIllegalMultiCharacterStringIsNotAllowed() {

        textField.text = ""
        XCTAssertFalse(textFieldDelegate.textField(textField, shouldChangeCharactersInRange: NSRange(location: 0, length: 0), replacementString: "01"))
    }
}
