import XCTest
import UIKit

class TransactionCalculatorControllerTestsBase: XCTestCase {

    class UITableViewForTesting: UITableView {

        var didCallReloadData = false

        override func reloadData() {

            didCallReloadData = true
        }
    }

    class TransactionCalculatorForTesting: TransactionCalculator {

        var didCallReset = false

        override func reset() {

            didCallReset = true
        }

        var didCallApply = false

        override func apply() {

            didCallApply = true
        }

        override var isValid: Bool {
            
            return true
        }

        var hasPayerForTesting = false

        override var hasPayer: Bool {

            return hasPayerForTesting
        }

        var payerIndexForTesting: Int?

        override func togglePayerAtIndex(index: Int) {

            payerIndexForTesting = index
        }

        var payeeIndexForTesting: Int?

        override func togglePayeeAtIndex(index: Int) {

            payeeIndexForTesting = index
        }

        init() {

            super.init(modelDidBecomeInvalidCallback: { a in }, participantStore: ParticipantStore(participants: []))
        }
    }

    class CostTextFieldControllerForTesting: CostTextFieldController {

        var didCallReset = false

        override func reset() {

            didCallReset = true
        }

        var didCallTransactionDidStart = false

        override func transactionDidStart() {

            didCallTransactionDidStart = true
        }
    }

    var costTextFieldController: CostTextFieldControllerForTesting!
    var doneBarButtonItem: UIBarButtonItem!
    var participantDataSource: TransactionCalculatorController.ParticipantDataSource!
    var sut: TransactionCalculatorController!
    var tableView: UITableViewForTesting!
    var transactionCalculator: TransactionCalculatorForTesting!

    override func setUp() {

        participantDataSource = TransactionCalculatorController.ParticipantDataSource { (a, b) in }
        transactionCalculator = TransactionCalculatorForTesting()

        costTextFieldController = CostTextFieldControllerForTesting()
        doneBarButtonItem = UIBarButtonItem()
        tableView = UITableViewForTesting()

        sut = TransactionCalculatorController(participantDataSource: participantDataSource, transactionCalculator: transactionCalculator)
        sut.costTextFieldController = costTextFieldController
        sut.doneBarButtonItem = doneBarButtonItem
        sut.tableView = tableView
    }
}

class TransactionCalculatorControllerTests: TransactionCalculatorControllerTestsBase {

    func testTableViewDataSourceIsSet() {

        XCTAssertNotNil(sut.tableView.dataSource)
    }

    func testApplyCallsApplyOnTransactionCalculator() {

        sut.apply()
        XCTAssertTrue(transactionCalculator.didCallApply)
    }
}

class TransactionCalculatorControllerCostChangeTests: TransactionCalculatorControllerTestsBase {

    override func setUp() {

        super.setUp()
        doneBarButtonItem.enabled = false
        sut.cost = 1
    }

    func testCostIsSetOnTransactionCalculator() {

        XCTAssertEqual(transactionCalculator.cost, sut.cost)
    }

    func testTableViewIsReloaded() {

        XCTAssertTrue(tableView.didCallReloadData)
    }

    func testDoneBarButtonItemIsEnabledWhenTransactionIsValid() {

        XCTAssertTrue(doneBarButtonItem.enabled)
    }
}

class TransactionCalculatorControllerResetTests: TransactionCalculatorControllerTestsBase {

    override func setUp() {

        super.setUp()
        sut.reset()
    }

    func testTableViewIsReloaded() {

        XCTAssertTrue(tableView.didCallReloadData)
    }

    func testCostTextFieldControllerIsReset() {

        XCTAssertTrue(costTextFieldController.didCallReset)
    }

    func testTransactionCalculatorIsReset() {

        XCTAssertTrue(transactionCalculator.didCallReset)
    }
}

class TransactionCalculatorControllerRowSelectionTests: TransactionCalculatorControllerTestsBase {

    override func setUp() {

        super.setUp()
        sut.tableView(tableView, didSelectRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 0))
    }

    func testPayerIsSetWhenTransactionCalculatorDoesNotHaveAPayer() {

        XCTAssertEqual(transactionCalculator.payerIndexForTesting!, 0)
    }

    func testPayeeIsSetWhenTransactionCalculatorHasAPayer() {

        transactionCalculator.hasPayerForTesting = true
        sut.tableView(tableView, didSelectRowAtIndexPath: NSIndexPath(forRow: 1, inSection: 0))
        XCTAssertEqual(transactionCalculator.payeeIndexForTesting!, 1)
    }

    func testTransactionDidStartIsCalledWhenTransactionCalculatorHasAPayer() {

        XCTAssertTrue(costTextFieldController.didCallTransactionDidStart)
    }

    func testTableViewIsReloaded() {

        XCTAssertTrue(tableView.didCallReloadData)
    }

    func testDoneBarButtonItemIsEnabledWhenTransactionIsValid() {

        XCTAssertTrue(doneBarButtonItem.enabled)
    }
}