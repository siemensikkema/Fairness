import XCTest
import UIKit

class MainStoryboardTestsBase: XCTestCase {

    let storyboard = UIStoryboard(name: "Main", bundle: NSBundle(forClass: TransactionEntryViewControllerTests.self))

    var costTextFieldController: CostTextFieldController!
    var navigationController: NavigationController!
    var transactionCalculatorController: TransactionCalculatorController!
    var transactionEntryViewController: TransactionEntryViewController!

    override func setUp() {

        navigationController = storyboard.instantiateInitialViewController() as NavigationController
        transactionEntryViewController = navigationController.viewControllers.first as TransactionEntryViewController

        // trigger loadView
        transactionEntryViewController.view.hidden = false

        transactionCalculatorController = transactionEntryViewController.transactionCalculatorController
        costTextFieldController = transactionCalculatorController.costTextFieldController
    }
}

class MainStoryboardTransactionEntryViewControllerTests: MainStoryboardTestsBase {

    var sut: TransactionEntryViewController!

    override func setUp() {

        super.setUp()
        sut = transactionEntryViewController
    }

    func testOutlets() {

        XCTAssertNotNil(sut.costTextField)
        XCTAssertNotNil(sut.accessoryToolbar)
        XCTAssertNotNil(sut.costTextField.delegate)
        XCTAssertNotNil(sut.tableView.delegate)
        XCTAssertNotNil(sut.addParticipantButton)
        XCTAssertNotNil(sut.transactionCalculatorController)
    }
}

class MainStoryboardTransactionCalculatorControllerTests: MainStoryboardTestsBase {

    var sut: TransactionCalculatorController!

    override func setUp() {

        super.setUp()
        sut = transactionEntryViewController.transactionCalculatorController
    }

    func testOutlets() {

        XCTAssertNotNil(sut.costTextFieldController)
        XCTAssertNotNil(sut.doneBarButtonItem)
        XCTAssertNotNil(sut.participantController)
        XCTAssertNotNil(sut.tableView)
        XCTAssertNotNil(sut.tableView.dataSource)
    }
}

class MainStoryboardAccessoryToolbarButtonTests: MainStoryboardTestsBase {

    var toolbarButtons: [UIBarButtonItem]!

    override func setUp() {

        super.setUp()
        toolbarButtons = [0, 2].map { self.transactionEntryViewController.accessoryToolbar.items?[$0] as UIBarButtonItem }
    }

    func testTargets() {

        func testTarget(barButtonItem: UIBarButtonItem) {

            XCTAssertEqual(barButtonItem.target! as TransactionCalculatorController, transactionCalculatorController)
        }

        testTarget(toolbarButtons.first!)
        testTarget(toolbarButtons.last!)
    }

    func testActions() {

        XCTAssertEqual(toolbarButtons.map { $0.action }, ["reset", "apply"])
    }
}

class MainStoryboardCostTextFieldControllerTests: MainStoryboardTestsBase {

    var sut: CostTextFieldController!

    override func setUp() {

        super.setUp()
        sut = transactionCalculatorController.costTextFieldController
    }

    func testCostTextFieldDidChangeTriggersCorrectAction() {

        XCTAssertEqual(sut.costTextField.actionsForTarget(sut, forControlEvent: .EditingChanged)!.first as String, "costDidChange")
    }
}

class MainStoryboardParticipantControllerTests: MainStoryboardTestsBase {

    var sut: ParticipantController!
    var addParticipantButton: UIBarButtonItem!

    override func setUp() {

        super.setUp()
        sut = transactionCalculatorController.participantController as ParticipantController
        addParticipantButton = transactionEntryViewController.addParticipantButton
    }

    func testAddParticipantButtonTarget() {

        XCTAssertEqual(addParticipantButton.target as ParticipantController, sut)
    }

    func testAddParticipantButtonAction() {

        XCTAssertEqual(String(_sel: addParticipantButton.action), "addParticipant")
    }

    func testTableViewOutlet() {

        XCTAssertNotNil(sut.tableView)
    }
}

class MainStoryboardNavigationControllerTests: MainStoryboardTestsBase {

    func testNavigationBarReappearBehaviorHasOutletToNavigationController() {

        XCTAssertEqual(navigationController.navigationBarReappearBehavior.navigationController, navigationController)
    }
}