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

        override func togglePayerAtIndex(index: Int) {

            payerIndexForTesting = index
        }

        override func togglePayeeAtIndex(index: Int) {

            payeeIndexForTesting = index
        }
    }

    class ParticipantControllerForTesting: ParticipantController {

        var didCallApplyAmounts = false

        override func applyAmounts(amounts: [Double]) {

            didCallApplyAmounts = true
        }
    }

    var costTextFieldController: CostTextFieldController!
    var doneBarButtonItem: UIBarButtonItem!
    var notificationCenter: FairnessNotificationCenterForTesting!
    var participantDataSource: TransactionCalculatorController.ParticipantDataSource!
    var participantController: ParticipantControllerForTesting!
    var sut: TransactionCalculatorController!
    var tableView: UITableViewForTesting!
    var transactionCalculator: TransactionCalculatorForTesting!

    override func setUp() {

        participantDataSource = TransactionCalculatorController.ParticipantDataSource { (a, b) in }
        transactionCalculator = TransactionCalculatorForTesting()

        costTextFieldController = CostTextFieldController()
        doneBarButtonItem = UIBarButtonItem()
        notificationCenter = FairnessNotificationCenterForTesting()
        participantController = ParticipantControllerForTesting()
        tableView = UITableViewForTesting()

        sut = TransactionCalculatorController(notificationCenter: notificationCenter, participantDataSource: participantDataSource, transactionCalculator: transactionCalculator)

        sut.costTextFieldController = costTextFieldController
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

    func testTransactionWasEnded() {

        XCTAssertTrue(notificationCenter.didCallTransactionDidEnd)
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

    func testTransactionWasEnded() {

        XCTAssertTrue(notificationCenter.didCallTransactionDidEnd)
    }
}

class TransactionCalculatorControllerCostDidChangeTests: TransactionCalculatorControllerTestsBase {

    override func setUp() {

        super.setUp()
        doneBarButtonItem.enabled = false
        costTextFieldController.costDidChangeCallbackOrNil!(1)
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

class TransactionCalculatorControllerParticipantUpdateCallbackTests: TransactionCalculatorControllerTestsBase {

    override func setUp() {

        super.setUp()
        let participants = ["name1", "name2"].map { Participant(name: $0) }
        participantController.participantUpdateCallbackOrNil!(participants)
    }

    func testParticipantTransactionModelsAreSetOnParticipantDataSource() {

        XCTAssertEqual(participantDataSource.items.count, 2)
    }

    func testParticipantTransactionModelsAreSetOnTransactionCalculator() {

        XCTAssertEqual(transactionCalculator.participantTransactionModels.count, 2)
    }

    func testTableViewIsReloaded() {

        XCTAssertTrue(tableView.didCallReloadData)
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

        XCTAssertTrue(notificationCenter.didCallTransactionDidStart)
    }

    func testTableViewIsReloaded() {

        XCTAssertTrue(tableView.didCallReloadData)
    }

    func testDoneBarButtonItemIsEnabledWhenTransactionIsValid() {

        XCTAssertTrue(doneBarButtonItem.enabled)
    }
}