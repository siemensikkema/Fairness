import XCTest
import UIKit

class CostTextFieldControllerTests: XCTestCase {

    var sut: CostTextFieldController!
    var textField: UITextField!
    var transactionCalculatorController: TransactionCalculatorControllerForTesting!
    var window: UIWindow!

    override func setUp() {

        sut = CostTextFieldController()
        textField = UITextField()
        sut.costTextField = textField
        transactionCalculatorController = TransactionCalculatorControllerForTesting()
        sut.transactionCalculatorController = transactionCalculatorController

        window = UIWindow()
        window.addSubview(textField)
    }
}

extension CostTextFieldControllerTests {

    func testCostGetSetOnTransactionCalculatorController() {

        let cost = 1.23
        sut.costTextField.text = "\(cost)"
        sut.costDidChange()
        XCTAssertEqual(sut.transactionCalculatorController.cost, cost)
    }

    func testTextFieldIsFirstResponderAfterTransactionDidStart() {

        sut.transactionDidStart()
        XCTAssertTrue(textField.isFirstResponder())
    }

    func testTextFieldIsNotFirstResponderAfterReset() {

        sut.reset()
        XCTAssertFalse(textField.isFirstResponder())
    }

    func testTextFieldUserInteractionIsEnabledAfterTransactionDidStart() {

        sut.transactionDidStart()
        XCTAssertTrue(textField.userInteractionEnabled)
    }

    func testTextFieldUserInteractionIsDisabledAfterReset() {

        sut.reset()
        XCTAssertFalse(textField.userInteractionEnabled)
    }

    func testTextFieldTextIsEmptyAfterReset() {

        sut.reset()
        XCTAssertEqual(textField.text, "")
    }
}