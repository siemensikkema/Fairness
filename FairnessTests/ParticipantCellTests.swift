import XCTest
import UIKit

class ParticipantCellTests: XCTestCase {

    class TextEditControllerForTesting: NSObject, TextEditControllerInterface {

        var textField: UITextField!
        var textChangeCallback: TextChangeCallback!

        func configureWithTextField(textField: UITextField, textChangeCallback: TextChangeCallback) {

            self.textField = textField
            self.textChangeCallback = textChangeCallback
        }
    }

    class ParticipantTransactionViewModelForTesting: ParticipantTransactionViewModelInterface {

        var amountString: String { return "amount" }
        var isPayee: Bool = false
        var isPayer: Bool = false
        var nameOrNil: String? { return "name" }
    }

    var amountLabel: UILabel!
    var nameTextField: UITextField!
    var sut: ParticipantCell!
    let participantTransactionViewModel = ParticipantTransactionViewModelForTesting()

    var textEditController: TextEditControllerForTesting!

    override func setUp() {

        amountLabel = UILabel()
        nameTextField = UITextField()
        textEditController = TextEditControllerForTesting()

        sut = ParticipantCell(style: .Default, reuseIdentifier: ParticipantCell.reuseIdentifier(), textEditController: textEditController)
        sut.amountLabel = amountLabel
        sut.nameTextField = nameTextField

        sut.configureWithParticipantTransactionViewModel(participantTransactionViewModel, textChangeCallback: { _ in })
    }

    func testReuseIdentifier() {

        XCTAssertEqual(ParticipantCell.reuseIdentifier(), "Participant")
    }

    func testAmountLabelTextGetsSet() {

        XCTAssertEqual(amountLabel.text!, participantTransactionViewModel.amountString)
    }

    func testNameTextFieldTextGetsSet() {

        XCTAssertEqual(nameTextField.text!, participantTransactionViewModel.nameOrNil!)
    }

    func testTextEditControllerGetsSet() {

        XCTAssertNotNil(sut.textEditController)
    }

    func testTextEditorGetsConfiguredWithTextFieldAndCallback() {

        XCTAssertEqual(textEditController.textField, nameTextField)
        XCTAssertFalse(textEditController.textChangeCallback == nil)
    }

    func testBackgroundColorIsWhiteForNonPayees() {

        XCTAssertEqual(sut.backgroundColor!, UIColor.whiteColor())
    }

    func testBackgroundColorIsGreenForPayees() {

        participantTransactionViewModel.isPayee = true
        sut.configureWithParticipantTransactionViewModel(participantTransactionViewModel, textChangeCallback: { _ in })
        XCTAssertEqual(sut.backgroundColor!, UIColor.greenColor())
    }

    func testBorderIsAbsentForNonPayers() {

        XCTAssertEqual(sut.layer.borderWidth, 0 as CGFloat)
    }

    func testBorderIsPresentForPayers() {

        participantTransactionViewModel.isPayer = true
        sut.configureWithParticipantTransactionViewModel(participantTransactionViewModel, textChangeCallback: { _ in })
        XCTAssertEqual(sut.layer.borderWidth, 1 as CGFloat)
    }
}