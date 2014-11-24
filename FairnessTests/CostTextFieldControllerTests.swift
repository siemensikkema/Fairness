import XCTest
import UIKit

class CostTextFieldControllerTestsBase: XCTestCase {

    var sut: CostTextFieldController!
    var textField: UITextField!
    var window: UIWindow!

    override func setUp() {

        sut = CostTextFieldController()
        textField = UITextField()
        sut.costTextField = textField

        // textField must be added to a window in order for isFirstResponder() to work
        window = UIWindow()
        window.addSubview(textField)
    }
}

class CostTextFieldControllerTests: CostTextFieldControllerTestsBase {

    func testCostGetSetOnTransactionCalculatorController() {

        let cost = 1.23
        textField.text = "\(cost)"

        sut.costDidChangeCallback = { costFromCallback in

            XCTAssertEqual(costFromCallback, cost)
        }
        sut.costDidChange()
    }
}

class CostTextFieldControllerTransactionDidStartTests: CostTextFieldControllerTestsBase {

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

class CostTextFieldControllerTransactionDidResetTests: CostTextFieldControllerTestsBase {

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