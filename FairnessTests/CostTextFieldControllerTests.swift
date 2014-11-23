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

class CostTextFieldControllerCostDidChangeTests: CostTextFieldControllerTests {

    func testCostGetSetOnTransactionCalculatorController() {

        let cost = 1.23
        textField.text = "\(cost)"
        sut.costDidChange()
        XCTAssertEqual(sut.transactionCalculatorController.cost, cost)
    }
}

class CostTextFieldControllerTransactionDidStartTests: CostTextFieldControllerTests {

    override func setUp() {

        super.setUp()
        sut.transactionDidStart()
    }

    func testTextFieldIsFirstResponder() {

        XCTAssertTrue(textField.isFirstResponder())
    }

    func testTextFieldUserInteractionIsEnabled() {

        XCTAssertTrue(textField.userInteractionEnabled)
    }
}

class CostTextFieldControllerTransactionDidResetTests: CostTextFieldControllerTests {

    override func setUp() {

        super.setUp()
        sut.reset()
    }

    func testTextFieldIsNotFirstResponder() {

        XCTAssertFalse(textField.isFirstResponder())
    }

    func testTextFieldUserInteractionIsDisabled() {

        XCTAssertFalse(textField.userInteractionEnabled)
    }

    func testTextFieldTextIsEmpty() {

        XCTAssertEqual(textField.text, "")
    }
}