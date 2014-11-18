import UIKit
import XCTest
import Tools

class AmountEntryTests: XCTestCase {

    var balanceFormatter: BalanceFormatter!
    var amountTextFieldDelegate: AmountTextFieldDelegate!
    var textField: UITextField!

    override func setUp() {

        balanceFormatter = BalanceFormatter()
        balanceFormatter.decimalSeparator = "."

        amountTextFieldDelegate = AmountTextFieldDelegate()
        amountTextFieldDelegate.balanceFormatter = balanceFormatter
        textField = UITextField()
    }

    // MARK: Helper methods

    func fillInString(string: String, atLocation location: Int) -> Bool {

        return amountTextFieldDelegate.textField(textField, shouldChangeCharactersInRange: NSRange(location: location, length: 0), replacementString: string)
    }

    // MARK: Tests

    func testEnteringOneDigit() {

        XCTAssertTrue(fillInString("1", atLocation: 0))
    }

    func testNumberIsFormattedWhenEditingDidEnd() {

        textField.text = "1"
        amountTextFieldDelegate.textFieldDidEndEditing(textField)
        XCTAssertEqual(textField.text, balanceFormatter.stringFromNumber(1)!)
    }

    func testEnteringSecondFractionalDigitIsAllowed() {

        textField.text = "1.0"
        XCTAssertTrue(fillInString("0", atLocation: 3))
    }

    func testEnteringThirdFractionalDigitIsNotAllowed() {

        textField.text = "1.00"
        XCTAssertFalse(fillInString("0", atLocation: 4))
    }

    func testZeroFollowedByDigitIsNotAllowed() {

        textField.text = "0"
        XCTAssertFalse(fillInString("1", atLocation: 1))
    }

    func testZeroFollowedByDecimalSeparatorIsAllowed() {

        textField.text = "0"
        XCTAssertTrue(fillInString(balanceFormatter.decimalSeparator!, atLocation: 1))
    }

    func testInsertingIllegalMultiCharacterStringIsNotAllowed() {

        textField.text = ""
        XCTAssertFalse(fillInString("01", atLocation: 0))
    }

    func testNumberWithZeroFollowingFirstCharacterIsAllowed() {

        textField.text = ""
        XCTAssertTrue(fillInString("10", atLocation: 0))
    }

    func testDecimalSeparatorFromBalanceFormatterIsUsed() {

        balanceFormatter.decimalSeparator = ";"
        XCTAssertTrue(fillInString(";1", atLocation: 0))
    }
}
