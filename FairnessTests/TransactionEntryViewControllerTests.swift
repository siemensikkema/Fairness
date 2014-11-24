import XCTest
import UIKit

class TransactionEntryViewControllerTests: XCTestCase {

    let storyboard = UIStoryboard(name: "Main", bundle: NSBundle(forClass: TransactionEntryViewControllerTests.self))

    var costTextFieldController: CostTextFieldController!
    var costTextFieldDelegate: CostTextFieldDelegate!
    var sut: TransactionEntryViewController!
    var transactionCalculatorController: TransactionCalculatorController!
    var costTextField: UITextField!

    override func setUp() {

        let navigationController = storyboard.instantiateInitialViewController() as UINavigationController
        sut = navigationController.viewControllers.first as TransactionEntryViewController
        sut.view.hidden = false

        costTextFieldDelegate = sut.costTextField.delegate as CostTextFieldDelegate
        let tableViewDelegate = sut.tableView.delegate as TableViewDelegateSplitter
        transactionCalculatorController = tableViewDelegate.selectionDelegate as TransactionCalculatorController
        costTextFieldController = transactionCalculatorController.costTextFieldController
        costTextField = sut.costTextField
    }
}

extension TransactionEntryViewControllerTests {

    func testCostTextFieldInputAccessoryViewIsSet() {

        XCTAssertEqual(sut.costTextField.inputAccessoryView!, sut.accessoryToolbar)
    }

    func testCostTextFieldDelegateIsSet() {

        XCTAssertNotNil(costTextFieldDelegate)
    }

    func testTableViewDelegateIsSet() {

        XCTAssertNotNil(transactionCalculatorController)
    }

    func testCostTextFieldControllerIsSet() {

        XCTAssertNotNil(costTextFieldController)
    }

    func testTransactionControllerIsSetOnCostTextFieldController() {

        XCTAssertNotNil(costTextFieldController.transactionCalculatorController)
    }

    func testTableViewIsSetOnTransactionCalculatorController() {

        XCTAssertNotNil(transactionCalculatorController.tableView)
    }

    func testDoneBarButtonItemIsSetOnTransactionCalculatorController() {

        XCTAssertNotNil(transactionCalculatorController.doneBarButtonItem)
    }

    func testCostTextFieldIsSetOnCostTextFieldController() {

        XCTAssertNotNil(costTextFieldController.costTextField)
    }

    func testCostTextFieldDidChangeTriggersCorrectAction() {

        XCTAssertEqual(costTextField.actionsForTarget(costTextFieldController, forControlEvent: .EditingChanged)!.first as String, "costDidChange")
    }

    func testToolbarButtonActions() {

        let actionForAccessoryToolbarButtonWithIndex = { (index: Int) -> String in

            return String(_sel: (self.sut.accessoryToolbar.items?[index] as UIBarButtonItem).action)
        }

        XCTAssertEqual([0,2].map { actionForAccessoryToolbarButtonWithIndex($0) }, ["reset", "apply"])
    }
}

extension TransactionEntryViewControllerTests {

    func testEditButtonExists() {

        XCTAssertEqual(sut.navigationItem.rightBarButtonItem!, sut.editButtonItem())
    }

    func testAddParticipantButtonExists() {

        XCTAssertNotNil(sut.addParticipantButton)
    }

    func testLeftBarButtonItemIsEmptyWhenNotInEditMode() {

        sut.editing = false
        XCTAssertNil(sut.navigationItem.leftBarButtonItem)
    }

    func testAddParticipantButtonIsAddedToNavigationItemWhenInEditMode() {

        sut.editing = true
        XCTAssertEqual(sut.navigationItem.leftBarButtonItem!, sut.addParticipantButton)
    }

    func testAddParticipantButtonHasCorrectAction() {

        XCTAssertEqual(String(_sel: sut.addParticipantButton.action), "addParticipant")
    }
}