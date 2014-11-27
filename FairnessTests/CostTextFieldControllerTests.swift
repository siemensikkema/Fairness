import XCTest
import UIKit

class CostTextFieldControllerTestsBase: XCTestCase {

    var notificationCenter: FairnessNotificationCenterForTesting!
    var sut: CostTextFieldController!
    var costTextField: UITextField!
    var window: UIWindow!

    override func setUp() {

        notificationCenter = FairnessNotificationCenterForTesting()
        costTextField = UITextField()

        sut = CostTextFieldController(notificationCenter: notificationCenter)
        sut.costTextField = costTextField

        // textField must be added to a window in order for isFirstResponder() to work
        window = UIWindow()
        window.addSubview(costTextField)
    }
}

class CostTextFieldControllerTests: CostTextFieldControllerTestsBase {

    func testCostGetSetOnTransactionCalculatorController() {

        let cost = 1.23
        costTextField.text = "\(cost)"

        sut.costDidChangeCallbackOrNil = { costFromCallback in

            XCTAssertEqual(costFromCallback, cost)
        }
        sut.costDidChange()
    }
}

class CostTextFieldControllerTransactionDidStartTests: CostTextFieldControllerTestsBase {

    override func setUp() {

        super.setUp()
        notificationCenter.transactionDidStartCallback?()
    }

    func testTextFieldIsFirstResponder() {

        XCTAssertTrue(costTextField.isFirstResponder())
    }

    func testTextFieldUserInteractionIsEnabled() {

        XCTAssertTrue(costTextField.userInteractionEnabled)
    }
}

class CostTextFieldControllerTransactionDidResetTests: CostTextFieldControllerTestsBase {

    override func setUp() {

        super.setUp()
        costTextField.text = "1"
        notificationCenter.transactionDidEndCallback?()
    }

    func testTextFieldIsNotFirstResponder() {

        XCTAssertFalse(costTextField.isFirstResponder())
    }

    func testTextFieldUserInteractionIsDisabled() {

        XCTAssertFalse(costTextField.userInteractionEnabled)
    }

    func testTextFieldTextIsEmpty() {

        XCTAssertEqual(costTextField.text, "")
    }
}