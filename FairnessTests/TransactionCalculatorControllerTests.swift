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
        var didCallAmounts = false
        var didSetCost = false
        var hasPayerForTesting = false
        var payerIndexForTesting: Int?
        var payeeIndexForTesting: Int?

        override var amounts: [Double] {

            didCallAmounts = true
            return []
        }

        override var cost: Double {

            didSet { didSetCost = true }
        }

        override var isValid: Bool {
            
            return true
        }

        override var hasPayer: Bool {

            return hasPayerForTesting
        }

        override func reset() {

            didCallReset = true
        }
        
        override func togglePayerAtIndex(index: Int) {

            payerIndexForTesting = index
        }

        override func togglePayeeAtIndex(index: Int) {

            payeeIndexForTesting = index
        }
    }

    class CostTextFieldControllerForTesting: CostTextFieldController {

        var didCallReset = false
        var didCallTransactionDidStart = false

        override func reset() {

            didCallReset = true
        }

        override func transactionDidStart() {

            didCallTransactionDidStart = true
        }
    }

    class ParticipantControllerForTesting: ParticipantController {

        var didCallApplyAmounts = false

        override func applyAmounts(amounts: [Double]) {

            didCallApplyAmounts = true
        }
    }

    var costTextFieldController: CostTextFieldControllerForTesting!
    var doneBarButtonItem: UIBarButtonItem!
    var participantDataSource: TransactionCalculatorController.ParticipantDataSource!
    var participantController: ParticipantControllerForTesting!
    var sut: TransactionCalculatorController!
    var tableView: UITableViewForTesting!
    var transactionCalculator: TransactionCalculatorForTesting!

    override func setUp() {

        participantDataSource = TransactionCalculatorController.ParticipantDataSource { (a, b) in }
        transactionCalculator = TransactionCalculatorForTesting()

        costTextFieldController = CostTextFieldControllerForTesting()
        doneBarButtonItem = UIBarButtonItem()
        participantController = ParticipantControllerForTesting()
        tableView = UITableViewForTesting()

        sut = TransactionCalculatorController()
        sut.costTextFieldController = costTextFieldController

        sut.participantDataSource = participantDataSource
        sut.transactionCalculator = transactionCalculator

        sut.doneBarButtonItem = doneBarButtonItem
        sut.participantController = participantController
        sut.tableView = tableView
    }
}

class TransactionCalculatorControllerTests: TransactionCalculatorControllerTestsBase {

    func testTableViewDataSourceIsSet() {

        XCTAssertNotNil(sut.tableView.dataSource)
    }
}

class TransactionCalculatorControllerApplyTests: TransactionCalculatorControllerTestsBase {

    override func setUp() {

        super.setUp()
        sut.apply()
    }

    func testCallsAmountsOnTransactionCalculator() {

        XCTAssertTrue(transactionCalculator.didCallAmounts)
    }

    func testCallsApplyAmountsOnParticipantController() {

        XCTAssertTrue(participantController.didCallApplyAmounts)
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

class TransactionCalculatorControllerAwakeFromNibTestsBase: TransactionCalculatorControllerTestsBase {

    override func setUp() {

        super.setUp()
        sut.participantDataSource = nil
        sut.transactionCalculator = nil
        sut.awakeFromNib()
    }
}

class TransactionCalculatorControllerAwakeFromNibTests: TransactionCalculatorControllerAwakeFromNibTestsBase {

    func testTransactionCalculatorIsSet() {

        XCTAssertNotNil(sut.transactionCalculator)
    }

    func testParticipantDataSourceIsSet() {

        XCTAssertNotNil(sut.participantDataSource)
    }
}

class TransactionCalculatorControllerCostDidChangeTests: TransactionCalculatorControllerAwakeFromNibTestsBase {

    override func setUp() {

        super.setUp()
        doneBarButtonItem.enabled = false
        sut.transactionCalculator = transactionCalculator
        costTextFieldController.costDidChangeCallback!(1)
    }

    func testTableViewIsReloaded() {

        XCTAssertTrue(tableView.didCallReloadData)
    }

    func testDoneBarButtonItemIsEnabledWhenTransactionIsValid() {


        XCTAssertTrue(doneBarButtonItem.enabled)
    }

    func testCostIsSetOnTransactionCalculator() {

        XCTAssertTrue(transactionCalculator.didSetCost)
    }
}

class TransactionCalculatorControllerParticipantUpdateCallbackTests: TransactionCalculatorControllerAwakeFromNibTestsBase {

    override func setUp() {

        super.setUp()
        let participants = ["name1", "name2"].map { Participant(name: $0) }
        participantController.participantUpdateCallback!(participants)
    }

    func testParticipantTransactionModelsAreSetOnParticipantDataSource() {

        XCTAssertEqual(sut.participantDataSource.items.count, 2)
    }

    func testParticipantTransactionModelsAreSetOnTransactionCalculator() {

        XCTAssertEqual(sut.transactionCalculator.participantTransactionModels.count, 2)
    }
}